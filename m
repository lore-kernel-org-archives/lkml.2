Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0KNFH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:07:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49930 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0KNFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:07:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
In-Reply-To: <20101111043541.GA4588@google.com>
References: <20101111043541.GA4588@google.com>
Message-Id: <20101111161905.2068.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:07:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mandeep,

> For ChromiumOS, we'd like to be able to oom_adj a process up/down
> as its leaves/enters the foreground. Currently, it is not possible
> to oom_adj down without CAP_SYS_RESOURCE. This patch creates a new
> resource limit, RLIMIT_OOMADJ, which is works in a similar fashion
> to RLIMIT_NICE. This allows a process's oom_adj to be lowered
> without CAP_SYS_RESOURCE as long as the new value is greater
> than the resource limit.
> 
> Alternative considered:
> 
> * a setuid binary
> * a daemon with CAP_SYS_RESOURCE
> 
> Since you don't wan't all processes to be able to reduce their
> oom_adj, a setuid or daemon implementation would be complex. The
> alternatives also have much higher overhead.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> ---
>  fs/proc/base.c                 |   12 ++++++++++--
>  include/asm-generic/resource.h |    5 ++++-
>  2 files changed, 14 insertions(+), 3 deletions(-)

This concept sound useful for embedeed. but I dislike this interface
a bit. Why don't you create /proc/{pid}/oom_adj_lower_bound or similar? 
It is more straight forward because oom_adj are already using /proc.

I also think 15..-17 to 0-32 convertion is a bit user unfriendly.


> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f3d02ca..4384013 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -462,6 +462,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
>  	[RLIMIT_NICE] = {"Max nice priority", NULL},
>  	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
>  	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> +	[RLIMIT_OOMADJ] = {"Max OOM adjust", NULL},
>  };
>  
>  /* Display limits for a process */
> @@ -1057,8 +1058,15 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
>  	}
>  
>  	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
> -		err = -EACCES;
> -		goto err_sighand;
> +		/* convert oom_adj [15,-17] to rlimit style value [1,33] */
> +		long oom_rlim = OOM_ADJUST_MAX + 1 - oom_adjust;
> +
> +		if (oom_rlim > task->signal->rlim[RLIMIT_OOMADJ].rlim_cur) {

two points.

1) task->signal->rlim[RLIMIT_OOMADJ].rlim_cur is incorrect.
   please use task_rlimit().

2) If process has CAP_SYS_RESOURCE, we should ignore RLIMIT_OOMADJ for
   backword compatibility. CAP_NICE do so. (see below)

------------------------------------------------------------------
int can_nice(const struct task_struct *p, const int nice)
{
        /* convert nice value [19,-20] to rlimit style value [1,40] */
        int nice_rlim = 20 - nice;

        return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
                capable(CAP_SYS_NICE));
}
------------------------------------------------------------------



> +			unlock_task_sighand(task, &flags);
> +			put_task_struct(task);
> +			err = -EACCES;
> +			goto err_sighand;
> +		}
>  	}
>  
>  	if (oom_adjust != task->signal->oom_adj) {
> diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
> index 587566f..a8640a4 100644
> --- a/include/asm-generic/resource.h
> +++ b/include/asm-generic/resource.h
> @@ -45,7 +45,9 @@
>  					   0-39 for nice level 19 .. -20 */
>  #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
>  #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
> -#define RLIM_NLIMITS		16
> +#define RLIMIT_OOMADJ		16	/* max oom_adj allowed to lower to
> +					   0-32 for oom level 15 .. -17 */
> +#define RLIM_NLIMITS		17
>  
>  /*
>   * SuS says limits have to be unsigned.
> @@ -86,6 +88,7 @@
>  	[RLIMIT_MSGQUEUE]	= {   MQ_BYTES_MAX,   MQ_BYTES_MAX },	\
>  	[RLIMIT_NICE]		= { 0, 0 },				\
>  	[RLIMIT_RTPRIO]		= { 0, 0 },				\
> +	[RLIMIT_OOMADJ]		= { 0, 0 },				\

I don't think 0 is good initial value because 0 mean oom_adj==15.



>  	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
>  }
>  
> -- 
> 1.7.3.1
> 




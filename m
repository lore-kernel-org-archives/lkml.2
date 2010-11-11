Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab0KKHgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:36:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab0KKHf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tbOzAw6iTWRGK/LcIjuZ7vrsrVtY03A6G5ykJO+qJf1CV8UxR+2hbRZBU166vgmbwF
         z62eETdUe6fmBW6YxR/w==
Date: Wed, 10 Nov 2010 23:35:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
In-Reply-To: <20101111043541.GA4588@google.com>
Message-ID: <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com>
References: <20101111043541.GA4588@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Mandeep Singh Baines wrote:

> For ChromiumOS, we'd like to be able to oom_adj a process up/down
> as its leaves/enters the foreground. Currently, it is not possible
> to oom_adj down without CAP_SYS_RESOURCE. This patch creates a new
> resource limit, RLIMIT_OOMADJ, which is works in a similar fashion
> to RLIMIT_NICE. This allows a process's oom_adj to be lowered
> without CAP_SYS_RESOURCE as long as the new value is greater
> than the resource limit.
> 

First of all, oom_adj is deprecated and scheduled for removal in a couple 
of years (see Documentation/feature-removal-schedule.txt) so any work in 
this area should be targeting oom_score_adj instead.

What is the anticipated use case for this?  We know that you want to lower 
oom_adj without CAP_SYS_RESOURCE, but what's the expected behavior when an 
app moves from foreground to background?  I assume it's something like 
having an oom_adj of 0 in the background and +15 in the foreground.  If 
so, does /proc/sys/vm/oom_kill_allocating_task get you most of what you're 
looking for?

I'm wondering if we can avoid yet another resource limit for something 
like this.

> Alternative considered:
> 
> * a setuid binary
> * a daemon with CAP_SYS_RESOURCE
> 
> Since you don't wan't all processes to be able to reduce their
> oom_adj, a setuid or daemon implementation would be complex. The
> alternatives also have much higher overhead.
> 

What do you anticipate will be writing to oom_score_adj with this patch, 
the app itself?

> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> ---
>  fs/proc/base.c                 |   12 ++++++++++--
>  include/asm-generic/resource.h |    5 ++++-
>  2 files changed, 14 insertions(+), 3 deletions(-)
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

s/Max/Min, right?

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

Ouch, that's a rather unfortunate mapping.

> +		if (oom_rlim > task->signal->rlim[RLIMIT_OOMADJ].rlim_cur) {
> +			unlock_task_sighand(task, &flags);
> +			put_task_struct(task);
> +			err = -EACCES;
> +			goto err_sighand;

err_sighand has duplicate unlock_task_sighand() and put_task_struct(); 
since you're missing the task_unlock(task) here, just using goto 
err_sighand would suffice.

> +		}
>  	}
>  
>  	if (oom_adjust != task->signal->oom_adj) {

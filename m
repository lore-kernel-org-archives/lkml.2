Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0FPPIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:08:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39866 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0FPPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ijZNPCXfW6Oo3/PUInp0x54SvwLKt9TWI9JDWqh9TwSCPRSPzxC4yBTBD0vRT6FJ3u
         XmEPiyH8xygkEJ/RxoRN6lheYCyWwX/1G+znkLIQmDJ/n7VeEWNxwc7SPreVlWtODr6f
         bLaPExBDtEsQqnPNQNPnWna3ckEdBCxFASywU=
Date: Thu, 17 Jun 2010 00:07:28 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/9] oom: oom_kill_process() need to check p is
 unkillable
Message-ID: <20100616150728.GD9278@barrios-desktop>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
 <20100616203212.72E0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616203212.72E0.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:32:45PM +0900, KOSAKI Motohiro wrote:
> When oom_kill_allocating_task is enabled, an argument of
> oom_kill_process is not selected by select_bad_process(), but
> just out_of_memory() caller task. It mean the task can be
> unkillable. check it first.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/oom_kill.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 6ca6cb8..3e48023 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -436,6 +436,17 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	unsigned long victim_points = 0;
>  	struct timespec uptime;
>  
> +	/*
> +	 * When oom_kill_allocating_task is enabled, p can be
> +	 * unkillable. check it first.
> +	 */
> +	if (is_global_init(p) || (p->flags & PF_KTHREAD))
> +		return 1;
> +	if (mem && !task_in_mem_cgroup(p, mem))
> +		return 1;
> +	if (!has_intersects_mems_allowed(p, nodemask))
> +		return 1;
> +

I think this check could be done before oom_kill_proces in case of
sysctl_oom_kill_allocating_task, too. 

-- 
Kind regards,
Minchan Kim

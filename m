Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0ELUG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:06:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39800 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0ELUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cnf29otJSESuHe1T9JsYvEJr40ZwOsu3nDyn8hBQPvsUAAYrlbvkfaC85qvDTfpYeT
         TNI6ZPmOB+NJQWtMRBEew7fglWrK5Ph5dn2tC8EhBuQOa6vUz7gVxraWAD1Mj/P9VXJp
         dWbnCadzlTDvYKRDvQMY3vdWb5w5p+aRWbcVw=
Date: Wed, 12 May 2010 22:06:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and
	softlockup_tick removal
Message-ID: <20100512200652.GF10028@nowhere>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com> <1273266711-18706-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273266711-18706-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 05:11:45PM -0400, Don Zickus wrote:
> Just some code cleanup to make touch_softlockup clearer and remove the
> softlockup_tick function as it is no longer needed.
> 
> Also remove the /proc softlockup_thres call as it has been changed to
> watchdog_thres.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  include/linux/sched.h |   16 +++-------------
>  kernel/sysctl.c       |    9 ---------
>  kernel/timer.c        |    1 -
>  kernel/watchdog.c     |   35 +++--------------------------------
>  4 files changed, 6 insertions(+), 55 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2455ff5..e9c6c1d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -308,18 +308,14 @@ extern void scheduler_tick(void);
>  extern void sched_show_task(struct task_struct *p);
>  
>  #ifdef CONFIG_DETECT_SOFTLOCKUP
> -extern void softlockup_tick(void);
>  extern void touch_softlockup_watchdog(void);
>  extern void touch_all_softlockup_watchdogs(void);
> -extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
> -				    void __user *buffer,
> -				    size_t *lenp, loff_t *ppos);
>  extern unsigned int  softlockup_panic;
>  extern int softlockup_thresh;
> +extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
> +				  void __user *buffer,
> +				  size_t *lenp, loff_t *ppos);
>  #else
> -static inline void softlockup_tick(void)
> -{
> -}
>  static inline void touch_softlockup_watchdog(void)
>  {
>  }
> @@ -338,12 +334,6 @@ extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
>  					 size_t *lenp, loff_t *ppos);
>  #endif
>  
> -#ifdef CONFIG_LOCKUP_DETECTOR
> -extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
> -				  void __user *buffer,
> -				  size_t *lenp, loff_t *ppos);
> -#endif
> -
>  /* Attach to any functions which should be ignored in wchan output. */
>  #define __sched		__attribute__((__section__(".sched.text")))
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 1083897..1fec781 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -827,15 +827,6 @@ static struct ctl_table kern_table[] = {
>  		.extra1		= &zero,
>  		.extra2		= &one,
>  	},
> -	{
> -		.procname	= "softlockup_thresh",
> -		.data		= &softlockup_thresh,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= proc_dosoftlockup_thresh,
> -		.extra1		= &neg_one,
> -		.extra2		= &sixty,
> -	},



I wonder about the ABI breakage.

But I suspect few userspace tools use it though, since this is
mostly for kernel dev.


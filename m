Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1G1VNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:13:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1G1VNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:13:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] Unfreeze tasks after an oops in the freezer
Date: Thu, 28 Jul 2011 23:14:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <201107271235.58734.oneukum@suse.de>
In-Reply-To: <201107271235.58734.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107282314.05894.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 27, 2011, Oliver Neukum wrote:
> From ee5849f0bc39d554ef91747ff80c307ac3e05cdd Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Wed, 27 Jul 2011 12:27:00 +0200
> Subject: [PATCH] Unfreeze tasks after an oops in the freezer
> 
> If an oops kills the task suspending or snapshotting
> is system, the system is dead because the action is
> never completed and the tasks never thawed.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  include/linux/freezer.h |    2 ++
>  kernel/panic.c          |    8 ++++++++
>  kernel/power/process.c  |   11 +++++++++++
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 1effc8b..ab0168a 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -50,6 +50,7 @@ extern int thaw_process(struct task_struct *p);
>  extern void refrigerator(void);
>  extern int freeze_processes(void);
>  extern void thaw_processes(void);
> +extern void thaw_in_oops(void);
>  
>  static inline int try_to_freeze(void)
>  {
> @@ -181,6 +182,7 @@ static inline void freezer_count(void) {}
>  static inline int freezer_should_skip(struct task_struct *p) { return 0; }
>  static inline void set_freezable(void) {}
>  static inline void set_freezable_with_signal(void) {}
> +static inline void thaw_in_oops(void) {}
>  
>  #define wait_event_freezable(wq, condition)				\
>  		wait_event_interruptible(wq, condition)
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 6923167..ccdd834 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/nmi.h>
>  #include <linux/dmi.h>
> +#include <linux/freezer.h>
>  
>  #define PANIC_TIMER_STEP 100
>  #define PANIC_BLINK_SPD 18
> @@ -355,6 +356,13 @@ void oops_exit(void)
>  	do_oops_enter_exit();
>  	print_oops_end_marker();
>  	kmsg_dump(KMSG_DUMP_OOPS);
> +	/*
> +	 * if we oops while tasks are frozen, the system
> +	 * will stop dead because the task that would thaw it
> +	 * has been killed. So the system must be explicitly
> +	 * thawed here.
> +	 */
> +	thaw_in_oops();
>  }
>  
>  #ifdef WANT_WARN_ON_SLOWPATH
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 0cf3a27..c03e88b 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -22,6 +22,9 @@
>   */
>  #define TIMEOUT	(20 * HZ)
>  
> +/* in case we oops while processes are frozen */
> +static bool tasks_frozen = false;
> +
>  static inline int freezable(struct task_struct * p)
>  {
>  	if ((p == current) ||
> @@ -131,6 +134,7 @@ static int try_to_freeze_tasks(bool sig_only)
>  			elapsed_csecs % 100);
>  	}
>  
> +	tasks_frozen = (todo == 0);

I'd prefer it to be set by freeze_processes(), when oom_killer_disable()
is called.

>  	return todo ? -EBUSY : 0;
>  }
>  
> @@ -189,7 +193,14 @@ void thaw_processes(void)
>  	thaw_workqueues();
>  	thaw_tasks(true);
>  	thaw_tasks(false);
> +	tasks_frozen = false;
>  	schedule();
>  	printk("done.\n");
>  }
>  
> +void thaw_in_oops(void)
> +{
> +	if (tasks_frozen)
> +		thaw_processes();
> +}
> +

Thanks,
Rafael

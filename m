Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1GYKKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:10:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47655 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYKKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:10:12 -0400
Date: Mon, 25 Jul 2011 12:10:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: better oopsing when frozen
Message-ID: <20110725101008.GA22126@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Oliver Neukum <oneukum@suse.de>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	rjw@sisk.pl
References: <201107251043.19932.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201107251043.19932.oneukum@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:43:19AM +0200, Oliver Neukum wrote:
> Hi Rafael,
> 
> I had a problem with the kernel stopping the machine forever because I got an
> oops while tasks were frozen. It seems to me that we should thaw when this
> happens. How about this approach?
> 
> 	Regards
> 		Oliver
> 
> From 6f3b5e7a5c7ccf3564bdd2e703eba7eee753ecdc Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Fri, 22 Jul 2011 11:20:19 +0200
> Subject: [PATCH] unfreeze tasks if an oops happens while tasks are frozen
> 
> If an oops kills the task suspending or snapshotting
> is system, the system is dead because the action is
> never completed and the tasks never thawed.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  include/linux/freezer.h |    1 +
>  kernel/panic.c          |    2 ++
>  kernel/power/process.c  |   11 +++++++++++
>  3 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 1effc8b..9907cf6 100644
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
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 6923167..255e662 100644
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
> @@ -355,6 +356,7 @@ void oops_exit(void)
>  	do_oops_enter_exit();
>  	print_oops_end_marker();
>  	kmsg_dump(KMSG_DUMP_OOPS);
> +	thaw_in_oops();
>  }
>  
>  #ifdef WANT_WARN_ON_SLOWPATH
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 0cf3a27..20994cd 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -22,6 +22,9 @@
>   */
>  #define TIMEOUT	(20 * HZ)
>  
> +/* in case we oops while processes are frozen */
> +static bool tasks_fozen = false;

I think you mean 'tasks_frozen' here :).

-- 
Regards/Gruss,
    Boris.

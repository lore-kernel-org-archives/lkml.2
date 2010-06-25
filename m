Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0FYOmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:42:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45714 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756282Ab0FYOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:42:29 -0400
Date: Fri, 25 Jun 2010 10:42:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [update 3] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006250100.14166.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006251028240.1604-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Rafael J. Wysocki wrote:

> So, there it goes.
> 
> I decided not to play with memory allocations at this point, because I really
> don't expect pm_wakeup_event() to be heavily used initially.  If there are more
> users and it's called more frequently, we can always switch to using a separate
> slab cache.
> 
> Hopefully, I haven't overlooked anything vitally important this time.
> 
> Please tell me what you think.

Obviously comments still need to be added.  Beyond that...

> --- /dev/null
> +++ linux-2.6/drivers/base/power/wakeup.c
> @@ -0,0 +1,143 @@
> +
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/capability.h>
> +#include <linux/pm.h>
> +
> +bool events_check_enabled;
> +
> +static unsigned long event_count;
> +static unsigned long saved_event_count;
> +static unsigned long events_in_progress;
> +static spinlock_t events_lock;

Use static DEFINE_SPINLOCK(events_lock) instead.

> +static DECLARE_WAIT_QUEUE_HEAD(events_wait_queue);
> +
> +void pm_wakeup_events_init(void)
> +{
> +	spin_lock_init(&events_lock);
> +}

Then this routine won't be needed.

> +unsigned long pm_dev_wakeup_count(struct device *dev)
> +{
> +	unsigned long flags;
> +	unsigned long count;
> +
> +	spin_lock_irqsave(&events_lock, flags);
> +	count = dev->power.wakeup_count;
> +	spin_unlock_irqrestore(&events_lock, flags);
> +	return count;
> +}

Are the spin_lock calls needed here?  I doubt it.

> --- linux-2.6.orig/kernel/power/power.h
> +++ linux-2.6/kernel/power/power.h
> @@ -184,6 +184,15 @@ static inline void suspend_test_finish(c
>  #ifdef CONFIG_PM_SLEEP
>  /* kernel/power/main.c */
>  extern int pm_notifier_call_chain(unsigned long val);
> +
> +/* drivers/base/power/wakeup.c */
> +extern bool events_check_enabled;
> +
> +extern void pm_wakeup_events_init(void);
> +extern bool pm_check_wakeup_events(void);
> +extern bool pm_check_wakeup_events_final(void);
> +extern bool pm_get_wakeup_count(unsigned long *count);
> +extern bool pm_save_wakeup_count(unsigned long count);
>  #endif

This is unfortunate.  These declarations belong in a file that can
also be #included by drivers/base/power/wakeup.c.  Otherwise future
changes might cause type mismatches the compiler won't be able to
catch.

> @@ -511,18 +513,24 @@ int hibernation_platform_enter(void)
>  
>  	local_irq_disable();
>  	sysdev_suspend(PMSG_HIBERNATE);
> +	if (!pm_check_wakeup_events()) {
> +		error = -EAGAIN;
> +		goto Power_up;
> +	}
> +
>  	hibernation_ops->enter();
>  	/* We should never get here */
>  	while (1);
>  
> -	/*
> -	 * We don't need to reenable the nonboot CPUs or resume consoles, since
> -	 * the system is going to be halted anyway.
> -	 */
> + Power_up:
> +	sysdev_resume();
> +	local_irq_enable();
> +	enable_nonboot_cpus();
> +
>   Platform_finish:
>  	hibernation_ops->finish();
>  
> -	dpm_suspend_noirq(PMSG_RESTORE);
> +	dpm_resume_noirq(PMSG_RESTORE);

Is this a bug fix that crept in along with the other changes?

> --- linux-2.6.orig/drivers/pci/pci.h
> +++ linux-2.6/drivers/pci/pci.h
> @@ -6,6 +6,8 @@
>  #define PCI_CFG_SPACE_SIZE	256
>  #define PCI_CFG_SPACE_EXP_SIZE	4096
>  
> +#define PCI_WAKEUP_COOLDOWN	100

This definition can go directly in pci.c, since it isn't used anywhere
else.

Alan Stern


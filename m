Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab0FTFwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 01:52:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56578 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0FTFwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 01:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uNP2N05eNPar3jOs8UKwto+dzrPBSsShaMHTTKL7H+/b5PQNlHoo+TvetWr9tzsMVO
         C8/KTvsFv/WmRf86SpqeNedOYsp3KVamqdstALbGYFn3F1FAn651r6wxvnhuOGioc68G
         T5ZpFWsYkwCcfwmODKVKHPj+rpI5FpaYo6agc=
Date: Sat, 19 Jun 2010 22:52:54 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100620055254.GA21994@gvim.org>
Reply-To: markgross@thegnar.org
References: <201006200005.35771.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006200005.35771.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 12:05:35AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> One of the arguments during the suspend blockers discussion was that the
> mainline kernel didn't contain any mechanisms allowing it to avoid losing
> wakeup events during system suspend.
> 
> Generally, there are two problems in that area.  First, if a wakeup event
> occurs exactly at the same time when /sys/power/state is being written to,
> the even may be delivered to user space right before the freezing of it,
> in which case the user space consumer of the event may not be able to process
yes this is racy.  souldn't the wakeup event handers/driver force a user
mode ACK before they stop failing suspend attempts? 

> it before the system is suspended.  Second, if a wakeup event occurs after user
> space has been frozen and that event is not a wakeup interrupt, the kernel will
> not react to it and the system will be suspended.

If its not a wakeup interrupt is it not fair to allow the suspend to
happen even if its handler's are "in flight" at suspend time?
> 
> The following patch illustrates my idea of how these two problems may be
> addressed.  It introduces a new global sysfs attribute,
> /sys/power/wakeup_count, associated with a running counter of wakeup events
> and a helper function, pm_wakeup_event(), that may be used by kernel subsystems
> to increment the wakeup events counter.
> 
> /sys/power/wakeup_count may be read from or written to by user space.  Reads
> will always succeed and return the current value of the wakeup events counter.
> Writes, however, will only succeed if the written number is equal to the
> current value of the wakeup events counter.  If a write is successful, it will
> cause the kernel to save the current value of the wakeup events counter and
> to compare the saved number with the current value of the counter at certain
> points of the subsequent suspend (or hibernate) sequence.  If the two values
> don't match, the suspend will be aborted just as though a wakeup interrupt
> happened.  Reading from /sys/power/wakeup_count again will turn that mechanism
> off.

why would you want to turn it off?

> 
> The assumption is that there's a user space power manager that will first
> read from /sys/power/wakeup_count.  Then it will check all user space consumers
> of wakeup events known to it for unprocessed events.  If there are any, it will
> wait for them to be processed and repeat.  In turn, if there are not any,
> it will try to write to /sys/power/wakeup_count and if the write is successful,
> it will write to /sys/power/state to start suspend, so if any wakeup events
> accur past that point, they will be noticed by the kernel and will eventually
> cause the suspend to be aborted.
> 
> In addition to the above, the patch adds a wakeup events counter to the
> power member of struct device and makes these per-device wakeup event counters
> available via sysfs, so that it's possible to check the activity of various
> wakeup event sources within the kernel.
> 
> To illustrate how subsystems can use pm_wakeup_event(), I added it to the
> PCI runtime PM wakeup-handling code.
> 
> At the moment the patch only contains code changes (ie. no documentation),
> but I'm going to add comments etc. if people like the idea.
> 
> Please tell me what you think.
> 
> Rafael
> 
> ---
>  drivers/base/power/Makefile     |    2 -
>  drivers/base/power/main.c       |    1 
>  drivers/base/power/power.h      |    3 +
>  drivers/base/power/sysfs.c      |    9 ++++
>  drivers/base/power/wakeup.c     |   74 ++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci-acpi.c          |    2 +
>  drivers/pci/pcie/pme/pcie_pme.c |    2 +
>  include/linux/pm.h              |    6 +++
>  kernel/power/hibernate.c        |   14 ++++---
>  kernel/power/main.c             |   24 ++++++++++++
>  kernel/power/power.h            |    6 +++
>  kernel/power/suspend.c          |    2 -
>  12 files changed, 138 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -204,6 +204,28 @@ static ssize_t state_store(struct kobjec
>  
>  power_attr(state);
>  
> +static ssize_t wakeup_count_show(struct kobject *kobj,
> +				struct kobj_attribute *attr,
> +				char *buf)
> +{
> +	return sprintf(buf, "%lu\n", pm_get_wakeup_count());
> +}
> +
> +static ssize_t wakeup_count_store(struct kobject *kobj,
> +				struct kobj_attribute *attr,
> +				const char *buf, size_t n)
> +{
> +	unsigned long val;
> +
> +	if (sscanf(buf, "%lu", &val) == 1) {
> +		if (pm_save_wakeup_count(val))
> +			return n;
> +	}
> +	return -EINVAL;
> +}
> +
> +power_attr(wakeup_count);
> +
>  #ifdef CONFIG_PM_TRACE
>  int pm_trace_enabled;
>  
> @@ -236,6 +258,7 @@ static struct attribute * g[] = {
>  #endif
>  #ifdef CONFIG_PM_SLEEP
>  	&pm_async_attr.attr,
> +	&wakeup_count_attr.attr,
>  #ifdef CONFIG_PM_DEBUG
>  	&pm_test_attr.attr,
>  #endif
> @@ -266,6 +289,7 @@ static int __init pm_init(void)
>  	int error = pm_start_workqueue();
>  	if (error)
>  		return error;
> +	pm_wakeup_events_init();
>  	power_kobj = kobject_create_and_add("power", NULL);
>  	if (!power_kobj)
>  		return -ENOMEM;
> Index: linux-2.6/drivers/base/power/wakeup.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/base/power/wakeup.c
> @@ -0,0 +1,74 @@
> +
> +#include <linux/device.h>
> +#include <linux/pm.h>
> +
> +static unsigned long event_count;
> +static unsigned long saved_event_count;

what about over flow issues?

> +static bool events_check_enabled;
> +static spinlock_t events_lock;
> +
> +void pm_wakeup_events_init(void)
> +{
> +	spin_lock_init(&events_lock);
> +}
> +
> +void pm_wakeup_event(struct device *dev)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&events_lock, flags);
> +	event_count++;
should event_count be an atomic type so we can not bother with taking
the evnets_lock?

> +	if (dev)
> +		dev->power.wakeup_count++;
> +	spin_unlock_irqrestore(&events_lock, flags);
> +}
> +
> +bool pm_check_wakeup_events(bool enable)
> +{
> +	unsigned long flags;
> +	bool ret;
> +
> +	spin_lock_irqsave(&events_lock, flags);
> +	ret = !events_check_enabled || (event_count == saved_event_count);
I'm not getting the events_check_enbled flag yet.

> +	events_check_enabled = enable;
I'm not sure if this is the right thing depending on all the different
ways the boolians are interacting with eachother.

Which is a red flag to me.  This code is confusing.


I'll look at it some more when I'm fresh tomorrow.

--mgross

> +	spin_unlock_irqrestore(&events_lock, flags);
> +	return ret;
> +}
> +
> +unsigned long pm_get_wakeup_count(void)
> +{
> +	unsigned long flags;
> +	unsigned long count;
> +
> +	spin_lock_irqsave(&events_lock, flags);
> +	events_check_enabled = false;
> +	count = event_count;
> +	spin_unlock_irqrestore(&events_lock, flags);
> +	return count;
> +}
> +
> +bool pm_save_wakeup_count(unsigned long count)
> +{
> +	unsigned long flags;
> +	bool ret = false;
> +
> +	spin_lock_irqsave(&events_lock, flags);
> +	if (count == event_count) {
> +		saved_event_count = count;
> +		events_check_enabled = true;
> +		ret = true;
> +	}
> +	spin_unlock_irqrestore(&events_lock, flags);
> +	return ret;
> +}
> +
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
> Index: linux-2.6/include/linux/pm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pm.h
> +++ linux-2.6/include/linux/pm.h
> @@ -457,6 +457,7 @@ struct dev_pm_info {
>  #ifdef CONFIG_PM_SLEEP
>  	struct list_head	entry;
>  	struct completion	completion;
> +	unsigned long		wakeup_count;
>  #endif
>  #ifdef CONFIG_PM_RUNTIME
>  	struct timer_list	suspend_timer;
> @@ -552,6 +553,9 @@ extern void __suspend_report_result(cons
>  	} while (0)
>  
>  extern void device_pm_wait_for_dev(struct device *sub, struct device *dev);
> +
> +/* drivers/base/power/wakeup.c */
> +extern void pm_wakeup_event(struct device *dev);
>  #else /* !CONFIG_PM_SLEEP */
>  
>  #define device_pm_lock() do {} while (0)
> @@ -565,6 +569,8 @@ static inline int dpm_suspend_start(pm_m
>  #define suspend_report_result(fn, ret)		do {} while (0)
>  
>  static inline void device_pm_wait_for_dev(struct device *a, struct device *b) {}
> +
> +static inline void pm_wakeup_event(struct device *dev) {}
>  #endif /* !CONFIG_PM_SLEEP */
>  
>  /* How to reorder dpm_list after device_move() */
> Index: linux-2.6/drivers/base/power/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/Makefile
> +++ linux-2.6/drivers/base/power/Makefile
> @@ -1,5 +1,5 @@
>  obj-$(CONFIG_PM)	+= sysfs.o
> -obj-$(CONFIG_PM_SLEEP)	+= main.o
> +obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
>  obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
>  obj-$(CONFIG_PM_OPS)	+= generic_ops.o
>  obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -59,6 +59,7 @@ void device_pm_init(struct device *dev)
>  {
>  	dev->power.status = DPM_ON;
>  	init_completion(&dev->power.completion);
> +	dev->power.wakeup_count = 0;
>  	pm_runtime_init(dev);
>  }
>  
> Index: linux-2.6/kernel/power/power.h
> ===================================================================
> --- linux-2.6.orig/kernel/power/power.h
> +++ linux-2.6/kernel/power/power.h
> @@ -184,6 +184,12 @@ static inline void suspend_test_finish(c
>  #ifdef CONFIG_PM_SLEEP
>  /* kernel/power/main.c */
>  extern int pm_notifier_call_chain(unsigned long val);
> +
> +/* drivers/base/power/wakeup.c */
> +extern void pm_wakeup_events_init(void);
> +extern bool pm_check_wakeup_events(bool enable);
> +extern unsigned long pm_get_wakeup_count(void);
> +extern bool pm_save_wakeup_count(unsigned long count);
>  #endif
>  
>  #ifdef CONFIG_HIGHMEM
> Index: linux-2.6/kernel/power/suspend.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/suspend.c
> +++ linux-2.6/kernel/power/suspend.c
> @@ -157,7 +157,7 @@ static int suspend_enter(suspend_state_t
>  
>  	error = sysdev_suspend(PMSG_SUSPEND);
>  	if (!error) {
> -		if (!suspend_test(TEST_CORE))
> +		if (!suspend_test(TEST_CORE) && pm_check_wakeup_events(false))
>  			error = suspend_ops->enter(state);
>  		sysdev_resume();
>  	}
> Index: linux-2.6/kernel/power/hibernate.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/hibernate.c
> +++ linux-2.6/kernel/power/hibernate.c
> @@ -277,7 +277,7 @@ static int create_image(int platform_mod
>  		goto Enable_irqs;
>  	}
>  
> -	if (hibernation_test(TEST_CORE))
> +	if (hibernation_test(TEST_CORE) || !pm_check_wakeup_events(true))
>  		goto Power_up;
>  
>  	in_suspend = 1;
> @@ -511,14 +511,18 @@ int hibernation_platform_enter(void)
>  
>  	local_irq_disable();
>  	sysdev_suspend(PMSG_HIBERNATE);
> +	if (!pm_check_wakeup_events(false))
> +		goto Power_up;
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
> Index: linux-2.6/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-acpi.c
> +++ linux-2.6/drivers/pci/pci-acpi.c
> @@ -48,6 +48,8 @@ static void pci_acpi_wake_dev(acpi_handl
>  	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
>  		pci_check_pme_status(pci_dev);
>  		pm_runtime_resume(&pci_dev->dev);
> +		if (device_may_wakeup(&pci_dev->dev))
> +			pm_wakeup_event(&pci_dev->dev);
>  		if (pci_dev->subordinate)
>  			pci_pme_wakeup_bus(pci_dev->subordinate);
>  	}
> Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/pme/pcie_pme.c
> +++ linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
> @@ -147,6 +147,8 @@ static bool pcie_pme_walk_bus(struct pci
>  		/* Skip PCIe devices in case we started from a root port. */
>  		if (!pci_is_pcie(dev) && pci_check_pme_status(dev)) {
>  			pm_request_resume(&dev->dev);
> +			if (device_may_wakeup(&dev->dev))
> +				pm_wakeup_event(&dev->dev);
>  			ret = true;
>  		}
>  
> Index: linux-2.6/drivers/base/power/power.h
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/power.h
> +++ linux-2.6/drivers/base/power/power.h
> @@ -30,6 +30,9 @@ extern void device_pm_move_before(struct
>  extern void device_pm_move_after(struct device *, struct device *);
>  extern void device_pm_move_last(struct device *);
>  
> +/* drivers/base/power/wakeup.c */
> +extern unsigned long pm_dev_wakeup_count(struct device *dev);
> +
>  #else /* !CONFIG_PM_SLEEP */
>  
>  static inline void device_pm_init(struct device *dev)
> Index: linux-2.6/drivers/base/power/sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/sysfs.c
> +++ linux-2.6/drivers/base/power/sysfs.c
> @@ -144,6 +144,14 @@ wake_store(struct device * dev, struct d
>  
>  static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
>  
> +static ssize_t wakeup_count_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%lu\n", pm_dev_wakeup_count(dev));
> +}
> +
> +static DEVICE_ATTR(wakeup_count, 0444, wakeup_count_show, NULL);
> +
>  #ifdef CONFIG_PM_ADVANCED_DEBUG
>  #ifdef CONFIG_PM_RUNTIME
>  
> @@ -230,6 +238,7 @@ static struct attribute * power_attrs[]
>  	&dev_attr_control.attr,
>  #endif
>  	&dev_attr_wakeup.attr,
> +	&dev_attr_wakeup_count.attr,
>  #ifdef CONFIG_PM_ADVANCED_DEBUG
>  	&dev_attr_async.attr,
>  #ifdef CONFIG_PM_RUNTIME
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1DZLq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:46:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab1DZLq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:46:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
Date: Tue, 26 Apr 2011 13:47:21 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com> <1303781471-2477-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1303781471-2477-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261347.21811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If I saw it correctly, patches [2-3/3] only added the generic routine to
the platform and i2c bus types, right?

Now, this one is better than the previous one IMO, but (1) it also should
cover hibernation (I'd don't see a reason why suspend-to-RAM should be a
special case here) and (2) I don't really think that thawing user space is
"too heavy" (in fact it's much lighter weight than resuming all devices
that your approach doesn't prevent from happening, so for example on my
desktop/notebook machines I woulnd't mind at all if user space were
thawed after all of the devices had been resumed).

On Tuesday, April 26, 2011, MyungJoo Ham wrote:
> A system or a device may need to control suspend/wakeup events. It may
> want to wakeup the system after a predefined amount of time or at a
> predefined event decided while entering suspend for polling or delayed
> work. Then, it may want to enter suspend again if its predefined wakeup
> condition is the only wakeup reason and there is no outstanding events;
> thus, it does not wakeup the userspace unnecessary and keeps suspended
> as long as possible (saving the power).

I'm not really sure if kernel subsystems should decide when to suspend,
because that's a matter of policy and as such I think it should belong to
user space.  The kernel subsystems should be concerned with _how_ to
suspend, not _when_ to do that.

For example, even if your wakeup signal is the only one and it _seems_ it's
better to suspend again, it actually may be better to wake up and let user
space decide.

Moreover, I'm not sure if kernel subsystems (including drivers) should really
decide when to generate wakeup signals in the first place.  Generally,
user space decides what devices should wake up the system from sleep and the
kernel should follow.  So, there shouldn't be any wakeup signals enabled
beyond what user space has requested.

> Enabling a system to wakeup after a specified time can be easily
> achieved by using RTC. However, to enter suspend again immediately
> without invoking userland, we need additional features in the
> suspend framework.
> 
> Such need comes from:
> 
> 1. Monitoring a critical device status without interrupts that can
> wakeup the system. (in-suspend polling)
>  An example is ambient temperature monitoring that needs to shut down
> the system or a specific device function if it is too hot or cold. The
> temperature of a specific device may be needed to be monitored as well;
> e.g., a charger monitors battery temperature in order to stop charging
> if overheated.

I'd say in those cases (ie. if polling is necessary to prevent some
disaster from happening) you shouldn't suspend at all and use runtime PM
instead (I know that's hard with Android, but please not that Android is
not using the mainline kernel).

> 2. Execute critical "delayed work" at suspend.
>  A driver or a system/board may have a delayed work (or any similar
> things) that it wants to execute at the requested time.
>  For example, some chargers want to check the battery voltage some
> time (e.g., 30 seconds) after the battery is fully charged and the
> charger has stopped. Then, the charger restarts charging if the voltage has
> dropped more than a threshold, which is smaller than "restart-charger"
> voltage, which is a threshold to restart charging regardless of the
> time passed.

Again, don't suspend if you have a usage case like this.

> This patch allows a device to provide "suspend_again" callback with
> struct dev_pm_ops in driver. With suspend_again callbacks registered
> along with supporting subsystems, the suspend framework
> (kernel/power/suspend.c) tries to enter suspend again if conditions are met.
> In general, in order to support suspend-again, subsystems simply need to
> return the value returned by the suspend_again of device as the
> pm_generic_suspend_again does.
> 
> The system enters the suspend again if and only if all of the following
> conditions are met:
> 1. None of suspend_again ops returned "I want to stop suspend" by
> returning a negative number.
> 2. At least one of suspend_again ops returned "I want to suspend again"
> by returning a positive number.
> 
> suspend_again ops may return "I do not care. This wakeup is not related
> with me." by providing zero.
> 
> suspend_again ops may return a negative number in order to override
> other devices' "suspend again" request and to wakeup fully. Devices
> that poll sensors during suspend may need this if any outstanding status
> that requires to notify the userland is found. Conventional suspend
> wakeup sources may also need this to override SUSPEND_AGAIN devices.
> (we may need to lookup every IRQ registered with set_irq_wake and
> register IRQS that are related with suspend_ops separatedly. this is
> not implemented yet anyway and discusses below with item 3.)
> 
> Anyway, the following features may need to be added later:
> 
> 1. An API to allow devices to express next desired wakeup-time. Then,
> the framework will combine them and setup RTC alarm accordingly and
> save/restore previously registered RTC alarms.
> => For this, rtc_timer_init/start/cancel might work for any rtc that
> has wakeup enabled. We need to express whether the rtc_timer is going to
> be used for suspend_again so that it would not fully wakeup the system.
> => Then, we need a bogus platform-device of rtc to see if the
> current wakeup event is whether a) rtc-induced and b) suspend-again
> related rtc event. This may be implemented at drivers/rtc/interface.c?
> 
> 2. Create a method to declare a specific instance of delayed-work is to
> be executed in suspend by waking up the system in the middle of
> suspend. Then, let the framework handle those "critical" delayed-work
> in suspend.
> => If the workitem 1 with identification method is done, this will
> probably be an easy feature to add. (virtually already implemented with 1.)
> 
> 3. If a device says "suspend again, >0" and there is another wakeup
> source pending (e.g., power button) without suspend_again ops, the
> system will enter suspend again. In such a case, the system should not
> suspend again. We may need to see if irqs that are enabled by
> set_irq_wake() (and not related to suspend_ops devices)
> are pending at syscore_suspend_again(). Maybe we need to add
> something like "set_irq_wake_with_suspend_again" so that IRQs with
> suspend_again ops implemented are ignored for the
> "override-suspend-again-continue" checking.
> => For wakeup-enabled IRQs, such behavior of fully-waking up the system
> (by returning a negative number at suspend_again) should be default and
> should not require any modification; the change should be transparent to
> the conventional wakeup sources. Thus, we should modify IRQ core to
> do this by default and add an option not to return < 0 optionally
> (selected by suspend-again users). The implementation of 1 and 2 should
> include this in their code as well.
> 
> In this patch, the suspend-again loops at "suspend_devices_and_enter"
> because at that point,
> 1. every device is resume and are ready to be used.
> 2. userspace is still not invoked (transparent to it)
> 3. console is accessible as it is outside of suspend/resume_console.
> 4. it is outside of trace_machine_suspend(); thus, we can have seperated
> traces for each instance of suspend_again.
> 
> For the RFC release, I have set the point of "suspend-again" after
> suspend_ops->end(). However, I'm not so sure about where to set the
> suspend-again point. Because in-suspend polling, which may require
> I/O with other devices, is supposed to be executed at suspend-again ops,
> the suspend-again point is configured to be as late as possible in
> suspend_devices_and_enter(). In order to reduce the number of devices
> waked up, we may need to set the suspend-again point ealier.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> --
> Changes from v1:
> 	- moved from syscore to dev_pm_ops
> 	- added generic ops for subsystems.
> 	- cleaned up suspend_again code at kernel/power/suspend.
> ---
>  drivers/base/power/generic_ops.c |   17 ++++++++++
>  drivers/base/power/main.c        |   61 ++++++++++++++++++++++++++++++++++++++
>  include/linux/pm.h               |   17 ++++++++++
>  kernel/power/suspend.c           |    4 ++-
>  4 files changed, 98 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
> index 42f97f9..0976452 100644
> --- a/drivers/base/power/generic_ops.c
> +++ b/drivers/base/power/generic_ops.c
> @@ -213,6 +213,22 @@ int pm_generic_restore(struct device *dev)
>  	return __pm_generic_resume(dev, PM_EVENT_RESTORE);
>  }
>  EXPORT_SYMBOL_GPL(pm_generic_restore);
> +
> +/**
> + * pm_generic_suspend_again - Generic suspend-again callback for subsystems.
> + * @dev: Device to check for suspend-again request.
> + */
> +int pm_generic_suspend_again(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (!pm || !pm->suspend_again)
> +		return 0;
> +
> +	return pm->suspend_again(dev);
> +}
> +EXPORT_SYMBOL_GPL(pm_generic_suspend_again);
> +
>  #endif /* CONFIG_PM_SLEEP */
>  
>  struct dev_pm_ops generic_subsys_pm_ops = {
> @@ -223,6 +239,7 @@ struct dev_pm_ops generic_subsys_pm_ops = {
>  	.thaw = pm_generic_thaw,
>  	.poweroff = pm_generic_poweroff,
>  	.restore = pm_generic_restore,
> +	.suspend_again = pm_generic_suspend_again,
>  #endif
>  #ifdef CONFIG_PM_RUNTIME
>  	.runtime_suspend = pm_generic_runtime_suspend,
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 052dc53..a5b659f 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1082,3 +1082,64 @@ int device_pm_wait_for_dev(struct device *subordinate, struct device *dev)
>  	return async_error;
>  }
>  EXPORT_SYMBOL_GPL(device_pm_wait_for_dev);
> +
> +/**
> + * dpm_suspend_again - Let devices poll or run code while the system is kept
> + *	suspended in the view of userland.
> + *
> + * Execute all "suspend_again" callbacks of devices and return non-zero value
> + * if all of the following conditions are met:
> + * 1) There is a device that wants to suspend again (returned > 0)
> + * 2) There is no device that wants to wake up (returned < 0)
> + */
> +int dpm_suspend_again(void)
> +{
> +	int suspend_again = 0;
> +	int wakeup = 0;
> +	struct device *dev;
> +
> +	mutex_lock(&dpm_list_mtx);
> +
> +	list_for_each_entry(dev, &dpm_list, power.entry) {
> +		const struct dev_pm_ops *ops = NULL;
> +		int result = 0;
> +
> +		get_device(dev);
> +		mutex_unlock(&dpm_list_mtx);
> +		device_lock(dev);
> +

Please remember of power domains (that's being worked on at the moment).

> +		if (dev->type && dev->type->pm) {
> +			ops = dev->type->pm;
> +			dev_dbg(dev, "type suspend_again ");
> +		} else if (dev->class && dev->class->pm) {
> +			ops = dev->class->pm;
> +			dev_dbg(dev, "class suspend_again ");
> +		} else if (dev->bus && dev->bus->pm) {
> +			ops = dev->bus->pm;
> +			dev_dbg(dev, "suspend_again ");
> +		}
> +		if (ops && ops->suspend_again)
> +			result = ops->suspend_again(dev);
> +
> +		device_unlock(dev);
> +		mutex_lock(&dpm_list_mtx);
> +		put_device(dev);
> +
> +		if (result > 0)
> +			suspend_again++;
> +		if (result < 0)
> +			wakeup++;
> +	}
> +	mutex_unlock(&dpm_list_mtx);
> +
> +	pr_debug("%d devices wants to suspend again. "
> +		 "%d devices wants to wakeup.\n", suspend_again, wakeup);
> +
> +	if (suspend_again && !wakeup) {
> +		pr_info("Suspending Again.\n");
> +		return 1;
> +	}
> +
> +	pr_info("No devices wants to suspend again or a device wants to wakeup.\n");
> +	return 0;
> +}
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 512e091..d3a9c67 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -145,6 +145,15 @@ typedef struct pm_message {
>   *	actions required for resuming the device that need interrupts to be
>   *	disabled
>   *
> + * @suspend_again: Tell the system whether the device wants to either
> + *	suspend again (return > 0), wake up (return < 0), or not-care
> + *	(return = 0). If a device wants to poll sensors or execute some code
> + *	during suspended, suspend_again callback is the place assuming that
> + *	periodic-wakeup or alarm-wakeup is already setup. Note that if a
> + *	device returns "wakeup" with an under-zero value, it overrides
> + *	other devices' "suspend again" return values. This allows to
> + *	execute some codes while being kept suspended in the view of userland.
> + *

Since, as I said, I think that should cover hibernation too, I'd change the
name to, say, sleep_again().

>   * @freeze_noirq: Complete the operations of ->freeze() by carrying out any
>   *	actions required for freezing the device that need interrupts to be
>   *	disabled
> @@ -212,6 +221,7 @@ struct dev_pm_ops {
>  	int (*restore)(struct device *dev);
>  	int (*suspend_noirq)(struct device *dev);
>  	int (*resume_noirq)(struct device *dev);
> +	int (*suspend_again)(struct device *dev);
>  	int (*freeze_noirq)(struct device *dev);
>  	int (*thaw_noirq)(struct device *dev);
>  	int (*poweroff_noirq)(struct device *dev);
> @@ -544,6 +554,7 @@ extern void dpm_resume_end(pm_message_t state);
>  extern void device_pm_unlock(void);
>  extern int dpm_suspend_noirq(pm_message_t state);
>  extern int dpm_suspend_start(pm_message_t state);
> +extern int dpm_suspend_again(void);
>  
>  extern void __suspend_report_result(const char *function, void *fn, int ret);
>  
> @@ -563,6 +574,11 @@ static inline int dpm_suspend_start(pm_message_t state)
>  	return 0;
>  }
>  
> +static int dpm_suspend_again(void)
> +{
> +	return 0;
> +}
> +
>  #define suspend_report_result(fn, ret)		do {} while (0)
>  
>  static inline int device_pm_wait_for_dev(struct device *a, struct device *b)
> @@ -585,5 +601,6 @@ extern int pm_generic_freeze(struct device *dev);
>  extern int pm_generic_thaw(struct device *dev);
>  extern int pm_generic_restore(struct device *dev);
>  extern int pm_generic_poweroff(struct device *dev);
> +extern int pm_generic_suspend_again(struct device *dev);
>  
>  #endif /* _LINUX_PM_H */
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 08515b4..b5a84a4 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -291,7 +291,9 @@ int enter_state(suspend_state_t state)
>  		goto Finish;
>  
>  	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
> -	error = suspend_devices_and_enter(state);
> +	do {
> +		error = suspend_devices_and_enter(state);
> +	} while (!error && dpm_suspend_again());
>  
>   Finish:
>  	pr_debug("PM: Finishing wakeup.\n");
> 

To conclude, I'm not sure about the approach.  In particular, I'm not sure
if the benefit is worth the effort and the resulting complications (ie. the
possibility of having to deal with wakeup signals not requested by user
space) seem to be a bit too far reaching.

Greg, what do you think?

Thanks,
Rafael

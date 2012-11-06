Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2KFM6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:58:54 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:58248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab2KFM6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:58:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 2/7] ACPI / PM: Move device power state selection routine to device_pm.c
Date: Tue, 06 Nov 2012 14:03:02 +0100
Message-ID: <1761214.vYoRTfZW8j@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121106045605.GA18104@aaronlu.sh.intel.com>
References: <1766582.8gdQKXoi0K@vostro.rjw.lan> <3439310.Qij2blxWr5@vostro.rjw.lan> <20121106045605.GA18104@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 06, 2012 12:56:07 PM Aaron Lu wrote:
> This patch doesn't apply...
> 
> I'm trying on Linus' master branch, HEAD is v3.7-rc4, and I've merged
> your pm-qos branch on top of v3.7-rc4.

Well, it applies for me.

You can use the linux-next branch of my tree instead.  It may contain
some fixes made after this patch had been sent.

Thanks,
Rafael


> On Mon, Oct 29, 2012 at 10:09:09AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The ACPI function for choosing device power state is now located
> > in drivers/acpi/sleep.c, but drivers/acpi/device_pm.c is a more
> > logical place for it, so move it there.
> > 
> > However, instead of moving the function entirely, move its core only
> > under a different name and with a different list of arguments, so
> > that it is more flexible, and leave a wrapper around it in the
> > original location.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/device_pm.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/acpi/sleep.c     |   88 +-------------------------------------
> >  include/acpi/acpi_bus.h  |   15 ++++++
> >  3 files changed, 124 insertions(+), 86 deletions(-)
> > 
> > Index: linux/drivers/acpi/device_pm.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/device_pm.c
> > +++ linux/drivers/acpi/device_pm.c
> > @@ -23,7 +23,9 @@
> >   */
> >  
> >  #include <linux/device.h>
> > +#include <linux/export.h>
> >  #include <linux/mutex.h>
> > +#include <linux/pm_qos.h>
> >  
> >  #include <acpi/acpi.h>
> >  #include <acpi/acpi_bus.h>
> > @@ -89,3 +91,108 @@ acpi_status acpi_remove_pm_notifier(stru
> >  	mutex_unlock(&acpi_pm_notifier_lock);
> >  	return status;
> >  }
> > +
> > +/**
> > + * acpi_device_power_state - Get preferred power state of ACPI device.
> > + * @dev: Device whose preferred target power state to return.
> > + * @adev: ACPI device node corresponding to @dev.
> > + * @target_state: System state to match the resultant device state.
> > + * @d_max_in: Deepest low-power state to take into consideration.
> > + * @d_min_p: Location to store the upper limit of the allowed states range.
> > + * Return value: Preferred power state of the device on success, -ENODEV
> > + * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
> > + *
> > + * Find the lowest power (highest number) ACPI device power state that the
> > + * device can be in while the system is in the state represented by
> > + * @target_state.  If @d_min_p is set, the highest power (lowest number) device
> > + * power state that @dev can be in for the given system sleep state is stored
> > + * at the location pointed to by it.
> > + *
> > + * Callers must ensure that @dev and @adev are valid pointers and that @adev
> > + * actually corresponds to @dev before using this function.
> > + */
> > +int acpi_device_power_state(struct device *dev, struct acpi_device *adev,
> > +			    u32 target_state, int d_max_in, int *d_min_p)
> > +{
> > +	char acpi_method[] = "_SxD";
> > +	unsigned long long d_min, d_max;
> > +	bool wakeup = false;
> > +
> > +	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3)
> > +		return -EINVAL;
> > +
> > +	if (d_max_in > ACPI_STATE_D3_HOT) {
> > +		enum pm_qos_flags_status stat;
> > +
> > +		stat = dev_pm_qos_flags(dev, PM_QOS_FLAG_NO_POWER_OFF);
> > +		if (stat == PM_QOS_FLAGS_ALL)
> > +			d_max_in = ACPI_STATE_D3_HOT;
> > +	}
> > +
> > +	acpi_method[2] = '0' + target_state;
> > +	/*
> > +	 * If the sleep state is S0, the lowest limit from ACPI is D3,
> > +	 * but if the device has _S0W, we will use the value from _S0W
> > +	 * as the lowest limit from ACPI.  Finally, we will constrain
> > +	 * the lowest limit with the specified one.
> > +	 */
> > +	d_min = ACPI_STATE_D0;
> > +	d_max = ACPI_STATE_D3;
> > +
> > +	/*
> > +	 * If present, _SxD methods return the minimum D-state (highest power
> > +	 * state) we can use for the corresponding S-states.  Otherwise, the
> > +	 * minimum D-state is D0 (ACPI 3.x).
> > +	 *
> > +	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
> > +	 * provided -- that's our fault recovery, we ignore retval.
> > +	 */
> > +	if (target_state > ACPI_STATE_S0) {
> > +		acpi_evaluate_integer(adev->handle, acpi_method, NULL, &d_min);
> > +		wakeup = device_may_wakeup(dev) && adev->wakeup.flags.valid
> > +			&& adev->wakeup.sleep_state >= target_state;
> > +	} else if (dev_pm_qos_flags(dev, PM_QOS_FLAG_REMOTE_WAKEUP) !=
> > +			PM_QOS_FLAGS_NONE) {
> > +		wakeup = adev->wakeup.flags.valid;
> > +	}
> > +
> > +	/*
> > +	 * If _PRW says we can wake up the system from the target sleep state,
> > +	 * the D-state returned by _SxD is sufficient for that (we assume a
> > +	 * wakeup-aware driver if wake is set).  Still, if _SxW exists
> > +	 * (ACPI 3.x), it should return the maximum (lowest power) D-state that
> > +	 * can wake the system.  _S0W may be valid, too.
> > +	 */
> > +	if (wakeup) {
> > +		acpi_status status;
> > +
> > +		acpi_method[3] = 'W';
> > +		status = acpi_evaluate_integer(adev->handle, acpi_method, NULL,
> > +						&d_max);
> > +		if (ACPI_FAILURE(status)) {
> > +			if (target_state != ACPI_STATE_S0 ||
> > +			    status != AE_NOT_FOUND)
> > +				d_max = d_min;
> > +		} else if (d_max < d_min) {
> > +			/* Warn the user of the broken DSDT */
> > +			printk(KERN_WARNING "ACPI: Wrong value from %s\n",
> > +				acpi_method);
> > +			/* Sanitize it */
> > +			d_min = d_max;
> > +		}
> > +	}
> > +
> > +	if (d_max_in < d_min)
> > +		return -EINVAL;
> > +	if (d_min_p)
> > +		*d_min_p = d_min;
> > +	/* constrain d_max with specified lowest limit (max number) */
> > +	if (d_max > d_max_in) {
> > +		for (d_max = d_max_in; d_max > d_min; d_max--) {
> > +			if (adev->power.states[d_max].flags.valid)
> > +				break;
> > +		}
> > +	}
> > +	return d_max;
> > +}
> > +EXPORT_SYMBOL_GPL(acpi_device_power_state);
> > Index: linux/drivers/acpi/sleep.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/sleep.c
> > +++ linux/drivers/acpi/sleep.c
> > @@ -19,7 +19,6 @@
> >  #include <linux/acpi.h>
> >  #include <linux/module.h>
> >  #include <linux/pm_runtime.h>
> > -#include <linux/pm_qos.h>
> >  
> >  #include <asm/io.h>
> >  
> > @@ -706,101 +705,20 @@ int acpi_suspend(u32 acpi_state)
> >   * Return value: Preferred power state of the device on success, -ENODEV
> >   * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
> >   *
> > - * Find the lowest power (highest number) ACPI device power state that the
> > - * device can be in while the system is in the sleep state represented
> > - * by %acpi_target_sleep_state.  If @d_min_p is set, the highest power (lowest
> > - * number) device power state that @dev can be in for the given system sleep
> > - * state is stored at the location pointed to by it.
> > - *
> >   * The caller must ensure that @dev is valid before using this function.
> >   */
> >  int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
> >  {
> >  	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
> >  	struct acpi_device *adev;
> > -	char acpi_method[] = "_SxD";
> > -	unsigned long long d_min, d_max;
> > -	bool wakeup = false;
> >  
> > -	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3)
> > -		return -EINVAL;
> >  	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
> > -		printk(KERN_DEBUG "ACPI handle has no context!\n");
> > +		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
> >  		return -ENODEV;
> >  	}
> > -	if (d_max_in > ACPI_STATE_D3_HOT) {
> > -		enum pm_qos_flags_status stat;
> > -
> > -		stat = dev_pm_qos_flags(dev, PM_QOS_FLAG_NO_POWER_OFF);
> > -		if (stat == PM_QOS_FLAGS_ALL)
> > -			d_max_in = ACPI_STATE_D3_HOT;
> > -	}
> > -
> > -	acpi_method[2] = '0' + acpi_target_sleep_state;
> > -	/*
> > -	 * If the sleep state is S0, the lowest limit from ACPI is D3,
> > -	 * but if the device has _S0W, we will use the value from _S0W
> > -	 * as the lowest limit from ACPI.  Finally, we will constrain
> > -	 * the lowest limit with the specified one.
> > -	 */
> > -	d_min = ACPI_STATE_D0;
> > -	d_max = ACPI_STATE_D3;
> >  
> > -	/*
> > -	 * If present, _SxD methods return the minimum D-state (highest power
> > -	 * state) we can use for the corresponding S-states.  Otherwise, the
> > -	 * minimum D-state is D0 (ACPI 3.x).
> > -	 *
> > -	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
> > -	 * provided -- that's our fault recovery, we ignore retval.
> > -	 */
> > -	if (acpi_target_sleep_state > ACPI_STATE_S0) {
> > -		acpi_evaluate_integer(handle, acpi_method, NULL, &d_min);
> > -		wakeup = device_may_wakeup(dev) && adev->wakeup.flags.valid
> > -			&& adev->wakeup.sleep_state >= acpi_target_sleep_state;
> > -	} else if (dev_pm_qos_flags(dev, PM_QOS_FLAG_REMOTE_WAKEUP) !=
> > -			PM_QOS_FLAGS_NONE) {
> > -		wakeup = adev->wakeup.flags.valid;
> > -	}
> > -
> > -	/*
> > -	 * If _PRW says we can wake up the system from the target sleep state,
> > -	 * the D-state returned by _SxD is sufficient for that (we assume a
> > -	 * wakeup-aware driver if wake is set).  Still, if _SxW exists
> > -	 * (ACPI 3.x), it should return the maximum (lowest power) D-state that
> > -	 * can wake the system.  _S0W may be valid, too.
> > -	 */
> > -	if (wakeup) {
> > -		acpi_status status;
> > -
> > -		acpi_method[3] = 'W';
> > -		status = acpi_evaluate_integer(handle, acpi_method, NULL,
> > -						&d_max);
> > -		if (ACPI_FAILURE(status)) {
> > -			if (acpi_target_sleep_state != ACPI_STATE_S0 ||
> > -			    status != AE_NOT_FOUND)
> > -				d_max = d_min;
> > -		} else if (d_max < d_min) {
> > -			/* Warn the user of the broken DSDT */
> > -			printk(KERN_WARNING "ACPI: Wrong value from %s\n",
> > -				acpi_method);
> > -			/* Sanitize it */
> > -			d_min = d_max;
> > -		}
> > -	}
> > -
> > -	if (d_max_in < d_min)
> > -		return -EINVAL;
> > -	if (d_min_p)
> > -		*d_min_p = d_min;
> > -	/* constrain d_max with specified lowest limit (max number) */
> > -	if (d_max > d_max_in) {
> > -		for (d_max = d_max_in; d_max > d_min; d_max--) {
> > -			if (adev->power.states[d_max].flags.valid)
> > -				break;
> > -		}
> > -	}
> > -	return d_max;
> > +	return acpi_device_power_state(dev, adev, acpi_target_sleep_state,
> > +				       d_max_in, d_min_p);
> >  }
> >  EXPORT_SYMBOL(acpi_pm_device_sleep_state);
> >  #endif /* CONFIG_PM */
> > Index: linux/include/acpi/acpi_bus.h
> > ===================================================================
> > --- linux.orig/include/acpi/acpi_bus.h
> > +++ linux/include/acpi/acpi_bus.h
> > @@ -419,6 +419,8 @@ acpi_status acpi_add_pm_notifier(struct
> >  				 acpi_notify_handler handler, void *context);
> >  acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
> >  				    acpi_notify_handler handler);
> > +int acpi_device_power_state(struct device *dev, struct acpi_device *adev,
> > +			    u32 target_state, int d_max_in, int *d_min_p);
> >  int acpi_pm_device_sleep_state(struct device *, int *, int);
> >  #else
> >  static inline acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
> > @@ -432,12 +434,23 @@ static inline acpi_status acpi_remove_pm
> >  {
> >  	return AE_SUPPORT;
> >  }
> > -static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
> > +static inline int __acpi_device_power_state(int m, int *p)
> >  {
> >  	if (p)
> >  		*p = ACPI_STATE_D0;
> >  	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
> >  }
> > +static inline int acpi_device_power_state(struct device *dev,
> > +					  struct acpi_device *adev,
> > +					  u32 target_state, int d_max_in,
> > +					  int *d_min_p)
> > +{
> > +	return __acpi_device_power_state(d_max_in, d_min_p);
> > +}
> > +static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
> > +{
> > +	return __acpi_device_power_state(m, p);
> > +}
> >  #endif
> >  
> >  #ifdef CONFIG_PM_RUNTIME
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

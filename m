Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1BOSXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:23:25 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:34049 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534Ab1BOSXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:23:24 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 1/2] PM: Add support for device power domains
Organization: Texas Instruments, Inc.
References: <201101300107.19389.rjw@sisk.pl> <201102011939.49793.rjw@sisk.pl>
	<201102122312.26545.rjw@sisk.pl> <201102122313.23398.rjw@sisk.pl>
Date: Tue, 15 Feb 2011 10:23:16 -0800
In-Reply-To: <201102122313.23398.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 12 Feb 2011 23:13:23 +0100")
Message-ID: <87hbc5rwbv.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The platform bus type is often used to handle Systems-on-a-Chip (SoC)
> where all devices are represented by objects of type struct
> platform_device.  In those cases the same "platform" device driver
> may be used with multiple different system configurations, but the
> actions needed to put the devices it handles into a low-power state
> and back into the full-power state may depend on the design of the
> given SoC.  The driver, however, cannot possibly include all the
> information necessary for the power management of its device on all
> the systems it is used with.  Moreover, the device hierarchy in its
> current form also is not suitable for representing this kind of
> information.
>
> The patch below attempts to address this problem by introducing
> objects of type struct dev_power_domain that can be used for
> representing power domains within a SoC.  Every struct
> dev_power_domain object provides a sets of device power
> management callbacks that can be used to perform what's needed for
> device power management in addition to the operations carried out by
> the device's driver and subsystem.
>
> Namely, if a struct dev_power_domain object is pointed to by the
> pwr_domain field in a struct device, the callbacks provided by its
> ops member will be executed in addition to the corresponding
> callbacks provided by the device's subsystem and driver during all
> power transitions.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Kevin Hilman <khilman@ti.com>

Tested by converting OMAP platform_bus dev_pm_ops overrides to use this
method, and works great.

Tested-by: Kevin Hilman <khilman@ti.com>

> ---
>  Documentation/power/devices.txt |   45 +++++++++++++++++++++++++++++++++++++++-
>  drivers/base/power/main.c       |   37 ++++++++++++++++++++++++++++++++
>  drivers/base/power/runtime.c    |   19 +++++++++++++++-
>  include/linux/device.h          |    1 
>  include/linux/pm.h              |    8 +++++++
>  5 files changed, 107 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/include/linux/pm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pm.h
> +++ linux-2.6/include/linux/pm.h
> @@ -463,6 +463,14 @@ struct dev_pm_info {
>  
>  extern void update_pm_runtime_accounting(struct device *dev);
>  
> +/*
> + * Power domains provide callbacks that are executed during system suspend,
> + * hibernation, system resume and during runtime PM transitions along with
> + * subsystem-level and driver-level callbacks.
> + */
> +struct dev_power_domain {
> +	struct dev_pm_ops	ops;
> +};
>  
>  /*
>   * The PM_EVENT_ messages are also used by drivers implementing the legacy
> Index: linux-2.6/include/linux/device.h
> ===================================================================
> --- linux-2.6.orig/include/linux/device.h
> +++ linux-2.6/include/linux/device.h
> @@ -422,6 +422,7 @@ struct device {
>  	void		*platform_data;	/* Platform specific data, device
>  					   core doesn't touch it */
>  	struct dev_pm_info	power;
> +	struct dev_power_domain	*pwr_domain;
>  
>  #ifdef CONFIG_NUMA
>  	int		numa_node;	/* NUMA node this device is close to */
> Index: linux-2.6/drivers/base/power/runtime.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/runtime.c
> +++ linux-2.6/drivers/base/power/runtime.c
> @@ -168,6 +168,7 @@ static int rpm_check_suspend_allowed(str
>  static int rpm_idle(struct device *dev, int rpmflags)
>  {
>  	int (*callback)(struct device *);
> +	int (*domain_callback)(struct device *);
>  	int retval;
>  
>  	retval = rpm_check_suspend_allowed(dev);
> @@ -222,10 +223,19 @@ static int rpm_idle(struct device *dev,
>  	else
>  		callback = NULL;
>  
> -	if (callback) {
> +	if (dev->pwr_domain)
> +		domain_callback = dev->pwr_domain->ops.runtime_idle;
> +	else
> +		domain_callback = NULL;
> +
> +	if (callback || domain_callback) {
>  		spin_unlock_irq(&dev->power.lock);
>  
> -		callback(dev);
> +		if (domain_callback)
> +			retval = domain_callback(dev);
> +
> +		if (!retval && callback)
> +			callback(dev);
>  
>  		spin_lock_irq(&dev->power.lock);
>  	}
> @@ -390,6 +400,8 @@ static int rpm_suspend(struct device *de
>  		else
>  			pm_runtime_cancel_pending(dev);
>  	} else {
> +		if (dev->pwr_domain)
> +			rpm_callback(dev->pwr_domain->ops.runtime_suspend, dev);
>   no_callback:
>  		__update_runtime_status(dev, RPM_SUSPENDED);
>  		pm_runtime_deactivate_timer(dev);
> @@ -569,6 +581,9 @@ static int rpm_resume(struct device *dev
>  
>  	__update_runtime_status(dev, RPM_RESUMING);
>  
> +	if (dev->pwr_domain)
> +		rpm_callback(dev->pwr_domain->ops.runtime_resume, dev);
> +
>  	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
>  		callback = dev->bus->pm->runtime_resume;
>  	else if (dev->type && dev->type->pm && dev->type->pm->runtime_resume)
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -423,6 +423,11 @@ static int device_resume_noirq(struct de
>  	TRACE_DEVICE(dev);
>  	TRACE_RESUME(0);
>  
> +	if (dev->pwr_domain) {
> +		pm_dev_dbg(dev, state, "EARLY power domain ");
> +		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
> +	}
> +
>  	if (dev->bus && dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "EARLY ");
>  		error = pm_noirq_op(dev, dev->bus->pm, state);
> @@ -518,6 +523,11 @@ static int device_resume(struct device *
>  
>  	dev->power.in_suspend = false;
>  
> +	if (dev->pwr_domain) {
> +		pm_dev_dbg(dev, state, "power domain ");
> +		pm_op(dev, &dev->pwr_domain->ops, state);
> +	}
> +
>  	if (dev->bus) {
>  		if (dev->bus->pm) {
>  			pm_dev_dbg(dev, state, "");
> @@ -629,6 +639,11 @@ static void device_complete(struct devic
>  {
>  	device_lock(dev);
>  
> +	if (dev->pwr_domain && dev->pwr_domain->ops.complete) {
> +		pm_dev_dbg(dev, state, "completing power domain ");
> +		dev->pwr_domain->ops.complete(dev);
> +	}
> +
>  	if (dev->class && dev->class->pm && dev->class->pm->complete) {
>  		pm_dev_dbg(dev, state, "completing class ");
>  		dev->class->pm->complete(dev);
> @@ -745,6 +760,13 @@ static int device_suspend_noirq(struct d
>  	if (dev->bus && dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "LATE ");
>  		error = pm_noirq_op(dev, dev->bus->pm, state);
> +		if (error)
> +			goto End;
> +	}
> +
> +	if (dev->pwr_domain) {
> +		pm_dev_dbg(dev, state, "LATE power domain ");
> +		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
>  	}
>  
>  End:
> @@ -864,6 +886,13 @@ static int __device_suspend(struct devic
>  			pm_dev_dbg(dev, state, "legacy ");
>  			error = legacy_suspend(dev, state, dev->bus->suspend);
>  		}
> +		if (error)
> +			goto End;
> +	}
> +
> +	if (dev->pwr_domain) {
> +		pm_dev_dbg(dev, state, "power domain ");
> +		pm_op(dev, &dev->pwr_domain->ops, state);
>  	}
>  
>   End:
> @@ -976,7 +1005,15 @@ static int device_prepare(struct device
>  		pm_dev_dbg(dev, state, "preparing class ");
>  		error = dev->class->pm->prepare(dev);
>  		suspend_report_result(dev->class->pm->prepare, error);
> +		if (error)
> +			goto End;
> +	}
> +
> +	if (dev->pwr_domain && dev->pwr_domain->ops.prepare) {
> +		pm_dev_dbg(dev, state, "preparing power domain ");
> +		dev->pwr_domain->ops.prepare(dev);
>  	}
> +
>   End:
>  	device_unlock(dev);
>  
> Index: linux-2.6/Documentation/power/devices.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/devices.txt
> +++ linux-2.6/Documentation/power/devices.txt
> @@ -1,6 +1,6 @@
>  Device Power Management
>  
> -Copyright (c) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> +Copyright (c) 2010-2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
>  Copyright (c) 2010 Alan Stern <stern@rowland.harvard.edu>
>  
>  
> @@ -507,6 +507,49 @@ routines.  Nevertheless, different callb
>  situation where it actually matters.
>  
>  
> +Device Power Domains
> +--------------------
> +Sometimes devices share reference clocks or other power resources.  In those
> +cases it generally is not possible to put devices into low-power states
> +individually.  Instead, a set of devices sharing a power resource can be put
> +into a low-power state together at the same time by turning off the shared
> +power resource.  Of course, they also need to be put into the full-power state
> +together, by turning the shared power resource on.  A set of devices with this
> +property is often referred to as a power domain.
> +
> +Support for power domains is provided through the pwr_domain field of struct
> +device.  This field is a pointer to an object of type struct dev_power_domain,
> +defined in include/linux/pm.h, providing a set of power management callbacks
> +analogous to the subsystem-level and device driver callbacks that are executed
> +for the given device during all power transitions, in addition to the respective
> +subsystem-level callbacks.  Specifically, the power domain "suspend" callbacks
> +(i.e. ->runtime_suspend(), ->suspend(), ->freeze(), ->poweroff(), etc.) are
> +executed after the analogous subsystem-level callbacks, while the power domain
> +"resume" callbacks (i.e. ->runtime_resume(), ->resume(), ->thaw(), ->restore,
> +etc.) are executed before the analogous subsystem-level callbacks.  Error codes
> +returned by the "suspend" and "resume" power domain callbacks are ignored.
> +
> +Power domain ->runtime_idle() callback is executed before the subsystem-level
> +->runtime_idle() callback and the result returned by it is not ignored.  Namely,
> +if it returns error code, the subsystem-level ->runtime_idle() callback will not
> +be called and the helper function rpm_idle() executing it will return error
> +code.  This mechanism is intended to help platforms where saving device state
> +is a time consuming operation and should only be carried out if all devices
> +in the power domain are idle, before turning off the shared power resource(s).
> +Namely, the power domain ->runtime_idle() callback may return error code until
> +the pm_runtime_idle() helper (or its asychronous version) has been called for
> +all devices in the power domain (it is recommended that the returned error code
> +be -EBUSY in those cases), preventing the subsystem-level ->runtime_idle()
> +callback from being run prematurely.
> +
> +The support for device power domains is only relevant to platforms needing to
> +use the same subsystem-level (e.g. platform bus type) and device driver power
> +management callbacks in many different power domain configurations and wanting
> +to avoid incorporating the support for power domains into the subsystem-level
> +callbacks.  The other platforms need not implement it or take it into account
> +in any way.
> +
> +
>  System Devices
>  --------------
>  System devices (sysdevs) follow a slightly different API, which can be found in

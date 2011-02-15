Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1BOSRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:17:16 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:54850 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab1BOSRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:17:14 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle subsystems consistently
Organization: Texas Instruments, Inc.
References: <201101300107.19389.rjw@sisk.pl> <201102011939.49793.rjw@sisk.pl>
	<201102122312.26545.rjw@sisk.pl> <201102122314.41407.rjw@sisk.pl>
Date: Tue, 15 Feb 2011 10:10:06 -0800
In-Reply-To: <201102122314.41407.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 12 Feb 2011 23:14:41 +0100")
Message-ID: <87pqqtrwxt.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The code handling system-wide power transitions (eg. suspend-to-RAM)
> can in theory execute callbacks provided by the device's bus type,
> device type and class in each phase of the power transition.  In
> turn, the runtime PM core code only calls one of those callbacks at
> a time, preferring bus type callbacks to device type or class
> callbacks and device type callbacks to class callbacks.
>
> It seems reasonable to make them both behave in the same way in that
> respect.  Moreover, even though a device may belong to two subsystems
> (eg. bus type and device class) simultaneously, in practice power
> management callbacks for system-wide power transitions are always
> provided by only one of them (ie. if the bus type callbacks are
> defined, the device class ones are not and vice versa).  Thus it is
> possible to modify the code handling system-wide power transitions
> so that it follows the core runtime PM code (ie. treats the
> subsystem callbacks as mutually exclusive).
>
> On the other hand, the core runtime PM code will choose to execute,
> for example, a runtime suspend callback provided by the device type
> even if the bus type's struct dev_pm_ops object exists, but the
> runtime_suspend pointer in it happens to be NULL.  This is confusing,
> because it may lead to the execution of callbacks from different
> subsystems during different operations (eg. the bus type suspend
> callback may be executed during runtime suspend, while the device
> type callback will be executed during runtime resume).
>
> Make all of the power management code treat subsystem callbacks in
> a consistent way, such that:
> (1) If the device's bus type is defined (eg. dev->bus is not NULL)
>     and its pm pointer is not NULL, the callbacks from dev->bus->pm
>     will be used.
> (2) If dev->bus is NULL or dev->bus->pm is NULL, but the device's
>     device type is defined (eg. dev->type is not NULL) and its pm
>     pointer is not NULL, the callbacks from dev->type->pm will be
>     used.
> (3) If dev->bus is NULL or dev->bus->pm is NULL and dev->type is
>     NULL or dev->type->pm is NULL, the callbacks from dev->class->pm
>     will be used provided that both dev->class and dev->class->pm
>     are not NULL.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

This looks good,  consistency between system and runtime PM is a great
help to readability.

Acked-by: Kevin Hilman <khilman@ti.com>


> ---
>  Documentation/power/devices.txt |   28 +++----
>  drivers/base/power/main.c       |  141 +++++++++++++++++-----------------------
>  drivers/base/power/runtime.c    |   12 +--
>  3 files changed, 79 insertions(+), 102 deletions(-)
>
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -433,21 +433,17 @@ static int device_resume_noirq(struct de
>  		error = pm_noirq_op(dev, dev->bus->pm, state);
>  		if (error)
>  			goto End;
> -	}
> -
> -	if (dev->type && dev->type->pm) {
> +	} else if (dev->type && dev->type->pm) {
>  		pm_dev_dbg(dev, state, "EARLY type ");
>  		error = pm_noirq_op(dev, dev->type->pm, state);
>  		if (error)
>  			goto End;
> -	}
> -
> -	if (dev->class && dev->class->pm) {
> +	} else if (dev->class && dev->class->pm) {
>  		pm_dev_dbg(dev, state, "EARLY class ");
>  		error = pm_noirq_op(dev, dev->class->pm, state);
>  	}
>  
> -End:
> + End:
>  	TRACE_RESUME(error);
>  	return error;
>  }
> @@ -532,21 +528,18 @@ static int device_resume(struct device *
>  		if (dev->bus->pm) {
>  			pm_dev_dbg(dev, state, "");
>  			error = pm_op(dev, dev->bus->pm, state);
> +			goto End;
>  		} else if (dev->bus->resume) {
>  			pm_dev_dbg(dev, state, "legacy ");
>  			error = legacy_resume(dev, dev->bus->resume);
> -		}
> -		if (error)
>  			goto End;
> +		}
>  	}
>  
> -	if (dev->type) {
> -		if (dev->type->pm) {
> -			pm_dev_dbg(dev, state, "type ");
> -			error = pm_op(dev, dev->type->pm, state);
> -		}
> -		if (error)
> -			goto End;
> +	if (dev->type && dev->type->pm) {
> +		pm_dev_dbg(dev, state, "type ");
> +		error = pm_op(dev, dev->type->pm, state);
> +		goto End;
>  	}
>  
>  	if (dev->class) {
> @@ -558,6 +551,7 @@ static int device_resume(struct device *
>  			error = legacy_resume(dev, dev->class->resume);
>  		}
>  	}
> +
>   End:
>  	device_unlock(dev);
>  	complete_all(&dev->power.completion);
> @@ -644,19 +638,18 @@ static void device_complete(struct devic
>  		dev->pwr_domain->ops.complete(dev);
>  	}
>  
> -	if (dev->class && dev->class->pm && dev->class->pm->complete) {
> -		pm_dev_dbg(dev, state, "completing class ");
> -		dev->class->pm->complete(dev);
> -	}
> -
> -	if (dev->type && dev->type->pm && dev->type->pm->complete) {
> -		pm_dev_dbg(dev, state, "completing type ");
> -		dev->type->pm->complete(dev);
> -	}
> -
> -	if (dev->bus && dev->bus->pm && dev->bus->pm->complete) {
> +	if (dev->bus && dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "completing ");
> -		dev->bus->pm->complete(dev);
> +		if (dev->bus->pm->complete)
> +			dev->bus->pm->complete(dev);
> +	} else if (dev->type && dev->type->pm) {
> +		pm_dev_dbg(dev, state, "completing type ");
> +		if (dev->type->pm->complete)
> +			dev->type->pm->complete(dev);
> +	} else if (dev->class && dev->class->pm) {
> +		pm_dev_dbg(dev, state, "completing class ");
> +		if (dev->class->pm->complete)
> +			dev->class->pm->complete(dev);
>  	}
>  
>  	device_unlock(dev);
> @@ -741,27 +734,23 @@ static pm_message_t resume_event(pm_mess
>   */
>  static int device_suspend_noirq(struct device *dev, pm_message_t state)
>  {
> -	int error = 0;
> +	int error;
>  
> -	if (dev->class && dev->class->pm) {
> -		pm_dev_dbg(dev, state, "LATE class ");
> -		error = pm_noirq_op(dev, dev->class->pm, state);
> +	if (dev->bus && dev->bus->pm) {
> +		pm_dev_dbg(dev, state, "LATE ");
> +		error = pm_noirq_op(dev, dev->bus->pm, state);
>  		if (error)
> -			goto End;
> -	}
> -
> -	if (dev->type && dev->type->pm) {
> +			return error;
> +	} else if (dev->type && dev->type->pm) {
>  		pm_dev_dbg(dev, state, "LATE type ");
>  		error = pm_noirq_op(dev, dev->type->pm, state);
>  		if (error)
> -			goto End;
> -	}
> -
> -	if (dev->bus && dev->bus->pm) {
> -		pm_dev_dbg(dev, state, "LATE ");
> -		error = pm_noirq_op(dev, dev->bus->pm, state);
> +			return error;
> +	} else if (dev->class && dev->class->pm) {
> +		pm_dev_dbg(dev, state, "LATE class ");
> +		error = pm_noirq_op(dev, dev->class->pm, state);
>  		if (error)
> -			goto End;
> +			return error;
>  	}
>  
>  	if (dev->pwr_domain) {
> @@ -769,8 +758,7 @@ static int device_suspend_noirq(struct d
>  		pm_noirq_op(dev, &dev->pwr_domain->ops, state);
>  	}
>  
> -End:
> -	return error;
> +	return 0;
>  }
>  
>  /**
> @@ -857,40 +845,36 @@ static int __device_suspend(struct devic
>  		goto End;
>  	}
>  
> -	if (dev->class) {
> -		if (dev->class->pm) {
> -			pm_dev_dbg(dev, state, "class ");
> -			error = pm_op(dev, dev->class->pm, state);
> -		} else if (dev->class->suspend) {
> -			pm_dev_dbg(dev, state, "legacy class ");
> -			error = legacy_suspend(dev, state, dev->class->suspend);
> -		}
> -		if (error)
> -			goto End;
> -	}
> -
> -	if (dev->type) {
> -		if (dev->type->pm) {
> -			pm_dev_dbg(dev, state, "type ");
> -			error = pm_op(dev, dev->type->pm, state);
> -		}
> -		if (error)
> -			goto End;
> -	}
> -
>  	if (dev->bus) {
>  		if (dev->bus->pm) {
>  			pm_dev_dbg(dev, state, "");
>  			error = pm_op(dev, dev->bus->pm, state);
> +			goto Domain;
>  		} else if (dev->bus->suspend) {
>  			pm_dev_dbg(dev, state, "legacy ");
>  			error = legacy_suspend(dev, state, dev->bus->suspend);
> +			goto Domain;
>  		}
> -		if (error)
> -			goto End;
>  	}
>  
> -	if (dev->pwr_domain) {
> +	if (dev->type && dev->type->pm) {
> +		pm_dev_dbg(dev, state, "type ");
> +		error = pm_op(dev, dev->type->pm, state);
> +		goto Domain;
> +	}
> +
> +	if (dev->class) {
> +		if (dev->class->pm) {
> +			pm_dev_dbg(dev, state, "class ");
> +			error = pm_op(dev, dev->class->pm, state);
> +		} else if (dev->class->suspend) {
> +			pm_dev_dbg(dev, state, "legacy class ");
> +			error = legacy_suspend(dev, state, dev->class->suspend);
> +		}
> +	}
> +
> + Domain:
> +	if (!error && dev->pwr_domain) {
>  		pm_dev_dbg(dev, state, "power domain ");
>  		pm_op(dev, &dev->pwr_domain->ops, state);
>  	}
> @@ -985,25 +969,24 @@ static int device_prepare(struct device
>  
>  	device_lock(dev);
>  
> -	if (dev->bus && dev->bus->pm && dev->bus->pm->prepare) {
> +	if (dev->bus && dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "preparing ");
> -		error = dev->bus->pm->prepare(dev);
> +		if (dev->bus->pm->prepare)
> +			error = dev->bus->pm->prepare(dev);
>  		suspend_report_result(dev->bus->pm->prepare, error);
>  		if (error)
>  			goto End;
> -	}
> -
> -	if (dev->type && dev->type->pm && dev->type->pm->prepare) {
> +	} else if (dev->type && dev->type->pm) {
>  		pm_dev_dbg(dev, state, "preparing type ");
> -		error = dev->type->pm->prepare(dev);
> +		if (dev->type->pm->prepare)
> +			error = dev->type->pm->prepare(dev);
>  		suspend_report_result(dev->type->pm->prepare, error);
>  		if (error)
>  			goto End;
> -	}
> -
> -	if (dev->class && dev->class->pm && dev->class->pm->prepare) {
> +	} else if (dev->class && dev->class->pm) {
>  		pm_dev_dbg(dev, state, "preparing class ");
> -		error = dev->class->pm->prepare(dev);
> +		if (dev->class->pm->prepare)
> +			error = dev->class->pm->prepare(dev);
>  		suspend_report_result(dev->class->pm->prepare, error);
>  		if (error)
>  			goto End;
> Index: linux-2.6/drivers/base/power/runtime.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/runtime.c
> +++ linux-2.6/drivers/base/power/runtime.c
> @@ -214,9 +214,9 @@ static int rpm_idle(struct device *dev,
>  
>  	dev->power.idle_notification = true;
>  
> -	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
> +	if (dev->bus && dev->bus->pm)
>  		callback = dev->bus->pm->runtime_idle;
> -	else if (dev->type && dev->type->pm && dev->type->pm->runtime_idle)
> +	else if (dev->type && dev->type->pm)
>  		callback = dev->type->pm->runtime_idle;
>  	else if (dev->class && dev->class->pm)
>  		callback = dev->class->pm->runtime_idle;
> @@ -382,9 +382,9 @@ static int rpm_suspend(struct device *de
>  
>  	__update_runtime_status(dev, RPM_SUSPENDING);
>  
> -	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
> +	if (dev->bus && dev->bus->pm)
>  		callback = dev->bus->pm->runtime_suspend;
> -	else if (dev->type && dev->type->pm && dev->type->pm->runtime_suspend)
> +	else if (dev->type && dev->type->pm)
>  		callback = dev->type->pm->runtime_suspend;
>  	else if (dev->class && dev->class->pm)
>  		callback = dev->class->pm->runtime_suspend;
> @@ -584,9 +584,9 @@ static int rpm_resume(struct device *dev
>  	if (dev->pwr_domain)
>  		rpm_callback(dev->pwr_domain->ops.runtime_resume, dev);
>  
> -	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
> +	if (dev->bus && dev->bus->pm)
>  		callback = dev->bus->pm->runtime_resume;
> -	else if (dev->type && dev->type->pm && dev->type->pm->runtime_resume)
> +	else if (dev->type && dev->type->pm)
>  		callback = dev->type->pm->runtime_resume;
>  	else if (dev->class && dev->class->pm)
>  		callback = dev->class->pm->runtime_resume;
> Index: linux-2.6/Documentation/power/devices.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/devices.txt
> +++ linux-2.6/Documentation/power/devices.txt
> @@ -249,23 +249,17 @@ various phases always run after tasks ha
>  unfrozen.  Furthermore, the *_noirq phases run at a time when IRQ handlers have
>  been disabled (except for those marked with the IRQ_WAKEUP flag).
>  
> -Most phases use bus, type, and class callbacks (that is, methods defined in
> -dev->bus->pm, dev->type->pm, and dev->class->pm).  The prepare and complete
> -phases are exceptions; they use only bus callbacks.  When multiple callbacks
> -are used in a phase, they are invoked in the order: <class, type, bus> during
> -power-down transitions and in the opposite order during power-up transitions.
> -For example, during the suspend phase the PM core invokes
> -
> -	dev->class->pm.suspend(dev);
> -	dev->type->pm.suspend(dev);
> -	dev->bus->pm.suspend(dev);
> -
> -before moving on to the next device, whereas during the resume phase the core
> -invokes
> -
> -	dev->bus->pm.resume(dev);
> -	dev->type->pm.resume(dev);
> -	dev->class->pm.resume(dev);
> +All phases use bus, type, or class callbacks (that is, methods defined in
> +dev->bus->pm, dev->type->pm, or dev->class->pm).  These callbacks are mutually
> +exclusive, so if the bus provides a struct dev_pm_ops object pointed to by its
> +pm field (i.e. both dev->bus and dev->bus->pm are defined), the callbacks
> +included in that object (i.e. dev->bus->pm) will be used.  In turn, if the
> +device type provides a struct dev_pm_ops object pointed to by its pm field
> +(i.e. both dev->type and dev->type->pm are defined), the PM core will used the
> +callbacks from that object (i.e. dev->type->pm).  Finally, if the pm fields of
> +both the bus and device type objects are NULL (or those objects do not exist),
> +the callbacks provided by the class (that is, the callbacks from dev->class->pm)
> +will be used.
>  
>  These callbacks may in turn invoke device- or driver-specific methods stored in
>  dev->driver->pm, but they don't have to.

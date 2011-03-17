Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1CQH6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:58:49 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:50917 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab1CQH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:58:46 -0400
Message-ID: <4D81BF71.2070006@metafoo.de>
Date: Thu, 17 Mar 2011 08:59:45 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PWM v8 1/3] PWM: Implement a generic PWM framework
References: <1299990249-18264-1-git-send-email-bgat@billgatliff.com> <1299990249-18264-2-git-send-email-bgat@billgatliff.com>
In-Reply-To: <1299990249-18264-2-git-send-email-bgat@billgatliff.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 05:24 AM, Bill Gatliff wrote:
> Updates the existing PWM-related functions to support multiple
> and/or hotplugged PWM devices, and adds a sysfs interface.
> Moves the code to drivers/pwm.
> 
> For now, this new code can exist alongside the current PWM
> implementations; the existing implementations will be migrated
> to this new framework as time permits.  Eventually, the current
> PWM implementation will be deprecated and then expunged.
> 
> Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
> ---
>  Documentation/pwm.txt   |  276 ++++++++++++++++++++++
>  MAINTAINERS             |    8 +
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    2 +
>  drivers/pwm/Kconfig     |   10 +
>  drivers/pwm/Makefile    |    4 +
>  drivers/pwm/pwm.c       |  594 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm/pwm.h |  140 +++++++++++
>  8 files changed, 1036 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/pwm.txt
>  create mode 100644 drivers/pwm/Kconfig
>  create mode 100644 drivers/pwm/Makefile
>  create mode 100644 drivers/pwm/pwm.c
>  create mode 100644 include/linux/pwm/pwm.h
> 
> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> new file mode 100644
> index 0000000..6a0c95d
> --- /dev/null
> +++ b/Documentation/pwm.txt
> @@ -0,0 +1,276 @@
> +                       Generic PWM Device API
> +
> +                          February 7, 2011
> +                            Bill Gatliff
> +                        <bgat@billgatliff.com>
> +
> +
> +
> +The code in drivers/pwm and include/linux/pwm/ implements an API for
> +applications involving pulse-width-modulation signals.  This document
> +describes how the API implementation facilitates both PWM-generating
> +devices, and users of those devices.
> +
> +
> +Motivation
> +
> +The primary goals for implementing the "generic PWM API" are to
> +consolidate the various PWM implementations within a consistent and
> +redundancy-reducing framework, and to facilitate the use of
> +hotpluggable PWM devices.
> +
> +Previous PWM-related implementations within the Linux kernel achieved
> +their consistency via cut-and-paste, but did not need to (and didn't)
> +facilitate more than one PWM-generating device within the system---
> +hotplug or otherwise.  The Generic PWM Device API might be most
> +appropriately viewed as an update to those implementations, rather
> +than a complete rewrite.
> +
> +
> +Challenges
> +
> +One of the difficulties in implementing a generic PWM framework is the
> +fact that pulse-width-modulation applications involve real-world
> +signals, which often must be carefully managed to prevent destruction
> +of hardware that is linked to those signals.  A DC motor that
> +experiences a brief interruption in the PWM signal controlling it
> +might destructively overheat; it could suddenly change speed, losing
> +synchronization with a sensor; it could even suddenly change direction
> +or torque, breaking the mechanical device connected to it.
> +
> +(A generic PWM device framework is not directly responsible for
> +preventing the above scenarios: that responsibility lies with the
> +hardware designer, and the application and driver authors.  But it
> +must to the greatest extent possible make it easy to avoid such
> +problems).
> +
> +A generic PWM device framework must accommodate the substantial
> +differences between available PWM-generating hardware devices, without
> +becoming sub-optimal for any of them.
> +
> +Finally, a generic PWM device framework must be relatively
> +lightweight, computationally speaking.  Some PWM users demand
> +high-speed outputs, plus the ability to regulate those outputs
> +quickly.  A device framework must be able to "keep up" with such
> +hardware, while still leaving time to do real work.
> +
> +The Generic PWM Device API is an attempt to meet all of the above
> +requirements.  At its initial publication, the API was already in use
> +managing small DC motors, sensors and solenoids through a
> +custom-designed, optically-isolated H-bridge driver.
> +
> +
> +Functional Overview
> +
> +The Generic PWM Device API framework is implemented in
> +include/linux/pwm/pwm.h and drivers/pwm/pwm.c.  The functions therein
> +use information from pwm_device and pwm_config structures to invoke
> +services in PWM peripheral device drivers.  Consult
> +drivers/pwm/atmel-pwmc.c for an example driver for the Atmel PWMC
> +peripheral.
> +
> +There are two classes of adopters of the PWM framework:
> +
> +  Users -- those wishing to employ the API merely to produce PWM
> +  signals; once they have identified the appropriate physical output
> +  on the platform in question, they don't care about the details of
> +  the underlying hardware
> +
> +  Driver authors -- those wishing to bind devices that can generate
> +  PWM signals to the Generic PWM Device API, so that the services of
> +  those devices become available to users. Assuming the hardware can
> +  support the needs of a user, driver authors don't care about the
> +  details of the user's application
> +
> +Generally speaking, users will first invoke pwm_request() to obtain a
> +handle to a PWM device.  They will then pass that handle to functions
> +like pwm_duty_ns() and pwm_period_ns() to set the duty cycle and
> +period of the PWM signal, respectively.  They will also invoke
> +pwm_start() and pwm_stop() to turn the signal on and off.
> +
> +The Generic PWM API framework also provides a sysfs interface to PWM
> +devices, which is adequate for basic application needs and testing.
> +
> +Driver authors fill out a pwm_device_ops structure, which describes
> +the capabilities of the PWM hardware being utilized.  They then invoke
> +pwm_register() (usually from within their device's probe() handler) to
> +make the PWM API aware of their device.  The framework will call back
> +to the methods described in the pwm_device_ops structure as users
> +begin to configure and utilize the hardware.
> +
> +Many PWM-capable peripherals provide two, three, or more channels of
> +PWM output.  The driver author calls pwm_register() once for each
> +channel they wish to be supported by the Generic PWM API.
> +
> +Note that PWM signals can be produced by a variety of peripherals,
> +beyond the true PWM peripherals offered by many system-on-chip
> +devices.  Other possibilities include timer/counters with
> +compare-match capabilities, carefully-programmed synchronous serial
> +ports (e.g. SPI), and GPIO pins driven by kernel interval timers.
> +With a proper pwm_device structure, these devices and pseudo-devices
> +can be accommodated by the Generic PWM Device API framework.
> +
> +The following paragraphs describe the basic functions provided by the
> +Generic PWM API framework.  See the kerneldoc in drivers/pwm/pwm.c for
> +the most detailed documentation.
> +
> +
> +Using the API to Generate PWM Signals -- Basic Kernel Functions
> +
> +pwm_request() -- Returns a pwm_device pointer, which is subsequently
> +passed to the other user-related PWM functions.  Once requested, a PWM
> +channel is marked as in-use and subsequent requests prior to
> +pwm_release() will fail.
> +
> +The names used to refer to PWM devices are defined by driver authors.
> +Typically they are platform device bus identifiers, and this
> +convention is encouraged for consistency.
> +
> +pwm_release() -- Marks a PWM channel as no longer in use.  The PWM
> +device is stopped before it is released by the API.
> +
> +pwm_period_ns() -- Specifies the PWM signal's period, in nanoseconds.
> +
> +pwm_duty_ns() -- Specifies the PWM signal's active duration, in nanoseconds.
> +
> +pwm_duty_percent() -- Specifies the PWM signal's active duration, as a
> +percentage of the current period of the signal.  NOTE: this value is
> +not recalculated if the period of the signal is subsequently changed.
> +
> +pwm_start(), pwm_stop() -- Turns the PWM signal on and off.  Except
> +where stated otherwise by a driver author, signals are stopped at the
> +end of the current period, at which time the output is set to its
> +inactive state.
> +
> +pwm_polarity() -- Defines whether the PWM signal output's active
> +region is "1" or "0".  A 10% duty-cycle, polarity=1 signal will
> +conventionally be at 5V (or 3.3V, or 1000V, or whatever the platform
> +hardware does) for 10% of the period.  The same configuration of a
> +polarity=0 signal will be at 5V (or 3.3V, or ...) for 90% of the
> +period.
> +
> +
> +Using the Sysfs Interface to Generate PWM Signals from Userspace
> +
> +The Generic PWM API provides the following attributes under
> +/sys/class/pwm/<device>/ to allow user applications to control
> +and/or monitor PWM signal generation.  Except for the 'export'
> +attribute, all attributes are read-only if the PWM device is not
> +exported to userspace.
> +
> +export (rw) -- write a label to this attribute to request that the PWM
> +device be exported to userspace; returns the length of the label on
> +success (for compatibilty with echo/cat), or -EBUSY if the device is
> +already in use by the kernel or has already been exported to
> +userspace. Read from this attribute to obtain the label of the current
> +PWM device owner, if any.
> +
> +unexport (w) -- write a non-null string to this attribute to release
> +the PWM device; the device then becomes available for reexport and/or
> +requests.  Returns -EBUSY if the device is not currently exported,
> +-EINVAL if the device is not currently in use, or the length of the
> +string on success.
> +
> +polarity (rw) -- write an ascii '1' to set active high, or a '0' for
> +active low.  Read to obtain the current polarity.
> +
> +period_ns (rw) -- write an ascii decimal number to set the period of
> +the PWM device, in nanoseconds.  Value written must not be less than
> +duty_ns or -EINVAL is returned.  Read to determine the current period
> +of the PWM device, which might be slightly different than the value
> +requested due to hardware limitations.
> +
> +duty_ns (rw) -- write an ascii decimal number to set the duration of
> +the active portion of the PWM period, in nanoseconds; value written
> +must not exceed period_ns.  Read to obtain current duty_ns, which may
> +be slightly different than the value requested due to hardware
> +limitations.
> +
> +tick_hz (r) -- indicates the base tick rate of the underlying
> +hardware, in nanoseconds.  Returns '0' if the rate is not yet known,
> +which might be the case if the device has not been requested yet (some
> +drivers don't initialize this value until the hardware is requested,
> +because the value is dynamic).
> +
> +run (rw) -- write '1' to start PWM signal generation, '0' to stop.
> +Read to determine whether the PWM device is running or not.
> +
> +
> +Using the API to Generate PWM Signals -- Advanced Functions
> +
> +pwm_config() -- Passes a pwm_config structure to the associated device
> +driver.  This function is invoked by pwm_start(), pwm_duty_ns(),
> +etc. and is one of two main entry points to the PWM driver for the
> +hardware being used.  The configuration change is guaranteed atomic if
> +multiple configuration changes are specified by the config structure.
> +This function might sleep, depending on what the device driver has to
> +do to satisfy the request.  All PWM device drivers must support this
> +entry point.
> +
> +pwm_config_nosleep() -- Passes a pwm_config structure to the
> +associated device driver.  If the driver must sleep in order to
> +implement the requested configuration change, -EWOULDBLOCK is
> +returned.  Users may call this function from interrupt handlers, timer
> +handlers, and other interrupt contexts, but must confine their
> +configuration changes to only those that the driver can implement
> +without sleeping.  This is the other main entry point into the PWM
> +hardware driver, but not all device drivers support this entry point.
> +
> +pwm_synchronize(), pwm_unsynchronize() -- "Synchronizes" two or more
> +PWM channels, if the underlying hardware permits.  (If it doesn't, the
> +framework facilitates emulating this capability but it is not yet
> +implemented).  Synchronized channels will start and stop
> +simultaneously when any single channel in the group is started or
> +stopped.  Use pwm_unsynchronize(..., NULL) to completely detach a
> +channel from any other synchronized channels.  By default, all PWM
> +channels are unsynchronized.
> +
> +
> +Implementing a PWM Device API Driver -- Functions for Driver Authors
> +
> +
> +request -- (optional) Invoked each time a user requests a channel.
> +Use to turn on clocks, clean up register states, etc.  The framework
> +takes care of device locking/unlocking; you will see only successful
> +requests.
> +
> +release -- (optional) Invoked each time a user relinquishes a channel.
> +The framework will have already stopped, unsynchronized and un-handled
> +the channel.  Use to turn off clocks, etc. as necessary.
> +
> +config -- Invoked to change the device configuration, always from a
> +sleep-compatible context.  All the changes indicated must be performed
> +atomically, ideally synchronized to an end-of-period event (so that
> +you avoid short or long output pulses).  You may sleep, etc. as
> +necessary within this function.
> +
> +config_nosleep -- (optional) Invoked to change device configuration
> +from within a context that is not allowed to sleep.  If you cannot
> +perform the requested configuration changes without sleeping, return
> +-EWOULDBLOCK.
> +
> +
> +FAQs and Additional Notes
> +
> +The Atmel PWMC pwm_config() function tries to satisfy the user's
> +configuration request by first invoking pwm_config_nosleep().  If that
> +operation fails, then the PWM peripheral is brought to a synchronized
> +stop, the configuration changes are made, and the device is restarted.
> +
> +The Atmel PWMC's use of pwm_config_nosleep() from pwm_config()
> +minimizes redundant code between the two functions, and relieves the
> +pwm_config() function of the need to explicitly test whether a
> +requested configuration change can be carried out while the PWM device
> +is in its current mode.
> +
> +PWM API driver authors are encouraged to adopt the Atmel PWMC's
> +pwm_config()-vs.-pwm_config_nosleep() strategy in implementations for
> +other devices as well.
> +
> +
> +Acknowledgements
> +
> +The author expresses his gratitude to the countless developers who
> +have reviewed and submitted feedback on the various versions of the
> +Generic PWM Device API code, and those who have submitted drivers and
> +applications that use the framework.  You know who you are.  ;)
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 560ecce..c9f7f3a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5041,6 +5041,14 @@ S:	Maintained
>  F:	Documentation/video4linux/README.pvrusb2
>  F:	drivers/media/video/pvrusb2/
>  
> +PWM DEVICE API
> +M:	Bill Gatliff <bgat@billgatliff.com>
> +L:	linux-embedded@vger.kernel.org
> +T:	git git://git.billgatliff.com/pwm.git
> +S:	Maintained
> +F:	Documentation/pwm.txt
> +F:	drivers/pwm/
> +
>  PXA2xx/PXA3xx SUPPORT
>  M:	Eric Miao <eric.y.miao@gmail.com>
>  M:	Russell King <linux@arm.linux.org.uk>
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 9bfb71f..413e4f9 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -56,6 +56,8 @@ source "drivers/pps/Kconfig"
>  
>  source "drivers/gpio/Kconfig"
>  
> +source "drivers/pwm/Kconfig"
> +
>  source "drivers/w1/Kconfig"
>  
>  source "drivers/power/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index b423bb1..4e37abf 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -6,6 +6,8 @@
>  #
>  
>  obj-y				+= gpio/
> +obj-$(CONFIG_GENERIC_PWM)	+= pwm/
> +
>  obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> new file mode 100644
> index 0000000..bc550f7
> --- /dev/null
> +++ b/drivers/pwm/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# PWM infrastructure and devices
> +#
> +
> +menuconfig GENERIC_PWM
> +	tristate "PWM Support"
> +	help
> +	  Enables PWM device support implemented via a generic
> +	  framework.  If unsure, say N.
> +
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> new file mode 100644
> index 0000000..7baa201
> --- /dev/null
> +++ b/drivers/pwm/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for pwm devices
> +#
> +obj-$(CONFIG_GENERIC_PWM) := pwm.o
> diff --git a/drivers/pwm/pwm.c b/drivers/pwm/pwm.c
> new file mode 100644
> index 0000000..18c511b
> --- /dev/null
> +++ b/drivers/pwm/pwm.c
> @@ -0,0 +1,594 @@
> +/*
> + * PWM API implementation
> + *
> + * Copyright (C) 2011 Bill Gatliff <bgat@billgatliff.com>
> + * Copyright (C) 2011 Arun Murthy <arun.murthy@stericsson.com>
> + *
> + * This program is free software; you may redistribute and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
> + * USA
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/fs.h>
> +#include <linux/completion.h>
> +#include <linux/workqueue.h>
> +#include <linux/list.h>
> +#include <linux/sched.h>
> +#include <linux/pwm/pwm.h>

completion.h, workqueue.h, list.h and sched.h are not used.

> +
> +static const char *REQUEST_SYSFS = "sysfs";
> +static DEFINE_MUTEX(device_list_mutex);
I still think the mutex can go away, see my previous mail on how it can be done.

> +static struct class pwm_class;
> +
> +void pwm_set_drvdata(struct pwm_device *p, void *data)
> +{
> +	dev_set_drvdata(&p->dev, data);
> +}
> +EXPORT_SYMBOL(pwm_set_drvdata);
> +
> +void *pwm_get_drvdata(const struct pwm_device *p)
> +{
> +	return dev_get_drvdata(&p->dev);
> +}
> +EXPORT_SYMBOL(pwm_get_drvdata);
> +
> +static inline struct pwm_device *to_pwm_device(struct device *dev)
> +{
> +	return container_of(dev, struct pwm_device, dev);
> +}
> +
> +static int pwm_match_name(struct device *dev, void *name)
> +{
> +	return !strcmp(name, dev_name(dev));
> +}
> +
> +static int __pwm_request(struct pwm_device *p, const char *label)
> +{
> +	int ret;
> +
> +	if (!try_module_get(p->ops->owner))
> +		return -ENODEV;
> +
> +	ret = test_and_set_bit(PWM_FLAG_REQUESTED, &p->flags);
> +	if (ret) {
> +		ret = -EBUSY;
> +		goto err_flag_requested;
> +	}
> +
> +	p->label = label;
> +
> +	if (p->ops->request) {
> +		ret = p->ops->request(p);
> +		if (ret)
> +			goto err_request_ops;
> +			
> +	}
> +
> +	return 0;
> +
> +err_request_ops:
> +	clear_bit(PWM_FLAG_REQUESTED, &p->flags);
> +
> +err_flag_requested:
> +	module_put(p->ops->owner);
> +	return ret;
> +}
> +
> +static struct pwm_device *__pwm_request_byname(const char *name,
> +					       const char *label)
> +{
> +	struct device *d;
> +	struct pwm_device *p;
> +	int ret;
> +
> +	d = class_find_device(&pwm_class, NULL, (char*)name, pwm_match_name);
> +	if (IS_ERR_OR_NULL(d))
class_find_device will only return NULL or the device.

> +		return ERR_PTR(-EINVAL);
> +
> +	p = to_pwm_device(d);
> +	ret = __pwm_request(p, label);
> +
> +	if (ret)

You need to drop the reference to d which was taken by class_find_device:
		put_device(d);

> +		return ERR_PTR(ret);
> +	return p;
> +}
> +
> +/**
> + * pwm_request - request a PWM device by name
> + *
> + * @name: name of PWM device
> + * @label: label that identifies requestor
> + *
> + * The @name format is driver-specific, but is typically of the form
> + * "<bus_id>:<chan>".  For example, "atmel_pwmc:1" identifies the
> + * second ATMEL PWMC peripheral channel.
> + *
> + * Returns a pointer to the requested PWM device on success, -EINVAL
> + * otherwise.
> + */
> +struct pwm_device *pwm_request(const char *name, const char *label)
> +{
> +	struct pwm_device *p;
> +
> +	mutex_lock(&device_list_mutex);
> +	p = __pwm_request_byname(name, label);

__pwm_request_byname is only ever used here. In my opinion it makes sense to
simply move its code here.


> +	mutex_unlock(&device_list_mutex);
> +	return p;
> +}
> +EXPORT_SYMBOL(pwm_request);
> +
> +/**
> + * pwm_release - releases a previously-requested PWM channel
> + *
> + * @p: PWM device to release
> + */
> +void pwm_release(struct pwm_device *p)
> +{
> +	mutex_lock(&device_list_mutex);
> +
> +	if (!test_and_clear_bit(PWM_FLAG_REQUESTED, &p->flags)) {
> +		WARN(1, "%s: releasing unrequested PWM device %s\n",
> +		     __func__, dev_name(&p->dev));
> +		goto done;
> +	}
> +
> +	pwm_stop(p);
> +	pwm_unsynchronize(p, NULL);
> +	p->label = NULL;
> +
> +	if (p->ops->release)
> +		p->ops->release(p);
> +
> +	put_device(&p->dev);
> +	module_put(p->ops->owner);
> +
> +done:
> +	mutex_unlock(&device_list_mutex);
> +}
> +EXPORT_SYMBOL(pwm_release);
> +
...

> +
> +static ssize_t pwm_period_ns_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	struct pwm_device *p = to_pwm_device(dev);
> +	return sprintf(buf, "%lu\n", pwm_get_period_ns(p));
> +}
> +
> +static ssize_t pwm_period_ns_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t len)
> +{
> +	unsigned long period_ns;
> +	struct pwm_device *p = to_pwm_device(dev);
> +
> +	if (!pwm_is_exported(p))
> +		return -EPERM;
> +
> +	if (!strict_strtoul(buf, 10, &period_ns))
> +		pwm_set_period_ns(p, period_ns);

How about returning the error from strict_strtoul like it is done for the
attributes above.

> +	return len;
> +}
> +
> +static ssize_t pwm_polarity_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct pwm_device *p = to_pwm_device(dev);
> +	return sprintf(buf, "%d\n", p->polarity ? 1 : 0);
> +}
> +
> +static ssize_t pwm_polarity_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	unsigned long polarity;
> +	struct pwm_device *p = to_pwm_device(dev);
> +
> +	if (!pwm_is_exported(p))
> +		return -EPERM;
> +
> +	if (!strict_strtoul(buf, 10, &polarity))
> +		pwm_set_polarity(p, polarity);

Same here. But maybe it would be best just to accept '0' or '1'.

> +	return len;
> +}
> +
> +static ssize_t pwm_export_show(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	struct pwm_device *p = to_pwm_device(dev);
> +
> +	if (pwm_is_exported(p))
> +		return sprintf(buf, "%s\n", p->label);
> +	else if (pwm_is_requested(p))
> +		return -EBUSY;

This still looks strange. If pwm_is_exported is true label will always be
"sysfs". And it also doesn't match with the description from the documentation.


> +	return 0;
> +}
> +
> +static ssize_t pwm_export_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t len)
> +{
> +	struct pwm_device *p = to_pwm_device(dev);
> +	int ret;
> +
> +	mutex_lock(&device_list_mutex);
> +	if (pwm_is_exported(p))
> +		ret = -EBUSY;
> +	else
> +		ret = __pwm_request(p, REQUEST_SYSFS);

Just ret = __pwm_request(p, REQUEST_SYSFS); should be enough. If
pwm_is_exported is true __pwm_request will return -EBUSY because
PWM_FLAG_REQUESTED is set.

You should also call get_device here since pwm_release is going to call put_device.

> +
> +	if (!ret)
> +		set_bit(PWM_FLAG_EXPORTED, &p->flags);
> +	mutex_unlock(&device_list_mutex);
> +
> +	return ret ? ret : len;
> +}
> +
> +static ssize_t pwm_unexport_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	struct pwm_device *p = to_pwm_device(dev);
> +
> +	if (!pwm_is_exported(p) || !pwm_is_requested(p))
> +		return -EINVAL;
> +
> +	pwm_release(p);
> +	clear_bit(PWM_FLAG_EXPORTED, &p->flags);

You should clear PWM_FLAG_EXPORTED before releasing the device.

> +	return len;
> +}
> +
> +static struct device_attribute pwm_dev_attrs[] = {
> +	__ATTR(export, S_IRUGO | S_IWUSR, pwm_export_show, pwm_export_store),
> +	__ATTR(unexport, S_IWUSR, NULL, pwm_unexport_store),
> +	__ATTR(polarity, S_IRUGO | S_IWUSR, pwm_polarity_show, pwm_polarity_store),
> +	__ATTR(period_ns, S_IRUGO | S_IWUSR, pwm_period_ns_show, pwm_period_ns_store),
> +	__ATTR(duty_ns, S_IRUGO | S_IWUSR, pwm_duty_ns_show, pwm_duty_ns_store),
> +	__ATTR(tick_hz, S_IRUGO, pwm_tick_hz_show, NULL),
> +	__ATTR(run, S_IRUGO | S_IWUSR, pwm_run_show, pwm_run_store),
> +	__ATTR_NULL,
> +};
> +
> +static struct class pwm_class = {
> +	.name		= "pwm",
> +	.owner		= THIS_MODULE,
> +	.dev_attrs	= pwm_dev_attrs,
> +};
> +
> +static void __pwm_release(struct device *dev)
> +{
> +	struct pwm_device *p = container_of(dev, struct pwm_device, dev);
> +	kfree(p);
> +}
> +
> +/**
> + * pwm_register - registers a PWM device
> + *
> + * @ops: PWM device operations
> + * @parent: reference to parent device, if any
> + * @fmt: printf-style format specifier for device name
> + */
> +struct pwm_device *pwm_register(const struct pwm_device_ops *ops,
> +				struct device *parent, const char *fmt, ...)
> +{
> +	struct pwm_device *p;
> +	int ret;
> +	va_list vargs;
> +
> +	if (!ops || !ops->config)
> +		return ERR_PTR(-EINVAL);
> +
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p)
> +		return ERR_PTR(-ENOMEM);
> +
> +	p->ops = ops;
> +
> +	p->dev.devt = MKDEV(0, 0);
devt should already be 0, since you used kzalloc.

> +	p->dev.class = &pwm_class;
> +	p->dev.parent = parent;
> +	p->dev.release = __pwm_release;
> +
> +	va_start(vargs, fmt);
> +	ret = kobject_set_name_vargs(&p->dev.kobj, fmt, vargs);
> +
> +	ret = device_register(&p->dev);
> +	if (ret)
> +		goto err;
> +
> +	return p;
> +
> +err:
> +	put_device(&p->dev);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(pwm_register);
> +
> +void pwm_unregister(struct pwm_device *p)
> +{
> +	device_unregister(&p->dev);

Hm, I wonder what to do, if pwm_unregister is called while the device is still
requested. The device struct will still be there, but all the resources used by
callbacks like memory regions and clocks and such are already going to be
freed. And all the sysfs files will be gone as well, so if the device is
request through sysfs there will be no way of freeing it. Maybe the device
should be force-released and if one of the pwm_* functions is called afterwards
it should return -ENODEV.
I wonder how other device classes deal with this.

> +}
> +EXPORT_SYMBOL(pwm_unregister);
> +
> +static int __init pwm_init(void)
> +{
> +	return class_register(&pwm_class);
> +}
> +
> +static void __exit pwm_exit(void)
> +{
> +	class_unregister(&pwm_class);
> +}
> +
> +postcore_initcall(pwm_init);
> +module_exit(pwm_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
> +MODULE_DESCRIPTION("Generic PWM device API implementation");
> diff --git a/include/linux/pwm/pwm.h b/include/linux/pwm/pwm.h
> new file mode 100644
> index 0000000..9390754
> --- /dev/null
> +++ b/include/linux/pwm/pwm.h
> @@ -0,0 +1,140 @@
> +/*
> + * Copyright (C) 2011 Bill Gatliff < bgat@billgatliff.com>
> + * Copyright (C) 2011 Arun Murthy <arun.murth@stericsson.com>
> + *
> + * This program is free software; you may redistribute and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
> + * USA
> + */
> +#ifndef __LINUX_PWM_H
> +#define __LINUX_PWM_H
> +
> +#include <linux/device.h>
> +
> +enum {
> +	PWM_FLAG_REQUESTED	= 0,
> +	PWM_FLAG_STOP		= 1,
> +	PWM_FLAG_RUNNING	= 2,
> +	PWM_FLAG_EXPORTED	= 3,
> +};
> +
> +enum {
> +	PWM_CONFIG_DUTY_TICKS	= 0,
> +	PWM_CONFIG_PERIOD_TICKS	= 1,
> +	PWM_CONFIG_POLARITY	= 2,
> +	PWM_CONFIG_START	= 3,
> +	PWM_CONFIG_STOP		= 4,
> +};
> +
> +struct pwm_config;
> +struct pwm_device;
> +
> +struct pwm_device_ops {
> +	struct module *owner;
> +
> +	int	(*request)		(struct pwm_device *p);
> +	void	(*release)		(struct pwm_device *p);
> +	int	(*config)		(struct pwm_device *p,
> +					 struct pwm_config *c);
> +	int	(*config_nosleep)	(struct pwm_device *p,
> +					 struct pwm_config *c);
> +	int	(*synchronize)		(struct pwm_device *p,
> +					 struct pwm_device *to_p);
> +	int	(*unsynchronize)	(struct pwm_device *p,
> +					 struct pwm_device *from_p);
> +};
> +
> +/**
> + * struct pwm_config - configuration data for a PWM device
> + *
> + * @config_mask: which fields are valid
> + * @duty_ticks: requested duty cycle, in ticks
> + * @period_ticks: requested period, in ticks
> + * @polarity: active high (1), or active low (0)
> + */
> +struct pwm_config {
> +	unsigned long	config_mask;
> +	unsigned long	duty_ticks;
> +	unsigned long	period_ticks;
> +	int		polarity;
> +};
> +
> +/**
> + * struct pwm_device - represents a PWM device
> + *
> + * @dev: device model reference
> + * @ops: operations supported by the PWM device
> + * @label: requestor of the PWM device, or NULL
> + * @flags: PWM device state, see FLAG_*
> + * @tick_hz: base tick rate of PWM device, in HZ
> + * @polarity: active high (1), or active low (0)
> + * @period_ticks: PWM device's current period, in ticks
> + * @duty_ticks: duration of PWM device's active cycle, in ticks
> + */
> +struct pwm_device {
> +	struct device	dev;
> +	const struct pwm_device_ops *ops;
> +	const char	*label;
> +	unsigned long	flags;
> +	unsigned long	tick_hz;
> +	int		polarity;
> +	unsigned long	period_ticks;
> +	unsigned long	duty_ticks;
> +};
> +
> +struct pwm_device *pwm_request(const char *name, const char *label);
> +void pwm_release(struct pwm_device *p);
> +
> +static inline int pwm_is_requested(const struct pwm_device *p)
> +{
> +	return test_bit(PWM_FLAG_REQUESTED, &p->flags);
> +}
> +
> +static inline int pwm_is_running(const struct pwm_device *p)
> +{
> +	return test_bit(PWM_FLAG_RUNNING, &p->flags);
> +}
> +
> +static inline int pwm_is_exported(const struct pwm_device *p)
> +{
> +	return test_bit(PWM_FLAG_EXPORTED, &p->flags);
> +}
> +
> +struct pwm_device *pwm_register(const struct pwm_device_ops *ops, struct device *parent,
> +				const char *fmt, ...);
> +void pwm_unregister(struct pwm_device *p);
> +
> +void pwm_set_drvdata(struct pwm_device *p, void *data);
> +void *pwm_get_drvdata(const struct pwm_device *p);
> +
> +int pwm_set(struct pwm_device *p, unsigned long period_ns,
> +	    unsigned long duty_ns, int polarity);
> +
> +int pwm_set_period_ns(struct pwm_device *p, unsigned long period_ns);
> +unsigned long pwm_get_period_ns(struct pwm_device *p);
> +
> +int pwm_set_duty_ns(struct pwm_device *p, unsigned long duty_ns);
> +unsigned long pwm_get_duty_ns(struct pwm_device *p);
> +
> +int pwm_set_polarity(struct pwm_device *p, int polarity);
> +
> +int pwm_start(struct pwm_device *p);
> +int pwm_stop(struct pwm_device *p);
> +
> +int pwm_config_nosleep(struct pwm_device *p, struct pwm_config *c);
> +int pwm_config(struct pwm_device *p, struct pwm_config *c);
> +
> +int pwm_synchronize(struct pwm_device *p, struct pwm_device *to_p);
> +int pwm_unsynchronize(struct pwm_device *p, struct pwm_device *from_p);
> +
> +#endif


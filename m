Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab1CFGPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 01:15:11 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65275 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab1CFGPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 01:15:07 -0500
Message-ID: <4D7326B0.6050706@metafoo.de>
Date: Sun, 06 Mar 2011 07:16:16 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com> <1299385050-13674-2-git-send-email-bgat@billgatliff.com>
In-Reply-To: <1299385050-13674-2-git-send-email-bgat@billgatliff.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 05:17 AM, Bill Gatliff wrote:
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
>  Documentation/pwm.txt   |  277 +++++++++++++++++++++
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    2 +
>  drivers/pwm/Kconfig     |   10 +
>  drivers/pwm/Makefile    |    4 +
>  drivers/pwm/pwm.c       |  610 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm/pwm.h |  155 ++++++++++++
>  7 files changed, 1060 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/pwm.txt
>  create mode 100644 drivers/pwm/Kconfig
>  create mode 100644 drivers/pwm/Makefile
>  create mode 100644 drivers/pwm/pwm.c
>  create mode 100644 include/linux/pwm/pwm.h
> 
> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> new file mode 100644
> index 0000000..2b15395
> --- /dev/null
> +++ b/Documentation/pwm.txt
> @@ -0,0 +1,277 @@
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
> +
> +Functional Overview
> +
> +The Generic PWM Device API framework is implemented in
> +include/linux/pwm/pwm.h and drivers/pwm/pwm.c.  The functions therein
> +use information from pwm_device and pwm__config structures to invoke
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
> +Driver authors fill out a pwm_device structure, which describes the
> +capabilities of the PWM hardware being utilized.  They then invoke
> +pwm_register() (usually from within their device's probe() handler) to
> +make the PWM API aware of their device.  The framework will call back
> +to the methods described in the pwm_device structure as users begin to
> +configure and utilize the hardware.
> +
> +Many PWM-capable peripherals provide two, three, or more channels of
> +PWM output.  The driver author completes and registers a pwm_device
> +structure for each channel they wish to be supported by the Generic
> +PWM API.
> +
> +Note that PWM signals can be produced by a variety of peripherals,
> +beyond the true PWM peripherals offered by many system-on-chip
> +devices.  Other possibilities include timer/counters with
> +compare-match capabilities, carefully-programmed synchronous serial
> +ports (e.g. SPI), and GPIO pins driven by kernel interval timers.
> +With a proper pwm_device structure, these devices and pseudo-devices
> +can be accommodated by the Generic PWM Device API framework.
> +
> +
> +
> +Using the API to Generate PWM Signals -- Basic Functions for Users
> +
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
> +
> +pwm_release() -- Marks a PWM channel as no longer in use.  The PWM
> +device is stopped before it is released by the API.
> +
> +
> +pwm_period_ns() -- Specifies the PWM signal's period, in nanoseconds.
> +
> +
> +pwm_duty_ns() -- Specifies the PWM signal's active duration, in nanoseconds.
> +
> +
> +pwm_duty_percent() -- Specifies the PWM signal's active duration, as a
> +percentage of the current period of the signal.  NOTE: this value is
> +not recalculated if the period of the signal is subsequently changed.
> +
> +
> +pwm_start(), pwm_stop() -- Turns the PWM signal on and off.  Except
> +where stated otherwise by a driver author, signals are stopped at the
> +end of the current period, at which time the output is set to its
> +inactive state.
> +
> +
> +pwm_polarity() -- Defines whether the PWM signal output's active
> +region is "1" or "0".  A 10% duty-cycle, polarity=1 signal will
> +conventionally be at 5V (or 3.3V, or 1000V, or whatever the platform
> +hardware does) for 10% of the period.  The same configuration of a
> +polarity=0 signal will be at 5V (or 3.3V, or ...) for 90% of the
> +period.
> +
> +
> +
> +Using the API to Generate PWM Signals -- Advanced Functions
> +
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
> +pwm_set_handler() -- Defines an end-of-period callback.  The indicated
> +function will be invoked in a worker thread at the end of each PWM
> +period, and can subsequently invoke pwm_config(), etc.  Must be used
> +with extreme care for high-speed PWM outputs.  Set the handler
> +function to NULL to un-set the handler.
> +
> +
> +
> +Implementing a PWM Device API Driver -- Functions for Driver Authors
> +
> +
> +Fill out the appropriate fields in a pwm_device structure, and submit
> +to pwm_register():
> +
> +
> +bus_id -- the plain-text name of the device.  Users will bind to a
> +channel on the device using this name plus the channel number.  For
> +example, the Atmel PWMC's bus_id is "atmel_pwmc", the same as used by
> +the platform device driver (recommended).  The first Atmel PWMC
> +platform device registered thereby receives bus_id "atmel_pwmc.0",
> +which is what you put in pwm_device.bus_id.  Channels are then named
> +"atmel_pwmc.0:[0-3]".  (Hint: just use dev_name(pdev->dev) in your
> +probe() method).
> +
> +
> +request -- (optional) Invoked each time a user requests a channel.
> +Use to turn on clocks, clean up register states, etc.  The framework
> +takes care of device locking/unlocking; you will see only successful
> +requests.
> +
> +
> +free -- (optional) Invoked each time a user relinquishes a channel.
> +The framework will have already stopped, unsynchronized and un-handled
> +the channel.  Use to turn off clocks, etc. as necessary.
> +
> +
> +set_callback -- (optional) If the hardware supports an end-of-period
> +interrupt, invoke the function provided in this callback during the
> +device's interrupt handler.  The callback function itself is always
> +internal to the API, and does not map directly to the user's callback
> +function.
> +
> +
> +config -- Invoked to change the device configuration, always from a
> +sleep-compatible context.  All the changes indicated must be performed
> +atomically, ideally synchronized to an end-of-period event (so that
> +you avoid short or long output pulses).  You may sleep, etc. as
> +necessary within this function.
> +
> +
> +config_nosleep -- (optional) Invoked to change device configuration
> +from within a context that is not allowed to sleep.  If you cannot
> +perform the requested configuration changes without sleeping, return
> +-EWOULDBLOCK.
> +
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
> +
> +Acknowledgements
> +
> +
> +The author expresses his gratitude to the countless developers who
> +have reviewed and submitted feedback on the various versions of the
> +Generic PWM Device API code, and those who have submitted drivers and
> +applications that use the framework.  You know who you are.  ;)

Two minor remarks on the documentation: You are not mentioning the functions
arguments and there is no documentation on the sysfs interface at all.

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
> index 0000000..f958e4b
> --- /dev/null
> +++ b/drivers/pwm/pwm.c
> @@ -0,0 +1,610 @@
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
> +
> +static const char *REQUEST_SYSFS = "sysfs";
> +static LIST_HEAD(pwm_device_list);
The list is not used.

> +static DEFINE_MUTEX(device_list_mutex);
> +static struct class pwm_class;
> +static struct workqueue_struct *pwm_handler_workqueue;
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
> +	ret = test_and_set_bit(FLAG_REQUESTED, &p->flags);
> +	if (ret) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	p->label = label;
> +
> +	if (p->ops->request) {
> +		ret = p->ops->request(p);
> +		if (ret) {
> +			clear_bit(FLAG_REQUESTED, &p->flags);
> +			goto done;
> +		}
> +	}
> +
> +done:
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
> +		return ERR_PTR(-EINVAL);
> +
> +	p = dev_get_drvdata(d);
> +	ret = __pwm_request(p, label);
> +
> +	if (ret)
> +		return ERR_PTR(ret);
> +	return p;
> +}
> +
> +struct pwm_device *pwm_request_byname(const char *name, const char *label)
> +{
> +	struct pwm_device *p;
> +
> +	mutex_lock(&device_list_mutex);
> +	p = __pwm_request_byname(name, label);
> +	mutex_unlock(&device_list_mutex);
> +	return p;
> +}
> +EXPORT_SYMBOL(pwm_request_byname);
> +
> +struct pwm_device *pwm_request(const char *bus_id, int id, const char *label)
> +{
> +	char name[256];
> +	int ret;
> +
> +	if (id == -1)
> +		ret = scnprintf(name, sizeof name, "%s", bus_id);

sizeof(name)

> +	else
> +		ret = scnprintf(name, sizeof name, "%s:%d", bus_id, id);
> +	if (ret <= 0 || ret >= sizeof name)
> +		return ERR_PTR(-EINVAL);
> +
> +	return pwm_request_byname(name, label);
> +}
> +EXPORT_SYMBOL(pwm_request);
> +
> +void pwm_release(struct pwm_device *p)
> +{
> +	mutex_lock(&device_list_mutex);
> +
> +	if (!test_and_clear_bit(FLAG_REQUESTED, &p->flags)) {
> +		WARN(1, "%s: releasing unrequested PWM device %s\n",
> +		     __func__, dev_name(p->dev));
> +		goto done;
> +	}
> +
> +	pwm_stop(p);
> +	pwm_unsynchronize(p, NULL);
> +	pwm_set_handler(p, NULL, NULL);
> +
> +	p->label = NULL;
> +
> +	if (p->ops->release)
> +		p->ops->release(p);
> +done:
> +	mutex_unlock(&device_list_mutex);
> +}
> +EXPORT_SYMBOL(pwm_release);
> +
> +static unsigned long pwm_ns_to_ticks(struct pwm_device *p, unsigned long nsecs)
> +{
> +	unsigned long long ticks;
> +
> +	ticks = nsecs;
> +	ticks *= p->tick_hz;
> +	do_div(ticks, 1000000000);
> +	return ticks;
> +}
> +
> +static unsigned long pwm_ticks_to_ns(struct pwm_device *p, unsigned long ticks)
> +{
> +	unsigned long long ns;
> +
> +	if (!p->tick_hz)
> +		return 0;
> +
> +	ns = ticks;
> +	ns *= 1000000000UL;
> +	do_div(ns, p->tick_hz);
> +	return ns;
> +}
> +
> +int pwm_config_nosleep(struct pwm_device *p, struct pwm_config *c)
> +{
> +	if (!p->ops->config_nosleep)
> +		return -EINVAL;

Would ENOSYS be more appropriate?

> +
> +	return p->ops->config_nosleep(p, c);
> +}
> +EXPORT_SYMBOL(pwm_config_nosleep);
> +
> +int pwm_config(struct pwm_device *p, struct pwm_config *c)
> +{
> +	int ret = 0;
> +
> +	switch (c->config_mask & (BIT(PWM_CONFIG_PERIOD_TICKS)
> +				  | BIT(PWM_CONFIG_DUTY_TICKS))) {
> +	case BIT(PWM_CONFIG_PERIOD_TICKS):
> +		if (p->duty_ticks > c->period_ticks) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +		break;
> +	case BIT(PWM_CONFIG_DUTY_TICKS):
> +		if (p->period_ticks < c->duty_ticks) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +		break;
> +	case BIT(PWM_CONFIG_DUTY_TICKS) | BIT(PWM_CONFIG_PERIOD_TICKS):
> +		if (c->duty_ticks > c->period_ticks) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +err:
> +	dev_dbg(p->dev, "%s: config_mask %lu period_ticks %lu "
> +		"duty_ticks %lu polarity %d\n",
> +		__func__, c->config_mask, c->period_ticks,
> +		c->duty_ticks, c->polarity);
> +
> +	if (ret)
> +		return ret;

This looks a bit confusing. Maybe it would be better to move the dev_dbg at the
top of the function and the 'err' label at the end of the function.


> +	return p->ops->config(p, c);
> +}
> +EXPORT_SYMBOL(pwm_config);
> +
> +int pwm_set(struct pwm_device *p, unsigned long period_ns,
> +	    unsigned long duty_ns, int active_high)
> +{
> +	struct pwm_config c = {
> +		.config_mask = (BIT(PWM_CONFIG_PERIOD_TICKS)
> +				| BIT(PWM_CONFIG_DUTY_TICKS)
> +				| BIT(PWM_CONFIG_POLARITY)),
> +		.period_ticks = pwm_ns_to_ticks(p, period_ns),
> +		.duty_ticks = pwm_ns_to_ticks(p, duty_ns),
> +		.polarity = active_high
> +	};
> +
> +	return pwm_config(p, &c);
> +}
> +EXPORT_SYMBOL(pwm_set);
> +
> +int pwm_set_period_ns(struct pwm_device *p, unsigned long period_ns)
> +{
> +	struct pwm_config c = {
> +		.config_mask = BIT(PWM_CONFIG_PERIOD_TICKS),
> +		.period_ticks = pwm_ns_to_ticks(p, period_ns),
> +	};
> +
> +	return pwm_config(p, &c);
> +}
> +EXPORT_SYMBOL(pwm_set_period_ns);
> +
> +unsigned long pwm_get_period_ns(struct pwm_device *p)
> +{
> +	return pwm_ticks_to_ns(p, p->period_ticks);
> +}
> +EXPORT_SYMBOL(pwm_get_period_ns);
> +
> +int pwm_set_duty_ns(struct pwm_device *p, unsigned long duty_ns)
> +{
> +	struct pwm_config c = {
> +		.config_mask = BIT(PWM_CONFIG_DUTY_TICKS),
> +		.duty_ticks = pwm_ns_to_ticks(p, duty_ns),
> +	};
> +	return pwm_config(p, &c);
> +}
> +EXPORT_SYMBOL(pwm_set_duty_ns);
> +
> +unsigned long pwm_get_duty_ns(struct pwm_device *p)
> +{
> +	return pwm_ticks_to_ns(p, p->duty_ticks);
> +}
> +EXPORT_SYMBOL(pwm_get_duty_ns);
> +
> +int pwm_set_polarity(struct pwm_device *p, int active_high)
> +{
> +	struct pwm_config c = {
> +		.config_mask = BIT(PWM_CONFIG_POLARITY),
> +		.polarity = active_high,
> +	};
> +	return pwm_config(p, &c);
> +}
> +EXPORT_SYMBOL(pwm_set_polarity);
> +
> +int pwm_start(struct pwm_device *p)
> +{
> +	struct pwm_config c = {
> +		.config_mask = BIT(PWM_CONFIG_START),
> +	};
> +	return pwm_config(p, &c);
> +}
> +EXPORT_SYMBOL(pwm_start);
> +
> +int pwm_stop(struct pwm_device *p)
> +{
> +	struct pwm_config c = {
> +		.config_mask = BIT(PWM_CONFIG_STOP),
> +	};
> +	return pwm_config(p, &c);
> +}
> +EXPORT_SYMBOL(pwm_stop);
> +
> +int pwm_synchronize(struct pwm_device *p, struct pwm_device *to_p)
> +{
> +	if (!p->ops->synchronize)
> +		return -EINVAL;
ENOSYS here too
> +
> +	return p->ops->synchronize(p, to_p);
> +}
> +EXPORT_SYMBOL(pwm_synchronize);
> +
> +int pwm_unsynchronize(struct pwm_device *p, struct pwm_device *from_p)
> +{
> +	if (!p->ops->unsynchronize)
> +		return -EINVAL;
and here.
> +
> +	return p->ops->unsynchronize(p, from_p);
> +}
> +EXPORT_SYMBOL(pwm_unsynchronize);
> +
> +static void pwm_handler(struct work_struct *w)
> +{
> +	struct pwm_device *p = container_of(w, struct pwm_device,
> +					    handler_work);
> +	if (p->handler)
> +		p->handler(p, p->handler_data);
> +}
> +
> +void pwm_callback(struct pwm_device *p)
> +{
> +	queue_work(pwm_handler_workqueue, &p->handler_work);
> +}
> +EXPORT_SYMBOL(pwm_callback);
> +
> +int pwm_set_handler(struct pwm_device *p, pwm_handler_t handler, void *data)
> +{
> +	struct pwm_config c;
> +	int ret;
> +
> +	if (handler)
> +		c.config_mask = BIT(PWM_CONFIG_ENABLE_CALLBACK);
> +	else
> +		c.config_mask = BIT(PWM_CONFIG_DISABLE_CALLBACK);
> +
> +	ret = pwm_config(p, &c);

There is a chance for a race here. The device could fire, for example due to an
irq, before the handler has been initalized.

> +
> +	if (!ret && handler) {
> +		p->handler_data = data;
> +		p->handler = handler;
> +		INIT_WORK(&p->handler_work, pwm_handler);

The INIT_WORK should probably into pwm_device_register.

> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_set_handler);
> +
> +static ssize_t pwm_run_show(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	return sprintf(buf, "%d\n", pwm_is_running(p));
> +}
> +
> +static ssize_t pwm_run_store(struct device *dev,
> +			     struct device_attribute *attr,
> +			     const char *buf, size_t len)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	if (!pwm_is_exported(p))
> +		return -EINVAL;

I'm not sure, but maybe -EPERM is better here.

> +
> +	if (sysfs_streq(buf, "1"))
> +		pwm_start(p);
> +	else if (sysfs_streq(buf, "0"))
> +		pwm_stop(p);
Maybe return -EINVAL if it is neither 0 or 1.

> +
> +	return len;
> +}
> +static DEVICE_ATTR(run, S_IRUGO | S_IWUSR, pwm_run_show, pwm_run_store);
> +
> +static ssize_t pwm_tick_hz_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	return sprintf(buf, "%lu\n", p->tick_hz);
> +}
> +static DEVICE_ATTR(tick_hz, S_IRUGO, pwm_tick_hz_show, NULL);
> +
> +static ssize_t pwm_duty_ns_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	return sprintf(buf, "%lu\n", pwm_get_duty_ns(p));
> +}
> +
> +static ssize_t pwm_duty_ns_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	unsigned long duty_ns;
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	if (!pwm_is_exported(p))
> +		return -EINVAL;
> +
> +	if (!strict_strtoul(buf, 10, &duty_ns))
> +		pwm_set_duty_ns(p, duty_ns);

How about returning the error value of strict_strtou if it fails?

> +	return len;
> +}
> +static DEVICE_ATTR(duty_ns, S_IRUGO | S_IWUSR, pwm_duty_ns_show, pwm_duty_ns_store);
> +
> +static ssize_t pwm_period_ns_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	return sprintf(buf, "%lu\n", pwm_get_period_ns(p));
> +}
> +
> +static ssize_t pwm_period_ns_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t len)
> +{
> +	unsigned long period_ns;
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	if (!pwm_is_exported(p))
> +		return -EINVAL;
> +
> +	if (!strict_strtoul(buf, 10, &period_ns))
> +		pwm_set_period_ns(p, period_ns);
> +	return len;
> +}
> +static DEVICE_ATTR(period_ns, S_IRUGO | S_IWUSR, pwm_period_ns_show, pwm_period_ns_store);
> +
> +static ssize_t pwm_polarity_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	return sprintf(buf, "%d\n", p->active_high ? 1 : 0);
> +}
> +
> +static ssize_t pwm_polarity_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	unsigned long polarity;
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	if (!pwm_is_exported(p))
> +		return -EINVAL;
> +
> +	if (!strict_strtoul(buf, 10, &polarity))
> +		pwm_set_polarity(p, polarity);
> +	return len;
> +}
> +static DEVICE_ATTR(polarity, S_IRUGO | S_IWUSR, pwm_polarity_show, pwm_polarity_store);
> +
> +static ssize_t pwm_request_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	int ret;
> +
> +	mutex_lock(&device_list_mutex);
> +	ret = __pwm_request(p, REQUEST_SYSFS);
> +	mutex_unlock(&device_list_mutex);
> +
> +	if (!ret)
> +		set_bit(FLAG_EXPORTED, &p->flags);
> +
> +	return sprintf(buf, "%s\n", p->label);
> +}
> +
> +static ssize_t pwm_request_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	pwm_release(p);
> +	clear_bit(FLAG_EXPORTED, &p->flags);
> +	return len;
> +}
> +static DEVICE_ATTR(request, S_IRUGO | S_IWUSR, pwm_request_show, pwm_request_store);

So `cat request` requests the device and `echo > request` frees the device?
Thats a bit odd in my opinion.

> +
> +static const struct attribute *pwm_attrs[] = {
> +	&dev_attr_tick_hz.attr,
> +	&dev_attr_run.attr,
> +	&dev_attr_polarity.attr,
> +	&dev_attr_duty_ns.attr,
> +	&dev_attr_period_ns.attr,
> +	&dev_attr_request.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group pwm_device_attr_group = {
> +	.attrs = (struct attribute **) pwm_attrs,
> +};
> +
> +static struct class_attribute pwm_class_attrs[] = {
> +	__ATTR_NULL,
> +};
> +
> +static struct class pwm_class = {
> +	.name = "pwm",
> +	.owner = THIS_MODULE,
> +
> +	.class_attrs = pwm_class_attrs,

Just leaving it NULL should work, if you don't want any class attributes.

> +};
> +
> +int pwm_register_byname(struct pwm_device *p, struct device *parent,
> +			const char *name)
> +{
> +	struct device *d;
> +	int ret;
> +
> +	if (!p->ops || !p->ops->config)
> +		return -EINVAL;
> +
> +	mutex_lock(&device_list_mutex);
> +
> +	d = class_find_device(&pwm_class, NULL, (char*)name, pwm_match_name);
> +	if (d) {
> +		ret = -EEXIST;
> +		goto err_found_device;
> +	}
device_create should fail if a device with the same name already exits, so I'm
not sure if it makes sense to do the check here.

> +
> +	p->dev = device_create(&pwm_class, parent, MKDEV(0, 0), NULL, name);
... NULL, "%s", name);

Or you could use device_create_vargs and get rid of that scnprintf in pwm_register.

> +	if (IS_ERR(p->dev)) {
> +		ret = PTR_ERR(p->dev);
> +		goto err_device_create;
> +	}
I think it would be better to embedd the device struct directly into the
pwm_device struct. You could also remove the data field of the pwm_device
struct and use dev_{get,set}_drvdata for pwm_{get,set}_drvdata.


> +
> +	ret = sysfs_create_group(&p->dev->kobj, &pwm_device_attr_group);
> +	if (ret)
> +		goto err_create_group;

It should be possible to use the classes dev_attrs here instead.


> +
> +	dev_set_drvdata(p->dev, p);
> +	p->flags = BIT(FLAG_REGISTERED);
> +
> +	goto done;
> +
> +err_create_group:
> +	device_unregister(p->dev);
> +	p->flags = 0;
> +
> +err_device_create:
> +err_found_device:
> +done:
> +	mutex_unlock(&device_list_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_register_byname);
> +
> +int pwm_register(struct pwm_device *p, struct device *parent, int id)
> +{
> +	int ret;
> +	char name[256];
> +
> +	if (IS_ERR_OR_NULL(parent))
> +		return -EINVAL;
> +
> +	if (id == -1)
> +		ret = scnprintf(name, sizeof name, "%s", dev_name(parent));
> +	else
> +		ret = scnprintf(name, sizeof name, "%s:%d", dev_name(parent), id);
> +	if (ret <= 0 || ret >= sizeof name)
> +		return -EINVAL;
> +
> +	return pwm_register_byname(p, parent, name);
> +}
> +EXPORT_SYMBOL(pwm_register);
> +
> +int pwm_unregister(struct pwm_device *p)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&device_list_mutex);
> +
> +	if (pwm_is_running(p) || pwm_is_requested(p)) {

Is it possible that the pwm is running but not requested?


> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	sysfs_remove_group(&p->dev->kobj, &pwm_device_attr_group);
> +	device_unregister(p->dev);
> +	p->flags = 0;
> +
> +done:
> +	mutex_unlock(&device_list_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_unregister);
> +
> +static int __init pwm_init(void)
> +{
> +	pwm_handler_workqueue = create_singlethread_workqueue("pwm");
> +	if (IS_ERR_OR_NULL(pwm_handler_workqueue)) {
> +		pr_err("%s: failed to create PWM workqueue; aborting\n",
> +		       __func__);
> +		return -ENOMEM;
> +	}
> +
> +	return class_register(&pwm_class);
> +}
> +
> +static void __exit pwm_exit(void)
> +{
> +	destroy_workqueue(pwm_handler_workqueue);
> +	class_unregister(&pwm_class);
> +}
> +
> +postcore_initcall(pwm_init);
> +module_exit(pwm_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
> +MODULE_DESCRIPTION("Generic PWM device API implementation");
> diff --git a/include/linux/pwm/pwm.h b/include/linux/pwm/pwm.h
> new file mode 100644
> index 0000000..1447333
> --- /dev/null
> +++ b/include/linux/pwm/pwm.h
> @@ -0,0 +1,155 @@
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
> +enum {
> +	FLAG_REGISTERED		= 0,
Does the REGISTERED flag makes any sense, I mean are there any usecases for
pwm_is_registered? Non registered pwm_devices should not be visible to the
outside world, so if you got an pointer to an pwm_device outside of an
pwm_device driver it should also be registered. And inside a pwm_device driver
the driver should know whether it already registered the pwm_device or not.

> +	FLAG_REQUESTED		= 1,
> +	FLAG_STOP		= 2,
> +	FLAG_RUNNING		= 3,
> +	FLAG_EXPORTED		= 4,
> +};
> +
> +enum {
> +	PWM_CONFIG_DUTY_TICKS	= 0,
> +	PWM_CONFIG_PERIOD_TICKS	= 1,
> +	PWM_CONFIG_POLARITY	= 2,
> +	PWM_CONFIG_START	= 3,
> +	PWM_CONFIG_STOP		= 4,
> +
> +	PWM_CONFIG_ENABLE_CALLBACK = 9,
> +	PWM_CONFIG_DISABLE_CALLBACK = 10,
> +};
> +
> +struct pwm_config;
> +struct pwm_device;
> +
> +typedef int (*pwm_handler_t)(struct pwm_device *p, void *data);
> +typedef void (*pwm_callback_t)(struct pwm_device *p);
> +
> +struct pwm_device_ops {
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
> +struct pwm_config {
> +	unsigned long config_mask;
> +
> +	unsigned long duty_ticks;
> +	unsigned long period_ticks;
> +	int polarity;
> +};
> +
> +struct pwm_device {
> +	struct device *dev;
> +	const struct pwm_device_ops *ops;
> +
> +	const void *data;
> +
> +	const char *label;
> +
> +	unsigned long flags;
> +
> +	unsigned long tick_hz;
> +
> +	struct work_struct handler_work;
> +	pwm_handler_t handler;
> +	void *handler_data;
> +
> +	int active_high;
In the config you call it polarity, here you call it active_high. A consistent
naming would be better in my opinion.

> +	unsigned long period_ticks;
> +	unsigned long duty_ticks;
> +};
> +
> +struct pwm_device *pwm_request_byname(const char *name, const char *label);
> +struct pwm_device *pwm_request(const char *bus_id, int id, const char *label);
> +void pwm_release(struct pwm_device *p);
> +
> +static inline int pwm_is_registered(const struct pwm_device *p)
> +{
> +	return test_bit(FLAG_REGISTERED, &p->flags);
> +}
> +
> +static inline int pwm_is_requested(const struct pwm_device *p)
> +{
> +	return test_bit(FLAG_REQUESTED, &p->flags);
> +}
> +
> +static inline int pwm_is_running(const struct pwm_device *p)
> +{
> +	return test_bit(FLAG_RUNNING, &p->flags);
> +}
> +
> +static inline int pwm_is_exported(const struct pwm_device *p)
> +{
> +	return test_bit(FLAG_EXPORTED, &p->flags);
> +}
> +
> +static inline void pwm_set_drvdata(struct pwm_device *p, const void *data)
> +{
> +	p->data = data;
> +}
> +
> +static inline void *pwm_get_drvdata(const struct pwm_device *p)
> +{
> +	return (void*)p->data;
> +}
> +
> +
> +int pwm_register(struct pwm_device *p, struct device *parent, int id);
> +int pwm_register_byname(struct pwm_device *p, struct device *parent,
> +			const char *name);
> +int pwm_unregister(struct pwm_device *p);
> +
> +int pwm_set(struct pwm_device *p, unsigned long period_ns,
> +	    unsigned long duty_ns, int active_high);
> +
> +int pwm_set_period_ns(struct pwm_device *p, unsigned long period_ns);
> +unsigned long pwm_get_period_ns(struct pwm_device *p);
> +
> +int pwm_set_duty_ns(struct pwm_device *p, unsigned long duty_ns);
> +unsigned long pwm_get_duty_ns(struct pwm_device *p);
> +
> +int pwm_set_polarity(struct pwm_device *p, int active_high);
> +
> +int pwm_start(struct pwm_device *p);
> +int pwm_stop(struct pwm_device *p);
> +
> +int pwm_config_nosleep(struct pwm_device *p, struct pwm_config *c);
> +int pwm_config(struct pwm_device *p, struct pwm_config *c);
> +
> +int pwm_synchronize(struct pwm_device *p, struct pwm_device *to_p);
> +int pwm_unsynchronize(struct pwm_device *p, struct pwm_device *from_p);
> +int pwm_set_handler(struct pwm_device *p, pwm_handler_t handler, void *data);
> +
> +void pwm_callback(struct pwm_device *p);
> +
> +struct pwm_device *gpio_pwm_create(int gpio);
> +int gpio_pwm_destroy(struct pwm_device *p);

These two definitions probably belong to the second patch.

> +
> +#endif


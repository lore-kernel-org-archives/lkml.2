Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1CJEqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:46:13 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62386 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab1CJEqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:46:12 -0500
Message-ID: <4D7857DB.1020400@metafoo.de>
Date: Thu, 10 Mar 2011 05:47:23 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PWM v7 1/3] PWM: Implement a generic PWM framework
References: <1299701596-24665-1-git-send-email-bgat@billgatliff.com> <1299701596-24665-2-git-send-email-bgat@billgatliff.com>
In-Reply-To: <1299701596-24665-2-git-send-email-bgat@billgatliff.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 09:13 PM, Bill Gatliff wrote:
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
>  Documentation/pwm.txt   |  289 +++++++++++++++++++++
>  MAINTAINERS             |    8 +
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    2 +
>  drivers/pwm/Kconfig     |   10 +
>  drivers/pwm/Makefile    |    4 +
>  drivers/pwm/pwm.c       |  645 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm/pwm.h |  140 ++++++++++
>  8 files changed, 1100 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/pwm.txt
>  create mode 100644 drivers/pwm/Kconfig
>  create mode 100644 drivers/pwm/Makefile
>  create mode 100644 drivers/pwm/pwm.c
>  create mode 100644 include/linux/pwm/pwm.h
> 

...

> diff --git a/drivers/pwm/pwm.c b/drivers/pwm/pwm.c
> new file mode 100644
> index 0000000..16d8c9c
> --- /dev/null
> +++ b/drivers/pwm/pwm.c
> @@ -0,0 +1,645 @@
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
> +static DEFINE_MUTEX(device_list_mutex);

I've been thinking about if this mutex can be removed. It's name suggest that
it was originally used to protect the device list, which is now gone.
Currently the it protects against races between pwm_request_by_name,
pwm_release and pwm_device_unregister.
But the same thing can be accomplished by using FLAG_REQUESTED, with some minor
adjustments in pwm_release and by marking the device as requested in
pwm_device_unregister.
The later will also have the benefit of that it is not possible to request the
device anymore after it has been removed through an kept open sysfs file.


> +static int __pwm_request(struct pwm_device *p, const char *label)
> +{
> +	int ret;
> +
> +	ret = test_and_set_bit(FLAG_REQUESTED, &p->flags);
> +	if (ret)
> +		return -EBUSY;
> +
> +	p->label = label;
> +
> +	if (p->ops->request) {
> +		ret = p->ops->request(p);
> +		if (ret)
> +			clear_bit(FLAG_REQUESTED, &p->flags);
> +	}
> +
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

class_find_device only returns either NULL or a pointer.

> +		return ERR_PTR(-EINVAL);
> +
> +	p = dev_get_drvdata(d);
> +	ret = __pwm_request(p, label);
> +
> +	if (ret)

class_find_device gets a reference to the device, which has to be dropped in
the error path: put_device(d);

> +		return ERR_PTR(ret);
> +	return p;
> +}

__pwm_request_byname is only used by pwm_request_byname, i think it can be
merged down.


> +
> +/**
> + * pwm_request_byname - request a PWM device by name
> + *
> + * @name: full name of PWM device, including the numeric identifier
> + * @label: label that identifies requestor
> + *
> + * For example, the @name of "atmel_pwmc.1" identifies the second
> + * ATMEL PWMC peripheral channel.  This would be equivalent to a call
> + * of pwm_request("atmel_pwmc", 1, "label").
> + *
> + * Returns a pointer to the requested PWM device on success, -EINVAL
> + * otherwise.
> + */
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
> +/**
> + * pwm_request - requests a PWM device
> + * @bus_id: PWM device's bus identifier
> + * @id: PWM device's identifier
> + * @label: label that identifies requestor
> + *
> + * The @bus_id argument is typically the dev_name(parent) used during
> + * PWM device registration.  For example, for the "atmel_pwmc.1"
> + * device the @bus_id is "atmel_pwmc".
> + *
> + * The @id parameter is the numeric identifier of the requested
> + * device, if any.  For example, for the "atmel_pwmc.1" device the @id
> + * is 1.
> + *
> + * Returns the PWM device structure of the requested device, or
> + * ERR_PTR() on error.
> + */
> +struct pwm_device *pwm_request(const char *bus_id, int id, const char *label)
> +{
> +	char name[256];
> +	int ret;
> +
> +	if (id == -1)
> +		ret = scnprintf(name, sizeof(name), "%s", bus_id);
> +	else
> +		ret = scnprintf(name, sizeof(name), "%s:%d", bus_id, id);
> +	if (ret <= 0 || ret >= sizeof(name))
> +		return ERR_PTR(-EINVAL);
> +
> +	return pwm_request_byname(name, label);
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
> +	if (!test_and_clear_bit(FLAG_REQUESTED, &p->flags)) {
	if (!test_bit(FLAG_REQUESTED, &p->flags)) {


> +		WARN(1, "%s: releasing unrequested PWM device %s\n",
> +		     __func__, dev_name(p->dev));
> +		goto done;
> +	}


> +
> +	pwm_stop(p);
> +	pwm_unsynchronize(p, NULL);
> +	p->label = NULL;
> +
> +	if (p->ops->release)
> +		p->ops->release(p);

	clear_bit(FLAG_REQUESTED, &p->flags);

> +done:
> +	mutex_unlock(&device_list_mutex);
> +}
> +EXPORT_SYMBOL(pwm_release);
> +

...

> +
> +static ssize_t pwm_export_show(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	if (pwm_is_exported(p))
> +		return sprintf(buf, "%s\n", p->label);
> +	else if (pwm_is_requested(p))
> +		return -EBUSY;

This looks a bit strange. If it is exported it will always be named "sysfs".

> +	return 0;
> +}
> +
> +static ssize_t pwm_export_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t len)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +	int ret;
> +
> +	mutex_lock(&device_list_mutex);
> +	if (pwm_is_exported(p))
> +		ret = -EBUSY;
> +	else
> +		ret = __pwm_request(p, REQUEST_SYSFS);

	ret = __pwm_request(p, REQUEST_SYSFS);
	
> +
> +	if (!ret)
> +		set_bit(FLAG_EXPORTED, &p->flags);
> +	mutex_unlock(&device_list_mutex);
> +
> +	return ret ? ret : len;
> +}
> +
> +static ssize_t pwm_unexport_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	struct pwm_device *p = dev_get_drvdata(dev);
> +
> +	if (!pwm_is_exported(p) || !pwm_is_requested(p))
> +		return -EINVAL;
> +
> +	pwm_release(p);
> +	clear_bit(FLAG_EXPORTED, &p->flags);
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
> +/**
> + * pwm_register_vargs - registers a PWM device
> + *
> + * @p: PWM device to register
> + * @parent: reference to parent device, if any
> + * @fmt: printf-style format specifier for device name
> + *
> + */
> +int pwm_register_vargs(struct pwm_device *p, struct device *parent,
> +		       const char *fmt, ...)

_vargs is usualy used for functions which take a va_list. pwm_register_fmt
would be a better name here I guess.

> +{
> +	va_list args;
> +	int ret = 0;
> +
> +	if (!p->ops || !p->ops->config)
> +		return -EINVAL;
> +
> +	va_start(args, fmt);
> +
> +	mutex_lock(&device_list_mutex);
> +
> +	p->dev = device_create_vargs(&pwm_class, parent,
> +				     MKDEV(0, 0), NULL, fmt, args);
> +	if (IS_ERR(p->dev))
> +		ret = PTR_ERR(p->dev);
> +	else
> +		dev_set_drvdata(p->dev, p);
> +
> +	mutex_unlock(&device_list_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_register_vargs);
> +

...

> +
> +int pwm_unregister(struct pwm_device *p)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&device_list_mutex);
> +
> +	if (pwm_is_requested(p)) {

	if (test_and_set_bit(FLAG_REQUESTED, &p->flags)) {

> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
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
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
> +MODULE_DESCRIPTION("Generic PWM device API implementation");
> diff --git a/include/linux/pwm/pwm.h b/include/linux/pwm/pwm.h
> new file mode 100644
> index 0000000..ff3eae7
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
> +enum {
> +	FLAG_REQUESTED		= 0,
> +	FLAG_STOP		= 1,
> +	FLAG_RUNNING		= 2,
> +	FLAG_EXPORTED		= 3,
> +};

I think a PWM_ prefix for the flags would be good.

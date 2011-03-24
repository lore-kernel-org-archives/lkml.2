Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab1CXTW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:22:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933843Ab1CXTWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:22:23 -0400
Date: Thu, 24 Mar 2011 12:20:05 -0700
From: Greg KH <gregkh@suse.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, vapier@gentoo.org
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110324192005.GA9296@suse.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 03:21:08PM +0000, Jamie Iles wrote:
> +/*
> + * Copyright 2010-2011 Picochip LTD, Jamie Iles
> + * http://www.picochip.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.

Do you _really_ mean "any later version"?  Be sure about that please.
You have that wording in all of your files you add, please be careful
about it as you might have copied from code that did not have that
wording (I'm not saying you did, just be sure about this.)

> + */
> +#define pr_fmt(fmt) "otp: " fmt
> +
> +#undef DEBUG

What is this for?

> +#include <linux/cdev.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/otp.h>
> +#include <linux/semaphore.h>
> +#include <linux/slab.h>
> +#include <linux/sysfs.h>
> +#include <linux/uaccess.h>
> +
> +static int otp_open(struct inode *inode, struct file *filp);
> +static int otp_release(struct inode *inode, struct file *filp);
> +static ssize_t otp_write(struct file *filp, const char __user *buf,
> +			 size_t len, loff_t *offs);
> +static ssize_t otp_read(struct file *filp, char __user *buf, size_t len,
> +			loff_t *offs);
> +static loff_t otp_llseek(struct file *filp, loff_t offs, int origin);
> +
> +static const struct file_operations otp_fops = {
> +	.owner	    = THIS_MODULE,
> +	.open	    = otp_open,
> +	.release    = otp_release,
> +	.write	    = otp_write,
> +	.read	    = otp_read,
> +	.llseek	    = otp_llseek,
> +};
> +
> +static DEFINE_SEMAPHORE(otp_sem);
> +static int otp_we, otp_strict_programming;
> +static struct otp_device *otp;
> +static dev_t otp_devno;
> +
> +/*
> + * Given a device for one of the otpN devices, get the corresponding
> + * otp_region.
> + */
> +static inline struct otp_region *to_otp_region(struct device *dev)
> +{
> +	return dev ? container_of(dev, struct otp_region, dev) : NULL;
> +}
> +
> +static inline struct otp_device *to_otp_device(struct device *dev)
> +{
> +	return dev ? container_of(dev, struct otp_device, dev) : NULL;
> +}
> +
> +bool otp_strict_programming_enabled(void)
> +{
> +	return otp_strict_programming;
> +}
> +EXPORT_SYMBOL_GPL(otp_strict_programming_enabled);
> +
> +static ssize_t otp_format_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct otp_region *region = to_otp_region(dev);
> +	enum otp_redundancy_fmt fmt;
> +	const char *fmt_string;
> +
> +	if (down_interruptible(&otp_sem))
> +		return -ERESTARTSYS;
> +
> +	if (region->ops->get_fmt(region))
> +		fmt = region->ops->get_fmt(region);
> +	else
> +		fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
> +
> +	up(&otp_sem);
> +
> +	if (OTP_REDUNDANCY_FMT_SINGLE_ENDED == fmt)

While some people feel this somehow makes it harder to write bad C code,
it's not the kernel style.  Please reverse this comparison.  If you
accidentally put a '=' in there instead of '==', gcc would warn you
about it.

> +		fmt_string = "single-ended";
> +	else if (OTP_REDUNDANCY_FMT_REDUNDANT == fmt)
> +		fmt_string = "redundant";
> +	else if (OTP_REDUNDANCY_FMT_DIFFERENTIAL == fmt)
> +		fmt_string = "differential";
> +	else if (OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT == fmt)
> +		fmt_string = "differential-redundant";
> +	else
> +		fmt_string = NULL;

Just return -EINVAL here.

> +
> +	return fmt_string ? sprintf(buf, "%s\n", fmt_string) : -EINVAL;

Then you don't have to do the embedded if in this statement.

Same thing goes for your other show/store functions.

> +/**
> + * struct otp_device - a picoxcell OTP device.
> + *
> + * @ops:		The operations to use for manipulating the device.
> + * @dev:		The parent device (typically a platform_device) that
> + *			provides the OTP.
> + * @regions:		The regions registered to the device.
> + * @size:		The size of the OTP in bytes.
> + * @driver_data:	Private driver data.
> + */
> +struct otp_device {
> +	const struct otp_device_ops	*ops;
> +	struct device			dev;
> +	struct list_head		regions;
> +	size_t				size;
> +	void				*driver_data;

Why do you need this pointer, can't you use the one in struct device
that is there for this purpose?  Then provide a get/set function to
access this field so that a driver doesn't go and poke in it directly.


thanks,

greg k-h

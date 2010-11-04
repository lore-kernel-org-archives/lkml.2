Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab0KDSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:25:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:44238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0KDSZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:25:54 -0400
Date: Thu, 4 Nov 2010 14:25:51 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Add support for Roccat Kone[+]
In-Reply-To: <1287943025.2623.16.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1011041418530.15851@pobox.suse.cz>
References: <1287943025.2623.16.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010, Stefan Achatz wrote:

> This patch adds support for Roccat Kone[+] gaming mouse. Kone[+] is an enhanced version
> of the old Kone with more memory for macros, a better sensor and more functionality.
> This driver is conceptual similar to the existing Kone and Pyra drivers.
> Userland tools can soon be found at http://sourceforge.net/projects/roccat

Seems like there is a lot of duplicate code with Roccat Kone.

> +static int koneplus_send_control(struct usb_device *usb_dev, uint value,
> +		enum koneplus_control_requests request)
> +{
> +	int len;
> +	struct koneplus_control *control;
> +
> +	if ((request == KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
> +			request == KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
> +			value > 4)
> +		return -EINVAL;
> +
> +	control = kmalloc(sizeof(struct koneplus_control), GFP_KERNEL);
> +	if (!control)
> +		return -ENOMEM;
> +
> +	control->command = KONEPLUS_COMMAND_CONTROL;
> +	control->value = value;
> +	control->request = request;
> +
> +	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
> +			USB_REQ_SET_CONFIGURATION,
> +			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
> +			KONEPLUS_USB_COMMAND_CONTROL, 0, control,
> +			sizeof(struct koneplus_control),
> +			USB_CTRL_SET_TIMEOUT);
> +
> +	kfree(control);
> +
> +	if (len != sizeof(struct koneplus_control))
> +		return len;
> +
> +	return 0;
> +}
> +
> +static int koneplus_receive(struct usb_device *usb_dev, uint usb_command,
> +		void *buf, uint size) {
> +	int len;
> +
> +	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
> +			USB_REQ_CLEAR_FEATURE,
> +			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
> +			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
> +
> +	return (len != size) ? -EIO : 0;
> +}
> +
> +static int koneplus_receive_control_status(struct usb_device *usb_dev)
> +{
> +	int retval;
> +	struct koneplus_control *control;
> +
> +	control = kmalloc(sizeof(struct koneplus_control), GFP_KERNEL);
> +	if (!control)
> +		return -ENOMEM;
> +
> +	do {
> +		retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
> +				control, sizeof(struct koneplus_control));
> +
> +		/* check if we get a completely wrong answer */
> +		if (retval)
> +			goto out;
> +
> +		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_OK) {
> +			retval = 0;
> +			goto out;
> +		}
> +
> +		/* indicates that hardware needs some more time to complete action */
> +		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_WAIT) {
> +			msleep(500); /* windows driver uses 1000 */
> +			continue;
> +		}
> +
> +		/* seems to be critical - replug necessary */
> +		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD) {
> +			retval = -EINVAL;
> +			goto out;
> +		}
> +
> +		dev_err(&usb_dev->dev, "koneplus_receive_control_status: "
> +				"unknown response value 0x%x\n", control->value);
> +		retval = -EINVAL;
> +		goto out;
> +
> +	} while (1);
> +out:
> +	kfree(control);
> +	return retval;
> +}
> +
> +static int koneplus_send(struct usb_device *usb_dev, uint command,
> +		void *buf, uint size) {
> +	int len;
> +
> +	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
> +			USB_REQ_SET_CONFIGURATION,
> +			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
> +			command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
> +
> +	if (len != size)
> +		return -EIO;
> +
> +	if (koneplus_receive_control_status(usb_dev))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int koneplus_select_profile(struct usb_device *usb_dev, uint number,
> +		enum koneplus_control_requests request)
> +{
> +	int retval;
> +
> +	retval = koneplus_send_control(usb_dev, number, request);
> +	if (retval)
> +		return retval;
> +
> +	/* allow time to settle things - windows driver uses 500 */
> +	msleep(100);
> +
> +	retval = koneplus_receive_control_status(usb_dev);
> +	if (retval)
> +		return retval;
> +
> +	return 0;
> +}
> +
> +static int koneplus_get_info(struct usb_device *usb_dev,
> +		struct koneplus_info *buf)
> +{
> +	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_INFO,
> +			buf, sizeof(struct koneplus_info));
> +}
> +
> +static int koneplus_get_profile_settings(struct usb_device *usb_dev,
> +		struct koneplus_profile_settings *buf, uint number)
> +{
> +	int retval;
> +
> +	retval = koneplus_select_profile(usb_dev, number,
> +			KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
> +	if (retval)
> +		return retval;
> +
> +	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
> +			buf, sizeof(struct koneplus_profile_settings));
> +}
> +
> +static int koneplus_set_profile_settings(struct usb_device *usb_dev,
> +		struct koneplus_profile_settings const *settings)
> +{
> +	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
> +			(void *)settings, sizeof(struct koneplus_profile_settings));
> +}
> +
> +static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
> +		struct koneplus_profile_buttons *buf, int number)
> +{
> +	int retval;
> +
> +	retval = koneplus_select_profile(usb_dev, number,
> +			KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
> +	if (retval)
> +		return retval;
> +
> +	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
> +			buf, sizeof(struct koneplus_profile_buttons));
> +}
> +
> +static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
> +		struct koneplus_profile_buttons const *buttons)
> +{
> +	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
> +			(void *)buttons, sizeof(struct koneplus_profile_buttons));
> +}
> +
> +/* retval is 0-4 on success, < 0 on error */
> +static int koneplus_get_startup_profile(struct usb_device *usb_dev)
> +{
> +	struct koneplus_startup_profile *buf;
> +	int retval;
> +
> +	buf = kmalloc(sizeof(struct koneplus_startup_profile), GFP_KERNEL);
> +
> +	retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
> +			buf, sizeof(struct koneplus_startup_profile));
> +
> +	if (retval)
> +		goto out;
> +
> +	retval = buf->startup_profile;
> +out:
> +	kfree(buf);
> +	return retval;
> +}
> +
> +static int koneplus_set_startup_profile(struct usb_device *usb_dev,
> +		int startup_profile)
> +{
> +	struct koneplus_startup_profile buf;
> +
> +	buf.command = KONEPLUS_COMMAND_STARTUP_PROFILE;
> +	buf.size = sizeof(struct koneplus_startup_profile);
> +	buf.startup_profile = startup_profile;
> +
> +	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
> +			(char *)&buf, sizeof(struct koneplus_profile_buttons));
> +}

Is there any reason this couldn't be merged with the Roccat Kone 
counterparts?

> +static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
> +		char *buf, loff_t off, size_t count,
> +		size_t real_size, uint command)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
> +	int retval;
> +
> +	if (off != 0 || count != real_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&koneplus->koneplus_lock);
> +	retval = koneplus_receive(usb_dev, command, buf, real_size);
> +	mutex_unlock(&koneplus->koneplus_lock);
> +
> +	if (retval)
> +		return retval;
> +
> +	return real_size;
> +}
> +
> +static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
> +		void const *buf, loff_t off, size_t count,
> +		size_t real_size, uint command)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
> +	int retval;
> +
> +	if (off != 0 || count != real_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&koneplus->koneplus_lock);
> +	retval = koneplus_send(usb_dev, command, (void *)buf, real_size);
> +	mutex_unlock(&koneplus->koneplus_lock);
> +
> +	if (retval)
> +		return retval;
> +
> +	return real_size;
> +}
> +
> +static ssize_t koneplus_sysfs_write_macro(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_write(fp, kobj, buf, off, count,
> +			sizeof(struct koneplus_macro), KONEPLUS_USB_COMMAND_MACRO);
> +}
> +
> +static ssize_t koneplus_sysfs_read_sensor(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read(fp, kobj, buf, off, count,
> +			sizeof(struct koneplus_sensor), KONEPLUS_USB_COMMAND_SENSOR);
> +}
> +
> +static ssize_t koneplus_sysfs_write_sensor(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_write(fp, kobj, buf, off, count,
> +			sizeof(struct koneplus_sensor), KONEPLUS_USB_COMMAND_SENSOR);
> +}
> +
> +static ssize_t koneplus_sysfs_write_tcu(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_write(fp, kobj, buf, off, count,
> +			sizeof(struct koneplus_tcu), KONEPLUS_USB_COMMAND_TCU);
> +}
> +
> +static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read(fp, kobj, buf, off, count,
> +			sizeof(struct koneplus_tcu_image), KONEPLUS_USB_COMMAND_TCU);
> +}
> +
> +static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count, uint number)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
> +
> +	if (off >= sizeof(struct koneplus_profile_settings))
> +		return 0;
> +
> +	if (off + count > sizeof(struct koneplus_profile_settings))
> +		count = sizeof(struct koneplus_profile_settings) - off;
> +
> +	mutex_lock(&koneplus->koneplus_lock);
> +	memcpy(buf, ((void const *)&koneplus->profile_settings[number]) + off,
> +			count);
> +	mutex_unlock(&koneplus->koneplus_lock);
> +
> +	return count;
> +}
> +
> +static ssize_t koneplus_sysfs_read_profile1_settings(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read_profilex_settings(fp, kobj,
> +			attr, buf, off, count, 0);
> +}
> +
> +static ssize_t koneplus_sysfs_read_profile2_settings(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read_profilex_settings(fp, kobj,
> +			attr, buf, off, count, 1);
> +}
> +
> +static ssize_t koneplus_sysfs_read_profile3_settings(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read_profilex_settings(fp, kobj,
> +			attr, buf, off, count, 2);
> +}
> +
> +static ssize_t koneplus_sysfs_read_profile4_settings(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read_profilex_settings(fp, kobj,
> +			attr, buf, off, count, 3);
> +}
> +
> +static ssize_t koneplus_sysfs_read_profile5_settings(struct file *fp,
> +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		loff_t off, size_t count)
> +{
> +	return koneplus_sysfs_read_profilex_settings(fp, kobj,
> +			attr, buf, off, count, 4);
> +}
> +

This is really ugly. Can't you have just one read() function and 
distuingish according to bin_attribute->private?


> diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
> new file mode 100644
> index 0000000..bf750fa
> --- /dev/null
> +++ b/drivers/hid/hid-roccat-koneplus.h
> @@ -0,0 +1,229 @@
> +#ifndef __HID_ROCCAT_KONEPLUS_H
> +#define __HID_ROCCAT_KONEPLUS_H
> +
> +/*
> + * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/types.h>
> +
> +#pragma pack(push)
> +#pragma pack(1)

Why?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

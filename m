Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0H0MOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:14:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45727 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750707Ab0H0MOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:14:19 -0400
Date: Fri, 27 Aug 2010 13:31:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
Message-ID: <20100827133109.1eb974ed@lxorguk.ukuu.org.uk>
In-Reply-To: <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
	<1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int ak8974_regulators_on(struct ak8974_chip *chip)
> +{
> +	int ret;
> +	ret = regulator_bulk_enable(ARRAY_SIZE(chip->regs), chip->regs);
> +	if (ret == 0)
> +		msleep(AK8974_POWERON_DELAY);
> +
> +	return ret;
> +}
> +
> +static inline void ak8974_regulators_off(struct ak8974_chip *chip)
> +{
> +	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
> +}

That bit seems platform specific but in generic code ?


> +static ssize_t ak8974_misc_read(struct file *file, char __user *buf,
> +			size_t count, loff_t *offset)
> +{
> +	struct ak8974_chip *chip = container_of(file->private_data,
> +						struct ak8974_chip,
> +						miscdev);
> +	struct ak8974_data data;

So we have a different API to the ak8975 just posted and to the other
existing devices. This needs sorting out across the devices before there
is a complete disaster. Right now we have a mix of submissions pending
which variously use

	misc + sysfs
	sysfs
	input (reporting X Y Z etc axes)

Someone needs to decide on a single API before it's too late.

> +
> +	if (count < sizeof(data))
> +		return -EINVAL;
> +
> +	if (*offset >= chip->offset) {
> +		schedule_work(&chip->work);
> +		if (file->f_flags & O_NONBLOCK)
> +			return -EAGAIN;
> +		if (wait_event_interruptible(chip->misc_wait,
> +						(*offset < chip->offset)))
> +			return -ERESTARTSYS;
> +	}
> +
> +	mutex_lock(&chip->lock);
> +	data.x = chip->x;
> +	data.y = chip->y;
> +	data.z = chip->z;
> +	data.valid = chip->valid;
> +	*offset = chip->offset;
> +	mutex_unlock(&chip->lock);

What happens if you have two readers - is it fine they get copies of the
same event when it races ?


> +
> +	return copy_to_user(buf, &data, sizeof(data)) ? -EFAULT : sizeof(data);

Pedantically if data is consumed and a partial copy occurs you should
return the bytes successfully copied.

> +static DEVICE_ATTR(chip_id, S_IRUGO, ak8974_show_chip_id, NULL);
> +
> +static ssize_t ak8974_show_range(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct ak8974_chip *chip = dev_get_drvdata(dev);
> +	return sprintf(buf, "%d\n", chip->max_range);
> +}

Other devices make all of this sysfs or use input. We need to work out
what the right interface actually is.

> +	snprintf(chip->name, sizeof(chip->name), "ak8974%d",
> +		atomic_add_return(1, &device_number) - 1);

Surely this is serialized anyway ?


> +#ifdef CONFIG_PM
> +static int ak8974_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct ak8974_chip *chip = i2c_get_clientdata(client);
> +	mutex_lock(&chip->users_lock);
> +	if (chip->users > 0)
> +		ak8974_enable(chip, AK8974_PWR_OFF);
> +	mutex_unlock(&chip->users_lock);
> +	return 0;
> +}
> +
> +static int ak8974_resume(struct i2c_client *client)
> +{
> +	struct ak8974_chip *chip = i2c_get_clientdata(client);
> +	mutex_lock(&chip->users_lock);
> +	if (chip->users > 0)
> +		ak8974_enable(chip, AK8974_PWR_ON);
> +	mutex_unlock(&chip->users_lock);
> +	return 0;
> +}

The whole chip->users thing you are implementing is basically a
reimplementation of the kernel runtime pm stuff - so can that be used
instead ?


> +#ifndef __LINUX_I2C_AK8974_H
> +#define __LINUX_I2C_AK8974_H
> +
> +#define AK8974_NO_MAP		  0
> +#define AK8974_DEV_X		  1
> +#define AK8974_DEV_Y		  2
> +#define AK8974_DEV_Z		  3
> +#define AK8974_INV_DEV_X	 -1
> +#define AK8974_INV_DEV_Y	 -2
> +#define AK8974_INV_DEV_Z	 -3
> +
> +struct ak8974_platform_data {
> +	s8 axis_x;
> +	s8 axis_y;
> +	s8 axis_z;
> +};
> +
> +/* Device name: /dev/ak8974n, where n is a running number */
> +struct ak8974_data {
> +	__s16 x;
> +	__s16 y;
> +	__s16 z;
> +	__u16 valid;
> +} __attribute__((packed));

This could go in the C file.

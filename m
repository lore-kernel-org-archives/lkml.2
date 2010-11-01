Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab0KAMaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:30:01 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50311 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0KAMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:30:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CCEB42F.8000102@cam.ac.uk>
Date: Mon, 01 Nov 2010 12:35:59 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Maciej Szmigiero <mhej@o2.pl>
CC: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [W1] a driver for DS2405 chip
References: <4CC9E2A5.2010400@o2.pl>
In-Reply-To: <4CC9E2A5.2010400@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/10 21:52, Maciej Szmigiero wrote:
> [W1] a driver for DS2405 chip
> 
> This is a driver for DS2405 1-wire single-channel addressable switch / PIO.
> DS2405 can also work as single-channel binary remote sensor.
Perhaps handle this as a gpio chip? (be it a fairly limited one)
To my mind it would make it more generally useful...
> 
> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
> --- a/drivers/w1/w1_family.h	2009-06-10 05:05:27.000000000 +0200
> +++ b/drivers/w1/w1_family.h	2009-12-13 22:23:32.994770399 +0100
> @@ -28,6 +28,7 @@
>  
>  #define W1_FAMILY_DEFAULT	0
>  #define W1_FAMILY_SMEM_01	0x01
> +#define W1_FAMILY_DS2405	0x05
>  #define W1_FAMILY_SMEM_81	0x81
>  #define W1_THERM_DS18S20 	0x10
>  #define W1_THERM_DS1822  	0x22
> --- a/drivers/w1/w1_io.c	2009-06-10 05:05:27.000000000 +0200
> +++ b/drivers/w1/w1_io.c	2009-12-15 22:32:48.362801835 +0100
> @@ -210,6 +210,7 @@
>  		return retval;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(w1_triplet);
>  
>  /**
>   * Reads 8 bits.
> --- /dev/null	2010-10-28 22:18:50.899999998 +0200
> +++ b/drivers/w1/slaves/w1_ds2405.c	2010-10-28 22:42:13.000000000 +0200
> @@ -0,0 +1,251 @@
> +/*
> + *	w1_ds2405.c
> + *
> + * Copyright (c) 2009 Maciej Szmigiero <mhej@o2.pl>
> + * Based on w1_therm.c copyright (c) 2004 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the therms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/sched.h>
> +#include <linux/device.h>
> +#include <linux/types.h>
> +#include <linux/delay.h>
> +
> +#include "../w1.h"
> +#include "../w1_int.h"
> +#include "../w1_family.h"
> +
> +static int w1_ds2405_select(struct w1_slave *sl, int only_active)
> +{
> +	struct w1_master *dev = sl->master;
> +	int ret;
> +
> +	if (w1_reset_bus(dev) != 0)
> +		return 0;
> +
> +	/* We cannot use normal Match ROM command */
> +	/* since doing so would toggle PIO state */
> +	w1_write_8(dev, only_active ? W1_ALARM_SEARCH : W1_SEARCH);
> +
> +	do {
> +		u64 dev_addr = cpu_to_le64(((u64)sl->reg_num.crc<<(8+48))
> +					| ((u64)sl->reg_num.id<<8)
> +					| sl->reg_num.family);
> +		u8 bit_ctr;
> +
> +		for (bit_ctr = 0; bit_ctr < 64; bit_ctr++) {
> +			int bit2send = !!(dev_addr & 1LL<<bit_ctr);
> +			ret = w1_triplet(dev, bit2send);
> +
> +			if ((ret & 3) == 3) /* no devices found */
> +				return 0;
> +
> +			if ((!!(ret & 4)) != bit2send)
> +				/* wrong direction taken - no such device */
> +				return 0;
> +		}
> +	} while (0);
> +
> +	return 1;
> +}
> +
> +static int w1_ds2405_read_pio(struct w1_slave *sl)
> +{
> +	if (w1_ds2405_select(sl, 1))
> +		return 0; /* "active" means PIO is low */
> +
> +	if (w1_ds2405_select(sl, 0))
> +		return 1;
> +	else
> +		return -ENODEV;
> +}
> +
> +static ssize_t w1_ds2405_read_sensed_file(struct device *device,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct w1_slave *sl = dev_to_w1_slave(device);
> +	struct w1_master *dev = sl->master;
> +
> +	int ret;
> +	ssize_t f_retval;
> +	u8 state;
> +
> +	ret = mutex_lock_interruptible(&dev->mutex);
> +	if (ret)
> +		return ret;
> +
> +	if (!w1_ds2405_select(sl, 0)) {
> +		f_retval = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	state = w1_read_8(dev);
> +
> +	f_retval = snprintf(buf, PAGE_SIZE, "%u\n", !!(state));
> +
> +out_unlock:
> +	w1_reset_bus(dev);
> +	mutex_unlock(&dev->mutex);
> +
> +	return f_retval;
> +}
> +
> +static ssize_t w1_ds2405_read_pio_file(struct device *device,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct w1_slave *sl = dev_to_w1_slave(device);
> +	struct w1_master *dev = sl->master;
> +
> +	int ret;
> +	ssize_t f_retval;
> +
> +	ret = mutex_lock_interruptible(&dev->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = w1_ds2405_read_pio(sl);
> +	if (ret < 0) {
> +		f_retval = ret;
> +		goto out_unlock;
> +	}
> +
> +	f_retval = snprintf(buf, PAGE_SIZE, "%d\n", ret);
> +
> +out_unlock:
> +	w1_reset_bus(dev);
> +	mutex_unlock(&dev->mutex);
> +
> +	return f_retval;
> +}
> +
> +static ssize_t w1_ds2405_write_pio_file(struct device *device,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct w1_slave *sl = dev_to_w1_slave(device);
> +	struct w1_master *dev = sl->master;
> +
> +	int ret, current_pio;
> +	unsigned int val;
> +	ssize_t f_retval;
> +
> +	if (count < 1)
> +		return -EINVAL;
> +
> +	/* fill_write_buffer() in fs/sysfs/file.c */
> +	/* keeps the buffer null-terminated */
> +	if (sscanf(buf, " %u%n", &val, &ret) < 1)
> +		return -EINVAL;
> +
> +	if ((val != 0) && (val != 1))
> +		return -EINVAL;
> +
> +	f_retval = ret;
> +
> +	ret = mutex_lock_interruptible(&dev->mutex);
> +	if (ret)
> +		return ret;
> +
> +	current_pio = w1_ds2405_read_pio(sl);
> +	if (current_pio < 0) {
> +		f_retval = current_pio;
> +		goto out_unlock;
> +	}
> +
> +	if (current_pio == val)
> +		goto out_unlock;
> +
> +	if (w1_reset_bus(dev) != 0) {
> +		f_retval = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	do {
> +		u64 dev_addr = cpu_to_le64(((u64)sl->reg_num.crc<<(8+48))
> +			     | ((u64)sl->reg_num.id<<8) | sl->reg_num.family);
> +
> +		w1_write_8(dev, W1_MATCH_ROM);
> +		w1_write_block(dev, (u8 *)&dev_addr, 8);
> +	} while (0);
> +
> +out_unlock:
> +	w1_reset_bus(dev);
> +	mutex_unlock(&dev->mutex);
> +
> +	return f_retval;
> +}
> +
> +static DEVICE_ATTR(sensed, S_IRUSR | S_IRGRP, w1_ds2405_read_sensed_file, NULL);
> +static DEVICE_ATTR(PIO, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP,
> +		    w1_ds2405_read_pio_file, w1_ds2405_write_pio_file);
> +
> +static int w1_ds2405_add_slave(struct w1_slave *sl)
> +{
> +	int err;
> +
> +	err = device_create_file(&sl->dev, &dev_attr_sensed);
> +	if (err)
> +		return err;
> +
> +	err = device_create_file(&sl->dev, &dev_attr_PIO);
> +	if (err) {
> +		device_remove_file(&sl->dev, &dev_attr_sensed);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void w1_ds2405_remove_slave(struct w1_slave *sl)
> +{
> +	device_remove_file(&sl->dev, &dev_attr_sensed);
> +	device_remove_file(&sl->dev, &dev_attr_PIO);
> +}
> +
> +
> +static struct w1_family_ops w1_ds2405_fops = {
> +	.add_slave	= w1_ds2405_add_slave,
> +	.remove_slave	= w1_ds2405_remove_slave,
> +};
> +
> +
> +static struct w1_family w1_family_ds2405 = {
> +	.fid = W1_FAMILY_DS2405,
> +	.fops = &w1_ds2405_fops,
> +};
> +
> +static int __init w1_ds2405_init(void)
> +{
> +	return w1_register_family(&w1_family_ds2405);
> +}
> +
> +static void __exit w1_ds2405_fini(void)
> +{
> +
> +	w1_unregister_family(&w1_family_ds2405);
> +}
> +
> +module_init(w1_ds2405_init);
> +module_exit(w1_ds2405_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Maciej Szmigiero <mhej@o2.pl>");
> +MODULE_DESCRIPTION("Driver for 1-wire Dallas DS2405 PIO");
> --- a/drivers/w1/slaves/Makefile	2010-08-02 00:11:14.000000000 +0200
> +++ b/drivers/w1/slaves/Makefile	2010-10-28 22:39:13.000000000 +0200
> @@ -4,6 +4,7 @@
>  
>  obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
>  obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
> +obj-$(CONFIG_W1_SLAVE_DS2405)	+= w1_ds2405.o
>  obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
>  obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
>  obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
> --- a/drivers/w1/slaves/Kconfig	2010-08-02 00:11:14.000000000 +0200
> +++ b/drivers/w1/slaves/Kconfig	2010-10-28 22:37:55.000000000 +0200
> @@ -16,6 +16,14 @@
>  	  Say Y here if you want to connect 1-wire
>  	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
>  
> +config W1_SLAVE_DS2405
> +	tristate "DS2405 Addressable Switch / PIO"
> +	help
> +	  Say Y here if you want to build driver for 1-wire
> +	  single-channel addressable switch / PIO.
> +	  This device can also work as single-channel
> +	  binary remote sensor.
> +
>  config W1_SLAVE_DS2431
>  	tristate "1kb EEPROM family support (DS2431)"
>  	help
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


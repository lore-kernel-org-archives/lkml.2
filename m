Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0DNXF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:05:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab0DNXFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:05:54 -0400
Date: Thu, 15 Apr 2010 09:05:42 +1000
From: Neil Brown <neilb@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: =?UTF-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>,
       Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] liss331d1: accelerometer driver
Message-ID: <20100415090542.21f9778d@notabene.brown>
In-Reply-To: <20100414223429.GW30807@buzzloop.caiaq.de>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125155.23181.56610.stgit@localhost.localdomain>
	<4BC63DC5.8040501@tudelft.nl>
	<20100414223429.GW30807@buzzloop.caiaq.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 00:34:29 +0200
Daniel Mack <daniel@caiaq.de> wrote:

> On Thu, Apr 15, 2010 at 12:12:21AM +0200, Éric Piel wrote:
> > Op 14-04-10 14:52, Alan Cox schreef:
> > > From: Kalhan Trisal <kalhan.trisal@intel.com>
> > > 
> > > The acceleremeter driver reads the x,y,z coordinate registers and provides
> > > the information to user through the input layer
> > > 
> > > Conversion to input device, clean up and porting of retry fixes needed
> > > for AAVA done by Alan Cox.
> > Hello,
> > 
> > I wouldn't want to be too picky, if this driver works fine with your
> > hardware and it's tested, why not, but from looking at the spec of this
> > chip (and at the code of this driver), it looks like it could be
> > completely compatible with the lis3lv02d driver (with lis3lv02d_i2c).
> > Same registers, including the WHO_AM_I register which returns 0x3B
> > (which is a supported version).
> > 
> > Have you tried and there were some specific incompatibilities? To me, it
> > looks like the only thing not in the lis3lv02d is the read with multiple
> > retries, and it could be easily added if necessary for your hardware.
> 
> Yes, that would be better. Also because there's also a SPI version of
> the lis331dl. If support for this chip would be incorporated in the
> existing driver, they would automatically be supported as well.
> 

The Openmoko Freerunner has as lis302D which is an SPI version of a very
similar device, so making the one driver work on that was well would be nice
if possible.

The lis302d can detect threshold crossings and taps as well as simple
orientation and I found it useful to include support for those in the driver
as well.
In particular:
 1/ I allowed the 'data_rate' that was programmed to be any number (including 
    fractions and 0) and the driver would report at that rate, using a timer
    for rates below 50Hz.
    When the app is only interested in long-term change, this can
    significantly reduce the amount of data that has to be handled by
    userspace.

 2/ I allowed a 'threshold' to be set so that changes bigger than that get
    notified promptly even if that is faster than the requested data rate

 3/ I allowed taps to be detected and reported as BTN_X BTN_Y and BTN_Z
    input events.

Would it be sensible to include that support in this driver?  The
LIS331DL seem to have the same threshold and tap support.

NeilBrown



> Daniel
> 
> 
> > > Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
> > > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > > ---
> > > 
> > >  drivers/hwmon/Kconfig    |    8 +
> > >  drivers/hwmon/Makefile   |    1 
> > >  drivers/hwmon/lis331dl.c |  286 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 295 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/hwmon/lis331dl.c
> > > 
> > > 
> > > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> > > index 1fa2533..6868b9d 100644
> > > --- a/drivers/hwmon/Kconfig
> > > +++ b/drivers/hwmon/Kconfig
> > > @@ -1104,6 +1104,14 @@ config SENSORS_ISL29020
> > >  	  Range values can be configured using sysfs.
> > >  	  Lux data is accessible via sysfs.
> > >  
> > > +config SENSORS_LIS331DL
> > > +	tristate "STMicroeletronics LIS331DL three-axis digital accelerometer"
> > > +	depends on I2C
> > > +	help
> > > +	  If you say yes here you get support for the Accelerometer  Devices
> > > +	  Device can be configured using sysfs.
> > > +	  x y Z data can be   accessible via sysfs.
> > > +
> > >  if ACPI
> > >  
> > >  comment "ACPI drivers"
> > > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> > > index 13d6832..ebeb2a2 100644
> > > --- a/drivers/hwmon/Makefile
> > > +++ b/drivers/hwmon/Makefile
> > > @@ -60,6 +60,7 @@ obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
> > >  obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
> > >  obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
> > >  obj-$(CONFIG_SENSORS_LIS3_I2C)	+= lis3lv02d.o lis3lv02d_i2c.o
> > > +obj-$(CONFIG_SENSORS_LIS331DL)	+= lis331dl.o
> > >  obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
> > >  obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
> > >  obj-$(CONFIG_SENSORS_LM73)	+= lm73.o
> > > diff --git a/drivers/hwmon/lis331dl.c b/drivers/hwmon/lis331dl.c
> > > new file mode 100644
> > > index 0000000..34009eb
> > > --- /dev/null
> > > +++ b/drivers/hwmon/lis331dl.c
> > > @@ -0,0 +1,286 @@
> > > +/*
> > > + * lis331dl.c - ST LIS331DL  Accelerometer Driver
> > > + *
> > > + * Copyright (C) 2009 Intel Corp
> > > + *
> > > + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation; version 2 of the License.
> > > + *
> > > + * This program is distributed in the hope that it will be useful, but
> > > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> > > + * General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License along
> > > + * with this program; if not, write to the Free Software Foundation, Inc.,
> > > + * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> > > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > + *
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/init.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/err.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/sysfs.h>
> > > +#include <linux/input-polldev.h>
> > > +
> > > +
> > > +#define POLL_INTERVAL	50
> > > +
> > > +struct lis331dl {
> > > +	struct input_polled_dev *idev;
> > > +	struct i2c_client *client;
> > > +	struct mutex update_lock;
> > > +};
> > > +
> > > +static ssize_t data_rate_show(struct device *dev,
> > > +			struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct i2c_client *client = to_i2c_client(dev);
> > > +	int val;
> > > +	int speed = 100;
> > > +
> > > +	val = i2c_smbus_read_byte_data(client, 0x20);
> > > +	if (val & 0x80); /* 1= 400HZ 0= 100HZ */
> > > +		speed = 400;
> > > +	return sprintf(buf, "%d\n", speed);
> > > +}
> > > +
> > > +static ssize_t power_mode_show(struct device *dev,
> > > +			struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct i2c_client *client = to_i2c_client(dev);
> > > +	int val;
> > > +
> > > +	val = i2c_smbus_read_byte_data(client, 0x20) & 0x40;
> > > +	if (val == 0x40)
> > > +		val = 1;
> > > +	return sprintf(buf, "%d\n", val);
> > > +}
> > > +
> > > +static int read_with_retries(struct i2c_client *client, int r)
> > > +{
> > > +	int retries;
> > > +	int ret;
> > > +	
> > > +	for (retries = 0; retries < 5; retries++) {
> > > +		ret = i2c_smbus_read_byte_data(client, r);
> > > +		if (ret != -ETIMEDOUT)
> > > +			break;
> > > +		msleep(10);
> > > +	}
> > > +	return ret;
> > > +}
> > > +
> > > +static void lis331dl_poll(struct input_polled_dev *idev)
> > > +{
> > > +	struct input_dev *input = idev->input;
> > > +	struct lis331dl *data = idev->private;
> > > +	int x, y, z;
> > > +	struct i2c_client *client = data->client;
> > > +
> > > +	x = read_with_retries(client, 0x29);
> > > +	y = read_with_retries(client, 0x2B);
> > > +	z = read_with_retries(client, 0x2D);
> > > +
> > > +	input_report_abs(input, ABS_X, x);
> > > +	input_report_abs(input, ABS_Y, y);
> > > +	input_report_abs(input, ABS_Z, z);
> > > +	input_sync(input);
> > > +}
> > > +
> > > +static ssize_t data_rate_store(struct device *dev,
> > > +		struct device_attribute *attr, const char *buf, size_t count)
> > > +{
> > > +	struct i2c_client *client = to_i2c_client(dev);
> > > +	struct lis331dl *data = i2c_get_clientdata(client);
> > > +	unsigned int ret_val;
> > > +	unsigned long val;
> > > +
> > > +	if (strict_strtoul(buf, 10, &val))
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&data->update_lock);
> > > +
> > > +	ret_val = i2c_smbus_read_byte_data(client, 0x20);
> > > +	ret_val &= 0x7F;
> > > +
> > > +	switch (val) {
> > > +	case 400:
> > > +		ret_val |= 0x80;
> > > +	case 100:
> > > +		i2c_smbus_write_byte_data(client, 0x20, ret_val);
> > > +		break;
> > > +	default:		
> > > +		mutex_unlock(&data->update_lock);
> > > +		return -EINVAL;
> > > +	}
> > > +	mutex_unlock(&data->update_lock);
> > > +	return count;
> > > +}
> > > +
> > > +static ssize_t power_mode_store(struct device *dev,
> > > +		struct device_attribute *attr, const  char *buf, size_t count)
> > > +{
> > > +	struct i2c_client *client = to_i2c_client(dev);
> > > +	struct lis331dl *data = i2c_get_clientdata(client);
> > > +	unsigned int ret_val;
> > > +	unsigned long val;
> > > +
> > > +	if (strict_strtoul(buf, 10, &val))
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&data->update_lock);
> > > +
> > > +	ret_val = i2c_smbus_read_byte_data(client, 0x20);
> > > +	ret_val &= 0xBF;
> > > +	
> > > +	switch(val) {
> > > +	case 1:
> > > +		ret_val |= 0x40;
> > > +	case 0:
> > > +		i2c_smbus_write_byte_data(client, 0x20, ret_val);
> > > +		break;
> > > +	default:
> > > +		mutex_unlock(&data->update_lock);
> > > +		return -EINVAL;
> > > +	}
> > > +	mutex_unlock(&data->update_lock);
> > > +	return count;
> > > +}
> > > +
> > > +static DEVICE_ATTR(data_rate, S_IRUGO | S_IWUSR,
> > > +	data_rate_show, data_rate_store);
> > > +static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
> > > +	power_mode_show, power_mode_store);
> > > +
> > > +static struct attribute *mid_att_accelero[] = {
> > > +	&dev_attr_data_rate.attr,
> > > +	&dev_attr_power_state.attr,
> > > +	NULL
> > > +};
> > > +
> > > +static struct attribute_group m_accelero_gr = {
> > > +	.name = "lis331dl",
> > > +	.attrs = mid_att_accelero
> > > +};
> > > +
> > > +static void accel_set_default_config(struct i2c_client *client)
> > > +{
> > > +	i2c_smbus_write_byte_data(client, 0x20, 0x47);
> > > +}
> > > +
> > > +static int  lis331dl_probe(struct i2c_client *client,
> > > +					const struct i2c_device_id *id)
> > > +{
> > > +	int res;
> > > +	struct lis331dl *data;
> > > +	struct input_polled_dev *idev;
> > > +	struct input_dev *input;
> > > +
> > > +	data = kzalloc(sizeof(struct lis331dl), GFP_KERNEL);
> > > +	if (data == NULL) {
> > > +		dev_err(&client->dev, "lis331dl: out of memory\n");
> > > +		return -ENOMEM;
> > > +	}
> > > +	mutex_init(&data->update_lock);
> > > +	i2c_set_clientdata(client, data);
> > > +	data->client = client;
> > > +
> > > +	res = sysfs_create_group(&client->dev.kobj, &m_accelero_gr);
> > > +	if (res) {
> > > +		dev_err(&client->dev, "lis331dl: sysfs  group failed\n");
> > > +		goto accelero_error1;
> > > +	}
> > > +	idev = input_allocate_polled_device();
> > > +	if (!idev) {
> > > +		res = -ENOMEM;
> > > +		dev_err(&client->dev,
> > > +			"lis331dl: unable to register input device\n");
> > > +		goto accelero_error2;
> > > +	}
> > > +	idev->poll = lis331dl_poll;
> > > +	idev->poll_interval = POLL_INTERVAL;
> > > +
> > > +	idev->private = data;
> > > +	data->idev =  idev;
> > > +
> > > +	input = idev->input;
> > > +	input->name = "lis331dl";
> > > +	input->phys = "lis331dl/input0";
> > > +	input->id.bustype = BUS_I2C;
> > > +	input->dev.parent = &client->dev;
> > > +	input->evbit[0] = BIT_MASK(EV_ABS);
> > > +	input_set_abs_params(input, ABS_X, 0, 255, 2, 2);
> > > +	input_set_abs_params(input, ABS_Y, 0, 255, 2, 2);
> > > +	input_set_abs_params(input, ABS_Z, 0, 255, 2, 2);
> > > +
> > > +	res = input_register_polled_device(idev);
> > > +	if (res == 0) {
> > > +		dev_info(&client->dev,
> > > +			"%s lis331dl:  Accelerometer chip found",
> > > +							client->name);
> > > +		return 0;
> > > +	}
> > > +	input_free_polled_device(idev);
> > > +accelero_error2:
> > > +	sysfs_remove_group(&client->dev.kobj, &m_accelero_gr);
> > > +accelero_error1:
> > > +	i2c_set_clientdata(client, NULL);
> > > +	kfree(data);
> > > +	return res;
> > > +}
> > > +
> > > +static int lis331dl_remove(struct i2c_client *client)
> > > +{
> > > +	struct lis331dl *data = i2c_get_clientdata(client);
> > > +
> > > +	input_unregister_polled_device(data->idev);
> > > +	input_free_polled_device(data->idev);
> > > +	sysfs_remove_group(&client->dev.kobj, &m_accelero_gr);
> > > +	kfree(data);
> > > +	return 0;
> > > +}
> > > +
> > > +static struct i2c_device_id lis331dl_id[] = {
> > > +	{ "i2c_accel", 0 },
> > > +	{ }
> > > +};
> > > +
> > > +MODULE_DEVICE_TABLE(i2c, lis331dl_id);
> > > +
> > > +static struct i2c_driver lis331dl_driver = {
> > > +	.driver = {
> > > +	.name = "lis331dl",
> > > +	},
> > > +	.probe = lis331dl_probe,
> > > +	.remove = lis331dl_remove,
> > > +	.id_table = lis331dl_id,
> > > +};
> > > +
> > > +static int __init sensor_lis331dl_init(void)
> > > +{
> > > +	int res;
> > > +
> > > +	res = i2c_add_driver(&lis331dl_driver);
> > > +	return res;
> > > +}
> > > +
> > > +static void  __exit sensor_lis331dl_exit(void)
> > > +{
> > > +	i2c_del_driver(&lis331dl_driver);
> > > +}
> > > +
> > > +module_init(sensor_lis331dl_init);
> > > +module_exit(sensor_lis331dl_exit);
> > > +
> > > +MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com>, Alan Cox");
> > > +MODULE_DESCRIPTION("STMicroelectronics LIS331DL Accelerometer Driver");
> > > +MODULE_LICENSE("GPL v2");
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1D3Jy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 05:54:29 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:50210 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1D3JyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 05:54:23 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DBBDCCF.4010104@cam.ac.uk>
Date: Sat, 30 Apr 2011 10:56:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [lm-sensors] [RFC 5/5] hwmon: add support for Technologic Systems
 TS-5500 A-D converter
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-6-git-send-email-vivien.didelot@savoirfairelinux.com> <20110430033938.GA14397@ericsson.com>
In-Reply-To: <20110430033938.GA14397@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/11 04:39, Guenter Roeck wrote:
> On Fri, Apr 29, 2011 at 06:21:52PM -0400, Vivien Didelot wrote:
>> From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
>>
>>
>> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> 
> Hi Vivien,
> 
> The headline and file name are a bit misleading, since the driver is really
> for MAX197 on a TS-5500 board.
> 
> You should split the driver into two parts, a generic driver
> for the MAX197 and a platform driver (residing somewhere in arch/
> or possibly drivers/platform/) to instantiate it.
The bus looks 'interesting'. Vivien, is this a common interface to
parts? If so, perhaps we want a small layer in between the raw reads
on the ts5500 and what hits the maxim part.  That would allow us
to simply support other means of talking to this chip. If it's a very
much part specific interface, then we can leave generalizing until
someone actually needs it of course!
> 
> There should be a platform data include file, probably in
> include/linux/platform_data/.
> 
> .ioaddr in platform data should not be necessary. The driver's probe
> function should get the values using platform_get_resource().
> 
> Having said that, from reading the code it looks like the chip is not really
> used for hardware monitoring, but for generic ADC functionality. A quick look
> into the TS-5500 user manual confirms this. So this should not be a hwmon
> driver in the first place, but a generic ADC driver. Given the ADC conversion rate
> of the MAX197, the hwmon ABI is not optimal anyway. You should move this driver
> into the iio subsystem, probably to drivers/staging/iio/adc. Copying the iio
> mailing list for input.
Yup, that does make sense here as far as I can tell. Definitely wants to be broken
up in the platform bit and max197 drivers though as Guenter has said.
> 
> Thanks,
> Guenter
Thanks for cc'ing us...
> 
>> ---
>>  MAINTAINERS                |    1 +
>>  drivers/hwmon/Kconfig      |   10 +
>>  drivers/hwmon/Makefile     |    1 +
>>  drivers/hwmon/ts5500-adc.c |  481 ++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 493 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/hwmon/ts5500-adc.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index c0a646d..aace74a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6062,6 +6062,7 @@ F:        drivers/gpio/ts5500-gpio.c
>>  F:     include/linux/ts5500-gpio.h
>>  F:     drivers/tty/serial/ts5500-auto485.c
>>  F:     drivers/leds/leds-ts5500.c
>> +F:     drivers/hwmon/ts5500-adc.c
>>
>>  TEGRA SUPPORT
>>  M:     Colin Cross <ccross@android.com>
>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index 060ef63..5070530 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -1286,6 +1286,16 @@ config SENSORS_MC13783_ADC
>>          help
>>            Support for the A/D converter on MC13783 PMIC.
>>
>> +config SENSORS_TS5500_ADC
>> +        tristate "Technologic Systems TS-5500 ADC"
>> +        depends on TS5500_SBC
>> +        help
>> +      Support for the A/D converter on Technologic Systems TS-5500
>> +         SBCs.
>> +
>> +         This driver can also be built as a module.  If so, the module
>> +         will be called ts5500-adc.
>> +
>>  if ACPI
>>
>>  comment "ACPI drivers"
>> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
>> index 967d0ea..9c8563d 100644
>> --- a/drivers/hwmon/Makefile
>> +++ b/drivers/hwmon/Makefile
>> @@ -114,6 +114,7 @@ obj-$(CONFIG_SENSORS_W83L785TS)     += w83l785ts.o
>>  obj-$(CONFIG_SENSORS_W83L786NG)        += w83l786ng.o
>>  obj-$(CONFIG_SENSORS_WM831X)   += wm831x-hwmon.o
>>  obj-$(CONFIG_SENSORS_WM8350)   += wm8350-hwmon.o
>> +obj-$(CONFIG_SENSORS_TS5500_ADC)+= ts5500-adc.o
>>
>>  # PMBus drivers
>>  obj-$(CONFIG_PMBUS)            += pmbus_core.o
>> diff --git a/drivers/hwmon/ts5500-adc.c b/drivers/hwmon/ts5500-adc.c
>> new file mode 100644
>> index 0000000..6568e9e
>> --- /dev/null
>> +++ b/drivers/hwmon/ts5500-adc.c
>> @@ -0,0 +1,481 @@
>> +/*
>> + * Technologic Systems TS-5500 boards - MAX197 ADC driver
>> + *
>> + * Copyright (c) 2010 Savoir-faire Linux Inc.
>> + *          Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
>> + *
>> + * Portions Copyright (C) 2008 Marc Pignat <marc.pignat@hevs.ch>
>> + *
>> + * The driver uses direct access for communication with the ADC.
>> + * Should work unchanged with the MAX199 chip.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/device.h>
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/err.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/hwmon-sysfs.h>
>> +#include <linux/mutex.h>
>> +#include <linux/ts5xxx-sbcinfo.h>
>> +#include <linux/slab.h>
>> +#include <linux/io.h>
>> +
>> +#define MODULE_NAME    "ts5500-max197"
>> +
>> +/*
>> + * Control bits of A/D command
>> + * bits 0-2:   selected channel (0 - 7)
>> + * bits 3:     uni/bipolar (0 = unipolar (ie 0 to +5V))
>> + *                         (1 = bipolar (ie -5 to +5V))
>> + * bit 4:      selected range (0 = 5v range, 1 = 10V range)
>> + * bit 5-7:    padded zero (unused)
>> + */
>> +#define TS5500_MAX197_BIPOLAR          0x08
>> +#define TS5500_MAX197_UNIPOLAR         0x00
>> +#define TS5500_MAX197_RANGE_5V         0x00    /* 0 to 5V range */
>> +#define TS5500_MAX197_RANGE_10V                0x10    /* 0 to 10V range */
>> +
>> +#define TS5500_MAX197_READ_DELAY       15      /* usec */
>> +#define TS5500_MAX197_READ_BUSY_MASK   0x01
>> +#define TS5500_MAX197_NAME             "MAX197 (8 channels)"
>> +
>> +#define MAX197_CHANNELS_MAX            8       /* 0 to 7 channels on device */
>> +
>> +#define max197_test_bit(bit, map)      (test_bit(bit, map) != 0)
>> +
>> +/**
>> + * struct max197_platform_data
>> + * @name:      Name of the device.
>> + * @ioaddr:    I/O address containing:
>> + *             .data:          Data register for conversion reading.
>> + *             .ctrl:          A/D Control Register (bit 0 = 0 when
>> + *                             conversion completed).
>> + * @read:      Information about conversion reading, with:
>> + *             .delay:         Delay before next conversion.
>> + *             .busy_mask:     Control register bit 0 equals 1 means
>> + *                             conversion is not completed yet.
>> + * @ctrl:      Data tables addressable by [polarity][range].
>> + * @ranges:    Ranges.
>> + *             .min:           Min value.
>> + *             .max:           Max value.
>> + * @scale:     Polarity/Range coefficients to scale raw conversion reading.
>> + */
>> +struct max197_platform_data {
>> +       const char *name;
>> +       struct {
>> +               int data;
>> +               int ctrl;
>> +       } ioaddr;
>> +       struct {
>> +               u8 delay;
>> +               u8 busy_mask;
>> +       } read;
>> +       u8 ctrl[2][2];
>> +       struct {
>> +               int min[2][2];
>> +               int max[2][2];
>> +       } ranges;
>> +       int scale[2][2];
>> +};
>> +
>> +/**
>> + * struct max197_chip
>> + * @hwmon_dev:         The hwmon device.
>> + * @lock:              Read/Write mutex.
>> + * @spec:              The MAX197 platform data.
>> + * @polarity:          bitmap for polarity.
>> + * @range:             bitmap for range.
>> + */
>> +struct max197_chip {
>> +       struct device *hwmon_dev;
>> +       struct mutex lock;
>> +       struct max197_platform_data spec;
>> +       DECLARE_BITMAP(polarity, MAX197_CHANNELS_MAX);
>> +       DECLARE_BITMAP(range, MAX197_CHANNELS_MAX);
>> +};
>> +
>> +static inline s32 max197_scale(struct max197_chip *chip, s16 raw,
>> +                                  int polarity, int range)
>> +{
>> +       s32 scaled = raw;
>> +
>> +       scaled *= chip->spec.scale[polarity][range];
>> +       scaled /= 10000;
>> +
>> +       return scaled;
>> +}
>> +
>> +static inline int max197_range(struct max197_chip *chip, int is_min,
>> +                              int polarity, int range)
>> +{
>> +       if (is_min)
>> +               return chip->spec.ranges.min[polarity][range];
>> +       return chip->spec.ranges.max[polarity][range];
>> +}
>> +
>> +static inline int max197_strtol(const char *buf, long *value, int range1,
>> +                               int range2)
>> +{
>> +       if (strict_strtol(buf, 10, value))
>> +               return -EINVAL;
>> +
>> +       if (range1 < range2)
>> +               *value = SENSORS_LIMIT(*value, range1, range2);
>> +       else
>> +               *value = SENSORS_LIMIT(*value, range2, range1);
>> +
>> +       return 0;
>> +}
>> +
>> +static inline struct max197_chip *max197_get_drvdata(struct device *dev)
>> +{
>> +       return platform_get_drvdata(to_platform_device(dev));
>> +}
>> +
>> +/**
>> + * max197_show_range() - Display range on user output
>> + *
>> + * Function called on read access on
>> + * /sys/devices/platform/ts5500-max197/in{0,1,2,3,4,5,6,7}_{min,max}
>> + */
>> +static ssize_t max197_show_range(struct device *dev,
>> +                                struct device_attribute *devattr, char *buf)
>> +{
>> +       struct max197_chip *chip = max197_get_drvdata(dev);
>> +       struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>> +       int is_min = attr->nr != 0;
>> +       int polarity, range;
>> +
>> +       if (mutex_lock_interruptible(&chip->lock))
>> +               return -ERESTARTSYS;
>> +
>> +       polarity = max197_test_bit(attr->index, chip->polarity);
>> +       range = max197_test_bit(attr->index, chip->range);
>> +
>> +       mutex_unlock(&chip->lock);
>> +
>> +       return sprintf(buf, "%d\n",
>> +                      max197_range(chip, is_min, polarity, range));
>> +}
>> +
>> +/**
>> + * max197_store_range() - Write range from user input
>> + *
>> + * Function called on write access on
>> + * /sys/devices/platform/ts5500-max197/in{0,1,2,3,4,5,6,7}_{min,max}
>> + */
>> +static ssize_t max197_store_range(struct device *dev,
>> +                                 struct device_attribute *devattr,
>> +                                 const char *buf, size_t count)
>> +{
>> +       struct max197_chip *chip = max197_get_drvdata(dev);
>> +       struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>> +       int is_min = attr->nr != 0;
>> +       int range1 = max197_range(chip, is_min, 0, 0);
>> +       int range2 = max197_range(chip, is_min, 1, 1);
>> +       long value;
>> +
>> +       if (max197_strtol(buf, &value, range1, range2))
>> +               return -EINVAL;
>> +
>> +       if (mutex_lock_interruptible(&chip->lock))
>> +               return -ERESTARTSYS;
>> +
>> +       if (abs(value) > 5000)
>> +               set_bit(attr->index, chip->range);
>> +       else
>> +               clear_bit(attr->index, chip->range);
>> +
>> +       if (is_min) {
>> +               if (value < 0)
>> +                       set_bit(attr->index, chip->polarity);
>> +               else
>> +                       clear_bit(attr->index, chip->polarity);
>> +       }
>> +
>> +       mutex_unlock(&chip->lock);
>> +
>> +       return count;
>> +}
>> +
>> +/**
>> + * max197_show_input() - Show channel input
>> + *
>> + * Function called on read access on
>> + * /sys/devices/platform/ts5500-max197/in{0,1,2,3,4,5,6,7}_input
>> + */
>> +static ssize_t max197_show_input(struct device *dev,
>> +                                struct device_attribute *devattr, char *buf)
>> +{
>> +       struct max197_chip *chip = max197_get_drvdata(dev);
>> +       struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +       int polarity, range;
>> +       int ret;
>> +       u8 command;
>> +
>> +       if (mutex_lock_interruptible(&chip->lock))
>> +               return -ERESTARTSYS;
>> +
>> +       polarity = max197_test_bit(attr->index, chip->polarity);
>> +       range = max197_test_bit(attr->index, chip->range);
>> +
>> +       command = attr->index | chip->spec.ctrl[polarity][range];
>> +
>> +       outb(command, chip->spec.ioaddr.data);
>> +
>> +       udelay(chip->spec.read.delay);
>> +       ret = inb(chip->spec.ioaddr.ctrl);
>> +
>> +       if (ret & chip->spec.read.busy_mask) {
>> +               dev_err(dev, "device not ready (ret=0x0%x, try=%d)\n", ret,
>> +                       range);
>> +               ret = -EIO;
>> +       } else {
>> +               /* LSB of conversion is at 0x196 and MSB is at 0x197 */
>> +               u8 lsb = inb(chip->spec.ioaddr.data);
>> +               u8 msb = inb(chip->spec.ioaddr.data + 1);
>> +               s16 raw = (msb << 8) | lsb;
>> +               s32 scaled = max197_scale(chip, raw, polarity, range);
>> +
>> +               ret = sprintf(buf, "%d\n", scaled);
>> +       }
>> +
>> +       mutex_unlock(&chip->lock);
>> +       return ret;
>> +}
>> +
>> +static ssize_t max197_show_name(struct device *dev,
>> +       struct device_attribute *devattr, char *buf)
>> +{
>> +       return sprintf(buf, "%s\n", max197_get_drvdata(dev)->spec.name);
>> +}
>> +
>> +#define MAX197_HWMON_CHANNEL(chan)                             \
>> +       SENSOR_DEVICE_ATTR(in##chan##_input, S_IRUGO,           \
>> +                          max197_show_input, NULL, chan);      \
>> +       SENSOR_DEVICE_ATTR_2(in##chan##_max, S_IRUGO | S_IWUSR, \
>> +                            max197_show_range,                 \
>> +                            max197_store_range, 0, chan);      \
>> +       SENSOR_DEVICE_ATTR_2(in##chan##_min, S_IRUGO | S_IWUSR, \
>> +                            max197_show_range,                 \
>> +                            max197_store_range, 1, chan)       \
>> +
>> +#define MAX197_SYSFS_CHANNEL(chan)                             \
>> +       &sensor_dev_attr_in##chan##_input.dev_attr.attr,        \
>> +       &sensor_dev_attr_in##chan##_max.dev_attr.attr,          \
>> +       &sensor_dev_attr_in##chan##_min.dev_attr.attr
>> +
>> +static DEVICE_ATTR(name, S_IRUGO, max197_show_name, NULL);
>> +
>> +static MAX197_HWMON_CHANNEL(0);
>> +static MAX197_HWMON_CHANNEL(1);
>> +static MAX197_HWMON_CHANNEL(2);
>> +static MAX197_HWMON_CHANNEL(3);
>> +static MAX197_HWMON_CHANNEL(4);
>> +static MAX197_HWMON_CHANNEL(5);
>> +static MAX197_HWMON_CHANNEL(6);
>> +static MAX197_HWMON_CHANNEL(7);
>> +
>> +static const struct attribute_group max197_sysfs_group = {
>> +       .attrs = (struct attribute *[]) {
>> +               &dev_attr_name.attr,
>> +               MAX197_SYSFS_CHANNEL(0),
>> +               MAX197_SYSFS_CHANNEL(1),
>> +               MAX197_SYSFS_CHANNEL(2),
>> +               MAX197_SYSFS_CHANNEL(3),
>> +               MAX197_SYSFS_CHANNEL(4),
>> +               MAX197_SYSFS_CHANNEL(5),
>> +               MAX197_SYSFS_CHANNEL(6),
>> +               MAX197_SYSFS_CHANNEL(7),
>> +               NULL
>> +       }
>> +};
>> +
>> +static int __devinit max197_probe(struct platform_device *pdev)
>> +{
>> +       struct max197_platform_data *pdata = pdev->dev.platform_data;
>> +       struct max197_chip *chip;
>> +       int ret;
>> +
>> +       if (pdata == NULL)
>> +               return -ENODEV;
>> +
>> +       chip = kzalloc(sizeof *chip, GFP_KERNEL);
>> +       if (!chip)
>> +               return -ENOMEM;
>> +
>> +       chip->spec = *pdata;
>> +
>> +       mutex_init(&chip->lock);
>> +       mutex_lock(&chip->lock);
>> +
>> +       ret = sysfs_create_group(&pdev->dev.kobj, &max197_sysfs_group);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "sysfs_create_group failed.\n");
>> +               goto error_unlock_and_free;
>> +       }
>> +
>> +       chip->hwmon_dev = hwmon_device_register(&pdev->dev);
>> +       if (IS_ERR(chip->hwmon_dev)) {
>> +               dev_err(&pdev->dev, "hwmon_device_register failed.\n");
>> +               ret = PTR_ERR(chip->hwmon_dev);
>> +               goto error_unregister_device;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, chip);
>> +       mutex_unlock(&chip->lock);
>> +       return 0;
>> +
>> +error_unregister_device:
>> +       sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
>> +
>> +error_unlock_and_free:
>> +       mutex_unlock(&chip->lock);
>> +       kfree(chip);
>> +       return ret;
>> +}
>> +
>> +static int __devexit max197_remove(struct platform_device *pdev)
>> +{
>> +       struct max197_chip *chip = platform_get_drvdata(pdev);
>> +
>> +       mutex_lock(&chip->lock);
>> +       hwmon_device_unregister(chip->hwmon_dev);
>> +       sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
>> +       platform_set_drvdata(pdev, NULL);
>> +       mutex_unlock(&chip->lock);
>> +       kfree(chip);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct platform_driver max197_driver = {
>> +       .driver = {
>> +               .name   = MODULE_NAME,
>> +               .owner  = THIS_MODULE,
>> +       },
>> +       .probe  = max197_probe,
>> +       .remove = __devexit_p(max197_remove),
>> +};
>> +
>> +static void ts5500_max197_release(struct device *dev)
>> +{
>> +       /* noop */
>> +}
>> +
>> +static struct resource ts5500_max197_resources[] = {
>> +       {
>> +               .name  = MODULE_NAME "-data",
>> +               .start = 0x196,
>> +               .end   = 0x197,
>> +               .flags = IORESOURCE_IO,
>> +       },
>> +       {
>> +               .name  = MODULE_NAME "-ctrl",
>> +               .start = 0x195,
>> +               .end   = 0x195,
>> +               .flags = IORESOURCE_IO,
>> +       }
>> +};
>> +
>> +static struct max197_platform_data ts5500_max197_platform_data = {
>> +       .name = TS5500_MAX197_NAME,
>> +       .ioaddr = {
>> +               .data = 0x196,
>> +               .ctrl = 0x195,
>> +       },
>> +       .read = {
>> +               .delay     = TS5500_MAX197_READ_DELAY,
>> +               .busy_mask = TS5500_MAX197_READ_BUSY_MASK,
>> +       },
>> +       .ctrl = {
>> +               { TS5500_MAX197_UNIPOLAR | TS5500_MAX197_RANGE_5V,
>> +                 TS5500_MAX197_UNIPOLAR | TS5500_MAX197_RANGE_10V },
>> +               { TS5500_MAX197_BIPOLAR  | TS5500_MAX197_RANGE_5V,
>> +                 TS5500_MAX197_BIPOLAR  | TS5500_MAX197_RANGE_10V },
>> +       },
>> +       .ranges = {
>> +               .min = {
>> +                       {  0,     0 },
>> +                       { -5000, -10000 },
>> +               },
>> +               .max = {
>> +                       {  5000,  10000 },
>> +                       {  5000,  10000 },
>> +               },
>> +       },
>> +       .scale = {
>> +               { 12207, 24414 },
>> +               { 24414, 48828 },
>> +       },
>> +};
>> +
>> +static struct platform_device ts5500_max197_device = {
>> +       .name = MODULE_NAME,
>> +       .id = -1,
>> +       .resource = ts5500_max197_resources,
>> +       .num_resources = ARRAY_SIZE(ts5500_max197_resources),
>> +       .dev = {
>> +               .platform_data = &ts5500_max197_platform_data,
>> +               .release = ts5500_max197_release,
>> +       },
>> +};
>> +
>> +static int __init ts5500_max197_init(void)
>> +{
>> +       struct ts5xxx_sbcinfo sbcinfo;
>> +       int ret;
>> +
>> +       ts5xxx_sbcinfo_set(&sbcinfo);
>> +       if (5500 != sbcinfo.board_id && !sbcinfo.adc) {
>> +               printk(MODULE_NAME ": Incompatible TS Board.\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       ret = platform_driver_register(&max197_driver);
>> +       if (ret)
>> +               goto error_out;
>> +
>> +       ret = platform_device_register(&ts5500_max197_device);
>> +       if (ret)
>> +               goto error_device_register;
>> +
>> +       return 0;
>> +
>> +error_device_register:
>> +       platform_driver_unregister(&max197_driver);
>> +error_out:
>> +       return ret;
>> +}
>> +module_init(ts5500_max197_init);
>> +
>> +static void __exit ts5500_max197_exit(void)
>> +{
>> +       platform_device_unregister(&ts5500_max197_device);
>> +       platform_driver_unregister(&max197_driver);
>> +}
>> +module_exit(ts5500_max197_exit);
>> +
>> +MODULE_DESCRIPTION("TS5500 MAX197 ADC device driver");
>> +MODULE_AUTHOR("Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("platform:ts5500-max197");
>> --
>> 1.7.1
>>
>>
>> _______________________________________________
>> lm-sensors mailing list
>> lm-sensors@lm-sensors.org
>> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


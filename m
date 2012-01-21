Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2AUALk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:11:40 -0500
Received: from imr4.ericy.com ([198.24.6.9]:33094 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab2AUALi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:11:38 -0500
Date: Fri, 20 Jan 2012 16:09:13 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4 4/4] x86/platform: (TS-5500) add ADC support
Message-ID: <20120121000913.GA3089@ericsson.com>
References: <1326930731-21215-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120119025549.GA20804@ericsson.com>
 <20120120184150.3f0050a8@v0nbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120120184150.3f0050a8@v0nbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivien,

On Fri, Jan 20, 2012 at 06:41:50PM -0500, Vivien Didelot wrote:
> Hi Guenter,
> 
> Thanks for the code review.
> 
> On Wed, 18 Jan 2012 18:55:49
> -0800, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > On Wed, Jan 18, 2012 at 06:52:11PM -0500, Vivien Didelot wrote:
> > > From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > >
> > > Signed-off-by: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > ---
> > >  arch/x86/platform/ts5500/Kconfig      |    7 +
> > >  arch/x86/platform/ts5500/Makefile     |    1 +
> > >  arch/x86/platform/ts5500/ts5500_adc.c |  478
> > > +++++++++++++++++++++++++++++++++ 3 files changed, 486
> > > insertions(+), 0 deletions(-) create mode 100644
> > > arch/x86/platform/ts5500/ts5500_adc.c
> > >
> > I can not comment about the other drivers, but this is a hwmon
> > driver, and thus should reside in drivers/hwmon and be reviewed and
> > handled on the hwmon mailing list (copied).
> 
> The ADC is a MAX197, but it is totally abstracted by the TS-5500 CPLD.
> The device (and its driver) is then really specific to the TS-5500
> platform (like the other devices). So the driver should be in its
> platform directory.
> 
I disagree. There are lots of other platform specific hwmon drivers in the hwmon directory.

If there is a new upstream policy to move such drivers into platform specific directories,
please point me to it (or someone else point me to it, please). I don't think that would
be supportable, though, since subsystem maintainers will hardly ever know about such drivers,
and a lot of bad code could get in. It was more or less accidential that I noticed this one.

In addition to that, it would be an easy way to bypass the review process and sneak in drivers
in unrelated directories. We would then be stuck having to support drivers we never
had a chance to review - and just saying "sorry, not my problem" doesn't seem to be the
right way either.

> >
> > Couple of additional comments below; just some things I noticed, not
> > a complete review.
> >
> > > diff --git a/arch/x86/platform/ts5500/Kconfig
> > > b/arch/x86/platform/ts5500/Kconfig index 76f777f..f1a5f1d 100644
> > > --- a/arch/x86/platform/ts5500/Kconfig
> > > +++ b/arch/x86/platform/ts5500/Kconfig
> > > @@ -20,3 +20,10 @@ config TS5500_LED
> > >     default y
> > >     help
> > >       This option enables support for the on-chip LED.
> > > +
> > > +config TS5500_ADC
> > > +   tristate "TS-5500 ADC"
> > > +   depends on TS5500 && HWMON=y
> > > +   default y
> > > +   help
> > > +      Support for the A/D converter on Technologic Systems TS-5500
> > > SBCs. diff --git a/arch/x86/platform/ts5500/Makefile
> > > b/arch/x86/platform/ts5500/Makefile index 88eccc9..dcf46d8 100644
> > > --- a/arch/x86/platform/ts5500/Makefile
> > > +++ b/arch/x86/platform/ts5500/Makefile
> > > @@ -1,3 +1,4 @@
> > >  obj-$(CONFIG_TS5500)                       += ts5500.o
> > >  obj-$(CONFIG_TS5500_GPIO)          += ts5500_gpio.o
> > >  obj-$(CONFIG_TS5500_LED)           += ts5500_led.o
> > > +obj-$(CONFIG_TS5500_ADC)           += ts5500_adc.o
> > > diff --git a/arch/x86/platform/ts5500/ts5500_adc.c
> > > b/arch/x86/platform/ts5500/ts5500_adc.c new file mode 100644
> > > index 0000000..fc4560f
> > > --- /dev/null
> > > +++ b/arch/x86/platform/ts5500/ts5500_adc.c
> > > @@ -0,0 +1,478 @@
> > > +/*
> > > + * Technologic Systems TS-5500 boards - Mapped MAX197 ADC driver
> > > + *
> > > + * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
> > > + *          Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > > + *
> > > + * Portions Copyright (C) 2008 Marc Pignat <marc.pignat@hevs.ch>
> > > + *
> > > + * The driver uses direct access for communication with the ADC.
> > > + * Should work unchanged with the MAX199 chip.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > modify
> > > + * it under the terms of the GNU General Public License as
> > > published by
> > > + * the Free Software Foundation; either version 2 of the License,
> > > or
> > > + * (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public
> > > License
> > > + * along with this program; if not, write to the Free Software
> > > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > > + *
> > > + * The TS-5500 uses a CPLD to abstract the interface to a MAX197.
> > > + */
> > > +
> > > +#include <linux/init.h>
> > > +#include <linux/module.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/device.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/err.h>
> > > +#include <linux/sysfs.h>
> > > +#include <linux/hwmon.h>
> > > +#include <linux/hwmon-sysfs.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/io.h>
> > > +#include "ts5500.h"
> > > +
> > > +#define TS5500_ADC_CTRL_REG                0x195   /*
> > > Conversion state register */ +#define
> > > TS5500_ADC_INIT_LSB_REG             0x196   /* Init conv. /
> > > LSB register */ +#define TS5500_ADC_MSB_REG
> > > 0x197       /* MSB register */ +/*
> > > + * Control bits of A/D command
> > > + * bits 0-2:       selected channel (0 - 7)
> > > + * bits 3: uni/bipolar (0 = unipolar (ie 0 to +5V))
> > > + *                     (1 = bipolar (ie -5 to +5V))
> > > + * bit 4:  selected range (0 = 5v range, 1 = 10V range)
> > > + * bit 5-7:        padded zero (unused)
> > > + */
> > > +
> > > +#define TS5500_ADC_CHANNELS_MAX            8       /* 0 to 7
> > > channels on device */ +
> > > +#define TS5500_ADC_BIPOLAR         0x08
> > > +#define TS5500_ADC_UNIPOLAR                0x00
> > > +#define TS5500_ADC_RANGE_5V                0x00    /* 0 to 5V
> > > range */ +#define TS5500_ADC_RANGE_10V
> > > 0x10        /* 0 to 10V range */ +
> > > +#define TS5500_ADC_READ_DELAY              15      /* usec */
> > > +#define TS5500_ADC_READ_BUSY_MASK  0x01
> > > +#define TS5500_ADC_NAME                    "MAX197 (8
> > > channels)" +
> > > +/**
> > > + * struct ts5500_adc_platform_data
> > > + * @name:  Name of the device.
> > > + * @ioaddr:        I/O address containing:
> > > + *         .data:          Data register for
> > > conversion reading.
> > > + *         .ctrl:          A/D Control Register (bit
> > > 0 = 0 when
> > > + *                         conversion completed).
> > > + * @read:  Information about conversion reading, with:
> > > + *         .delay:         Delay before next
> > > conversion.
> > > + *         .busy_mask:     Control register bit 0 equals
> > > 1 means
> > > + *                         conversion is not completed yet.
> > > + * @ctrl:  Data tables addressable by [polarity][range].
> > > + * @ranges:        Ranges.
> > > + *         .min:           Min value.
> > > + *         .max:           Max value.
> > > + * @scale: Polarity/Range coefficients to scale raw
> > > conversion reading.
> > > + */
> > > +struct ts5500_adc_platform_data {
> > > +   const char *name;
> > > +   struct {
> > > +           int data;
> > > +           int ctrl;
> > > +   } ioaddr;
> > > +   struct {
> > > +           u8 delay;
> > > +           u8 busy_mask;
> > > +   } read;
> > > +   u8 ctrl[2][2];
> >
> > const ?
> >
> > > +   struct {
> > > +           int min[2][2];
> > > +           int max[2][2];
> >
> > Should those be const ?
> >
> > > +   } ranges;
> > > +   int scale[2][2];
> >
> > const ?
> >
> > > +};
> > > +
> >
> > I am a bit lost about this structure and its use. It appears as if
> > you expect that there will be other uses besides the one defined here
> > (otherwise the variables would not make much sense and you could use
> > defines), yet it is all defined in this file and thus static. Please
> > elaborate.
> 
> You're right. I removed this structure and used define instead.
> 
> >
> > > +#define ts5500_adc_test_bit(bit, map)      (test_bit(bit,
> > > map) != 0) +
> > Why "!= 0" ? Isn't that implied ? And then why the define to start
> > with ?
> 
> Dropped. I replaced ts5500_adc_test_bit() call by !!test_bit().
> 
Tricky, tricky. You want a bool which you then use to index an array, meaning you use
the bool as integer. And a few implementations unfortunately do not return a bool
but an int.

Maybe it would be better if you were to declare range and polarity as bool wherever used.
At least then it would be more obvious that this is what you are doing.

> >
> > > +/**
> > > + * struct ts5500_adc_chip
> > > + * @hwmon_dev:             The hwmon device.
> > > + * @lock:          Read/Write mutex.
> > > + * @spec:          The mapped MAX197 platform data.
> > > + * @polarity:              bitmap for polarity.
> > > + * @range:         bitmap for range.
> > > + */
> > > +struct ts5500_adc_chip {
> > > +   struct device *hwmon_dev;
> > > +   struct mutex lock;
> > > +   struct ts5500_adc_platform_data spec;
> > > +   DECLARE_BITMAP(polarity, TS5500_ADC_CHANNELS_MAX);
> > > +   DECLARE_BITMAP(range, TS5500_ADC_CHANNELS_MAX);
> > > +};
> > > +
> > > +static s32 ts5500_adc_scale(struct ts5500_adc_chip *chip, s16 raw,
> > > +                       int polarity, int range)
> > > +{
> > > +   s32 scaled = raw;
> > > +
> > > +   scaled *= chip->spec.scale[polarity][range];
> > > +   scaled /= 10000;
> > > +
> > > +   return scaled;
> > > +}
> > > +
> > > +static int ts5500_adc_range(struct ts5500_adc_chip *chip, int
> > > is_min,
> > > +                          int polarity, int range)
> > > +{
> > > +   if (is_min)
> > > +           return chip->spec.ranges.min[polarity][range];
> > > +   return chip->spec.ranges.max[polarity][range];
> > > +}
> > > +
> > > +static int ts5500_adc_strtol(const char *buf, long *value, int
> > > range1,
> > > +                           int range2)
> > > +{
> > > +   if (strict_strtol(buf, 10, value))
> >
> > checkpatch warning.
> >
> > > +           return -EINVAL;
> > > +
> > > +   if (range1 < range2)
> > > +           *value = SENSORS_LIMIT(*value, range1, range2);
> > > +   else
> > > +           *value = SENSORS_LIMIT(*value, range2, range1);
> > > +
> > > +   return 0;
> > > +}
> > This function is called exactly once. Why not just embed it in the
> > calling code ?
> >
> > > +
> > > +static struct ts5500_adc_chip *ts5500_adc_get_drvdata(struct
> > > device *dev) +{
> > > +   return platform_get_drvdata(to_platform_device(dev));
> > > +}
> > > +
> > > +/**
> > > + * ts5500_adc_show_range() - Display range on user output
> > > + *
> > > + * Function called on read access on
> > > + * /sys/devices/platform/ts5500-adc/in{0,1,2,3,4,5,6,7}_{min,max}
> > > + */
> > > +static ssize_t ts5500_adc_show_range(struct device *dev,
> > > +                            struct device_attribute *devattr,
> > > char *buf) +{
> > > +   struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
> > > +   struct sensor_device_attribute_2 *attr =
> > > to_sensor_dev_attr_2(devattr);
> > > +   int is_min = attr->nr != 0;
> > > +   int polarity, range;
> > > +
> > > +   if (mutex_lock_interruptible(&chip->lock))
> > > +           return -ERESTARTSYS;
> > > +
> > > +   polarity = ts5500_adc_test_bit(attr->index,
> > > chip->polarity);
> > > +   range = ts5500_adc_test_bit(attr->index, chip->range);
> > > +
> > > +   mutex_unlock(&chip->lock);
> > > +
> > > +   return sprintf(buf, "%d\n",
> > > +                  ts5500_adc_range(chip, is_min, polarity,
> > > range)); +}
> > > +
> > > +/**
> > > + * ts5500_adc_store_range() - Write range from user input
> > > + *
> > > + * Function called on write access on
> > > + * /sys/devices/platform/ts5500-adc/in{0,1,2,3,4,5,6,7}_{min,max}
> > > + */
> > > +static ssize_t ts5500_adc_store_range(struct device *dev,
> > > +                             struct device_attribute *devattr,
> > > +                             const char *buf, size_t count)
> > > +{
> > > +   struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
> > > +   struct sensor_device_attribute_2 *attr =
> > > to_sensor_dev_attr_2(devattr);
> > > +   int is_min = attr->nr != 0;
> > > +   int range1 = ts5500_adc_range(chip, is_min, 0, 0);
> > > +   int range2 = ts5500_adc_range(chip, is_min, 1, 1);
> > > +   long value;
> > > +
> > > +   if (ts5500_adc_strtol(buf, &value, range1, range2))
> > > +           return -EINVAL;
> > > +
> > > +   if (mutex_lock_interruptible(&chip->lock))
> > > +           return -ERESTARTSYS;
> > > +
> > > +   if (abs(value) > 5000)
> > > +           set_bit(attr->index, chip->range);
> > > +   else
> > > +           clear_bit(attr->index, chip->range);
> > > +
> > > +   if (is_min) {
> > > +           if (value < 0)
> > > +                   set_bit(attr->index, chip->polarity);
> > > +           else
> > > +                   clear_bit(attr->index, chip->polarity);
> > > +   }
> > > +
> > > +   mutex_unlock(&chip->lock);
> > > +
> > > +   return count;
> > > +}
> > > +
> > > +/**
> > > + * ts5500_adc_show_input() - Show channel input
> > > + *
> > > + * Function called on read access on
> > > + * /sys/devices/platform/ts5500-adc/in{0,1,2,3,4,5,6,7}_input
> > > + */
> > > +static ssize_t ts5500_adc_show_input(struct device *dev,
> > > +                                struct device_attribute
> > > *devattr,
> > > +                                char *buf)
> > > +{
> > > +   struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
> > > +   struct sensor_device_attribute *attr =
> > > to_sensor_dev_attr(devattr);
> > > +   int polarity, range;
> > > +   int ret;
> > > +   u8 command;
> > > +
> > > +   if (mutex_lock_interruptible(&chip->lock))
> > > +           return -ERESTARTSYS;
> > > +
> > > +   polarity = ts5500_adc_test_bit(attr->index,
> > > chip->polarity);
> > > +   range = ts5500_adc_test_bit(attr->index, chip->range);
> > > +
> > > +   command = attr->index | chip->spec.ctrl[polarity][range];
> > > +
> > > +   outb(command, chip->spec.ioaddr.data);
> > > +
> > > +   udelay(chip->spec.read.delay);
> > > +   ret = inb(chip->spec.ioaddr.ctrl);
> > > +
> > > +   if (ret & chip->spec.read.busy_mask) {
> > > +           dev_err(dev, "device not ready (ret=0x0%x,
> > > try=%d)\n", ret,
> > > +                   range);
> >
> > What does "try=" have to do with the displayed "range" ?
> >
> > > +           ret = -EIO;
> > > +   } else {
> > > +           /* LSB of conversion is at 0x196 and MSB is at
> > > 0x197 */
> > > +           u8 lsb = inb(chip->spec.ioaddr.data);
> > > +           u8 msb = inb(chip->spec.ioaddr.data + 1);
> > > +           s16 raw = (msb << 8) | lsb;
> > > +           s32 scaled = ts5500_adc_scale(chip, raw, polarity,
> > > range); +
> > > +           ret = sprintf(buf, "%d\n", scaled);
> > > +   }
> > > +
> > > +   mutex_unlock(&chip->lock);
> > > +   return ret;
> > > +}
> > > +
> > > +static ssize_t ts5500_adc_show_name(struct device *dev,
> > > +   struct device_attribute *devattr, char *buf)
> > > +{
> > > +   return sprintf(buf, "%s\n",
> > > ts5500_adc_get_drvdata(dev)->spec.name); +}
> > > +
> > > +#define
> > > TS5500_ADC_HWMON_CHANNEL(chan)                              \
> > > +   SENSOR_DEVICE_ATTR(in##chan##_input,
> > > S_IRUGO,            \
> > > +                      ts5500_adc_show_input, NULL,
> > > chan);      \
> > > +   SENSOR_DEVICE_ATTR_2(in##chan##_max, S_IRUGO |
> > > S_IWUSR,    \
> > > +                        ts5500_adc_show_range,
> > > \
> > > +                        ts5500_adc_store_range, 0,
> > > chan);      \
> > > +   SENSOR_DEVICE_ATTR_2(in##chan##_min, S_IRUGO |
> > > S_IWUSR,    \
> > > +                        ts5500_adc_show_range,
> > > \
> > > +                        ts5500_adc_store_range, 1,
> > > chan)       \ +
> > > +#define
> > > TS5500_ADC_SYSFS_CHANNEL(chan)                              \
> > > +   &sensor_dev_attr_in##chan##_input.dev_attr.attr,        \
> > > +
> > > &sensor_dev_attr_in##chan##_max.dev_attr.attr,              \
> > > +   &sensor_dev_attr_in##chan##_min.dev_attr.attr
> > > +
> > > +static DEVICE_ATTR(name, S_IRUGO, ts5500_adc_show_name, NULL);
> > > +
> > > +static TS5500_ADC_HWMON_CHANNEL(0);
> > > +static TS5500_ADC_HWMON_CHANNEL(1);
> > > +static TS5500_ADC_HWMON_CHANNEL(2);
> > > +static TS5500_ADC_HWMON_CHANNEL(3);
> > > +static TS5500_ADC_HWMON_CHANNEL(4);
> > > +static TS5500_ADC_HWMON_CHANNEL(5);
> > > +static TS5500_ADC_HWMON_CHANNEL(6);
> > > +static TS5500_ADC_HWMON_CHANNEL(7);
> > > +
> > Looks good at first glance, but unless I misunderstand something,
> > each define generates three structures, yet only the first of those
> > is declared static, the others are global.
> 
> Good point, now everything's declared as static.
> 
> >
> > > +static const struct attribute_group ts5500_adc_sysfs_group = {
> > > +   .attrs = (struct attribute *[]) {
> >
> > checkpatch error.
> 
> This is a bit tricky. checkpatch thinks that the asterisk is a
> multiplication, so it is complaining about coding style.
> 
Hmm. YOu are right ... and by changing it you would actually add a coding style error.
Maybe just add a note in the version change log that this is a false positive.

> >
> > > +           &dev_attr_name.attr,
> > > +           TS5500_ADC_SYSFS_CHANNEL(0),
> > > +           TS5500_ADC_SYSFS_CHANNEL(1),
> > > +           TS5500_ADC_SYSFS_CHANNEL(2),
> > > +           TS5500_ADC_SYSFS_CHANNEL(3),
> > > +           TS5500_ADC_SYSFS_CHANNEL(4),
> > > +           TS5500_ADC_SYSFS_CHANNEL(5),
> > > +           TS5500_ADC_SYSFS_CHANNEL(6),
> > > +           TS5500_ADC_SYSFS_CHANNEL(7),
> > > +           NULL
> > > +   }
> > > +};
> > > +
> > > +static int __devinit ts5500_adc_probe(struct platform_device *pdev)
> > > +{
> > > +   struct ts5500_adc_platform_data *pdata =
> > > pdev->dev.platform_data;
> > > +   struct ts5500_adc_chip *chip;
> > > +   int ret;
> > > +
> > > +   if (pdata == NULL)
> > > +           return -ENODEV;
> > > +
> > > +   chip = kzalloc(sizeof *chip, GFP_KERNEL);
> > > +   if (!chip)
> > > +           return -ENOMEM;
> > > +
> > > +   chip->spec = *pdata;
> > > +
> > > +   mutex_init(&chip->lock);
> > > +   mutex_lock(&chip->lock);
> >
> > Probe function does not need a lock if you rearrange the code below.
> >
> > > +
> > > +   ret = sysfs_create_group(&pdev->dev.kobj,
> > > &ts5500_adc_sysfs_group);
> > > +   if (ret) {
> > > +           dev_err(&pdev->dev, "sysfs_create_group
> > > failed.\n");
> > > +           goto error_unlock_and_free;
> > > +   }
> > > +
> > > +   chip->hwmon_dev = hwmon_device_register(&pdev->dev);
> > > +   if (IS_ERR(chip->hwmon_dev)) {
> > > +           dev_err(&pdev->dev, "hwmon_device_register
> > > failed.\n");
> > > +           ret = PTR_ERR(chip->hwmon_dev);
> > > +           goto error_unregister_device;
> > > +   }
> > > +
> > > +   platform_set_drvdata(pdev, chip);
> >
> > Set this before creating sysfs entries.
> 
> Thanks for the trick.
> 
> >
> > > +   mutex_unlock(&chip->lock);
> > > +   return 0;
> > > +
> > > +error_unregister_device:
> > > +   sysfs_remove_group(&pdev->dev.kobj,
> > > &ts5500_adc_sysfs_group); +
> > > +error_unlock_and_free:
> > > +   mutex_unlock(&chip->lock);
> > > +   kfree(chip);
> > > +   return ret;
> > > +}
> > > +
> > > +static void ts5500_adc_release(struct device *dev)
> > > +{
> > > +   /* noop */
> > > +}
> >
> > Is this really needed ? Just wondering.
> 
> Yes it is, otherwise you get a "Device 'ts5500_adc' does not have a
> release() function, it is broken and must be fixed." kernel error.
> 
> >
> > > +
> > > +static struct resource ts5500_adc_resources[] = {
> > > +   {
> > > +           .name  = "ts5500_adc" "-data",
> > > +           .start = TS5500_ADC_INIT_LSB_REG,
> > > +           .end   = TS5500_ADC_MSB_REG,
> > > +           .flags = IORESOURCE_IO,
> > > +   },
> > > +   {
> > > +           .name  = "ts5500_adc" "-ctrl",
> > > +           .start = TS5500_ADC_CTRL_REG,
> > > +           .end   = TS5500_ADC_CTRL_REG,
> > > +           .flags = IORESOURCE_IO,
> > > +   }
> > > +};
> > > +
> > > +static struct ts5500_adc_platform_data ts5500_adc_platform_data = {
> > > +   .name = TS5500_ADC_NAME,
> > > +   .ioaddr = {
> > > +           .data = TS5500_ADC_INIT_LSB_REG,
> > > +           .ctrl = TS5500_ADC_CTRL_REG,
> > > +   },
> > > +   .read = {
> > > +           .delay     = TS5500_ADC_READ_DELAY,
> > > +           .busy_mask = TS5500_ADC_READ_BUSY_MASK,
> > > +   },
> > > +   .ctrl = {
> > > +           { TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_5V,
> > > +             TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_10V },
> > > +           { TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_5V,
> > > +             TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_10V },
> > > +   },
> > > +   .ranges = {
> > > +           .min = {
> > > +                   {  0,     0 },
> > > +                   { -5000, -10000 },
> > > +           },
> > > +           .max = {
> > > +                   {  5000,  10000 },
> > > +                   {  5000,  10000 },
> > > +           },
> > > +   },
> > > +   .scale = {
> > > +           { 12207, 24414 },
> > > +           { 24414, 48828 },
> > > +   },
> > > +};
> > > +
> > > +static struct platform_device ts5500_adc_device = {
> > > +   .name = "ts5500_adc",
> > > +   .id = -1,
> > > +   .resource = ts5500_adc_resources,
> > > +   .num_resources = ARRAY_SIZE(ts5500_adc_resources),
> > > +   .dev = {
> > > +           .platform_data = &ts5500_adc_platform_data,
> > > +           .release = ts5500_adc_release,
> > > +   },
> > > +};
> > > +
> > Usually all the above would be in a platform file.
> >
> > > +static int __devexit ts5500_adc_remove(struct platform_device
> > > *pdev) +{
> > > +   struct ts5500_adc_chip *chip = platform_get_drvdata(pdev);
> > > +
> > > +   mutex_lock(&chip->lock);
> > > +   hwmon_device_unregister(chip->hwmon_dev);
> > > +   sysfs_remove_group(&pdev->dev.kobj,
> > > &ts5500_adc_sysfs_group);
> > > +   platform_set_drvdata(pdev, NULL);
> > > +   mutex_unlock(&chip->lock);
> >
> > Lock not needed here.
> >
> > > +   kfree(chip);
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static struct platform_driver ts5500_adc_driver = {
> > > +   .driver = {
> > > +           .name   = "ts5500_adc",
> > > +           .owner  = THIS_MODULE,
> > > +   },
> > > +   .probe  = ts5500_adc_probe,
> > > +   .remove = __devexit_p(ts5500_adc_remove)
> > > +};
> > > +
> > > +static int __init ts5500_adc_init(void)
> > > +{
> > > +   int ret;
> > > +
> > > +   ret = platform_driver_register(&ts5500_adc_driver);
> > > +   if (ret)
> > > +           goto error_out;
> > > +
> > > +   ret = platform_device_register(&ts5500_adc_device);
> > > +   if (ret)
> > > +           goto error_device_register;
> > > +
> > > +   return 0;
> > > +
> > > +error_device_register:
> > > +   platform_driver_unregister(&ts5500_adc_driver);
> > > +error_out:
> > > +   return ret;
> > > +}
> > > +module_init(ts5500_adc_init);
> > > +
> > > +static void __exit ts5500_adc_exit(void)
> > > +{
> > > +   platform_driver_unregister(&ts5500_adc_driver);
> > > +   platform_device_unregister(&ts5500_adc_device);
> > > +}
> > > +module_exit(ts5500_adc_exit);
> > > +
> > > +MODULE_DESCRIPTION("TS-5500 mapped MAX197 ADC device driver");
> > > +MODULE_AUTHOR("Jonas Fonseca
> > > <jonas.fonseca@savoirfairelinux.com>"); +MODULE_LICENSE("GPL");
> > > --
> > > 1.7.6.5
> > >
> > >
> 
> A patch for this review will follow.
> 
> Regards,
> 
>         Vivien.
> 
> 
> --
> Vivien Didelot
> Savoir-faire Linux Inc.
> Tel: (514) 276-5468 #149

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2BAViQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:38:16 -0500
Received: from imr4.ericy.com ([198.24.6.9]:50162 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501Ab2BAViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:38:12 -0500
Message-ID: <1328132138.2261.116.camel@groeck-laptop>
Subject: Re: [PATCH v5 4/5] hwmon: add MAX197 support
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Date: Wed, 1 Feb 2012 13:35:38 -0800
In-Reply-To: <1328130344-18836-5-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1328130344-18836-5-git-send-email-vivien.didelot@savoirfairelinux.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivien,

On Wed, 2012-02-01 at 16:05 -0500, Vivien Didelot wrote:
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Nicely done. Looks pretty good. Couple of minor comments below.

> ---
>  Documentation/hwmon/max197 |   54 ++++++
>  drivers/hwmon/Kconfig      |    9 +
>  drivers/hwmon/Makefile     |    1 +
>  drivers/hwmon/max197.c     |  403 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/max197.h     |   22 +++
>  5 files changed, 489 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hwmon/max197
>  create mode 100644 drivers/hwmon/max197.c
>  create mode 100644 include/linux/max197.h
> 
> diff --git a/Documentation/hwmon/max197 b/Documentation/hwmon/max197
> new file mode 100644
> index 0000000..aa0934f
> --- /dev/null
> +++ b/Documentation/hwmon/max197
> @@ -0,0 +1,54 @@
> +Maxim MAX197 driver
> +===================
> +
> +Author:
> +  * Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> +
> +Supported chips:
> +  * Maxim MAX197
> +    Prefix: 'max197'
> +    Datasheet: http://datasheets.maxim-ic.com/en/ds/MAX197.pdf
> +
> +  * Maxim MAX199
> +    Prefix: 'max199'
> +    Datasheet: http://datasheets.maxim-ic.com/en/ds/MAX199.pdf
> +
> +Description
> +-----------
> +
> +The A/D converters MAX197 and MAX199 are both 8-Channel, Multi-Range, 5V,
> +12-Bit DAS with 8+4 Bus Interface and Fault Protection.
> +
> +The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to 10V,
> +while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
> +
> +Platform data
> +-------------
> +
> +The MAX197 platform data (defined in linux/max197.h) should be filled with two
> +function pointers:
> +
> +* start:
> +  The function which writes the control byte to start a new conversion.
> +* read:
> +  The function used to read the raw value from the chip.
> +
> +Control-Byte Format:
> +
> +Bit    Name            Description
> +7,6    PD1,PD0         Clock and Power-Down modes
> +5      ACQMOD          Internal or External Controlled Acquisition
> +4      RNG             Full-scale voltage magnitude at the input
> +3      BIP             Unipolar or Bipolar conversion mode
> +2,1,0  A2,A1,A0        Channel
> +
> +Sysfs interface
> +---------------
> +
> +* in[0-7]_input: The conversion value for the corresponding channel.
> +* in[0-7]_min:   The lower limit (in mV) for the corresponding channel.
> +                 It can be one value in -10000, -5000, -4000, -2000, 0,
> +                 depending on the chip.
> +* in[0-7]_max:   The higher limit (in mV) for the corresponding channel.
> +                 It can be one value in 2000, 4000, 5000, 10000,
> +                 depending on the chip.
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 91be41f..ccdf59b 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1360,6 +1360,15 @@ config SENSORS_MC13783_ADC
>          help
>            Support for the A/D converter on MC13783 PMIC.
> 
> +config SENSORS_MAX197
> +       tristate "Maxim MAX197 and compatibles."
> +       help
> +    If you say yes here you get support for the Maxim MAX197,
> +    and MAX199 A/D converters.
> +
> +         This driver can also be built as a module.  If so, the module
> +         will be called max197.
> +
>  if ACPI
> 
>  comment "ACPI drivers"
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 8251ce8..dfb73d9 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -125,6 +125,7 @@ obj-$(CONFIG_SENSORS_W83L785TS)     += w83l785ts.o
>  obj-$(CONFIG_SENSORS_W83L786NG)        += w83l786ng.o
>  obj-$(CONFIG_SENSORS_WM831X)   += wm831x-hwmon.o
>  obj-$(CONFIG_SENSORS_WM8350)   += wm8350-hwmon.o
> +obj-$(CONFIG_SENSORS_MAX197)   += max197.o
> 
>  obj-$(CONFIG_PMBUS)            += pmbus/
> 
> diff --git a/drivers/hwmon/max197.c b/drivers/hwmon/max197.c
> new file mode 100644
> index 0000000..985615c
> --- /dev/null
> +++ b/drivers/hwmon/max197.c
> @@ -0,0 +1,403 @@
> +/*
> + * Maxim MAX197 A/D Converter Driver
> + *
> + * Copyright (c) 2012 Savoir-faire Linux Inc.
> + *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * For further information, see the Documentation/hwmon/max197 file.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/sysfs.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/max197.h>
> +
> +#define MAX199_LIMIT   4000    /* 4V */
> +#define MAX197_LIMIT   10000   /* 10V */
> +
> +#define MAX197_NUM_CH  8       /* 8 Analog Input Channels */
> +
> +/* Control byte format */
> +#define MAX197_A0      0x01    /* Channel bit 0 */
> +#define MAX197_A1      0x02    /* Channel bit 1 */
> +#define MAX197_A2      0x04    /* Channel bit 2 */
> +#define MAX197_BIP     0x08    /* Bipolarity */
> +#define MAX197_RNG     0x10    /* Full range */
> +#define MAX197_ACQMOD  0x20    /* Internal/External controlled acquisition */
> +#define MAX197_PD0     0x40    /* Clock/Power-Down modes bit 1 */
> +#define MAX197_PD1     0x80    /* Clock/Power-Down modes bit 2 */
> +
> +#define MAX197_SCALE   12207   /* Scale coefficient for raw data */
> +
> +/**
> + * struct max197_chip - device instance specific data
> + * @pdata:             Platform data.
> + * @hwmon_dev:         The hwmon device.
> + * @lock:              Read/Write mutex.
> + * @limit:             Max range value (10V for MAX197, 4V for MAX199).
> + * @scale:             Need to scale.
> + * @ctrl_bytes:                Channels control byte.
> + */
> +struct max197_chip {
> +       struct max197_platform_data *pdata;
> +       struct device *hwmon_dev;
> +       struct mutex lock;
> +       int limit;
> +       bool scale;
> +       u8 ctrl_bytes[MAX197_NUM_CH];
> +};
> +
> +static inline void max197_set_unipolarity(struct max197_chip *chip, int channel)
> +{
> +       chip->ctrl_bytes[channel] &= ~MAX197_BIP;
> +}
> +
> +static inline void max197_set_bipolarity(struct max197_chip *chip, int channel)
> +{
> +       chip->ctrl_bytes[channel] |= MAX197_BIP;
> +}
> +
> +static inline void max197_set_half_range(struct max197_chip *chip, int channel)
> +{
> +       chip->ctrl_bytes[channel] &= ~MAX197_RNG;
> +}
> +
> +static inline void max197_set_full_range(struct max197_chip *chip, int channel)
> +{
> +       chip->ctrl_bytes[channel] |= MAX197_RNG;
> +}
> +
> +static inline bool max197_is_bipolar(struct max197_chip *chip, int channel)
> +{
> +       return !!(chip->ctrl_bytes[channel] & MAX197_BIP);
> +}
> +
> +static inline bool max197_is_full_range(struct max197_chip *chip, int channel)
> +{
> +       return !!(chip->ctrl_bytes[channel] & MAX197_RNG);
> +}
> +
Interestingly enough, you don't need the !!() above. The C language
defines that the result of an operation assigned to a bool is always
converted to either 0 or 1. Not that it matters, really - I personally
actually prefer you style.

> +/**
> + * max197_show_range() - Display range on user output
> + *
> + * Function called on read access on in{0,1,2,3,4,5,6,7}_{min,max}
> + */
> +static ssize_t max197_show_range(struct device *dev,
> +                                struct device_attribute *devattr, char *buf)
> +{
> +       struct max197_chip *chip = dev_get_drvdata(dev);
> +       struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> +       int channel = attr->index;
> +       bool is_min = attr->nr;
> +       int range;
> +
> +       if (mutex_lock_interruptible(&chip->lock))
> +               return -ERESTARTSYS;
> +
> +       range = max197_is_full_range(chip, channel) ?
> +               chip->limit : chip->limit / 2;
> +       if (is_min) {
> +               if (max197_is_bipolar(chip, channel))
> +                       range = -range;
> +               else
> +                       range = 0;
> +       }
> +
> +       mutex_unlock(&chip->lock);
> +
> +       return sprintf(buf, "%d\n", range);
> +}
> +
> +/**
> + * max197_store_range() - Write range from user input
> + *
> + * Function called on write access on in{0,1,2,3,4,5,6,7}_{min,max}
> + */
> +static ssize_t max197_store_range(struct device *dev,
> +                                 struct device_attribute *devattr,
> +                                 const char *buf, size_t count)
> +{
> +       struct max197_chip *chip = dev_get_drvdata(dev);
> +       struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> +       int channel = attr->index;
> +       bool is_min = attr->nr;
> +       long value;
> +       int half = chip->limit / 2;
> +       int full = chip->limit;
> +
> +       if (kstrtol(buf, 10, &value))
> +               return -EINVAL;
> +
> +       if (is_min) {
> +               if ((value != 0) && (value != -half) && (value != -full))
> +                       return -EINVAL;
> +       } else {
> +               if ((value != half) && (value != full))
> +                       return -EINVAL;
> +       }
> +
Technically ok, except for the unnecessary ( ). Would be great if you
could remove those.

Since the actual limits are chip dependent, and not easily to figure out
for the ordinary user, it would be nice to either accept any number and
adjust it to one of the accepted values, or to explicitly spell out the
accepted the per-chip accepted values in the documentation (and not just
say "depending on the chip"). I'll leave it up to you to decide which
way to go.

Not too difficult - if you change the code, something like

	if (is_min) {
		if (value <= -full)
			value = -full;
		else if (value < 0)
			value = -half;
		else value = 0;
	} else {
		if (value >= full)
			value = full;
		else
			value = half;
	}

would be good enough.

Thanks,
Guenter



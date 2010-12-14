Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0LNLBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:01:36 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:27430 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab0LNLBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:01:34 -0500
X-IronPort-AV: E=Sophos;i="4.59,341,1288584000"; 
   d="scan'208";a="26164801"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Tue, 14 Dec 2010 11:01:29 +0000
Subject: RE: [PATCH 3/3] IIO: DDS: AD9833 / AD9834 driver
Thread-Topic: [PATCH 3/3] IIO: DDS: AD9833 / AD9834 driver
Thread-Index: AcubDlJDYVICDnVvQ6K8w8/Mms7t5QAbsc2g
Message-ID: <544AC56F16B56944AEC3BD4E3D591771324BCA860C@LIMKCMBX1.ad.analog.com>
References: <1292257644-26477-1-git-send-email-michael.hennerich@analog.com>
 <1292257644-26477-3-git-send-email-michael.hennerich@analog.com>
 <4D0692BA.6050009@cam.ac.uk>
In-Reply-To: <4D0692BA.6050009@cam.ac.uk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jonathan Cameron wrote on 2010-12-13:
> > On 12/13/10 16:27, michael.hennerich@analog.com wrote:
> > From: Michael Hennerich <michael.hennerich@analog.com>
> >
> > Changes since RFC/v1:
> > IIO: Apply list review feedback
> >
> > Apply list review feedback:
> >     Rename attributes to fit IIO convention used in other drivers.
> >     Fix typos.
> >     Provide ddsX_out_enable as opposed to ddsX_out_disable.
> >     Use proper __devexit marking.
> >     Use strict_strtoul() to avoid negatives.
> >
> Couple of nitpicks inline. Subject to changes due to changes in macros
> suggested in previous patch (or you convincing me otherwise):
> > Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> > Reviewed-by: Datta Shubhrajyoti <shubhrajyoti@ti.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> > ---
> >  drivers/staging/iio/dds/Kconfig  |    7 +
> >  drivers/staging/iio/dds/Makefile |    1 +
> >  drivers/staging/iio/dds/ad9834.c |  482
> ++++++++++++++++++++++++++++++++++++++
> >  drivers/staging/iio/dds/ad9834.h |  112 +++++++++
> >  4 files changed, 602 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/staging/iio/dds/ad9834.c
> >  create mode 100644 drivers/staging/iio/dds/ad9834.h
> >
> > diff --git a/drivers/staging/iio/dds/Kconfig
> b/drivers/staging/iio/dds/Kconfig
> > index 7969be2..4c9cce3 100644
> > --- a/drivers/staging/iio/dds/Kconfig
> > +++ b/drivers/staging/iio/dds/Kconfig
> > @@ -17,6 +17,13 @@ config AD9832
> >       Say yes here to build support for Analog Devices DDS chip
> >       ad9832 and ad9835, provides direct access via sysfs.
> >
> > +config AD9834
> > +   tristate "Analog Devices ad9833/4/ driver"
> > +   depends on SPI
> > +   help
> > +     Say yes here to build support for Analog Devices DDS chip
> > +     AD9833 and AD9834, provides direct access via sysfs.
> > +
> >  config AD9850
> >     tristate "Analog Devices ad9850/1 driver"
> >     depends on SPI
> > diff --git a/drivers/staging/iio/dds/Makefile
> b/drivers/staging/iio/dds/Makefile
> > index 6f274ac..1477461 100644
> > --- a/drivers/staging/iio/dds/Makefile
> > +++ b/drivers/staging/iio/dds/Makefile
> > @@ -4,6 +4,7 @@
> >
> >  obj-$(CONFIG_AD5930) += ad5930.o
> >  obj-$(CONFIG_AD9832) += ad9832.o
> > +obj-$(CONFIG_AD9834) += ad9834.o
> >  obj-$(CONFIG_AD9850) += ad9850.o
> >  obj-$(CONFIG_AD9852) += ad9852.o
> >  obj-$(CONFIG_AD9910) += ad9910.o
> > diff --git a/drivers/staging/iio/dds/ad9834.c
> b/drivers/staging/iio/dds/ad9834.c
> > new file mode 100644
> > index 0000000..df3d68c
> > --- /dev/null
> > +++ b/drivers/staging/iio/dds/ad9834.c
> > @@ -0,0 +1,482 @@
> > +/*
> > + * AD9834 SPI DAC driver
> > + *
> > + * Copyright 2010 Analog Devices Inc.
> > + *
> > + * Licensed under the GPL-2 or later.
> > + */
> > +
> > +#include <linux/interrupt.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/device.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/list.h>
> > +#include <linux/spi/spi.h>
> > +#include <linux/regulator/consumer.h>
> > +#include <linux/err.h>
> > +#include <asm/div64.h>
> > +
> > +#include "../iio.h"
> > +#include "../sysfs.h"
> > +#include "dds.h"
> > +
> > +#include "ad9834.h"
> > +
> > +static unsigned int ad9834_calc_freqreg(unsigned long mclk, unsigned
> long fout)
> > +{
> > +   unsigned long long freqreg = (u64) fout * (u64) (1 <<
> AD9834_FREQ_BITS);
> > +   do_div(freqreg, mclk);
> > +   return freqreg;
> > +}
> > +
> > +static int ad9834_write_frequency(struct ad9834_state *st,
> > +                             unsigned long addr, unsigned long fout)
> > +{
> > +   unsigned long regval;
> > +
> > +   if (fout > (st->mclk / 2))
> > +           return -EINVAL;
> > +
> > +   regval = ad9834_calc_freqreg(st->mclk, fout);
> > +
> > +   st->freq_data[0] = cpu_to_be16(addr | (regval &
> > +                                  RES_MASK(AD9834_FREQ_BITS / 2)));
> > +   st->freq_data[1] = cpu_to_be16(addr | ((regval >>
> > +                                  (AD9834_FREQ_BITS / 2)) &
> > +                                  RES_MASK(AD9834_FREQ_BITS / 2)));
> > +
> > +   return spi_sync(st->spi, &st->freq_msg);;
> > +}
> > +
> > +static int ad9834_write_phase(struct ad9834_state *st,
> > +                             unsigned long addr, unsigned long phase)
> > +{
> > +   if (phase > (1 << AD9834_PHASE_BITS))
> > +           return -EINVAL;
> > +   st->data = cpu_to_be16(addr | phase);
> > +
> > +   return spi_sync(st->spi, &st->msg);
> > +}
> > +
> > +static ssize_t ad9834_write(struct device *dev,
> > +           struct device_attribute *attr,
> > +           const char *buf,
> > +           size_t len)
> > +{
> > +   struct iio_dev *dev_info = dev_get_drvdata(dev);
> > +   struct ad9834_state *st = dev_info->dev_data;
> > +   struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> > +   int ret;
> > +   long val;
> > +
> > +   ret = strict_strtoul(buf, 10, &val);
> > +   if (ret)
> > +           goto error_ret;
> > +
> > +   mutex_lock(&dev_info->mlock);
> > +   switch (this_attr->address) {
> > +   case AD9834_REG_FREQ0:
> > +   case AD9834_REG_FREQ1:
> > +           ret = ad9834_write_frequency(st, this_attr->address, val);
> > +           break;
> > +   case AD9834_REG_PHASE0:
> > +   case AD9834_REG_PHASE1:
> > +           ret = ad9834_write_phase(st, this_attr->address, val);
> > +           break;
> > +   case AD9834_OPBITEN:
> > +           if (st->control & AD9834_MODE) {
> > +                   ret = -EINVAL;  /* AD9843 reserved mode */
> > +                   break;
> > +           }
> > +
> > +           if (val)
> > +                   st->control |= AD9834_OPBITEN;
> > +           else
> > +                   st->control &= ~AD9834_OPBITEN;
> > +
> > +           st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +           ret = spi_sync(st->spi, &st->msg);
> > +           break;
> > +   case AD9834_PIN_SW:
> > +           if (val)
> > +                   st->control |= AD9834_PIN_SW;
> > +           else
> > +                   st->control &= ~AD9834_PIN_SW;
> > +           st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +           ret = spi_sync(st->spi, &st->msg);
> > +           break;
> > +   case AD9834_FSEL:
> > +   case AD9834_PSEL:
> > +           if (val == 0)
> > +                   st->control &= ~(this_attr->address | AD9834_PIN_SW);
> > +           else if (val == 1) {
> > +                   st->control |= this_attr->address;
> > +                   st->control &= ~AD9834_PIN_SW;
> > +           } else {
> > +                   ret = -EINVAL;
> > +                   break;
> > +           }
> > +           st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +           ret = spi_sync(st->spi, &st->msg);
> > +           break;
> > +   case AD9834_RESET:
> > +           if (val)
> > +                   st->control &= ~AD9834_RESET;
> > +           else
> > +                   st->control |= AD9834_RESET;
> > +
> > +           st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +           ret = spi_sync(st->spi, &st->msg);
> > +           break;
> > +   default:
> > +           ret = -ENODEV;
> > +   }
> > +   mutex_unlock(&dev_info->mlock);
> > +
> > +error_ret:
> > +   return ret ? ret : len;
> > +}
> > +
> > +static ssize_t ad9834_store_wavetype(struct device *dev,
> > +                            struct device_attribute *attr,
> > +                            const char *buf,
> > +                            size_t len)
> > +{
> > +   struct iio_dev *dev_info = dev_get_drvdata(dev);
> > +   struct ad9834_state *st = dev_info->dev_data;
> > +   struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> > +   int ret = 0;
> > +   bool is_ad9833 = st->devid == ID_AD9833;
> > +
> > +   mutex_lock(&dev_info->mlock);
> > +
> > +   switch (this_attr->address) {
> > +   case 0:
> > +           if (sysfs_streq(buf, "sine")) {
> > +                   st->control &= ~AD9834_MODE;
> > +                   if (is_ad9833)
> > +                           st->control &= ~AD9834_OPBITEN;
> > +           } else if (sysfs_streq(buf, "triangle")) {
> > +                   if (is_ad9833) {
> > +                           st->control &= ~AD9834_OPBITEN;
> > +                           st->control |= AD9834_MODE;
> > +                   } else if (st->control & AD9834_OPBITEN) {
> > +                           ret = -EINVAL;  /* AD9843 reserved mode */
> > +                   } else {
> > +                           st->control |= AD9834_MODE;
> > +                   }
> > +           } else if (is_ad9833 && sysfs_streq(buf, "square")) {
> > +                   st->control &= ~AD9834_MODE;
> > +                   st->control |= AD9834_OPBITEN;
> > +           } else {
> > +                   ret = -EINVAL;
> > +           }
> > +
> > +           break;
> > +   case 1:
> > +           if (sysfs_streq(buf, "square") &&
> > +                   !(st->control & AD9834_MODE)) {
> > +                   st->control &= ~AD9834_MODE;
> > +                   st->control |= AD9834_OPBITEN;
> > +           } else {
> > +                   ret = -EINVAL;
> > +           }
> > +           break;
> > +   default:
> > +           ret = -EINVAL;
> > +           break;
> > +   }
> > +
> > +   if (!ret) {
> > +           st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +           ret = spi_sync(st->spi, &st->msg);
> > +   }
> > +           mutex_unlock(&dev_info->mlock);
> In correct tabbing on previous line? (or my email client has messed up)

Your email client doing the right thing.

> > +
> > +   return ret ? ret : len;
> > +}
> > +
> > +static ssize_t ad9834_show_name(struct device *dev,
> > +                            struct device_attribute *attr,
> > +                            char *buf)
> > +{
> > +   struct iio_dev *dev_info = dev_get_drvdata(dev);
> > +   struct ad9834_state *st = iio_dev_get_devdata(dev_info);
> > +
> > +   return sprintf(buf, "%s\n", spi_get_device_id(st->spi)->name);
> > +}
> > +static IIO_DEVICE_ATTR(name, S_IRUGO, ad9834_show_name, NULL, 0);
> > +
> > +static ssize_t ad9834_show_out0_wavetype_available(struct device
> *dev,
> > +                                           struct device_attribute *attr,
> > +                                           char *buf)
> > +{
> > +   struct iio_dev *dev_info = dev_get_drvdata(dev);
> > +   struct ad9834_state *st = iio_dev_get_devdata(dev_info);
> > +   char *str;
> > +
> > +   if (st->devid == ID_AD9833)
> > +           str = "sine triangle square";
> > +   else if (st->control & AD9834_OPBITEN)
> > +           str = "sine";
> > +   else
> > +           str = "sine triangle";
> > +
> > +   return sprintf(buf, "%s\n", str);
> > +}
> > +
> > +
> > +static IIO_DEVICE_ATTR(dds0_out0_wavetype_available, S_IRUGO,
> > +                  ad9834_show_out0_wavetype_available, NULL, 0);
> > +
> > +static ssize_t ad9834_show_out1_wavetype_available(struct device
> *dev,
> > +                                           struct device_attribute *attr,
> > +                                           char *buf)
> > +{
> > +   struct iio_dev *dev_info = dev_get_drvdata(dev);
> > +   struct ad9834_state *st = iio_dev_get_devdata(dev_info);
> > +   char *str;
> > +
> > +   if (st->control & AD9834_MODE)
> > +           str = "";
> I 'think' that the is_visible below makes this first condition
> impossible?

No - the is_visible prevents this file to be available on the AD9833.
However this expresses a dependency on the AD9834 between the two outputs, where
the 'square' output on out1 is not available in case out0 is set to 'triangle'

> I've never used the is_visible stuff so not entirely sure I've
> understood
> it correctly...
> That probably means that you can use a const attr for this...

No

> > +   else
> > +           str = "square";
> > +
> > +   return sprintf(buf, "%s\n", str);
> > +}
> > +
> > +static IIO_DEVICE_ATTR(dds0_out1_wavetype_available, S_IRUGO,
> > +                  ad9834_show_out1_wavetype_available, NULL, 0);
> > +
> > +/**
> > + * see dds.h for further information
> > + */
> > +
> > +static IIO_DEV_ATTR_FREQ(0, 0, ad9834_write, AD9834_REG_FREQ0);
> > +static IIO_DEV_ATTR_FREQ(0, 1, ad9834_write, AD9834_REG_FREQ1);
> > +static IIO_DEV_ATTR_FREQSYMBOL(0, ad9834_write, AD9834_FSEL);
> > +static IIO_CONST_ATTR_FREQ_SCALE(0, "1"); /* 1Hz */
> > +
> > +static IIO_DEV_ATTR_PHASE(0, 0, ad9834_write, AD9834_REG_PHASE0);
> > +static IIO_DEV_ATTR_PHASE(0, 1, ad9834_write, AD9834_REG_PHASE1);
> > +static IIO_DEV_ATTR_PHASESYMBOL(0, ad9834_write, AD9834_PSEL);
> > +static IIO_CONST_ATTR_PHASE_SCALE(0, "0.0015339808"); /* 2PI/2^12
> rad*/
> > +
> > +static IIO_DEV_ATTR_PINCONTROL_EN(0, ad9834_write, AD9834_PIN_SW);
> > +static IIO_DEV_ATTR_OUT_ENABLE(0, ad9834_write, AD9834_RESET);
> > +static IIO_DEV_ATTR_OUTY_ENABLE(0, 1, ad9834_write, AD9834_OPBITEN);
> > +static IIO_DEV_ATTR_OUT_WAVETYPE(0, 0, ad9834_store_wavetype, 0);
> > +static IIO_DEV_ATTR_OUT_WAVETYPE(0, 1, ad9834_store_wavetype, 1);
> > +
> > +static struct attribute *ad9834_attributes[] = {
> > +   &iio_dev_attr_dds0_freq0.dev_attr.attr,
> > +   &iio_dev_attr_dds0_freq1.dev_attr.attr,
> > +   &iio_const_attr_dds0_freq_scale.dev_attr.attr,
> > +   &iio_dev_attr_dds0_phase0.dev_attr.attr,
> > +   &iio_dev_attr_dds0_phase1.dev_attr.attr,
> > +   &iio_const_attr_dds0_phase_scale.dev_attr.attr,
> > +   &iio_dev_attr_dds0_pincontrol_en.dev_attr.attr,
> > +   &iio_dev_attr_dds0_freqsymbol.dev_attr.attr,
> > +   &iio_dev_attr_dds0_phasesymbol.dev_attr.attr,
> > +   &iio_dev_attr_dds0_out_enable.dev_attr.attr,
> > +   &iio_dev_attr_dds0_out1_enable.dev_attr.attr,
> > +   &iio_dev_attr_dds0_out0_wavetype.dev_attr.attr,
> > +   &iio_dev_attr_dds0_out1_wavetype.dev_attr.attr,
> > +   &iio_dev_attr_dds0_out0_wavetype_available.dev_attr.attr,
> > +   &iio_dev_attr_dds0_out1_wavetype_available.dev_attr.attr,
> > +   &iio_dev_attr_name.dev_attr.attr,
> > +   NULL,
> > +};
> > +
> > +static mode_t ad9834_attr_is_visible(struct kobject *kobj,
> > +                                struct attribute *attr, int n)
> > +{
> > +   struct device *dev = container_of(kobj, struct device, kobj);
> > +   struct iio_dev *dev_info = dev_get_drvdata(dev);
> > +   struct ad9834_state *st = iio_dev_get_devdata(dev_info);
> > +
> > +   mode_t mode = attr->mode;
> > +
> > +   if (st->devid == ID_AD9834)
> > +           return mode;
> > +
> > +   if ((attr == &iio_dev_attr_dds0_out1_enable.dev_attr.attr) ||
> > +           (attr == &iio_dev_attr_dds0_out1_wavetype.dev_attr.attr) ||
> > +           (attr ==
> > +           &iio_dev_attr_dds0_out1_wavetype_available.dev_attr.attr))
> > +           mode = 0;
> > +
> > +   return mode;
> > +}
> > +
> > +static const struct attribute_group ad9834_attribute_group = {
> > +   .attrs = ad9834_attributes,
> > +   .is_visible = ad9834_attr_is_visible,
> > +};
> > +
> > +static int __devinit ad9834_probe(struct spi_device *spi)
> > +{
> > +   struct ad9834_platform_data *pdata = spi->dev.platform_data;
> > +   struct ad9834_state *st;
> > +   int ret;
> > +
> > +   if (!pdata) {
> > +           dev_dbg(&spi->dev, "no platform data?\n");
> > +           return -ENODEV;
> > +   }
> > +
> > +   st = kzalloc(sizeof(*st), GFP_KERNEL);
> > +   if (st == NULL) {
> > +           ret = -ENOMEM;
> > +           goto error_ret;
> > +   }
> > +
> > +   st->reg = regulator_get(&spi->dev, "vcc");
> > +   if (!IS_ERR(st->reg)) {
> > +           ret = regulator_enable(st->reg);
> > +           if (ret)
> > +                   goto error_put_reg;
> > +   }
> > +
> > +   st->mclk = pdata->mclk;
> > +
> > +   spi_set_drvdata(spi, st);
> > +
> > +   st->spi = spi;
> > +   st->devid = spi_get_device_id(spi)->driver_data;
> > +
> > +   st->indio_dev = iio_allocate_device();
> > +   if (st->indio_dev == NULL) {
> > +           ret = -ENOMEM;
> > +           goto error_disable_reg;
> > +   }
> > +
> > +   st->indio_dev->dev.parent = &spi->dev;
> > +   st->indio_dev->attrs = &ad9834_attribute_group;
> > +   st->indio_dev->dev_data = (void *)(st);
> nitpick: technically superflous brackets...

ok

> > +   st->indio_dev->driver_module = THIS_MODULE;
> > +   st->indio_dev->modes = INDIO_DIRECT_MODE;
> > +
> > +   /* Setup default messages */
> > +
> > +   st->xfer.tx_buf = &st->data;
> > +   st->xfer.len = 2;
> > +
> > +   spi_message_init(&st->msg);
> > +   spi_message_add_tail(&st->xfer, &st->msg);
> > +
> > +   st->freq_xfer[0].tx_buf = &st->freq_data[0];
> > +   st->freq_xfer[0].len = 2;
> > +   st->freq_xfer[0].cs_change = 1;
> > +   st->freq_xfer[1].tx_buf = &st->freq_data[1];
> > +   st->freq_xfer[1].len = 2;
> > +
> > +   spi_message_init(&st->freq_msg);
> > +   spi_message_add_tail(&st->freq_xfer[0], &st->freq_msg);
> > +   spi_message_add_tail(&st->freq_xfer[1], &st->freq_msg);
> > +
> > +   st->control = AD9834_B28 | AD9834_RESET;
> > +
> > +   if (!pdata->en_div2)
> > +           st->control |= AD9834_DIV2;
> > +
> > +   if (!pdata->en_signbit_msb_out && (st->devid == ID_AD9834))
> > +           st->control |= AD9834_SIGN_PIB;
> > +
> > +   st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +   ret = spi_sync(st->spi, &st->msg);
> > +   if (ret) {
> > +           dev_err(&spi->dev, "device init failed\n");
> > +           goto error_free_device;
> > +   }
> > +
> > +   ret = ad9834_write_frequency(st, AD9834_REG_FREQ0, pdata->freq0);
> > +   if (ret)
> > +           goto error_free_device;
> > +
> > +   ret = ad9834_write_frequency(st, AD9834_REG_FREQ1, pdata->freq1);
> > +   if (ret)
> > +           goto error_free_device;
> > +
> > +   ret = ad9834_write_phase(st, AD9834_REG_PHASE0, pdata->phase0);
> > +   if (ret)
> > +           goto error_free_device;
> > +
> > +   ret = ad9834_write_phase(st, AD9834_REG_PHASE1, pdata->phase1);
> > +   if (ret)
> > +           goto error_free_device;
> > +
> > +   st->control &= ~AD9834_RESET;
> > +   st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
> > +   ret = spi_sync(st->spi, &st->msg);
> > +   if (ret)
> > +           goto error_free_device;
> > +
> > +   ret = iio_device_register(st->indio_dev);
> > +   if (ret)
> > +           goto error_free_device;
> > +
> > +   return 0;
> > +
> > +error_free_device:
> > +   iio_free_device(st->indio_dev);
> > +error_disable_reg:
> > +   if (!IS_ERR(st->reg))
> > +           regulator_disable(st->reg);
> > +error_put_reg:
> > +   if (!IS_ERR(st->reg))
> > +           regulator_put(st->reg);
> > +   kfree(st);
> > +error_ret:
> > +   return ret;
> > +}
> > +
> > +static int __devexit ad9834_remove(struct spi_device *spi)
> > +{
> > +   struct ad9834_state *st = spi_get_drvdata(spi);
> > +   struct iio_dev *indio_dev = st->indio_dev;
> > +
> nitpick: could just use st->indio_dev in the next call and lose the
> line above.  It's the only use in this function.

ok

> > +   iio_device_unregister(indio_dev);
> > +   if (!IS_ERR(st->reg)) {
> > +           regulator_disable(st->reg);
> > +           regulator_put(st->reg);
> > +   }
> > +   kfree(st);
> > +   return 0;
> > +}
> > +
> > +static const struct spi_device_id ad9834_id[] = {
> > +   {"ad9833", ID_AD9833},
> > +   {"ad9834", ID_AD9834},
> > +   {}
> > +};
> > +
> > +static struct spi_driver ad9834_driver = {
> > +   .driver = {
> > +           .name   = "ad9834",
> > +           .bus    = &spi_bus_type,
> > +           .owner  = THIS_MODULE,
> > +   },
> > +   .probe          = ad9834_probe,
> > +   .remove         = __devexit_p(ad9834_remove),
> > +   .id_table       = ad9834_id,
> > +};
> > +
> > +static int __init ad9834_init(void)
> > +{
> > +   return spi_register_driver(&ad9834_driver);
> > +}
> > +module_init(ad9834_init);
> > +
> > +static void __exit ad9834_exit(void)
> > +{
> > +   spi_unregister_driver(&ad9834_driver);
> > +}
> > +module_exit(ad9834_exit);
> > +
> > +MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
> > +MODULE_DESCRIPTION("Analog Devices AD9833/AD9834 DDS");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_ALIAS("spi:ad9834");
> > diff --git a/drivers/staging/iio/dds/ad9834.h
> b/drivers/staging/iio/dds/ad9834.h
> > new file mode 100644
> > index 0000000..0fc3b88
> > --- /dev/null
> > +++ b/drivers/staging/iio/dds/ad9834.h
> > @@ -0,0 +1,112 @@
> > +/*
> > + * AD9834 SPI DDS driver
> > + *
> > + * Copyright 2010 Analog Devices Inc.
> > + *
> > + * Licensed under the GPL-2 or later.
> > + */
> > +#ifndef IIO_DDS_AD9834_H_
> > +#define IIO_DDS_AD9834_H_
> > +
> > +/* Registers */
> > +
> > +#define AD9834_REG_CMD             (0 << 14)
> > +#define AD9834_REG_FREQ0   (1 << 14)
> > +#define AD9834_REG_FREQ1   (2 << 14)
> > +#define AD9834_REG_PHASE0  (6 << 13)
> > +#define AD9834_REG_PHASE1  (7 << 13)
> > +
> > +/* Command Control Bits */
> > +
> > +#define AD9834_B28         (1 << 13)
> > +#define AD9834_HLB         (1 << 12)
> > +#define AD9834_FSEL                (1 << 11)
> > +#define AD9834_PSEL                (1 << 10)
> > +#define AD9834_PIN_SW              (1 << 9)
> > +#define AD9834_RESET               (1 << 8)
> > +#define AD9834_SLEEP1              (1 << 7)
> > +#define AD9834_SLEEP12             (1 << 6)
> > +#define AD9834_OPBITEN             (1 << 5)
> > +#define AD9834_SIGN_PIB            (1 << 4)
> > +#define AD9834_DIV2                (1 << 3)
> > +#define AD9834_MODE                (1 << 1)
> > +
> > +#define AD9834_FREQ_BITS   28
> > +#define AD9834_PHASE_BITS  12
> > +
> > +#define RES_MASK(bits)     ((1 << (bits)) - 1)
> > +
> > +/**
> > + * struct ad9834_state - driver instance specific data
> > + * @indio_dev:             the industrial I/O device
> > + * @spi:           spi_device
> > + * @reg:           supply regulator
> > + * @mclk:          external master clock
> > + * @control:               cached control word
> > + * @xfer:          default spi transfer
> > + * @msg:           default spi message
> > + * @freq_xfer:             tuning word spi transfer
> > + * @freq_msg:              tuning word spi message
> > + * @data:          spi transmit buffer
> > + * @freq_data:             tuning word spi transmit buffer
> > + */
> > +
> > +struct ad9834_state {
> > +   struct iio_dev                  *indio_dev;
> > +   struct spi_device               *spi;
> > +   struct regulator                *reg;
> > +   unsigned int                    mclk;
> > +   unsigned short                  control;
> > +   unsigned short                  devid;
> > +   struct spi_transfer             xfer;
> > +   struct spi_message              msg;
> > +   struct spi_transfer             freq_xfer[2];
> > +   struct spi_message              freq_msg;
> > +
> > +   /*
> > +    * DMA (thus cache coherency maintenance) requires the
> > +    * transfer buffers to live in their own cache lines.
> > +    */
> > +   unsigned short                  data ____cacheline_aligned;
> > +   unsigned short                  freq_data[2] ;
> > +};
> > +
> > +
> > +/*
> > + * TODO: struct ad7887_platform_data needs to go into
> include/linux/iio
> > + */
> > +
> > +/**
> > + * struct ad9834_platform_data - platform specific information
> > + * @mclk:          master clock in Hz
> > + * @freq0:         power up freq0 tuning word in Hz
> > + * @freq1:         power up freq1 tuning word in Hz
> > + * @phase0:                power up phase0 value [0..4095] correlates with
> 0..2PI
> > + * @phase1:                power up phase1 value [0..4095] correlates with
> 0..2PI
> > + * @en_div2:               digital output/2 is passed to the SIGN BIT OUT
> pin
> > + * @en_signbit_msb_out:    the MSB (or MSB/2) of the DAC data is
> connected to the
> > + *                 SIGN BIT OUT pin. en_div2 controls whether it is the
> MSB
> > + *                 or MSB/2 that is output. if en_signbit_msb_out=false,
> > + *                 the on-board comparator is connected to SIGN BIT OUT
> > + */
> > +
> > +struct ad9834_platform_data {
> > +   unsigned int            mclk;
> > +   unsigned int            freq0;
> > +   unsigned int            freq1;
> > +   unsigned short          phase0;
> > +   unsigned short          phase1;
> > +   bool                    en_div2;
> > +   bool                    en_signbit_msb_out;
> > +};
> > +
> > +/**
> > + * ad9834_supported_device_ids:
> > + */
> > +
> > +enum ad9834_supported_device_ids {
> > +   ID_AD9833,
> > +   ID_AD9834,
> > +};
> > +
> > +#endif /* IIO_DDS_AD9834_H_ */
> > --
> > 1.6.0.2
> >
> >


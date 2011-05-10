Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1EJBog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 21:44:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39829 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1EJBod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 21:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=K8OjpxnKPZBVQk72TXPkjZWfEOapQ9TjHW3MIWn013EPUXVThkotp9fBR1hdFC6dV6
         XsxvHRgf/6PAyGRQJYfRNQeduz32afwvykMG7Ugt25cv/nBPB5wwbwBo96uAE9k0o5lj
         6OITcY//mpHvPVEYyrFNvZHv4eRDg9pph4/vc=
MIME-Version: 1.0
In-Reply-To: <4DC7D2E8.10105@codeaurora.org>
References: <1304574535-23710-1-git-send-email-aghayal@codeaurora.org> <4DC7D2E8.10105@codeaurora.org>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Tue, 10 May 2011 09:44:09 +0800
Message-ID: <BANLkTimPeLmQiJqejk2ZNCJgQLc9GB=WRQ@mail.gmail.com>
Subject: Re: [PATCH V2] drivers: rtc: Add support for Qualcomm PMIC8xxx RTC
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/9 Anirudh Ghayal <aghayal@codeaurora.org>:
> Hi Peter, Wan,
>
> I have updated the patch with your suggested changes.
> Could you please re-review this patch.

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

thanks!

>
> Thank you,
> ~Anirudh
>
> On 5/5/2011 11:18 AM, Anirudh Ghayal wrote:
>>
>> This patch adds support for PMIC8xxx based RTC.
>> PMIC8xxx is Qualcomm's power management IC that
>> internally houses an RTC module. This driver
>> communicates with the PMIC module over SSBI bus.
>>
>> Cc: Wan ZongShun<mcuos.com@gmail.com>
>> Cc: Andrew Morton<akpm@linux-foundation.org>
>> Cc: Lars-Peter Clausen<lars@metafoo.de>
>> Signed-off-by: Anirudh Ghayal<aghayal@codeaurora.org>
>> ---
>>  drivers/rtc/Kconfig            |   10 +
>>  drivers/rtc/Makefile           |    1 +
>>  drivers/rtc/rtc-pm8xxx.c       |  568
>> ++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/pm8xxx/rtc.h |   25 ++
>>  4 files changed, 604 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/rtc/rtc-pm8xxx.c
>>  create mode 100644 include/linux/mfd/pm8xxx/rtc.h
>>
>> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
>> index e187887..39b7032 100644
>> --- a/drivers/rtc/Kconfig
>> +++ b/drivers/rtc/Kconfig
>> @@ -985,6 +985,16 @@ config RTC_DRV_LPC32XX
>>          This driver can also be buillt as a module. If so, the module
>>          will be called rtc-lpc32xx.
>>
>> +config RTC_DRV_PM8XXX
>> +       tristate "Qualcomm PMIC8XXX RTC"
>> +       depends on MFD_PM8XXX
>> +       help
>> +         If you say yes here you get support for the
>> +         Qualcomm PMIC8XXX RTC.
>> +
>> +         To compile this driver as a module, choose M here: the
>> +         module will be called rtc-pm8xxx.
>> +
>>  config RTC_DRV_TEGRA
>>        tristate "NVIDIA Tegra Internal RTC driver"
>>        depends on RTC_CLASS&&  ARCH_TEGRA
>> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
>> index ca91c3c..40a6e66 100644
>> --- a/drivers/rtc/Makefile
>> +++ b/drivers/rtc/Makefile
>> @@ -74,6 +74,7 @@ obj-$(CONFIG_RTC_DRV_PCF2123) += rtc-pcf2123.o
>>  obj-$(CONFIG_RTC_DRV_PCF50633)        += rtc-pcf50633.o
>>  obj-$(CONFIG_RTC_DRV_PL030)   += rtc-pl030.o
>>  obj-$(CONFIG_RTC_DRV_PL031)   += rtc-pl031.o
>> +obj-$(CONFIG_RTC_DRV_PM8XXX)    += rtc-pm8xxx.o
>>  obj-$(CONFIG_RTC_DRV_PS3)     += rtc-ps3.o
>>  obj-$(CONFIG_RTC_DRV_PXA)     += rtc-pxa.o
>>  obj-$(CONFIG_RTC_DRV_R9701)   += rtc-r9701.o
>> diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
>> new file mode 100644
>> index 0000000..95e3911
>> --- /dev/null
>> +++ b/drivers/rtc/rtc-pm8xxx.c
>> @@ -0,0 +1,568 @@
>> +/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include<linux/module.h>
>> +#include<linux/init.h>
>> +#include<linux/rtc.h>
>> +#include<linux/pm.h>
>> +#include<linux/slab.h>
>> +#include<linux/spinlock.h>
>> +
>> +#include<linux/mfd/pm8xxx/core.h>
>> +#include<linux/mfd/pm8xxx/rtc.h>
>> +
>> +
>> +/* RTC Register offsets from RTC CTRL REG */
>> +#define PM8XXX_ALARM_CTRL_OFFSET 0x01
>> +#define PM8XXX_RTC_WRITE_OFFSET 0x02
>> +#define PM8XXX_RTC_READ_OFFSET 0x06
>> +#define PM8XXX_ALARM_RW_OFFSET 0x0A
>> +
>> +/* RTC_CTRL register bit fields */
>> +#define PM8xxx_RTC_ENABLE      BIT(7)
>> +#define PM8xxx_RTC_ALARM_ENABLE        BIT(1)
>> +#define PM8xxx_RTC_ALARM_CLEAR  BIT(0)
>> +
>> +#define NUM_8_BIT_RTC_REGS     0x4
>> +
>> +/**
>> + * struct pm8xxx_rtc - rtc driver internal structure
>> + * @rtc: rtc device for this driver
>> + * @rtc_alarm_irq: rtc alarm irq number
>> + */
>> +struct pm8xxx_rtc {
>> +       struct rtc_device *rtc;
>> +       int rtc_alarm_irq;
>> +       int rtc_base;
>> +       int rtc_read_base;
>> +       int rtc_write_base;
>> +       int alarm_rw_base;
>> +       u8  ctrl_reg;
>> +       struct device *rtc_dev;
>> +       spinlock_t ctrl_reg_lock;
>> +};
>> +
>> +/*
>> + * The RTC registers need to be read/written one byte at a time. This is
>> a
>> + * hardware limitation.
>> + */
>> +
>> +static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
>> +                       int base, int count)
>> +{
>> +       int i, rc;
>> +       struct device *parent = rtc_dd->rtc_dev->parent;
>> +
>> +       for (i = 0; i<  count; i++) {
>> +               rc = pm8xxx_readb(parent, base + i,&rtc_val[i]);
>> +               if (rc<  0) {
>> +                       dev_err(rtc_dd->rtc_dev, "PM8xxx read failed\n");
>> +                       return rc;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
>> +                       int base, int count)
>> +{
>> +       int i, rc;
>> +       struct device *parent = rtc_dd->rtc_dev->parent;
>> +
>> +       for (i = 0; i<  count; i++) {
>> +               rc = pm8xxx_writeb(parent, base + i, rtc_val[i]);
>> +               if (rc<  0) {
>> +                       dev_err(rtc_dd->rtc_dev, "PM8xxx write failed\n");
>> +                       return rc;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +
>> +/*
>> + * Steps to write the RTC registers.
>> + * 1. Disable alarm if enabled.
>> + * 2. Write 0x00 to LSB.
>> + * 3. Write Byte[1], Byte[2], Byte[3] then Byte[0].
>> + * 4. Enable alarm if disabled in step 1.
>> + */
>> +static int
>> +pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
>> +{
>> +       int rc;
>> +       unsigned long secs, irq_flags;
>> +       u8 value[4], reg = 0, alarm_enabled = 0, ctrl_reg;
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +
>> +       rtc_tm_to_time(tm,&secs);
>> +
>> +       value[0] = secs&  0xFF;
>> +       value[1] = (secs>>  8)&  0xFF;
>> +       value[2] = (secs>>  16)&  0xFF;
>> +       value[3] = (secs>>  24)&  0xFF;
>> +
>> +       dev_dbg(dev, "Seconds value to be written to RTC = %lu\n", secs);
>> +
>> +       spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +       ctrl_reg = rtc_dd->ctrl_reg;
>> +
>> +       if (ctrl_reg&  PM8xxx_RTC_ALARM_ENABLE) {
>> +               alarm_enabled = 1;
>> +               ctrl_reg&= ~PM8xxx_RTC_ALARM_ENABLE;
>> +               rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg,
>> rtc_dd->rtc_base,
>> +
>> 1);
>> +               if (rc<  0) {
>> +                       dev_err(dev, "PM8xxx write failed\n");
>> +                       goto rtc_rw_fail;
>> +               }
>> +       } else
>> +               spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +
>> +       /* Write Byte[1], Byte[2], Byte[3], Byte[0] */
>> +       /* Write 0 to Byte[0] */
>> +       reg = 0;
>> +       rc = pm8xxx_write_wrapper(rtc_dd,&reg, rtc_dd->rtc_write_base, 1);
>> +       if (rc<  0) {
>> +               dev_err(dev, "PM8xxx write failed\n");
>> +               goto rtc_rw_fail;
>> +       }
>> +
>> +       /* Write Byte[1], Byte[2], Byte[3] */
>> +       rc = pm8xxx_write_wrapper(rtc_dd, value + 1,
>> +                                       rtc_dd->rtc_write_base + 1, 3);
>> +       if (rc<  0) {
>> +               dev_err(dev, "Write to RTC registers failed\n");
>> +               goto rtc_rw_fail;
>> +       }
>> +
>> +       /* Write Byte[0] */
>> +       rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->rtc_write_base,
>> 1);
>> +       if (rc<  0) {
>> +               dev_err(dev, "Write to RTC register failed\n");
>> +               goto rtc_rw_fail;
>> +       }
>> +
>> +       if (alarm_enabled) {
>> +               ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
>> +               rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg,
>> rtc_dd->rtc_base,
>> +
>> 1);
>> +               if (rc<  0) {
>> +                       dev_err(dev, "PM8xxx write failed\n");
>> +                       goto rtc_rw_fail;
>> +               }
>> +       }
>> +
>> +       rtc_dd->ctrl_reg = ctrl_reg;
>> +
>> +rtc_rw_fail:
>> +       if (alarm_enabled)
>> +               spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +
>> +       return rc;
>> +}
>> +
>> +static int
>> +pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
>> +{
>> +       int rc;
>> +       u8 value[4], reg;
>> +       unsigned long secs;
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +
>> +       rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->rtc_read_base,
>> +
>> NUM_8_BIT_RTC_REGS);
>> +       if (rc<  0) {
>> +               dev_err(dev, "RTC time read failed\n");
>> +               return rc;
>> +       }
>> +
>> +       /*
>> +        * Read the LSB again and check if there has been a carry over.
>> +        * If there is, redo the read operation.
>> +        */
>> +       rc = pm8xxx_read_wrapper(rtc_dd,&reg, rtc_dd->rtc_read_base, 1);
>> +       if (rc<  0) {
>> +               dev_err(dev, "PM8xxx read failed\n");
>> +               return rc;
>> +       }
>> +
>> +       if (unlikely(reg<  value[0])) {
>> +               rc = pm8xxx_read_wrapper(rtc_dd, value,
>> +                               rtc_dd->rtc_read_base,
>> NUM_8_BIT_RTC_REGS);
>> +               if (rc<  0) {
>> +                       dev_err(dev, "RTC time read failed\n");
>> +                       return rc;
>> +               }
>> +       }
>> +
>> +       secs = value[0] | (value[1]<<  8) | (value[2]<<  16) \
>> +                                               | (value[3]<<  24);
>> +
>> +       rtc_time_to_tm(secs, tm);
>> +
>> +       rc = rtc_valid_tm(tm);
>> +       if (rc<  0) {
>> +               dev_err(dev, "Invalid time read from PM8xxx\n");
>> +               return rc;
>> +       }
>> +
>> +       dev_dbg(dev, "secs = %lu, h:m:s == %d:%d:%d, d/m/y = %d/%d/%d\n",
>> +                       secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
>> +                       tm->tm_mday, tm->tm_mon, tm->tm_year);
>> +
>> +       return 0;
>> +}
>> +
>> +static int
>> +pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
>> +{
>> +       int rc;
>> +       u8 value[4], ctrl_reg;
>> +       unsigned long secs, secs_rtc, irq_flags;
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +       struct rtc_time rtc_tm;
>> +
>> +       rtc_tm_to_time(&alarm->time,&secs);
>> +
>> +       /*
>> +        * Read the current RTC time and verify if the alarm time is in
>> the
>> +        * past. If yes, return invalid.
>> +        */
>> +       rc = pm8xxx_rtc_read_time(dev,&rtc_tm);
>> +       if (rc<  0) {
>> +               dev_err(dev, "Unamble to read RTC time\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       rtc_tm_to_time(&rtc_tm,&secs_rtc);
>> +       if (secs<  secs_rtc) {
>> +               dev_err(dev, "Trying to set alarm in the past\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       value[0] = secs&  0xFF;
>> +       value[1] = (secs>>  8)&  0xFF;
>> +       value[2] = (secs>>  16)&  0xFF;
>> +       value[3] = (secs>>  24)&  0xFF;
>> +
>> +       spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +
>> +       rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
>> +
>> NUM_8_BIT_RTC_REGS);
>> +       if (rc<  0) {
>> +               dev_err(dev, "Write to RTC ALARM registers failed\n");
>> +               goto rtc_rw_fail;
>> +       }
>> +
>> +       ctrl_reg = rtc_dd->ctrl_reg;
>> +       ctrl_reg = (alarm->enabled) ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE)
>> :
>> +                                       (ctrl_reg&
>>  ~PM8xxx_RTC_ALARM_ENABLE);
>> +
>> +       rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg, rtc_dd->rtc_base, 1);
>> +       if (rc<  0) {
>> +               dev_err(dev, "PM8xxx write failed\n");
>> +               goto rtc_rw_fail;
>> +       }
>> +
>> +       rtc_dd->ctrl_reg = ctrl_reg;
>> +
>> +       dev_dbg(dev, "Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
>> +                       alarm->time.tm_hour, alarm->time.tm_min,
>> +                       alarm->time.tm_sec, alarm->time.tm_mday,
>> +                       alarm->time.tm_mon, alarm->time.tm_year);
>> +rtc_rw_fail:
>> +       spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +       return rc;
>> +}
>> +
>> +static int
>> +pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
>> +{
>> +       int rc;
>> +       u8 value[4];
>> +       unsigned long secs;
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +
>> +       rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
>> +                       NUM_8_BIT_RTC_REGS);
>> +       if (rc<  0) {
>> +               dev_err(dev, "RTC alarm time read failed\n");
>> +               return rc;
>> +       }
>> +
>> +       secs = value[0] | (value[1]<<  8) | (value[2]<<  16) | \
>> +                                                (value[3]<<  24);
>> +
>> +       rtc_time_to_tm(secs,&alarm->time);
>> +
>> +       rc = rtc_valid_tm(&alarm->time);
>> +       if (rc<  0) {
>> +               dev_err(dev, "Invalid time read from PM8xxx\n");
>> +               return rc;
>> +       }
>> +
>> +       dev_dbg(dev, "Alarm set for - h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
>> +               alarm->time.tm_hour, alarm->time.tm_min,
>> +                               alarm->time.tm_sec, alarm->time.tm_mday,
>> +                               alarm->time.tm_mon, alarm->time.tm_year);
>> +
>> +       return 0;
>> +}
>> +
>> +
>> +static int
>> +pm8xxx_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
>> +{
>> +       int rc;
>> +       unsigned long irq_flags;
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +       u8 ctrl_reg;
>> +
>> +       spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +       ctrl_reg = rtc_dd->ctrl_reg;
>> +       ctrl_reg = (enable) ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
>> +                               (ctrl_reg&  ~PM8xxx_RTC_ALARM_ENABLE);
>> +
>> +       rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg, rtc_dd->rtc_base, 1);
>> +       if (rc<  0) {
>> +               dev_err(dev, "PM8xxx write failed\n");
>> +               goto rtc_rw_fail;
>> +       }
>> +
>> +       rtc_dd->ctrl_reg = ctrl_reg;
>> +
>> +rtc_rw_fail:
>> +       spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +       return rc;
>> +}
>> +
>> +static struct rtc_class_ops pm8xxx_rtc_ops = {
>> +       .read_time      = pm8xxx_rtc_read_time,
>> +       .set_alarm      = pm8xxx_rtc_set_alarm,
>> +       .read_alarm     = pm8xxx_rtc_read_alarm,
>> +       .alarm_irq_enable = pm8xxx_rtc_alarm_irq_enable,
>> +};
>> +
>> +static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
>> +{
>> +       struct pm8xxx_rtc *rtc_dd = dev_id;
>> +       u8 ctrl_reg;
>> +       int rc;
>> +       unsigned long irq_flags;
>> +
>> +       rtc_update_irq(rtc_dd->rtc, 1, RTC_IRQF | RTC_AF);
>> +
>> +       spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +
>> +       /* Clear the alarm enable bit */
>> +       ctrl_reg = rtc_dd->ctrl_reg;
>> +       ctrl_reg&= ~PM8xxx_RTC_ALARM_ENABLE;
>> +
>> +       rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg, rtc_dd->rtc_base, 1);
>> +       if (rc<  0) {
>> +               spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +               dev_err(rtc_dd->rtc_dev, "PM8xxx write failed!\n");
>> +               goto rtc_alarm_handled;
>> +       }
>> +
>> +       rtc_dd->ctrl_reg = ctrl_reg;
>> +       spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
>> +
>> +       /* Clear RTC alarm register */
>> +       rc = pm8xxx_read_wrapper(rtc_dd,&ctrl_reg, rtc_dd->rtc_base +
>> +                                               PM8XXX_ALARM_CTRL_OFFSET,
>> 1);
>> +       if (rc<  0) {
>> +               dev_err(rtc_dd->rtc_dev, "PM8xxx write failed!\n");
>> +               goto rtc_alarm_handled;
>> +       }
>> +
>> +       ctrl_reg&= ~PM8xxx_RTC_ALARM_CLEAR;
>> +       rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg, rtc_dd->rtc_base +
>> +                                               PM8XXX_ALARM_CTRL_OFFSET,
>> 1);
>> +       if (rc<  0)
>> +               dev_err(rtc_dd->rtc_dev, "PM8xxx write failed!\n");
>> +
>> +rtc_alarm_handled:
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static int __devinit pm8xxx_rtc_probe(struct platform_device *pdev)
>> +{
>> +       int rc;
>> +       u8 ctrl_reg;
>> +       bool rtc_write_enable = false;
>> +       struct pm8xxx_rtc *rtc_dd;
>> +       struct resource *rtc_resource;
>> +       const struct pm8xxx_rtc_platform_data *pdata = mfd_get_data(pdev);
>> +
>> +       if (pdata != NULL)
>> +               rtc_write_enable = pdata->rtc_write_enable;
>> +
>> +       rtc_dd = kzalloc(sizeof(*rtc_dd), GFP_KERNEL);
>> +       if (rtc_dd == NULL) {
>> +               dev_err(&pdev->dev, "Unable to allocate memory!\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       /* Initialise spinlock to protect RTC cntrol register */
>> +       spin_lock_init(&rtc_dd->ctrl_reg_lock);
>> +
>> +       rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
>> +       if (rtc_dd->rtc_alarm_irq<  0) {
>> +               dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
>> +               rc = -ENXIO;
>> +               goto fail_rtc_enable;
>> +       }
>> +
>> +       rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
>> +                                                       "pmic_rtc_base");
>> +       if (!(rtc_resource&&  rtc_resource->start)) {
>> +               dev_err(&pdev->dev, "RTC IO resource absent!\n");
>> +               rc = -ENXIO;
>> +               goto fail_rtc_enable;
>> +       }
>> +
>> +       rtc_dd->rtc_base = rtc_resource->start;
>> +
>> +       /* Setup RTC register addresses */
>> +       rtc_dd->rtc_write_base = rtc_dd->rtc_base +
>> PM8XXX_RTC_WRITE_OFFSET;
>> +       rtc_dd->rtc_read_base = rtc_dd->rtc_base + PM8XXX_RTC_READ_OFFSET;
>> +       rtc_dd->alarm_rw_base = rtc_dd->rtc_base + PM8XXX_ALARM_RW_OFFSET;
>> +
>> +       rtc_dd->rtc_dev =&(pdev->dev);
>> +
>> +       /* Check if the RTC is on, else turn it on */
>> +       rc = pm8xxx_read_wrapper(rtc_dd,&ctrl_reg, rtc_dd->rtc_base, 1);
>> +       if (rc<  0) {
>> +               dev_err(&pdev->dev, "PM8xxx read failed!\n");
>> +               goto fail_rtc_enable;
>> +       }
>> +
>> +       if (!(ctrl_reg&  PM8xxx_RTC_ENABLE)) {
>> +               ctrl_reg |= PM8xxx_RTC_ENABLE;
>> +               rc = pm8xxx_write_wrapper(rtc_dd,&ctrl_reg,
>> rtc_dd->rtc_base,
>> +
>> 1);
>> +               if (rc<  0) {
>> +                       dev_err(&pdev->dev, "PM8xxx write failed!\n");
>> +                       goto fail_rtc_enable;
>> +               }
>> +       }
>> +
>> +       rtc_dd->ctrl_reg = ctrl_reg;
>> +       if (rtc_write_enable == true)
>> +               pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
>> +
>> +       platform_set_drvdata(pdev, rtc_dd);
>> +
>> +       /* Register the RTC device */
>> +       rtc_dd->rtc = rtc_device_register("pm8xxx_rtc",&pdev->dev,
>> +                               &pm8xxx_rtc_ops, THIS_MODULE);
>> +       if (IS_ERR(rtc_dd->rtc)) {
>> +               dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
>> +                                       __func__, PTR_ERR(rtc_dd->rtc));
>> +               rc = PTR_ERR(rtc_dd->rtc);
>> +               goto fail_rtc_enable;
>> +       }
>> +
>> +       /* Request the alarm IRQ */
>> +       rc = request_any_context_irq(rtc_dd->rtc_alarm_irq,
>> +                                pm8xxx_alarm_trigger,
>> IRQF_TRIGGER_RISING,
>> +                                "pm8xxx_rtc_alarm", rtc_dd);
>> +       if (rc<  0) {
>> +               dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
>> +               goto fail_req_irq;
>> +       }
>> +
>> +       device_init_wakeup(&pdev->dev, 1);
>> +
>> +       dev_dbg(&pdev->dev, "Probe success !!\n");
>> +
>> +       return 0;
>> +
>> +fail_req_irq:
>> +       rtc_device_unregister(rtc_dd->rtc);
>> +fail_rtc_enable:
>> +       platform_set_drvdata(pdev, NULL);
>> +       kfree(rtc_dd);
>> +       return rc;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int pm8xxx_rtc_resume(struct device *dev)
>> +{
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +
>> +       if (device_may_wakeup(dev))
>> +               disable_irq_wake(rtc_dd->rtc_alarm_irq);
>> +
>> +       return 0;
>> +}
>> +
>> +static int pm8xxx_rtc_suspend(struct device *dev)
>> +{
>> +       struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
>> +
>> +       if (device_may_wakeup(dev))
>> +               enable_irq_wake(rtc_dd->rtc_alarm_irq);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct dev_pm_ops pm8xxx_rtc_pm_ops = {
>> +       .suspend = pm8xxx_rtc_suspend,
>> +       .resume = pm8xxx_rtc_resume,
>> +};
>> +#endif
>> +static int __devexit pm8xxx_rtc_remove(struct platform_device *pdev)
>> +{
>> +       struct pm8xxx_rtc *rtc_dd = platform_get_drvdata(pdev);
>> +
>> +       device_init_wakeup(&pdev->dev, 0);
>> +       free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
>> +       rtc_device_unregister(rtc_dd->rtc);
>> +       platform_set_drvdata(pdev, NULL);
>> +       kfree(rtc_dd);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct platform_driver pm8xxx_rtc_driver = {
>> +       .probe          = pm8xxx_rtc_probe,
>> +       .remove         = __devexit_p(pm8xxx_rtc_remove),
>> +       .driver = {
>> +               .name   = PM8XXX_RTC_DEV_NAME,
>> +               .owner  = THIS_MODULE,
>> +#ifdef CONFIG_PM
>> +               .pm     =&pm8xxx_rtc_pm_ops,
>> +#endif
>> +       },
>> +};
>> +
>> +static int __init pm8xxx_rtc_init(void)
>> +{
>> +       return platform_driver_register(&pm8xxx_rtc_driver);
>> +}
>> +module_init(pm8xxx_rtc_init);
>> +
>> +static void __exit pm8xxx_rtc_exit(void)
>> +{
>> +       platform_driver_unregister(&pm8xxx_rtc_driver);
>> +}
>> +module_exit(pm8xxx_rtc_exit);
>> +
>> +MODULE_ALIAS("platform:rtc-pm8xxx");
>> +MODULE_DESCRIPTION("PMIC8xxx RTC driver");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR("Anirudh Ghayal<aghayal@codeaurora.org>");
>> diff --git a/include/linux/mfd/pm8xxx/rtc.h
>> b/include/linux/mfd/pm8xxx/rtc.h
>> new file mode 100644
>> index 0000000..14f1983
>> --- /dev/null
>> +++ b/include/linux/mfd/pm8xxx/rtc.h
>> @@ -0,0 +1,25 @@
>> +/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef __RTC_PM8XXX_H__
>> +#define __RTC_PM8XXX_H__
>> +
>> +#define PM8XXX_RTC_DEV_NAME     "rtc-pm8xxx"
>> +/**
>> + * struct pm8xxx_rtc_pdata - RTC driver platform data
>> + * @rtc_write_enable: variable stating RTC write capability
>> + */
>> +struct pm8xxx_rtc_platform_data {
>> +       bool rtc_write_enable;
>> +};
>> +
>> +#endif /* __RTC_PM8XXX_H__ */
>
>



-- 
Wan ZongShun.
www.mcuos.com

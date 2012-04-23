Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2DWCeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:34:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47676 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DWCeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:34:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7cb4ae000000d81-d7-4f94bf991c84
Message-id: <4F94BF94.6000208@samsung.com>
Date: Mon, 23 Apr 2012 11:33:56 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: a.zummo@towertech.it, kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: Add MAX8997 RTC driver
References: <4F90CE19.9060502@samsung.com>
 <CAP=VYLrRshhdqMDTte8vms5jGq+AMx+yhaPf6Gq9YZ81CQRq8w@mail.gmail.com>
In-reply-to: <CAP=VYLrRshhdqMDTte8vms5jGq+AMx+yhaPf6Gq9YZ81CQRq8w@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul,

First of all, i really appreciate of your concern and advices.

I'll accept your advice and also will apply it.

Anyway, here is answers for your questions.

=> Although MAX8997 and MAX8998 have almost same functions, it is more
efficient that control each of them by own driver. Because they have
diffrent register map and its control also little bit diffrent.

=> About delay variable,,,
Actually it is not for MAX8997 device, but for LP397X mfd. It is
empirical and also documented (by chip producer) bug occured when read
registers after writing. Allowing some delays after writing register ,
problem can be solved. If "delay" field of platform data is
true(LP397x), the rtc driver assumes that such delays are required.

I'm sorry for omiting comments more details. I hope it help you to clear
your questions. If you have more questions or opinion, please contact me
by this e-mail.

Thanks

Lee.


On 2012년 04월 23일 03:41, Paul Gortmaker wrote:

> On Thu, Apr 19, 2012 at 10:46 PM,  <jonghwa3.lee@samsung.com> wrote:
>> From: MyungJoo Ham <myungjoo.ham@samsung.com>
>>
>> This patch is for MAX8997's rtc driver. It is based on MAX8998 RTC driver.
> 
> It would be nice to see that comment at the top of the new C file
> as well as just here.   Any chance for enhancing the 8898 support
> to add 8997 support, instead of creating a new file/driver?
> 
> It would also be nice to see more about this "delay" thing you add.
> 
> Is it a workaround for a documented hardware bug, or one of those
> empirical "hey, it works now when we add this mdelay"  type items?
> 
> Who will be responsible for setting the delay bit when it is required?
> Is it more simple to just unconditionally delay, and not make the
> special case?
> 
> Paul.
> --
> 
>> MAX8997 is a PMIC and RTC is client of it.
>>
>> RTC driver can support below features.
>> - Set and read Real time clock
>> - Set Alarm ON/OFF
>>
>> (RTC also can control WTSR(Watch dog timer) SMPL(Sudden Momentary Power
>> Loss) mode
>>    ,but it isn't implemented.)
>>
>> It was tesed by 'rtc-test' which is provided by<Documentation/rtc.txt>
>>
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/rtc/Kconfig         |   10 +
>>  drivers/rtc/Makefile        |    1 +
>>  drivers/rtc/rtc-max8997.c   |  443
>> +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/max8997.h |    1 +
>>  4 files changed, 455 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/rtc/rtc-max8997.c
>>
>> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
>> index 8c8377d..9a7072e 100644
>> --- a/drivers/rtc/Kconfig
>> +++ b/drivers/rtc/Kconfig
>> @@ -213,6 +213,16 @@ config RTC_DRV_MAX8998
>>          This driver can also be built as a module. If so, the module
>>          will be called rtc-max8998.
>>
>> +config RTC_DRV_MAX8997
>> +       tristate "Maxim MAX8997"
>> +       depends on MFD_MAX8997
>> +       help
>> +         If you say yes here you will get support for the
>> +         RTC of Maxim MAX8997 PMIC.
>> +
>> +         This driver can also be built as a module. If so, the module
>> +         will be called rtc-max8997.
>> +
>>  config RTC_DRV_RS5C372
>>        tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
>>        help
>> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
>> index 727ae77..8810867 100644
>> --- a/drivers/rtc/Makefile
>> +++ b/drivers/rtc/Makefile
>> @@ -65,6 +65,7 @@ obj-$(CONFIG_RTC_MXC)         += rtc-mxc.o
>>  obj-$(CONFIG_RTC_DRV_MAX6900)  += rtc-max6900.o
>>  obj-$(CONFIG_RTC_DRV_MAX8925)  += rtc-max8925.o
>>  obj-$(CONFIG_RTC_DRV_MAX8998)  += rtc-max8998.o
>> +obj-$(CONFIG_RTC_DRV_MAX8997)  += rtc-max8997.o
>>  obj-$(CONFIG_RTC_DRV_MAX6902)  += rtc-max6902.o
>>  obj-$(CONFIG_RTC_DRV_MC13XXX)  += rtc-mc13xxx.o
>>  obj-$(CONFIG_RTC_DRV_MSM6242)  += rtc-msm6242.o
>> diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
>> new file mode 100644
>> index 0000000..8a494fb
>> --- /dev/null
>> +++ b/drivers/rtc/rtc-max8997.c
>> @@ -0,0 +1,443 @@
>> +/*
>> + * rtc-max8997.c - RTC driver for Maxim 8966 and 8997
>> + *
>> + * Copyright (C) 2012 Samsung Electronics
>> + * MyungJoo Ham <myungjoo.ham@samsung.com>
>> + *
>> + * This program is not provided / owned by Maxim Integrated Products.
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
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
>>  USA
>> + *
>> + */
>> +
>> +#include <linux/bcd.h>
>> +#include <linux/delay.h>
>> +#include <linux/mutex.h>
>> +#include <linux/slab.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/rtc.h>
>> +#include <linux/mfd/max8997.h>
>> +#include <linux/mfd/max8997-private.h>
>> +
>> +struct rtc_data{
>> +       struct mutex            lock;
>> +       struct i2c_client       *i2c;
>> +       struct max8997_dev      *iodev;
>> +
>> +       struct device           *dev;
>> +       struct rtc_device       *rtc_dev;
>> +
>> +       int irq;
>> +       bool delay;
>> +};
>> +
>> +enum {
>> +       RTC_SEC = 0,
>> +       RTC_MIN,
>> +       RTC_HOUR,
>> +       RTC_WEEKDAY,
>> +       RTC_MONTH,
>> +       RTC_YEAR,
>> +       RTC_MONTHDAY,
>> +       RTC_DATA_SIZE,
>> +};
>> +
>> +static inline int wday_8997_to_kernel(u8 shifted)
>> +{
>> +       int counter = -1;
>> +       while (shifted) {
>> +               shifted >>= 1;
>> +               counter++;
>> +       }
>> +       return counter;
>> +}
>> +
>> +static void __maybe_unused dump(struct rtc_data *rtc)
>> +{
>> +       int i, j;
>> +       char buf[256];
>> +       char *ptr;
>> +       u8 val;
>> +
>> +       for (i = 0; i < 3; i++) {
>> +               ptr = buf;
>> +               ptr += sprintf(ptr, "[%2.2xh] ", i * 16);
>> +               for (j = 0; j < 16; j++) {
>> +                       max8997_read_reg(rtc->i2c, i * 16 + j, &val);
>> +                       ptr += sprintf(ptr, "%2.2x ", val);
>> +               }
>> +               pr_info("%s\n", buf);
>> +       }
>> +}
>> +
>> +static inline u8 wday_kernel_to_8997(u8 wday)
>> +{
>> +       return 1 << wday;
>> +}
>> +
>> +static void data_to_tm(u8 *data, struct rtc_time *tm)
>> +{
>> +       tm->tm_sec = bcd2bin(data[RTC_SEC] & 0x7f);
>> +       tm->tm_min = bcd2bin(data[RTC_MIN] & 0x7f);
>> +       tm->tm_hour = bcd2bin(data[RTC_HOUR] & 0x3f);    /* 24 hour mode */
>> +       tm->tm_wday = wday_8997_to_kernel(data[RTC_WEEKDAY] & 0x7f);
>> +       tm->tm_mon = bcd2bin(data[RTC_MONTH] & 0x1f) - 1;
>> +       tm->tm_year = bcd2bin(data[RTC_YEAR] & 0x7f) + 100;     /* From 2000 */
>> +       tm->tm_mday = bcd2bin(data[RTC_MONTHDAY] & 0x3f);
>> +       tm->tm_yday = 0;
>> +       tm->tm_isdst = 0;
>> +}
>> +
>> +static void tm_to_data(struct rtc_time *tm, u8 *data)
>> +{
>> +       data[RTC_SEC] = bin2bcd(tm->tm_sec) & 0x7f;
>> +       data[RTC_MIN] = bin2bcd(tm->tm_min) & 0x7f;
>> +       data[RTC_HOUR] = bin2bcd(tm->tm_hour) & 0x3f;
>> +       data[RTC_WEEKDAY] = wday_kernel_to_8997(tm->tm_wday) & 0x7f;
>> +       data[RTC_MONTH] = bin2bcd(tm->tm_mon + 1) & 0x1f;
>> +       data[RTC_YEAR] = bin2bcd((tm->tm_year > 100) ?
>> +                                        tm->tm_year - 100 : 0) & 0x7f;
>> +       data[RTC_MONTHDAY] = bin2bcd(tm->tm_mday) & 0x3f;
>> +
>> +       if (tm->tm_year < 100) /* Prior 2000 */
>> +               pr_warn("MAX8997 RTC cannot handle the year %d.
>> +                       Assume it's 2000.\n", 1899 + tm->tm_year);
>> +}
>> +
>> +static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
>> +{
>> +       struct rtc_data *rtc = dev_get_drvdata(dev);
>> +       u8 data[RTC_DATA_SIZE];
>> +       int ret;
>> +
>> +       mutex_lock(&rtc->lock);
>> +       ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_SEC,
>> +                               RTC_DATA_SIZE, data);
>> +       mutex_unlock(&rtc->lock);
>> +
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       data_to_tm(data, tm);
>> +
>> +       return rtc_valid_tm(tm);
>> +}
>> +
>> +static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
>> +{
>> +       struct rtc_data *rtc = dev_get_drvdata(dev);
>> +       u8 data[RTC_DATA_SIZE];
>> +       int ret;
>> +
>> +       tm_to_data(tm, data);
>> +
>> +       mutex_lock(&rtc->lock);
>> +
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1, 0x03);
>> +
>> +       ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_SEC,
>> +                               RTC_DATA_SIZE, data);
>> +
>> +       if (rtc->delay)
>> +               msleep(20);
>> +
>> +       mutex_unlock(&rtc->lock);
>> +
>> +       return ret;
>> +}
>> +
>> +static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm
>> *alrm)
>> +{
>> +       struct rtc_data *rtc = dev_get_drvdata(dev);
>> +       u8 data[RTC_DATA_SIZE];
>> +       u8 val;
>> +       int i;
>> +       int ret;
>> +
>> +       mutex_lock(&rtc->lock);
>> +       ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
>> +                                RTC_DATA_SIZE, data);
>> +
>> +       if (ret < 0)
>> +               goto exit;
>> +
>> +       data_to_tm(data, &alrm->time);
>> +
>> +       alrm->enabled = 0;
>> +       for (i = 0; i < RTC_DATA_SIZE; i++)
>> +               if (data[i] & (1 << 7)) {
>> +                       alrm->enabled = 1;
>> +                       break;
>> +               }
>> +
>> +       alrm->pending = 0;
>> +       ret = max8997_read_reg(rtc->iodev->i2c, MAX8997_REG_STATUS1, &val);
>> +       if (val & (1 << 4)) /* "RTCA1" */
>> +               alrm->pending = 1;
>> +exit:
>> +       mutex_unlock(&rtc->lock);
>> +       return ret;
>> +}
>> +
>> +static int max8997_rtc_start_alarm(struct rtc_data *rtc)
>> +{
>> +       u8 data[RTC_DATA_SIZE];
>> +       int ret;
>> +
>> +       /* Should be locked before entering here */
>> +       if (!mutex_is_locked(&rtc->lock))
>> +               dev_warn(rtc->dev, "%s should have mutex locked.\n", __func__);
>> +
>> +       ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
>> +                               RTC_DATA_SIZE, data);
>> +       if (rtc < 0)
>> +               goto exit;
>> +
>> +       data[RTC_SEC] |= (1 << 7);
>> +       data[RTC_MIN] |= (1 << 7);
>> +       data[RTC_HOUR] |= (1 << 7);
>> +       data[RTC_WEEKDAY] &= ~(1 << 7);
>> +       if (data[RTC_MONTH] & 0x1f)
>> +               data[RTC_MONTH] |= (1 << 7);
>> +       if (data[RTC_YEAR] & 0x7f)
>> +               data[RTC_YEAR] |= (1 << 7);
>> +       if (data[RTC_MONTHDAY] & 0x3f)
>> +               data[RTC_MONTHDAY] |= (1 << 7);
>> +
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1, 0x03);
>> +       ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
>> +                               RTC_DATA_SIZE, data);
>> +       if (ret < 0)
>> +               goto exit;
>> +       if (rtc->delay)
>> +               msleep(20);
>> +
>> +exit:
>> +       return ret;
>> +}
>> +
>> +static int max8997_rtc_stop_alarm(struct rtc_data *rtc)
>> +{
>> +       u8 data[RTC_DATA_SIZE];
>> +       int ret;
>> +       int i;
>> +
>> +       /* Should be locked before entering here */
>> +       if (!mutex_is_locked(&rtc->lock))
>> +               dev_warn(rtc->dev, "%s should have mutex locked.\n", __func__);
>> +
>> +       ret = max8997_bulk_read(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
>> +                               RTC_DATA_SIZE, data);
>> +       if (rtc < 0)
>> +               goto exit;
>> +
>> +       for (i = 0; i < RTC_DATA_SIZE; i++)
>> +               data[i] &= ~(1 << 7);
>> +
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1, 0x03);
>> +       ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
>> +                                RTC_DATA_SIZE, data);
>> +       if (ret < 0)
>> +               goto exit;
>> +       if (rtc->delay)
>> +               msleep(20);
>> +
>> +exit:
>> +       return ret;
>> +}
>> +
>> +static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm
>> *alrm)
>> +{
>> +       struct rtc_data *rtc = dev_get_drvdata(dev);
>> +       u8 data[RTC_DATA_SIZE];
>> +       int ret = 0;
>> +
>> +       tm_to_data(&alrm->time, data);
>> +
>> +       mutex_lock(&rtc->lock);
>> +       ret = max8997_rtc_stop_alarm(rtc);
>> +       if (ret < 0)
>> +               goto exit;
>> +
>> +       if (alrm->enabled) {
>> +               data[RTC_SEC] |= (1 << 7);
>> +               data[RTC_MIN] |= (1 << 7);
>> +               data[RTC_HOUR] |= (1 << 7);
>> +               data[RTC_WEEKDAY] &= ~(1 << 7);
>> +               if (data[RTC_MONTH] & 0x1f)
>> +                       data[RTC_MONTH] |= (1 << 7);
>> +               if (data[RTC_YEAR] & 0x7f)
>> +                       data[RTC_YEAR] |= (1 << 7);
>> +               if (data[RTC_MONTHDAY] & 0x3f)
>> +                       data[RTC_MONTHDAY] |= (1 << 7);
>> +       }
>> +
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1, 0x03);
>> +       ret = max8997_bulk_write(rtc->i2c, MAX8997_RTC_ALARM1_SEC,
>> +                               RTC_DATA_SIZE, data);
>> +       if (ret < 0)
>> +               goto exit;
>> +       if (rtc->delay)
>> +               msleep(20);
>> +
>> +exit:
>> +       mutex_unlock(&rtc->lock);
>> +       return ret;
>> +}
>> +
>> +static int max8997_rtc_alarm_irq_enable(struct device *dev,
>> +                                        unsigned int enabled)
>> +{
>> +       struct rtc_data *rtc = dev_get_drvdata(dev);
>> +       int ret;
>> +
>> +       mutex_lock(&rtc->lock);
>> +       if (enabled)
>> +               ret = max8997_rtc_start_alarm(rtc);
>> +       else
>> +               ret = max8997_rtc_stop_alarm(rtc);
>> +       mutex_unlock(&rtc->lock);
>> +
>> +       return ret;
>> +}
>> +
>> +static irqreturn_t max8997_rtc_alarm_irq(int irq, void *data)
>> +{
>> +       struct rtc_data *rtc = data;
>> +
>> +       rtc_update_irq(rtc->rtc_dev, 1, RTC_IRQF | RTC_AF);
>> +
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static const struct rtc_class_ops max8997_rtc_ops = {
>> +       .read_time              = max8997_rtc_read_time,
>> +       .set_time               = max8997_rtc_set_time,
>> +       .read_alarm             = max8997_rtc_read_alarm,
>> +       .set_alarm              = max8997_rtc_set_alarm,
>> +       .alarm_irq_enable       = max8997_rtc_alarm_irq_enable,
>> +};
>> +
>> +static __devinit int rtc_probe(struct platform_device *pdev)
>> +{
>> +       struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>> +       struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
>> +       struct rtc_data *rtc;
>> +       int ret = 0;
>> +       u8 val;
>> +
>> +       if (!pdata) {
>> +               dev_err(pdev->dev.parent, "No platform init data supplied.\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       rtc = kzalloc(sizeof(struct rtc_data), GFP_KERNEL);
>> +       if (!rtc)
>> +               return -ENOMEM;
>> +
>> +       mutex_init(&rtc->lock);
>> +       mutex_lock(&rtc->lock);
>> +       rtc->i2c = iodev->rtc;
>> +       rtc->dev = &pdev->dev;
>> +       rtc->iodev = iodev;
>> +       rtc->irq = iodev->irq_base + MAX8997_PMICIRQ_RTCA1;
>> +
>> +       if (pdata->delay)
>> +               rtc->delay = true;
>> +
>> +       platform_set_drvdata(pdev, rtc);
>> +
>> +       /* Allow update setting */
>> +       val = 0x03;
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_CTRLMASK, val);
>> +       /* 24 hour | BCD */
>> +       val = (1 << 1) | (1 << 0);
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_CTRL, val);
>> +       /* Allow RTC Update */
>> +       val = 0x03;
>> +       max8997_write_reg(rtc->i2c, MAX8997_RTC_UPDATE1, val);
>> +
>> +       if (pdata->wakeup)
>> +               device_init_wakeup(&pdev->dev, 1);
>> +
>> +       rtc->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
>> +                       &max8997_rtc_ops, THIS_MODULE);
>> +       if (IS_ERR_OR_NULL(rtc->rtc_dev)) {
>> +               ret = PTR_ERR(rtc->rtc_dev);
>> +
>> +               dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
>> +               if (ret == 0)
>> +                       ret = -EINVAL;
>> +               goto err;
>> +       }
>> +
>> +       ret = request_threaded_irq(rtc->irq, NULL, max8997_rtc_alarm_irq, 0,
>> +                       "max8997-rtc-alarm1", rtc);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "Failed to request alarm IRQ %d (%d)\n",
>> +                               rtc->irq, ret);
>> +               goto err;
>> +       }
>> +
>> +       goto exit;
>> +err:
>> +       kfree(rtc);
>> +exit:
>> +       mutex_unlock(&rtc->lock);
>> +       return ret;
>> +}
>> +
>> +static __devexit int rtc_remove(struct platform_device *pdev)
>> +{
>> +       struct rtc_data *rtc = platform_get_drvdata(pdev);
>> +
>> +       rtc_device_unregister(rtc->rtc_dev);
>> +       free_irq(rtc->irq, rtc);
>> +       kfree(rtc);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct platform_device_id rtc_id[] = {
>> +       { "max8997-rtc", 0 },
>> +       { },
>> +};
>> +
>> +static struct platform_driver max8997_rtc_driver = {
>> +       .driver = {
>> +               .name = "max8997-rtc",
>> +               .owner = THIS_MODULE,
>> +       },
>> +       .probe = rtc_probe,
>> +       .remove = __devexit_p(rtc_remove),
>> +       .id_table = rtc_id,
>> +};
>> +
>> +static int __init max8997_rtc_init(void)
>> +{
>> +       return platform_driver_register(&max8997_rtc_driver);
>> +}
>> +subsys_initcall(max8997_rtc_init);
>> +
>> +static void __exit max8997_rtc_cleanup(void)
>> +{
>> +       platform_driver_unregister(&max8997_rtc_driver);
>> +}
>> +module_exit(max8997_rtc_cleanup);
>> +
>> +MODULE_DESCRIPTION("MAXIM 8997/8966 RTC Driver");
>> +MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> +
>> diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
>> index 28726dd..52bc142 100644
>> --- a/include/linux/mfd/max8997.h
>> +++ b/include/linux/mfd/max8997.h
>> @@ -245,6 +245,7 @@ struct max8997_platform_data {
>>        struct max8997_haptic_platform_data *haptic_pdata;
>>
>>        /* RTC: Not implemented */
>> +       bool delay; /* The MAX8997 RTC write delay is required. */
>>        /* ---- LED ---- */
>>        struct max8997_led_platform_data *led_pdata;
>>  };
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0KLMx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:53:57 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1081 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757474Ab0KLMxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:53:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8949
Message-ID: <4CDD38CE.1000902@metafoo.de>
Date: Fri, 12 Nov 2010 13:53:34 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [RFC v1 PATCH 6/6] drivers: rtc: Add support for Qualcomm PMIC8058
 RTC
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-7-git-send-email-tsoni@codeaurora.org>
In-Reply-To: <1289393281-4459-7-git-send-email-tsoni@codeaurora.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trilok Soni wrote:
> From: Anirudh Ghayal <aghayal@codeaurora.org>
> 
> PMIC8058 is Qualcomm's power management IC. A
> 32-bit RTC is housed inside this PMIC. The RTC driver
> uses SSBI to communicate with the RTC module.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
> ---
>  drivers/rtc/Kconfig            |    9 +
>  drivers/rtc/Makefile           |    1 +
>  drivers/rtc/rtc-pm8058.c       |  487 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/rtc/rtc-pm8058.h |   29 +++
>  4 files changed, 526 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-pm8058.c
>  create mode 100644 include/linux/rtc/rtc-pm8058.h
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 2883428..9f4ea00 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -665,6 +665,15 @@ config RTC_DRV_NUC900
>  	  If you say yes here you get support for the RTC subsystem of the
>  	  NUC910/NUC920 used in embedded systems.
>  
> +config RTC_DRV_PM8058
> +	tristate "Qualcomm PMIC8058 RTC"
> +	depends on PMIC8058
> +	help
> +	  Say Y here if you want to support the Qualcomm PMIC8058 RTC.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called pmic8058-rtc.
> +
>  comment "on-CPU RTC drivers"
>  
>  config RTC_DRV_DAVINCI
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 4c2832d..d7a4f7d 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -73,6 +73,7 @@ obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
>  obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
>  obj-$(CONFIG_RTC_DRV_PCF2123)	+= rtc-pcf2123.o
>  obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
> +obj-$(CONFIG_RTC_DRV_PM8058)	+= rtc-pm8058.o
>  obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
>  obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
>  obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
> diff --git a/drivers/rtc/rtc-pm8058.c b/drivers/rtc/rtc-pm8058.c
> new file mode 100644
> index 0000000..9fef82d
> --- /dev/null
> +++ b/drivers/rtc/rtc-pm8058.c
> @@ -0,0 +1,487 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/rtc.h>
> +#include <linux/mfd/pmic8058.h>
> +#include <linux/pm.h>
> +#include <linux/slab.h>
> +#include <linux/rtc/rtc-pm8058.h>
> +
> +/* RTC control registers */
> +#define PM8058_RTC_CTRL		0x1E8
> +#define PM8058_RTC_ALARM_CTRL	0x1E9
> +#define PM8058_RTC_TEST		0x1F6
> +
> +/* RTC register bases */
> +#define PM8058_RTC_READ_BASE	0x1EE
> +#define PM8058_RTC_WRITE_BASE	0x1EA
> +#define PM8058_RTC_ALARM_BASE	0x1F2
> +
> +/* RTC_CTRL register bit fields */
> +#define PM8058_RTC_ENABLE	BIT(7)
> +#define PM8058_RTC_ALARM_ENABLE	BIT(1)

Are there other bits in the ctrl register which are not touch by this driver?
If not you could turn the read-modify-write operations changing the ctrl register
into simple writes.

> +
> +#define NUM_8_BIT_RTC_REGS	0x4
> +
> +/**
> + * struct pm8058_rtc - rtc driver internal structure
> + * @rtc0 - rtc device for this driver
> + * @rtc_irq - rtc irq number
> + * @rtc_alarm_irq - rtc alarm irq number
> + * @pm_chip - pointer to pm8058 parent structure
> + */
> +struct pm8058_rtc {
> +	struct rtc_device *rtc0;
Is there a reason for the '0'?
> +	int rtc_irq;
> +	int rtc_alarm_irq;
> +	struct pm8058_chip *pm_chip;
> +};
> +
> +static int
> +pm8058_rtc_read_bytes(struct pm8058_rtc *rtc_dd, u8 *rtc_val, int base)
> +{
> +	int i, rc;
> +
> +	/* Read the 32-bit register value, 8 bits at a time. */
> +	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
> +		rc = pm8058_read(rtc_dd->pm_chip, base + i, &rtc_val[i], 1);
> +		if (rc < 0) {
> +			pr_err("PM8058 read failed\n");
> +			return rc;
> +		}
> +	}
Hm, I don't know the hardware, but I would assume that
pm8058_read(rtc_dd->pm_chip, base, rtc_val, NUM_8_BIT_RTC_REGS) should work as well.
> +
> +	return 0;
> +}
> +
> +static int
> +pm8058_rtc_write_bytes(struct pm8058_rtc *rtc_dd, u8 *rtc_val, int base)
> +{
> +	int i, rc;
> +
> +	/* Write the 32-bit register value, 8 bits at a time. */
> +	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
> +		rc = pm8058_write(rtc_dd->pm_chip, base + i, &rtc_val[i], 1);
> +		if (rc < 0) {
> +			pr_err("PM8058 read failed\n");
> +			return rc;
> +		}
> +	}
> +
Same here
> +	return 0;
> +}
> +
> +/*
> + * Steps to write the RTC registers.
> + * 1. Disable alarm if enabled.
> + * 2. Write 0x00 to LSB.
> + * 3. Write Byte[1], Byte[2], Byte[3] then Byte[0].
> + * 4. Enable alarm if disabled in step 1.
> + */
> +static int
> +pm8058_rtc0_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +	int rc;
> +	unsigned long secs = 0;
> +	u8 value[4], reg = 0, alarm_enabled = 0, ctrl_reg = 0, i;
> +	struct pm8058_rtc *rtc_dd = dev_get_drvdata(dev);
> +
> +	rtc_tm_to_time(tm, &secs);
> +
> +	value[0] = secs & 0xFF;
> +	value[1] = (secs >> 8) & 0xFF;
> +	value[2] = (secs >> 16) & 0xFF;
> +	value[3] = (secs >> 24) & 0xFF;
> +
> +	pr_debug("Seconds value to be written to RTC = %lu\n", secs);
> +
> +	/* Disable alarm before updating RTC */
> +	rc = pm8058_read(rtc_dd->pm_chip, PM8058_RTC_CTRL, &ctrl_reg, 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 read failed\n");
dev_err instead of pr_err. The other pr_err should also be replaced.
> +		return rc;
> +	}
> +
> +	if (ctrl_reg & PM8058_RTC_ALARM_ENABLE) {
> +		alarm_enabled = 1;
> +		ctrl_reg &= ~PM8058_RTC_ALARM_ENABLE;
> +		rc = pm8058_write(rtc_dd->pm_chip, PM8058_RTC_CTRL,
> +							&ctrl_reg, 1);
> +		if (rc < 0) {
> +			pr_err("PM8058 write failed\n");
> +			return rc;
> +		}
> +	}
> +
> +	/* Write Byte[1], Byte[2], Byte[3], Byte[0] */
> +	reg = 0;
> +	rc = pm8058_write(rtc_dd->pm_chip, PM8058_RTC_WRITE_BASE, &reg, 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 write failed\n");
> +		return rc;
> +	}
> +
> +	for (i = 1; i < NUM_8_BIT_RTC_REGS; i++) {
> +		rc = pm8058_write(rtc_dd->pm_chip, PM8058_RTC_WRITE_BASE + i,
> +								&value[i], 1);
> +		if (rc < 0) {
> +			pr_err("Write to RTC registers failed\n");
> +			return rc;
> +		}
> +	}
> +
> +	rc = pm8058_write(rtc_dd->pm_chip, PM8058_RTC_WRITE_BASE,
> +							&value[0], 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 write failed\n");
> +		return rc;
> +	}
> +
> +	if (alarm_enabled) {
> +		ctrl_reg |= PM8058_RTC_ALARM_ENABLE;
> +		rc = pm8058_write(rtc_dd->pm_chip, PM8058_RTC_CTRL,
> +							&ctrl_reg, 1);
> +		if (rc < 0) {
> +			pr_err("PM8058 write failed\n");
> +			return rc;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +pm8058_rtc0_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	int rc;
> +	u8 value[4], reg;
> +	unsigned long secs = 0;
> +	struct pm8058_rtc *rtc_dd = dev_get_drvdata(dev);
> +
> +	rc = pm8058_rtc_read_bytes(rtc_dd, value, PM8058_RTC_READ_BASE);
> +	if (rc < 0) {
> +		pr_err("RTC time read failed\n");
> +		return rc;
> +	}
> +
> +	/*
> +	 * Read the LSB again and check if there has been a carry over.
> +	 * If there is, redo the read operation.
> +	 */
> +	rc = pm8058_read(rtc_dd->pm_chip, PM8058_RTC_READ_BASE, &reg, 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 read failed\n");
> +		return rc;
> +	}
> +
> +	if (unlikely(reg < value[0])) {
> +		rc = pm8058_rtc_read_bytes(rtc_dd, value,
> +						PM8058_RTC_READ_BASE);
> +		if (rc < 0) {
> +			pr_err("RTC time read failed\n");
> +			return rc;
> +		}
> +	}
> +
> +	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
> +
> +	rtc_time_to_tm(secs, tm);
> +
> +	rc = rtc_valid_tm(tm);
> +	if (rc < 0) {
> +		pr_err("Invalid time read from PMIC8058\n");
> +		return rc;
> +	}
> +
> +	pr_debug("secs = %lu, h::m:s == %d::%d::%d, d/m/y = %d/%d/%d\n",
> +			secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
> +			tm->tm_mday, tm->tm_mon, tm->tm_year);
> +
> +	return 0;
> +}
> +
> +static int
> +pm8058_rtc0_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +	int rc;
> +	u8 value[4], reg;
> +	unsigned long secs = 0;
No need to initialize secs here.
> +	struct pm8058_rtc *rtc_dd = dev_get_drvdata(dev);
> +
> +	/* Check if a alarm is valid */
> +	rc = rtc_valid_tm(&alarm->time);
> +	if (rc < 0) {
> +		pr_err("Alarm time invalid\n");
> +		return -EINVAL;
> +	}
The upper layer will already check if alarm->time is valid, so there is no need to
check it here again.
> +
> +	rtc_tm_to_time(&alarm->time, &secs);
> +
> +	value[0] = secs & 0xFF;
> +	value[1] = (secs >> 8) & 0xFF;
> +	value[2] = (secs >> 16) & 0xFF;
> +	value[3] = (secs >> 24) & 0xFF;
> +
> +	rc = pm8058_rtc_write_bytes(rtc_dd, value, PM8058_RTC_ALARM_BASE);
> +	if (rc < 0) {
> +		pr_err("Alarm could not be set\n");
> +		return rc;
> +	}
> +
> +	rc = pm8058_read(rtc_dd->pm_chip, PM8058_RTC_CTRL, &reg, 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 read failed\n");
> +		return rc;
> +	}
> +
> +	reg = (alarm->enabled) ? (reg | PM8058_RTC_ALARM_ENABLE) :
> +					(reg & ~PM8058_RTC_ALARM_ENABLE);
> +
> +	rc = pm8058_write(rtc_dd->pm_chip, PM8058_RTC_CTRL, &reg, 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 write failed\n");
> +		return rc;
> +	}
> +
> +	pr_debug("Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
> +			alarm->time.tm_hour, alarm->time.tm_min,
> +			alarm->time.tm_sec, alarm->time.tm_mday,
> +			alarm->time.tm_mon, alarm->time.tm_year);
> +
> +	return 0;
> +}
> +
> +static int
> +pm8058_rtc0_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +	int rc;
> +	u8 value[4], reg;
> +	unsigned long secs = 0;
No need to initialize secs here.
> +	struct pm8058_rtc *rtc_dd = dev_get_drvdata(dev);
> +
> +	/* Check if the alarm is enabled */
> +	rc = pm8058_read(rtc_dd->pm_chip, PM8058_RTC_CTRL, &reg, 1);
> +	if (rc < 0) {
> +		pr_err("PM8058 read failed\n");
> +		return rc;
> +	}
> +	alarm->enabled = !!(reg & PM8058_RTC_ALARM_ENABLE);
> +
> +	rc = pm8058_rtc_read_bytes(rtc_dd, value,
> +					PM8058_RTC_ALARM_BASE);
> +	if (rc < 0) {
> +		pr_err("RTC alarm time read failed\n");
> +		return rc;
> +	}
> +
> +	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
> +
> +	rtc_time_to_tm(secs, &alarm->time);
> +
> +	rc = rtc_valid_tm(&alarm->time);
> +	if (rc < 0) {
> +		pr_err("Invalid time read from PMIC8058\n");
> +		return rc;
> +	}
> +
> +	pr_debug("Alarm set for - h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
> +		alarm->time.tm_hour, alarm->time.tm_min,
> +				alarm->time.tm_sec, alarm->time.tm_mday,
> +				alarm->time.tm_mon, alarm->time.tm_year);
> +
> +	return 0;
> +}
> +
> +static struct rtc_class_ops pm8058_rtc0_ops = {
> +	.read_time	= pm8058_rtc0_read_time,
> +	.set_alarm	= pm8058_rtc0_set_alarm,
> +	.read_alarm	= pm8058_rtc0_read_alarm,

Implementig alarm_irq_enable might be a good idea

> +};
> +
> +static irqreturn_t pm8058_alarm_trigger(int irq, void *dev_id)
> +{
> +	unsigned long events = 0;
> +	struct pm8058_rtc *rtc_dd = dev_id;
> +
> +	events = RTC_IRQF | RTC_AF;
> +	rtc_update_irq(rtc_dd->rtc0, 1, events);

just rtc_update_irq(rtc_dd->rtc0, 1, RTC_IRQF | RTC_AF); should be fine

> +
> +	pr_debug("Alarm Triggered !!\n");
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit pm8058_rtc_probe(struct platform_device *pdev)
> +{
> +	int rc;
> +	u8 reg;
> +	struct pm8058_rtc *rtc_dd;
> +	struct pm8058_chip *pm_chip;
> +	struct pm8058_rtc_pdata *pdata = pdev->dev.platform_data;
> +
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "Platform data absent!\n");
> +		return -ENXIO;
> +	}
It might be a good idea to assume a default for rtc_write_enable if pdata is not set.
> +
> +	pm_chip = platform_get_drvdata(pdev);
> +	if (pm_chip == NULL) {
> +		dev_err(&pdev->dev, "Invalid driver information!\n");
> +		return -ENXIO;
> +	}
> +
> +	rtc_dd = kzalloc(sizeof(*rtc_dd), GFP_KERNEL);
> +	if (rtc_dd == NULL) {
> +		dev_err(&pdev->dev, "Unable to allocate memory!\n");
> +		return -ENOMEM;
> +	}
> +
> +	rtc_dd->rtc_irq = platform_get_irq(pdev, 0);
You don't seem to use this irq.

> +	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 1);
> +	if (!rtc_dd->rtc_alarm_irq || !rtc_dd->rtc_irq) {
> +		dev_err(&pdev->dev, "RTC / Alarm IRQ resource absent!\n");
> +		rc = -ENXIO;
> +		goto fail_rtc_enable;
> +	}
> +
> +	rtc_dd->pm_chip = pm_chip;
> +
> +	/* Check if the RTC is on, else turn it on */
> +	rc = pm8058_read(pm_chip, PM8058_RTC_CTRL, &reg, 1);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "PM8058 read failed!\n");
> +		goto fail_rtc_enable;
> +	}
> +
> +	if (!(reg & PM8058_RTC_ENABLE)) {
> +		reg |= PM8058_RTC_ENABLE;
> +		rc = pm8058_write(pm_chip, PM8058_RTC_CTRL, &reg, 1);
> +		if (rc < 0) {
> +			dev_err(&pdev->dev, "PM8058 write failed!\n");
> +			goto fail_rtc_enable;
> +		}
> +	}
> +
> +	if (pdata->rtc_write_enable == true)
> +		pm8058_rtc0_ops.set_time = pm8058_rtc0_set_time,
> +
> +	/* Register the RTC device */
> +	rtc_dd->rtc0 = rtc_device_register("pm8058_rtc0", &pdev->dev,
> +				&pm8058_rtc0_ops, THIS_MODULE);
> +	if (IS_ERR(rtc_dd->rtc0)) {
> +		dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
> +					__func__, PTR_ERR(rtc_dd->rtc0));
> +		rc = PTR_ERR(rtc_dd->rtc0);
> +		goto fail_rtc_enable;
> +	}
> +
> +	platform_set_drvdata(pdev, rtc_dd);
> +
> +	/* Request the alarm IRQ */
> +	rc = request_any_context_irq(rtc_dd->rtc_alarm_irq,
> +				 pm8058_alarm_trigger, IRQF_TRIGGER_RISING,
> +				 "pm8058_rtc_alarm", rtc_dd);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
> +		goto fail_req_irq;
> +	}
> +
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	dev_dbg(&pdev->dev, "Probe success !!\n");
> +
> +	return 0;
> +
> +fail_req_irq:
> +	rtc_device_unregister(rtc_dd->rtc0);
> +fail_rtc_enable:
> +	kfree(rtc_dd);
> +	return rc;
> +}
> +
> +#ifdef CONFIG_PM
> +static int pm8058_rtc_resume(struct device *dev)
> +{
> +	struct pm8058_rtc *rtc_dd = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(rtc_dd->rtc_alarm_irq);
> +
> +	return 0;
> +}
> +
> +static int pm8058_rtc_suspend(struct device *dev)
> +{
> +	struct pm8058_rtc *rtc_dd = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(rtc_dd->rtc_alarm_irq);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops pm8058_rtc_pm_ops = {
> +	.suspend = pm8058_rtc_suspend,
> +	.resume = pm8058_rtc_resume,
> +};
> +#endif
> +
> +static int __devexit pm8058_rtc_remove(struct platform_device *pdev)
> +{
> +	struct pm8058_rtc *rtc_dd = platform_get_drvdata(pdev);
> +
> +	device_init_wakeup(&pdev->dev, 0);
> +	free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
> +	rtc_device_unregister(rtc_dd->rtc0);
> +	kfree(rtc_dd);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver pm8058_rtc_driver = {
> +	.probe		= pm8058_rtc_probe,
> +	.remove		= __devexit_p(pm8058_rtc_remove),
> +	.driver	= {
> +		.name	= "pm8058-rtc",
> +		.owner	= THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm	= &pm8058_rtc_pm_ops,
> +#endif
> +	},
> +};
> +
> +static int __init pm8058_rtc_init(void)
> +{
> +	return platform_driver_register(&pm8058_rtc_driver);
> +}
> +
> +static void __exit pm8058_rtc_exit(void)
> +{
> +	platform_driver_unregister(&pm8058_rtc_driver);
> +}
> +
> +module_init(pm8058_rtc_init);
> +module_exit(pm8058_rtc_exit);
module_{init,exit} should go right beneath the function they are referring to

> +
> +MODULE_ALIAS("platform:pm8058-rtc");
> +MODULE_DESCRIPTION("PMIC8058 RTC driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(Anirudh Ghayal "<aghayal@codeaurora.org>");
> diff --git a/include/linux/rtc/rtc-pm8058.h b/include/linux/rtc/rtc-pm8058.h
> new file mode 100644
> index 0000000..51f7c0b
> --- /dev/null
> +++ b/include/linux/rtc/rtc-pm8058.h
> @@ -0,0 +1,29 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +
> +#ifndef __RTC_PM8058_H__
> +#define __RTC_PM8058_H__
> +
> +/**
> + * struct pm8058_rtc_pdata - RTC driver platform data
> + * @rtc_write_enable - variable stating RTC write capability
> + */
> +struct pm8058_rtc_pdata {
> +	bool rtc_write_enable;
> +};
Is there a technical reason why changing the rtc clocks time should be disabled or is
this a policy based decision?
> +
> +#endif /* __RTC_PM8058_H__ */


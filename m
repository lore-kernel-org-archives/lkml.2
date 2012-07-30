Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2G3JRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:17:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7605 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2G3JRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:17:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6787"; a="215812303"
Message-ID: <5016510B.9010202@codeaurora.org>
Date: Mon, 30 Jul 2012 02:16:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: a.zummo@towertech.it, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, ldewangan@nvidia.com,
        kyle.manna@fuel7.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
References: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/2012 11:35 PM, Venu Byravarasu wrote:
> +
> +static struct rtc_class_ops tps65910_rtc_ops = {

const?

> +	.read_time	= tps65910_rtc_read_time,
> +	.set_time	= tps65910_rtc_set_time,
> +	.read_alarm	= tps65910_rtc_read_alarm,
> +	.set_alarm	= tps65910_rtc_set_alarm,
> +	.alarm_irq_enable = tps65910_rtc_alarm_irq_enable,
> +};
> +
> +static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
> +{
> +	struct tps65910 *tps65910 = NULL;
> +	struct tps65910_rtc *tps_rtc = NULL;
> +	struct tps65910_board *pmic_plat_data;
> +	int ret = -EINVAL;
> +	int irq = 0;
> +	u32 rtc_reg;

It seems like all the above assignments are useless as they're
overwritten later in this function. Can you remove the assignments?

> +
> +	tps65910 = dev_get_drvdata(pdev->dev.parent);
> +
> +	tps_rtc = devm_kzalloc(&pdev->dev, sizeof(struct tps65910_rtc),
> +			GFP_KERNEL);
> +	if (!tps_rtc)
> +		return -ENOMEM;
> +
> +	/* Clear pending interrupts */
> +	ret = regmap_read(tps65910->regmap, TPS65910_RTC_STATUS, &rtc_reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = regmap_write(tps65910->regmap, TPS65910_RTC_STATUS, rtc_reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(&pdev->dev, "Enabling tps65910-RTC.\n");

Hmph, looks more like stopping the RTC.

> +	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
> +	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL, rtc_reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	pmic_plat_data = dev_get_platdata(tps65910->dev);
> +	irq = pmic_plat_data->irq_base;
> +	if (irq <= 0) {
> +		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
> +			irq);
> +		return ret;
> +	}
> +
> +	irq += TPS65910_IRQ_RTC_ALARM;
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> +		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
> +		dev_name(&tps_rtc->rtc->dev), &pdev->dev);

How does this work? It doesn't look like tps_rtc->rtc is assigned until
down there at the rtc_device_register() call.

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "IRQ is not free.\n");
> +		return ret;
> +	}
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
> +		&tps65910_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(tps_rtc->rtc)) {
> +		ret = PTR_ERR(tps_rtc->rtc);
> +		dev_err(&pdev->dev, "RTC device register: err %d\n", ret);
> +		return ret;
> +	}
> +

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


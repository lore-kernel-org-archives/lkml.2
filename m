Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2G3KJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:09:06 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12019 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2G3KJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:09:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 30 Jul 2012 03:08:21 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jul 2012 15:37:18 +0530
Subject: RE: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Thread-Topic: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Thread-Index: Ac1uNCOPKlPC0BRFSru2AWGLufVdAAABYohg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDCAC4244@BGMAIL02.nvidia.com>
References: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
 <5016510B.9010202@codeaurora.org>
In-Reply-To: <5016510B.9010202@codeaurora.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen for your comments.
Plz see my comments inline.


> -----Original Message-----
> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> Sent: Monday, July 30, 2012 2:47 PM
> To: Venu Byravarasu
> Cc: a.zummo@towertech.it; sameo@linux.intel.com;
> broonie@opensource.wolfsonmicro.com; Laxman Dewangan;
> kyle.manna@fuel7.com; rtc-linux@googlegroups.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
> 
> On 7/25/2012 11:35 PM, Venu Byravarasu wrote:
> > +
> > +static struct rtc_class_ops tps65910_rtc_ops = {
> 
> const?

Will add it in my next patch. 

> 
> > +	.read_time	= tps65910_rtc_read_time,
> > +	.set_time	= tps65910_rtc_set_time,
> > +	.read_alarm	= tps65910_rtc_read_alarm,
> > +	.set_alarm	= tps65910_rtc_set_alarm,
> > +	.alarm_irq_enable = tps65910_rtc_alarm_irq_enable,
> > +};
> > +
> > +static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
> > +{
> > +	struct tps65910 *tps65910 = NULL;
> > +	struct tps65910_rtc *tps_rtc = NULL;
> > +	struct tps65910_board *pmic_plat_data;
> > +	int ret = -EINVAL;
> > +	int irq = 0;
> > +	u32 rtc_reg;
> 
> It seems like all the above assignments are useless as they're
> overwritten later in this function. Can you remove the assignments?
> 

Some of the non-intelligent compilers/tools complain as variables 
may get used uninitialized. Hence to avoid such complaints, initialized
them to some default values.
What harm do you see if I have local variables initialized during their declaration?

> > +
> > +	tps65910 = dev_get_drvdata(pdev->dev.parent);
> > +
> > +	tps_rtc = devm_kzalloc(&pdev->dev, sizeof(struct tps65910_rtc),
> > +			GFP_KERNEL);
> > +	if (!tps_rtc)
> > +		return -ENOMEM;
> > +
> > +	/* Clear pending interrupts */
> > +	ret = regmap_read(tps65910->regmap, TPS65910_RTC_STATUS,
> &rtc_reg);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = regmap_write(tps65910->regmap, TPS65910_RTC_STATUS,
> rtc_reg);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	dev_dbg(&pdev->dev, "Enabling tps65910-RTC.\n");
> 
> Hmph, looks more like stopping the RTC.
> 

No, the register is a misnomer here.
As per data sheet of TPS65910, setting this bit will start RTC, 
instead of stopping as its name suggests.
 

> > +	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
> > +	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL,
> rtc_reg);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	pmic_plat_data = dev_get_platdata(tps65910->dev);
> > +	irq = pmic_plat_data->irq_base;
> > +	if (irq <= 0) {
> > +		dev_warn(&pdev->dev, "Wake up is not possible as irq =
> %d\n",
> > +			irq);
> > +		return ret;
> > +	}
> > +
> > +	irq += TPS65910_IRQ_RTC_ALARM;
> > +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> > +		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
> > +		dev_name(&tps_rtc->rtc->dev), &pdev->dev);
> 
> How does this work? It doesn't look like tps_rtc->rtc is assigned until
> down there at the rtc_device_register() call.
> 

Somehow this got skipped. Thanks for pointing out.
Will fix and push as part of next patch.
 

> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "IRQ is not free.\n");
> > +		return ret;
> > +	}
> > +	device_init_wakeup(&pdev->dev, 1);
> > +
> > +	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
> > +		&tps65910_rtc_ops, THIS_MODULE);
> > +	if (IS_ERR(tps_rtc->rtc)) {
> > +		ret = PTR_ERR(tps_rtc->rtc);
> > +		dev_err(&pdev->dev, "RTC device register: err %d\n", ret);
> > +		return ret;
> > +	}
> > +
> 
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum.


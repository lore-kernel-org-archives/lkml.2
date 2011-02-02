Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1BBIyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:54:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34595 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1BBIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:54:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6244"; a="72891579"
Message-ID: <4D491BA5.5080107@codeaurora.org>
Date: Wed, 02 Feb 2011 14:23:57 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Anirudh Ghayal <aghayal@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Amy Maloche <amaloche@codeaurora.org>,
        Mohan Pallaka <mpallaka@codeaurora.org>
Subject: Re: [RFC v2 PATCH 7/7] input: misc: Add support for PM8058 based
 vibrator driver
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org> <1296568063-12010-8-git-send-email-aghayal@codeaurora.org> <20110202083315.GA23573@core.coreip.homeip.net>
In-Reply-To: <20110202083315.GA23573@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 2/2/2011 2:03 PM, Dmitry Torokhov wrote:
> Hi Anirudh,
> 
> On Tue, Feb 01, 2011 at 07:17:43PM +0530, Anirudh Ghayal wrote:
>> +
>> +#include <linux/mfd/pmic8058.h>
>> +#include <linux/input/pmic8058-vibrator.h>
> 
> Where is this header file? Shouldn't it be part of this patch?

Looks like someone forgot "git add" on it. We will fix this in v3.

> 
>> +
>> +#define VIB_DRV			0x4A
>> +
>> +#define VIB_DRV_SEL_MASK	0xf8
>> +#define VIB_DRV_SEL_SHIFT	0x03
>> +#define VIB_DRV_EN_MANUAL_MASK	0xfc
>> +
>> +#define VIB_MAX_LEVEL_mV	(3100)
>> +#define VIB_MIN_LEVEL_mV	(1200)
>> +#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
>> +
>> +#define MAX_FF_SPEED		0xff
>> +
>> +/*
>> + * struct pmic8058_vib - structure to hold vibrator data
>> + * vib_input_dev: input device supporting force feedback
>> + * work: work structure to set the vibration parameters
>> + * dev: device supporting force feedback
>> + * pdata: platform data
>> + * pm_chip: reference to pmic chip to carry out read/write operations
>> + * speed: speed of vibration set from userland
>> + * state: state of vibrator
>> + * level: level of vibration to set in the chip
>> + * reg_vib_drv: VIB_DRV register value
> 
> Hmm, this is kind of kerneldoc but not quite (kerneldoc's arguments
> start with '@').

Ack. It will be fixed.

>> +
>> +static int __devinit pmic8058_vib_probe(struct platform_device *pdev)
>> +
>> +{
>> +	struct pm8058_chip *pm_chip;
>> +	struct pmic8058_vib *vib;
>> +	const struct pmic8058_vibrator_pdata *pdata = pdev->dev.platform_data;
>> +	int rc;
>> +	u8 val;
>> +
>> +	pm_chip = platform_get_drvdata(pdev);
> 
> The parent should not abuse platform data of _this_ device, it belongs
> to this driver. In fact you overwrite it with pmic8058_vib below, which
> means that you can't unbind the driver and bind it again.
> 
> Please find other way to pass pm_chip.

This will be fixed through pmic8058 core driver, when we submit. We are aware of it,
and the all the sub-device driver will be changed to do it properly once we release
them again with pmic core driver submission.

>> +
>> +	platform_set_drvdata(pdev, vib);
>> +
>> +	rc = input_register_device(vib->vib_input_dev);
>> +	if (rc < 0) {
>> +		dev_dbg(&pdev->dev, "couldn't register input device\n");
>> +		goto err_reg_input_dev;
>> +	}
> 
> platform_set_drvdata(pdev, vib) should go here so you do not need to
> clean it if input_register_device() fails.

Ack

>> +
>> +static int __devexit pmic8058_vib_remove(struct platform_device *pdev)
>> +{
>> +	struct pmic8058_vib *vib = platform_get_drvdata(pdev);
>> +
>> +	cancel_work_sync(&vib->work);
>> +	if (vib->state)
>> +		pmic8058_vib_set(vib, 0);
> 
> This should probably be part of pmic8058_vib_close() method.
> 

Ok. We will check and fix.

>> +
>> +	input_unregister_device(vib->vib_input_dev);
>> +	kfree(vib);
> 
> Need to call platform_set_drvdata(pdev, NULL);

Ack.

> 
> What about PM? Do you need to shut off vibration if device goes to sleep?

Yes. Let me check and add it to v3 patch series.

I will drop the PMIC8058 OTHC from v3 series, as Mark suggested to explore ASoC way of 
doing it.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

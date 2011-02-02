Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1BBIdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:33:24 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53626 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1BBIdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:33:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QZR5wWcnWv7v8FcUE4zFxNPj08X5Pkxbmz+Fc5U811DHab+KXCYUBWRuI9CX6u2Bv8
         4MnQCjgeRrbzBQNmTVteaek95JaK9nKWmup5rKihBNt3OqOzqJajezc82J9ZdKIkE+oT
         1j/9FJiTRW2oQagDfI3PWhI8OJIccJDyoWclI=
Date: Wed, 2 Feb 2011 00:33:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Amy Maloche <amaloche@codeaurora.org>,
        Mohan Pallaka <mpallaka@codeaurora.org>
Subject: Re: [RFC v2 PATCH 7/7] input: misc: Add support for PM8058 based
 vibrator driver
Message-ID: <20110202083315.GA23573@core.coreip.homeip.net>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
 <1296568063-12010-8-git-send-email-aghayal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296568063-12010-8-git-send-email-aghayal@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anirudh,

On Tue, Feb 01, 2011 at 07:17:43PM +0530, Anirudh Ghayal wrote:
> +
> +#include <linux/mfd/pmic8058.h>
> +#include <linux/input/pmic8058-vibrator.h>

Where is this header file? Shouldn't it be part of this patch?

> +
> +#define VIB_DRV			0x4A
> +
> +#define VIB_DRV_SEL_MASK	0xf8
> +#define VIB_DRV_SEL_SHIFT	0x03
> +#define VIB_DRV_EN_MANUAL_MASK	0xfc
> +
> +#define VIB_MAX_LEVEL_mV	(3100)
> +#define VIB_MIN_LEVEL_mV	(1200)
> +#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
> +
> +#define MAX_FF_SPEED		0xff
> +
> +/*
> + * struct pmic8058_vib - structure to hold vibrator data
> + * vib_input_dev: input device supporting force feedback
> + * work: work structure to set the vibration parameters
> + * dev: device supporting force feedback
> + * pdata: platform data
> + * pm_chip: reference to pmic chip to carry out read/write operations
> + * speed: speed of vibration set from userland
> + * state: state of vibrator
> + * level: level of vibration to set in the chip
> + * reg_vib_drv: VIB_DRV register value

Hmm, this is kind of kerneldoc but not quite (kerneldoc's arguments
start with '@').

> + *
> + */
> +struct pmic8058_vib {
> +	struct input_dev *vib_input_dev;
> +	struct work_struct work;
> +	struct device *dev;
> +	const struct pmic8058_vibrator_pdata *pdata;
> +	struct pm8058_chip	*pm_chip;
> +	int speed;
> +	int state;
> +	int level;
> +	u8  reg_vib_drv;
> +};
> +
> +/*
> + * pmic8058_vib_read_u8 - helper to read a byte from pmic chip
> + * vib: pointer to vibrator structure
> + * data: placeholder for data to be read
> + * reg: register address
> + *
> + */
> +static int pmic8058_vib_read_u8(struct pmic8058_vib *vib,
> +				 u8 *data, u16 reg)
> +{
> +	int rc;
> +
> +	rc = pm8058_read(vib->pm_chip, reg, data, 1);
> +	if (rc < 0)
> +		dev_warn(vib->dev, "Error reading pmic8058 reg 0x%x(0x%x)\n",
> +				reg, rc);
> +	return rc;
> +}
> +
> +/*
> + * pmic8058_vib_write_u8 - helper to write a byte to pmic chip
> + * vib: pointer to vibrator structure
> + * data: data to write
> + * reg: register address
> + *
> + */
> +static int pmic8058_vib_write_u8(struct pmic8058_vib *vib,
> +				 u8 data, u16 reg)
> +{
> +	int rc;
> +
> +	rc = pm8058_write(vib->pm_chip, reg, &data, 1);
> +	if (rc < 0)
> +		dev_warn(vib->dev, "Error writing pmic8058 reg 0x%x(0x%x)\n",
> +				reg, rc);
> +	return rc;
> +}
> +
> +/*
> + * pmic8058_vib_set - handler to start/stop vibration
> + * vib: pointer to vibrator structure
> + * on: state to set
> + *
> + */
> +static int pmic8058_vib_set(struct pmic8058_vib *vib, int on)
> +{
> +	int rc;
> +	u8 val;
> +
> +	val = vib->reg_vib_drv;
> +
> +	if (on)
> +		val |= ((vib->level << VIB_DRV_SEL_SHIFT) & VIB_DRV_SEL_MASK);
> +	else
> +		val &= ~VIB_DRV_SEL_MASK;
> +
> +	rc = pmic8058_vib_write_u8(vib, val, VIB_DRV);
> +	if (rc < 0)
> +		return rc;
> +
> +	vib->reg_vib_drv = val;
> +	return rc;
> +}
> +
> +/*
> + * pmic8058_work_handler - worker to set vibration level
> + * work: pointer to work_struct
> + *
> + */
> +static void pmic8058_work_handler(struct work_struct *work)
> +{
> +	struct pmic8058_vib *vib;
> +	int rc;
> +	u8 val;
> +
> +	vib  = container_of(work, struct pmic8058_vib, work);
> +
> +	rc = pmic8058_vib_read_u8(vib, &val, VIB_DRV);
> +	if (rc < 0)
> +		return;
> +
> +	/*
> +	 * pmic vibrator supports voltage ranges from 1.2 to 3.1V, so
> +	 * scale the level to fit into these ranges.
> +	 */
> +	if (vib->speed) {
> +		vib->state = 1;
> +		vib->level = ((VIB_MAX_LEVELS * vib->speed) / MAX_FF_SPEED) +
> +						VIB_MIN_LEVEL_mV;
> +		vib->level /= 100;
> +	} else {
> +		vib->state = 0;
> +		vib->level = VIB_MIN_LEVEL_mV / 100;
> +	}
> +	pmic8058_vib_set(vib, vib->state);
> +}
> +
> +/*
> + * pmic8058_vib_play_effect - function to handle vib effects.
> + * dev: input device pointer
> + * data: data of effect
> + * effect: effect to play
> + *
> + * Currently this driver supports only rumble effects.
> + *
> + */
> +static int pmic8058_vib_play_effect(struct input_dev *dev, void *data,
> +		      struct ff_effect *effect)
> +{
> +	struct pmic8058_vib *vib = input_get_drvdata(dev);
> +
> +	vib->speed = effect->u.rumble.strong_magnitude >> 8;
> +	if (!vib->speed)
> +		vib->speed = effect->u.rumble.weak_magnitude >> 9;
> +	schedule_work(&vib->work);
> +	return 0;
> +}
> +
> +static int __devinit pmic8058_vib_probe(struct platform_device *pdev)
> +
> +{
> +	struct pm8058_chip *pm_chip;
> +	struct pmic8058_vib *vib;
> +	const struct pmic8058_vibrator_pdata *pdata = pdev->dev.platform_data;
> +	int rc;
> +	u8 val;
> +
> +	pm_chip = platform_get_drvdata(pdev);

The parent should not abuse platform data of _this_ device, it belongs
to this driver. In fact you overwrite it with pmic8058_vib below, which
means that you can't unbind the driver and bind it again.

Please find other way to pass pm_chip.

> +	if (pm_chip == NULL) {
> +		dev_err(&pdev->dev, "no parent data passed in\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	if (pdata->level_mV < VIB_MIN_LEVEL_mV ||
> +			 pdata->level_mV > VIB_MAX_LEVEL_mV)
> +		return -EINVAL;
> +
> +	vib = kzalloc(sizeof(*vib), GFP_KERNEL);
> +	if (!vib)
> +		return -ENOMEM;
> +
> +	vib->pm_chip	= pm_chip;
> +	vib->pdata	= pdata;
> +	vib->dev	= &pdev->dev;
> +
> +	INIT_WORK(&vib->work, pmic8058_work_handler);
> +
> +	vib->vib_input_dev = input_allocate_device();
> +
> +	if (vib->vib_input_dev == NULL) {
> +		dev_err(&pdev->dev, "couldn't allocate input device\n");
> +		rc = -ENOMEM;
> +		goto err_alloc_dev;
> +	}
> +
> +	input_set_drvdata(vib->vib_input_dev, vib);
> +
> +	vib->vib_input_dev->name = "pmic8058_vibrator";
> +	vib->vib_input_dev->id.version = 1;
> +	vib->vib_input_dev->dev.parent = &pdev->dev;
> +
> +	/* operate in manual mode */
> +	rc = pmic8058_vib_read_u8(vib, &val, VIB_DRV);
> +	if (rc < 0)
> +		goto err_read_vib;
> +	val &= ~VIB_DRV_EN_MANUAL_MASK;
> +	rc = pmic8058_vib_write_u8(vib, val, VIB_DRV);
> +	if (rc < 0)
> +		goto err_read_vib;
> +
> +	vib->reg_vib_drv = val;
> +
> +	input_set_capability(vib->vib_input_dev, EV_FF, FF_RUMBLE);
> +
> +	rc = input_ff_create_memless(vib->vib_input_dev, NULL,
> +					pmic8058_vib_play_effect);
> +	if (rc < 0) {
> +		dev_dbg(&pdev->dev, "couldn't register vibrator to FF\n");
> +		goto err_create_memless;
> +	}
> +
> +	platform_set_drvdata(pdev, vib);
> +
> +	rc = input_register_device(vib->vib_input_dev);
> +	if (rc < 0) {
> +		dev_dbg(&pdev->dev, "couldn't register input device\n");
> +		goto err_reg_input_dev;
> +	}

platform_set_drvdata(pdev, vib) should go here so you do not need to
clean it if input_register_device() fails.

> +	return 0;
> +
> +err_reg_input_dev:
> +	input_ff_destroy(vib->vib_input_dev);
> +err_create_memless:
> +err_read_vib:
> +	input_free_device(vib->vib_input_dev);
> +err_alloc_dev:
> +	kfree(vib);
> +	return rc;
> +}
> +
> +static int __devexit pmic8058_vib_remove(struct platform_device *pdev)
> +{
> +	struct pmic8058_vib *vib = platform_get_drvdata(pdev);
> +
> +	cancel_work_sync(&vib->work);
> +	if (vib->state)
> +		pmic8058_vib_set(vib, 0);

This should probably be part of pmic8058_vib_close() method.

> +
> +	input_unregister_device(vib->vib_input_dev);
> +	kfree(vib);

Need to call platform_set_drvdata(pdev, NULL);

> +	return 0;
> +}
> +
> +static struct platform_driver pmic8058_vib_driver = {
> +	.probe		= pmic8058_vib_probe,
> +	.remove		= __devexit_p(pmic8058_vib_remove),
> +	.driver		= {
> +		.name	= "pm8058-vib",
> +		.owner	= THIS_MODULE,
> +	},
> +};

What about PM? Do you need to shut off vibration if device goes to sleep?

Thanks.

-- 
Dmitry

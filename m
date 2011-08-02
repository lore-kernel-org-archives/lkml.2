Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab1HBG1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:27:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1HBG1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:27:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6425"; a="107256749"
Message-ID: <4E3798C1.3080800@codeaurora.org>
Date: Tue, 02 Aug 2011 11:57:13 +0530
From: Anirudh Ghayal <aghayal@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org> <CAM=Q2cvzsZO4dc6Ot_aYJyLW27TErgySdXRcHr1UDb5ua1uHAg@mail.gmail.com>
In-Reply-To: <CAM=Q2cvzsZO4dc6Ot_aYJyLW27TErgySdXRcHr1UDb5ua1uHAg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

Thanks for the review.

On 8/2/2011 11:34 AM, Shubhrajyoti Datta wrote:
> Hi Amy,
>
> On Tue, Aug 2, 2011 at 9:43 AM, Anirudh Ghayal <aghayal@codeaurora.org
> <mailto:aghayal@codeaurora.org>> wrote:
>
>     From: Amy Maloche <amaloche@codeaurora.org
>     <mailto:amaloche@codeaurora.org>>
>
>     Add support for pm8xx based vibrator to facilitate haptics.
>     This module uses the ff-memless framework.
>
>     Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com
>     <mailto:dmitry.torokhov@gmail.com>>
>     Signed-off-by: Amy Maloche <amaloche@codeaurora.org
>     <mailto:amaloche@codeaurora.org>>
>     Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org
>     <mailto:aghayal@codeaurora.org>>
>     ---
>     Changes:
>        Addressed Dmitry's comments from the previous RFC submission.
>     lkml.org/lkml/2011/2/2/53 <http://lkml.org/lkml/2011/2/2/53>
>
>       drivers/input/misc/Kconfig           |   12 ++
>       drivers/input/misc/Makefile          |    1 +
>       drivers/input/misc/pm8xxx-vibrator.c |  309
>     ++++++++++++++++++++++++++++++++++
>       3 files changed, 322 insertions(+), 0 deletions(-)
>       create mode 100644 drivers/input/misc/pm8xxx-vibrator.c
>
>     diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>     index c9104bb..50b9e1b 100644
>     --- a/drivers/input/misc/Kconfig
>     +++ b/drivers/input/misc/Kconfig
>     @@ -74,6 +74,18 @@ config INPUT_PCSPKR
>               To compile this driver as a module, choose M here: the
>               module will be called pcspkr.
>
>     +config INPUT_PM8XXX_VIBRATOR
>     +       tristate "Qualcomm PM8XXX vibrator support"
>
>
> You may want to specify the part number here.  Just in case there is
> another
> vibrator with PM8XXX .

Here, we are only driving a signal out of the PMIC. You can have any 
vibrator installed there. This is a common pin across all the PM8xxx PMICs.

>
>     +       depends on MFD_PM8XXX
>     +       select INPUT_FF_MEMLESS
>     +       help
>     +         This option enables device driver support for the vibrator
>     +         on Qualcomm PM8xxx chip. This driver supports ff-memless
>     interface
>     +         from input framework.
>     +
>     +         To compile this driver as module, choose M here: the
>     +         module will be called pm8xxx-vibrator.
>     +
>       config INPUT_SPARCSPKR
>             tristate "SPARC Speaker support"
>             depends on PCI && SPARC64
>     diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
>     index 299ad5e..40ebe2b 100644
>     --- a/drivers/input/misc/Makefile
>     +++ b/drivers/input/misc/Makefile
>     @@ -34,6 +34,7 @@ obj-$(CONFIG_INPUT_PCAP)              += pcap_keys.o
>       obj-$(CONFIG_INPUT_PCF50633_PMU)       += pcf50633-input.o
>       obj-$(CONFIG_INPUT_PCF8574)            += pcf8574_keypad.o
>       obj-$(CONFIG_INPUT_PCSPKR)             += pcspkr.o
>     +obj-$(CONFIG_INPUT_PM8XXX_VIBRATOR)    += pm8xxx-vibrator.o
>       obj-$(CONFIG_INPUT_POWERMATE)          += powermate.o
>       obj-$(CONFIG_INPUT_PWM_BEEPER)         += pwm-beeper.o
>       obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)    += pmic8xxx-pwrkey.o
>     diff --git a/drivers/input/misc/pm8xxx-vibrator.c
>     b/drivers/input/misc/pm8xxx-vibrator.c
>     new file mode 100644
>     index 0000000..cb2d3ad
>     --- /dev/null
>     +++ b/drivers/input/misc/pm8xxx-vibrator.c
>     @@ -0,0 +1,309 @@
>     +/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
>     + *
>     + * This program is free software; you can redistribute it and/or modify
>     + * it under the terms of the GNU General Public License version 2 and
>     + * only version 2 as published by the Free Software Foundation.
>     + *
>     + * This program is distributed in the hope that it will be useful,
>     + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>     + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>     + * GNU General Public License for more details.
>     + */
>     +
>     +#include <linux/module.h>
>     +#include <linux/init.h>
>     +#include <linux/kernel.h>
>     +#include <linux/errno.h>
>     +#include <linux/platform_device.h>
>     +#include <linux/input.h>
>     +#include <linux/slab.h>
>     +#include <linux/mfd/pm8xxx/core.h>
>     +
>     +#define VIB_DRV                        0x4A
>     +
>     +#define VIB_DRV_SEL_MASK       0xf8
>     +#define VIB_DRV_SEL_SHIFT      0x03
>     +#define VIB_DRV_EN_MANUAL_MASK 0xfc
>     +
>     +#define VIB_MAX_LEVEL_mV       (3100)
>     +#define VIB_MIN_LEVEL_mV       (1200)
>     +#define VIB_MAX_LEVELS         (VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
>     +
>     +#define MAX_FF_SPEED           0xff
>     +
>     +/*
>     + * struct pm8xxx_vib - structure to hold vibrator data
>     + * @vib_input_dev: input device supporting force feedback
>     + * @vwork: work structure to set the vibration parameters
>     + * @dev: device supporting force feedback
>     + * @speed: speed of vibration set from userland
>     + * @state: state of vibrator
>     + * @level: level of vibration to set in the chip
>     + * @reg_vib_drv: VIB_DRV register value
>     + *
>     + */
>     +struct pm8xxx_vib {
>     +       struct input_dev *vib_input_dev;
>     +       struct work_struct work;
>     +       struct device *dev;
>     +       int speed;
>     +       int state;
>     +       int level;
>     +       u8  reg_vib_drv;
>     +};
>     +
>     +/*
>     + * pm8xxx_vib_read_u8 - helper to read a byte from pmic chip
>     + * @vib: pointer to vibrator structure
>     + * @data: placeholder for data to be read
>     + * @reg: register address
>     + *
>     + */
>     +static int pm8xxx_vib_read_u8(struct pm8xxx_vib *vib,
>     +                                u8 *data, u16 reg)
>     +{
>     +       int rc;
>     +
>     +       rc = pm8xxx_readb(vib->dev->parent, reg, data);
>     +       if (rc < 0)
>     +               dev_warn(vib->dev, "Error reading pm8xxx reg
>     0x%x(0x%x)\n",
>     +                               reg, rc);
>     +       return rc;
>     +}
>     +
>     +/*
>     + * pm8xxx_vib_write_u8 - helper to write a byte to pmic chip
>     + * @vib: pointer to vibrator structure
>     + * @data: data to write
>     + * @reg: register address
>     + *
>     + */
>     +static int pm8xxx_vib_write_u8(struct pm8xxx_vib *vib,
>     +                                u8 data, u16 reg)
>     +{
>     +       int rc;
>     +
>     +       rc = pm8xxx_writeb(vib->dev->parent, reg, data);
>     +       if (rc < 0)
>     +               dev_warn(vib->dev, "Error writing pm8xxx reg
>     0x%x(0x%x)\n",
>     +                               reg, rc);
>     +       return rc;
>     +}
>     +
>     +/*
>     + * pm8xxx_vib_set - handler to start/stop vibration
>     + * @vib: pointer to vibrator structure
>     + * @on: state to set
>     + *
>     + */
>     +static int pm8xxx_vib_set(struct pm8xxx_vib *vib, int on)
>     +{
>     +       int rc;
>     +       u8 val;
>     +
>     +       val = vib->reg_vib_drv;
>     +
>     +       if (on)
>     +               val |= ((vib->level << VIB_DRV_SEL_SHIFT) &
>     VIB_DRV_SEL_MASK);
>     +       else
>     +               val &= ~VIB_DRV_SEL_MASK;
>     +
>     +       rc = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
>     +       if (rc < 0)
>     +               return rc;
>     +
>     +       vib->reg_vib_drv = val;
>     +       return rc;
>     +}
>     +
>     +/*
>     + * pm8xxx_work_handler - worker to set vibration level
>     + * @work: pointer to work_struct
>     + *
>     + */
>     +static void pm8xxx_work_handler(struct work_struct *work)
>     +{
>     +       struct pm8xxx_vib *vib;
>     +       int rc;
>     +       u8 val;
>     +
>     +       vib  = container_of(work, struct pm8xxx_vib, work);
>     +
>     +       rc = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
>     +       if (rc < 0)
>     +               return;
>     +
>     +       /*
>     +        * pmic vibrator supports voltage ranges from 1.2 to 3.1V, so
>     +        * scale the level to fit into these ranges.
>     +        */
>     +       if (vib->speed) {
>     +               vib->state = 1;
>     +               vib->level = ((VIB_MAX_LEVELS * vib->speed) /
>     MAX_FF_SPEED) +
>     +                                               VIB_MIN_LEVEL_mV;
>     +               vib->level /= 100;
>     +       } else {
>     +               vib->state = 0;
>     +               vib->level = VIB_MIN_LEVEL_mV / 100;
>     +       }
>     +       pm8xxx_vib_set(vib, vib->state);
>     +}
>     +
>     +/*
>     + * pm8xxx_vib_close - callback of input close callback
>     + * @dev: input device pointer
>     + *
>     + * Turns off the vibrator
>     + *
>     + */
>     +static void pm8xxx_vib_close(struct input_dev *dev)
>     +{
>     +       struct pm8xxx_vib *vib = input_get_drvdata(dev);
>     +
>     +       cancel_work_sync(&vib->work);
>     +       if (vib->state)
>     +               pm8xxx_vib_set(vib, 0);
>     +}
>     +
>     +/*
>     + * pm8xxx_vib_play_effect - function to handle vib effects.
>     + * @dev: input device pointer
>     + * @data: data of effect
>     + * @effect: effect to play
>     + *
>     + * Currently this driver supports only rumble effects.
>     + *
>     + */
>     +static int pm8xxx_vib_play_effect(struct input_dev *dev, void *data,
>     +                     struct ff_effect *effect)
>     +{
>     +       struct pm8xxx_vib *vib = input_get_drvdata(dev);
>     +
>     +       vib->speed = effect->u.rumble.strong_magnitude >> 8;
>     +       if (!vib->speed)
>     +               vib->speed = effect->u.rumble.weak_magnitude >> 9;
>     +       schedule_work(&vib->work);
>     +       return 0;
>     +}
>     +
>     +static int __devinit pm8xxx_vib_probe(struct platform_device *pdev)
>     +
>     +{
>     +       struct pm8xxx_vib *vib;
>     +       int rc;
>     +       u8 val;
>     +
>     +
>     +       vib = kzalloc(sizeof(*vib), GFP_KERNEL);
>     +       if (!vib)
>     +               return -ENOMEM;
>     +
>     +       vib->dev        = &pdev->dev;
>     +
>     +       INIT_WORK(&vib->work, pm8xxx_work_handler);
>     +
>     +       vib->vib_input_dev = input_allocate_device();
>     +
>     +       if (vib->vib_input_dev == NULL) {
>     +               dev_err(&pdev->dev, "couldn't allocate input device\n");
>     +               rc = -ENOMEM;
>     +               goto err_alloc_dev;
>     +       }
>     +
>     +       input_set_drvdata(vib->vib_input_dev, vib);
>     +
>     +       vib->vib_input_dev->name = "pm8xxx_vib_ffmemless";
>     +       vib->vib_input_dev->id.version = 1;
>     +       vib->vib_input_dev->dev.parent = &pdev->dev;
>     +
>     +       /* operate in manual mode */
>     +       rc = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
>     +       if (rc < 0)
>     +               goto err_read_vib;
>     +       val &= ~VIB_DRV_EN_MANUAL_MASK;
>     +       rc = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
>     +       if (rc < 0)
>     +               goto err_read_vib;
>     +
>     +       vib->reg_vib_drv = val;
>     +
>     +       input_set_capability(vib->vib_input_dev, EV_FF, FF_RUMBLE);
>     +       vib->vib_input_dev->close = pm8xxx_vib_close;
>     +
>     +       rc = input_ff_create_memless(vib->vib_input_dev, NULL,
>     +                                       pm8xxx_vib_play_effect);
>     +       if (rc < 0) {
>     +               dev_dbg(&pdev->dev, "couldn't register vibrator to
>     FF\n");
>     +               goto err_create_memless;
>     +       }
>     +
>     +       rc = input_register_device(vib->vib_input_dev);
>     +       if (rc < 0) {
>     +               dev_dbg(&pdev->dev, "couldn't register input device\n");
>
>
> dev_err ?? Just a sugestion .

Yes should have been dev_err.

Dmitry, would you like me to submit another patch for this? I can make 
the @work change as well. Or would you make this minor change as well. 
Thank you.

>
>     +               goto err_reg_input_dev;
>     +       }
>     +
>     +       platform_set_drvdata(pdev, vib);
>     +
>     +       return 0;
>     +
>     +err_reg_input_dev:
>     +       input_ff_destroy(vib->vib_input_dev);
>     +err_create_memless:
>     +err_read_vib:
>     +       input_free_device(vib->vib_input_dev);
>     +err_alloc_dev:
>     +       kfree(vib);
>     +       return rc;
>     +}
>     +
>     +static int __devexit pm8xxx_vib_remove(struct platform_device *pdev)
>     +{
>     +       struct pm8xxx_vib *vib = platform_get_drvdata(pdev);
>     +
>     +       input_unregister_device(vib->vib_input_dev);
>     +       platform_set_drvdata(pdev, NULL);
>     +       kfree(vib);
>     +       return 0;
>     +}
>     +
>     +#ifdef CONFIG_PM_SLEEP
>     +static int pm8xxx_vib_suspend(struct device *dev)
>     +{
>     +       struct pm8xxx_vib *vib = dev_get_drvdata(dev);
>     +       /* Turn off the vibrator */
>     +       pm8xxx_vib_set(vib, 0);
>     +
>     +       return 0;
>     +}
>
> If the suspend has turned it off  who turns it on?

We basically only drive the pin low to turn off the vibrator (not 
disabling the pin). It is turned on the next time you write to the 
device node with the required effect.

>
>     +#endif
>     +
>     +static SIMPLE_DEV_PM_OPS(pm8xxx_vib_pm_ops,
>     +                        pm8xxx_vib_suspend, NULL);
>     +
>     +static struct platform_driver pm8xxx_vib_driver = {
>     +       .probe          = pm8xxx_vib_probe,
>     +       .remove         = __devexit_p(pm8xxx_vib_remove),
>     +       .driver         = {
>     +               .name   = "pm8xxx-vib",
>     +               .owner  = THIS_MODULE,
>     +               .pm     = &pm8xxx_vib_pm_ops,
>     +       },
>     +};
>     +
>     +static int __init pm8xxx_vib_init(void)
>     +{
>     +       return platform_driver_register(&pm8xxx_vib_driver);
>     +}
>     +module_init(pm8xxx_vib_init);
>     +
>     +static void __exit pm8xxx_vib_exit(void)
>     +{
>     +       platform_driver_unregister(&pm8xxx_vib_driver);
>     +}
>     +module_exit(pm8xxx_vib_exit);
>     +
>     +MODULE_ALIAS("platform:pm8xxx_vib");
>     +MODULE_DESCRIPTION("PMIC8xxx vibrator driver based on ff-memless
>     framework");
>     +MODULE_LICENSE("GPL v2");
>     +MODULE_AUTHOR("Amy Maloche <amaloche@codeaurora.org
>     <mailto:amaloche@codeaurora.org>>");
>     --
>     Sent by a consultant of the Qualcomm Innovation Center, Inc.
>     The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>     Forum.
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-input" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>

Thank you,
~Anirudh



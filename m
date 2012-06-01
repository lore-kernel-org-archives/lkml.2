Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2FAFVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 01:21:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47110 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2FAFV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 01:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1338524234-12165-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1338524234-12165-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Fri, 1 Jun 2012 10:51:29 +0530
Message-ID: <CAKew6eWfPyC5ExJmEsgnRdsLsjAqc+zXCnVMzyyiqbEp1RUerw@mail.gmail.com>
Subject: Re: [PATCH] regulator: MAX77686: Add Maxim 77686 regulator driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static __devinit int max77686_pmic_probe(struct platform_device *pdev)
> +{
> +       struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +       struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
> +       struct regulator_dev **rdev;
> +       struct max77686_data *max77686;
> +       int i,  size;
> +       int ret = 0;
> +       struct regulator_config config;
> +
> +       dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +       max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
> +                               GFP_KERNEL);
> +       if (!max77686)
> +               return -ENOMEM;
> +
> +       size = sizeof(struct regulator_dev *) * MAX77686_REGULATORS;
> +       max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +       if (!max77686->rdev)
> +               return -ENOMEM;
> +
> +       rdev = max77686->rdev;
> +       max77686->dev = &pdev->dev;
> +       max77686->iodev = iodev;
> +       if (pdata)
> +               max77686->num_regulators = pdata->num_regulators;
> +       platform_set_drvdata(pdev, max77686);
> +
> +       max77686->ramp_delay = RAMP_RATE_NO_CTRL; /* Set 0x3 for RAMP */
> +       regmap_update_bits(max77686->iodev->regmap,
> +                       MAX77686_REG_BUCK2CTRL1, MAX77686_RAMP_RATE_MASK,
> +                       max77686->ramp_delay << 6);
> +       regmap_update_bits(max77686->iodev->regmap,
> +                       MAX77686_REG_BUCK3CTRL1, MAX77686_RAMP_RATE_MASK,
> +                       max77686->ramp_delay << 6);
> +       regmap_update_bits(max77686->iodev->regmap,
> +                       MAX77686_REG_BUCK4CTRL1, MAX77686_RAMP_RATE_MASK,
> +                       max77686->ramp_delay << 6);
> +
> +       if (pdata->num_regulators == MAX77686_REGULATORS) {

I was expecting this check inside the if(pdata) { ... } earlier at
starting of probe
because it looks more appropriate(good)  their :).
Anyways, this can also work.

> +               for (i = 0; i < MAX77686_REGULATORS; i++) {
> +                       config.dev = max77686->dev;
> +                       config.regmap = iodev->regmap;
> +                       config.driver_data = max77686;
> +                       config.init_data = pdata->regulators[i].initdata;
> +
> +                       rdev[i] = regulator_register(&regulators[i], &config);
> +
> +                       if (IS_ERR(rdev[i])) {
> +                               ret = PTR_ERR(rdev[i]);
> +                               dev_err(max77686->dev,
> +                               "regulator init failed for %d\n", i);
> +                               rdev[i] = NULL;
> +                               goto err;
> +                       }
> +               }
> +       } else {
> +               dev_err(max77686->dev,
> +                        "Lack of initial data for regulator's initialiation\n");
> +               return -EINVAL;
> +       }
> +       return 0;


Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>

Regards,
Yadwinder.

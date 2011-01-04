Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1ADHtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:49:15 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48865 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ADHtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:49:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Date: Tue, 04 Jan 2011 08:49:04 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
In-reply-to: <1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>, myungjoo.ham@gmail.com
Message-id: <20110104084904.5765cd9e@lmajewski.digital.local>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
References: <20101224113805.GI27832@sortiz-mobl>
 <1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jan 2011 14:17:40 +0900
MyungJoo Ham <myungjoo.ham@samsung.com> wrote:

Hi all,

I've posted some comments below:

if (gpio_is_valid(pdata->buck2_set3)) {
> -			if (max8998->buck2_vol[0] == i) {
> -				max8998->buck2_idx = 0;
> -				buck2_gpio_set(pdata->buck2_set3, 0);
> -			} else {
> -				max8998->buck2_idx = 1;
> -				ret =
> max8998_get_voltage_register(rdev, &reg, -
> &shift,
> -
> &mask);
> -				ret = max8998_write_reg(i2c, reg, i);
> -				max8998->buck2_vol[1] = i;
> -				buck2_gpio_set(pdata->buck2_set3, 1);
> +
> +			/* check if requested voltage */
> +			/* value is already defined */
> +			for (j = 0; j <
> ARRAY_SIZE(max8998->buck2_vol); j++) {
> +				if (max8998->buck2_vol[j] == i) {
> +					max8998->buck2_idx = j;
> +
> buck2_gpio_set(pdata->buck2_set3, j);
> +					goto buck2_exit;
> +				}
>  			}
> +
> +			if (pdata->buck_voltage_lock)
> +				return -EINVAL;
> +
> +			max8998_get_voltage_register(rdev,
> +					&reg, &shift, &mask);
> +			ret = max8998_write_reg(i2c, reg, i);
> +			max8998->buck2_vol[max8998->buck2_idx] = i;
> +
> buck2_gpio_set(pdata->buck2_set3,max8998->buck2_idx); +buck2_exit:
> dev_dbg(max8998->dev, "%s: SET3:%d\n", i2c->name,
gpio_get_value(pdata->buck2_set3));

Maybe only the matter of taste. The "for" loop for only two elements?

> + * @buck_voltage_lock: Do NOT change the values of the following six
> + *   registers set by buck?_voltage?. The voltage of BUCK1/2 cannot
> + *   be other than the preset values.
> + * @buck1_voltage1: BUCK1 DVS mode 1 voltage register
> + * @buck1_voltage2: BUCK1 DVS mode 2 voltage register
> + * @buck1_voltage3: BUCK1 DVS mode 3 voltage register
> + * @buck1_voltage4: BUCK1 DVS mode 4 voltage register
> + * @buck2_voltage1: BUCK2 DVS mode 1 voltage register
> + * @buck2_voltage2: BUCK2 DVS mode 2 voltage register

Is it desirable to define all four for BUCK1 and two for BUCK2 DVS
voltages in platform code? 

Why the "general purpose" slots approach for user changeable/definable
voltages (as it was done previously) have been replaced? Is the current
approach faster?


-- 
Best regards,

Lukasz Majewski

Samsung Poland R&D Center
Platform Group

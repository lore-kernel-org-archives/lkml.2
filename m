Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0LBCgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:36:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54518 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab0LBCgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:36:46 -0500
MIME-Version: 1.0
In-Reply-To: <20101201075002.GE6017@pengutronix.de>
References: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
	<20101201075002.GE6017@pengutronix.de>
Date: Thu, 2 Dec 2010 10:36:45 +0800
Message-ID: <AANLkTinTXQ=-YYTjLpjx+sk7+5-zNY-gKUQbNWsqYSQb@mail.gmail.com>
Subject: Re: [PATCHv2] make mc13783 regulator code generic
From: Yong Shen <yong.shen@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linaro Dev <linaro-dev@lists.linaro.org>,
        List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 3:50 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Yong,
>
> On Wed, Dec 01, 2010 at 03:15:55PM +0800, Yong Shen wrote:
>> Hi there,
>>
>> This is the v2 with some changes according to comments from v1. There
>> will be few patches coming out after this one, for mc13892 regulator
>> to share some code with mc13783.
>>
>> Still, cause the firewall problem, I send out patch this way. Please
>> give comments inline and use attached patch for testing.
>
> This patch definitely goes into the right direction. Some comments
> inline.
>
>>
>> Yong
>>
>> From b3451070f4665c90f11e600a8722f86b68437ded Mon Sep 17 00:00:00 2001
>> From: Yong Shen <yong.shen@linaro.org>
>> Date: Tue, 30 Nov 2010 14:11:34 +0800
>> Subject: [PATCH] make mc13783 regulator code generic
>>
>> move some common functions and micros of mc13783 regulaor driver to
>> a seperate file, which makes it possible for mc13892 to share code.
>>
>> Signed-off-by: Yong Shen <yong.shen@linaro.org>
>> ---
>>  drivers/regulator/Kconfig                  |    4 +
>>  drivers/regulator/Makefile                 |    1 +
>>  drivers/regulator/mc13783-regulator.c      |  325 ++++------------------------
>>  drivers/regulator/mc13xxx-regulator-core.c |  239 ++++++++++++++++++++
>>  include/linux/mfd/mc13783.h                |   67 +++---
>>  include/linux/regulator/mc13xxx.h          |  101 +++++++++
>>  6 files changed, 425 insertions(+), 312 deletions(-)
>>  create mode 100644 drivers/regulator/mc13xxx-regulator-core.c
>>  create mode 100644 include/linux/regulator/mc13xxx.h
>>
>> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
>> index dd30e88..63c2bdd 100644
>> --- a/drivers/regulator/Kconfig
>> +++ b/drivers/regulator/Kconfig
>> @@ -186,9 +186,13 @@ config REGULATOR_PCAP
>>        This driver provides support for the voltage regulators of the
>>        PCAP2 PMIC.
>>
>> +config REGULATOR_MC13XXX_CORE
>> +     tristate "Support regulators on Freescale MC13xxx PMIC"
>> +
>
> This does not need a prompt. Selecting only this option does not make
> sense and it will be selected by the mc13783/mc13892 code anyway.
>
>>  config REGULATOR_MC13783
>>       tristate "Support regulators on Freescale MC13783 PMIC"
>>       depends on MFD_MC13783
>> +     select REGULATOR_MC13XXX_CORE
>>       help
>>         Say y here to support the regulators found on the Freescale MC13783
>>         PMIC.
>> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
>> index bff8157..11876be 100644
>> --- a/drivers/regulator/Makefile
>> +++ b/drivers/regulator/Makefile
>> @@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_DA903X)      += da903x.o
>>  obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
>>  obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
>>  obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
>> +obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
>>  obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
>>
>>  obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
>
> [snip]
>
>> diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
>> index b4c741e..7d0f3d6 100644
>> --- a/include/linux/mfd/mc13783.h
>> +++ b/include/linux/mfd/mc13783.h
>> @@ -1,4 +1,5 @@
>>  /*
>> + * Copyright 2010 Yong Shen <yong.shen@linaro.org>
>>   * Copyright 2009-2010 Pengutronix
>>   * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
>>   *
>> @@ -122,39 +123,39 @@ int mc13783_adc_do_conversion(struct mc13783
>> *mc13783, unsigned int mode,
>>               unsigned int channel, unsigned int *sample);
>>
>>
>> -#define      MC13783_SW_SW1A         0
>> -#define      MC13783_SW_SW1B         1
>> -#define      MC13783_SW_SW2A         2
>> -#define      MC13783_SW_SW2B         3
>> -#define      MC13783_SW_SW3          4
>> -#define      MC13783_SW_PLL          5
>> -#define      MC13783_REGU_VAUDIO     6
>> -#define      MC13783_REGU_VIOHI      7
>> -#define      MC13783_REGU_VIOLO      8
>> -#define      MC13783_REGU_VDIG       9
>> -#define      MC13783_REGU_VGEN       10
>> -#define      MC13783_REGU_VRFDIG     11
>> -#define      MC13783_REGU_VRFREF     12
>> -#define      MC13783_REGU_VRFCP      13
>> -#define      MC13783_REGU_VSIM       14
>> -#define      MC13783_REGU_VESIM      15
>> -#define      MC13783_REGU_VCAM       16
>> -#define      MC13783_REGU_VRFBG      17
>> -#define      MC13783_REGU_VVIB       18
>> -#define      MC13783_REGU_VRF1       19
>> -#define      MC13783_REGU_VRF2       20
>> -#define      MC13783_REGU_VMMC1      21
>> -#define      MC13783_REGU_VMMC2      22
>> -#define      MC13783_REGU_GPO1       23
>> -#define      MC13783_REGU_GPO2       24
>> -#define      MC13783_REGU_GPO3       25
>> -#define      MC13783_REGU_GPO4       26
>> -#define      MC13783_REGU_V1         27
>> -#define      MC13783_REGU_V2         28
>> -#define      MC13783_REGU_V3         29
>> -#define      MC13783_REGU_V4         30
>> -#define      MC13783_REGU_PWGT1SPI   31
>> -#define      MC13783_REGU_PWGT2SPI   32
>
> These have users. If you really want to change them you must change
> the users aswell. Also, I would suggest an additional patch for this.
> Remember, one topic per patch. Renaming things is a topic that can
> easily be split out.
My bad, I had not noticed that. In this case, I will split it into
two. The renaming patch goes first followed with code restructuring
patch.
>
>> +#define      MC13783_REG_SW1A                0
>> +#define      MC13783_REG_SW1B                1
>> +#define      MC13783_REG_SW2A                2
>> +#define      MC13783_REG_SW2B                3
>> +#define      MC13783_REG_SW3         4
>> +#define      MC13783_REG_PLL         5
>> +#define      MC13783_REG_VAUDIO      6
>> +#define      MC13783_REG_VIOHI       7
>> +#define      MC13783_REG_VIOLO       8
>> +#define      MC13783_REG_VDIG        9
>> +#define      MC13783_REG_VGEN        10
>> +#define      MC13783_REG_VRFDIG      11
>> +#define      MC13783_REG_VRFREF      12
>> +#define      MC13783_REG_VRFCP       13
>> +#define      MC13783_REG_VSIM        14
>> +#define      MC13783_REG_VESIM       15
>> +#define      MC13783_REG_VCAM        16
>> +#define      MC13783_REG_VRFBG       17
>> +#define      MC13783_REG_VVIB        18
>> +#define      MC13783_REG_VRF1        19
>> +#define      MC13783_REG_VRF2        20
>> +#define      MC13783_REG_VMMC1       21
>> +#define      MC13783_REG_VMMC2       22
>> +#define      MC13783_REG_GPO1        23
>> +#define      MC13783_REG_GPO2        24
>> +#define      MC13783_REG_GPO3        25
>> +#define      MC13783_REG_GPO4        26
>> +#define      MC13783_REG_V1          27
>> +#define      MC13783_REG_V2          28
>> +#define      MC13783_REG_V3          29
>> +#define      MC13783_REG_V4          30
>> +#define      MC13783_REG_PWGT1SPI    31
>> +#define      MC13783_REG_PWGT2SPI    32
>>
>>  #define MC13783_IRQ_ADCDONE  MC13XXX_IRQ_ADCDONE
>>  #define MC13783_IRQ_ADCBISDONE       MC13XXX_IRQ_ADCBISDONE
>> diff --git a/include/linux/regulator/mc13xxx.h
>> b/include/linux/regulator/mc13xxx.h
>> new file mode 100644
>> index 0000000..a60c9be
>> --- /dev/null
>> +++ b/include/linux/regulator/mc13xxx.h
>
> The things in this file are private to the driver. IMO this should go to
> drivers/regulator/mc13xxx.h.
>
>> @@ -0,0 +1,101 @@
>> +/*
>> + * mc13xxx.h - regulators for the Freescale mc13xxx PMIC
>> + *
>> + *  Copyright (C) 2010 Yong Shen <yong.shen@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef __LINUX_REGULATOR_MC13XXX_H
>> +#define __LINUX_REGULATOR_MC13XXX_H
>> +
>> +#include <linux/regulator/driver.h>
>> +
>> +struct mc13xxx_regulator {
>> +     struct regulator_desc desc;
>> +     int reg;
>> +     int enable_bit;
>> +     int vsel_reg;
>> +     int vsel_shift;
>> +     int vsel_mask;
>> +     int hi_bit;
>> +     int const *voltages;
>> +};
>> +
>> +struct mc13xxx_regulator_priv {
>> +     struct mc13xxx *mc13xxx;
>> +     u32 powermisc_pwgt_state;
>> +     struct mc13xxx_regulator *mc13xxx_regulators;
>> +     struct regulator_dev *regulators[];
>> +};
>> +
>> +extern int mc13xxx_sw_regulator(struct regulator_dev *rdev);
>> +extern int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev);
>> +extern int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
>> +                                             int min_uV, int max_uV);
>> +extern int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
>> +                                             unsigned selector);
>> +extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
>> +                                             int min_uV, int max_uV);
>> +extern int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev);
>> +
>> +extern struct regulator_ops mc13xxx_regulator_ops;
>> +extern struct regulator_ops mc13xxx_fixed_regulator_ops;
>> +
>> +#define MC13xxx_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages, _ops)      \
>> +     [prefix ## _name] = {                           \
>> +             .desc = {                                               \
>> +                     .name = #prefix "_" #_name,                     \
>> +                     .n_voltages = ARRAY_SIZE(_voltages),            \
>> +                     .ops = &_ops,                   \
>> +                     .type = REGULATOR_VOLTAGE,                      \
>> +                     .id = prefix ## _name,          \
>> +                     .owner = THIS_MODULE,                           \
>> +             },                                                      \
>> +             .reg = prefix ## _reg,                          \
>> +             .enable_bit = prefix ## _reg ## _ ## _name ## EN,       \
>> +             .vsel_reg = prefix ## _vsel_reg,                        \
>> +             .vsel_shift = prefix ## _vsel_reg ## _ ## _name ## VSEL,\
>> +             .vsel_mask = prefix ## _vsel_reg ## _ ## _name ## VSEL_M,\
>> +             .voltages =  _voltages,                                 \
>> +     }
>> +
>> +#define MC13xxx_FIXED_DEFINE(prefix, _name, _reg, _voltages, _ops)   \
>> +     [prefix ## _name] = {                           \
>> +             .desc = {                                               \
>> +                     .name = #prefix "_" #_name,                     \
>> +                     .n_voltages = ARRAY_SIZE(_voltages),            \
>> +                     .ops = &_ops,           \
>> +                     .type = REGULATOR_VOLTAGE,                      \
>> +                     .id = prefix ## _name,          \
>> +                     .owner = THIS_MODULE,                           \
>> +             },                                                      \
>> +             .reg = prefix ## _reg,                          \
>> +             .enable_bit = prefix ## _reg ## _ ## _name ## EN,       \
>> +             .voltages =  _voltages,                                 \
>> +     }
>> +
>> +#define MC13xxx_GPO_DEFINE(prefix, _name, _reg,  _voltages, _ops)    \
>> +     [prefix ## _name] = {                           \
>> +             .desc = {                                               \
>> +                     .name = #prefix "_" #_name,                     \
>> +                     .n_voltages = ARRAY_SIZE(_voltages),            \
>> +                     .ops = &_ops,           \
>> +                     .type = REGULATOR_VOLTAGE,                      \
>> +                     .id = prefix ## _name,          \
>> +                     .owner = THIS_MODULE,                           \
>> +             },                                                      \
>> +             .reg = prefix ## _reg,                          \
>> +             .enable_bit = prefix ## _reg ## _ ## _name ## EN,       \
>> +             .voltages =  _voltages,                                 \
>> +     }
>> +
>> +#define MC13xxx_DEFINE_SW(_name, _reg, _vsel_reg, _voltages, ops)    \
>> +     MC13xxx_DEFINE(SW, _name, _reg, _vsel_reg, _voltages, ops)
>> +#define MC13xxx_DEFINE_REGU(_name, _reg, _vsel_reg, _voltages, ops)  \
>> +     MC13xxx_DEFINE(REGU, _name, _reg, _vsel_reg, _voltages, ops)
>> +
>> +#endif
>> --
>> 1.7.0.4
>>
>> Cheers
>> Yong
>
>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2LFGVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:21:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51395 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2LFGVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:21:20 -0500
From: "Jeong, Daniel" <Daniel.Jeong@ti.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Jeong <gshark.jeong@gmail.com>
Subject: RE: [PATCH v1] regulator: new driver for LP8755
Thread-Topic: [PATCH v1] regulator: new driver for LP8755
Thread-Index: AQHN0q6AAr76qbfsdEqB3w02gPC1qJgKuw4AgACJ0GA=
Date: Thu, 6 Dec 2012 06:21:13 +0000
Message-ID: <F0866C1C5ECEAF4CB380B619BD733BEA641AC3DB@DQHE02.ent.ti.com>
References: <1354687497-18446-1-git-send-email-gshark.jeong@gmail.com>
 <A874F61F95741C4A9BA573A70FE3998F641937AF@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F641937AF@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.61]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>From: Kim, Milo 
>Sent: Thursday, December 06, 2012 2:34 PM
>To: Daniel Jeong
>Cc: Jeong, Daniel; linux-kernel@ver.kernel.org; Girdwood, Liam; Mark Brown
>Subject: RE: [PATCH v1] regulator: new driver for LP8755
>
>Hi Daniel,
>
>> This driver is a general version for lp8755 regulator driver of TI.
>> 
>> LP8755 :
>> The LP8755 is a high performance power management unit.It contains six 
>> step-down DC-DC converters which can can be filexibly bundled together 
>> in multiphase converters as required by application.
>> www.ti.com
>> 
>> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
>
>I've added few comments on your code. 
>(return code, error handling and regulator notification events) Other things look good to me.
>
>> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig 
>> index 67d47b59..63e37ff 100644
>> --- a/drivers/regulator/Kconfig
>> +++ b/drivers/regulator/Kconfig
>> @@ -257,6 +257,15 @@ config REGULATOR_LP872X
>>  	help
>>  	  This driver supports LP8720/LP8725 PMIC
>> 
>> +config REGULATOR_LP8755
>> +	tristate "TI LP8755 Hihg Performance PMU driver"
>
>Typo, 'High'.
Oops. Thank you for your comments. 
>
>> +struct lp8755_chip {
>> +	struct device *dev;
>> +	struct regmap *regmap;
>> +	struct lp8755_platform_data *pdata;
>> +
>> +	int irq;
>> +	unsigned int irqmask;
>> +
>> +	int num_reg;
>
>Can 'num_reg' be removed if unnecessary?
>
You're right. It should be dropped. Thank you. 
>> +static unsigned int lp8755_buck_get_mode(struct regulator_dev *rdev) 
>> +{
>> +	int ret;
>> +	unsigned int regval;
>> +	enum lp8755_bucks id = rdev_get_id(rdev);
>> +	struct lp8755_chip *pchip = rdev_get_drvdata(rdev);
>> +
>> +	ret = lp8755_read(pchip, 0x06, &regval);
>> +	if (ret < 0)
>> +		goto err_i2c;
>> +	/* mode fast means forced pwm mode */
>> +	if (regval & (0x01 << id))
>> +		return REGULATOR_MODE_FAST;
>> +
>> +	ret = lp8755_read(pchip, 0x10, &regval);
>> +	if (ret < 0)
>> +		goto err_i2c;
>> +	/* mode normal means automatic pwm/pfm mode */
>> +	if ((regval & 0x01) == 0)
>> +		return REGULATOR_MODE_NORMAL;
>> +
>> +	ret = lp8755_read(pchip, 0x08 + id, &regval);
>> +	if (ret < 0)
>> +		goto err_i2c;
>> +	/* mode idle means automatic pwm/pfm/lppfm mode */
>> +	if (regval & 0x20)
>> +		return REGULATOR_MODE_IDLE;
>> +
>> +err_i2c:
>> +	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
>> +	return ret;
>
>Return 0 is better because the return type of _get_mode is unsigned int.
>
>> +
>> +/* interrupts */
>> +enum lp8755_irq {
>> +	LP8755_IRQ_OCP = 0,
>> +	LP8755_IRQ_OVP,
>> +	LP8755_IRQ_B0,
>> +	LP8755_IRQ_B1,
>> +	LP8755_IRQ_B2,
>> +	LP8755_IRQ_B3,
>> +	LP8755_IRQ_B4,
>> +	LP8755_IRQ_B5,
>> +	LP8755_IRQ_MAX,
>> +};
>
>Can 'lp8755_irq' be removed if unnecessary? 
You're right. It should be dropped. Thank you.
> 
>> +static int lp8755_int_config(struct lp8755_chip *pchip) {
>> +	int ret;
>> +	unsigned int regval;
>> +
>> +	if (pchip->irq == 0) {
>> +		dev_warn(pchip->dev, "not use interrupt : %s\n", __func__);
>> +		return 0;
>> +	}
>> +
>> +	ret = lp8755_read(pchip, 0x0F, &regval);
>> +	if (ret < 0)
>> +		goto err_i2c;
>> +	pchip->irqmask = regval;
>> +	ret = request_threaded_irq(pchip->irq, NULL, lp8755_irq_handler,
>> +				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +				   "lp8755-irq", pchip);
>> +	if (ret)
>> +		return -1;
>
>Return 'ret', not '-1'.
>
>> +err_irq:
>> +	dev_err(&client->dev, "fail to irq config\n");
>> +
>> +	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
>> +		regulator_unregister(pchip->rdev[icnt]);
>> +
>> +err_regulator:
>> +	dev_err(&client->dev, "fail to initialize regulators\n");
>> +	/* output disable */
>> +	for (icnt = 0; icnt < 0x06; icnt++)
>> +		lp8755_write(pchip, icnt, 0x80);
>
>I'm curious the reason why the value is different from handling in _remove().
>In _remove(), 0x0 ~ 0x5 registers are cleared.
>
>	for (icnt = 0; icnt < 0x06; icnt++)
>		lp8755_write(pchip, icnt, 0x00);
>                                      ^^^^ However, these registers are updated to 0x80 when lp8755_regulator_int() gets failed.
>
>	for (icnt = 0; icnt < 0x06; icnt++)
>		lp8755_write(pchip, icnt, 0x80);
>                                      ^^^^ I'm not sure this point is meaningful. Could you check this?
>
>> diff --git a/include/linux/platform_data/lp8755.h
>> b/include/linux/platform_data/lp8755.h
>> new file mode 100644
>> index 0000000..a7fd077
>> --- /dev/null
>> +++ b/include/linux/platform_data/lp8755.h
>> @@ -0,0 +1,71 @@
>> +/*
>> + * LP8755 High Performance Power Management Unit Driver:System
>> Interface Driver
>> + *
>> + *			Copyright (C) 2012 Texas Instruments
>> + *
>> + * Author: Daniel(Geon Si) Jeong <daniel.jeong@ti.com>
>> + *             G.Shark Jeong <gshark.jeong@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#ifndef _LP8755_H
>> +#define _LP8755_H
>> +
>> +#include <linux/regulator/consumer.h>
>> +
>> +#define LP8755_NAME "lp8755-regulator"
>> +/*
>> + *PWR FAULT : power fault detected
>> + *OCP : over current protect activated  *OVP : over voltage protect 
>> +activated  *TEMP_WARN : thermal warning  *TEMP_SHDN : thermal 
>> +shutdonw detected  *I_LOAD : current measured  */ #define 
>> +LP8755_EVENT_PWR_FAULT REGULATOR_EVENT_FAIL #define LP8755_EVENT_OCP 
>> +REGULATOR_EVENT_OVER_CURRENT #define LP8755_EVENT_OVP 0x10000 #define 
>> +LP8755_EVENT_TEMP_WARN 0x2000 #define LP8755_EVENT_TEMP_SHDN 
>> +REGULATOR_EVENT_OVER_TEMP
>> +#define LP8755_EVENT_I_LOAD	0x40000
>
>IMO, it would be better to use general regulator notification rather than
>LP8755 custom event.
>The regulator notifications are handled by a regulator consumer.
>The regulator consumer, it doesn't need to handle chip-specific events such like LP8755_EVENT_XXX. Then, lp8755.h should be included in the consumer.
>To make the consumer general, I recommend legacy regulator notification events.
>
>LP8755_EVENT_OVP can be replaced with REGULATOR_EVENT_REGULATION_OUT.
>LP8755_EVENT_TEMP_WARN, LP8755_EVENT_TEMP_SHDN and LP8755_EVENT_I_LOAD are not used in the driver, so definitions can be ignored.
>
>My suggestion is removing all LP8755_EVENT_ definitions in the header and making driver code as following.
>
>			regulator_notifier_call_chain(pchip->rdev[icnt],
>-						      LP8755_EVENT_PWR_FAULT,
>+							REGULATOR_EVENT_FAIL,
>						      NULL);
>
>				regulator_notifier_call_chain(pchip->rdev[icnt],
>-							      LP8755_EVENT_OCP,
>+							      REGULATOR_EVENT_OVER_CURRENT,
>							      NULL);
>
>				regulator_notifier_call_chain(pchip->rdev[icnt],
>-							      LP8755_EVENT_OVP,
>+							      REGULATOR_EVENT_REGULATION_OUT,
>							      NULL);
>
Regulator notifications are handled by lp8755 consumer and lp8755 can provide more events than general regulator notification to lp8755 regulator consumer. IMO lp8755 consumer need to know more information than general regulator notification.  
Lp8755 actually support interrupt for temperature and current load but my board version disable as a default value. Other version could be enabled, those are for others. 
Thank you for your comments. 
>Mark,
>I'd like to have your opinion about handling regulator notification events.
>
>Best Regards,
>Milo
>

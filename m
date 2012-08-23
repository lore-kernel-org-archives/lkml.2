Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2HWF4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:56:40 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63734 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HWF4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:56:37 -0400
Date: Wed, 22 Aug 2012 22:54:12 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 2/3] power_supply: add new lp8788 charger driver
Message-ID: <20120823055412.GB4849@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EEFC3E@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EEFC3E@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:32:50AM +0000, Kim, Milo wrote:
> Patch v3.

Thanks for the driver! It looks great, mostly cosmetic comments
down below.

> (a) use irq domain for handling charger interrupts
> (b) use scaled adc value rather than raw value
>     : replace iio_read_channel_raw() with iio_read_channel_scale()
> (c) clean up charger-platform-data code
> (d) remove goto statement in _probe()
> (e) name change : from lp8788_unregister_psy() to lp8788_psy_unregister()

Only changelog? No description for the driver? Nothing exciting to
tell us about the hardware, e.g. why it's so great? :-)

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
[...]
> @@ -0,0 +1,785 @@
> +/*
> + * TI LP8788 MFD - battery charger driver
> + *
> + * Copyright 2012 Texas Instruments
> + *
> + * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/err.h>
> +#include <linux/iio/consumer.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqdomain.h>
> +#include <linux/mfd/lp8788.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/power_supply.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +/* register address */
> +#define LP8788_CHG_STATUS		0x07
> +#define LP8788_CHG_IDCIN		0x13
> +#define LP8788_CHG_IBATT		0x14
> +#define LP8788_CHG_VTERM		0x15
> +#define LP8788_CHG_EOC			0x16
> +
> +/* mask/shift bits */
> +#define LP8788_CHG_INPUT_STATE_M	0x03	/* Addr 07h */
> +#define LP8788_CHG_STATE_M		0x3C
> +#define LP8788_CHG_STATE_S		2
> +#define LP8788_NO_BATT_M		BIT(6)
> +#define LP8788_BAD_BATT_M		BIT(7)
> +#define LP8788_CHG_IBATT_M		0x1F	/* Addr 14h */
> +#define LP8788_CHG_VTERM_M		0x0F	/* Addr 15h */
> +#define LP8788_CHG_EOC_LEVEL_M		0x30	/* Addr 16h */
> +#define LP8788_CHG_EOC_LEVEL_S		4
> +#define LP8788_CHG_EOC_TIME_M		0x0E
> +#define LP8788_CHG_EOC_TIME_S		1
> +#define LP8788_CHG_EOC_MODE_M		BIT(0)
> +
> +#define CHARGER_NAME			"charger"
> +#define BATTERY_NAME			"main_batt"
> +
> +#define LP8788_CHG_START		0x11
> +#define LP8788_CHG_END			0x1C
> +
> +#define BUF_SIZE			40

This is in the global namespace, although not exported, true.

Anyways, seems way too generic. I'd prepend it with LP8788_, or
at least LP_ for short.

> +#define LP8788_ISEL_MAX			23
> +#define LP8788_ISEL_STEP		50
> +#define LP8788_VTERM_MIN		4100
> +#define LP8788_VTERM_STEP		25
> +#define MAX_BATT_CAPACITY		100
> +#define MAX_CHG_IRQS			11

ditto.

> +
> +enum lp8788_charging_state {
> +	OFF,
> +	WARM_UP,
> +	LOW_INPUT = 0x3,
> +	PRECHARGE,
> +	CC,
> +	CV,

ditto.

> +	MAINTENANCE,
> +	BATTERY_FAULT,
> +	SYSTEM_SUPPORT = 0xC,
> +	HIGH_CURRENT = 0xF,
> +	MAX_CHG_STATE,
> +};
> +
> +enum lp8788_charger_adc_sel {
> +	VBATT,
> +	BATT_TEMP,
> +	NUM_CHG_ADC,
> +};
> +
> +enum lp8788_charger_input_state {
> +	SYSTEM_SUPPLY = 1,
> +	FULL_FUNCTION,

ditto ditto..

> +};
> +
> +/*
> + * struct lp8788_chg_irq
> + * @which        : lp8788 interrupt id
> + * @virq         : Linux IRQ number from irq_domain
> + */
> +struct lp8788_chg_irq {
> +	enum lp8788_int_id which;
> +	int virq;
> +};
[...]
> +static inline bool lp8788_is_valid_charger_register(u8 addr)
> +{
> +	return (addr >= LP8788_CHG_START && addr <= LP8788_CHG_END);

No need for the outermost parenthesis.

> +}
> +
> +static int lp8788_update_charger_params(struct lp8788_charger *pchg)
> +{
> +	struct lp8788 *lp = pchg->lp;
> +	struct lp8788_charger_platform_data *pdata = pchg->pdata;
> +	struct lp8788_chg_param *param;
> +	int i, ret;

One declaration per line, please. I.e.

int i;
int ret;

> +
> +	if (!pdata || !pdata->chg_params) {
> +		dev_info(lp->dev, "skip updating charger parameters\n");
> +		return 0;
> +	}
[...]
> +static ssize_t lp8788_show_eoc_time(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct lp8788_charger *pchg = dev_get_drvdata(dev);
> +	char *stime[] = { "400ms", "5min", "10min", "15min",
> +			"20min", "25min", "30min" "No timeout" };
> +	u8 val;
> +
> +	lp8788_read_byte(pchg->lp, LP8788_CHG_EOC, &val);
> +	val = (val & LP8788_CHG_EOC_TIME_M) >> LP8788_CHG_EOC_TIME_S;
> +
> +	return scnprintf(buf, BUF_SIZE, "End Of Charge Time: %s\n", stime[val]);
> +}
> +
> +static ssize_t lp8788_show_eoc_level(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct lp8788_charger *pchg = dev_get_drvdata(dev);
> +	char *abs_level[] = { "25mA", "49mA", "75mA", "98mA" };
> +	char *relative_level[] = { "5%", "10%", "15%", "20%" };
> +	char *level;
> +	u8 val, mode;

One declaration per line please, i.e.

u8 val;
u8 mode;

> +
> +	lp8788_read_byte(pchg->lp, LP8788_CHG_EOC, &val);
> +
> +	mode = val & LP8788_CHG_EOC_MODE_M;
> +	val = (val & LP8788_CHG_EOC_LEVEL_M) >> LP8788_CHG_EOC_LEVEL_S;
> +	level = mode ? abs_level[val] : relative_level[val];
> +
> +	return scnprintf(buf, BUF_SIZE, "End Of Charge Level: %s\n", level);
> +}
> +
> +static DEVICE_ATTR(charger_status, S_IRUSR, lp8788_show_charger_status, NULL);
> +static DEVICE_ATTR(idcin, S_IRUSR, lp8788_show_idcin, NULL);
> +static DEVICE_ATTR(ibatt, S_IRUSR, lp8788_show_ibatt, NULL);
> +static DEVICE_ATTR(vterm, S_IRUSR, lp8788_show_vterm, NULL);
> +static DEVICE_ATTR(eoc_time, S_IRUSR, lp8788_show_eoc_time, NULL);
> +static DEVICE_ATTR(eoc_level, S_IRUSR, lp8788_show_eoc_level, NULL);
> +
> +static struct attribute *lp8788_charger_attr[] = {
> +	&dev_attr_charger_status.attr,
> +	&dev_attr_idcin.attr,
> +	&dev_attr_ibatt.attr,
> +	&dev_attr_vterm.attr,
> +	&dev_attr_eoc_time.attr,
> +	&dev_attr_eoc_level.attr,

Are you sure you want to have the driver-specific properties?
I.e., maybe some of them generic enough to them to the standard
POWER_SUPPLY_PROP_* set?

At least 'charging current' seems generic enough...

> +	NULL,
> +};
> +
> +static const struct attribute_group lp8788_attr_group = {
> +	.attrs = lp8788_charger_attr,
> +};
> +
> +static __devinit int lp8788_charger_probe(struct platform_device *pdev)
> +{
> +	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
> +	struct lp8788_charger *pchg;
> +	int ret;
> +
> +	pchg = devm_kzalloc(lp->dev, sizeof(struct lp8788_charger), GFP_KERNEL);
> +	if (!pchg)
> +		return -ENOMEM;
> +
> +	pchg->lp = lp;
> +	pchg->pdata = lp->pdata ? lp->pdata->chg_pdata : NULL;
> +	platform_set_drvdata(pdev, pchg);
> +
> +	ret = lp8788_update_charger_params(pchg);
> +	if (ret)
> +		return ret;
> +
> +	lp8788_setup_adc_channel(pchg);
> +
> +	ret = lp8788_psy_register(pdev, pchg);
> +	if (ret)
> +		return ret;
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &lp8788_attr_group);
> +	if (ret) {
> +		lp8788_psy_unregister(pchg);
> +		return ret;
> +	}
> +
> +	ret = lp8788_irq_register(pdev, pchg);
> +	if (ret)
> +		dev_warn(lp->dev, "failed to register charger irq: %d\n", ret);
> +
> +	return 0;
> +}
> +
> +static int __devexit lp8788_charger_remove(struct platform_device *pdev)
> +{
> +	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
> +
> +	if (pchg->charger_work.func)
> +		flush_work_sync(&pchg->charger_work);

You need to flush the work after freeing irqs, otherwise irq might
reschedule it again.

> +	lp8788_irq_unregister(pdev, pchg);

This will probably blow up if you _probe failed to register irq.
To fix this, you probably want to set pchg->num_irqs to 0 if
irq_register() failed.

> +	sysfs_remove_group(&pdev->dev.kobj, &lp8788_attr_group);
> +	lp8788_psy_unregister(pchg);
> +	lp8788_release_adc_channel(pchg);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver lp8788_charger_driver = {
> +	.probe = lp8788_charger_probe,
> +	.remove = __devexit_p(lp8788_charger_remove),
> +	.driver = {
> +		.name = LP8788_DEV_CHARGER,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +module_platform_driver(lp8788_charger_driver);
> +
> +MODULE_DESCRIPTION("TI LP8788 Charger Driver");
> +MODULE_AUTHOR("Milo Kim");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:lp8788-charger");

Thanks!

Anton.

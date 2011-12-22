Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1LVLdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:33:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42737 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab1LVLdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:33:42 -0500
Date: Thu, 22 Dec 2011 11:33:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, eric.miao@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCHv2] Regulator: Add Anatop regulator driver
Message-ID: <20111222113337.GL4546@opensource.wolfsonmicro.com>
References: <1323265998-29088-2-git-send-email-paul.liu@linaro.org>
 <1324458211-1612-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324458211-1612-1-git-send-email-paul.liu@linaro.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 05:03:31PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop regulator driver is used by i.MX6 SoC. The regulator provides
> controlling the voltage of PU, CORE, SOC, and some devices. This patch
> adds the Anatop regulator driver.

It's still not at all clear to me what an "Anatop" regulator is or why
everything is being done as platform data.

> +config REGULATOR_ANATOP
> +	tristate "ANATOP LDO regulators"
> +	depends on SOC_IMX6
> +	default y if SOC_IMX6

This isn't great, it might be on your reference design but people are
going to change that.

> +#include <linux/platform_device.h>
> +#include <linux/regulator/machine.h>

Why does your regulator driver need this?  That suggests a layering
violation.

> +static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
> +				  int max_uV, unsigned *selector)
> +{
> +	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> +	u32 val, rega;
> +	int uv;
> +
> +	uv = max_uV;

This looks wrong, you should be aiming to get as close as possible to
the minimum not the maximum.

> +	if (anatop_reg->rdata->control_reg) {
> +		val = anatop_reg->rdata->min_bit_val +
> +			(uv - reg->constraints->min_uV) / 25000;

You're not checking that the resulting voltage matches the constraints
or updating selector.

> +	} else {
> +		pr_debug("Regulator not supported.\n");

Why are you logging an error as a debug message?  You should also use
dev_ logging.

> +static int anatop_get_voltage(struct regulator_dev *reg)
> +{

Implement this as get_voltage_sel()

> +static int anatop_enable(struct regulator_dev *reg)
> +{
> +	return 0;
> +}
> +
> +static int anatop_disable(struct regulator_dev *reg)
> +{
> +	return 0;
> +}
> +
> +static int anatop_is_enabled(struct regulator_dev *reg)
> +{
> +	return 1;
> +}

The regulator clearly doesn't have enable or disable support at all, it
shouldn't have these operations.

> +static struct regulator_ops anatop_rops = {
> +	.set_voltage	= anatop_set_voltage,
> +	.get_voltage	= anatop_get_voltage,

You should implement list_voltage() as well.

> +static struct regulator_desc anatop_reg_desc[] = {
> +	{
> +		.name = "vddpu",
> +		.id = ANATOP_VDDPU,
> +		.ops = &anatop_rops,
> +		.irq = 0,

No need to set zero fields.  It's also *very* odd to see a table
explicitly listing regulators by name in a driver that doesn't know
which registers it's working with.

> +int anatop_regulator_probe(struct platform_device *pdev)
> +{
> +	struct regulator_desc *rdesc;
> +	struct regulator_dev *rdev;
> +	struct anatop_regulator *sreg;
> +	struct regulator_init_data *initdata;
> +
> +	sreg = platform_get_drvdata(pdev);
> +	initdata = pdev->dev.platform_data;
> +	sreg->cur_current = 0;
> +	sreg->next_current = 0;
> +	sreg->cur_voltage = 0;

You're trying to read the driver data but you haven't set any.  This is
going to crash.

> +	init_waitqueue_head(&sreg->wait_q);

This waitqueue appears to never be referenced.

> +	if (pdev->id > ANATOP_SUPPLY_NUM) {
> +		rdesc = kzalloc(sizeof(struct regulator_desc), GFP_KERNEL);

devm_kzalloc() and check the return value.

> +		memcpy(rdesc, &anatop_reg_desc[ANATOP_SUPPLY_NUM],
> +			sizeof(struct regulator_desc));
> +		rdesc->name = kstrdup(sreg->rdata->name, GFP_KERNEL);

This looks really confused, you've got some regulators embedded into the
driver and some with things passed in as platform data.  Either approach
should be fine but mixing both complicates things needlessly.

> +	} else
> +		rdesc = &anatop_reg_desc[pdev->id];

Use braces on both sides of the if.

> +	pr_debug("probing regulator %s %s %d\n",
> +			sreg->rdata->name,
> +			rdesc->name,
> +			pdev->id);

A lot of this logging looks like it's just replicating logging from the
core.

> +	/* register regulator */
> +	rdev = regulator_register(rdesc, &pdev->dev,
> +				  initdata, sreg);

The driver isn't doing anything to for example map the register bank
it's using.

> +int anatop_register_regulator(
> +		struct anatop_regulator *reg_data, int reg,
> +			      struct regulator_init_data *initdata)
> +{

Eew, no.  Just register the platform device normally.

> +	int mode;
> +	int cur_voltage;
> +	int cur_current;
> +	int next_current;

These appear to be unused and are rather obscure.

> +struct anatop_regulator_data {
> +	char name[80];

const char *.

> +	char *parent_name;

What's this?

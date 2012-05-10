Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2EJBMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:12:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42911 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2EJBMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:12:50 -0400
Message-ID: <4FAB15DB.5050702@googlemail.com>
Date: Thu, 10 May 2012 03:11:55 +0200
From: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] Common clock framework for external clock generators
Content-Type: multipart/mixed;
 boundary="------------080907030606010505070402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080907030606010505070402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

first of all I apologize for the quite long attachment but I think
it is useful for the following discussion.

I recently read about the newly introduced common clock framework (ccf)
and wondered if this could be also used for external, e.g. i2c attached,
clock generators.

Based on my current understanding of the framework I wrote such a
driver and now I want to present it here for clarification of some
remarks I have regarding the framework itself.

Please do not see this driver as mature but as some kind of
proof-of-concept. I have the driver somewhat running but stumbled
upon some issues.

First I want to give a brief overview of the intended use case of
this driver:

It is a driver for a clock generator that is externally attached to
a Marvell Dove (arm/mach-dove) SoC. It will provide driver configurable
clocks that are connected to dedicated clock inputs of the SoC, e.g.
external audio clock for i2s controller.

The basic intention I had in mind when writing this driver was to
add it during platform init and pass a list of clock aliases and clock
hierarchy description to allow the receiving driver, e.g. i2s, to set
the rate of the supplied clock without poking the clock generator
directly.

Please comment on the following aspects:
- there is no clk_unregister which is okay for platform clocks but
should be there since clock generators can be detached
- the clock generator has two plls and up to 8 clocks; inside the
clk_ops it is quite hard to find the correct struct clk_hw when
using container_of()
- most of clk_ops are spin-locked but i2c drivers tend to sleep
during read or write; this causes a "BUG: scheduling while atomic"

I know that ccf is quite new but it is well suited for generic,
i.e. platform independent, external clock generator drivers. Maybe
I got the overall concept just wrong but maybe this RFC helps
to straighten things up for future drivers.

Regards,
     Sebastian







--------------080907030606010505070402
Content-Type: text/x-csrc;
 name="clk-si5351.lkml.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="clk-si5351.lkml.c"

/*
 * clk-si5351.c: Silicon Laboratories Si5351A/B/C I2C Clock Generator
 *               (stripped for LKML discussion)
 */

struct si5351_driver_data {
	struct clk_hw		hw_xtal;
	struct clk_hw		hw_clkin;
	struct clk_hw		hw_vxco;
	struct clk_hw		hw_plla;
	struct clk_hw		hw_pllb;
	struct clk_hw		hw_clkout0;
	struct clk_hw		hw_clkout1;
	struct clk_hw		hw_clkout2;
	struct clk_hw		hw_clkout3;
	struct clk_hw		hw_clkout4;
	struct clk_hw		hw_clkout5;
	struct clk_hw		hw_clkout6;
	struct clk_hw		hw_clkout7;
	struct i2c_client	*client;
	unsigned long		fxtal;
	unsigned long		fclkin;
	u8                      variant;
	u8			clkmask;
};

static char* si5351_clkout_names[] = {
	"clkout0", "clkout1", "clkout2", "clkout3",
	"clkout4", "clkout5", "clkout6", "clkout7"};

/*
 * Si5351 helper
 */

static struct clk_hw *si5351_get_clkout_hw_from_num(struct si5351_driver_data* sidata, int num)
{
	switch(num) {
	case 0: return &sidata->hw_clkout0;
	case 1: return &sidata->hw_clkout1;
	case 2: return &sidata->hw_clkout2;
	case 3: return &sidata->hw_clkout3;
	case 4: return &sidata->hw_clkout4;
	case 5: return &sidata->hw_clkout5;
	case 6: return &sidata->hw_clkout6;
	case 7: return &sidata->hw_clkout7;
	}
	return NULL;
}

/*
 * Si5351 i2c register read/write
 */

static inline u8 si5351_reg_read(struct si5351_driver_data *data, u8 addr)
{
	return (u8)i2c_smbus_read_byte_data(data->client, addr);
}

static inline int si5351_regs_read(struct si5351_driver_data *data, u8 addr, u8 length, void *buf)
{
	return i2c_smbus_read_i2c_block_data(data->client, addr, length, buf);
}

static inline int si5351_reg_write(struct si5351_driver_data *data, u8 addr, u8 val)
{
	return i2c_smbus_write_byte_data(data->client, addr, val);
}

static inline int si5351_regs_write(struct si5351_driver_data *data, u8 addr, u8 length, const void *buf)
{
	return i2c_smbus_write_i2c_block_data(data->client, addr, length, buf);
}

/*
 * Si5351 xtal clock input
 */

static int si5351_xtal_enable(struct clk_hw *hw)
{
	struct si5351_driver_data *sidata = 
		container_of(hw, struct si5351_driver_data, hw_xtal);
	u8 reg;

	reg = si5351_reg_read(sidata, SI5351_FANOUT_ENABLE);
	reg |= SI5351_XTAL_ENABLE;
	si5351_reg_write(sidata, SI5351_FANOUT_ENABLE, reg);
	return 0;
}

static void si5351_xtal_disable(struct clk_hw *hw)
{
	struct si5351_driver_data *sidata = 
		container_of(hw, struct si5351_driver_data, hw_xtal);
	u8 reg;

	reg = si5351_reg_read(sidata, SI5351_FANOUT_ENABLE);
	reg &= ~SI5351_XTAL_ENABLE;
	si5351_reg_write(sidata, SI5351_FANOUT_ENABLE, reg);
}

static unsigned long si5351_xtal_recalc_rate(struct clk_hw *hw, 
					     unsigned long parent_rate)
{
	struct si5351_driver_data *sidata = 
		container_of(hw, struct si5351_driver_data, hw_xtal);
	return sidata->fxtal;
}

static const struct clk_ops si5351_xtal_ops = {
	.enable = si5351_xtal_enable,
	.disable = si5351_xtal_disable,
	.recalc_rate = si5351_xtal_recalc_rate,
};

/*
 * Si5351 pll a/b
 */
static struct si5351_driver_data *si5351_pll_get_data(struct clk_hw *hw)
{
	if (strncmp(hw->clk->name, "plla", 4) == 0)
		return container_of(hw, struct si5351_driver_data, hw_plla);
	return container_of(hw, struct si5351_driver_data, hw_pllb);
}

static u8 si5351_pll_get_parent(struct clk_hw *hw)
{
	struct si5351_driver_data *sidata = 
		container_of(hw, struct si5351_driver_data, hw_plla);
	u8 mask = (hw == &sidata->hw_plla) ? 
		SI5351_PLLA_SOURCE : SI5351_PLLB_SOURCE;
	u8 reg;

	if (sidata->variant != SI5351_VARIANT_C)
		return 0;
	
	reg = si5351_reg_read(sidata, SI5351_PLL_INPUT_SOURCE);

	return (reg & mask) ? 1 : 0;
}

static int si5351_pll_set_parent(struct clk_hw *hw, u8 index)
{
	struct si5351_driver_data *sidata = 
		container_of(hw, struct si5351_driver_data, hw_plla);
	u8 mask = (hw == &sidata->hw_plla) ? 
		SI5351_PLLA_SOURCE : SI5351_PLLB_SOURCE;
	u8 reg;

	if (sidata->variant != SI5351_VARIANT_C)
		return -EPERM;

	if (index > 1)
		return -EINVAL;

	reg = si5351_reg_read(sidata, SI5351_PLL_INPUT_SOURCE);
	if (index)
		reg |= mask;
	else
		reg &= ~mask;
	si5351_reg_write(sidata, SI5351_PLL_INPUT_SOURCE, reg);

	return 0;
}

static unsigned long si5351_pll_recalc_rate(struct clk_hw *hw,
					    unsigned long parent_rate)
{
	struct si5351_driver_data *sidata = si5351_pll_get_data(hw);
	struct si5351_parameters params;
	unsigned long m;
	unsigned long long rate;
	u32 p1, p2, p3;
	u8 addr = (hw == &sidata->hw_plla) ? SI5351_PLLA_PARAMETERS : SI5351_PLLB_PARAMETERS;

	si5351_regs_read(sidata, addr, SI5351_PARAMETERS_LENGTH, &params);

	p1 = ((params.p1_high    & 0x03) << 16) | (params.p1_mid << 8) | params.p1_low;
	p2 = ((params.p2_p3_high & 0x0f) << 16) | (params.p2_mid << 8) | params.p2_low;
	p3 = ((params.p2_p3_high & 0xf0) << 12) | (params.p3_mid << 8) | params.p3_low;

	if (p3 == 0)
		return 0;

	rate  = (p1*p3 + p2 + 512*p3);
	rate *= parent_rate;
	do_div(rate,p3);
	do_div(rate,128);

	return (unsigned long)rate;
}

static long si5351_pll_round_rate(struct clk_hw *hw, unsigned long rate,
				  unsigned long *parent_rate)
{
	struct si5351_driver_data *sidata = si5351_pll_get_data(hw);

	return rate;
}

static const struct clk_ops si5351_pll_ops = {
	.set_parent = si5351_pll_set_parent,
	.get_parent = si5351_pll_get_parent,
	.recalc_rate = si5351_pll_recalc_rate,
	.round_rate = si5351_pll_round_rate,
};

/*
 * Si5351 clkout
 */
static struct si5351_driver_data *si5351_clkout_get_data(struct clk_hw *hw)
{
	char index = hw->clk->name[6];
	switch(index) {
	case '0': return container_of(hw, struct si5351_driver_data, hw_clkout0);
	case '1': return container_of(hw, struct si5351_driver_data, hw_clkout1);
	case '2': return container_of(hw, struct si5351_driver_data, hw_clkout2);
	case '3': return container_of(hw, struct si5351_driver_data, hw_clkout3);
	case '4': return container_of(hw, struct si5351_driver_data, hw_clkout4);
	case '5': return container_of(hw, struct si5351_driver_data, hw_clkout5);
	case '6': return container_of(hw, struct si5351_driver_data, hw_clkout6);
	case '7': return container_of(hw, struct si5351_driver_data, hw_clkout7);
	}
	return NULL;
}

static int si5351_clkout_enable(struct clk_hw *hw)
{
	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
	return 0;
}

static void si5351_clkout_disable(struct clk_hw *hw)
{
	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
}

static int si5351_clkout_set_parent(struct clk_hw *hw, u8 index)
{
	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
	return 0;
}

static u8 si5351_clkout_get_parent(struct clk_hw *hw)
{
	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
	return 0;
}

static unsigned long si5351_clkout_recalc_rate(struct clk_hw *hw, 
					       unsigned long parent_rate)
{
	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
	return 0;
}

static long si5351_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
				     unsigned long *parent_rate)
{
	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
	return 0;
}

static const struct clk_ops si5351_clkout_ops = {
	.enable = si5351_clkout_enable,
	.disable = si5351_clkout_disable,
	.set_parent = si5351_clkout_set_parent,
	.get_parent = si5351_clkout_get_parent,
	.recalc_rate = si5351_clkout_recalc_rate,
	.round_rate = si5351_clkout_round_rate,
};

/*
 * Si5351 i2c probe
 */

static int si5351_probe(struct i2c_client *client,
			 const struct i2c_device_id *id)
{
	struct si5351_driver_data *sidata;
	struct si5351_clocks_data *drvdata = 
		(struct si5351_clocks_data *)client->dev.platform_data;

	sidata = kzalloc(sizeof(struct si5351_driver_data), GFP_KERNEL);
	if (sidata == NULL) {
		dev_err(&client->dev, "unable to allocate driver data\n");
		return -ENOMEM;
	}

	i2c_set_clientdata(client, sidata);
	sidata->client = client;
	sidata->fxtal = drvdata->fxtal;

	if (!clk_register(&client->dev, "xtal", &si5351_xtal_ops, 
			  &sidata->hw_xtal, NULL, 0, CLK_IS_ROOT)) {
		dev_err(&client->dev, "unable to register xtal\n");
		ret = -EINVAL;
		goto si5351_probe_error_register;
	}

	if (!clk_register(&client->dev, "plla", &si5351_pll_ops, 
			  &sidata->hw_plla, si5351_common_pll_parents, 
			  num_parents, 0)) {
		dev_err(&client->dev, "unable to register pll a\n");
		ret = -EINVAL;
		goto si5351_probe_error_register;
	}

	if (!clk_register(&client->dev, "pllb", &si5351_pll_ops, 
			  &sidata->hw_pllb, pll_parents, num_parents, 0)) {
		dev_err(&client->dev, "unable to register pll b\n");
		ret = -EINVAL;
		goto si5351_probe_error_register;
	}

	/* Disable interrupts */
	si5351_reg_write(sidata, SI5351_INTERRUPT_MASK, 0xf0);
	/* Set disabled output drivers to drive low */
	si5351_reg_write(sidata, SI5351_CLK3_0_DISABLE_STATE, 0x00);
	si5351_reg_write(sidata, SI5351_CLK7_4_DISABLE_STATE, 0x00);
	/* Disable outputs */
	si5351_reg_write(sidata, SI5351_OUTPUT_ENABLE_CTRL, 0xff);
	/* Power down output drivers */
	for(i=SI5351_CLK0_CTRL; i<=SI5351_CLK7_CTRL; i++)
		si5351_reg_write(sidata, i, SI5351_CLK_POWERDOWN);

	sidata->clkmask = 0x00;
	for(i=0; i<num_clocks; i++) {
		struct clk *clk;
		struct clk_lookup *cl;
		clk = clk_register(&client->dev, si5351_clkout_names[i], 
				   &si5351_clkout_ops, 
				   si5351_get_clkout_hw_from_num(sidata, i), 
				   si5351_common_clkout_parents, num_parents, 0);
		if (IS_ERR(clk)) {
			dev_err(&client->dev, "unable to register %s\n", 
				si5351_clkout_names[i]);
			ret = -EINVAL;
			goto si5351_probe_error_register;
		}
		cl = clkdev_alloc(clk, si5351_clkout_names[i], dev_name(&client->dev));
		if (cl)
			clkdev_add(cl);
	}

	drvdata->clkdev = &client->dev;
	for(i=0; i<drvdata->num_clocks; i++) {
		const struct si5351_clock_descr *descr = &drvdata->clocks[i];
		struct clk_hw *hw;
		u8 clkbit = (1 << descr->clkout);
		
		if (sidata->clkmask & clkbit) {
			dev_err(&client->dev, "slip already allocated clkout%d\n", 
				descr->clkout); 
			continue;
		}
		
		sidata->clkmask |= clkbit;

		hw = si5351_get_clkout_hw_from_num(sidata, descr->clkout);
		if (descr->pllmaster)
			hw->clk->flags |= CLK_SET_RATE_PARENT;

		switch(descr->clksrc) {
		case SI5351_CLKINSEL_PLLA:
			clk_set_parent(hw->clk, sidata->hw_plla.clk);
			break;
		case SI5351_CLKINSEL_PLLB:
			clk_set_parent(hw->clk, sidata->hw_pllb.clk);
			break;
		case SI5351_CLKINSEL_XTAL:
			clk_set_parent(hw->clk, sidata->hw_xtal.clk);
			break;
		}
		clk_add_alias(descr->alias, descr->alias_dev, 
			      hw->clk->name, &client->dev);
	}

	return 0;

si5351_probe_error_register:
	i2c_set_clientdata(client, NULL);
	kfree(sidata);
	return ret;
}

static int si5351_remove(struct i2c_client *client)
{
	struct si5351_driver_data *sidata = i2c_get_clientdata(client);
	i2c_set_clientdata(client, NULL);
	kfree(sidata);
	return 0;
}


--------------080907030606010505070402--

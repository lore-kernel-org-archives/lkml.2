Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2ENK0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:26:39 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:53880 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475Ab2ENK0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:26:38 -0400
Message-ID: <4FB0DDD7.8020803@slimlogic.co.uk>
Date: Mon, 14 May 2012 19:26:31 +0900
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] MFD: palmas PMIC device support
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk> <1336960712-2812-2-git-send-email-gg@slimlogic.co.uk> <20120514082832.GF31985@opensource.wolfsonmicro.com>
In-Reply-To: <20120514082832.GF31985@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/12 17:28, Mark Brown wrote:
> On Mon, May 14, 2012 at 10:58:29AM +0900, Graeme Gregory wrote:
>
>>  drivers/mfd/palmas-irq.c   |  241 +++++
> The IRQ support here seems to be following a pretty common pattern for
> dense IRQ maps - could we factor it out into regmap-irq?  It'd also be
> nice if it were using an irq_domain - while it's far from essential it
> is something Grant has been pushing and I believe it'll be required when
> you do device tree support.
>
The IRQ map is not dense. It is split into 4 registers which are not
contiguous. I think the overhead of translating to 4 reqmap irqs would
negate the point of using regmap irq. I can add to TODO to add this
handling to regmap_irq.

I am confused on the whole irq_domain business, is it replacement for
sparse irq? I don't see many users in drivers/mfd and not much
Documentation.

>> +	if (palmas->irq_mask != reg_mask) {
>> +		addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE,
>> +				PALMAS_INT1_MASK);
>> +		reg = palmas->irq_mask & 0xFF;
>> +		regmap_write(palmas->regmap[slave], addr, reg);
> This looks like you've open coded some regmap_update_bits() calls?
I did not notice this, but yes it could, I shall convert.

>> +	if (!palmas->irq_base) {
>> +		dev_warn(palmas->dev, "No interrupt support, no IRQ base\n");
>> +		return -EINVAL;
>> +	}
> If you use an irqdomain you can automatically allocate the interrupt
> range much more easily (even if you don't if you pass -1 as the base
> irq_alloc_descs() it's supposed to figure things out to you - it looks
> like you're not calling irq_alloc_decs()).
As you noticed later I put the irq_alloc_descs in the wrong location I
shall fix.
> With the irqdomain you should also find that as the interrupts are
> always registered (even if they can't fire) then you can just assume
> they're there in function drivers which makes the code simpler.
>
>> +	ret = request_threaded_irq(palmas->irq, NULL, palmas_irq, IRQF_ONESHOT,
>> +				   "palmas-irq", palmas);
>> +
>> +	irq_set_irq_type(palmas->irq, IRQ_TYPE_LEVEL_LOW);
> Why not just IRQF_TRIGGER_LOW?
I was copying the style from other MFD drivers, I this method seems the
more popular. I am not fixed on this style though so I will change.

>> +static const struct mfd_cell palmas_children[] = {
>> +};
> I'd just go ahead and fill this in, it makes merging much easier as the
> function drivers don't have a merge dependency on the core.
OK I shall do this!

>> +static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
>> +	{
>> +		.reg_bits = 8,
>> +		.val_bits = 8,
>> +		.cache_type = REGCACHE_NONE,
> Shouldn't need to explicitly set REGCACHE_NONE.  max_register might be
> useful to get you register dumps in debugfs.
Ok, I was just making it clear that I was not caching, I know that
NONE=0, I shall add the max_register fields though.

>> +	palmas = kzalloc(sizeof(struct palmas), GFP_KERNEL);
>> +	if (palmas == NULL)
>> +		return -ENOMEM;
> devm_kzalloc().
I had meant to do this, will fix.
>> +	ret = irq_alloc_descs(-1, 0, PALMAS_NUM_IRQ, 0);
>> +	if (ret < 0) {
>> +		dev_err(&i2c->dev, "failed to allocate IRQ descs\n");
>> +		goto err;
>> +	}
> Oh, here's the irq_alloc_descs() call - seems useful to put it in the
> generic irq init?
As noted yes wrong location, will fix.
>> +		palmas->regmap[i] = regmap_init_i2c(palmas->i2c_clients[i],
>> +				&palmas_regmap_config[i]);
> devm_regmap_init_i2c().
>
Will fix!
>> +static const struct i2c_device_id palmas_i2c_id[] = {
>> +	{ "palmas", PALMAS_ID_TWL6035 },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, palmas_i2c_id);
> I'd suggest also including the part names as an option (so having an
> entry for "twl6035") - makes life easier for users as they don't need to
> think about if the device is compatible.
Ok, I did have this then changed my mind, but I can add them back easy
enough.

>> +/* Bit definitions for MONTHS_REG */
>> +#define MONTHS_REG_MONTH1					0x10
>> +#define MONTHS_REG_MONTH1_SHIFT					4
>> +#define MONTHS_REG_MONTH0_MASK					0x0f
>> +#define MONTHS_REG_MONTH0_SHIFT					0
> Some of these registers should be namespaced (many are already).
I can do this, it will take some of the register definitions pretty
close to 72 chars though.

Thanks for taking time to review.

Graeme


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2ENI2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:28:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43562 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210Ab2ENI2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:28:36 -0400
Date: Mon, 14 May 2012 09:28:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] MFD: palmas PMIC device support
Message-ID: <20120514082832.GF31985@opensource.wolfsonmicro.com>
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
 <1336960712-2812-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Content-Disposition: inline
In-Reply-To: <1336960712-2812-2-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 10:58:29AM +0900, Graeme Gregory wrote:

>  drivers/mfd/palmas-irq.c   |  241 +++++

The IRQ support here seems to be following a pretty common pattern for
dense IRQ maps - could we factor it out into regmap-irq?  It'd also be
nice if it were using an irq_domain - while it's far from essential it
is something Grant has been pushing and I believe it'll be required when
you do device tree support.

> +	if (palmas->irq_mask != reg_mask) {
> +		addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE,
> +				PALMAS_INT1_MASK);
> +		reg = palmas->irq_mask & 0xFF;
> +		regmap_write(palmas->regmap[slave], addr, reg);

This looks like you've open coded some regmap_update_bits() calls?

> +	if (!palmas->irq_base) {
> +		dev_warn(palmas->dev, "No interrupt support, no IRQ base\n");
> +		return -EINVAL;
> +	}

If you use an irqdomain you can automatically allocate the interrupt
range much more easily (even if you don't if you pass -1 as the base
irq_alloc_descs() it's supposed to figure things out to you - it looks
like you're not calling irq_alloc_decs()).

With the irqdomain you should also find that as the interrupts are
always registered (even if they can't fire) then you can just assume
they're there in function drivers which makes the code simpler.

> +	ret = request_threaded_irq(palmas->irq, NULL, palmas_irq, IRQF_ONESHOT,
> +				   "palmas-irq", palmas);
> +
> +	irq_set_irq_type(palmas->irq, IRQ_TYPE_LEVEL_LOW);

Why not just IRQF_TRIGGER_LOW?

> +static const struct mfd_cell palmas_children[] = {
> +};

I'd just go ahead and fill this in, it makes merging much easier as the
function drivers don't have a merge dependency on the core.

> +static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
> +	{
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +		.cache_type = REGCACHE_NONE,

Shouldn't need to explicitly set REGCACHE_NONE.  max_register might be
useful to get you register dumps in debugfs.

> +	palmas = kzalloc(sizeof(struct palmas), GFP_KERNEL);
> +	if (palmas == NULL)
> +		return -ENOMEM;

devm_kzalloc().

> +	ret = irq_alloc_descs(-1, 0, PALMAS_NUM_IRQ, 0);
> +	if (ret < 0) {
> +		dev_err(&i2c->dev, "failed to allocate IRQ descs\n");
> +		goto err;
> +	}

Oh, here's the irq_alloc_descs() call - seems useful to put it in the
generic irq init?

> +		palmas->regmap[i] = regmap_init_i2c(palmas->i2c_clients[i],
> +				&palmas_regmap_config[i]);

devm_regmap_init_i2c().

> +static const struct i2c_device_id palmas_i2c_id[] = {
> +	{ "palmas", PALMAS_ID_TWL6035 },
> +};
> +MODULE_DEVICE_TABLE(i2c, palmas_i2c_id);

I'd suggest also including the part names as an option (so having an
entry for "twl6035") - makes life easier for users as they don't need to
think about if the device is compatible.

> +/* Bit definitions for MONTHS_REG */
> +#define MONTHS_REG_MONTH1					0x10
> +#define MONTHS_REG_MONTH1_SHIFT					4
> +#define MONTHS_REG_MONTH0_MASK					0x0f
> +#define MONTHS_REG_MONTH0_SHIFT					0

Some of these registers should be namespaced (many are already).

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsMIqAAoJEBus8iNuMP3dugsP/Rbt8Q9qpcZR4pqT5yJMRwwJ
LuqhoSQE1RVnCdtLw7xhDEHvIy4jpeJG8MBVKQRjtfmbQ+f09YLz6aJzzfH7qnqd
IDCgBl/AhUbX6Y7I41v0Lin+ofkwQ3GAoAbW5qzkOO9NjjgnVWgFWQRqiVcaVJxn
ym/+P5gDkXyqetLWOCT9htxbq6O277IpHromUr/zMrfHwVt4IKn5zXgbW3QNYisi
AaitiCVqnA3Dkv9SY9lPrvq6IIxI4L2NM12i0ULIO+Ms+I/WuKXRO2ExlkWOeFnm
bv2U17XXq5nlLhRcg1KRexQxjn0uO6GTg37LmrYfJ5/n9sqIaDtb1DiVzOxMe/NN
PEjEz2RkRpbdV0SzU/lLl+ReDGaUgm8XVbT8MiUIn6AuqbomWLBjyCbBhrylticL
j8YIdXxcGNijJvNKgWP76unFSCaW0C2FyoE+f5XpLHmKANWG8o1NsdyjVLnE0xdq
IHmfCRzXyMUeN/NMbYozQrHWUbWgX2gCPqRihfQgC2uNeDfT/Lgl64YhkMM52gki
6ECfVkoWe5afUim+xSBSttwb4H3WR0+pSeFewMFBn+k5PeKlxHJxxliDgjE+MpHA
NzporJAsFiRDUk0o4XS4LeHSUXdBk1v6E7zWXYfdjD1RbJL62IBAGqDgCMpR0id1
1cgigSA2TCa7S2NoUlpJ
=KOlP
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--

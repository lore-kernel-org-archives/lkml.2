Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2GZUf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:35:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418Ab2GZUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:35:55 -0400
Date: Thu, 26 Jul 2012 21:35:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
Message-ID: <20120726203526.GD4560@opensource.wolfsonmicro.com>
References: <1343331630-27126-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Content-Disposition: inline
In-Reply-To: <1343331630-27126-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 01:40:30PM -0600, Stephen Warren wrote:

> +struct max8907_irq_data {
> +	int	reg;
> +	int	mask_reg;
> +	int	offs;		/* bit offset in mask register */
> +	bool	is_rtc;
> +};

This (and all the code in here) looks very much like regmap-irq (or one
of the pre-regmap drivers I wrote which were factored out to there)...
why can't we use regmap_irq?

Looking at the code it looks like a very similar pattern to the arizona
chips where you've got two IRQ domains in the chip which can be handled
with a single virtual IRQ to do the demux.  We could factor that out
too easily enough, I might just do that...

> +		if (!irqd_irq_disabled(d) && (value & irq_data->offs)) {

This looks very suspicious...  why do we need to call
irqd_irq_disabled() here?

> +	regmap_write(chip->regmap_gen, MAX8907_REG_CHG_IRQ1_MASK, irq_chg[0]);
> +	regmap_write(chip->regmap_gen, MAX8907_REG_CHG_IRQ2_MASK, irq_chg[1]);
> +	regmap_write(chip->regmap_gen, MAX8907_REG_ON_OFF_IRQ1_MASK,
> +		     irq_on[0]);
> +	regmap_write(chip->regmap_gen, MAX8907_REG_ON_OFF_IRQ2_MASK,
> +		     irq_on[1]);
> +	regmap_write(chip->regmap_rtc, MAX8907_REG_RTC_IRQ_MASK, irq_rtc);

If you have the cache enabled regmap_update_bits() is your friend here,
it'll suppress duplicate I/O.

> +static void max8907_irq_enable(struct irq_data *data)
> +{
> +	/* Everything happens in max8907_irq_sync_unlock */
> +}

> +static void max8907_irq_disable(struct irq_data *data)
> +{
> +	/* Everything happens in max8907_irq_sync_unlock */
> +}

The fact that these functions are empty is the second part of the above
suspicous check for disabled IRQs.  We're just completely ignoring the
caller here.  What would idiomatically happen is that we'd update a
variable here then write it out in the unmask.

If these functions really should be empty then they should be omitted.

> +static int max8907_irq_set_wake(struct irq_data *data, unsigned int on)
> +{
> +	/* Everything happens in max8907_irq_sync_unlock */
> +
> +	return 0;
> +}

Again, this doesn't look clever at all.

> +		if (irqd_is_wakeup_set(d)) {
> +			/* 1 -- disable, 0 -- enable */
> +			switch (irq_data->mask_reg) {

This loop we should just port over into the regmap code.

> +static const struct regmap_config max8907_regmap_gen_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.volatile_reg = max8907_gen_is_volatile_reg,
> +	.writeable_reg = max8907_gen_is_writeable_reg,
> +	.max_register = MAX8907_REG_LDO20VOUT,
> +	.cache_type = REGCACHE_RBTREE,
> +};

Your IRQ registers appear to be clear on read which means you should
have a precious_reg callback too otherwise someone looking at the
register map in debugfs can ack interrupts.

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEan/AAoJEBus8iNuMP3dooIP/3M85KMd6fJayKtfy1+8Oz47
wgNuHGXnalcIJtFQcohpFCx8+sCmx7hg7QQeXZWENqxaK7TKZ9sIDwcuqfh3RkyE
Iei727sHU66xK1XUTenfInqwruur3yOKFuZLLMf0gyVu6sqarcvS4xfiDHrPROG3
PbD7aSIaGN8kFZyU6WCqtPdbL7ybBfcSm488rRFWH6hVTIHIHp03JWIa5wejI/jt
G6a+uCnZtLHXXPBXc/uj1t+nxoS7w+uLNRPDe9svA1/XqyWTLl1RIOlHOU82qUf1
mbzNm9Znz6cSjvO0uSiBfKl5XpyUPAD0vR/JNx7i4RBGAsHK79MYjhJ4PmATqJqy
g1yiZJ4TqHqDKvH8yv8xE0UJd4fF9eNIZyp4WQ0+by35Wir2Z1IRv+5G1yR//r2+
KCtf9G9leKZK/J+xnIBgZfRDtNL2eOgzQMHccJ+gB+ACJbXQzZ8pdDhn4Uh0HqS6
QkxsFHWCHbW6mFxwy9IBfSfMP5t6N8T8Pe/qb35HQiO7fjveb5pgTGjvUUFpC2W5
iog9gU1EKO6YVjXB7rghexmm6I1Ppd45d4ei8gBNnWG8CcAkSOl1b3unlnEywQKE
6RqjRIEu/BZJ6WPFAhP6WzS1Q9i1ANaT0mFCdz10vsHOszfGgPe7RwqOmTKoRVRH
P0eL0Y3HBfKNfX3jQGq2
=GN3A
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--

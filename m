Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2HUMmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:42:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52892 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2HUMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:42:11 -0400
Date: Tue, 21 Aug 2012 13:41:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20120821124146.GA21557@sirena.org.uk>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 04:15:37PM +0530, Sourav Poddar wrote:

> +config MFD_SMSC
> +       bool "Support for the SMSC ECE1099 series chips"
> +       depends on I2C=y && MFD_CORE && REGMAP_I2C

This needs to select REGMAP_I2C not depend on it.  REGMAP_I2C will only
be enabled by being selected.

> +int smsc_read(struct device *child, unsigned int reg,
> +	unsigned int *dest)
> +{
> +	struct smsc     *smsc = dev_get_drvdata(child->parent);
> +
> +	return regmap_read(smsc->regmap, reg, dest);
> +}
> +EXPORT_SYMBOL_GPL(smsc_read);

I'd suggest making these static inlines in the header given that they're
so trivial.

> +static struct regmap_config smsc_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +		.cache_type = REGCACHE_COMPRESSED,
> +};

Indentation is weird here.  For the cache we should have at least
.max_register defined and given the functionality there must surely be
some volatile registers (I'm surprised this works at all as it is, the
cache should break things).

> +	of_property_read_u32(node, "clock", &smsc->clk);
> +

This is all unconditional, there should be a dependency on this in
Kconfig.

> +	regmap_read(smsc->regmap, SMSC_DEV_ID, &ret);
> +	dev_dbg(&i2c->dev, "SMSC Device ID: %d\n", ret);

I'd make these log messages dev_info() or something.

> +err:
> +	kfree(smsc);

Use devm_kzalloc() for this.

> +static const struct i2c_device_id smsc_i2c_id[] = {
> +	{ "smsc", 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, smsc_i2c_id);

This should probably list the part name rather than "smsc" - that seems
far too generic a name to use, obviously smsc produce more than one
part!

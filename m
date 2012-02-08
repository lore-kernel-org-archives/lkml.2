Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2BHLlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:41:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40373 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150Ab2BHLlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:41:22 -0500
Date: Wed, 8 Feb 2012 11:41:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, jedu@slimlogic.co.uk,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1 1/2] mfd: tps65910: use regmap for device register
 access.
Message-ID: <20120208114120.GF3120@opensource.wolfsonmicro.com>
References: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Content-Disposition: inline
In-Reply-To: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2012 at 04:16:24PM +0530, Laxman Dewangan wrote:

> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	struct tps65910 *tps65910 = dev_get_drvdata(dev);
> +	return test_bit(reg, tps65910->cache_reg) ? false : true;
> +}

This is *really* odd.  Why is this not static data (or mostly static
data), why does it vary at runtime?

> +static bool regmap_volatile_range(struct tps65910 *tps65910,
> +			unsigned int reg, unsigned int bytes)
> +{
> +	unsigned int i;
> +	for (i = 0; i < bytes; i++)
> +		if (!is_volatile_reg(tps65910->dev, reg + i))
> +			return false;
> +	return true;
> +}

I don't think this should be here (the naming is a bit of a clue - it's
named like a core function), see below where you're using it...

> +	unsigned char *wbuf = src;
> +	unsigned int ival;
> +
> +	if (regmap_volatile_range(tps65910, reg, bytes))
> +		return regmap_raw_write(tps65910->regmap, reg, src, bytes);
> +
> +	/* If any of register is non-volatile then use byte-wise transfer */
> +	for (i = 0; i < bytes; ++i) {
> +		ival = (unsigned int) (*wbuf++);
> +		ret = regmap_write(tps65910->regmap, reg, ival);
> +		if (ret < 0)
> +			return ret;
> +	}

There's nothing specific to the driver about this, if this is a good
idea add support for it to the core.

> +void tps65910_enable_reg_cache(struct tps65910 *tps65910, int reg)
> +{
> +	set_bit(reg, tps65910->cache_reg);
> +}
> +EXPORT_SYMBOL_GPL(tps65910_enable_reg_cache);

Why are you doing this?  This looks very icky, and if it is needed there
needs to be more code here to make sure the register cache and device
are in sync.

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMl9ZAAoJEBus8iNuMP3dWm0P/07RW2USrlt6KRqEVbGYSVQB
nl3BKqCYUFup+jQV/Hcyz+4f6i2dfbVANZu60EaK0fQ/xa4FmQ444rrTxDdXaH/W
yfEPS0wtSZnfP+RO05snjBWkqd4e1MT6XrOw4j7pT96wbzn0TiVa0slGz3AfQGGg
FoMnceEKKrgtpIamOazHZ35SgQ/h9J/IS4PARO4WBVSAMX7hCKMGcrfGMTzJhOtP
HhdSTvrV7r350JElh4DUNZIzPlqh6e/Gwb07ckVS6ae36DEnugbg72KC6lmFNGmC
g9XbcIZPzEzP0NMUFB04yGX/oJcrvksf7PLi/Zl8mLEDsr5AlhQpRdDxQYUkVcdt
rLFOwedE/+W7zpzU2k5RCSaaMN2zeGg7+LW934/MXEl2nraA97dxV/cCKQsRt70j
WEE0GaQCdWaJSEQLPOSPsPOW8VPxPKiGdVQnKKFGuNxMAcxz17NUpRP4De+hn+mv
e9vgC8q6ABECjPf4lNfVv3vrFCz8uqL3u6QRt4XRssDmtsF895L0WOc0WzPJbJzA
nCGwOxgIGVyUNxws/4XFvLNV8IA/zz653E1YSamE3VeLgovnfjbGYV8UafoBgn7c
Gu2ZuBFHVF5DtXX8BxG9XBcaiWcOue3jZAHA1p98GZ1Vj5zWQBl87CRfh9/XVDCF
j1QA5DinEhT/W4Q9Grb/
=jAVZ
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--

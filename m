Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2DTLmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:42:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50454 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab2DTLmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:42:06 -0400
Date: Fri, 20 Apr 2012 12:42:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Robin Gong <B38343@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] regulator: Add Freescale's MC34708 regulators
Message-ID: <20120420114201.GA3259@opensource.wolfsonmicro.com>
References: <1334853521-23792-1-git-send-email-paul.liu@linaro.org>
 <1334853521-23792-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1334853521-23792-2-git-send-email-paul.liu@linaro.org>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 12:38:41AM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +static const int mc34708_sw1A[] = {
> +	650000, 662500, 675000, 687500, 700000, 712500,

Replace these by direct calculations, using tables is both less
efficient and less clear.

> +	mc34708_lock(priv->mc34708);
> +	ret = mc34708_reg_rmw(priv->mc34708, mc34708_regulators[id].reg,
> +			      mc34708_regulators[id].enable_bit,
> +			      mc34708_regulators[id].enable_bit);
> +	mc34708_unlock(priv->mc34708);

Having to open code this locking in every single driver is a bit
painful; just have the default register I/O operations do the locking
and introduce additional unlocked versions if needed.

All this stuff could be factored out if you were using regmap.

> +EXPORT_SYMBOL_GPL(mc34708_regulator_list_voltage);

No, this stuff should only be accessed via the ops.  Why are you doing
this?

> +int
> +mc34708_get_best_voltage_index(struct regulator_dev *rdev,
> +			       int min_uV, int max_uV)
> +{

You're reimplementing core functionality here, or it'd be even better to
use calculations.

> +static int mc34708_regulator_get_voltage(struct regulator_dev *rdev)
> +{

Why is this not get_voltage_sel?

> +static struct regulator_ops mc34708_regulator_ops = {
> +	.enable = mc34708_regulator_enable,
> +	.disable = mc34708_regulator_disable,
> +	.is_enabled = mc34708_regulator_is_enabled,
> +	.list_voltage = mc34708_regulator_list_voltage,
> +	.set_voltage = mc34708_regulator_set_voltage,
> +	.get_voltage = mc34708_regulator_get_voltage,
> +};
> +EXPORT_SYMBOL_GPL(mc34708_regulator_ops);

No.  What are you doing this for?

> +int
> +mc34708_fixed_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
> +				    int max_uV, unsigned *selector)

This function makes no sense...

> +int mc34708_sw_regulator_is_enabled(struct regulator_dev *rdev)
> +{
> +	return 1;
> +}

Why are you doing this - this function is redundant.

> +	ret = mc34708_reg_rmw(mc34708, MC34708_SW12OP,
> +			      MC34708_SW12OP_SW1AMODE_M |
> +			      MC34708_SW12OP_SW2MODE_M,
> +			      MC34708_SW12OP_SW1AMODE_VALUE |
> +			      MC34708_SW12OP_SW2MODE_VALUE);
> +	if (ret)
> +		goto err_free;
> +
> +	ret = mc34708_reg_rmw(mc34708, MC34708_SW345OP,
> +			      MC34708_SW345OP_SW3MODE_M |
> +			      MC34708_SW345OP_SW4AMODE_M |
> +			      MC34708_SW345OP_SW4BMODE_M |
> +			      MC34708_SW345OP_SW5MODE_M,
> +			      MC34708_SW345OP_SW3MODE_VALUE |
> +			      MC34708_SW345OP_SW4AMODE_VALUE |
> +			      MC34708_SW345OP_SW4BMODE_VALUE |
> +			      MC34708_SW345OP_SW5MODE_VALUE);
> +	if (ret)
> +		goto err_free;

If this needs to be done unconditionally shouldn't it be being donei in
the MFD core driver?

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkUuCAAoJEBus8iNuMP3dpHoP/RfWxdE4EeESW2TBK3zqrEsL
INF9HYlGUItXLC5QvI3dd15qOSUvsh9VjTOL3Q30p7gUBoiSXdjymFXxWPaBHHsS
l+8J1r9b2fMIbd/6QcgDUwT8jkmURL6r5jnw4NltbiwJN+Dc3X//qNOHItZrhnqw
56+W2RgXoLfzQvOjshJwU+p7S1JMNLt1QMD8r0iXpEuVQ5kzoASyYO2Kg6qddWl4
e2ZrzNq5DctbKbYvICFmWBsARWuVrzOPbha4ZTKfJtDT0HVQ0f4LDCkrUeuIU6Xg
aPYQ2fAXS6QJzGmjDLOLfEOdVtmPxSiiox4MEOyhjq7STRnZylIVCZs81e18psBo
QZaSppxKtjH6OZANjok2vStS6xjX9eyotPiTjx2x5CyP/u+CvRGy99qHoMjwd0vE
gyF38DDneTuPCuBzIK1HAoDKE0tad2Q3ULJl453osfI2CskXH6EiRDeSkbkjwx7B
4O3XshOyEkcYOaXm9rXvK5Q+Pk0UOKa/4OIbY8JvuMdIxPD0O7dv/1F5jcWH87z9
Rs2pXpsNx6J6y/M/kU2CnRC/aSOABZ3QNkPDwwRBKptjnguueIKisRxHn1bZNM1C
erQW86niU9nyDTcy7cEza48ExI3+3wG6pCDNbDqflFX8paiC5JnDFj/xLTZakOE1
kDBV8z93kDyYi4Z3o3Kx
=vCMK
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

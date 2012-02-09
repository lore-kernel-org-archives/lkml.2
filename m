Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2BILYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:24:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45826 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab2BILYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:24:42 -0500
Date: Thu, 9 Feb 2012 11:24:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, eric.miao@linaro.org,
        shawn.guo@linaro.org, Nancy Chen <Nancy.Chen@freescale.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v4 2/2] Regulator: Add Anatop regulator driver
Message-ID: <20120209112439.GC3058@opensource.wolfsonmicro.com>
References: <1328734286-30091-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <1328734286-30091-2-git-send-email-paul.liu@linaro.org>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 04:51:26AM +0800, Ying-Chun Liu (PaulLiu) wrote:

Overall this is looking pretty good, a few issues but relatively minor.

> +	if (uv < anatop_reg->rdata->min_voltage
> +	    || uv > anatop_reg->rdata->max_voltage) {
> +		if (max_uV > anatop_reg->rdata->min_voltage)
> +			uv = anatop_reg->rdata->min_voltage;
> +		else
> +			return -EINVAL;
> +	}

This looks buggy (and is quite hard to follow).  The check for the
voltage being above the minimum voltage is fine but surely if the
voltage is too high then the first if statement will be true and max_uV
will be greater than the minimum voltage so the second if will be true.
This will cause us to choose the minimum voltage that the regulator can
do which is less than the minimum voltage requested.

You probably shouldn't be checking for the upper end of the range at all
here...

> +	if (anatop_reg->rdata->control_reg) {
> +		sel = (uv - anatop_reg->rdata->min_voltage) / 25000;
> +		val = anatop_reg->rdata->min_bit_val + sel;
> +		*selector = sel;
> +		pr_debug("%s: calculated val %d\n", __func__, val);

...instead check that selector is in range here.

> +		anatop_reg->rdata->mfd->write(anatop_reg->rdata->mfd,
> +					      anatop_reg->rdata->control_reg,
> +					      anatop_reg->rdata->vol_bit_shift,
> +					      anatop_reg->rdata->vol_bit_size,
> +					      val);

Just have a write() function in the MFD.

> +	memset(rdesc, 0, sizeof(struct regulator_desc));
> +	rdesc->name = kstrdup(of_get_property(np, "regulator-name", NULL),
> +			      GFP_KERNEL);

You should add binding documentation for the device since it's OF based.

> +	sreg->rdata->name = kstrdup(rdesc->name, GFP_KERNEL);

Can't you just point to rdesc->name?

> +	if (IS_ERR(rdev)) {
> +		dev_err(&pdev->dev, "failed to register %s\n",
> +			rdesc->name);
> +		return PTR_ERR(rdev);
> +	}

All your kstrdup()s need to be unwound in error and free cases.

> +int anatop_regulator_init(void)
> +{
> +	return platform_driver_register(&anatop_regulator);
> +}
> +
> +void anatop_regulator_exit(void)
> +{
> +	platform_driver_unregister(&anatop_regulator);
> +}
> +
> +postcore_initcall(anatop_regulator_init);
> +module_exit(anatop_regulator_exit);

These should be adjacent to the functions.

> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");

Either omit this or put one or more humans as the author.

> +struct anatop_regulator {
> +       struct regulator_desc *regulator;
> +       struct regulator_init_data *initdata;
> +       struct anatop_regulator_data *rdata;
> +};

May as well just merge the regulator data in here - it's not ever used
except with a 1:1 relationship between them.  Could also directly
embed the desc and init_data, then you just have one allocation for the
data rather than a series to error check.

> +int anatop_register_regulator(
> +		struct anatop_regulator *reg_data, int reg,
> +		      struct regulator_init_data *initdata);

This looks like it's not defined any more so could be removed and since
you only appear to support OF the entire header could be merged into the
driver.

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM6zuAAoJEBus8iNuMP3du/sP/RjXrNGqGGaT1qiMN5Vm6Su+
CaF6oLok6m+rFv3Q6a1dKUXoouVnkudialT+N1zxHDZoQENR+LVht/5sOcM7Cxwf
z0VUSjzgjUtOZLbomigA5g5zMK5DAlXzGs3RTGlKWn3SE16AY7yP1SX7/7nEHFJp
kbJqQkc75FNsiKLgbBXvevyyp+br9jm8l5innrgfu+N7hE3pGU05emTFK9Ok3Qaf
hpXnHkwOzVkG9sW8vOJIAriw1SuZpgPFiEnMLwhx8qUy0fcFURwicWTqg30+1JH2
0O2GsbdnlBRLf9HVS/5PTCYmHBz4ysBq0kXn+CT3xE720WtQne9uusiRTxTFYAN/
BgC6Mo8x6pqPQJfYmF2Y2+lNJVKcZVblS4G1rYusKgB0GUAKRB+snd8k3fJ4clF+
bm0L+6MhHhVsTFesiTovASDi6ML2ESqcov2XMHUEMVWXbLzdRBSuFERxEGyaBOzB
f1L3y3LAytfYt2S9rICFmq9QNr3/YUfY0KiEDPnpWw7AkS5Dlripz7nzwdP0e4HY
WeDgOzpwXx0SUs7CKLAY4Z9cxXhwIPgwce/SNA0mJtEKDzhpystwlyPgKmUCsKF3
PdT30vmtCatS70Aa92MrL5Ec57EL4uoKyt0mfRTW81Whnb29xV/w1LfuuvGCqw/O
5L+wtsCycu1p0Yh4ddTd
=RaNE
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--

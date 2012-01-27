Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2A0RIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:08:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50578 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab2A0RIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:08:00 -0500
Date: Fri, 27 Jan 2012 17:07:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, jedu@slimlogic.co.uk, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3] regulator: tps65910: Sleep control through external
 inputs
Message-ID: <20120127170757.GD18572@opensource.wolfsonmicro.com>
References: <1327506510-15948-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <1327506510-15948-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2012 at 09:18:30PM +0530, Laxman Dewangan wrote:

> +static int tps65910_set_suspend_enable(struct regulator_dev *dev)
> +{
> +	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
> +	int id = rdev_get_id(dev);
> +	/*
> +	 * If regulator is controlled through external control then
> +	 * it can be enable/disable by toggling external signal.
> +	 */
> +	if (pmic->board_ext_control[id])
> +		return 0;
> +	else
> +		return tps65910_set_mode(dev, REGULATOR_MODE_NORMAL);
> +}

I'm really confuseed now.  This definitely looks like it's doing the
wrong thing for the non-ext_control case, it's setting the mode which
really isn't what this is supposed to do and collides with any actual
configuration of the mode that might happen...

> +	/*
> +	 * Keep the regulator in OFF state if it needs to be disable
> +	 * in suspend state.
> +	 */
> +	if (pmic->board_ext_control[id]) {
> +		u8 regoffs = (pmic->ext_sleep_control[id] >> 8) & 0xFF;
> +		u8 bit_pos = (1 << pmic->ext_sleep_control[id] & 0xFF);
> +		int ret;
> +		ret = tps65910_clear_bits(mfd,
> +			TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
> +		if (!ret)
> +			ret = tps65910_set_bits(mfd,
> +				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
> +		if (ret < 0)
> +			dev_err(mfd->dev,
> +				"Error in configuring SLEEP register\n");

...and I'd really expect something that reverses these changes?

The actual bits setting up the ext_control look OK - can you split those
off from the bits implementing the suspend mode callbacks please so they
can be applied while the callbacks are reviewed?

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPItnhAAoJEBus8iNuMP3ddbIQAIuUrG6usBhEGEmnFwRpijCR
1VQvuU0ZLOQajh379z+CG4yuClrLLaoaUB7XQAeUEbpYlSY6Gp8RkE85/R+pNbde
FsdIxdfM7fOOLG6HD2OL3bGiFeZzPZKM0DZXoIXIzLorInZnYEyAH5DAwY6/v6IJ
508TWBEEbvDSaz/+UrxkG4X7UP+Cxk89jF5bNVscwDO2n4EGGxEx9pKy90DgfjnZ
O4WqVuNIi5kP4V6265Qo345bq67De6v5Fqf4qrNbUvL/QWxRONCRlklYrHVnRCIE
9Ibeh4ai4I0jGXVDSfC0syCW/Hm5/aZqWJ3XfHITxc0UnDg+JeDJ25XYyZ++4ZKI
opVszVotqa+3zMNcvKZrS9+vYy89y+Cp8IhPy/fdZpFeTWsL7QAsZfF/X/utOhaM
4RvmzpaEfXEIcSaShMErsH28FphWG1gTVjPwA5bNxPMzKKAHXv+EIVIG/6g0twtP
qqdNL7We5OAyZBNw/HV3a41jpWF3HMPJbfvUJPnlulRjVrJfFVuLTDqv3vrpTkyO
EEAz5vKXivzXYNDrxzdD6HL0ASf76wuWJuwG0sZYsRLC3ykSg+QR/4sJPuKh1JQC
XmspSxaDOZwpFv80hdRC3Oka3W+buyVlPkZz2hp1yB5IC8LraSB/EMAXoDyumMCl
+xse1zTd8+1wdjRSt1nq
=J5vm
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--

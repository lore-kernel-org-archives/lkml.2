Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0HRKbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:31:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53926 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0HRKbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:31:39 -0400
Date: Wed, 18 Aug 2010 12:31:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC] gpio/stmpe: add bitmask to block requests to unavailable
 GPIOs
Message-ID: <20100818103137.GB3528@pengutronix.de>
References: <1281971684-16505-1-git-send-email-w.sang@pengutronix.de>
 <20100818100950.GA19706@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <20100818100950.GA19706@bnru01.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 18, 2010 at 03:39:50PM +0530, Rabin VINCENT wrote:
> On Mon, Aug 16, 2010 at 17:14:44 +0200, Wolfram Sang wrote:
> > GPIOs on these controller are multi-functional. If you decided to use
> > some of them e.g. as input channels for the ADC, you surely don't want
> > those pins to be reassigned as simple GPIOs (which may be triggered even
> > from userspace via 'export'). Same for the touchscreen controller pins.
> > Since knowledge about the hardware is needed to decide which GPIOs to
> > reserve, let this bitmask be inside platform_data and provide some
> > defines to assist potential users.
>=20
> Could this be done without the platform data, say something like the
> below?  (Though this does assume that nobody tries to request GPIOs
> before the STMPE subdrivers reserve their pins.)
>=20

While I'd also like to skip the additional platform_data entry, your
last comment is in deed a drawback. Also, when thinking of a generic
solution (ADC comes to my mind), you can't make an assumption which pins
will have the alternate function as you can do with the touchscreen
driver. If a pin is an ADC-input channel or a GPIO, that is board
design.

Regards,

   Wolfram

> diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchsc=
reen/stmpe-ts.c
> index 656148e..d1595f9 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -179,6 +179,12 @@ static int __devinit stmpe_init_hw(struct stmpe_touc=
h *ts)
>  		return ret;
>  	}
> =20
> +	ret =3D stmpe_set_altfunc(stmpe, 0xf0, STMPE_BLOCK_TOUCHSCREEN);
> +	if (ret) {
> +		dev_err(dev, "Could not enable alternate function for pins\n");
> +		return ret;
> +	}
> +
>  	adc_ctrl1 =3D SAMPLE_TIME(ts->sample_time) | MOD_12B(ts->mod_12b) |
>  		REF_SEL(ts->ref_sel);
>  	adc_ctrl1_mask =3D SAMPLE_TIME(0xff) | MOD_12B(0xff) | REF_SEL(0xff);
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index 0754c5e9..4f748fa 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -253,6 +253,12 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins,=
 enum stmpe_block block)
> =20
>  	mutex_lock(&stmpe->lock);
> =20
> +	if (block =3D=3D STMPE_BLOCK_GPIO && (pins & stmpe->af_pins)) {
> +		dev_dbg(stmpe->dev, "not allowing change of AF pins to GPIO\n");
> +		ret =3D -EBUSY;
> +		goto out;
> +	}
> +
>  	ret =3D __stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
>  	if (ret < 0)
>  		goto out;
> @@ -274,6 +280,11 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins,=
 enum stmpe_block block)
>  		pins &=3D ~(1 << pin);
>  	}
> =20
> +	if (block =3D=3D STMPE_BLOCK_GPIO)
> +		stmpe->af_pins &=3D ~pins;
> +	else
> +		stmpe->af_pins |=3D pins;
> +
>  	ret =3D __stmpe_block_write(stmpe, regaddr, numregs, regs);
> =20
>  out:
> diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
> index 39ca758..ba5a847 100644
> --- a/include/linux/mfd/stmpe.h
> +++ b/include/linux/mfd/stmpe.h
> @@ -64,6 +64,7 @@ struct stmpe_variant_info;
>   * @num_gpios: number of gpios, differs for variants
>   * @ier: cache of IER registers for bus_lock
>   * @oldier: cache of IER registers for bus_lock
> + * @af_pins: mask of pins set in alternate function mode
>   * @pdata: platform data
>   */
>  struct stmpe {
> @@ -79,6 +80,7 @@ struct stmpe {
>  	int num_gpios;
>  	u8 ier[2];
>  	u8 oldier[2];
> +	u32 af_pins;
>  	struct stmpe_platform_data *pdata;
>  };
> =20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxrtokACgkQD27XaX1/VRtcegCgxLe5RfT4AOTjLDb0uMITP4rz
krEAn1wcWgwcV6vQYEXsP43P/ALskCe3
=iZVF
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--

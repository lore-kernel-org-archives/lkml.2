Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2K1TbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:31:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2K1TaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:30:18 -0500
Date: Wed, 28 Nov 2012 20:30:06 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
Message-ID: <20121128193006.GB23444@avionic-0098.adnet.avionic-design.de>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
 <20121123075537.A14713E0A91@localhost>
 <50AF3E21.4000009@ti.com>
 <50AF4584.7020604@ti.com>
 <20121126154600.765E03E1AFD@localhost>
 <50B5D161.6010200@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <50B5D161.6010200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:LmWnLJz/oo9ybPISmrl5ktx9Rybo/HOWLqZpwCicRI1
 nJCWgR+P4Iu4ebvfQYDwJj11Xdpu6SgxRKTlJAmpr4y15JhCpU
 DueZtvBMNVa3uC4BunEhrT6wFMubeK6hXo1eZuk/RqQEpedEuU
 QhPqhyVStI4SJgBlta2Op5ZXPNAQZyVp5UF8xAolb+ZELFz8Er
 CvDoYvIyh+DqWPZwRWwYG6vmBBwmWe6uSCRnpnnIB3IajSGbjA
 irRbjdjSdo2Wa2dmDc0S/4pae4+/f/f3wN2oyj41ZnBNu43Hlc
 Io6952HSZUShU+FQje0s7j6aqV6OqyxMrGVp9S50jdvQqpiNRy
 heBiudlPD44VrZQ+g1ImesS9PdvnfO+6pdIYi/QVl7qlD61d7O
 fuiF0xS7+tNU7kItcBCbTqefAZ7tk8pSkI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 09:54:57AM +0100, Peter Ujfalusi wrote:
> Hi Grant, Lars, Thierry,
>=20
> On 11/26/2012 04:46 PM, Grant Likely wrote:
> > You're effectively asking the pwm layer to behave like a gpio (which
> > is completely reasonable). Having a completely separate translation node
> > really doesn't make sense because it is entirely a software construct.
> > In fact, the way your using it is *entirely* to make the Linux driver
> > model instantiate the translation code. It has *nothing* to do with the
> > structure of the hardware. It makes complete sense that if a PWM is
> > going to be used as a GPIO, then the PWM node should conform to the GPIO
> > binding.
>=20
> I understand your point around this. I might say I agree with it as well.=
=2E.
> I spent yesterday with prototyping and I'm not really convinced that it i=
s a
> good approach from C code point of view. I got it working, yes.
> In essence this is what I have on top of the slightly modified gpio-pwm.c
> driver I have submitted:
>=20
> DTS files:
> twl_pwm: pwm {
> 	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
> 	compatible =3D "ti,twl6030-pwm";
> 	#pwm-cells =3D <2>;
>=20
> 	/* Enable GPIO us of the PWMs */
> 	gpio-controller =3D <1>;
> 	#gpio-cells =3D <2>;
> 	pwm,period_ns =3D <7812500>;
> };
>=20
> leds {
> 	compatible =3D "gpio-leds";
> 	backlight {
> 		label =3D "omap4::backlight";
> 		gpios =3D <&twl_pwm 1 0>; /* PWM1 of twl6030 */
> 	};
>=20
> 	keypad {
> 		label =3D "omap4::keypad";
> 		gpios =3D <&twl_pwm 0 0>; /* PWM0 of twl6030 */
> 	};
> };
>=20
> The bulk of the code in drivers/pwm/core.c to create the pwm-gpo device w=
hen
> it is requested going to look something like this. I have removed the err=
or
> checks for now and I still don't have the code to clean up the allocated
> memory for the created device on error, or in case the module is unloaded=
=2E We
> should also prevent the pwm core from removal when the pwm-gpo driver is =
loaded.
> We need to create the platform device for gpo-pwm, create the pdata struc=
ture
> for it and fill it in. We also need to hand craft the pwm_lookup table so=
 we
> can use pwm_get() to request the PWM. I have other minor changes around t=
his
> to get things working when we booted with DT.
> So the function to do the heavy lifting is something like this:
> static void of_pwmchip_as_gpio(struct pwm_chip *chip)
> {
> 	struct platform_device *pdev;
> 	struct gpio_pwm *gpos;
> 	struct gpio_pwm_pdata *pdata;
> 	struct pwm_lookup *lookup;
> 	char gpodev_name[15];
> 	int i;
> 	u32 gpio_mode =3D 0;
> 	u32 period_ns =3D 0;
>=20
> 	of_property_read_u32(chip->dev->of_node, "gpio-controller",
> 			     &gpio_mode);
> 	if (!gpio_mode)
> 		return;
>=20
> 	of_property_read_u32(chip->dev->of_node, "pwm,period_ns", &period_ns);
> 	if (!period_ns) {
> 		dev_err(chip->dev,
> 			"period_ns is not specified for GPIO use\n");
> 		return;
> 	}
>=20
> 	lookup =3D devm_kzalloc(chip->dev, sizeof(*lookup) * chip->npwm,
> 			      GFP_KERNEL);
> 	pdata =3D devm_kzalloc(chip->dev, sizeof(*pdata), GFP_KERNEL);
> 	gpos =3D devm_kzalloc(chip->dev, sizeof(*gpos) * chip->npwm,
> 			    GFP_KERNEL);
>=20
> 	pdata->gpos =3D gpos;
> 	pdata->num_gpos =3D chip->npwm;
> 	pdata->gpio_base =3D -1;
>=20
> 	pdev =3D platform_device_alloc("pwm-gpo", chip->base);
> 	pdev->dev.parent =3D chip->dev;
>=20
> 	sprintf(gpodev_name, "pwm-gpo.%d", chip->base);
> 	for (i =3D 0; i < chip->npwm; i++) {
> 		struct gpio_pwm *gpo =3D &gpos[i];
> 		struct pwm_lookup *pl =3D &lookup[i];
> 		char con_id[15];
>=20
> 		sprintf(con_id, "pwm-gpo.%d", chip->base + i);
>=20
> 		/* prepare GPO information */
> 		gpo->pwm_period_ns =3D period_ns;
> 		gpo->name =3D kmemdup(con_id, sizeof(con_id), GFP_KERNEL);;
>=20
> 		/* prepare pwm lookup table */
> 		pl->provider =3D dev_name(chip->dev);
> 		pl->index =3D i;
> 		pl->dev_id =3D kmemdup(gpodev_name, sizeof(gpodev_name),
> 				     GFP_KERNEL);
> 		pl->con_id =3D kmemdup(con_id, sizeof(con_id), GFP_KERNEL);
> 	}
>=20
> 	platform_device_add_data(pdev, pdata, sizeof(*pdata));
> 	pwm_add_table(lookup, chip->npwm);
> 	platform_device_add(pdev);
> }
>=20
> PS: as I have said I have removed the error check just to make the code
> snippet more readable and yes we need to do some memory cleanup as well a=
t the
> right time.
>=20
> Is this something you would like to see?

I must say I'm not terribly thrilled to integrate something like this
into the PWM subsystem. I wish hardware engineers wouldn't come up with
such designs. But since this seems to be a real use-case, if we want to
support it we should try and find the "right" solution.

Reading the above sounds overly complicated. Couldn't we, instead of
instantiating an extra driver, just register a GPIO chip if a chip wants
to support this functionality? Where the GPIO chip's request callback
requests the given PWM so that it cannot be used elsewhere? The
direction_input callback would need to always fail and the set callback
can configure the PWM either to 0% or 100% duty-cycle depending on the
desired output value.

Thierry

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtmY+AAoJEN0jrNd/PrOh0LMP/24mTk439aV5wWT76vFQS5of
Yk/TixVrQNJ9wiedemQoRZK+p+R/+pcn1teemKshW7HqaRdqNevQ5CLuRvQZc9ie
TEmVJe0YN/GbdO8OtgEwthNXvYQw73D+O5QLt3Egc5rxAng8i4cAnvCpewJOhxIq
QKwJLVMXFC+66F768nvxeyRBV8PLc260WSsh0ZLVRDUGTk7FD7+4TqE98DfTEkKn
OYiejdcLS0XhTidvhA6WbUizUopWdqjCyV5SSEywhMDgFxdUMi2R2e4ALszm5iE6
ZRFm3OzzR6dgUxKUX6ObZY+rCE2B/x40JF9IytqFMY+XM9RNntek74XjDfkMSL9D
MZpKGiZZ5snA0IzqGq25tfvNkOdYYpk7v119ocSJHa6fm1OTGm4qCqwiffhUCxax
TsRgbJ1M3tB5YrIDtw+3+paHf1Hc9MIrMmdYbg40zBuXb2uXjLzn5VI9PScUSAKF
f+fiAoh4oVtwV6wvpZ7F+AOOZOU+5m1aWPdrkrzGT54JzWAoo24Ib41yJOD2WN11
vfxIj6TPm2exBY8krSfvrh9anF7seW4rLebA7qvr9F1bivl3ZMF8CBTnu/eMC+y1
mHx4dvHE3DggmGfWA7VE7XfCTeVEcNL10N6LmCGEn6z6BBffC1+qOyrH4hgyDYYe
E30w/w1ezQZFkqoV5Jjf
=g5ex
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--

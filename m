Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2JVHsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:48:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59227 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2JVHsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:48:04 -0400
Date: Mon, 22 Oct 2012 10:42:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [PATCH] i2c: omap: adopt pinctrl support
Message-ID: <20121022074201.GW14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350401000-9453-1-git-send-email-s-guiriec@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <1350401000-9453-1-git-send-email-s-guiriec@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 16, 2012 at 05:23:20PM +0200, Sebastien Guiriec wrote:
> Some GPIO expanders need some early pin control muxing. Due to
> legacy boards sometimes the driver uses subsys_initcall instead of
> module_init. This patch takes advantage of defer probe feature
> and pin control in order to wait until pin control probing before
> GPIO driver probing. It has been tested on OMAP5 board with TCA6424
> driver.
>=20
> log:
>=20
> [0.482299] omap_i2c i2c.15: could not find pctldev for node /ocp/pinmux@4=
a00
> 2840/pinmux_i2c5_pins, deferring probe
> [0.482330] platform i2c.15: Driver omap_i2c requests probe deferral
> [0.484466] Advanced Linux Sound Architecture Driver Initialized.
>=20
> [4.746917] omap_i2c i2c.15: bus 4 rev2.4.0 at 100 kHz
> [4.755279] gpiochip_find_base: found new base at 477
> [4.761169] gpiochip_add: registered GPIOs 477 to 500 on device: tca6424a
>=20
> Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>

looks good to me also, should go in v3.8 merge window:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/i2c/busses/i2c-omap.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index db31eae..661d8a2 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -44,6 +44,7 @@
>  #include <linux/i2c-omap.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pm_qos.h>
> +#include <linux/pinctrl/consumer.h>
> =20
>  /* I2C controller revisions */
>  #define OMAP_I2C_OMAP1_REV_2		0x20
> @@ -213,6 +214,8 @@ struct omap_i2c_dev {
>  	u16			syscstate;
>  	u16			westate;
>  	u16			errata;
> +
> +	struct pinctrl		*pins;
>  };
> =20
>  static const u8 reg_map_ip_v1[] =3D {
> @@ -1107,6 +1110,16 @@ omap_i2c_probe(struct platform_device *pdev)
>  		dev->dtrev =3D pdata->rev;
>  	}
> =20
> +	dev->pins =3D devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(dev->pins)) {
> +		if (PTR_ERR(dev->pins) =3D=3D -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		dev_warn(&pdev->dev, "did not get pins for i2c error: %li\n",
> +			 PTR_ERR(dev->pins));
> +		dev->pins =3D NULL;
> +	}
> +
>  	dev->dev =3D &pdev->dev;
>  	dev->irq =3D irq;
> =20
> --=20
> 1.7.10.4
>=20

--=20
balbi

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhPjJAAoJEIaOsuA1yqRE9y4P/0hhSycYQr+mXwW1i3TPgt7j
ZjaRrRVPolLOlOKhGIy2rTH7ozzPl1bMTrXi09YAyNGn+w3hiCI2LPJMLIcQn8RC
KS7KwhphFSgI1zXHhObs8cf+XQmXliOz7iyRotgOH4BqU0ecbZWpz2iWUxVUnaxe
K7jcA9KdbLPQ553kUkRByiB2MUWMpNOlby3NS3+lJ3VQHIYDlZwYDm7SahIIfs9S
DPUztTA2+rhu46sv5wr4rpFv6fTbYSFB6HawSfSIW4iXYxW4djvdO/dq1J0vtM9u
nEeG9hM4uJ9Ke8noQI2I22Fameqg0FyAjLCcj8eYYqdMiCV2O7CA6TahEJNlgev5
SZFZZR+LbCaKMq8RWVJC5uX9qchdNBY3MHne6wIAHBbTipvicMnUR4ekL/75wVmB
LhN2FSWhhBnF/BChrbfvE8gNQOLfKACg3/MTpJUp5ioiWZNI0iEiu6nz9e/S1OQ1
rZ+F6TrtZZVcmaiV+3e5YL7dyrCRp9pW5ppYnLA6GATqTGW7MXx5LZ000YXMX22R
h9ZyYtphC3O94preYH3ufQ0OM4pb1/dBJPMLUt4wfFvUpR8EbS290WAPykcCJ4JP
RCLGP6843g5A/hZpS0QLUXIQ4SrcFxcEcgQdUyZilQ8L/H+dRja1ODkkyYZrtXr5
/aQcRHosnuXT8tNzRTiQ
=540X
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2GAIjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 04:39:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2GAIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 04:39:41 -0400
Date: Sun, 1 Jul 2012 10:39:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v3] spi/pl022: add devicetree support
Message-ID: <20120701083923.GA29380@avionic-0098.mockup.avionic-design.de>
References: <1340719537-627-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1340719537-627-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:JRtDMxhgc30gwdQ5h0Bzpm09YN2wLYsoITELTUDVff5
 9A538aTFs2EXqpMBDlk2DoZfljJWtKJeHye2drJbAdvoKRLoWl
 e317wx08psf6J3Zrj9BlfGBQ3xnx7gKmYbMkhgGDUhX9RrKAHz
 SE+0hYx4iCj1FErPnPu3+nzZUxlPfSjhD2DXllheI0GHZ6guHo
 Xm5LvRxXzV60SadxRZptxSbK0aApc8MOGMJCYS+8XxdTyzdFJF
 t2aKaJjREIblilVPrAi77IUJmQiqTAfRn0SZHOMoesnV9LlCdP
 uVWiwUlST21sFAcBze8+6ZcPkutwEU0fk2+pzIgYl6VgqOegye
 1OeS/JVfPqqm0nh3BvwCM0PJA39Z8r7vy36v1idMc6wnkKzNQM
 Cp/Ab4/HnqJcyh0ClE0fl6Sv5/ZmsZ13Co=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 11:05:36AM -0300, Alexandre Pereira da Silva wrote:
> Add the chipselect array and cur_cs properties to pl022 main structure
>=20
> Add a wrapper function to decide if the cs should be controlled by the
> cs_control callback or the chipselect gpio
>=20
> Populate chipselect property from cs-gpios
>=20
> Populate master->dev.of_node, so the spi bus can find child spi
> devices and register them
>=20
> At pl022 setup, fill chip_data structure from dt nodes, if not provided
> by platform.
>=20
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Tested-by: Roland Stigge <stigge@antcom.de>
> ---
> Applies to v3.5-rc4
>=20
> Changes since v2:
> * Use IS_ENABLED instead of #ifdef
> * Remove bogus const change
>=20
> Changes since v1:
> * return EPROBE_DEFFER if gpios are not initialized yet
>=20
> Thanks Thierry Reding for reviewing and improvements suggestions
>=20
>  .../devicetree/bindings/spi/spi_pl022.txt          |   15 +++
>  drivers/spi/spi-pl022.c                            |  115 ++++++++++++++=
++----
>  2 files changed, 111 insertions(+), 19 deletions(-)
>=20
[...]
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
[...]
> @@ -1998,8 +2039,14 @@ pl022_probe(struct amba_device *adev, const struct=
 amba_id *id)
>  		goto err_no_pdata;
>  	}
> =20
> +	num_cs =3D platform_info->num_chipselect;
> +#if IS_ENABLED(CONFIG_OF)
> +	of_property_read_u32(np, "pl022,num-chipselects", &num_cs);
> +#endif
> +

Actually this has even more advantages if you use it as a condition in
an if expression:

	if (IS_ENABLED(CONFIG_OF))
		of_property_read_u32(...);

The above will be compiled wether CONFIG_OF is enabled or not, but it
will not be included in the final output because of the compiler's DCE
(dead code elimination) seeing this as "if (0)". The result is that the
source code gets much better compile coverage and errors in the
conditional code can be caught earlier.

> @@ -2017,13 +2064,40 @@ pl022_probe(struct amba_device *adev, const struc=
t amba_id *id)
>  	 * on this board
>  	 */
>  	master->bus_num =3D platform_info->bus_id;
> -	master->num_chipselect =3D platform_info->num_chipselect;
> +	master->num_chipselect =3D num_cs;
>  	master->cleanup =3D pl022_cleanup;
>  	master->setup =3D pl022_setup;
>  	master->prepare_transfer_hardware =3D pl022_prepare_transfer_hardware;
>  	master->transfer_one_message =3D pl022_transfer_one_message;
>  	master->unprepare_transfer_hardware =3D pl022_unprepare_transfer_hardwa=
re;
>  	master->rt =3D platform_info->rt;
> +	master->dev.of_node =3D dev->of_node;
> +
> +#if IS_ENABLED(CONFIG_OF)
> +	for (i =3D 0; i < num_cs; i++) {
> +		int cs_gpio =3D of_get_named_gpio(np, "cs-gpios", i);
> +
> +		if (cs_gpio =3D=3D -EPROBE_DEFER) {
> +			status =3D -EPROBE_DEFER;
> +			goto err_no_gpio;
> +		}
> +
> +		pl022->chipselect[i] =3D cs_gpio;
> +
> +		if (gpio_is_valid(cs_gpio)) {
> +			if (gpio_request(cs_gpio, "ssp-pl022"))
> +				dev_err(&adev->dev,
> +					"could not request %d gpio\n", cs_gpio);
> +			else if (gpio_direction_output(cs_gpio, 1))
> +				dev_err(&adev->dev,
> +					"could set gpio %d as output\n",
> +					cs_gpio);
> +		}
> +	}
> +#else
> +	for (i =3D 0; i < num_cs; i++)
> +		pl022->chipselect[i] =3D -EINVAL;
> +#endif

Same here.

>  	/*
>  	 * Supports mode 0-3, loopback, and active low CS. Transfers are
> @@ -2130,6 +2204,9 @@ pl022_probe(struct amba_device *adev, const struct =
amba_id *id)
>   err_no_ioremap:
>  	amba_release_regions(adev);
>   err_no_ioregion:
> + #if IS_ENABLED(CONFIG_OF)
> + err_no_gpio:
> + #endif

And here.

Thierry

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8Ay7AAoJEN0jrNd/PrOh0b4P/2x7oJksZ24gDtvynKsgb0rg
LwohzrRHXfxaHddy/XJFQZwJNl407gwtwNwwbvRA2oRIp8AZRg5PkMVW3LL3XeWj
SZ02DyXb80Snn6L+M0nDn2gLpMIJTDvSqVMtCStr8iRm1F9R3EDhNxx+Icn5dNdW
YPWy/AMcIBUuoaiEHzbwwCI6NPh1G1sMSFSmRARXPx5W+Pha+oGpEHHWB1tk5W/T
DtvTLjVKp1YdqYluhb8AnOPl89fLZ9/iPxbCiyat62/FzeU8ighfC6wADnDwQ2/6
MXoN+dpvGfVoj6RRNxfSEzFf9PEtpKe72HwGp5Rb6h+SV76xh8fffmJGRjJmXrNg
dpI45UEEfoof+Ku96wFSyeLoywvzUj2esd9ltjuCLrR7pwta6yx5SqyUM2E6rnoW
QW9gfcA9q0lI0X8GXu6oJ5L5eR5SSdLUfyEtnq98vnut914MffLmF19BlXMZAUcX
TITvXX1cfVhOW9qwH8nt73hOZdKqqPKXfAWMICdEBkFukFnmZmorRIVb6L/Gw45+
+5A31WULLNXZ4cYFo7UmR0avfgLLepc5tGSqy2w+MPbxsnevz8FLZ2mzEQwbu6A3
Q7GvkxG0V8KL0llebPLef4PAruyx8QrkhgArMMQIUeDr3Iy/YQZmY+aGWZSlSJRc
yHGxNeJFsfBCwdZ15bbl
=uVeC
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

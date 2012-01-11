Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2AKLG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:06:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42462 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2AKLGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:06:53 -0500
Date: Wed, 11 Jan 2012 12:06:50 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
Message-ID: <20120111110650.GC2605@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Austin,

> --- a/drivers/rtc/rtc-ds1307.c	2011-10-10 11:22:22.674690998 +1300
> +++ b/drivers/rtc/rtc-ds1307.c	2011-11-04 10:02:27.859155009 +1300
> @@ -104,6 +104,8 @@ enum ds_type {
> =20
>  struct ds1307 {
>  	u8			offset; /* register's offset */
> +	u16			nvram_offset;
> +	u16			nvram_size;

I'd put them further down in the struct, at least after regs.


>  	u8			regs[11];
>  	enum ds_type		type;
>  	unsigned long		flags;
> @@ -119,26 +121,37 @@ struct ds1307 {
>  };
> =20
>  struct chip_desc {
> -	unsigned		nvram56:1;
>  	unsigned		alarm:1;
> +	u8			offset;

I think the stuff related to 'offset' should be in a separate patch with
specific commit-msg.

> +	u16			nvram_offset;
> +	u16			nvram_size;
>  };
> =20
>  static const struct chip_desc chips[last_ds_type] =3D {
>  	[ds_1307] =3D {
> -		.nvram56	=3D 1,
> +		.nvram_offset	=3D 8,
> +		.nvram_size	=3D 56, /* 56 bytes NVRAM */

Skip the comment, should be obvious.

>  	},
>  	[ds_1337] =3D {
>  		.alarm		=3D 1,
>  	},
>  	[ds_1338] =3D {
> -		.nvram56	=3D 1,
> +		.nvram_offset	=3D 8,
> +		.nvram_size	=3D 56, /* 56 bytes NVRAM */
>  	},
>  	[ds_1339] =3D {
>  		.alarm		=3D 1,
>  	},
> +	[ds_1388] =3D {
> +		.offset		=3D 1, /* seconds starts at 1 */
> +	},
>  	[ds_3231] =3D {
>  		.alarm		=3D 1,
>  	},
> +	[mcp7941x] =3D {
> +		.nvram_offset	=3D 0x20,
> +		.nvram_size	=3D 64, /* 64 bytes SRAM */

Minor: hex value for size, too? Comment should probably emphasize that
this is SRAM not NVRAM, the size is obvious again.

> +	},
>  };
> =20
=2E..

> @@ -638,7 +650,19 @@ static int __devinit ds1307_probe(struct
> =20
>  	ds1307->client	=3D client;
>  	ds1307->type	=3D id->driver_data;
> -	ds1307->offset	=3D 0;
> +
> +	if (chip && chip->offset)
> +		ds1307->offset =3D chip->offset;
> +	else
> +		ds1307->offset =3D 0;
> +	if (chip && chip->nvram_size)
> +		ds1307->nvram_size =3D chip->nvram_size;
> +	else
> +		ds1307->nvram_size =3D 0;
> +	if (chip && chip->nvram_offset)
> +		ds1307->nvram_offset =3D chip->nvram_offset;
> +	else
> +		ds1307->nvram_offset =3D 0;

ds1307 is kzalloced, so you can simplify this. Then, you also need to
check only once if chip !=3D NULL.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8NbUoACgkQD27XaX1/VRtd8gCeLxWSpKbBBHzLa6bFkynb1Qx3
20YAoIxWAPE70z5WozTlhbw60tsWeLKk
=0WMU
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--

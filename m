Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2LDScn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:32:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41367 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2LDScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:32:41 -0500
Date: Tue, 4 Dec 2012 19:32:38 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH RFC] misc/at24: distinguish between eeprom and fram chips
Message-ID: <20121204183238.GA15067@pengutronix.de>
References: <201212041758.38600.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <201212041758.38600.poeschel@lemonage.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> I wanted to use a fm24c04 i2c fram chip with linux. I grepped the source
> and found nothing. I later found that my chip can be handled by at24
> eeprom driver. It creates a sysfs file called eeprom to read from and
> write to the chip. Userspace has no chance to distinguish if it is
> writing an eeprom or a fram chip.

Why should it?

> I present this patch for 3 reasons:
> 1. For other people grepping finding a little more reference.

Yes. The Kconfig entry could be updated to mention not only EEPROMs.

> 2. For userspace being able to distinguish eeprom and fram.

Why?

> 3. Raising the bytes per write for fram chips.

Properly configuring the chip (including proper page_size) is the way to
go IMO. Read on...

>=20
> What do you kernel developers think ?
>=20
> Cheers,
> Lars
> -- >8 --
> From 4fab49fae62390995868e3b6dee7e0693fce5be9 Mon Sep 17 00:00:00 2001
> From: Lars Poeschel <poeschel@lemonage.de>
> Date: Tue, 4 Dec 2012 15:41:40 +0100
> Subject: [PATCH] misc/at24: distinguish between eeprom and fram chips
>=20
> Add a AT24_FLAGS_FRAM state to the flags to make userspace able to
> distinguish if it is using eeprom or fram. The sysfs entry gets the
> name "fram" instead of "eeprom".
> For frams the bytes/write can be at least 128 bytes, since these
> chips have no need to internally buffer writes.
>=20
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
>=20
> diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> index c9e695e..55948a5 100644
> --- a/drivers/misc/eeprom/Kconfig
> +++ b/drivers/misc/eeprom/Kconfig
> @@ -12,6 +12,12 @@ config EEPROM_AT24
>  	     24c00, 24c01, 24c02, spd (readonly 24c02), 24c04, 24c08,
>  	     24c16, 24c32, 24c64, 24c128, 24c256, 24c512, 24c1024
> =20
> +	  This driver also supports I2C FRAM chips that are feature
> +	  compatible to the 24cxx ones. In your at24_platform_data set
> +	  .flags =3D AT24_FLAG_FRAM. These generic names are supported:
> +
> +	     fm24c04
> +

The method of accessing EEPROMs is used by way more chips than FRAMs.
So, I'd prefer to have the text updated more generic like "EEPROMs and
similar devices like RAMs, ROMs, etc...". Describing setting .flags in
Kconfig is overkill.


>  	  Unless you like data loss puzzles, always be sure that any chip
>  	  you configure as a 24c32 (32 kbit) or larger is NOT really a
>  	  24c16 (16 kbit) or smaller, and vice versa. Marking the chip
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index ab1ad41..02a03a1 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -125,6 +125,7 @@ static const struct i2c_device_id at24_ids[] =3D {
>  	{ "24c256", AT24_DEVICE_MAGIC(262144 / 8, AT24_FLAG_ADDR16) },
>  	{ "24c512", AT24_DEVICE_MAGIC(524288 / 8, AT24_FLAG_ADDR16) },
>  	{ "24c1024", AT24_DEVICE_MAGIC(1048576 / 8, AT24_FLAG_ADDR16) },
> +	{ "fm24c04", AT24_DEVICE_MAGIC(4096 / 8, AT24_FLAG_FRAM) },

The 24cxxx entries are last resort fallbacks to give you minimal access.
They also do this for your FRAM correctly. For proper setup, you need
custom configuration anyhow. There, you can define the page_size as well
as the permissions for the created file. So, no to this change.

>  	{ "at24", 0 },
>  	{ /* END OF LIST */ }
>  };
> @@ -504,8 +505,13 @@ static int at24_probe(struct i2c_client *client, con=
st=20
> struct i2c_device_id *id)
>  		 * This is slow, but we can't know all eeproms, so we better
>  		 * play safe. Specifying custom eeprom-types via platform_data
>  		 * is recommended anyhow.
> +		 * For fram chips, we can allow minmum 128 bytes, as there is
> +		 * no page size and 128 is the smallest so far seen chip.
>  		 */
> -		chip.page_size =3D 1;
> +		if (chip.flags & AT24_FLAG_FRAM)
> +			chip.page_size =3D 128;
> +		else
> +			chip.page_size =3D 1;

I'd think most FRAMs can have the chip_size as the page_size since they
probably don't do buffering. But do you know for all the chips out
there? So, let's still play safe. If you want performance, you need to
setup the driver properly.

> =20
>  		/* update chipdata if OF is present */
>  		at24_get_ofdata(client, &chip);
> @@ -570,7 +576,10 @@ static int at24_probe(struct i2c_client *client, con=
st=20
> struct i2c_device_id *id)
>  	 * By default, only root should see the data (maybe passwords etc)
>  	 */
>  	sysfs_bin_attr_init(&at24->bin);
> -	at24->bin.attr.name =3D "eeprom";
> +	if (chip.flags & AT24_FLAG_FRAM)
> +		at24->bin.attr.name =3D "fram";
> +	else
> +		at24->bin.attr.name =3D "eeprom";

Again no. Applications would need to check for this file or that file.
The name "eeprom" is indeed a bit unfortunate, but is historic cruft.

>  	at24->bin.attr.mode =3D chip.flags & AT24_FLAG_IRUGO ? S_IRUGO : S_IRUS=
R;
>  	at24->bin.read =3D at24_bin_read;
>  	at24->bin.size =3D chip.byte_len;
> diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
> index 285025a..d786b71 100644
> --- a/include/linux/i2c/at24.h
> +++ b/include/linux/i2c/at24.h
> @@ -47,6 +47,7 @@ struct at24_platform_data {
>  #define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
>  #define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
>  #define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
> +#define AT24_FLAG_FRAM          0x08    /* chip is fram not eeprom */
> =20
>  	void		(*setup)(struct memory_accessor *, void *context);
>  	void		*context;

Thanks for your interest nonetheless,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlC+QcYACgkQD27XaX1/VRvyCgCeK/YL8ldngR2HQ05FqRE5wYZw
fd8AniXvtKJauQfZSxJV1jz0yI9OKsCT
=GIXQ
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

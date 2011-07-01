Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1GAAWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:22:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49269 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353Ab1GAAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:22:48 -0400
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
From: Ben Hutchings <ben@decadent.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
In-Reply-To: <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
	 <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-D2uhRO8mPNjP37YcyJ9b"
Date: Fri, 01 Jul 2011 01:22:41 +0100
Message-ID: <1309479761.3093.1659.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D2uhRO8mPNjP37YcyJ9b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-22 at 19:45 +0100, Mark Brown wrote:
[...]
> --- /dev/null
> +++ b/drivers/regmap/regmap.c
[...]
> +static void regmap_format_4_12_write(struct regmap *map,
> +				     unsigned int reg, unsigned int val)
> +{
> +	u16 *out =3D map->work_buf;

__be16 *out

> +	*out =3D cpu_to_be16((reg << 12) | val);
> +}
> +
> +static void regmap_format_7_9_write(struct regmap *map,
> +				    unsigned int reg, unsigned int val)
> +{
> +	u16 *out =3D map->work_buf;

__be16 *out

> +	*out =3D cpu_to_be16((reg << 9) | val);
> +}
> +
> +static void regmap_format_8(void *buf, unsigned int val)
> +{
> +	u8 *b =3D buf;
> +
> +	b[0] =3D val;
> +}
> +
> +static void regmap_format_16(void *buf, unsigned int val)
> +{
> +	u16 *b =3D buf;

__be16 *b

> +	b[0] =3D cpu_to_be16(val);
> +}
> +
> +static unsigned int regmap_parse_8(void *buf)
> +{
> +	u8 *b =3D buf;
> +
> +	return b[0];
> +}
> +
> +static unsigned int regmap_parse_16(void *buf)
> +{
> +	u16 *b =3D buf;

__be16 *b

> +	b[0] =3D be16_to_cpu(b[0]);
> +
> +	return b[0];

The assignment doesn't seem to be necessary and will irritate sparse,
so:

	return be16_to_cpu(b[0]);

> +}
> +
> +/**
> + * remap_init: Initialise register map

Missing 'g' in 'regmap_init'.  And the first line's format must be:

   regmap_init() - Initialise register map

(The other functions all have this problem as well.)

> + * dev: Device that will be interacted with
> + * config: Configuration for register map

Missing '@' before the parameter names.

[...]
> +static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> +			     const void *val, size_t val_len)
> +{
> +	void *buf;
> +	int ret =3D -ENOTSUPP;
> +	size_t len;
> +
> +	map->format.format_reg(map->work_buf, reg);
> +
> +	/* Try to do a gather write if we can */
> +	if (map->bus->gather_write)
> +		ret =3D map->bus->gather_write(map->dev, map->work_buf,
> +					     map->format.reg_bytes,
> +					     val, val_len);
> +
> +	/* Otherwise fall back on linearising by hand. */
> +	if (ret =3D=3D -ENOTSUPP) {
> +		len =3D map->format.reg_bytes + val_len;
> +		buf =3D kmalloc(len, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +		memcpy(buf, map->work_buf, map->format.reg_bytes);
> +		memcpy(buf + map->format.reg_bytes, val, val_len);
[...]

If I understand correctly, this is usually called by _regmap_write() and
val is already at the appropriate offset in work_buf.  Is it not worth
avoiding the allocation in that case?

General comments:

- All the functions must be called in process context, but this isn't
documented.
- I think this could go in lib or drivers/base rather than in a new
directory.  The specific support for I2C and SPI would go in their
existing directories.

Ben.

--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.

--=-D2uhRO8mPNjP37YcyJ9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATg0TQ+e/yOyVhhEJAQpAghAAr2LFHaSkYqEJf8gcKhbi987D5BGjlwCh
CEby2h8+8WLJV/d5GB+mzdR2SArO2+Z+sE43iVSZFKtWQ77ecKrNVjXSWhLRknzC
yv8Cu1OCaoMzKw9jE23mDFiW0CgEEZgJ2hGV0vOj2KDsAu1UkyzGdVlJSwGcERam
Y3jY1QbyW3sPZPFfP+mzh7D1uPg+biFM5maEgycOuaw2pgWj0qAM+wgiJRQkxomp
IWlRDA49RgQd69XQ8AumPfOQLL2oRG3rc2vAxWk66uQjLaOhSW5xxiBysesBkKNh
GlVqRjt4d8uHbOF3GPIgsvBudZyDQYi67+vbs5jKvWVMHHmqTZLNlchsFv+blXdg
LfP3f1ob8UaWpcJzmvuE6wlq6LcptQR23i/748KSKySaJ1VLxHRIN0rbQEXwXxDI
sWKZ5IsfLli4Yuaoo5zIw5T7UeKkwY6dtWAHLiGIJnpOHYGF8aGoqc+bn6AI/YG5
BtHyMfA+s4SBsOICIF92HRt7p2eLMaXqMNrd8Xq0eMPnB6Vuc5IjBsLWdSTvv5AV
F9BqrCuG39SmjmdC8YkQ2B2ikKLwU9t12ylaITSYyZBwgpbMY1+PIUxcZB+gvonm
6qfqAywCFL5v0IeyMOzFtUzX4m4uQY6Jfbr1DIk9c0wRcsf/J7hoQesUuLwTkVBo
2+aBoGoW14o=
=XdGD
-----END PGP SIGNATURE-----

--=-D2uhRO8mPNjP37YcyJ9b--

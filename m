Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab2C2UCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:02:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43165 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2C2UBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:01:53 -0400
Date: Thu, 29 Mar 2012 22:01:50 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH-v2] Support M95040 SPI EEPROM
Message-ID: <20120329200150.GA27005@pengutronix.de>
References: <1332942602-22324-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <1332942602-22324-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 28, 2012 at 03:50:02PM +0200, Ivo Sieben wrote:
> Updated the generic SPI EEPROM driver AT25 for support of an additional a=
ddress
> bit in the instruction byte. Certain EEPROMS have a size that is larger t=
han the
> number of address bytes would allow (e.g. like M95040 from ST that has 51=
2 Byte
> size but uses only one address byte (A0 to A7) for addressing.) For the e=
xtra
> address bit (A8, A16 or A24) bit 3 of the instruction byte is used. This
> instruction bit is normally defined as don't care for other AT25 like chi=
ps.
>=20
> v2: Introduced a flag EE_INSTR_BIT3_IS_ADDR to support additional address=
 bits
> in READ/WRITE instruction.

Yeah, this one looks promising. Thanks!

>=20
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
>  drivers/misc/eeprom/at25.c |   24 +++++++++++++++++++++---
>  include/linux/spi/eeprom.h |   10 ++++++++++
>  2 files changed, 31 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
> index c627e41..5e0650f 100644
> --- a/drivers/misc/eeprom/at25.c
> +++ b/drivers/misc/eeprom/at25.c
> @@ -35,6 +35,7 @@ struct at25_data {
>  	struct spi_eeprom	chip;
>  	struct bin_attribute	bin;
>  	unsigned		addrlen;
> +	unsigned		instr_bit3_address_offset;

I think we can live without this new member. See below

>  };
> =20
>  #define	AT25_WREN	0x06		/* latch the write enable */
> @@ -50,6 +51,7 @@ struct at25_data {
>  #define	AT25_SR_BP1	0x08
>  #define	AT25_SR_WPEN	0x80		/* writeprotect enable */
> =20
> +#define	AT25_INSTR_BIT3	0x08		/* Additional address bit in instr */
> =20
>  #define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
> =20
> @@ -75,6 +77,7 @@ at25_ee_read(
>  	ssize_t			status;
>  	struct spi_transfer	t[2];
>  	struct spi_message	m;
> +	u8			instr;
> =20
>  	if (unlikely(offset >=3D at25->bin.size))
>  		return 0;
> @@ -84,7 +87,12 @@ at25_ee_read(
>  		return count;
> =20
>  	cp =3D command;
> -	*cp++ =3D AT25_READ;
> +
> +	instr =3D AT25_READ;
> +	if (at25->instr_bit3_address_offset)
> +		if (offset >=3D at25->instr_bit3_address_offset)
> +			instr |=3D AT25_INSTR_BIT3;

What about:

	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR && (offset >> (at25->addrlen =
* 8)))
		instr |=3D AT25_INSTR_BIT3;

> +	*cp++ =3D instr;
> =20
>  	/* 8/16/24-bit address is written MSB first */
>  	switch (at25->addrlen) {
> @@ -167,14 +175,14 @@ at25_ee_write(struct at25_data *at25, const char *b=
uf, loff_t off,
>  	/* For write, rollover is within the page ... so we write at
>  	 * most one page, then manually roll over to the next page.
>  	 */
> -	bounce[0] =3D AT25_WRITE;
>  	mutex_lock(&at25->lock);
>  	do {
>  		unsigned long	timeout, retries;
>  		unsigned	segment;
>  		unsigned	offset =3D (unsigned) off;
> -		u8		*cp =3D bounce + 1;
> +		u8		*cp =3D bounce;
>  		int		sr;
> +		u8		instr;
> =20
>  		*cp =3D AT25_WREN;
>  		status =3D spi_write(at25->spi, cp, 1);
> @@ -184,6 +192,12 @@ at25_ee_write(struct at25_data *at25, const char *bu=
f, loff_t off,
>  			break;
>  		}
> =20
> +		instr =3D AT25_WRITE;
> +		if (at25->instr_bit3_address_offset)
> +			if (offset >=3D at25->instr_bit3_address_offset)
> +				instr |=3D AT25_INSTR_BIT3;

Ditto.

> +		*cp++ =3D instr;
> +
>  		/* 8/16/24-bit address is written MSB first */
>  		switch (at25->addrlen) {
>  		default:	/* case 3 */
> @@ -296,6 +310,7 @@ static int at25_probe(struct spi_device *spi)
>  	int			err;
>  	int			sr;
>  	int			addrlen;
> +	unsigned		instr_bit3_address_offset =3D 0;
> =20
>  	/* Chip description */
>  	chip =3D spi->dev.platform_data;
> @@ -317,6 +332,8 @@ static int at25_probe(struct spi_device *spi)
>  		err =3D -EINVAL;
>  		goto fail;
>  	}
> +	if (chip->flags & EE_INSTR_BIT3_IS_ADDR)
> +		instr_bit3_address_offset =3D 1U << (addrlen * 8);
> =20
>  	/* Ping the chip ... the status register is pretty portable,
>  	 * unlike probing manufacturer IDs.  We do expect that system
> @@ -339,6 +356,7 @@ static int at25_probe(struct spi_device *spi)
>  	at25->spi =3D spi_dev_get(spi);
>  	dev_set_drvdata(&spi->dev, at25);
>  	at25->addrlen =3D addrlen;
> +	at25->instr_bit3_address_offset =3D instr_bit3_address_offset;

Then we could also skip all this in probe.

> =20
>  	/* Export the EEPROM bytes through sysfs, since that's convenient.
>  	 * And maybe to other kernel code; it might hold a board's Ethernet
> diff --git a/include/linux/spi/eeprom.h b/include/linux/spi/eeprom.h
> index 306e7b1..403e007 100644
> --- a/include/linux/spi/eeprom.h
> +++ b/include/linux/spi/eeprom.h
> @@ -20,6 +20,16 @@ struct spi_eeprom {
>  #define	EE_ADDR3	0x0004			/* 24 bit addrs */
>  #define	EE_READONLY	0x0008			/* disallow writes */
> =20
> +	/*
> +	 * Certain EEPROMS have a size that is larger than the number of address
> +	 * bytes would allow (e.g. like M95040 from ST that has 512 Byte size
> +	 * but uses only one address byte (A0 to A7) for addressing.) For
> +	 * the extra address bit (A8, A16 or A24) bit 3 of the instruction byte
> +	 * is used. This instruction bit is normally defined as don't care for
> +	 * other AT25 like chips.
> +	 */
> +#define EE_INSTR_BIT3_IS_ADDR	0x0010
> +

Good documentation!

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk90v64ACgkQD27XaX1/VRvDCwCfcs8y+ISAC8HjWpNiXimp/NtY
6FsAmgNZBzXSAmkCgOblIp3bvJ+9+KV0
=8BAH
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--

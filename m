Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0IGNSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:18:51 -0400
Received: from vps.mortis.eu ([79.99.135.181]:41480 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab0IGNSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:18:39 -0400
Date: Tue, 7 Sep 2010 15:18:37 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add f71862fg support
Message-ID: <20100907131837.GH6114@salidar.me.mortis.eu>
References: <20100906132434.GA17730@kreios.titan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <20100906132434.GA17730@kreios.titan>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 06, 2010 at 03:24:34PM +0200, Lutz Ballaschke wrote:
> Fintek Super-I/O f71862fg watchdog support added to f71808e_wdt driver.
> Furthermore the WDIOC_GETTIMELEFT ioctl is added to the driver.

You're patch makes three changes:
 * Add f71862 support
 * Add the WDIOC_GETTIMELEFT ioctl
 * Change some config-register (magic) numbers into constants

Please split these things into separate patches.

> diff -Nurp linux-2.6.36-rc1-orig/drivers/watchdog/f71808e_wdt.c linux-2.6=
=2E36-rc1/drivers/watchdog/f71808e_wdt.c
> --- linux-2.6.36-rc1-orig/drivers/watchdog/f71808e_wdt.c	2010-08-16 02:41=
:37.000000000 +0200
> +++ linux-2.6.36-rc1/drivers/watchdog/f71808e_wdt.c	2010-09-04 18:52:14.0=
00000000 +0200
> @@ -252,6 +255,24 @@ exit_unlock:
>  	return err;
>  }
> =20
> +static int watchdog_time_left(void)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&watchdog.lock);
> +	ret =3D superio_enter(watchdog.sioaddr);
> +	if (ret)
> +		goto exit_unlock;
> +
> +	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
> +	ret =3D (int) superio_inb(watchdog.sioaddr, F71808FG_REG_WD_TIME);
> +	superio_exit(watchdog.sioaddr);
> +
> +exit_unlock:
> +	mutex_unlock(&watchdog.lock);
> +	return ret;
> +}
> +
>  static int watchdog_keepalive(void)
>  {
>  	int err =3D 0;

This function doesn't perform any unit-conversion.  The ioctl expects to
receive seconds as the result, while this function can either return
minutes or seconds depending on the value of WD_UNIT (see datasheet
and/or uses of minutes_mode in the driver).

Further, why are you casting superio_inb()'s return value to (int) while
that's already the return type of that function?

> @@ -308,4 +329,10 @@ static int watchdog_start(void)
>  		superio_set_bit(watchdog.sioaddr, SIO_REG_MFUNCT1, 1);
>  		break;
> =20
> +	case f71862fg:
> +		/* Set pin 63 to WDTRST# (SPI must be disabled first!) */
> +		superio_clear_bit(watchdog.sioaddr, SIO_REG_ROM_ADDR_SEL, 6);
> +		superio_set_bit(watchdog.sioaddr, SIO_REG_MFUNCT3, 4);
> +		break;
> +
>  	default:

Given that the F71862 has *two* pins assignable to the WDTRST# signal,
please document that fact, and the reason for choosing this one in the
code.

Perhaps it might even be desirable to insert a printk there.  This to
make the user aware of the fact that this driver might not work if the
pin configuration of their hardware doesn't match the assumption you
make about it in this code.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyGO60ACgkQZBYm/87l50KF+ACfZbPGiajF5ynS2tOcVNnh100K
4PoAnjuGYHgOgxcgTD/9Hxke5uUKGOl5
=jYS7
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--

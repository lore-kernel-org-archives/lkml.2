Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab1GKVdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:33:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53273 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab1GKVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:33:00 -0400
Date: Mon, 11 Jul 2011 23:32:59 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 04/11] watchdog: WatchDog Timer Driver Core - Add
 WDIOC_SETOPTIONS ioctl
Message-ID: <20110711213259.GE5811@pengutronix.de>
References: <1310392522-9949-1-git-send-email-wim@iguana.be>
 <1310392522-9949-4-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <1310392522-9949-4-git-send-email-wim@iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> @@ -121,6 +171,7 @@ static long watchdog_ioctl(struct file *file, unsigne=
d int cmd,
>  	void __user *argp =3D (void __user *)arg;
>  	int __user *p =3D argp;
>  	unsigned int val;
> +	int err;
> =20
>  	switch (cmd) {
>  	case WDIOC_GETSUPPORT:
> @@ -131,6 +182,20 @@ static long watchdog_ioctl(struct file *file, unsign=
ed int cmd,
>  		return put_user(val, p);
>  	case WDIOC_GETBOOTSTATUS:
>  		return put_user(wdd->bootstatus, p);
> +	case WDIOC_SETOPTIONS:
> +		if (get_user(val, p))
> +			return -EFAULT;
> +		if (val & WDIOS_DISABLECARD) {
> +			err =3D watchdog_stop(wdd);
> +			if (err < 0)
> +				return err;
> +		}
> +		if (val & WDIOS_ENABLECARD) {
> +			err =3D watchdog_start(wdd);
> +			if (err < 0)
> +				return err;
> +		}
> +		return 0;
>  	case WDIOC_KEEPALIVE:
>  		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
>  			return -EOPNOTSUPP;
> @@ -168,7 +233,7 @@ static int watchdog_open(struct inode *inode, struct =
file *file)
>  		goto out;
> =20
>  	/* start the watchdog */
> -	err =3D wdd->ops->start(wdd);
> +	err =3D watchdog_start(wdd);

I think we still might need open- and close-callbacks here. Some drivers tu=
rn
on/off clocks on these operations and we can't simply move them to the
start/stop callbacks, because the clock might be turned off via DISABLECARD
which calls stop. And without the clock, a simple register access via
set_timeout might lock up the machine.

>  	if (err < 0)
>  		goto out_mod;
> =20
> @@ -195,8 +260,8 @@ static int watchdog_release(struct inode *inode, stru=
ct file *file)
>  	int err;
> =20
>  	/* stop the watchdog */
> -	err =3D wdd->ops->stop(wdd);
> -	if (err !=3D 0) {
> +	err =3D watchdog_stop(wdd);
> +	if (err < 0) {
>  		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
>  		watchdog_ping(wdd);
>  	}
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index a2b639b..853387f 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -81,6 +81,7 @@ struct watchdog_device {
>  	void *priv;
>  	unsigned long status;
>  /* Bit numbers for status flags */
> +#define WDOG_ACTIVE		0	/* Is the watchdog running/active */
>  #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
>  };
> =20
> --=20
> 1.7.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4bbAsACgkQD27XaX1/VRsZqACfS+rMMiVTxLArAI4jsS6p66Hn
N4cAnAjclZcMVvWFTA6kD9x1r/1OGtaR
=Xqtf
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--

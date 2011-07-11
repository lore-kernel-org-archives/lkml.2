Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab1GKVer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:34:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55544 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1GKVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:34:46 -0400
Date: Mon, 11 Jul 2011 23:34:45 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 05/11] watchdog: WatchDog Timer Driver Core - Add
 WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
Message-ID: <20110711213445.GF5811@pengutronix.de>
References: <1310392522-9949-1-git-send-email-wim@iguana.be>
 <1310392522-9949-5-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <1310392522-9949-5-git-send-email-wim@iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_=
dev.c
> index 530003b..0d4b16d 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -201,6 +201,26 @@ static long watchdog_ioctl(struct file *file, unsign=
ed int cmd,
>  			return -EOPNOTSUPP;
>  		watchdog_ping(wdd);
>  		return 0;
> +	case WDIOC_SETTIMEOUT:
> +		if ((wdd->ops->set_timeout =3D=3D NULL) ||
> +		    !(wdd->info->options & WDIOF_SETTIMEOUT))
> +			return -EOPNOTSUPP;
> +		if (get_user(val, p))
> +			return -EFAULT;
> +		err =3D wdd->ops->set_timeout(wdd, val);
> +		if (err < 0)
> +			return err;
> +		wdd->timeout =3D val;
> +		/* If the watchdog is active then we sent a keepalive ping

s/sent/send/

> +		 * to make sure that the watchdog keep's running (and if
> +		 * possible that it takes the new timeout) */
> +		watchdog_ping(wdd);
> +		/* Fall */
> +	case WDIOC_GETTIMEOUT:
> +		/* timeout =3D=3D 0 means that we don't know the timeout */
> +		if (wdd->timeout)
> +			return put_user(wdd->timeout, p);
> +		return -EOPNOTSUPP;

I'd suggest to swap the logic here (branch taken on error):=20
=20
        if (wdd->timeout =3D=3D 0)=20
                return -EOPNOTSUPP;=20
        return put_user();=20

>  	default:
>  		return -ENOTTY;
>  	}

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4bbHUACgkQD27XaX1/VRv4OQCgvayPw21bYN15X588xC1pXAE4
kx8AoJNilDX1wkA07Cm95uybnD38Y4Md
=L4rY
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--

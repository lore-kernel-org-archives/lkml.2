Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2E2Cch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:32:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab2E2Ccg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:32:36 -0400
Message-ID: <1338258732.20487.171.camel@deadeye>
Subject: Re: [PATCH V2] MMC: core: cap MMC card timeouts at 2 seconds.
From: Ben Hutchings <ben@decadent.org.uk>
To: "Torne (Richard Coles)" <torne@google.com>
Cc: cjb@laptop.org, linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 May 2012 03:32:12 +0100
In-Reply-To: <1338226278-13336-1-git-send-email-torne@google.com>
References: <1338226278-13336-1-git-send-email-torne@google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FiFduHqgyPvp/JPgSek9"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FiFduHqgyPvp/JPgSek9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-28 at 18:31 +0100, Torne (Richard Coles) wrote:
> From: "Torne (Richard Coles)" <torne@google.com>
>=20
> MMC CSD info can specify very large, ridiculous timeouts, big enough to
> overflow timeout_ns on 32-bit machines. This can result in the card
> timing out on every operation because the wrapped timeout value is far
> too small.
>=20
> Fix the overflow by capping the result at 2 seconds.  Cards specifying
> longer timeouts are almost certainly insane, and host controllers
> generally cannot support timeouts that long in any case.
>=20
> 2 seconds should be plenty of time for any card to actually function;
> the timeout calculation code is already using 1 second as a "worst case"
> timeout for cards running in SPI mode.

Needs a 'Signed-off-by'.

> ---
>  drivers/mmc/core/core.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 0b6141d..3b4a9fc 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, con=
st struct mmc_card *card)
>  	if (data->flags & MMC_DATA_WRITE)
>  		mult <<=3D card->csd.r2w_factor;
> =20
> -	data->timeout_ns =3D card->csd.tacc_ns * mult;
> +	/*
> +	 * The timeout in nanoseconds may overflow with some cards. Cap it at
> +	 * two seconds both to avoid the overflow and also because host
> +	 * controllers cannot generally generate timeouts that long anyway.
> +	 */
> +	if (card->csd.tacc_ns <=3D (2 * NSEC_PER_SEC) / mult)
> +		data->timeout_ns =3D card->csd.tacc_ns * mult;
> +	else
> +		data->timeout_ns =3D 2 * NSEC_PER_SEC;

We clearly need to guard against overflow here, and this is the correct
way to clamp the multiplication.  I can't speak as to whether 2 seconds
is the right limit.

Ben.

>  	data->timeout_clks =3D card->csd.tacc_clks * mult;
> =20
>  	/*

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-FiFduHqgyPvp/JPgSek9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8Q1LOe/yOyVhhEJAQomIBAAgxPwCoV5gpA5yGhfUJl4xYqC+7qst+oo
M55xwm56KN0NXaC8X8B8bpqZ3nEF1NimcgK7WHlqofVvGCtLb3GwUuXmF7AWbLOT
DCtOHzm/VUyASg8LyUFLd87Hkr0dqQvMkIWHTJzLJyIqexGjHbEvt+UES7r72t9j
gw0fWylc566srOiMWXjfDsjPoKWJas1GShy4x0DzEKm3vTCNmz2Tp04JUOnKR5ya
L2afstW3GdOfa9/h/mvsaCx3BEHSTGsk3IpgZbstMv/OL0FK0+skSlg9aRDBh3it
iHu8soKf7NHNh/rmpOb3I/AfOZnqo62LMj94O5z9wh4JT0nQkhWWiYoVr1vwu3Nf
JXRBlmpoaTDx0g8281rjrvJsdmDWxWTdUQ9r13Ij4JUdceyOU/EskfcAHBHxjw2c
0eOCcvs6bRfRGxEXLGn30jkkZZRGIm23mK749j9HS6vkO6ksu2Hxhj/RIl95QU1s
yT3Z4EE4MHZJWllBgL/P4M9I3O/D5gooJmO0K1xEcPw1AjwcjNJWtjLrz8TBDC5b
oCYMSyH/udVkdgKWyHb62ezpXVz1Ouf3tiMRp0iyVxFptx0/tBXF6kUHkjWfWAmR
vgMpS0PeCSHeMZWO18dbcHVA4i0ol2QuzJSO8EhHnah1PS1VfQJ85JVEErv6gcFH
eJi9tw73mfU=
=dVXa
-----END PGP SIGNATURE-----

--=-FiFduHqgyPvp/JPgSek9--

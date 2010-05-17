Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0EQJPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:15:24 -0400
Received: from smtp-out110.alice.it ([85.37.17.110]:2609 "EHLO
	smtp-out110.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0EQJPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:15:22 -0400
Date: Mon, 17 May 2010 11:15:13 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [PATCH] leds-lp3944: properly handle lp3944_configure fail in
 lp3944_probe
Message-Id: <20100517111513.f76c0bb9.ospite@studenti.unina.it>
In-Reply-To: <1274060042.17226.2.camel@mola>
References: <1274060042.17226.2.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_May_2010_11_15_13_+0200_S47N2iG7Ae2yteIP"
X-OriginalArrivalTime: 17 May 2010 09:15:19.0928 (UTC) FILETIME=[78D58780:01CAF5A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_May_2010_11_15_13_+0200_S47N2iG7Ae2yteIP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 17 May 2010 09:34:02 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> In current implementation, lp3944_probe return 0 even if lp3944_configure=
 fail.
> Therefore, led_classdev_unregister will be executed twice ( in error hand=
ling of lp3944_configure and lp3944_remove ).
> This patch properly handles lp3944_configure fail in lp3944_probe.
>

Hi Axel, thanks for the fix, I agree it's needed.
There are some minor comments inlined below.

Plus, when possible, I prefer commit messages to be wrapped to 72/80
characters per line. Please, consider this if you are sending a v2.

Ah, may I ask where you are using this driver? Just curious.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/leds/leds-lp3944.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
> index 8d5ecce..03a24d0 100644
> --- a/drivers/leds/leds-lp3944.c
> +++ b/drivers/leds/leds-lp3944.c
> @@ -379,6 +379,7 @@ static int __devinit lp3944_probe(struct i2c_client *=
client,
>  {
>  	struct lp3944_platform_data *lp3944_pdata =3D client->dev.platform_data;
>  	struct lp3944_data *data;
> +	int err;
> =20
>  	if (lp3944_pdata =3D=3D NULL) {
>  		dev_err(&client->dev, "no platform data\n");
> @@ -403,8 +404,15 @@ static int __devinit lp3944_probe(struct i2c_client =
*client,
> =20
>  	dev_info(&client->dev, "lp3944 enabled\n");
> =20
> -	lp3944_configure(client, data, lp3944_pdata);
> +	err =3D lp3944_configure(client, data, lp3944_pdata);
> +	if (err < 0)
> +		goto err_configure;
> +

The dev_info(&client->dev, "lp3944 enabled\n"); could now go right
here, before the return 0, so we don't report the driver as enabled
even in the case its probe fails.

>  	return 0;
> +
> +err_configure:
> +	kfree(data);

add i2c_set_clientdata(client, NULL) here just like in lp3944_remove()

> +	return err;
>  }
> =20
>  static int __devexit lp3944_remove(struct i2c_client *client)
> --=20
> 1.5.4.3
>=20

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Mon__17_May_2010_11_15_13_+0200_S47N2iG7Ae2yteIP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvxCSEACgkQ5xr2akVTsAFFmwCgnZX3yFmev4sH2fnbqLhuxbih
714Ani0k4SG16mjXIPY5OEDDOC4gOBAC
=Pnmt
-----END PGP SIGNATURE-----

--Signature=_Mon__17_May_2010_11_15_13_+0200_S47N2iG7Ae2yteIP--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2IWSWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 14:22:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41837 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2IWSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 14:22:12 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, vda.linux@googlemail.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux@horizon.com
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
In-Reply-To: <1343971271-13355-3-git-send-email-linux@horizon.com>
Organization: Google Inc
References: <1343971271-13355-1-git-send-email-linux@horizon.com> <1343971271-13355-3-git-send-email-linux@horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Sun, 23 Sep 2012 20:22:02 +0200
Message-ID: <xa1ttxuo61md.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03 2012, George Spelvin wrote:
> If you're going to have a conditional branch after
> each 32x32->64-bit multiply, might as well shrink the code
> and make it a loop.
>
> This also avoids using the long multiply for small integers.
>
> (This leaves the comments in a confusing state, but that's a separate
> patch to make review easier.)
>
> Signed-off-by: George Spelvin <linux@horizon.com>

NAK.

> ---
>  lib/vsprintf.c |   20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index a8e7392..3ca77b8 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -174,20 +174,12 @@ char *put_dec_trunc8(char *buf, unsigned r)
>  	unsigned q;
>=20=20
>  	/* Copy of previous function's body with added early returns */
> -	q      =3D (r * (uint64_t)0x1999999a) >> 32;
> -	*buf++ =3D (r - 10 * q) + '0'; /* 2 */
> -	if (q =3D=3D 0)
> -		return buf;
> -	r      =3D (q * (uint64_t)0x1999999a) >> 32;
> -	*buf++ =3D (q - 10 * r) + '0'; /* 3 */
> -	if (r =3D=3D 0)
> -		return buf;
> -	q      =3D (r * (uint64_t)0x1999999a) >> 32;
> -	*buf++ =3D (r - 10 * q) + '0'; /* 4 */
> -	if (q =3D=3D 0)
> -		return buf;
> -	r      =3D (q * (uint64_t)0x1999999a) >> 32;
> -	*buf++ =3D (q - 10 * r) + '0'; /* 5 */
> +	while (r >=3D 10000) {
> +		q =3D r + '0';
> +		r  =3D (r * (uint64_t)0x1999999a) >> 32;
> +		*buf++ =3D q - 10*r;
> +	}

This loop looks nothing like the original code.  Why are you adding '0'
at the beginning?  Also, the original code switches the role of q and r,
the loop does not.

>  	if (r =3D=3D 0)
>  		return buf;
>  	q      =3D (r * 0x199a) >> 16;

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQX1NKAAoJECBgQBJQdR/0OI0P/0fE8AOqbg2D+VIaanMH5WLO
oDnXdJiRGHEEqEmEGOuE7PyJYfFZnd4ruEvJXZ/Vi4dTWXjwcWyG5T1QaVFieVYU
RBGSYiFKc9GwIh6wKnayVBMjSuyPgqVh9IPulymbaf6D4+wrSbzWqLgvRibT95eL
gA5Xne9tK9xE0vgmVru670Eo3zYScv9F6EKIZUOmPrqIPRxaN10ClG6/+ukHBEXT
TtiT6ZWUkuWdtEWiIS5Kic8oXa0uz29qJ9WtqG2pGZRpc4eJCbL0la4HvVY+sOqw
iOhsZZueonarrC/KEJj/neIZXJQEJgE7ePhlLQlnC5iHWfcD0i1zd3hClogbu9g8
vMjnovd9HIMAecYzhzOhRWcy7Vf0tKnYGFMdBKNBF3/Ec1rY80+Qa4BjSKcmlJag
dLHiCFjlAWq4cnpH5JybQFxjKqAvak2kW4dfkvjTZR2Bf8v6BkE/HvPyiuLssknz
uiDJUPcKn8zJ0GfP3i+4Jyr48dDrF5aG9SHFgyl7LF5o9G+J1emw8U5b5lR/3c1M
kI4uXxLeOe7gNq8hYBnFhxeQGcxTb5/EBrPBKYRCr6/BPO6m81QKgglaIYWb6ZOp
wTaQEYDk46wqy0U3dKLF7kmPiqr+FSXROQecRg4DruNqyGt55WjBAGTK8MJFdsnV
wXYM5VQYo4wZqB9lMIFQ
=KY+9
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

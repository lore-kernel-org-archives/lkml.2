Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2IWRXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:23:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58253 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2IWRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:23:05 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, vda.linux@googlemail.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux@horizon.com
Subject: Re: [PATCH 1/4] lib: vsprintf: Optimize division by 10 for small integers.
In-Reply-To: <1343971271-13355-1-git-send-email-linux@horizon.com>
Organization: Google Inc
References: <1343971271-13355-1-git-send-email-linux@horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Sun, 23 Sep 2012 19:22:54 +0200
Message-ID: <xa1tzk4g64cx.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03 2012, George Spelvin <linux@horizon.com> wrote:
> Shrink the reciprocal approximations used in put_dec_full4
> based on the comments in put_dec_full9.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> Cc: Denys Vlasenko <vda.linux@googlemail.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Have you verified that the comment is correct?

> ---
>  lib/vsprintf.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> I was looking over the code and noticed that the constants could be small=
er.
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index c3f36d41..2f32fe8 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -243,13 +243,14 @@ char *put_dec(char *buf, unsigned long long n)
>=20=20
>  /* Second algorithm: valid only for 64-bit long longs */
>=20=20
> +/* See comment in put_dec_full9 for choice of constants */
>  static noinline_for_stack
>  char *put_dec_full4(char *buf, unsigned q)
>  {
>  	unsigned r;
> -	r      =3D (q * 0xcccd) >> 19;
> +	r      =3D (q * 0xccd) >> 15;
>  	*buf++ =3D (q - 10 * r) + '0';
> -	q      =3D (r * 0x199a) >> 16;
> +	q      =3D (r * 0xcd) >> 11;
>  	*buf++ =3D (r - 10 * q)  + '0';
>  	r      =3D (q * 0xcd) >> 11;

If you are changing everything, this could also be changed to:

	r      =3D (q * 0x67) >> 10;

no?

>  	*buf++ =3D (q - 10 * r)  + '0';

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

iQIcBAEBAgAGBQJQX0VuAAoJECBgQBJQdR/0uL8P/2tVMiXczjxOrCecp25ugTxS
itLhW3YB0n1KkffGMLIyecK4vjzwUWl/3X58BWzYO2rtG69TPjHy5XfGAB2B992I
S2ZWgCvMqZmKolxht0iekTY/qRX7MY428DKrD/8gB3iZ8B+RmhizqF7VIVytc7xC
X5X8HRhpqvpABrQRL9+OWi7nTvDlilZodF19CGCj9JhzMA4KQKix0MCQftXILkRi
cqsqaKKRIzoftZNOML2B/PnhiqigZYUH3nm2SbIA2FMn2XDcHEYqfKoIMu0FmhP2
rtBgu9pnC2Kc3GPP04E3vZ546Cxl7mMrRlLPCzu2H1bbBrSNZFoQ/v8sqnNCUaBB
yrJIm3jxyhDB43HueigddxXWR06bPXvmmHzdE2Lh9OMZydU8npsSKpWIEmGq8QF2
TMmf6pS0Fjvd7nA5GdLEjhTPf1aEP8E+SbYOhMVVBa0PEuc0IU/nj8Su1zvWdTvv
NzEQK3mC6T7rSjghBJphJol7P8RYhaiUMYi+ThbVyYSEzmDnIrU3Z9aVUsOJMGWi
21fkydszFjpWHup7qLPiTutOmblV5Z5cU6iVd05qmNybMszcPXUYg/+YEUVe5CCy
arOJ//FThb7LI4u23DUEkMfGYzVi52g0CCcPos5SXbYPfXO1XjcV7A6mynRdwRgR
cL1gpImeGSd55q4p3vhB
=dzvR
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

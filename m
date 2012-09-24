Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2IXOyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:54:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50421 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2IXOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:53:58 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        linux@horizon.com, rabin@rab.in
Cc: hughd@google.com, linux-kernel@vger.kernel.org, vda.linux@googlemail.com
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
In-Reply-To: <20120924143305.30771.qmail@science.horizon.com>
Organization: Google Inc
References: <20120924143305.30771.qmail@science.horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 24 Sep 2012 16:53:48 +0200
Message-ID: <xa1t4nmncw03.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 24 2012, George Spelvin wrote:
> The fix is straightforward:
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index e755083..9872855 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -180,8 +180,6 @@ char *put_dec_trunc8(char *buf, unsigned r)
>  		*buf++ =3D q - 10*r;
>  	}
>=20=20
> -	if (r =3D=3D 0)
> -		return buf;
>  	q      =3D (r * 0x199a) >> 16;	/* r <=3D 9999 */
>  	*buf++ =3D (r - 10 * q)  + '0';
>  	if (q =3D=3D 0)
>
> Inspired by Michal Nazarewicz, I have some ideas for more tweaking to
> that code.

Ah, right.  I also thought about that first but than started worrying
that it could produce unnecessary zeros if the loop iterates at least
once and exits with r being zero, but now I see that this cannot happen
since if the loop condition was true, r >=3D 10000 and it has been divided
by 10000 in the loop so now it's at least 1.

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

iQIcBAEBAgAGBQJQYHP8AAoJECBgQBJQdR/0GlgP/320ld1YFw5iBWuMXCwo6QUn
CWfCyeTtzlali8PvSaJvjAuBWqe3Nck80W8QBekA6GINuhrzezqvh6vBqlbOsTRc
Ijo/6ZBsF5Q1tnoV5yordVQ74dRuFLjUvJbKLsuIVSKlfF45WvTszbEC3IRqcZzi
wlu0Ialp+EOQ9KR/diIKs989mfiFXD3jgnKN9nYxPfl8/3DfHGcrDqB44GdvZlxq
XDdveyIremGlUCaPBWikCy08lk4vXefWmYVyyu60i3YJcmBKxmLSFis5HBDnCyoA
lzoYmiQFKnJT03Ov5i14pWH+NO+lva4D3NShMqIAkNWbBZUtGVMfu7z/cIrzK65I
uWJ0/YmaRlhXrX+DC8ty50OsuX0TCGZVfD0ou1nyfFKJVeThjClmKJdkc7xFxAoR
L4v7nXdJBJ8qn5jEZBDa8JzNvX3M4FDOBl2aVybHjp5Ov+uEqx3jEEAJCIkNV2tO
TcVrh08TL1Hqoav/UDPxwU0JkoxDHCApZ2sn1VKFSjy/3A+wyny7vmNoNoKcdGp5
uAqzMspUcEtKzTwZ8FoBcQp4yNiaTlAGmKCRDkg+J8KJynFVEVlInnAJYZ1B1O2Z
aiuCRz/KoL54ECIQvxjQ09g4WBbR890a/b+DGU6uz1IZyqmE6Tr+KZU1r9DjrQOR
0FYUIaj9MzgDD2MQIy3a
=qtix
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

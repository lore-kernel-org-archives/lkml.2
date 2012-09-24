Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2IXPGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:06:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56158 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2IXPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:06:14 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, linux@horizon.com,
        vda.linux@googlemail.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
In-Reply-To: <20120924134939.23197.qmail@science.horizon.com>
Organization: Google Inc
References: <20120924134939.23197.qmail@science.horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 24 Sep 2012 17:06:04 +0200
Message-ID: <xa1ty5jzbgv7.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 24 2012, George Spelvin wrote:
> Michal Nazarewicz <mpn@google.com> wrote:
>> static noinline_for_stack
>> char *put_dec_trunc8(char *buf, unsigned r) {
>> 	unsigned q;
>>=20
>> 	if (r > 10000) {
>> 		do {
>> 			q =3D r + '0';
>> 			r =3D (r * (uint64_t)0x1999999a) >> 32;
>> 			*buf++ =3D q - 10 * r;
>> 		} while (r >=3D 10000);
>> 		if (r =3D=3D 0)
>> 			return buf;
>> 	}
>>=20
>> 	q      =3D (r * 0x199a) >> 16;
>> 	*buf++ =3D (r - 10 * q)  + '0'; /* 6 */
[...]
>> 	return buf;
>> }
>
> Two bugs:
>
> 1) The initial "(r > 10000)" should be >=3D.
>    If you let r =3D=3D 10000 through to the remaining code, you'll get
>    ":000".

Obviously... ;)

>
> 2) The "r =3D=3D 0" test isn't necessary.
>    Given that the loop divides r by 10 each time, r >=3D 10000 at the
>    beginning implies r >=3D 1000 at the end, so 1000 <=3D r < 10000
>    when the loop exits.

Yeah, I've just figured that out. :]
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

iQIcBAEBAgAGBQJQYHbcAAoJECBgQBJQdR/0qmkP/35qV4DjlnI8cQ6eCs1wF6Uq
aBY6h5ASH2YwEiXgybK/pl2GGTCH+T+eytYxL9LxtX+8diCjacmKwkOd9PULHcxD
DZrPqffwIrePySVutlZSjC++T9mZCoueae9ekTcZe8sHcc/1bTEA0I725OFEHTF+
qW1DoQPyKHLYZ6rgnLEFvZiK2akVoD4igTUVUpwiWmM2wI4Zy5/MSZ/pUZjELwio
RbDvrOq2KhOUuf6RNF1YnFvd7VN50cfi3/cufNCe/R/V6tFcdr5TA/c0+rr5BsK2
ccrB5/YSjhtCh6YWnS+YY1Qsi7p67BZ0a5+SUysRvWY0nP6kJ+zdC3qoHUsTd/FA
c7x7Urz7I+Eg+HC/tXEXu6lXpaaDJHzasHjsW7BUVspGxUAOLgeCNRmXJrjia9+J
yxztrG0bAqYLm8PCtiHoBGTHQePxKZ2noE2aF6efewmPZv1ohLR+6iqcLoYr4wuy
dNfExze7RwZrrTgilLSWiVkDnqkSecTnj/hnAT/skONidpFdFSLpkVhwNQ6cibuN
HXASRfaiUY3jjXxHOFHSA3sEGDZKpSse7kaRpGsycA7VRuyejxKONuTNZngvcKeo
0JmGT84zsaVmllVT5z39QfN/1rn+m2zIPlAn9DyrlOUc2kYgZEGfdUvtfVqXp0hd
rLJKjlnNVcCpaZchAv3W
=5htg
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

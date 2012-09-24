Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2IXMaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:30:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44320 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab2IXMaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:30:11 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, linux@horizon.com,
        vda.linux@googlemail.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
In-Reply-To: <20120924114602.501.qmail@science.horizon.com>
Organization: Google Inc
References: <20120924114602.501.qmail@science.horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 24 Sep 2012 14:29:56 +0200
Message-ID: <xa1tipb3d2nv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>>> @@ -174,20 +174,12 @@ char *put_dec_trunc8(char *buf, unsigned r)
>>>  	unsigned q;
>>>  	/* Copy of previous function's body with added early returns */
>>> -	q      =3D (r * (uint64_t)0x1999999a) >> 32;
>>> -	*buf++ =3D (r - 10 * q) + '0'; /* 2 */
>>> -	if (q =3D=3D 0)
>>> -		return buf;
>>> -	r      =3D (q * (uint64_t)0x1999999a) >> 32;
>>> -	*buf++ =3D (q - 10 * r) + '0'; /* 3 */
>>> -	if (r =3D=3D 0)
>>> -		return buf;
>>> -	q      =3D (r * (uint64_t)0x1999999a) >> 32;
>>> -	*buf++ =3D (r - 10 * q) + '0'; /* 4 */
>>> -	if (q =3D=3D 0)
>>> -		return buf;
>>> -	r      =3D (q * (uint64_t)0x1999999a) >> 32;
>>> -	*buf++ =3D (q - 10 * r) + '0'; /* 5 */
>>> +	while (r >=3D 10000) {
>>> +		q =3D r + '0';
>>> +		r  =3D (r * (uint64_t)0x1999999a) >> 32;
>>> +		*buf++ =3D q - 10*r;
>>> +	}

All right, I now see what the loop is doing (I couldn't grasp it
yesterday) and expect for r=3D0 it looks legit.

On Mon, Sep 24 2012, George Spelvin wrote:
> Truthfully, it would have made *more* sense to swap q and r globally,
> so the loop had a more sensible q=3Dquotient/r=3Dremainder assignment,
> but I wanted to show that the unmodified tail was in fact unmodified.

The original has it a bit awkwardly because it just copies code from
put_dec_full9() with the first iteration skipped.

> The big saving from using a loop is that it avoids unnecessary
> 32x32->64-bit multiplies, falling through to the 16x16->32-bit
> code as early as possible.  Given that most numbers are small,
> this seemed like a significant win.

Ah, makes sense.

I guess the following should work, even though it's not so pretty:

static noinline_for_stack
char *put_dec_trunc8(char *buf, unsigned r) {
	unsigned q;

	if (r > 10000) {
		do {
			q =3D r + '0';
			r =3D (r * (uint64_t)0x1999999a) >> 32;
			*buf++ =3D q - 10 * r;
		} while (r >=3D 10000);
		if (r =3D=3D 0)
			return buf;
	}

	q      =3D (r * 0x199a) >> 16;
	*buf++ =3D (r - 10 * q)  + '0'; /* 6 */
	if (q =3D=3D 0)
		return buf;
	r      =3D (q * 0xcd) >> 11;
	*buf++ =3D (q - 10 * r)  + '0'; /* 7 */
	if (r =3D=3D 0)
		return buf;
	q      =3D (r * 0xcd) >> 11;
	*buf++ =3D (r - 10 * q) + '0'; /* 8 */
	if (q =3D=3D 0)
		return buf;
	*buf++ =3D q + '0'; /* 9 */
	return buf;
}

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

iQIcBAEBAgAGBQJQYFJEAAoJECBgQBJQdR/08tQP/1whPN+KczKDi7cOgtzEBMqd
Y4fyl+0RILxLCQDwBWI8AK8fgtFwG1qViN4g6CJEs3Hstmc75j34LCOMIdRSLEiC
1EUyp3eOQcfk3QLs3gFjiTDVnhqGNxchCUtn1o2pwPyCDjUQyD5Agovk8Xum0zGO
XF5l5CkNu9gg0pNo6Jas41M0z4LL5Kv2ur/Y7T6ydSZ2BMZTKAj7aTYizuim7sp4
ITNtso1OnhMtyO8uPsBnNXguuAWprkGEGGpWd5GCk7ltb6kp7mgK6NpQLwB51uLd
svi0Mb04wBzPKk7xBXxI2475IT53QmsqL7UP9SGzfXW2Icrmhh8b9SS4wcT946kk
2ARUY4xhMrnFp1E5lJ/52ZuNIMVK1bZf5Qg1gaNi93VMV/NOX2pGDpAxzSQNKuTw
p1UqrZSflyGeJhRIUkyQqO5pfNyl1Z8kC9/2GUsyQXabVRMBoMDQRm0eDUVrwsOX
kZldZrPlpNDjcpPhzTRqImIQtjxKz4glrPo3ztZm56dcMST1rR48xG6PKsjQVKRW
ITjbHwTls3pwCx0v1KkekNT+xKgYaj660ZNAuX63rKUSLpMSEnPfmnQgi4TFkmX7
bGD9ZuhCM670pMZL+YxyMFmPy7tw00sr7PMN03c9KqScdiUcRWkBu/hTYUaUiLGM
WLmMHCW4xTqueiLQllXU
=Bwpg
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

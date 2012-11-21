Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2KUNHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:07:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45868 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2KUNHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:07:14 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES approaches low water mark
In-Reply-To: <20121121010556.GD447@bbox>
Organization: http://mina86.com/
References: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com> <20121120000137.GC447@bbox> <50AB987F.30002@samsung.com> <20121121010556.GD447@bbox>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 21 Nov 2012 14:07:04 +0100
Message-ID: <xa1t7gpfgl53.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21 2012, Minchan Kim wrote:
> So your concern is that too many free pages in MIGRATE_CMA when OOM happe=
ns
> is odd? It's natural with considering CMA design which kernel never fallb=
ack
> non-movable page allocation to CMA area. I guess it's not a your concern.
>
> Let's think below extreme cases.
>
> =3D Before =3D
>
> * 1000M DRAM system.
> * 400M kernel used pages.
> * 300M movable used pages.
> * 300M cma freed pages.
>
> 1. kernel want to request 400M non-movable memory, additionally.
> 2. VM start to reclaim 300M movable pages.
> 3. But it's not enough to meet 400M request.
> 4. go to OOM. (It's natural)
>
> =3D After(with your patch) =3D
>
> * 1000M DRAM system.
> * 400M kernel used pages.
> * 300M movable *freed* pages.
> * 300M cma used pages(by your patch, I simplified your concept)
>
> 1. kernel want to request 400M non-movable memory.
> 2. 300M movable freed pages isn't enough to meet 400M request.
> 3. Also, there is no point to reclaim CMA pages for non-movable allocatio=
n.
> 4. go to OOM. (It's natural)
>
> There is no difference between before and after in allocation POV.
> Let's think another example.
>
> =3D Before =3D
>
> * 1000M DRAM system.
> * 400M kernel used pages.
> * 300M movable used pages.
> * 300M cma freed pages.
>
> 1. kernel want to request 300M non-movable memory.
> 2. VM start to reclaim 300M movable pages.
> 3. It's enough to meet 300M request.
> 4. happy end
>
> =3D After(with your patch) =3D
>
> * 1000M DRAM system.
> * 400M kernel used pages.
> * 300M movable *freed* pages.
> * 300M cma used pages(by your patch, I simplified your concept)
>
> 1. kernel want to request 300M non-movable memory.
> 2. 300M movable freed pages is enough to meet 300M request.
> 3. happy end.
>
> There is no difference in allocation POV, too.

The difference thou is that before 30% of memory is wasted (ie. free),
whereas after all memory is used.  The main point of CMA is to make the
memory useful if devices are not using it.  Having it not allocated is
defeating that purpose.

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
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQrNH5AAoJECBgQBJQdR/0HxIP/2enYW5oBYHD39pEIHzQq7zd
oYiUlYBNFFtrbqmplZ15ik+zPGvasFtkl2pvpurFcbRhfE0ZCo7D/MNkDKqMfxcH
nEIkIjkb/XRH2t8Fx5vcjAJgsFdJLGmuXjOD4TNnXiTJjj9i19Kj9ytOPneqoBEK
I2Evv6itOO1UISujo9/NKHlLFmIaCRDnqRp/wXYfqNytIog22BXB8OHcTRMIaD/Q
WKSeEKOkWpftLoOfQ8SW3FCQhOILlwgC5kFk9DpEqANwR8T3OY6O/VNR0Ef0i+Zq
VWerm0s1mne5tZvcmMkLaPjAnwIdRe9EIuFLIcP1nkTJd5Ujo1WTgkslFV+BenCI
hMx925+HJPR3CleKAgHcrOehwM5Sl2ZZLwKn89rWFO0xPzEyPIo1iaUZYygLL9Ip
pIGuhVq5pqxcqMIQ92qg8CHZdFPk3MXAWR+Iq4Q/6lDOQbHbUqwUV9YTs0yuC8wI
VUOEt6OMqvNqxTY+QuAt9D93kDHAPzC3V1tG2f81Lf8pX12YMleRapWycaztTdlr
9q8VpFIgeUgvZwLYu1uxIB5b7LRjalmmuuLPFR3vUSMOkWqzWcxdqE/ynrBBMB1Y
nXajqOWgZZdgLiTKekJF1RhpmTIPpJN4jtbeuw2pATTPbrxjMo6rDV4Ji2V5u0S9
JvU43xmWTd63QZxZqWKG
=YdG9
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

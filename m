Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2KLQnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:43:03 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50298 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2KLQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:43:00 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: WARN if freed memory is still in use
In-Reply-To: <1352718446-32313-1-git-send-email-m.szyprowski@samsung.com>
Organization: http://mina86.com/
References: <1352718446-32313-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 12 Nov 2012 17:42:50 +0100
Message-ID: <xa1t8va6zsad.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12 2012, Marek Szyprowski wrote:
> Memory return to free_contig_range() must have no other references. Let
> kernel to complain loudly if page reference count is not equal to 1.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 022e4ed..290c2eb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5888,8 +5888,13 @@ done:
>=20=20
>  void free_contig_range(unsigned long pfn, unsigned nr_pages)
>  {
> -	for (; nr_pages--; ++pfn)
> -		__free_page(pfn_to_page(pfn));
> +	struct page *page =3D pfn_to_page(pfn);
> +	int refcount =3D nr_pages;
> +	for (; nr_pages--; page++) {
> +		refcount -=3D page_count(page) =3D=3D 1;
> +		__free_page(page);
> +	}
> +	WARN(refcount !=3D 0, "some pages are still in use!\n");

This decrementing logic seem backward to me.  Why not:

	struct page *page =3D pfn_to_page(pfn);
	unsigned int refcount =3D 0;
	for (; nr_pages--; page++) {
		refcount +=3D page_count(page) !=3D 1;
		__free_page(page);
	}
	WARN(refcount !=3D 0, "some pages are still in use!\n");

>  }
>  #endif

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

iQIcBAEBAgAGBQJQoScKAAoJECBgQBJQdR/0sNQQAIxdNyaczFaJA055aFVoZCoG
6w4IxqtMZeD96Vk0XD1msOH8wzmBknWEsknqKcRVEIp1Q05stiVlpn3Ny+1sUl6i
SjdUcVcyGJESvtQEA+af5M/PnOxXLj7kuFUGZ/knTOgN79V7cnR/3NvGpP8IBBJ4
xZeI/+PgxKXRIB07UqNeLnX6bQrwubxPPTOAZa9WzqajrtcT9RBD5qQRT4wzxzGb
+5MCVCa0GhhIfOXr7qsdMETIA+kJXycm9SMfVmJw3yoNt+GwLDKltQBRWMzH8xkN
404/qPkikDuNBdSRVRPhohQQ0JaOGOVk6r1pfGS8EDjEjGX0T8/r/OvihChdZ5fI
yxi0pMY9qBX2ExVkIwzbQ7no/vpFs1e/OmvpU4TCA/sBvxSAqn6n4slhJKAzHJai
emW78Y/j+obR5q8VdQaYPMgmI8ZW8y9GhhGIh8/COa6/wu+Gw2PJLTHLjRYQKe5D
90bTDChvuLc0ZNw0dTZ0GTvmMHqiGmpQnh/gMJAOuIYKHgyBWuDmqisnq+/M3HDz
MVIozN8sWLNn0+nbVt+CjfroQC42rcKhUP9AOwBqyUfC6o1gFFR4EBJFj7FLP/fM
zR15WXlKy5gkLLEAeLNca6Uy7ihoPTSn4Evhcpw7qYNVB2WjdsqQNyUrP7RmsPVy
LU7Y37q/6j/xF1gDrWgF
=4w/2
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

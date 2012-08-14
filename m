Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2HNOU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:20:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53239 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2HNOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:20:04 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC 2/2] cma: support MIGRATE_DISCARD
In-Reply-To: <1344934627-8473-3-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1344934627-8473-1-git-send-email-minchan@kernel.org> <1344934627-8473-3-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.13.2+121~gb26df7c (http://notmuchmail.org) Emacs/24.1.50.2 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 14 Aug 2012 16:19:55 +0200
Message-ID: <xa1t7gt1pnck.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Minchan Kim <minchan@kernel.org> writes:
> This patch introudes MIGRATE_DISCARD mode in migration.
> It drop clean cache pages instead of migration so that
> migration latency could be reduced. Of course, it could
> evict code pages but latency of big contiguous memory
> is more important than some background application's slow down
> in mobile embedded enviroment.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

This looks good to me.

> ---
>  include/linux/migrate_mode.h |   11 +++++++---
>  mm/migrate.c                 |   50 +++++++++++++++++++++++++++++++++---=
------
>  mm/page_alloc.c              |    2 +-
>  3 files changed, 49 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
> index ebf3d89..04ca19c 100644
> --- a/include/linux/migrate_mode.h
> +++ b/include/linux/migrate_mode.h
> @@ -6,11 +6,16 @@
>   *	on most operations but not ->writepage as the potential stall time
>   *	is too significant
>   * MIGRATE_SYNC will block when migrating pages
> + * MIGRTATE_DISCARD will discard clean cache page instead of migration
> + *
> + * MIGRATE_ASYNC, MIGRATE_SYNC_LIGHT, MIGRATE_SYNC shouldn't be used
> + * together as OR flag.
>   */
>  enum migrate_mode {
> -	MIGRATE_ASYNC,
> -	MIGRATE_SYNC_LIGHT,
> -	MIGRATE_SYNC,
> +	MIGRATE_ASYNC =3D 1 << 0,
> +	MIGRATE_SYNC_LIGHT =3D 1 << 1,
> +	MIGRATE_SYNC =3D 1 << 2,
> +	MIGRATE_DISCARD =3D 1 << 3,
>  };

Since CMA is the only user of MIGRATE_DISCARD it may be worth it to
guard it inside an #ifdef, eg:

#ifdef CONFIG_CMA
	MIGRATE_DISCARD =3D 1 << 3,
#define is_migrate_discard(mode) (((mode) & MIGRATE_DISCARD) =3D=3D MIGRATE=
_DISCARD)
#endif

=20=20
>  #endif		/* MIGRATE_MODE_H_INCLUDED */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 77ed2d7..8119a59 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -685,9 +685,12 @@ static int __unmap_and_move(struct page *page, struc=
t page *newpage,
>  	int remap_swapcache =3D 1;
>  	struct mem_cgroup *mem;
>  	struct anon_vma *anon_vma =3D NULL;
> +	enum ttu_flags ttu_flags;
> +	bool discard_mode =3D false;
> +	bool file =3D false;
>=20=20
>  	if (!trylock_page(page)) {
> -		if (!force || mode =3D=3D MIGRATE_ASYNC)
> +		if (!force || mode & MIGRATE_ASYNC)

+		if (!force || (mode & MIGRATE_ASYNC))

>  			goto out;
>=20=20
>  		/*


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

iQIcBAEBAgAGBQJQKl6LAAoJECBgQBJQdR/0goYP/0/hPtydiXAf13PcPR+dWLrx
UhGN2//ZkV8KnA11/q/1fLJ7mIuUoR84gGi9PPkQUOdos5iOxoVj9yMB+UWlok68
qwrsOeBwJZLcYzpeLP3UAyuElxUBWCs4A/zvRXjA9Sb8Bnk0p7W/ONqfIjeYQsyN
phpxS8dEZkwLff4QOaQpHNYopTxDyBfjzbL2F0vlnXfP0NuLVEYk6BDE1d1oCXWt
7t61/34i3e5fNYGCybgxcmMWG32vzg6i1a1MTt4kXFVg+H8PtC8iM2u+/o0Ma2oW
76le3gW1P3zGFreBABKYViyu3MUEdS5yNzjspvCM7d20nTLlxKN7ZnqZF2Pmldwb
VU/eCmWTNbA3aCH+2zjbuV1M08CS4TmQcQa+T2Txp6PctRM6zfoM1v/kxdTgHKIW
PdtXiYN1yryjHGb6RDt34W9VGhEmiJ4wOtVb1taDHODM/VzrWe8YRIqvyqDjqTD8
PoyeoP4lqA71KZelHJh5KY7YXw0owROkesoADZcxWJ01D4jRo5m6G+ZkyfiAwVgj
IE3g4T5wcG4BxVPGazIni3HqoPX0HbSdbb7SnI4MHoSK1LypBGmuKsaoAqSb3o28
8qXxNNfPO2Cj6TNxyJDAkBnUXGL5b2nQYF1FR2Ha4t79ljqsMAX+54JqkOErWMtE
1MeBYF5Gv4LtAgQONM6c
=v1Nm
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

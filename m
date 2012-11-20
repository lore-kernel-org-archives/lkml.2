Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2KTPlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:41:23 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40020 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2KTPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:41:21 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES approaches low water mark
In-Reply-To: <50AB987F.30002@samsung.com>
Organization: http://mina86.com/
References: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com> <20121120000137.GC447@bbox> <50AB987F.30002@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 20 Nov 2012 16:41:12 +0100
Message-ID: <xa1tk3tgjn8n.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20 2012, Marek Szyprowski wrote:
> Right now running out of 'plain' movable pages is the only possibility to
> get movable pages allocated from CMA. On the other hand running out of
> 'plain' movable pages is very deadly for the system, as movable pageblocks
> are also the main fallbacks for reclaimable and non-movable pages.
>
> Then, once we run out of movable pages and kernel needs non-mobable or
> reclaimable page (what happens quite often), it usually triggers OOM to
> satisfy the memory needs. Such OOM is very strange, especially on a system
> with dozen of megabytes of CMA memory, having most of them free at the OOM
> event. By high memory pressure I mean the high memory usage.

Would it make sense to *always* use MIGRATE_CMA for movable allocations
before MIGRATE_MOVABLE?  Ie. how about this patch (not tested):

------------------------- >8 ----------------------------------------------=
---
>From 790a3b5743414f2770e413e5e8866679de2920b4 Mon Sep 17 00:00:00 2001
Message-Id: <790a3b5743414f2770e413e5e8866679de2920b4.1353425911.git.mina86=
@mina86.com>
From: Michal Nazarewicz <mina86@mina86.com>
Date: Tue, 20 Nov 2012 16:37:50 +0100
Subject: [PATCH] mm: cma: on movable allocations try MIGRATE_CMA first

It has been observed that system tends to keep a lot of CMA free pages
even in very high memory pressure use cases.  The CMA fallback for
movable pages is used very rarely, only when system is completely
pruned from MOVABLE pages.  This means that the out-of-memory is
triggered for unmovable allocations even when there are many CMA pages
available.  This problem was not observed previously since movable
pages were used as a fallback for unmovable allocations.

To avoid such situation this commit changes the allocation order so
that on movable allocations the MIGRATE_CMA pageblocks are used first.

This change means that the MIGRATE_CMA can be removed from fallback
path of the MIGRATE_MOVABLE type.  This means that the
__rmqueue_fallback() function will never deal with CMA pages and thus
all the checks around MIGRATE_CMA can be removed from that function.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 mm/page_alloc.c |   55 +++++++++++++++++++++++++--------------------------=
----
 1 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb90971..b60bd75 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -893,14 +893,12 @@ struct page *__rmqueue_smallest(struct zone *zone, un=
signed int order,
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
  */
-static int fallbacks[MIGRATE_TYPES][4] =3D {
+static int fallbacks[MIGRATE_TYPES][3] =3D {
 	[MIGRATE_UNMOVABLE]   =3D { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,     MIG=
RATE_RESERVE },
 	[MIGRATE_RECLAIMABLE] =3D { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,     MIG=
RATE_RESERVE },
+	[MIGRATE_MOVABLE]     =3D { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   MIG=
RATE_RESERVE },
 #ifdef CONFIG_CMA
-	[MIGRATE_MOVABLE]     =3D { MIGRATE_CMA,         MIGRATE_RECLAIMABLE, MIG=
RATE_UNMOVABLE, MIGRATE_RESERVE },
 	[MIGRATE_CMA]         =3D { MIGRATE_RESERVE }, /* Never used */
-#else
-	[MIGRATE_MOVABLE]     =3D { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   MIG=
RATE_RESERVE },
 #endif
 	[MIGRATE_RESERVE]     =3D { MIGRATE_RESERVE }, /* Never used */
 	[MIGRATE_ISOLATE]     =3D { MIGRATE_RESERVE }, /* Never used */
@@ -1019,17 +1017,10 @@ __rmqueue_fallback(struct zone *zone, int order, in=
t start_migratetype)
 			 * pages to the preferred allocation list. If falling
 			 * back for a reclaimable kernel allocation, be more
 			 * aggressive about taking ownership of free pages
-			 *
-			 * On the other hand, never change migration
-			 * type of MIGRATE_CMA pageblocks nor move CMA
-			 * pages on different free lists. We don't
-			 * want unmovable pages to be allocated from
-			 * MIGRATE_CMA areas.
 			 */
-			if (!is_migrate_cma(migratetype) &&
-			    (unlikely(current_order >=3D pageblock_order / 2) ||
-			     start_migratetype =3D=3D MIGRATE_RECLAIMABLE ||
-			     page_group_by_mobility_disabled)) {
+			if (unlikely(current_order >=3D pageblock_order / 2) ||
+			    start_migratetype =3D=3D MIGRATE_RECLAIMABLE ||
+			    page_group_by_mobility_disabled) {
 				int pages;
 				pages =3D move_freepages_block(zone, page,
 								start_migratetype);
@@ -1048,14 +1039,12 @@ __rmqueue_fallback(struct zone *zone, int order, in=
t start_migratetype)
 			rmv_page_order(page);
=20
 			/* Take ownership for orders >=3D pageblock_order */
-			if (current_order >=3D pageblock_order &&
-			    !is_migrate_cma(migratetype))
+			if (current_order >=3D pageblock_order)
 				change_pageblock_range(page, current_order,
 							start_migratetype);
=20
 			expand(zone, page, order, current_order, area,
-			       is_migrate_cma(migratetype)
-			     ? migratetype : start_migratetype);
+			       start_migratetype);
=20
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype);
@@ -1076,21 +1065,27 @@ static struct page *__rmqueue(struct zone *zone, un=
signed int order,
 {
 	struct page *page;
=20
-retry_reserve:
-	page =3D __rmqueue_smallest(zone, order, migratetype);
+#ifdef CONFIG_CMA
+	if (migratetype =3D=3D MIGRATE_MOVABLE)
+		migratetype =3D MIGRATE_CMA;
+#endif
=20
-	if (unlikely(!page) && migratetype !=3D MIGRATE_RESERVE) {
-		page =3D __rmqueue_fallback(zone, order, migratetype);
+	for(;;) {
+		page =3D __rmqueue_smallest(zone, order, migratetype);
+		if (likely(page) || migratetype =3D=3D MIGRATE_RESERVE)
+			break;
=20
-		/*
-		 * Use MIGRATE_RESERVE rather than fail an allocation. goto
-		 * is used because __rmqueue_smallest is an inline function
-		 * and we want just one call site
-		 */
-		if (!page) {
-			migratetype =3D MIGRATE_RESERVE;
-			goto retry_reserve;
+		if (is_migrate_cma(migratetype)) {
+			migratetype =3D MIGRATE_MOVABLE;
+			continue;
 		}
+
+		page =3D __rmqueue_fallback(zone, order, migratetype);
+		if (page)
+			break;
+
+		/* Use MIGRATE_RESERVE rather than fail an allocation. */
+		migratetype =3D MIGRATE_RESERVE;
 	}
=20
 	trace_mm_page_alloc_zone_locked(page, order, migratetype);
--=20
1.7.7.3

------------------------- >8 ----------------------------------------------=
---

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

iQIcBAEBAgAGBQJQq6SYAAoJECBgQBJQdR/0e4EP/ivO9Y56YDT4AKitaF0+AbgC
v7oYMVCxc817TESwJ7wpIeHfUshVSqNw9EsLr16zSZoL+P2Ktqvou8Nm+Td7OhcI
j+us23pWZf2uUvqYID5399n5aW/yhmKXUgP97pyIPf9EfNbZKJz052ZrOfBnborT
k861b/Iz75YdcJssEgm3TNXUy28nIw5ZWcOt7XAA+xvTE1xtzJ2aNDvsEEfwYi/q
w/mr6tRjsOcEjP/vchqAOj8sXONyPvhOjRBcHZ8uZjP+73DXjDcRSigAgDLB0nje
vhlOy60PayMfLc1jbMOnAfUDo97nKj0w3SLNvgNNse7CtluwuR+TVEw2G+Z2yoVg
yWWULNMER5IwcBnjg963t0b6ldK8udI+EQvYYnzDtw6RjOQkN1514+sK71z6FNam
Hqhgot+Fww9RU8YhWrVZS9NgctlZIedty/hFGH+V1WwUGdmhzIBlLxYw1YMG4Z1M
7Yht19iOYNXZCq2VipgWhbpclmPhAm19UuDL9CThEhz5hzStfyFB0sWGg2g1MN7y
P5sTG4TrL6Vtr+F3uu3WODQrBKU/q0999h83rwLDBJl5GPEZeweSvxLTFlYO42zC
ir8iAhjycb7Sfn4gQbdoKBO6yCTN218F3wAXOVN4rLhMGN+DjFwFc30xmJJXrD6Y
cUwPqwU6pFT7tQKubXfA
=98nZ
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

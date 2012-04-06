Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2DFGNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:13:43 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:52725 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab2DFGNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:13:41 -0400
Date: Fri, 6 Apr 2012 08:13:05 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stuart Foster <smf.linux@ntlworld.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>,
        Greg KH <gregkh@linuxfoundation.org>, nikola.ciprich@linuxbox.cz
Subject: Re: [ 101/175] mm: vmscan: forcibly scan highmem if there are too
	many buffer_heads pinning highmem
Message-ID: <20120406061248.GA16549@pcnci2.linuxbox.cz>
References: <20120330194845.531765417@linuxfoundation.org> <1333422093.443.32.camel@deadeye> <20120405202435.GA11562@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20120405202435.GA11562@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7340083 records (last update: 20120406)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, sorry it took me a bit longer.

here's my backport, compiles fine, kernel boots without any problems.
please review.
n.

Signed-off-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz

(backport of upstream commit cc715d99e529d470dde2f33a6614f255adea71f3)

    mm: vmscan: forcibly scan highmem if there are too many buffer_heads pi=
nning highmem
   =20
    Stuart Foster reported on bugzilla that copying large amounts of data
    from NTFS caused an OOM kill on 32-bit X86 with 16G of memory.  Andrew
    Morton correctly identified that the problem was NTFS was using 512
    blocks meaning each page had 8 buffer_heads in low memory pinning it.
   =20
    In the past, direct reclaim used to scan highmem even if the allocating
    process did not specify __GFP_HIGHMEM but not any more.  kswapd no long=
er
    will reclaim from zones that are above the high watermark.  The intenti=
on
    in both cases was to minimise unnecessary reclaim.  The downside is on
    machines with large amounts of highmem that lowmem can be fully consumed
    by buffer_heads with nothing trying to free them.
   =20
    The following patch is based on a suggestion by Andrew Morton to extend
    the buffer_heads_over_limit case to force kswapd and direct reclaim to
    scan the highmem zone regardless of the allocation request or watermark=
s.
   =20
    Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D42578

---

diff -Naur linux-3.0/mm/vmscan.c linux-3.0-cc715d99e529d470dde2f33a6614f255=
adea71f3-backport/mm/vmscan.c
--- linux-3.0/mm/vmscan.c	2012-04-05 23:09:28.364000004 +0200
+++ linux-3.0-cc715d99e529d470dde2f33a6614f255adea71f3-backport/mm/vmscan.c=
	2012-04-05 23:25:30.989968627 +0200
@@ -1581,6 +1581,14 @@
 			putback_lru_page(page);
 			continue;
 		}
+	=09
+		if (unlikely(buffer_heads_over_limit)) {
+			if (page_has_private(page) && trylock_page(page)) {
+				if (page_has_private(page))
+					try_to_release_page(page, 0);
+				unlock_page(page);
+			}
+		}
=20
 		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated +=3D hpage_nr_pages(page);
@@ -2053,6 +2061,14 @@
 	struct zoneref *z;
 	struct zone *zone;
=20
+	/*
+	 * If the number of buffer_heads in the machine exceeds the maximum
+	 * allowed level, force direct reclaim to scan the highmem zone as
+	 * highmem pages could be pinning lowmem pages storing buffer_heads
+	 */
+	if (buffer_heads_over_limit)
+		sc->gfp_mask |=3D __GFP_HIGHMEM;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 			gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2514,7 +2530,8 @@
 				(zone->present_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			if (!zone_watermark_ok_safe(zone, order,
+			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
+				!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone) + balance_gap,
 					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
@@ -2543,6 +2560,17 @@
 				continue;
 			}
=20
+			/*
+			 * If the number of buffer_heads in the machine
+			 * exceeds the maximum allowed level and this node
+			 * has a highmem zone, force kswapd to reclaim from
+			 * it to relieve lowmem pressure.
+			 */
+			if (buffer_heads_over_limit && is_highmem_idx(i)) {
+				end_zone =3D i;
+				break;
+			}
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok =3D 0;

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk9+iXEACgkQ3xdJJrLygV51twCglNnUc9/iJtFf3CqQlGaLelQ5
pGUAn0yKTum8qL8e1wbfagXB9JvUb5OS
=O+CH
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--

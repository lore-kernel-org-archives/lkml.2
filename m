Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935646Ab1JFGEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:04:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48063 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1JFGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:04:36 -0400
Date: Thu, 6 Oct 2011 17:04:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: linux-next: manual merge of the akpm with the writeback tree
Message-Id: <20111006170407.35faecf280510cae4e09539c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_17_04_07_+1100_Q2I_b/vp6kxLgHWn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_17_04_07_+1100_Q2I_b/vp6kxLgHWn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/page-writeback.c between commit 6c14ae1e92c7 ("writeback: dirty
position control") from the writeback tree and commit
"mm/page-writeback.c: make determine_dirtyable_memory static again" from
the akpm tree.

Just context (I think).  I fixed it up (see below) and can carry the fix
as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/page-writeback.c
index 325f753,da6d263..0000000
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@@ -296,73 -409,6 +355,12 @@@ int bdi_set_max_ratio(struct backing_de
  }
  EXPORT_SYMBOL(bdi_set_max_ratio);
 =20
- /*
-  * Work out the current dirty-memory clamping and background writeout
-  * thresholds.
-  *
-  * The main aim here is to lower them aggressively if there is a lot of m=
apped
-  * memory around.  To avoid stressing page reclaim with lots of unreclaim=
able
-  * pages.  It is better to clamp down on writers than to start swapping, =
and
-  * performing lots of scanning.
-  *
-  * We only allow 1/2 of the currently-unmapped memory to be dirtied.
-  *
-  * We don't permit the clamping level to fall below 5% - that is getting =
rather
-  * excessive.
-  *
-  * We make sure that the background writeout level is below the adjusted
-  * clamping level.
-  */
-=20
- static unsigned long highmem_dirtyable_memory(unsigned long total)
- {
- #ifdef CONFIG_HIGHMEM
- 	int node;
- 	unsigned long x =3D 0;
-=20
- 	for_each_node_state(node, N_HIGH_MEMORY) {
- 		struct zone *z =3D
- 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
-=20
- 		x +=3D zone_page_state(z, NR_FREE_PAGES) +
- 		     zone_reclaimable_pages(z);
- 	}
- 	/*
- 	 * Make sure that the number of highmem pages is never larger
- 	 * than the number of the total dirtyable memory. This can only
- 	 * occur in very strange VM situations but we want to make sure
- 	 * that this does not occur.
- 	 */
- 	return min(x, total);
- #else
- 	return 0;
- #endif
- }
-=20
- /**
-  * determine_dirtyable_memory - amount of memory that may be used
-  *
-  * Returns the numebr of pages that can currently be freed and used
-  * by the kernel for direct mappings.
-  */
- unsigned long determine_dirtyable_memory(void)
- {
- 	unsigned long x;
-=20
- 	x =3D global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
-=20
- 	if (!vm_highmem_is_dirtyable)
- 		x -=3D highmem_dirtyable_memory(x);
-=20
- 	return x + 1;	/* Ensure that we never return 0 */
- }
-=20
 +static unsigned long dirty_freerun_ceiling(unsigned long thresh,
 +					   unsigned long bg_thresh)
 +{
 +	return (thresh + bg_thresh) / 2;
 +}
 +
  static unsigned long hard_dirty_limit(unsigned long thresh)
  {
  	return max(thresh, global_dirty_limit);

--Signature=_Thu__6_Oct_2011_17_04_07_+1100_Q2I_b/vp6kxLgHWn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjUTXAAoJEECxmPOUX5FEPScP/0f+Y28Ya7/uaNSHdNWq5BCs
wCkRXUE5iDPBjI5FVJSpLkOeFo+UMGvAdPJlKv6vMlmtHyEy2WPwhfJ4bmRWUoc+
DBdDfA636KV9g1106pcu7aSnLfBMpnXBdoaheNfBYw3mN0pLIh8ya+tMv/rj0Rml
6yXI8BdM84O/rGZdB9qRBgARlnTw9qHzsGMw8lhhuA6djWrP+olmcWWBX/BP3cET
qSpmS6QGAhq1eghYtIZ2CmgblQf3xVDuCfjVimganeXe/ojvuUiHOMyZl1Kkj4Ng
1vYdNxOZBdjR1yi8H93S7FH2wNH58bMMy2beqWlWvgGTViwlHdLHHmm/rQxrCRs3
tNqRk8Z0qvAYfYD0F9TFG4dhYqqJHoXwRTDuMIc+MtRETQ2lY4hK0xAHumpBoYUK
neQIkInRReamBV7fOJKZWENH97NQZKWvpuX4K1V9C327p0pI5r7oE4oMhjopoIla
2dMdMBCFuFdf6qLnIEEjyOpVqKQRcTLJFDfrRW/fiGZ0ixv+3jhdqgcTOjMBy4yJ
Y+tv93qU3GRyh00JJiRk2TUR8+ewONeadxrhV8fUYo7TGNvRxR0La+K8Ugt/KsA6
vLpPSobY+vNmCYBGE6I3PwrmBqIr0ItstLdEeISU8erGW0uN7HpCA5y6GmIBF4AM
eNwfGuewl9LDQZCfNpvB
=Brbq
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_17_04_07_+1100_Q2I_b/vp6kxLgHWn--

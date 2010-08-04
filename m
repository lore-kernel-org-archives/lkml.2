Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0HDCwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:52:54 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28858 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932499Ab0HDCwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fHaylyQVM1kXxP91KwD4whsmuchw.ehmdfhl5qtd1rrpnPS
 1E13e_pJPPHmHQz0aKxVNmsQkKu6ZUhMMnXNvOY.tRSu7CEQfkTj6UtwYonZ
 wCsv62WVB20cHWwjdIKN48niiZ7FMAC5OoQXbAozGRHg9VpbCBagV7NJgQ0Z
 bPUZBJhKScaeLw55oMOm5Gyylnn_FVlyjFJPnf6Vajxn32WYnl4Shq3WtpDu
 eaVW_AIX7ReMGZjJ22MynQW69wEbaF6fxHA--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024537.051343033@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:37 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 23/23] vmscan: Tie slub object expiration into page reclaim
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=unified_vmscan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already do slab reclaim during page reclaim. Add a call to
object expiration in slub whenever shrink_slab() is called.
If the reclaim is zone specific then use the node of the zone
to restrict reclaim in slub.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/vmscan.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2010-07-30 18:37:47.638837043 -0500
+++ linux-2.6/mm/vmscan.c	2010-07-30 18:57:44.867515416 -0500
@@ -1826,6 +1826,7 @@
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
 			}
+			kmem_cache_expire_all(NUMA_NO_NODE);
 		}
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2133,6 +2134,7 @@
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);
+			kmem_cache_expire_all(nid);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone->all_unreclaimable)
@@ -2640,6 +2642,8 @@
 		 */
 		sc.nr_reclaimed += slab_reclaimable -
 			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+
+		kmem_cache_expire_all(zone_to_nid(zone));
 	}
 
 	p->reclaim_state = NULL;


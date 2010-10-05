Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0JES70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:59:26 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:24370 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754788Ab0JES6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:58:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1B3Ts24VM1kjK9kKXJ6qIu2iZt1HntzDn.A0JqdWQLF_mwj
 oaOad94CTovvamuHkJv_4FFyrQiDsLJ29cdrlXy6JHaYM_YmNdf9n3yvP6IH
 ND8.Vaxo8GN2gJrZtMdjXQpAhuDA0REhChqfjCg5uNYyURy2xQFaa5JOYvpE
 SW5U37re06Xj61DD8Dikvatf1x37CcGvIg4ljvxsuLDSZEI.vHSYnm.EKy6r
 ye4W4NcmyHsT9iNodY7OznmEPkCOcml0ypg--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101005185819.367221853@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 13:57:38 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: [UnifiedV4 13/16] vmscan: Tie slub object expiration into page reclaim
References: <20101005185725.088808842@linux.com>
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
--- linux-2.6.orig/mm/vmscan.c	2010-10-04 08:14:25.000000000 -0500
+++ linux-2.6/mm/vmscan.c	2010-10-04 08:26:47.000000000 -0500
@@ -1917,6 +1917,7 @@ static unsigned long do_try_to_free_page
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
 			}
+			kmem_cache_expire_all(NUMA_NO_NODE);
 		}
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2221,6 +2222,7 @@ loop_again:
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);
+			kmem_cache_expire_all(zone_to_nid(zone));
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone->all_unreclaimable)
@@ -2722,6 +2724,8 @@ static int __zone_reclaim(struct zone *z
 				break;
 		}
 
+		kmem_cache_expire_all(zone_to_nid(zone));
+
 		/*
 		 * Update nr_reclaimed by the number of slab pages we
 		 * reclaimed from this zone.


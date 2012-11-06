Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2KFTmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:42:14 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42781 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2KFTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:42:11 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 05/10] mm: Create zonelists
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:10:56 +0530
Message-ID: <20121106194052.6560.36457.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
References: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-9574-0000-0000-00000533E262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ankita Garg <gargankita@gmail.com>

The default zonelist that is node ordered contains all zones from within a
node and then all zones from the next node and so on. By introducing memory
regions, the primary aim is to group memory allocations to a given area of
memory together. The modified zonelists thus contain all zones from one
region, followed by all zones from the next region and so on. This ensures
that all the memory in one region is allocated before going over to the next
region, unless targetted memory allocations are performed.

Signed-off-by: Ankita Garg <gargankita@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   69 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8e86b5..9c1d680 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3040,21 +3040,25 @@ static void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
 static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
 				int nr_zones, enum zone_type zone_type)
 {
+	enum zone_type z_type = zone_type;
+	struct mem_region *region;
 	struct zone *zone;
 
 	BUG_ON(zone_type >= MAX_NR_ZONES);
 	zone_type++;
 
-	do {
-		zone_type--;
-		zone = pgdat->node_zones + zone_type;
-		if (populated_zone(zone)) {
-			zoneref_set_zone(zone,
-				&zonelist->_zonerefs[nr_zones++]);
-			check_highest_zone(zone_type);
-		}
-
-	} while (zone_type);
+	for_each_mem_region_in_node(region, pgdat->node_id) {
+		do {
+			zone_type--;
+			zone = region->region_zones + zone_type;
+			if (populated_zone(zone)) {
+				zoneref_set_zone(zone,
+					&zonelist->_zonerefs[nr_zones++]);
+				check_highest_zone(zone_type);
+			}
+		} while (zone_type);
+		zone_type = z_type + 1;
+	}
 	return nr_zones;
 }
 
@@ -3275,17 +3279,20 @@ static void build_zonelists_in_zone_order(pg_data_t *pgdat, int nr_nodes)
 	int zone_type;		/* needs to be signed */
 	struct zone *z;
 	struct zonelist *zonelist;
+	struct mem_region *region;
 
 	zonelist = &pgdat->node_zonelists[0];
 	pos = 0;
 	for (zone_type = MAX_NR_ZONES - 1; zone_type >= 0; zone_type--) {
 		for (j = 0; j < nr_nodes; j++) {
 			node = node_order[j];
-			z = &NODE_DATA(node)->node_zones[zone_type];
-			if (populated_zone(z)) {
-				zoneref_set_zone(z,
-					&zonelist->_zonerefs[pos++]);
-				check_highest_zone(zone_type);
+			for_each_mem_region_in_node(region, node) {
+				z = &region->region_zones[zone_type];
+				if (populated_zone(z)) {
+					zoneref_set_zone(z,
+						&zonelist->_zonerefs[pos++]);
+					check_highest_zone(zone_type);
+				}
 			}
 		}
 	}
@@ -3299,6 +3306,8 @@ static int default_zonelist_order(void)
 	unsigned long low_kmem_size,total_size;
 	struct zone *z;
 	int average_size;
+	struct mem_region *region;
+
 	/*
          * ZONE_DMA and ZONE_DMA32 can be very small area in the system.
 	 * If they are really small and used heavily, the system can fall
@@ -3310,12 +3319,15 @@ static int default_zonelist_order(void)
 	total_size = 0;
 	for_each_online_node(nid) {
 		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-			z = &NODE_DATA(nid)->node_zones[zone_type];
-			if (populated_zone(z)) {
-				if (zone_type < ZONE_NORMAL)
-					low_kmem_size += z->present_pages;
-				total_size += z->present_pages;
-			} else if (zone_type == ZONE_NORMAL) {
+			for_each_mem_region_in_node(region, nid) {
+				z = &region->region_zones[zone_type];
+				if (populated_zone(z)) {
+					if (zone_type < ZONE_NORMAL)
+						low_kmem_size +=
+							z->present_pages;
+
+					total_size += z->present_pages;
+				} else if (zone_type == ZONE_NORMAL) {
 				/*
 				 * If any node has only lowmem, then node order
 				 * is preferred to allow kernel allocations
@@ -3323,7 +3335,8 @@ static int default_zonelist_order(void)
 				 * on other nodes when there is an abundance of
 				 * lowmem available to allocate from.
 				 */
-				return ZONELIST_ORDER_NODE;
+					return ZONELIST_ORDER_NODE;
+				}
 			}
 		}
 	}
@@ -3341,11 +3354,13 @@ static int default_zonelist_order(void)
 		low_kmem_size = 0;
 		total_size = 0;
 		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-			z = &NODE_DATA(nid)->node_zones[zone_type];
-			if (populated_zone(z)) {
-				if (zone_type < ZONE_NORMAL)
-					low_kmem_size += z->present_pages;
-				total_size += z->present_pages;
+			for_each_mem_region_in_node(region, nid) {
+				z = &region->region_zones[zone_type];
+				if (populated_zone(z)) {
+					if (zone_type < ZONE_NORMAL)
+						low_kmem_size += z->present_pages;
+					total_size += z->present_pages;
+				}
 			}
 		}
 		if (low_kmem_size &&


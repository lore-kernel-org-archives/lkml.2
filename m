Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2KFTmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:42:24 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54127 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2KFTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:42:21 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 06/10] mm: Verify zonelists
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:11:08 +0530
Message-ID: <20121106194104.6560.48366.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
References: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-9264-0000-0000-000002A20456
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ankita Garg <gargankita@gmail.com>

Verify that the zonelists were created appropriately.

Signed-off-by: Ankita Garg <gargankita@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/mm_init.c |   57 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1ffd97a..5c19842 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -21,6 +21,7 @@ int mminit_loglevel;
 /* The zonelists are simply reported, validation is manual. */
 void mminit_verify_zonelist(void)
 {
+	struct mem_region *region;
 	int nid;
 
 	if (mminit_loglevel < MMINIT_VERIFY)
@@ -28,37 +29,39 @@ void mminit_verify_zonelist(void)
 
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		struct zone *zone;
-		struct zoneref *z;
-		struct zonelist *zonelist;
-		int i, listid, zoneid;
-
-		BUG_ON(MAX_ZONELISTS > 2);
-		for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
-
-			/* Identify the zone and nodelist */
-			zoneid = i % MAX_NR_ZONES;
-			listid = i / MAX_NR_ZONES;
-			zonelist = &pgdat->node_zonelists[listid];
-			zone = &pgdat->node_zones[zoneid];
-			if (!populated_zone(zone))
-				continue;
-
-			/* Print information about the zonelist */
-			printk(KERN_DEBUG "mminit::zonelist %s %d:%s = ",
-				listid > 0 ? "thisnode" : "general", nid,
-				zone->name);
-
-			/* Iterate the zonelist */
-			for_each_zone_zonelist(zone, z, zonelist, zoneid) {
+		for_each_mem_region_in_node(region, nid) {
+			struct zone *zone;
+			struct zoneref *z;
+			struct zonelist *zonelist;
+			int i, listid, zoneid;
+
+			BUG_ON(MAX_ZONELISTS > 2);
+			for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
+
+				/* Identify the zone and nodelist */
+				zoneid = i % MAX_NR_ZONES;
+				listid = i / MAX_NR_ZONES;
+				zonelist = &pgdat->node_zonelists[listid];
+				zone = &region->region_zones[zoneid];
+				if (!populated_zone(zone))
+					continue;
+
+				/* Print information about the zonelist */
+				printk(KERN_DEBUG "mminit::zonelist %s %d:%s = ",
+					listid > 0 ? "thisnode" : "general", nid,
+					zone->name);
+
+				/* Iterate the zonelist */
+				for_each_zone_zonelist(zone, z, zonelist, zoneid) {
 #ifdef CONFIG_NUMA
-				printk(KERN_CONT "%d:%s ",
-					zone->node, zone->name);
+					printk(KERN_CONT "%d:%s ",
+						zone->node, zone->name);
 #else
-				printk(KERN_CONT "0:%s ", zone->name);
+					printk(KERN_CONT "0:%s ", zone->name);
 #endif /* CONFIG_NUMA */
+				}
+				printk(KERN_CONT "\n");
 			}
-			printk(KERN_CONT "\n");
 		}
 	}
 }


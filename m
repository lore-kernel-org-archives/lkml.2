Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2KFTlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:41:01 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56741 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2KFTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:40:59 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 01/10] mm: Introduce the memory regions data structure
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:09:48 +0530
Message-ID: <20121106193937.6560.81136.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
References: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-2000-0000-0000-000009C5B896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ankita Garg <gargankita@gmail.com>

Memory region data structure is created under a NUMA node. Each NUMA node can
have multiple memory regions, depending upon the platform configuration for
power management. Each memory region contains zones, which is the entity from
which memory is allocated by the buddy allocator.

                 -------------
		 | pg_data_t |
                 -------------
                     |  |
		------  -------
		v             v
        ----------------    ----------------
        | mem_region_t |    | mem_region_t |
        ----------------    ----------------    -------------
               |                    |...........| zone0 | ....
	       v                                -------------
           -----------------------------
           | zone0 | zone1 | zone3 | ..|
           -----------------------------

Each memory region contains a zone array for the zones belonging to that region,
in addition to other fields like node id, index of the region in the node, start
pfn of the pages in that region and the number of pages spanned in the region.
The zone array inside the regions is statically allocated at this point.

ToDo:
However, since the number of regions actually present on the system might be much
smaller than the maximum allowed, dynamic bootmem allocation could be used to save
memory.

Signed-off-by: Ankita Garg <gargankita@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 50aaca8..3f9b106 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -86,6 +86,7 @@ struct free_area {
 };
 
 struct pglist_data;
+struct mem_region;
 
 /*
  * zone->lock and zone->lru_lock are two of the hottest locks in the kernel.
@@ -465,6 +466,8 @@ struct zone {
 	 * Discontig memory support fields.
 	 */
 	struct pglist_data	*zone_pgdat;
+	struct mem_region	*zone_mem_region;
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
@@ -533,6 +536,8 @@ static inline int zone_is_oom_locked(const struct zone *zone)
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
+#define MAX_NR_REGIONS    256
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
@@ -541,7 +546,7 @@ static inline int zone_is_oom_locked(const struct zone *zone)
 #define DEF_PRIORITY 12
 
 /* Maximum number of zones on a zonelist */
-#define MAX_ZONES_PER_ZONELIST (MAX_NUMNODES * MAX_NR_ZONES)
+#define MAX_ZONES_PER_ZONELIST (MAX_NUMNODES * MAX_NR_REGIONS * MAX_NR_ZONES)
 
 #ifdef CONFIG_NUMA
 
@@ -671,6 +676,18 @@ struct node_active_region {
 extern struct page *mem_map;
 #endif
 
+struct mem_region {
+	struct zone region_zones[MAX_NR_ZONES];
+	int nr_region_zones;
+
+	int node;
+	int region;
+
+	unsigned long start_pfn;
+	unsigned long spanned_pages;
+};
+
+
 /*
  * The pg_data_t structure is used in machines with CONFIG_DISCONTIGMEM
  * (mostly NUMA machines?) to denote a higher-level memory zone than the
@@ -684,9 +701,10 @@ extern struct page *mem_map;
  */
 struct bootmem_data;
 typedef struct pglist_data {
-	struct zone node_zones[MAX_NR_ZONES];
+	struct mem_region node_regions[MAX_NR_REGIONS];
+	int nr_node_regions;
 	struct zonelist node_zonelists[MAX_ZONELISTS];
-	int nr_zones;
+	int nr_node_zone_types;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
 #ifdef CONFIG_MEMCG


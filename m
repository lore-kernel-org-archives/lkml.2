Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2KFTyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:54:17 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40836 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2KFTyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:54:14 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/8] mm: Introduce and initialize zone memory regions
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:23:02 +0530
Message-ID: <20121106195256.6941.69079.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com>
References: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-5564-0000-0000-000005365317
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory region boundaries don't necessarily fit on zone boundaries. So we need
to maintain a zone-level mapping of the absolute memory region boundaries.

"Node Memory Regions" will be used to capture the absolute region boundaries.
Add "Zone Memory Regions" to track the subsets of the absolute memory regions
that fall within the zone boundaries.

Eg:

	|<---------------------Node---------------------->|
	 _________________________________________________
	|      Node mem reg 0 	|      Node mem reg 1     |
	|_______________________|_________________________|

	 _________________________________________________
	|   ZONE_DMA    |	ZONE_NORMAL		  |
	|_______________|_________________________________|


In the above figure,

ZONE_DMA has only 1 zone memory region (say, Zone mem reg 0) which is a subset
of Node mem reg 0.

ZONE_NORMAL has 2 zone memory regions (say, Zone mem reg 0 and Zone mem reg 1)
which are subsets of Node mem reg 0 and Node mem reg 1 respectively.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |    9 +++++++++
 mm/page_alloc.c        |   42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bb7c3ef..9f923aa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -339,6 +339,12 @@ struct node_mem_region {
 	struct pglist_data *pgdat;
 };
 
+struct zone_mem_region {
+	unsigned long start_pfn;
+	unsigned long spanned_pages;
+	unsigned long present_pages;
+};
+
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -403,6 +409,9 @@ struct zone {
 #endif
 	struct free_area	free_area[MAX_ORDER];
 
+	struct zone_mem_region	zone_mem_region[MAX_NR_REGIONS];
+	int 			nr_zone_regions;
+
 #ifndef CONFIG_SPARSEMEM
 	/*
 	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 709e3c1..c00f72d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4594,6 +4594,46 @@ void init_node_memory_regions(struct pglist_data *pgdat)
 	}
 }
 
+void init_zone_memory_regions(struct pglist_data *pgdat)
+{
+	unsigned long start_pfn, end_pfn, absent;
+	int i, j, idx, nid = pgdat->node_id;
+	struct node_mem_region *region;
+	struct zone *z;
+
+	for (i = 0; i < pgdat->nr_zones; i++) {
+		z = &pgdat->node_zones[i];
+		idx = 0;
+
+		for (j = 0; j < pgdat->nr_node_regions; j++) {
+			region = &pgdat->node_regions[j];
+			start_pfn = max(z->zone_start_pfn, region->start_pfn);
+			end_pfn = min(z->zone_start_pfn + z->spanned_pages,
+				      region->start_pfn + region->spanned_pages);
+
+			if (start_pfn >= end_pfn)
+				continue;
+
+			z->zone_mem_region[idx].start_pfn = start_pfn;
+			z->zone_mem_region[idx].spanned_pages = end_pfn - start_pfn;
+
+			absent = __absent_pages_in_range(nid, start_pfn,
+						         end_pfn);
+			z->zone_mem_region[idx].present_pages =
+						end_pfn - start_pfn - absent;
+			idx++;
+		}
+
+		z->nr_zone_regions = idx;
+	}
+}
+
+void init_memory_regions(struct pglist_data *pgdat)
+{
+	init_node_memory_regions(pgdat);
+	init_zone_memory_regions(pgdat);
+}
+
 void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
@@ -4615,7 +4655,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 #endif
 
 	free_area_init_core(pgdat, zones_size, zholes_size);
-	init_node_memory_regions(pgdat);
+	init_memory_regions(pgdat);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP


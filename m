Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2KFTyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:54:04 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60023 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2KFTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:54:00 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/8] mm: Initialize node memory regions during boot
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:22:48 +0530
Message-ID: <20121106195241.6941.43309.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com>
References: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-8256-0000-0000-000004E79304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the node's memory regions structures with the information about
the region-boundaries, at boot time.

Based-on-patch-by: Ankita Garg <gargankita@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mm.h |    4 ++++
 mm/page_alloc.c    |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa06804..19c4fb0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -657,6 +657,10 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
+/* Hard-code memory regions size to be 512 MB for now. */
+#define MEM_REGION_SHIFT	(29 - PAGE_SHIFT)
+#define MEM_REGION_SIZE		(1UL << MEM_REGION_SHIFT)
+
 static inline enum zone_type page_zonenum(const struct page *page)
 {
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb90971..709e3c1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4560,6 +4560,40 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
+void init_node_memory_regions(struct pglist_data *pgdat)
+{
+	int nid = pgdat->node_id;
+	unsigned long start_pfn = pgdat->node_start_pfn;
+	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
+	unsigned long i, absent;
+	int idx;
+	struct node_mem_region *region;
+
+	for (i = start_pfn, idx = 0; i < end_pfn;
+				i += region->spanned_pages, idx++) {
+
+		region = &pgdat->node_regions[idx];
+
+		if (i + MEM_REGION_SIZE <= end_pfn) {
+			region->start_pfn = i;
+			region->spanned_pages = MEM_REGION_SIZE;
+		} else {
+			region->start_pfn = i;
+			region->spanned_pages = end_pfn - i;
+		}
+
+		absent = __absent_pages_in_range(nid, region->start_pfn,
+						 region->start_pfn +
+						 region->spanned_pages);
+
+		region->present_pages = region->spanned_pages - absent;
+		region->idx = idx;
+		region->node = nid;
+		region->pgdat = pgdat;
+		pgdat->nr_node_regions++;
+	}
+}
+
 void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
@@ -4581,6 +4615,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 #endif
 
 	free_area_init_core(pgdat, zones_size, zholes_size);
+	init_node_memory_regions(pgdat);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2KFTn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:43:28 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45905 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2KFTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:43:24 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 10/10] mm: Create memory regions at boot-up
To: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        arjan@linux.intel.com, kmpark@infradead.org,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 01:12:07 +0530
Message-ID: <20121106194202.6560.9541.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
References: <20121106193650.6560.71366.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12110619-2674-0000-0000-000006A396A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ankita Garg <gargankita@gmail.com>

Memory regions are created at boot up time, from the information obtained
from the firmware. But since the firmware doesn't yet export information
about memory units that can be independently power managed, for the purpose
of demonstration, we hard code memory region size to be 512MB.

In future, we expect ACPI 5.0 compliant firmware to expose the required
info in the form of MPST (Memory Power State Table) tables.

Signed-off-by: Ankita Garg <gargankita@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page_alloc.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c1d680..13d1b2f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4491,6 +4491,33 @@ void __init set_pageblock_order(void)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
+#define REGIONS_SIZE	(512 << 20) >> PAGE_SHIFT
+
+static void init_node_memory_regions(struct pglist_data *pgdat)
+{
+	int cnt = 0;
+	unsigned long i;
+	unsigned long start_pfn = pgdat->node_start_pfn;
+	unsigned long spanned_pages = pgdat->node_spanned_pages;
+	unsigned long total = 0;
+
+	for (i = start_pfn; i < start_pfn + spanned_pages; i += REGIONS_SIZE) {
+		struct mem_region *region = &pgdat->node_regions[cnt];
+
+		region->start_pfn = i;
+		if ((spanned_pages - total) < REGIONS_SIZE)
+			region->spanned_pages = spanned_pages - total;
+		else
+			region->spanned_pages = REGIONS_SIZE;
+
+		region->node = pgdat->node_id;
+		region->region = cnt;
+		pgdat->nr_node_regions++;
+		total += region->spanned_pages;
+		cnt++;
+	}
+}
+
 /*
  * Set up the zone data structures:
  *   - mark all pages reserved
@@ -4653,6 +4680,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
+	init_node_memory_regions(pgdat);
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1JJHL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:11:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1JJHLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:11:25 -0400
Date: Mon, 10 Oct 2011 08:11:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        nfont@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] mm: memory hotplug: Check if pages are correctly reserved on
 a per-section basis
Message-ID: <20111010071119.GE6418@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is expected that memory being brought online is PageReserved
similar to what happens when the page allocator is being brought up.
Memory is onlined in "memory blocks" which consist of one or more
sections. Unfortunately, the code that verifies PageReserved is
currently assuming that the memmap backing all these pages is virtually
contiguous which is only the case when CONFIG_SPARSEMEM_VMEMMAP is set.
As a result, memory hot-add is failing on !VMEMMAP configurations
with the message;

kernel: section number XXX page number 256 not reserved, was it already online?

This patch updates the PageReserved check to lookup struct page once
per section to guarantee the correct struct page is being checked.

[original patch by: nfont@linux.vnet.ibm.com]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 drivers/base/memory.c |   58 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2840ed4..ffb69cd 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -224,13 +224,48 @@ int memory_isolate_notify(unsigned long val, void *v)
 }
 
 /*
+ * The probe routines leave the pages reserved, just as the bootmem code does.
+ * Make sure they're still that way.
+ */
+static bool pages_correctly_reserved(unsigned long start_pfn,
+					unsigned long nr_pages)
+{
+	int i, j;
+	struct page *page;
+	unsigned long pfn = start_pfn;
+
+	/*
+	 * memmap between sections is not contiguous except with
+	 * SPARSEMEM_VMEMMAP. We lookup the page once per section
+	 * and assume memmap is contiguous within each section
+	 */
+	for (i = 0; i < sections_per_block; i++, pfn += PAGES_PER_SECTION) {
+		if (WARN_ON_ONCE(!pfn_valid(pfn)))
+			return false;
+		page = pfn_to_page(pfn);
+
+		for (j = 0; j < PAGES_PER_SECTION; j++) {
+			if (PageReserved(page + i))
+				continue;
+
+			printk(KERN_WARNING "section number %ld page number %d "
+				"not reserved, was it already online?\n",
+				pfn_to_section_nr(pfn), j);
+
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/*
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
  */
 static int
 memory_block_action(unsigned long phys_index, unsigned long action)
 {
-	int i;
 	unsigned long start_pfn, start_paddr;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	struct page *first_page;
@@ -238,26 +273,13 @@ memory_block_action(unsigned long phys_index, unsigned long action)
 
 	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
 
-	/*
-	 * The probe routines leave the pages reserved, just
-	 * as the bootmem code does.  Make sure they're still
-	 * that way.
-	 */
-	if (action == MEM_ONLINE) {
-		for (i = 0; i < nr_pages; i++) {
-			if (PageReserved(first_page+i))
-				continue;
-
-			printk(KERN_WARNING "section number %ld page number %d "
-				"not reserved, was it already online?\n",
-				phys_index, i);
-			return -EBUSY;
-		}
-	}
-
 	switch (action) {
 		case MEM_ONLINE:
 			start_pfn = page_to_pfn(first_page);
+
+			if (!pages_correctly_reserved(start_pfn, nr_pages))
+				return -EBUSY;
+
 			ret = online_pages(start_pfn, nr_pages);
 			break;
 		case MEM_OFFLINE:

-- 
Mel Gorman
SUSE Labs

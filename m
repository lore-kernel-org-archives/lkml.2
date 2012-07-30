Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2G3Roa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:44:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2G3Rcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:32:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [ 08/41] mm: memory hotplug: Check if pages are correctly reserved on a per-section basis
Date: Mon, 30 Jul 2012 10:31:07 -0700
Message-Id: <20120730172901.966790694@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 2bbcb8788311a40714b585fc11b51da6ffa2ab92 upstream.

Stable note: Fixes https://bugzilla.novell.com/show_bug.cgi?id=721039 .
        Without the patch, memory hot-add can fail for kernel configurations
        that do not set CONFIG_SPARSEMEM_VMEMMAP.

(Resending as I am not seeing it in -next so maybe it got lost)

mm: memory hotplug: Check if pages are correctly reserved on a per-section basis

It is expected that memory being brought online is PageReserved
similar to what happens when the page allocator is being brought up.
Memory is onlined in "memory blocks" which consist of one or more
sections. Unfortunately, the code that verifies PageReserved is
currently assuming that the memmap backing all these pages is virtually
contiguous which is only the case when CONFIG_SPARSEMEM_VMEMMAP is set.
As a result, memory hot-add is failing on those configurations with
the message;

kernel: section number XXX page number 256 not reserved, was it already online?

This patch updates the PageReserved check to lookup struct page once
per section to guarantee the correct struct page is being checked.

[Check pages within sections properly: rientjes@google.com]
[original patch by: nfont@linux.vnet.ibm.com]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/memory.c |   58 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 18 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -224,13 +224,48 @@ int memory_isolate_notify(unsigned long
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
+			if (PageReserved(page + j))
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
@@ -238,26 +273,13 @@ memory_block_action(unsigned long phys_i
 
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



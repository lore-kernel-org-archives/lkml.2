Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1IZPYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:24:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40263 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1IZPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:24:05 -0400
Message-ID: <4E8098B9.1080702@austin.ibm.com>
Date: Mon, 26 Sep 2011 10:22:33 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: [PATCH] memory hotplug: Correct page reservation checking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11092615-2398-0000-0000-0000007F28AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check to ensure that pages of recently added memory sections are correctly
marked as reserved before trying to online the memory is broken.  The request
to online the memory fails with the following:

kernel: section number XXX page number 256 not reserved, was it already online?

This updates the page reservation checking to check the pages of each memory
section of the memory block being onlined individually.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 drivers/base/memory.c |   60 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

Index: linux/drivers/base/memory.c
===================================================================
--- linux.orig/drivers/base/memory.c	2011-09-26 08:33:14.000000000 -0500
+++ linux/drivers/base/memory.c	2011-09-26 08:42:14.000000000 -0500
@@ -227,41 +227,42 @@
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
  */
+static int check_page_reservations(unsigned long phys_index)
+{
+	int i;
+	struct page *page;
+
+	page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
+
+	for (i = 0; i < PAGES_PER_SECTION; i++) {
+		if (PageReserved(page + i))
+			continue;
+
+		printk(KERN_WARNING "section number %ld page number %d "
+			"not reserved, was it already online?\n", phys_index, i);
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 static int
 memory_block_action(unsigned long phys_index, unsigned long action)
 {
-	int i;
 	unsigned long start_pfn, start_paddr;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	struct page *first_page;
+	struct page *page;
 	int ret;
 
-	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
-
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
+	page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
 
 	switch (action) {
 		case MEM_ONLINE:
-			start_pfn = page_to_pfn(first_page);
+			start_pfn = page_to_pfn(page);
 			ret = online_pages(start_pfn, nr_pages);
 			break;
 		case MEM_OFFLINE:
-			start_paddr = page_to_pfn(first_page) << PAGE_SHIFT;
+			start_paddr = page_to_pfn(page) << PAGE_SHIFT;
 			ret = remove_memory(start_paddr,
 					    nr_pages << PAGE_SHIFT);
 			break;
@@ -277,7 +278,7 @@
 static int memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
-	int ret = 0;
+	int i, ret = 0;
 
 	mutex_lock(&mem->state_mutex);
 
@@ -289,6 +290,19 @@
 	if (to_state == MEM_OFFLINE)
 		mem->state = MEM_GOING_OFFLINE;
 
+	if (to_state == MEM_ONLINE) {
+		/*
+		 * The probe routines leave the pages reserved, just
+		 * as the bootmem code does.  Make sure they're still
+		 * that way.
+		 */
+		for (i = 0; i < sections_per_block; i++) {
+			ret = check_page_reservations(mem->start_section_nr + i);
+			if (ret)
+				return ret;
+		}
+	}
+
 	ret = memory_block_action(mem->start_section_nr, to_state);
 
 	if (ret)


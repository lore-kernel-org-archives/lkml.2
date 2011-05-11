Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab1EKRC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:02:59 -0400
Received: from ozlabs.org ([203.10.76.45]:38724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab1EKRC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:02:58 -0400
Date: Wed, 11 May 2011 17:25:14 +1000
From: Anton Blanchard <anton@samba.org>
To: gregkh@suse.de, nfont@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] memory hotplug: Speed up add/remove when blocks are larger
 than PAGES_PER_SECTION
Message-ID: <20110511172514.7e30970d@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On ppc64 the minimum memory section for hotplug is 16MB but most
recent machines have a memory block size of 256MB. This means
memory_block_change_state does 16 separate calls to
memory_section_action.

This also means we call the notifiers 16 times and the hook
in the ehea network driver is quite costly. To offline one 256MB
region takes:

# time echo offline > /sys/devices/system/memory/memory32/state
7.9s

This patch removes the loop and calls online_pages or
remove_memory once for the entire region and in doing so makes
the logic simpler since we don't have to back out if things fail
part way through.

The same test to offline one region now takes:

# time echo online > /sys/devices/system/memory/memory32/state
0.67s

Over 11 times faster.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-work/drivers/base/memory.c
===================================================================
--- linux-2.6-work.orig/drivers/base/memory.c	2011-05-11 14:04:46.878078801 +1000
+++ linux-2.6-work/drivers/base/memory.c	2011-05-11 14:10:52.134521072 +1000
@@ -228,10 +228,11 @@ int memory_isolate_notify(unsigned long
  * OK to have direct references to sparsemem variables in here.
  */
 static int
-memory_section_action(unsigned long phys_index, unsigned long action)
+memory_block_action(unsigned long phys_index, unsigned long action)
 {
 	int i;
 	unsigned long start_pfn, start_paddr;
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	struct page *first_page;
 	int ret;
 
@@ -243,7 +244,7 @@ memory_section_action(unsigned long phys
 	 * that way.
 	 */
 	if (action == MEM_ONLINE) {
-		for (i = 0; i < PAGES_PER_SECTION; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			if (PageReserved(first_page+i))
 				continue;
 
@@ -257,12 +258,12 @@ memory_section_action(unsigned long phys
 	switch (action) {
 		case MEM_ONLINE:
 			start_pfn = page_to_pfn(first_page);
-			ret = online_pages(start_pfn, PAGES_PER_SECTION);
+			ret = online_pages(start_pfn, nr_pages);
 			break;
 		case MEM_OFFLINE:
 			start_paddr = page_to_pfn(first_page) << PAGE_SHIFT;
 			ret = remove_memory(start_paddr,
-					    PAGES_PER_SECTION << PAGE_SHIFT);
+					    nr_pages << PAGE_SHIFT);
 			break;
 		default:
 			WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
@@ -288,20 +289,11 @@ static int memory_block_change_state(str
 	if (to_state == MEM_OFFLINE)
 		mem->state = MEM_GOING_OFFLINE;
 
-	for (i = 0; i < sections_per_block; i++) {
-		ret = memory_section_action(mem->start_section_nr + i,
-					    to_state);
-		if (ret)
-			break;
-	}
-
-	if (ret) {
-		for (i = 0; i < sections_per_block; i++)
-			memory_section_action(mem->start_section_nr + i,
-					      from_state_req);
+	ret = memory_block_action(mem->start_section_nr, to_state);
 
+	if (ret)
 		mem->state = from_state_req;
-	} else
+	else
 		mem->state = to_state;
 
 out:

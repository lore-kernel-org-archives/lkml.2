Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab1ETAN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:13:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43981 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933910Ab1ETAMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:21 -0400
X-Sasl-enc: uW9WuvFXnacSHwxAPGZ/LPbmtA/uoqBLs0vPpFSmTHYH 1305850340
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/44] memory hotplug: Speed up add/remove when blocks are larger than PAGES_PER_SECTION
Date: Thu, 19 May 2011 17:10:59 -0700
Message-Id: <1305850262-9575-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 3e9aa3d..c4c443d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -229,10 +229,11 @@ int memory_isolate_notify(unsigned long val, void *v)
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
 
@@ -244,7 +245,7 @@ memory_section_action(unsigned long phys_index, unsigned long action)
 	 * that way.
 	 */
 	if (action == MEM_ONLINE) {
-		for (i = 0; i < PAGES_PER_SECTION; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			if (PageReserved(first_page+i))
 				continue;
 
@@ -258,12 +259,12 @@ memory_section_action(unsigned long phys_index, unsigned long action)
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
@@ -289,20 +290,11 @@ static int memory_block_change_state(struct memory_block *mem,
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
-- 
1.7.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2JWBfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:35:12 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39928 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2JWBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:35:10 -0400
From: Michael Spang <spang@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Michael Spang <spang@chromium.org>
Subject: [PATCH] ARM: Fix page counting in mem_init and show_mem
Date: Mon, 22 Oct 2012 21:34:51 -0400
Message-Id: <1350956091-5276-1-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in mem_init & show_mem to count page usage has two issues:

1. It assumes the memory map for a bank is contiguous. The sparsemem
   memory model partitions the memory map into sections, which may not
   be contiguous. They are usually contiguous due only to allocation
   order. Avoid this by using pfn_to_page for each page.

   If the memory map is not contiguous the pointer math works out
   badly and crashes the system.

2. A memory bank may have holes. Some regions may be removed using
   memblock_remove, and will not have valid page stucts. The code
   should not access the page structs for such pages. Avoid this by
   skipping pages that fail pfn_valid().

   If the memory map has holes, the free & total page counts are
   wrong.

Signed-off-by: Michael Spang <spang@chromium.org>
---
 arch/arm/mm/init.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c21d06c..97d811a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -101,16 +101,19 @@ void show_mem(unsigned int filter)
 
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
-		unsigned int pfn1, pfn2;
-		struct page *page, *end;
+		unsigned int start, end, pfn;
 
-		pfn1 = bank_pfn_start(bank);
-		pfn2 = bank_pfn_end(bank);
+		start = bank_pfn_start(bank);
+		end = bank_pfn_end(bank);
 
-		page = pfn_to_page(pfn1);
-		end  = pfn_to_page(pfn2 - 1) + 1;
+		for (pfn = start; pfn < end; pfn++) {
+			struct page *page;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
 
-		do {
 			total++;
 			if (PageReserved(page))
 				reserved++;
@@ -122,8 +125,7 @@ void show_mem(unsigned int filter)
 				free++;
 			else
 				shared += page_count(page) - 1;
-			page++;
-		} while (page < end);
+		}
 	}
 
 	printk("%d pages of RAM\n", total);
@@ -619,22 +621,24 @@ void __init mem_init(void)
 
 	for_each_bank(i, &meminfo) {
 		struct membank *bank = &meminfo.bank[i];
-		unsigned int pfn1, pfn2;
-		struct page *page, *end;
+		unsigned int start, end, pfn;
 
-		pfn1 = bank_pfn_start(bank);
-		pfn2 = bank_pfn_end(bank);
+		start = bank_pfn_start(bank);
+		end = bank_pfn_end(bank);
 
-		page = pfn_to_page(pfn1);
-		end  = pfn_to_page(pfn2 - 1) + 1;
+		for (pfn = start; pfn < end; pfn++) {
+			struct page *page;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
 
-		do {
 			if (PageReserved(page))
 				reserved_pages++;
 			else if (!page_count(page))
 				free_pages++;
-			page++;
-		} while (page < end);
+		}
 	}
 
 	/*
-- 
1.7.7.3


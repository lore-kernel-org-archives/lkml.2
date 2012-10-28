Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2J1TPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:15:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2J1TPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:15:16 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 4/5] mm, highmem: makes flush_all_zero_pkmaps() return index of last flushed entry
Date: Mon, 29 Oct 2012 04:12:55 +0900
Message-Id: <1351451576-2611-5-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351451576-2611-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, after flush_all_zero_pkmaps() is invoked,
then re-iterate all pkmaps. It can be optimized if flush_all_zero_pkmaps()
return index of flushed entry. With this index,
we can immediately map highmem page to virtual address represented by index.
So change return type of flush_all_zero_pkmaps()
and return index of last flushed entry.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index ef788b5..0683869 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -32,6 +32,7 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
+#define PKMAP_INDEX_INVAL (-1)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
diff --git a/mm/highmem.c b/mm/highmem.c
index 731cf9a..65beb9a 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -106,10 +106,10 @@ struct page *kmap_to_page(void *vaddr)
 	return virt_to_page(addr);
 }
 
-static void flush_all_zero_pkmaps(void)
+static int flush_all_zero_pkmaps(void)
 {
 	int i;
-	int need_flush = 0;
+	int index = PKMAP_INDEX_INVAL;
 
 	flush_cache_kmaps();
 
@@ -141,10 +141,12 @@ static void flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
-		need_flush = 1;
+		index = i;
 	}
-	if (need_flush)
+	if (index != PKMAP_INDEX_INVAL)
 		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+
+	return index;
 }
 
 /**
@@ -160,6 +162,7 @@ void kmap_flush_unused(void)
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
+	int index = PKMAP_INDEX_INVAL;
 	int count;
 
 start:
@@ -168,40 +171,45 @@ start:
 	for (;;) {
 		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
 		if (!last_pkmap_nr) {
-			flush_all_zero_pkmaps();
-			count = LAST_PKMAP;
+			index = flush_all_zero_pkmaps();
+			if (index != PKMAP_INDEX_INVAL)
+				break; /* Found a usable entry */
 		}
-		if (!pkmap_count[last_pkmap_nr])
+		if (!pkmap_count[last_pkmap_nr]) {
+			index = last_pkmap_nr;
 			break;	/* Found a usable entry */
-		if (--count)
-			continue;
-
-		/*
-		 * Sleep for somebody else to unmap their entries
-		 */
-		{
-			DECLARE_WAITQUEUE(wait, current);
-
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			add_wait_queue(&pkmap_map_wait, &wait);
-			unlock_kmap();
-			schedule();
-			remove_wait_queue(&pkmap_map_wait, &wait);
-			lock_kmap();
-
-			/* Somebody else might have mapped it while we slept */
-			if (page_address(page))
-				return (unsigned long)page_address(page);
-
-			/* Re-start */
-			goto start;
 		}
+		if (--count == 0)
+			break;
 	}
-	vaddr = PKMAP_ADDR(last_pkmap_nr);
+
+	/*
+	 * Sleep for somebody else to unmap their entries
+	 */
+	if (index == PKMAP_INDEX_INVAL) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		add_wait_queue(&pkmap_map_wait, &wait);
+		unlock_kmap();
+		schedule();
+		remove_wait_queue(&pkmap_map_wait, &wait);
+		lock_kmap();
+
+		/* Somebody else might have mapped it while we slept */
+		vaddr = (unsigned long)page_address(page);
+		if (vaddr)
+			return vaddr;
+
+		/* Re-start */
+		goto start;
+	}
+
+	vaddr = PKMAP_ADDR(index);
 	set_pte_at(&init_mm, vaddr,
-		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
+		   &(pkmap_page_table[index]), mk_pte(page, kmap_prot));
 
-	pkmap_count[last_pkmap_nr] = 1;
+	pkmap_count[index] = 1;
 	set_page_address(page, (void *)vaddr);
 
 	return vaddr;
-- 
1.7.9.5


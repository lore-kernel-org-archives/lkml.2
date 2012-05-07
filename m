Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2EGXOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:14:05 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:37991 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab2EGXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:14:03 -0400
From: =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, torvalds@linux-foundation.org, seanpaul@chromium.org,
        olofj@chromium.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>
Subject: [PATCH] mm: Work around Intel SNB GTT bug with some physical pages.
Date: Mon,  7 May 2012 16:13:41 -0700
Message-Id: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
X-Mailer: git-send-email 1.7.5.3.367.ga9930
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While investing some Sandy Bridge rendering corruption, I found out
that all physical memory pages below 1MiB were returning garbage when
read through the GTT. This has been causing graphics corruption (when
it's used for textures, render targets and pixmaps) and GPU hangups
(when it's used for GPU batch buffers).

I talked with some people at Intel and they confirmed my findings,
and said that a couple of other random pages were also affected.

We could fix this problem by adding an e820 region preventing the
memory below 1 MiB to be used, but that prevents at least my machine
from booting. One could think that we should be able to fix it in
i915, but since the allocation is done by the backing shmem this is
not possible.

In the end, I came up with the ugly workaround of just leaking the
offending pages in shmem.c. I do realize it's truly ugly, but I'm
looking for a fix to the existing code, and am wondering if people on
this list have a better idea, short of rewriting i915_gem.c to
allocate its own pages directly.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>

Change-Id: I957e125fb280e0b0d6b05a83cc4068df2f05aa0a
---
 mm/shmem.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6c253f7..dcbb58b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -768,6 +768,31 @@ redirty:
 	return 0;
 }
 
+/*
+ * Some intel GPUs can't use those pages in the GTT, which results in
+ * graphics corruption. Sadly, it's impossible to prevent usage of those
+ * pages in the intel allocator.
+ *
+ * Instead, we test for those areas here and leak the corresponding pages.
+ *
+ * Some day, when the intel GPU memory is not backed by shmem any more,
+ * we'll be able to come up with a solution which is contained in i915.
+ */
+static bool i915_usable_page(struct page *page)
+{
+	dma_addr_t addr = page_to_phys(page);
+
+	if (unlikely((addr < 1 * 1024 * 1024) ||
+		(addr == 0x20050000) ||
+		(addr == 0x20110000) ||
+		(addr == 0x20130000) ||
+		(addr == 0x20138000) ||
+		(addr == 0x40004000)))
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
 static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
@@ -816,6 +841,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
+	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
@@ -826,7 +852,11 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
 	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	do {
+		page = alloc_page_vma(gfp, &pvma, 0);
+	} while (!i915_usable_page(page));
+
+	return page;
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
@@ -844,7 +874,12 @@ static inline struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
 static inline struct page *shmem_alloc_page(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
-	return alloc_page(gfp);
+	struct page *page;
+	do {
+		page = alloc_page(gfp);
+	} while (!i915_usable_page(page));
+
+	return page;
 }
 #endif /* CONFIG_NUMA */
 
-- 
1.7.5.3.367.ga9930


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0LLXsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36673 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab0LLXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:08 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: mika.westerberg@iki.fi, rmk+kernel@arm.linux.org.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [181/223] ARM: 6464/2: fix spinlock recursion in adjust_pte()
Message-Id: <20101212234806.70014B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mika Westerberg <mika.westerberg@iki.fi>

commit 4e54d93d3c9846ba1c2644ad06463dafa690d1b7 upstream.

When running following code in a machine which has VIVT caches and
USE_SPLIT_PTLOCKS is not defined:

  fd = open("/etc/passwd", O_RDONLY);
  addr = mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd, 0);
  addr2 = mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd, 0);

  v = *((int *)addr);

we will hang in spinlock recursion in the page fault handler:

  BUG: spinlock recursion on CPU#0, mmap_test/717
  lock: c5e295d8, .magic: dead4ead, .owner: mmap_test/717,
                  .owner_cpu: 0
  [<c0026604>] (unwind_backtrace+0x0/0xec)
  [<c014ee48>] (do_raw_spin_lock+0x40/0x140)
  [<c0027f68>] (update_mmu_cache+0x208/0x250)
  [<c0079db4>] (__do_fault+0x320/0x3ec)
  [<c007af7c>] (handle_mm_fault+0x2f0/0x6d8)
  [<c0027834>] (do_page_fault+0xdc/0x1cc)
  [<c00202d0>] (do_DataAbort+0x34/0x94)

This comes from the fact that when USE_SPLIT_PTLOCKS is not defined,
the only lock protecting the page tables is mm->page_table_lock
which is already locked before update_mmu_cache() is called.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/arm/mm/fault-armv.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

Index: linux/arch/arm/mm/fault-armv.c
===================================================================
--- linux.orig/arch/arm/mm/fault-armv.c
+++ linux/arch/arm/mm/fault-armv.c
@@ -65,6 +65,30 @@ static int do_adjust_pte(struct vm_area_
 	return ret;
 }
 
+#if USE_SPLIT_PTLOCKS
+/*
+ * If we are using split PTE locks, then we need to take the page
+ * lock here.  Otherwise we are using shared mm->page_table_lock
+ * which is already locked, thus cannot take it.
+ */
+static inline void do_pte_lock(spinlock_t *ptl)
+{
+	/*
+	 * Use nested version here to indicate that we are already
+	 * holding one similar spinlock.
+	 */
+	spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+}
+
+static inline void do_pte_unlock(spinlock_t *ptl)
+{
+	spin_unlock(ptl);
+}
+#else /* !USE_SPLIT_PTLOCKS */
+static inline void do_pte_lock(spinlock_t *ptl) {}
+static inline void do_pte_unlock(spinlock_t *ptl) {}
+#endif /* USE_SPLIT_PTLOCKS */
+
 static int adjust_pte(struct vm_area_struct *vma, unsigned long address,
 	unsigned long pfn)
 {
@@ -89,11 +113,11 @@ static int adjust_pte(struct vm_area_str
 	 */
 	ptl = pte_lockptr(vma->vm_mm, pmd);
 	pte = pte_offset_map_nested(pmd, address);
-	spin_lock(ptl);
+	do_pte_lock(ptl);
 
 	ret = do_adjust_pte(vma, address, pfn, pte);
 
-	spin_unlock(ptl);
+	do_pte_unlock(ptl);
 	pte_unmap_nested(pte);
 
 	return ret;

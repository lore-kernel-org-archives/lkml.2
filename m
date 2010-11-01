Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0KAT34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:29:56 -0400
Received: from king.tilera.com ([72.1.168.226]:3864 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0KAT3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:29:54 -0400
Message-Id: <201011011929.oA1JTlnK024940@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 1 Nov 2010 15:21:35 -0400
Subject: [PATCH] arch/tile: complete migration to new kmap_atomic scheme
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Nov 2010 19:29:48.0445 (UTC) FILETIME=[2594C4D0:01CB79FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes KM_TYPE_NR independent of the actual deprecated
list of km_type values, which are no longer used in tile code anywhere.
For now we leave it set to 8, allowing that many nested mappings,
and thus reserving 32MB of address space.

A few remaining places using KM_* values were cleaned up as well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/highmem.h    |    1 -
 arch/tile/include/asm/kmap_types.h |   34 ++++++++++++++++++++++++----------
 arch/tile/include/asm/pgtable.h    |    6 ++----
 arch/tile/kernel/machine_kexec.c   |    6 +++---
 arch/tile/lib/memcpy_tile64.c      |   11 ++++++++---
 arch/tile/mm/highmem.c             |    2 +-
 arch/tile/mm/pgtable.c             |    4 ++--
 7 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/arch/tile/include/asm/highmem.h b/arch/tile/include/asm/highmem.h
index e0f7ee1..b2a6c5d 100644
--- a/arch/tile/include/asm/highmem.h
+++ b/arch/tile/include/asm/highmem.h
@@ -23,7 +23,6 @@
 
 #include <linux/interrupt.h>
 #include <linux/threads.h>
-#include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
 #include <asm/homecache.h>
 
diff --git a/arch/tile/include/asm/kmap_types.h b/arch/tile/include/asm/kmap_types.h
index 1480106..3d0f202 100644
--- a/arch/tile/include/asm/kmap_types.h
+++ b/arch/tile/include/asm/kmap_types.h
@@ -16,28 +16,42 @@
 #define _ASM_TILE_KMAP_TYPES_H
 
 /*
- * In TILE Linux each set of four of these uses another 16MB chunk of
- * address space, given 64 tiles and 64KB pages, so we only enable
- * ones that are required by the kernel configuration.
+ * In 32-bit TILE Linux we have to balance the desire to have a lot of
+ * nested atomic mappings with the fact that large page sizes and many
+ * processors chew up address space quickly.  In a typical
+ * 64-processor, 64KB-page layout build, making KM_TYPE_NR one larger
+ * adds 4MB of required address-space.  For now we leave KM_TYPE_NR
+ * set to depth 8.
  */
 enum km_type {
+	KM_TYPE_NR = 8
+};
+
+/*
+ * We provide dummy definitions of all the stray values that used to be
+ * required for kmap_atomic() and no longer are.
+ */
+enum {
 	KM_BOUNCE_READ,
 	KM_SKB_SUNRPC_DATA,
 	KM_SKB_DATA_SOFTIRQ,
 	KM_USER0,
 	KM_USER1,
 	KM_BIO_SRC_IRQ,
+	KM_BIO_DST_IRQ,
+	KM_PTE0,
+	KM_PTE1,
 	KM_IRQ0,
 	KM_IRQ1,
 	KM_SOFTIRQ0,
 	KM_SOFTIRQ1,
-	KM_MEMCPY0,
-	KM_MEMCPY1,
-#if defined(CONFIG_HIGHPTE)
-	KM_PTE0,
-	KM_PTE1,
-#endif
-	KM_TYPE_NR
+	KM_SYNC_ICACHE,
+	KM_SYNC_DCACHE,
+	KM_UML_USERCOPY,
+	KM_IRQ_PTE,
+	KM_NMI,
+	KM_NMI_PTE,
+	KM_KDB
 };
 
 #endif /* _ASM_TILE_KMAP_TYPES_H */
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index dc4ccdd..a6604e9 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -344,10 +344,8 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
 #if defined(CONFIG_HIGHPTE)
-extern pte_t *_pte_offset_map(pmd_t *, unsigned long address, enum km_type);
-#define pte_offset_map(dir, address) \
-	_pte_offset_map(dir, address, KM_PTE0)
-#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
+extern pte_t *pte_offset_map(pmd_t *, unsigned long address);
+#define pte_unmap(pte) kunmap_atomic(pte)
 #else
 #define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
 #define pte_unmap(pte) do { } while (0)
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
index ba7a265..0d8b9e9 100644
--- a/arch/tile/kernel/machine_kexec.c
+++ b/arch/tile/kernel/machine_kexec.c
@@ -182,13 +182,13 @@ static void kexec_find_and_set_command_line(struct kimage *image)
 
 		if ((entry & IND_SOURCE)) {
 			void *va =
-				kmap_atomic_pfn(entry >> PAGE_SHIFT, KM_USER0);
+				kmap_atomic_pfn(entry >> PAGE_SHIFT);
 			r = kexec_bn2cl(va);
 			if (r) {
 				command_line = r;
 				break;
 			}
-			kunmap_atomic(va, KM_USER0);
+			kunmap_atomic(va);
 		}
 	}
 
@@ -198,7 +198,7 @@ static void kexec_find_and_set_command_line(struct kimage *image)
 
 		hverr = hv_set_command_line(
 			(HV_VirtAddr) command_line, strlen(command_line));
-		kunmap_atomic(command_line, KM_USER0);
+		kunmap_atomic(command_line);
 	} else {
 		pr_info("%s: no command line found; making empty\n",
 		       __func__);
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
index dfedea7..f7d4a6a 100644
--- a/arch/tile/lib/memcpy_tile64.c
+++ b/arch/tile/lib/memcpy_tile64.c
@@ -54,7 +54,7 @@ typedef unsigned long (*memcpy_t)(void *, const void *, unsigned long);
  * we must run with interrupts disabled to avoid the risk of some
  * other code seeing the incoherent data in our cache.  (Recall that
  * our cache is indexed by PA, so even if the other code doesn't use
- * our KM_MEMCPY virtual addresses, they'll still hit in cache using
+ * our kmap_atomic virtual addresses, they'll still hit in cache using
  * the normal VAs that aren't supposed to hit in cache.)
  */
 static void memcpy_multicache(void *dest, const void *source,
@@ -64,6 +64,7 @@ static void memcpy_multicache(void *dest, const void *source,
 	unsigned long flags, newsrc, newdst;
 	pmd_t *pmdp;
 	pte_t *ptep;
+	int type0, type1;
 	int cpu = get_cpu();
 
 	/*
@@ -77,7 +78,8 @@ static void memcpy_multicache(void *dest, const void *source,
 	sim_allow_multiple_caching(1);
 
 	/* Set up the new dest mapping */
-	idx = FIX_KMAP_BEGIN + (KM_TYPE_NR * cpu) + KM_MEMCPY0;
+	type0 = kmap_atomic_idx_push();
+	idx = FIX_KMAP_BEGIN + (KM_TYPE_NR * cpu) + type0;
 	newdst = __fix_to_virt(idx) + ((unsigned long)dest & (PAGE_SIZE-1));
 	pmdp = pmd_offset(pud_offset(pgd_offset_k(newdst), newdst), newdst);
 	ptep = pte_offset_kernel(pmdp, newdst);
@@ -87,7 +89,8 @@ static void memcpy_multicache(void *dest, const void *source,
 	}
 
 	/* Set up the new source mapping */
-	idx += (KM_MEMCPY0 - KM_MEMCPY1);
+	type1 = kmap_atomic_idx_push();
+	idx += (type0 - type1);
 	src_pte = hv_pte_set_nc(src_pte);
 	src_pte = hv_pte_clear_writable(src_pte);  /* be paranoid */
 	newsrc = __fix_to_virt(idx) + ((unsigned long)source & (PAGE_SIZE-1));
@@ -119,6 +122,8 @@ static void memcpy_multicache(void *dest, const void *source,
 	 * We're done: notify the simulator that all is back to normal,
 	 * and re-enable interrupts and pre-emption.
 	 */
+	kmap_atomic_idx_pop();
+	kmap_atomic_idx_pop();
 	sim_allow_multiple_caching(0);
 	local_irq_restore(flags);
 	put_cpu();
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
index abb5733..31dbbd9 100644
--- a/arch/tile/mm/highmem.c
+++ b/arch/tile/mm/highmem.c
@@ -227,7 +227,7 @@ EXPORT_SYMBOL(kmap_atomic_prot);
 void *__kmap_atomic(struct page *page)
 {
 	/* PAGE_NONE is a magic value that tells us to check immutability. */
-	return kmap_atomic_prot(page, type, PAGE_NONE);
+	return kmap_atomic_prot(page, PAGE_NONE);
 }
 EXPORT_SYMBOL(__kmap_atomic);
 
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 335c246..1f5430c 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -134,9 +134,9 @@ void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
 }
 
 #if defined(CONFIG_HIGHPTE)
-pte_t *_pte_offset_map(pmd_t *dir, unsigned long address, enum km_type type)
+pte_t *_pte_offset_map(pmd_t *dir, unsigned long address)
 {
-	pte_t *pte = kmap_atomic(pmd_page(*dir), type) +
+	pte_t *pte = kmap_atomic(pmd_page(*dir)) +
 		(pmd_ptfn(*dir) << HV_LOG2_PAGE_TABLE_ALIGN) & ~PAGE_MASK;
 	return &pte[pte_index(address)];
 }
-- 
1.6.5.2


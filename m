Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab0HMNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:09:56 -0400
Received: from king.tilera.com ([72.1.168.226]:13968 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761601Ab0HMNJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:09:52 -0400
Message-Id: <201008131309.o7DD9lj6005842@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 08:52:19 -0400
Subject: [PATCH] arch/tile: Various cleanups.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 13 Aug 2010 13:09:47.0922 (UTC) FILETIME=[CE5D0F20:01CB3AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change rolls up random cleanups not representing any actual bugs.

- Remove a stale CONFIG_ value from the default tile_defconfig
- Remove unused tns_atomic_xxx() family of methods from <asm/atomic.h>
- Optimize get_order() using Tile's "clz" instruction
- Fix a bad hypervisor upcall name (not currently used in Linux anyway)
- Use __copy_in_user_inatomic() name for consistency, and export it
- Export some additional hypervisor driver I/O upcalls and some homecache calls
- Remove the obfuscating MEMCPY_TEST_WH64 support code
- Other stray comment cleanups, #if 0 removal, etc.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/configs/tile_defconfig  |    1 -
 arch/tile/include/asm/atomic_32.h |   37 -------------------------------------
 arch/tile/include/asm/page.h      |    6 +++++-
 arch/tile/include/asm/uaccess.h   |    4 ++--
 arch/tile/include/hv/hypervisor.h |    8 ++++----
 arch/tile/lib/Makefile            |    4 +++-
 arch/tile/lib/exports.c           |   16 +++++++++++-----
 arch/tile/lib/memcpy_32.S         |   20 ++++----------------
 arch/tile/lib/memset_32.c         |   25 -------------------------
 arch/tile/mm/fault.c              |    8 ++++++++
 arch/tile/mm/homecache.c          |    3 +++
 11 files changed, 40 insertions(+), 92 deletions(-)

diff --git a/arch/tile/configs/tile_defconfig b/arch/tile/configs/tile_defconfig
index f34c70b..5ad1a71 100644
--- a/arch/tile/configs/tile_defconfig
+++ b/arch/tile/configs/tile_defconfig
@@ -231,7 +231,6 @@ CONFIG_HARDWALL=y
 CONFIG_MEMPROF=y
 CONFIG_XGBE=y
 CONFIG_NET_TILE=y
-CONFIG_PSEUDO_NAPI=y
 CONFIG_TILEPCI_ENDP=y
 CONFIG_TILEPCI_HOST_SUBSET=m
 CONFIG_TILE_IDE_GPIO=y
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 40a5a3a..ed359ae 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -255,43 +255,6 @@ static inline void atomic64_set(atomic64_t *v, u64 n)
 #define smp_mb__after_atomic_dec()	do { } while (0)
 #define smp_mb__after_atomic_inc()	do { } while (0)
 
-
-/*
- * Support "tns" atomic integers.  These are atomic integers that can
- * hold any value but "1".  They are more efficient than regular atomic
- * operations because the "lock" (aka acquire) step is a single "tns"
- * in the uncontended case, and the "unlock" (aka release) step is a
- * single "store" without an mf.  (However, note that on tilepro the
- * "tns" will evict the local cache line, so it's not all upside.)
- *
- * Note that you can ONLY observe the value stored in the pointer
- * using these operations; a direct read of the value may confusingly
- * return the special value "1".
- */
-
-int __tns_atomic_acquire(atomic_t *);
-void __tns_atomic_release(atomic_t *p, int v);
-
-static inline void tns_atomic_set(atomic_t *v, int i)
-{
-	__tns_atomic_acquire(v);
-	__tns_atomic_release(v, i);
-}
-
-static inline int tns_atomic_cmpxchg(atomic_t *v, int o, int n)
-{
-	int ret = __tns_atomic_acquire(v);
-	__tns_atomic_release(v, (ret == o) ? n : ret);
-	return ret;
-}
-
-static inline int tns_atomic_xchg(atomic_t *v, int n)
-{
-	int ret = __tns_atomic_acquire(v);
-	__tns_atomic_release(v, n);
-	return ret;
-}
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index f894a90..7d90641 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -129,6 +129,11 @@ static inline u64 pmd_val(pmd_t pmd)
 
 #endif
 
+static inline __attribute_const__ int get_order(unsigned long size)
+{
+	return BITS_PER_LONG - __builtin_clzl((size - 1) >> PAGE_SHIFT);
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
@@ -332,7 +337,6 @@ extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 	(VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/getorder.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index ed17a80..ef34d2c 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -389,14 +389,14 @@ static inline unsigned long __must_check copy_from_user(void *to,
  * Returns number of bytes that could not be copied.
  * On success, this will be zero.
  */
-extern unsigned long __copy_in_user_asm(
+extern unsigned long __copy_in_user_inatomic(
 	void __user *to, const void __user *from, unsigned long n);
 
 static inline unsigned long __must_check
 __copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	might_sleep();
-	return __copy_in_user_asm(to, from, n);
+	return __copy_in_user_inatomic(to, from, n);
 }
 
 static inline unsigned long __must_check
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 59b46dc..9bd303a 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -532,11 +532,11 @@ void hv_disable_intr(HV_IntrMask disab_mask);
  */
 void hv_clear_intr(HV_IntrMask clear_mask);
 
-/** Assert a set of device interrupts.
+/** Raise a set of device interrupts.
  *
- * @param assert_mask Bitmap of interrupts to clear.
+ * @param raise_mask Bitmap of interrupts to raise.
  */
-void hv_assert_intr(HV_IntrMask assert_mask);
+void hv_raise_intr(HV_IntrMask raise_mask);
 
 /** Trigger a one-shot interrupt on some tile
  *
@@ -1712,7 +1712,7 @@ typedef struct
  * @param cache_control This argument allows you to specify a length of
  *        physical address space to flush (maximum HV_FLUSH_MAX_CACHE_LEN).
  *        You can "or" in HV_FLUSH_EVICT_L2 to flush the whole L2 cache.
- *        You can "or" in HV_FLUSH_EVICT_LI1 to flush the whole LII cache.
+ *        You can "or" in HV_FLUSH_EVICT_L1I to flush the whole L1I cache.
  *        HV_FLUSH_ALL flushes all caches.
  * @param cache_cpumask Bitmask (in row-major order, supervisor-relative) of
  *        tile indices to perform cache flush on.  The low bit of the first
diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 438af38..746dc81 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -7,7 +7,9 @@ lib-y = cacheflush.o checksum.o cpumask.o delay.o \
 	memcpy_$(BITS).o memchr_$(BITS).o memmove_$(BITS).o memset_$(BITS).o \
 	strchr_$(BITS).o strlen_$(BITS).o
 
-ifneq ($(CONFIG_TILEGX),y)
+ifeq ($(CONFIG_TILEGX),y)
+lib-y += memcpy_user_64.o
+else
 lib-y += atomic_32.o atomic_asm_32.o memcpy_tile64.o
 endif
 
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index 6bc7b52..ce5dbf5 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -36,21 +36,29 @@ EXPORT_SYMBOL(clear_user_asm);
 EXPORT_SYMBOL(current_text_addr);
 EXPORT_SYMBOL(dump_stack);
 
-/* arch/tile/lib/__memcpy.S */
-/* NOTE: on TILE64, these symbols appear in arch/tile/lib/memcpy_tile64.c */
+/* arch/tile/lib/, various memcpy files */
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__copy_to_user_inatomic);
 EXPORT_SYMBOL(__copy_from_user_inatomic);
 EXPORT_SYMBOL(__copy_from_user_zeroing);
+#ifdef __tilegx__
+EXPORT_SYMBOL(__copy_in_user_inatomic);
+#endif
 
 /* hypervisor glue */
 #include <hv/hypervisor.h>
 EXPORT_SYMBOL(hv_dev_open);
 EXPORT_SYMBOL(hv_dev_pread);
 EXPORT_SYMBOL(hv_dev_pwrite);
+EXPORT_SYMBOL(hv_dev_preada);
+EXPORT_SYMBOL(hv_dev_pwritea);
+EXPORT_SYMBOL(hv_dev_poll);
+EXPORT_SYMBOL(hv_dev_poll_cancel);
 EXPORT_SYMBOL(hv_dev_close);
+EXPORT_SYMBOL(hv_sysconf);
+EXPORT_SYMBOL(hv_confstr);
 
-/* -ltile-cc */
+/* libgcc.a */
 uint32_t __udivsi3(uint32_t dividend, uint32_t divisor);
 EXPORT_SYMBOL(__udivsi3);
 int32_t __divsi3(int32_t dividend, int32_t divisor);
@@ -70,8 +78,6 @@ EXPORT_SYMBOL(__moddi3);
 #ifndef __tilegx__
 uint64_t __ll_mul(uint64_t n0, uint64_t n1);
 EXPORT_SYMBOL(__ll_mul);
-#endif
-#ifndef __tilegx__
 int64_t __muldi3(int64_t, int64_t);
 EXPORT_SYMBOL(__muldi3);
 uint64_t __lshrdi3(uint64_t, unsigned int);
diff --git a/arch/tile/lib/memcpy_32.S b/arch/tile/lib/memcpy_32.S
index f92984b..30c3b7e 100644
--- a/arch/tile/lib/memcpy_32.S
+++ b/arch/tile/lib/memcpy_32.S
@@ -17,10 +17,6 @@
 
 #include <arch/chip.h>
 
-#if CHIP_HAS_WH64() || defined(MEMCPY_TEST_WH64)
-#define MEMCPY_USE_WH64
-#endif
-
 
 #include <linux/linkage.h>
 
@@ -160,7 +156,7 @@ EX:	{ sw r0, r3; addi r0, r0, 4; addi r2, r2, -4 }
 
 	{ addi r3, r1, 60; andi r9, r9, -64 }
 
-#ifdef MEMCPY_USE_WH64
+#if CHIP_HAS_WH64()
         /* No need to prefetch dst, we'll just do the wh64
          * right before we copy a line.
 	 */
@@ -173,7 +169,7 @@ EX:	{ lw r6, r3; addi r3, r3, 64 }
         /* Intentionally stall for a few cycles to leave L2 cache alone. */
         { bnzt zero, . }
 EX:	{ lw r7, r3; addi r3, r3, 64 }
-#ifndef MEMCPY_USE_WH64
+#if !CHIP_HAS_WH64()
         /* Prefetch the dest */
         /* Intentionally stall for a few cycles to leave L2 cache alone. */
         { bnzt zero, . }
@@ -288,15 +284,7 @@ EX:	{ lw r7, r3; addi r3, r3, 64 }
         /* Fill second L1D line. */
 EX:	{ lw r17, r17; addi r1, r1, 48; mvz r3, r13, r1 } /* r17 = WORD_4 */
 
-#ifdef MEMCPY_TEST_WH64
-        /* Issue a fake wh64 that clobbers the destination words
-         * with random garbage, for testing.
-         */
-	{ movei r19, 64; crc32_32 r10, r2, r9 }
-.Lwh64_test_loop:
-EX:	{ sw r9, r10; addi r9, r9, 4; addi r19, r19, -4 }
-        { bnzt r19, .Lwh64_test_loop; crc32_32 r10, r10, r19 }
-#elif CHIP_HAS_WH64()
+#if CHIP_HAS_WH64()
         /* Prepare destination line for writing. */
 EX:	{ wh64 r9; addi r9, r9, 64 }
 #else
@@ -340,7 +328,7 @@ EX:	{ lw r18, r1; addi r1, r1, 4 }                  /* r18 = WORD_8 */
 EX:	{ sw r0, r16; addi r0, r0, 4; add r16, r0, r2 } /* store(WORD_0) */
 EX:	{ sw r0, r13; addi r0, r0, 4; andi r16, r16, -64 } /* store(WORD_1) */
 EX:	{ sw r0, r14; addi r0, r0, 4; slt_u r16, r9, r16 } /* store(WORD_2) */
-#ifdef MEMCPY_USE_WH64
+#if CHIP_HAS_WH64()
 EX:	{ sw r0, r15; addi r0, r0, 4; addi r13, sp, -64 } /* store(WORD_3) */
 #else
         /* Back up the r9 to a cache line we are already storing to
diff --git a/arch/tile/lib/memset_32.c b/arch/tile/lib/memset_32.c
index bfde5d8..d014c1f 100644
--- a/arch/tile/lib/memset_32.c
+++ b/arch/tile/lib/memset_32.c
@@ -141,7 +141,6 @@ void *memset(void *s, int c, size_t n)
 			 */
 			__insn_prefetch(&out32[ahead32]);
 
-#if 1
 #if CACHE_LINE_SIZE_IN_WORDS % 4 != 0
 #error "Unhandled CACHE_LINE_SIZE_IN_WORDS"
 #endif
@@ -157,30 +156,6 @@ void *memset(void *s, int c, size_t n)
 				*out32++ = v32;
 				*out32++ = v32;
 			}
-#else
-			/* Unfortunately, due to a code generator flaw this
-			 * allocates a separate register for each of these
-			 * stores, which requires a large number of spills,
-			 * which makes this procedure enormously bigger
-			 * (something like 70%)
-			 */
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			*out32++ = v32;
-			n32 -= 16;
-#endif
 
 			/* To save compiled code size, reuse this loop even
 			 * when we run out of prefetching to do by dropping
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 0011f06..704f3e8 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -567,6 +567,14 @@ do_sigbus:
  * since that might indicate we have not yet squirreled the SPR
  * contents away and can thus safely take a recursive interrupt.
  * Accordingly, the hypervisor passes us the PC via SYSTEM_SAVE_1_2.
+ *
+ * Note that this routine is called before homecache_tlb_defer_enter(),
+ * which means that we can properly unlock any atomics that might
+ * be used there (good), but also means we must be very sensitive
+ * to not touch any data structures that might be located in memory
+ * that could migrate, as we could be entering the kernel on a dataplane
+ * cpu that has been deferring kernel TLB updates.  This means, for
+ * example, that we can't migrate init_mm or its pgd.
  */
 struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
 				      unsigned long address,
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 97c478e..fb3b4a5 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -29,6 +29,7 @@
 #include <linux/timex.h>
 #include <linux/cache.h>
 #include <linux/smp.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -348,6 +349,7 @@ pte_t pte_set_home(pte_t pte, int home)
 
 	return pte;
 }
+EXPORT_SYMBOL(pte_set_home);
 
 /*
  * The routines in this section are the "static" versions of the normal
@@ -403,6 +405,7 @@ struct page *homecache_alloc_pages(gfp_t gfp_mask,
 		homecache_change_page_home(page, order, home);
 	return page;
 }
+EXPORT_SYMBOL(homecache_alloc_pages);
 
 struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
 					unsigned int order, int home)
-- 
1.6.5.2


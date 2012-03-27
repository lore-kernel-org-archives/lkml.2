Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936757Ab2C3XCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:02:54 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934766Ab2C3VFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:12 -0400
Message-Id: <201203302104.q2UL4tQk006259@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 15:40:20 -0400
Subject: [PATCH] arch/tile: use interrupt critical sections less
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:56.0460 (UTC) FILETIME=[C28FFCC0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general we want to avoid ever touching memory while within an
interrupt critical section, since the page fault path goes through
a different path from the hypervisor when in an interrupt critical
section, and we carefully decided with tilegx that we didn't need
to support this path in the kernel.  (On tilepro we did implement
that path as part of supporting atomic instructions in software.)

In practice we always need to touch the kernel stack, since that's
where we store the interrupt state before releasing the critical
section, but this change cleans up a few things.  The IRQ_ENABLE
macro is split up so that when we want to enable interrupts in a
deferred way (e.g. for cpu_idle or for interrupt return) we can
read the per-cpu enable mask before entering the critical section.
The cache-migration code is changed to use interrupt masking instead
of interrupt critical sections.  And, the interrupt-entry code is
changed so that we defer loading "tp" from per-cpu data until after
we have released the interrupt critical section.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irqflags.h |   34 +++++++++++++----
 arch/tile/kernel/entry.S         |    3 +-
 arch/tile/kernel/intvec_64.S     |   78 +++++++++++++++++++++-----------------
 arch/tile/mm/init.c              |    4 ++
 arch/tile/mm/migrate.h           |    6 +++
 arch/tile/mm/migrate_32.S        |   36 ++++-------------
 arch/tile/mm/migrate_64.S        |   34 +++-------------
 7 files changed, 96 insertions(+), 99 deletions(-)

diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index 5db0ce5..b4e96fe 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -28,10 +28,10 @@
  */
 #if CHIP_HAS_AUX_PERF_COUNTERS()
 #define LINUX_MASKABLE_INTERRUPTS_HI \
-       (~(INT_MASK_HI(INT_PERF_COUNT) | INT_MASK_HI(INT_AUX_PERF_COUNT)))
+	(~(INT_MASK_HI(INT_PERF_COUNT) | INT_MASK_HI(INT_AUX_PERF_COUNT)))
 #else
 #define LINUX_MASKABLE_INTERRUPTS_HI \
-       (~(INT_MASK_HI(INT_PERF_COUNT)))
+	(~(INT_MASK_HI(INT_PERF_COUNT)))
 #endif
 
 #else
@@ -90,6 +90,14 @@
 	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K_0, (unsigned long)(__m)); \
 	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K_1, (unsigned long)(__m>>32)); \
 } while (0)
+#define interrupt_mask_save_mask() \
+	(__insn_mfspr(SPR_INTERRUPT_MASK_SET_K_0) | \
+	 (((unsigned long long)__insn_mfspr(SPR_INTERRUPT_MASK_SET_K_1))<<32))
+#define interrupt_mask_restore_mask(mask) do { \
+	unsigned long long __m = (mask); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_K_0, (unsigned long)(__m)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_K_1, (unsigned long)(__m>>32)); \
+} while (0)
 #else
 #define interrupt_mask_set(n) \
 	__insn_mtspr(SPR_INTERRUPT_MASK_SET_K, (1UL << (n)))
@@ -101,6 +109,10 @@
 	__insn_mtspr(SPR_INTERRUPT_MASK_SET_K, (mask))
 #define interrupt_mask_reset_mask(mask) \
 	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_K, (mask))
+#define interrupt_mask_save_mask() \
+	__insn_mfspr(SPR_INTERRUPT_MASK_K)
+#define interrupt_mask_restore_mask(mask) \
+	__insn_mtspr(SPR_INTERRUPT_MASK_K, (mask))
 #endif
 
 /*
@@ -122,7 +134,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 
 /* Disable all interrupts, including NMIs. */
 #define arch_local_irq_disable_all() \
-	interrupt_mask_set_mask(-1UL)
+	interrupt_mask_set_mask(-1ULL)
 
 /* Re-enable all maskable interrupts. */
 #define arch_local_irq_enable() \
@@ -179,7 +191,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 #ifdef __tilegx__
 
 #if INT_MEM_ERROR != 0
-# error Fix IRQ_DISABLED() macro
+# error Fix IRQS_DISABLED() macro
 #endif
 
 /* Return 0 or 1 to indicate whether interrupts are currently disabled. */
@@ -207,9 +219,10 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 	mtspr   SPR_INTERRUPT_MASK_SET_K, tmp
 
 /* Enable interrupts. */
-#define IRQ_ENABLE(tmp0, tmp1)					\
+#define IRQ_ENABLE_LOAD(tmp0, tmp1)				\
 	GET_INTERRUPTS_ENABLED_MASK_PTR(tmp0);			\
-	ld      tmp0, tmp0;					\
+	ld      tmp0, tmp0
+#define IRQ_ENABLE_APPLY(tmp0, tmp1)				\
 	mtspr   SPR_INTERRUPT_MASK_RESET_K, tmp0
 
 #else /* !__tilegx__ */
@@ -253,17 +266,22 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 	mtspr   SPR_INTERRUPT_MASK_SET_K_1, tmp
 
 /* Enable interrupts. */
-#define IRQ_ENABLE(tmp0, tmp1)					\
+#define IRQ_ENABLE_LOAD(tmp0, tmp1)				\
 	GET_INTERRUPTS_ENABLED_MASK_PTR(tmp0);			\
 	{							\
 	 lw     tmp0, tmp0;					\
 	 addi   tmp1, tmp0, 4					\
 	};							\
-	lw      tmp1, tmp1;					\
+	lw      tmp1, tmp1
+#define IRQ_ENABLE_APPLY(tmp0, tmp1)				\
 	mtspr   SPR_INTERRUPT_MASK_RESET_K_0, tmp0;		\
 	mtspr   SPR_INTERRUPT_MASK_RESET_K_1, tmp1
 #endif
 
+#define IRQ_ENABLE(tmp0, tmp1)					\
+	IRQ_ENABLE_LOAD(tmp0, tmp1);				\
+	IRQ_ENABLE_APPLY(tmp0, tmp1)
+
 /*
  * Do the CPU's IRQ-state tracing from assembly code. We call a
  * C function, but almost everywhere we do, we don't mind clobbering
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index 431e9ae..f8d6155 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -99,8 +99,9 @@ STD_ENTRY(smp_nap)
  */
 STD_ENTRY(_cpu_idle)
 	movei r1, 1
+	IRQ_ENABLE_LOAD(r2, r3)
 	mtspr INTERRUPT_CRITICAL_SECTION, r1
-	IRQ_ENABLE(r2, r3)             /* unmask, but still with ICS set */
+	IRQ_ENABLE_APPLY(r2, r3)       /* unmask, but still with ICS set */
 	mtspr INTERRUPT_CRITICAL_SECTION, zero
 	.global _cpu_idle_nap
 _cpu_idle_nap:
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 79c93e1..3c1f626 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -219,7 +219,9 @@ intvec_\vecname:
 	 * This routine saves just the first four registers, plus the
 	 * stack context so we can do proper backtracing right away,
 	 * and defers to handle_interrupt to save the rest.
-	 * The backtracer needs pc, ex1, lr, sp, r52, and faultnum.
+	 * The backtracer needs pc, ex1, lr, sp, r52, and faultnum,
+	 * and needs sp set to its final location at the bottom of
+	 * the stack frame.
 	 */
 	addli   r0, r0, PTREGS_OFFSET_LR - (PTREGS_SIZE + KSTK_PTREGS_GAP)
 	wh64    r0   /* cache line 7 */
@@ -449,23 +451,6 @@ intvec_\vecname:
 	push_reg r5, r52
 	st      r52, r4
 
-	/* Load tp with our per-cpu offset. */
-#ifdef CONFIG_SMP
-	{
-	 mfspr  r20, SPR_SYSTEM_SAVE_K_0
-	 moveli r21, hw2_last(__per_cpu_offset)
-	}
-	{
-	 shl16insli r21, r21, hw1(__per_cpu_offset)
-	 bfextu r20, r20, 0, LOG2_THREAD_SIZE-1
-	}
-	shl16insli r21, r21, hw0(__per_cpu_offset)
-	shl3add r20, r20, r21
-	ld      tp, r20
-#else
-	move    tp, zero
-#endif
-
 	/*
 	 * If we will be returning to the kernel, we will need to
 	 * reset the interrupt masks to the state they had before.
@@ -488,6 +473,44 @@ intvec_\vecname:
 	.endif
 	st      r21, r32
 
+	/*
+	 * we've captured enough state to the stack (including in
+	 * particular our EX_CONTEXT state) that we can now release
+	 * the interrupt critical section and replace it with our
+	 * standard "interrupts disabled" mask value.  This allows
+	 * synchronous interrupts (and profile interrupts) to punch
+	 * through from this point onwards.
+	 *
+	 * It's important that no code before this point touch memory
+	 * other than our own stack (to keep the invariant that this
+	 * is all that gets touched under ICS), and that no code after
+	 * this point reference any interrupt-specific SPR, in particular
+	 * the EX_CONTEXT_K_ values.
+	 */
+	.ifc \function,handle_nmi
+	IRQ_DISABLE_ALL(r20)
+	.else
+	IRQ_DISABLE(r20, r21)
+	.endif
+	mtspr   INTERRUPT_CRITICAL_SECTION, zero
+
+	/* Load tp with our per-cpu offset. */
+#ifdef CONFIG_SMP
+	{
+	 mfspr  r20, SPR_SYSTEM_SAVE_K_0
+	 moveli r21, hw2_last(__per_cpu_offset)
+	}
+	{
+	 shl16insli r21, r21, hw1(__per_cpu_offset)
+	 bfextu r20, r20, 0, LOG2_THREAD_SIZE-1
+	}
+	shl16insli r21, r21, hw0(__per_cpu_offset)
+	shl3add r20, r20, r21
+	ld      tp, r20
+#else
+	move    tp, zero
+#endif
+
 #ifdef __COLLECT_LINKER_FEEDBACK__
 	/*
 	 * Notify the feedback routines that we were in the
@@ -512,21 +535,6 @@ intvec_\vecname:
 #endif
 
 	/*
-	 * we've captured enough state to the stack (including in
-	 * particular our EX_CONTEXT state) that we can now release
-	 * the interrupt critical section and replace it with our
-	 * standard "interrupts disabled" mask value.  This allows
-	 * synchronous interrupts (and profile interrupts) to punch
-	 * through from this point onwards.
-	 */
-	.ifc \function,handle_nmi
-	IRQ_DISABLE_ALL(r20)
-	.else
-	IRQ_DISABLE(r20, r21)
-	.endif
-	mtspr   INTERRUPT_CRITICAL_SECTION, zero
-
-	/*
 	 * Prepare the first 256 stack bytes to be rapidly accessible
 	 * without having to fetch the background data.
 	 */
@@ -718,9 +726,10 @@ STD_ENTRY(interrupt_return)
 	beqzt   r30, .Lrestore_regs
 	j       3f
 2:	TRACE_IRQS_ON
+	IRQ_ENABLE_LOAD(r20, r21)
 	movei   r0, 1
 	mtspr   INTERRUPT_CRITICAL_SECTION, r0
-	IRQ_ENABLE(r20, r21)
+	IRQ_ENABLE_APPLY(r20, r21)
 	beqzt   r30, .Lrestore_regs
 3:
 
@@ -737,7 +746,6 @@ STD_ENTRY(interrupt_return)
 	 * that will save some cycles if this turns out to be a syscall.
 	 */
 .Lrestore_regs:
-	FEEDBACK_REENTER(interrupt_return)   /* called from elsewhere */
 
 	/*
 	 * Rotate so we have one high bit and one low bit to test.
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 7309988..51c5e51 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -450,6 +450,7 @@ static pgd_t pgtables[PTRS_PER_PGD]
  */
 static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 {
+	unsigned long long irqmask;
 	unsigned long address, pfn;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -630,10 +631,13 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	 *  - install pgtables[] as the real page table
 	 *  - flush the TLB so the new page table takes effect
 	 */
+	irqmask = interrupt_mask_save_mask();
+	interrupt_mask_set_mask(-1ULL);
 	rc = flush_and_install_context(__pa(pgtables),
 				       init_pgprot((unsigned long)pgtables),
 				       __get_cpu_var(current_asid),
 				       cpumask_bits(my_cpu_mask));
+	interrupt_mask_restore_mask(irqmask);
 	BUG_ON(rc != 0);
 
 	/* Copy the page table back to the normal swapper_pg_dir. */
diff --git a/arch/tile/mm/migrate.h b/arch/tile/mm/migrate.h
index cd45a08..91683d9 100644
--- a/arch/tile/mm/migrate.h
+++ b/arch/tile/mm/migrate.h
@@ -24,6 +24,9 @@
 /*
  * This function is used as a helper when setting up the initial
  * page table (swapper_pg_dir).
+ *
+ * You must mask ALL interrupts prior to invoking this code, since
+ * you can't legally touch the stack during the cache flush.
  */
 extern int flush_and_install_context(HV_PhysAddr page_table, HV_PTE access,
 				     HV_ASID asid,
@@ -39,6 +42,9 @@ extern int flush_and_install_context(HV_PhysAddr page_table, HV_PTE access,
  *
  * Note that any non-NULL pointers must not point to the page that
  * is handled by the stack_pte itself.
+ *
+ * You must mask ALL interrupts prior to invoking this code, since
+ * you can't legally touch the stack during the cache flush.
  */
 extern int homecache_migrate_stack_and_flush(pte_t stack_pte, unsigned long va,
 				     size_t length, pte_t *stack_ptep,
diff --git a/arch/tile/mm/migrate_32.S b/arch/tile/mm/migrate_32.S
index ac01a7c..5305814 100644
--- a/arch/tile/mm/migrate_32.S
+++ b/arch/tile/mm/migrate_32.S
@@ -40,8 +40,7 @@
 #define FRAME_R32	16
 #define FRAME_R33	20
 #define FRAME_R34	24
-#define FRAME_R35	28
-#define FRAME_SIZE	32
+#define FRAME_SIZE	28
 
 
 
@@ -66,12 +65,11 @@
 #define r_my_cpumask	r5
 
 /* Locals (callee-save); must not be more than FRAME_xxx above. */
-#define r_save_ics	r30
-#define r_context_lo	r31
-#define r_context_hi	r32
-#define r_access_lo	r33
-#define r_access_hi	r34
-#define r_asid		r35
+#define r_context_lo	r30
+#define r_context_hi	r31
+#define r_access_lo	r32
+#define r_access_hi	r33
+#define r_asid		r34
 
 STD_ENTRY(flush_and_install_context)
 	/*
@@ -104,11 +102,7 @@ STD_ENTRY(flush_and_install_context)
 	 sw r_tmp, r33
 	 addi r_tmp, sp, FRAME_R34
 	}
-	{
-	 sw r_tmp, r34
-	 addi r_tmp, sp, FRAME_R35
-	}
-	sw r_tmp, r35
+	sw r_tmp, r34
 
 	/* Move some arguments to callee-save registers. */
 	{
@@ -121,13 +115,6 @@ STD_ENTRY(flush_and_install_context)
 	}
 	move r_asid, r_asid_in
 
-	/* Disable interrupts, since we can't use our stack. */
-	{
-	 mfspr r_save_ics, INTERRUPT_CRITICAL_SECTION
-	 movei r_tmp, 1
-	}
-	mtspr INTERRUPT_CRITICAL_SECTION, r_tmp
-
 	/* First, flush our L2 cache. */
 	{
 	 move r0, zero  /* cache_pa */
@@ -163,7 +150,7 @@ STD_ENTRY(flush_and_install_context)
 	}
 	{
 	 move r4, r_asid
-	 movei r5, HV_CTX_DIRECTIO
+	 moveli r5, HV_CTX_DIRECTIO | CTX_PAGE_FLAG
 	}
 	jal hv_install_context
 	bnz r0, .Ldone
@@ -175,9 +162,6 @@ STD_ENTRY(flush_and_install_context)
 	}
 
 .Ldone:
-	/* Reset interrupts back how they were before. */
-	mtspr INTERRUPT_CRITICAL_SECTION, r_save_ics
-
 	/* Restore the callee-saved registers and return. */
 	addli lr, sp, FRAME_SIZE
 	{
@@ -202,10 +186,6 @@ STD_ENTRY(flush_and_install_context)
 	}
 	{
 	 lw r34, r_tmp
-	 addli r_tmp, sp, FRAME_R35
-	}
-	{
-	 lw r35, r_tmp
 	 addi sp, sp, FRAME_SIZE
 	}
 	jrp lr
diff --git a/arch/tile/mm/migrate_64.S b/arch/tile/mm/migrate_64.S
index e76fea6..1d15b10 100644
--- a/arch/tile/mm/migrate_64.S
+++ b/arch/tile/mm/migrate_64.S
@@ -38,8 +38,7 @@
 #define FRAME_R30	16
 #define FRAME_R31	24
 #define FRAME_R32	32
-#define FRAME_R33	40
-#define FRAME_SIZE	48
+#define FRAME_SIZE	40
 
 
 
@@ -60,10 +59,9 @@
 #define r_my_cpumask	r3
 
 /* Locals (callee-save); must not be more than FRAME_xxx above. */
-#define r_save_ics	r30
-#define r_context	r31
-#define r_access	r32
-#define r_asid		r33
+#define r_context	r30
+#define r_access	r31
+#define r_asid		r32
 
 /*
  * Caller-save locals and frame constants are the same as
@@ -93,11 +91,7 @@ STD_ENTRY(flush_and_install_context)
 	 st r_tmp, r31
 	 addi r_tmp, sp, FRAME_R32
 	}
-	{
-	 st r_tmp, r32
-	 addi r_tmp, sp, FRAME_R33
-	}
-	st r_tmp, r33
+	st r_tmp, r32
 
 	/* Move some arguments to callee-save registers. */
 	{
@@ -106,13 +100,6 @@ STD_ENTRY(flush_and_install_context)
 	}
 	move r_asid, r_asid_in
 
-	/* Disable interrupts, since we can't use our stack. */
-	{
-	 mfspr r_save_ics, INTERRUPT_CRITICAL_SECTION
-	 movei r_tmp, 1
-	}
-	mtspr INTERRUPT_CRITICAL_SECTION, r_tmp
-
 	/* First, flush our L2 cache. */
 	{
 	 move r0, zero  /* cache_pa */
@@ -147,7 +134,7 @@ STD_ENTRY(flush_and_install_context)
 	}
 	{
 	 move r2, r_asid
-	 movei r3, HV_CTX_DIRECTIO
+	 moveli r3, HV_CTX_DIRECTIO | CTX_PAGE_FLAG
 	}
 	jal hv_install_context
 	bnez r0, 1f
@@ -158,10 +145,7 @@ STD_ENTRY(flush_and_install_context)
 	 jal hv_flush_all
 	}
 
-1:      /* Reset interrupts back how they were before. */
-	mtspr INTERRUPT_CRITICAL_SECTION, r_save_ics
-
-	/* Restore the callee-saved registers and return. */
+1:	/* Restore the callee-saved registers and return. */
 	addli lr, sp, FRAME_SIZE
 	{
 	 ld lr, lr
@@ -177,10 +161,6 @@ STD_ENTRY(flush_and_install_context)
 	}
 	{
 	 ld r32, r_tmp
-	 addli r_tmp, sp, FRAME_R33
-	}
-	{
-	 ld r33, r_tmp
 	 addi sp, sp, FRAME_SIZE
 	}
 	jrp lr
-- 
1.6.5.2


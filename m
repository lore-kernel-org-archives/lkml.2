Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0JZCzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab0JZCzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 27/43] MN10300: Make the use of PIDR to mark TLB entries
 controllable
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:25 +0100
Message-ID: <20101026025525.23512.2088.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Make controllable the use of the PIDR register to mark TLB entries as belonging
to particular processes.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                   |    3 ++
 arch/mn10300/include/asm/mmu_context.h |   59 ++++++++++++++++----------------
 arch/mn10300/include/asm/tlbflush.h    |   43 ++++++++++++++++++++++-
 arch/mn10300/mm/mmu-context.c          |   41 ++++++----------------
 4 files changed, 84 insertions(+), 62 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index dd7b570..7bd920b 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -142,6 +142,9 @@ config FPU
 
 source "arch/mn10300/mm/Kconfig.cache"
 
+config MN10300_TLB_USE_PIDR
+	def_bool y
+
 menu "Memory layout options"
 
 config KERNEL_RAM_BASE_ADDRESS
diff --git a/arch/mn10300/include/asm/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
index 24d63f0..5fb3648 100644
--- a/arch/mn10300/include/asm/mmu_context.h
+++ b/arch/mn10300/include/asm/mmu_context.h
@@ -27,28 +27,22 @@
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
 
+#define MMU_CONTEXT_TLBPID_NR		256
 #define MMU_CONTEXT_TLBPID_MASK		0x000000ffUL
 #define MMU_CONTEXT_VERSION_MASK	0xffffff00UL
 #define MMU_CONTEXT_FIRST_VERSION	0x00000100UL
 #define MMU_NO_CONTEXT			0x00000000UL
-
-extern unsigned long mmu_context_cache[NR_CPUS];
-#define mm_context(mm)	(mm->context.tlbpid[smp_processor_id()])
+#define MMU_CONTEXT_TLBPID_LOCK_NR	0
 
 #define enter_lazy_tlb(mm, tsk)	do {} while (0)
 
-#ifdef CONFIG_SMP
-#define cpu_ran_vm(cpu, mm) \
-	cpumask_set_cpu((cpu), mm_cpumask(mm))
-#define cpu_maybe_ran_vm(cpu, mm) \
-	cpumask_test_and_set_cpu((cpu), mm_cpumask(mm))
-#else
-#define cpu_ran_vm(cpu, mm)		do {} while (0)
-#define cpu_maybe_ran_vm(cpu, mm)	true
-#endif /* CONFIG_SMP */
+#ifdef CONFIG_MN10300_TLB_USE_PIDR
+extern unsigned long mmu_context_cache[NR_CPUS];
+#define mm_context(mm)	(mm->context.tlbpid[smp_processor_id()])
 
-/*
- * allocate an MMU context
+/**
+ * allocate_mmu_context - Allocate storage for the arch-specific MMU data
+ * @mm: The userspace VM context being set up
  */
 static inline unsigned long allocate_mmu_context(struct mm_struct *mm)
 {
@@ -101,34 +95,41 @@ static inline int init_new_context(struct task_struct *tsk,
 }
 
 /*
- * destroy context related info for an mm_struct that is about to be put to
- * rest
- */
-#define destroy_context(mm)	do { } while (0)
-
-/*
  * after we have set current->mm to a new value, this activates the context for
  * the new mm so we see the new mappings.
  */
-static inline void activate_context(struct mm_struct *mm, int cpu)
+static inline void activate_context(struct mm_struct *mm)
 {
 	PIDR = get_mmu_context(mm) & MMU_CONTEXT_TLBPID_MASK;
 }
+#else  /* CONFIG_MN10300_TLB_USE_PIDR */
 
-/*
- * change between virtual memory sets
+#define init_new_context(tsk, mm)	(0)
+#define activate_context(mm)		local_flush_tlb()
+
+#endif /* CONFIG_MN10300_TLB_USE_PIDR */
+
+/**
+ * destroy_context - Destroy mm context information
+ * @mm: The MM being destroyed.
+ *
+ * Destroy context related info for an mm_struct that is about to be put to
+ * rest
+ */
+#define destroy_context(mm)	do {} while (0)
+
+/**
+ * switch_mm - Change between userspace virtual memory contexts
+ * @prev: The outgoing MM context.
+ * @next: The incoming MM context.
+ * @tsk: The incoming task.
  */
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
-	int cpu = smp_processor_id();
-
 	if (prev != next) {
-		cpu_ran_vm(cpu, next);
-		activate_context(next, cpu);
 		PTBR = (unsigned long) next->pgd;
-	} else if (!cpu_maybe_ran_vm(cpu, next)) {
-		activate_context(next, cpu);
+		activate_context(next);
 	}
 }
 
diff --git a/arch/mn10300/include/asm/tlbflush.h b/arch/mn10300/include/asm/tlbflush.h
index 5d54bf5..c3c194d 100644
--- a/arch/mn10300/include/asm/tlbflush.h
+++ b/arch/mn10300/include/asm/tlbflush.h
@@ -13,6 +13,12 @@
 
 #include <asm/processor.h>
 
+struct tlb_state {
+	struct mm_struct	*active_mm;
+	int			state;
+};
+DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
+
 /**
  * local_flush_tlb - Flush the current MM's entries from the local CPU's TLBs
  */
@@ -31,20 +37,51 @@ static inline void local_flush_tlb(void)
 /**
  * local_flush_tlb_all - Flush all entries from the local CPU's TLBs
  */
-#define local_flush_tlb_all()		local_flush_tlb()
+static inline void local_flush_tlb_all(void)
+{
+	local_flush_tlb();
+}
 
 /**
  * local_flush_tlb_one - Flush one entry from the local CPU's TLBs
  */
-#define local_flush_tlb_one(addr)	local_flush_tlb()
+static inline void local_flush_tlb_one(unsigned long addr)
+{
+	local_flush_tlb();
+}
 
 /**
  * local_flush_tlb_page - Flush a page's entry from the local CPU's TLBs
  * @mm: The MM to flush for
  * @addr: The address of the target page in RAM (not its page struct)
  */
-extern void local_flush_tlb_page(struct mm_struct *mm, unsigned long addr);
+static inline
+void local_flush_tlb_page(struct mm_struct *mm, unsigned long addr)
+{
+	unsigned long pteu, flags, cnx;
+
+	addr &= PAGE_MASK;
 
+	local_irq_save(flags);
+
+	cnx = 1;
+#ifdef CONFIG_MN10300_TLB_USE_PIDR
+	cnx = mm->context.tlbpid[smp_processor_id()];
+#endif
+	if (cnx) {
+		pteu = addr;
+#ifdef CONFIG_MN10300_TLB_USE_PIDR
+		pteu |= cnx & xPTEU_PID;
+#endif
+		IPTEU = pteu;
+		DPTEU = pteu;
+		if (IPTEL & xPTEL_V)
+			IPTEL = 0;
+		if (DPTEL & xPTEL_V)
+			DPTEL = 0;
+	}
+	local_irq_restore(flags);
+}
 
 /*
  * TLB flushing:
diff --git a/arch/mn10300/mm/mmu-context.c b/arch/mn10300/mm/mmu-context.c
index 3d83966..a4f7d3d 100644
--- a/arch/mn10300/mm/mmu-context.c
+++ b/arch/mn10300/mm/mmu-context.c
@@ -13,40 +13,15 @@
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_MN10300_TLB_USE_PIDR
 /*
  * list of the MMU contexts last allocated on each CPU
  */
 unsigned long mmu_context_cache[NR_CPUS] = {
-	[0 ... NR_CPUS - 1] = MMU_CONTEXT_FIRST_VERSION * 2 - 1,
+	[0 ... NR_CPUS - 1] =
+	MMU_CONTEXT_FIRST_VERSION * 2 - (1 - MMU_CONTEXT_TLBPID_LOCK_NR),
 };
-
-/*
- * flush the specified TLB entry
- */
-void local_flush_tlb_page(struct mm_struct *mm, unsigned long addr)
-{
-	unsigned long pteu, cnx, flags;
-
-	addr &= PAGE_MASK;
-
-	/* make sure the context doesn't migrate and defend against
-	 * interference from vmalloc'd regions */
-	local_irq_save(flags);
-
-	cnx = mm_context(mm);
-
-	if (cnx != MMU_NO_CONTEXT) {
-		pteu = addr | (cnx & 0x000000ffUL);
-		IPTEU = pteu;
-		DPTEU = pteu;
-		if (IPTEL & xPTEL_V)
-			IPTEL = 0;
-		if (DPTEL & xPTEL_V)
-			DPTEL = 0;
-	}
-
-	local_irq_restore(flags);
-}
+#endif /* CONFIG_MN10300_TLB_USE_PIDR */
 
 /*
  * preemptively set a TLB entry
@@ -63,10 +38,16 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t *pte
 	 * interference from vmalloc'd regions */
 	local_irq_save(flags);
 
+	cnx = ~MMU_NO_CONTEXT;
+#ifdef CONFIG_MN10300_TLB_USE_PIDR
 	cnx = mm_context(vma->vm_mm);
+#endif
 
 	if (cnx != MMU_NO_CONTEXT) {
-		pteu = addr | (cnx & 0x000000ffUL);
+		pteu = addr;
+#ifdef CONFIG_MN10300_TLB_USE_PIDR
+		pteu |= cnx & MMU_CONTEXT_TLBPID_MASK;
+#endif
 		if (!(pte_val(pte) & _PAGE_NX)) {
 			IPTEU = pteu;
 			if (IPTEL & xPTEL_V)


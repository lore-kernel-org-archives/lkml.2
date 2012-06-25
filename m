Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2FYGNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:13:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:27904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab2FYGLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162132934"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 2/9] x86/flush_tlb: try flush_tlb_single one by one in flush_tlb_range
Date: Mon, 25 Jun 2012 14:08:20 +0800
Message-Id: <1340604507-11214-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 has no flush_tlb_range support in instruction level. Currently the
flush_tlb_range just implemented by flushing all page table. That is not
the best solution for all scenarios. In fact, if we just use 'invlpg' to
flush few lines from TLB, we can get the performance gain from later
remain TLB lines accessing.

But the 'invlpg' instruction costs much of time. Its execution time can
compete with cr3 rewriting, and even a bit more on SNB CPU.

So, on a 512 4KB TLB entries CPU, the balance points is at:
	(512 - X) * 100ns(assumed TLB refill cost) =
		X(TLB flush entries) * 100ns(assumed invlpg cost)

Here, X is 256, that is 1/2 of 512 entries.

But with the mysterious CPU pre-fetcher and page miss handler Unit, the
assumed TLB refill cost is far lower then 100ns in sequential access. And
2 HT siblings in one core makes the memory access more faster if they are
accessing the same memory. So, in the patch, I just do the change when
the target entries is less than 1/16 of whole active tlb entries.
Actually, I have no data support for the percentage '1/16', so any
suggestions are welcomed.

As to hugetlb, guess due to smaller page table, and smaller active TLB
entries, I didn't see benefit via my benchmark, so no optimizing now.

My macro benchmark show in ideal scenarios, the performance improves 70
percent in reading. And in worst scenario, the reading/writing
performance is similar with unpatched 3.4-rc4 kernel.

Here is the reading data on my 2P * 4cores *HT NHM EP machine, with THP
'always':

multi thread testing, '-t' paramter is thread number:
	       	        with patch   unpatched 3.4-rc4
./mprotect -t 1           14ns		24ns
./mprotect -t 2           13ns		22ns
./mprotect -t 4           12ns		19ns
./mprotect -t 8           14ns		16ns
./mprotect -t 16          28ns		26ns
./mprotect -t 32          54ns		51ns
./mprotect -t 128         200ns		199ns

Single process with sequencial flushing and memory accessing:

		       	with patch   unpatched 3.4-rc4
./mprotect		    7ns			11ns
./mprotect -p 4096  -l 8 -n 10240
			    21ns		21ns

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/paravirt.h       |    5 +-
 arch/x86/include/asm/paravirt_types.h |    3 +-
 arch/x86/include/asm/tlbflush.h       |   23 +++-----
 arch/x86/include/asm/uv/uv.h          |    5 +-
 arch/x86/mm/tlb.c                     |   97 +++++++++++++++++++++++++++------
 arch/x86/platform/uv/tlb_uv.c         |    6 +-
 arch/x86/xen/mmu.c                    |   12 ++--
 include/trace/events/xen.h            |   12 +++--
 8 files changed, 114 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6cbbabf..7e2c2a6 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -397,9 +397,10 @@ static inline void __flush_tlb_single(unsigned long addr)
 
 static inline void flush_tlb_others(const struct cpumask *cpumask,
 				    struct mm_struct *mm,
-				    unsigned long va)
+				    unsigned long start,
+				    unsigned long end)
 {
-	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
+	PVOP_VCALL4(pv_mmu_ops.flush_tlb_others, cpumask, mm, start, end);
 }
 
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8e8b9a4..600a5fcac9 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -250,7 +250,8 @@ struct pv_mmu_ops {
 	void (*flush_tlb_single)(unsigned long addr);
 	void (*flush_tlb_others)(const struct cpumask *cpus,
 				 struct mm_struct *mm,
-				 unsigned long va);
+				 unsigned long start,
+				 unsigned long end);
 
 	/* Hooks for allocating and freeing a pagetable top-level */
 	int  (*pgd_alloc)(struct mm_struct *mm);
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 36a1a2a..33608d9 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -73,14 +73,10 @@ static inline void __flush_tlb_one(unsigned long addr)
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_others(cpumask, mm, va) flushes TLBs on other cpus
+ *  - flush_tlb_others(cpumask, mm, start, end) flushes TLBs on other cpus
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
- *
- * x86-64 can only flush individual pages or full VMs. For a range flush
- * we always do the full VM. Might be worth trying if for a small
- * range a few INVLPGs in a row are a win.
  */
 
 #ifndef CONFIG_SMP
@@ -111,7 +107,8 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 
 static inline void native_flush_tlb_others(const struct cpumask *cpumask,
 					   struct mm_struct *mm,
-					   unsigned long va)
+					   unsigned long start,
+					   unsigned long end)
 {
 }
 
@@ -129,17 +126,14 @@ extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
 extern void flush_tlb_mm(struct mm_struct *);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
+extern void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end);
 
 #define flush_tlb()	flush_tlb_current_task()
 
-static inline void flush_tlb_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end)
-{
-	flush_tlb_mm(vma->vm_mm);
-}
-
 void native_flush_tlb_others(const struct cpumask *cpumask,
-			     struct mm_struct *mm, unsigned long va);
+				struct mm_struct *mm,
+				unsigned long start, unsigned long end);
 
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
@@ -159,7 +153,8 @@ static inline void reset_lazy_tlbstate(void)
 #endif	/* SMP */
 
 #ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(mask, mm, va)
+#define flush_tlb_others(mask, mm, start, end)	\
+	native_flush_tlb_others(mask, mm, start, end)
 #endif
 
 static inline void flush_tlb_kernel_range(unsigned long start,
diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index 3bb9491..b47c2a8 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -15,7 +15,8 @@ extern void uv_nmi_init(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
-						 unsigned long va,
+						 unsigned long start,
+						 unsigned end,
 						 unsigned int cpu);
 
 #else	/* X86_UV */
@@ -26,7 +27,7 @@ static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
-		    unsigned long va, unsigned int cpu)
+		    unsigned long start, unsigned long end, unsigned int cpu)
 { return cpumask; }
 
 #endif	/* X86_UV */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5e57e11..3b91c98 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -41,7 +41,8 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
 union smp_flush_state {
 	struct {
 		struct mm_struct *flush_mm;
-		unsigned long flush_va;
+		unsigned long flush_start;
+		unsigned long flush_end;
 		raw_spinlock_t tlbstate_lock;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
@@ -156,10 +157,19 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 
 	if (f->flush_mm == this_cpu_read(cpu_tlbstate.active_mm)) {
 		if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (f->flush_va == TLB_FLUSH_ALL)
+			if (f->flush_end == TLB_FLUSH_ALL
+					|| !cpu_has_invlpg)
 				local_flush_tlb();
-			else
-				__flush_tlb_one(f->flush_va);
+			else if (!f->flush_end)
+				__flush_tlb_single(f->flush_start);
+			else {
+				unsigned long addr;
+				addr = f->flush_start;
+				while (addr < f->flush_end) {
+					__flush_tlb_single(addr);
+					addr += PAGE_SIZE;
+				}
+			}
 		} else
 			leave_mm(cpu);
 	}
@@ -172,7 +182,8 @@ out:
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
-				 struct mm_struct *mm, unsigned long va)
+				 struct mm_struct *mm, unsigned long start,
+				 unsigned long end)
 {
 	unsigned int sender;
 	union smp_flush_state *f;
@@ -185,7 +196,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 		raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
-	f->flush_va = va;
+	f->flush_start = start;
+	f->flush_end = end;
 	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
 		/*
 		 * We have to send the IPI only to
@@ -199,24 +211,26 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	}
 
 	f->flush_mm = NULL;
-	f->flush_va = 0;
+	f->flush_start = 0;
+	f->flush_end = 0;
 	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
 		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
-			     struct mm_struct *mm, unsigned long va)
+				 struct mm_struct *mm, unsigned long start,
+				 unsigned long end)
 {
 	if (is_uv_system()) {
 		unsigned int cpu;
 
 		cpu = smp_processor_id();
-		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
+		cpumask = uv_flush_tlb_others(cpumask, mm, start, end, cpu);
 		if (cpumask)
-			flush_tlb_others_ipi(cpumask, mm, va);
+			flush_tlb_others_ipi(cpumask, mm, start, end);
 		return;
 	}
-	flush_tlb_others_ipi(cpumask, mm, va);
+	flush_tlb_others_ipi(cpumask, mm, start, end);
 }
 
 static void __cpuinit calculate_tlb_offset(void)
@@ -282,7 +296,7 @@ void flush_tlb_current_task(void)
 
 	local_flush_tlb();
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), mm, TLB_FLUSH_ALL);
+		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
@@ -297,12 +311,63 @@ void flush_tlb_mm(struct mm_struct *mm)
 			leave_mm(smp_processor_id());
 	}
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), mm, TLB_FLUSH_ALL);
+		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
+
+	preempt_enable();
+}
+
+#define FLUSHALL_BAR	16
+
+void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	struct mm_struct *mm;
+
+	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
+		flush_tlb_mm(vma->vm_mm);
+		return;
+	}
+
+	preempt_disable();
+	mm = vma->vm_mm;
+	if (current->active_mm == mm) {
+		if (current->mm) {
+			unsigned long addr, vmflag = vma->vm_flags;
+			unsigned act_entries, tlb_entries = 0;
+
+			if (vmflag & VM_EXEC)
+				tlb_entries = tlb_lli_4k[ENTRIES];
+			else
+				tlb_entries = tlb_lld_4k[ENTRIES];
+
+			act_entries = tlb_entries > mm->total_vm ?
+					mm->total_vm : tlb_entries;
 
+			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
+				local_flush_tlb();
+			else {
+				for (addr = start; addr < end;
+						addr += PAGE_SIZE)
+					__flush_tlb_single(addr);
+
+				if (cpumask_any_but(mm_cpumask(mm),
+					smp_processor_id()) < nr_cpu_ids)
+					flush_tlb_others(mm_cpumask(mm), mm,
+								start, end);
+				preempt_enable();
+				return;
+			}
+		} else {
+			leave_mm(smp_processor_id());
+		}
+	}
+	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
+
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long start)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
@@ -310,13 +375,13 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 
 	if (current->active_mm == mm) {
 		if (current->mm)
-			__flush_tlb_one(va);
+			__flush_tlb_one(start);
 		else
 			leave_mm(smp_processor_id());
 	}
 
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), mm, va);
+		flush_tlb_others(mm_cpumask(mm), mm, start, 0UL);
 
 	preempt_enable();
 }
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 59880af..f1bef8e 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1068,8 +1068,8 @@ static int set_distrib_bits(struct cpumask *flush_mask, struct bau_control *bcp,
  * done.  The returned pointer is valid till preemption is re-enabled.
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
-				struct mm_struct *mm, unsigned long va,
-				unsigned int cpu)
+				struct mm_struct *mm, unsigned long start,
+				unsigned end, unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
@@ -1112,7 +1112,7 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = va;
+	bau_desc->payload.address = start;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3a73785..39ed567 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1244,7 +1244,8 @@ static void xen_flush_tlb_single(unsigned long addr)
 }
 
 static void xen_flush_tlb_others(const struct cpumask *cpus,
-				 struct mm_struct *mm, unsigned long va)
+				 struct mm_struct *mm, unsigned long start,
+				 unsigned long end)
 {
 	struct {
 		struct mmuext_op op;
@@ -1256,7 +1257,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	} *args;
 	struct multicall_space mcs;
 
-	trace_xen_mmu_flush_tlb_others(cpus, mm, va);
+	trace_xen_mmu_flush_tlb_others(cpus, mm, start, end);
 
 	if (cpumask_empty(cpus))
 		return;		/* nothing to do */
@@ -1269,11 +1270,10 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
 
-	if (va == TLB_FLUSH_ALL) {
-		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
-	} else {
+	args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
+	if (start != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
 		args->op.cmd = MMUEXT_INVLPG_MULTI;
-		args->op.arg1.linear_addr = va;
+		args->op.arg1.linear_addr = start;
 	}
 
 	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 92f1a79..15ba03b 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -397,18 +397,20 @@ TRACE_EVENT(xen_mmu_flush_tlb_single,
 
 TRACE_EVENT(xen_mmu_flush_tlb_others,
 	    TP_PROTO(const struct cpumask *cpus, struct mm_struct *mm,
-		     unsigned long addr),
-	    TP_ARGS(cpus, mm, addr),
+		     unsigned long addr, unsigned long end),
+	    TP_ARGS(cpus, mm, addr, end),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ncpus)
 		    __field(struct mm_struct *, mm)
 		    __field(unsigned long, addr)
+		    __field(unsigned long, end)
 		    ),
 	    TP_fast_assign(__entry->ncpus = cpumask_weight(cpus);
 			   __entry->mm = mm;
-			   __entry->addr = addr),
-	    TP_printk("ncpus %d mm %p addr %lx",
-		      __entry->ncpus, __entry->mm, __entry->addr)
+			   __entry->addr = addr,
+			   __entry->end = end),
+	    TP_printk("ncpus %d mm %p addr %lx, end %lx",
+		      __entry->ncpus, __entry->mm, __entry->addr, __entry->end)
 	);
 
 TRACE_EVENT(xen_mmu_write_cr3,
-- 
1.7.5.4


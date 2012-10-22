Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2JVKgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:36:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41925 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2JVKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:36:48 -0400
Date: Mon, 22 Oct 2012 12:36:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:numa/core] sched/numa/mm: Improve migration
Message-ID: <20121022103641.GB11607@gmail.com>
References: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
 <20121022075857.GA2198@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022075857.GA2198@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> On Thu, Oct 18, 2012 at 10:05:39AM -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  713f937655c4b15131b5a0eae4610918a4febe17
> > Gitweb:     http://git.kernel.org/tip/713f937655c4b15131b5a0eae4610918a4febe17
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Fri, 12 Oct 2012 19:30:14 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Mon, 15 Oct 2012 14:18:40 +0200
> > 
> > sched/numa/mm: Improve migration
> > 
> > Add THP migration. Extend task_numa_fault() to absorb THP faults.
> > 
> > [ Would be nice if the gents on Cc: expressed their opinion about
> >   this change. A missing detail might be cgroup page accounting,
> >   plus the fact that some architectures might cache PMD_NONE pmds
> >   in their TLBs, needing some extra TLB magic beyond what we already
> >   do here? ]
> > 
> 
> I'm travelling for a conference at the moment so will not get 
> the chance to properly review this until I get back. Is there 
> any plan to post the schednuma patches to linux-mm so the full 
> series can be reviewed? I can extract the patches from -tip 
> when I get back but it's still less than ideal from a review 
> standpoint.

Sure, and I'd suggest to rather (re-)post individual MM patches 
that you find interesting than sending out a 50+ patch series.

I've also attached below the combo patch, against current 
-linus, this shows all the mm/ changes in their totality.

> Superficially, the patch looks ok but as I lack context on 
> what the rest of schednuma looks like I cannot be sure so I'm 
> not going to ack it. Basically this is very similar to 
> __unmap_and_move except it doesn't deal with migration PTEs -- 
> presumably because the PTE is PROT_NONE so it gets queued up 
> behind it. There is a downside of that. With migration PTEs, 
> faults during migration will wait on the PTE. With this 
> approach, I think multiple faults will alloc a hugepage, 
> realise the ptes are no longer the same and back off. It 
> should still work but it's potentially more expensive. Was 
> that considered? Is it deliberate? If so, why?
> 
> It also feels like the migration part should have been a 
> helper function called unmap_and_move_thp() in migrate.c 
> instead of being buried in mm/huge_memory.c

Yeah. Peter is looking at this right now and trying to untangle 
it a bit more. You might want to wait for that to be complete 
before reviewing the end result.

Thanks,

	Ingo

-------------->
 CREDITS                                  |   1 +
 Documentation/scheduler/numa-problem.txt | 230 +++++++++++++
 arch/mips/include/asm/pgtable.h          |   2 +
 arch/s390/include/asm/pgtable.h          |  13 +
 arch/sh/mm/Kconfig                       |   1 +
 arch/x86/include/asm/pgtable.h           |   7 +
 arch/x86/mm/gup.c                        |  23 +-
 arch/x86/mm/pgtable.c                    |  17 +-
 drivers/base/node.c                      |   2 +-
 include/asm-generic/pgtable.h            |   4 +
 include/linux/huge_mm.h                  |  19 ++
 include/linux/init_task.h                |   8 +
 include/linux/mempolicy.h                |  11 +-
 include/linux/migrate.h                  |   7 +
 include/linux/migrate_mode.h             |   3 +
 include/linux/mm.h                       | 122 ++++---
 include/linux/mm_types.h                 |  10 +
 include/linux/mmzone.h                   |  15 +-
 include/linux/page-flags-layout.h        |  83 +++++
 include/linux/sched.h                    |  43 ++-
 include/uapi/linux/mempolicy.h           |  17 +-
 init/Kconfig                             |  14 +
 kernel/sched/core.c                      |  77 ++++-
 kernel/sched/debug.c                     |   3 +
 kernel/sched/fair.c                      | 566 +++++++++++++++++++++++++++++--
 kernel/sched/features.h                  |  14 +
 kernel/sched/sched.h                     |  36 ++
 kernel/sysctl.c                          |  34 +-
 mm/huge_memory.c                         | 254 +++++++++++---
 mm/memory.c                              | 158 ++++++++-
 mm/mempolicy.c                           | 273 +++++++++++----
 mm/migrate.c                             |  89 ++++-
 mm/mprotect.c                            |  31 +-
 mm/pgtable-generic.c                     |   3 +-
 mm/vmstat.c                              |   1 -
 35 files changed, 1929 insertions(+), 262 deletions(-)

diff --git a/CREDITS b/CREDITS
index d8fe12a..b4cdc8f 100644
--- a/CREDITS
+++ b/CREDITS
@@ -125,6 +125,7 @@ D: Author of pscan that helps to fix lp/parport bugs
 D: Author of lil (Linux Interrupt Latency benchmark)
 D: Fixed the shm swap deallocation at swapoff time (try_to_unuse message)
 D: VM hacker
+D: NUMA task placement
 D: Various other kernel hacks
 S: Imola 40026
 S: Italy
diff --git a/Documentation/scheduler/numa-problem.txt b/Documentation/scheduler/numa-problem.txt
new file mode 100644
index 0000000..a5d2fee
--- /dev/null
+++ b/Documentation/scheduler/numa-problem.txt
@@ -0,0 +1,230 @@
+
+
+Effective NUMA scheduling problem statement, described formally:
+
+ * minimize interconnect traffic
+
+For each task 't_i' we have memory, this memory can be spread over multiple
+physical nodes, let us denote this as: 'p_i,k', the memory task 't_i' has on
+node 'k' in [pages].  
+
+If a task shares memory with another task let us denote this as:
+'s_i,k', the memory shared between tasks including 't_i' residing on node
+'k'.
+
+Let 'M' be the distribution that governs all 'p' and 's', ie. the page placement.
+
+Similarly, lets define 'fp_i,k' and 'fs_i,k' resp. as the (average) usage
+frequency over those memory regions [1/s] such that the product gives an
+(average) bandwidth 'bp' and 'bs' in [pages/s].
+
+(note: multiple tasks sharing memory naturally avoid duplicat accounting
+       because each task will have its own access frequency 'fs')
+
+(pjt: I think this frequency is more numerically consistent if you explicitly 
+      restrict p/s above to be the working-set. (It also makes explicit the 
+      requirement for <C0,M0> to change about a change in the working set.)
+
+      Doing this does have the nice property that it lets you use your frequency
+      measurement as a weak-ordering for the benefit a task would receive when
+      we can't fit everything.
+
+      e.g. task1 has working set 10mb, f=90%
+           task2 has working set 90mb, f=10%
+
+      Both are using 9mb/s of bandwidth, but we'd expect a much larger benefit
+      from task1 being on the right node than task2. )
+
+Let 'C' map every task 't_i' to a cpu 'c_i' and its corresponding node 'n_i':
+
+  C: t_i -> {c_i, n_i}
+
+This gives us the total interconnect traffic between nodes 'k' and 'l',
+'T_k,l', as:
+
+  T_k,l = \Sum_i bp_i,l + bs_i,l + \Sum bp_j,k + bs_j,k where n_i == k, n_j == l
+
+And our goal is to obtain C0 and M0 such that:
+
+  T_k,l(C0, M0) =< T_k,l(C, M) for all C, M where k != l
+
+(note: we could introduce 'nc(k,l)' as the cost function of accessing memory
+       on node 'l' from node 'k', this would be useful for bigger NUMA systems
+
+ pjt: I agree nice to have, but intuition suggests diminishing returns on more
+      usual systems given factors like things like Haswell's enormous 35mb l3
+      cache and QPI being able to do a direct fetch.)
+
+(note: do we need a limit on the total memory per node?)
+
+
+ * fairness
+
+For each task 't_i' we have a weight 'w_i' (related to nice), and each cpu
+'c_n' has a compute capacity 'P_n', again, using our map 'C' we can formulate a
+load 'L_n':
+
+  L_n = 1/P_n * \Sum_i w_i for all c_i = n
+
+using that we can formulate a load difference between CPUs
+
+  L_n,m = | L_n - L_m |
+
+Which allows us to state the fairness goal like:
+
+  L_n,m(C0) =< L_n,m(C) for all C, n != m
+
+(pjt: It can also be usefully stated that, having converged at C0:
+
+   | L_n(C0) - L_m(C0) | <= 4/3 * | G_n( U(t_i, t_j) ) - G_m( U(t_i, t_j) ) |
+
+      Where G_n,m is the greedy partition of tasks between L_n and L_m. This is
+      the "worst" partition we should accept; but having it gives us a useful 
+      bound on how much we can reasonably adjust L_n/L_m at a Pareto point to 
+      favor T_n,m. )
+
+Together they give us the complete multi-objective optimization problem:
+
+  min_C,M [ L_n,m(C), T_k,l(C,M) ]
+
+
+
+Notes:
+
+ - the memory bandwidth problem is very much an inter-process problem, in
+   particular there is no such concept as a process in the above problem.
+
+ - the naive solution would completely prefer fairness over interconnect
+   traffic, the more complicated solution could pick another Pareto point using
+   an aggregate objective function such that we balance the loss of work
+   efficiency against the gain of running, we'd want to more or less suggest
+   there to be a fixed bound on the error from the Pareto line for any
+   such solution.
+
+References:
+
+  http://en.wikipedia.org/wiki/Mathematical_optimization
+  http://en.wikipedia.org/wiki/Multi-objective_optimization
+
+
+* warning, significant hand-waving ahead, improvements welcome *
+
+
+Partial solutions / approximations:
+
+ 1) have task node placement be a pure preference from the 'fairness' pov.
+
+This means we always prefer fairness over interconnect bandwidth. This reduces
+the problem to:
+
+  min_C,M [ T_k,l(C,M) ]
+
+ 2a) migrate memory towards 'n_i' (the task's node).
+
+This creates memory movement such that 'p_i,k for k != n_i' becomes 0 -- 
+provided 'n_i' stays stable enough and there's sufficient memory (looks like
+we might need memory limits for this).
+
+This does however not provide us with any 's_i' (shared) information. It does
+however remove 'M' since it defines memory placement in terms of task
+placement.
+
+XXX properties of this M vs a potential optimal
+
+ 2b) migrate memory towards 'n_i' using 2 samples.
+
+This separates pages into those that will migrate and those that will not due
+to the two samples not matching. We could consider the first to be of 'p_i'
+(private) and the second to be of 's_i' (shared).
+
+This interpretation can be motivated by the previously observed property that
+'p_i,k for k != n_i' should become 0 under sufficient memory, leaving only
+'s_i' (shared). (here we loose the need for memory limits again, since it
+becomes indistinguishable from shared).
+
+XXX include the statistical babble on double sampling somewhere near
+
+This reduces the problem further; we loose 'M' as per 2a, it further reduces
+the 'T_k,l' (interconnect traffic) term to only include shared (since per the
+above all private will be local):
+
+  T_k,l = \Sum_i bs_i,l for every n_i = k, l != k
+
+[ more or less matches the state of sched/numa and describes its remaining
+  problems and assumptions. It should work well for tasks without significant
+  shared memory usage between tasks. ]
+
+Possible future directions:
+
+Motivated by the form of 'T_k,l', try and obtain each term of the sum, so we
+can evaluate it;
+
+ 3a) add per-task per node counters
+
+At fault time, count the number of pages the task faults on for each node.
+This should give an approximation of 'p_i' for the local node and 's_i,k' for
+all remote nodes.
+
+While these numbers provide pages per scan, and so have the unit [pages/s] they
+don't count repeat access and thus aren't actually representable for our
+bandwidth numberes.
+
+ 3b) additional frequency term
+
+Additionally (or instead if it turns out we don't need the raw 'p' and 's' 
+numbers) we can approximate the repeat accesses by using the time since marking
+the pages as indication of the access frequency.
+
+Let 'I' be the interval of marking pages and 'e' the elapsed time since the
+last marking, then we could estimate the number of accesses 'a' as 'a = I / e'.
+If we then increment the node counters using 'a' instead of 1 we might get
+a better estimate of bandwidth terms.
+
+ 3c) additional averaging; can be applied on top of either a/b.
+
+[ Rik argues that decaying averages on 3a might be sufficient for bandwidth since
+  the decaying avg includes the old accesses and therefore has a measure of repeat
+  accesses.
+
+  Rik also argued that the sample frequency is too low to get accurate access
+  frequency measurements, I'm not entirely convinced, event at low sample 
+  frequencies the avg elapsed time 'e' over multiple samples should still
+  give us a fair approximation of the avg access frequency 'a'.
+
+  So doing both b&c has a fair chance of working and allowing us to distinguish
+  between important and less important memory accesses.
+
+  Experimentation has shown no benefit from the added frequency term so far. ]
+
+This will give us 'bp_i' and 'bs_i,k' so that we can approximately compute
+'T_k,l' Our optimization problem now reads:
+
+  min_C [ \Sum_i bs_i,l for every n_i = k, l != k ]
+
+And includes only shared terms, this makes sense since all task private memory
+will become local as per 2.
+
+This suggests that if there is significant shared memory, we should try and
+move towards it.
+
+ 4) move towards where 'most' memory is
+
+The simplest significance test is comparing the biggest shared 's_i,k' against
+the private 'p_i'. If we have more shared than private, move towards it.
+
+This effectively makes us move towards where most our memory is and forms a
+feed-back loop with 2. We migrate memory towards us and we migrate towards
+where 'most' memory is.
+
+(Note: even if there were two tasks fully trashing the same shared memory, it
+       is very rare for there to be an 50/50 split in memory, lacking a perfect
+       split, the small will move towards the larger. In case of the perfect
+       split, we'll tie-break towards the lower node number.)
+
+ 5) 'throttle' 4's node placement
+
+Since per 2b our 's_i,k' and 'p_i' require at least two scans to 'stabilize'
+and show representative numbers, we should limit node-migration to not be
+faster than this.
+
+ n) poke holes in previous that require more stuff and describe it.
diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index c02158b..bbe4cda 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -89,6 +89,8 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 extern void paging_init(void);
 
+#define pmd_pgprot(x)		__pgprot(pmd_val(x) & ~_PAGE_CHG_MASK)
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index dd647c9..098fc5a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1240,6 +1240,19 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	*pmdp = entry;
 }
 
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	pgprot_t prot = PAGE_RW;
+
+	if (pmd_val(pmd) & _SEGMENT_ENTRY_RO) {
+		if (pmd_val(pmd) & _SEGMENT_ENTRY_INV)
+			prot = PAGE_NONE;
+		else
+			prot = PAGE_RO;
+	}
+	return prot;
+}
+
 static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
 {
 	unsigned long pgprot_pmd = 0;
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index cb8f992..1210cc7 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -111,6 +111,7 @@ config VSYSCALL
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
 	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
+	select EMBEDDED_NUMA
 	default n
 	help
 	  Some SH systems have many various memories scattered around
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a1f780d..ecf64b4 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -349,6 +349,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 }
 
 #define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
+#define pmd_pgprot(x) __pgprot(pmd_val(x) & ~_HPAGE_CHG_MASK)
 
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
@@ -407,6 +408,12 @@ static inline int pte_present(pte_t a)
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
+#define __HAVE_ARCH_PTE_ACCESSIBLE
+static inline int pte_accessible(pte_t a)
+{
+	return pte_flags(a) & _PAGE_PRESENT;
+}
+
 static inline int pte_hidden(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_HIDDEN;
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..6dc9921 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -150,7 +150,13 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 
 	pmdp = pmd_offset(&pud, addr);
 	do {
-		pmd_t pmd = *pmdp;
+		/*
+		 * With THP and hugetlbfs the pmd can change from
+		 * under us and it can be cleared as well by the TLB
+		 * shootdown, so read it with ACCESS_ONCE to do all
+		 * computations on the same sampling.
+		 */
+		pmd_t pmd = ACCESS_ONCE(*pmdp);
 
 		next = pmd_addr_end(addr, end);
 		/*
@@ -220,7 +226,13 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 
 	pudp = pud_offset(&pgd, addr);
 	do {
-		pud_t pud = *pudp;
+		/*
+		 * With hugetlbfs giga pages the pud can change from
+		 * under us and it can be cleared as well by the TLB
+		 * shootdown, so read it with ACCESS_ONCE to do all
+		 * computations on the same sampling.
+		 */
+		pud_t pud = ACCESS_ONCE(*pudp);
 
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
@@ -280,7 +292,12 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
-		pgd_t pgd = *pgdp;
+		/*
+		 * The pgd could be cleared by the TLB shootdown from
+		 * under us so read it with ACCESS_ONCE to do all
+		 * computations on the same sampling.
+		 */
+		pgd_t pgd = ACCESS_ONCE(*pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..fc82cf1 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -306,11 +306,26 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 			  pte_t entry, int dirty)
 {
 	int changed = !pte_same(*ptep, entry);
+	/*
+	 * If the page used to be inaccessible (_PAGE_PROTNONE), or
+	 * this call upgrades the access permissions on the same page,
+	 * it is safe to skip the remote TLB flush.
+	 */
+	bool flush_remote = false;
+	if (!pte_accessible(*ptep))
+		flush_remote = false;
+	else if (pte_pfn(*ptep) != pte_pfn(entry) ||
+			(pte_write(*ptep) && !pte_write(entry)) ||
+			(pte_exec(*ptep) && !pte_exec(entry)))
+		flush_remote = true;
 
 	if (changed && dirty) {
 		*ptep = entry;
 		pte_update_defer(vma->vm_mm, address, ptep);
-		flush_tlb_page(vma, address);
+		if (flush_remote)
+			flush_tlb_page(vma, address);
+		else
+			__flush_tlb_one(address);
 	}
 
 	return changed;
diff --git a/drivers/base/node.c b/drivers/base/node.c
index af1a177..ef51157 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -169,7 +169,7 @@ static ssize_t node_read_numastat(struct device *dev,
 		       node_page_state(dev->id, NUMA_HIT),
 		       node_page_state(dev->id, NUMA_MISS),
 		       node_page_state(dev->id, NUMA_FOREIGN),
-		       node_page_state(dev->id, NUMA_INTERLEAVE_HIT),
+		       0UL,
 		       node_page_state(dev->id, NUMA_LOCAL),
 		       node_page_state(dev->id, NUMA_OTHER));
 }
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index b36ce40..8ce9d4e 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -219,6 +219,10 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef __HAVE_ARCH_PTE_ACCESSIBLE
+#define pte_accessible(pte)		pte_present(pte)
+#endif
+
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b31cb7d..4f0f948 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -159,6 +159,13 @@ static inline struct page *compound_trans_head(struct page *page)
 	}
 	return page;
 }
+
+extern bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd);
+
+extern void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd,
+				  unsigned int flags, pmd_t orig_pmd);
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -195,6 +202,18 @@ static inline int pmd_trans_huge_lock(pmd_t *pmd,
 {
 	return 0;
 }
+
+static inline bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd)
+{
+	return false;
+}
+
+static inline void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd,
+				  unsigned int flags, pmd_t orig_pmd)
+{
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6d087c5..b4405b6 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -143,6 +143,13 @@ extern struct task_group root_task_group;
 
 #define INIT_TASK_COMM "swapper"
 
+#ifdef CONFIG_SCHED_NUMA
+# define INIT_TASK_NUMA(tsk)						\
+	.node = -1,
+#else
+# define INIT_TASK_NUMA(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -210,6 +217,7 @@ extern struct task_group root_task_group;
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ							\
+	INIT_TASK_NUMA(tsk)						\
 }
 
 
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index e5ccb9d..d6b1ea1 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -5,7 +5,6 @@
 #ifndef _LINUX_MEMPOLICY_H
 #define _LINUX_MEMPOLICY_H 1
 
-
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
@@ -198,7 +197,9 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 	return 1;
 }
 
-#else
+extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
+
+#else /* CONFIG_NUMA */
 
 struct mempolicy {};
 
@@ -323,5 +324,11 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 	return 0;
 }
 
+static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
+				 unsigned long address)
+{
+	return -1; /* no node preference */
+}
+
 #endif /* CONFIG_NUMA */
 #endif
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index ce7e667..9a5afea 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -30,6 +30,7 @@ extern int migrate_vmas(struct mm_struct *mm,
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
+extern int migrate_misplaced_page(struct page *page, int node);
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
@@ -63,5 +64,11 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 #define migrate_page NULL
 #define fail_migrate_page NULL
 
+static inline
+int migrate_misplaced_page(struct page *page, int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_MIGRATION */
+
 #endif /* _LINUX_MIGRATE_H */
diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index ebf3d89..40b37dc 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -6,11 +6,14 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
+ * MIGRATE_FAULT called from the fault path to migrate-on-fault for mempolicy
+ *	this path has an extra reference count
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_FAULT,
 };
 
 #endif		/* MIGRATE_MODE_H_INCLUDED */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa06804..54b3094 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -164,6 +164,19 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_TRIED	0x40	/* second try */
 
 /*
+ * Some architectures (such as x86) may need to preserve certain pgprot
+ * bits, without complicating generic pgprot code.
+ *
+ * Most architectures don't care:
+ */
+#ifndef pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	return newprot;
+}
+#endif
+
+/*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
@@ -581,50 +594,11 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
  * sets it, so none of the operations on it need to be atomic.
  */
 
-
-/*
- * page->flags layout:
- *
- * There are three possibilities for how page->flags get
- * laid out.  The first is for the normal case, without
- * sparsemem.  The second is for sparsemem when there is
- * plenty of space for node and section.  The last is when
- * we have run out of space and have to fall back to an
- * alternate (slower) way of determining the node.
- *
- * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE | ... | FLAGS |
- * classic sparse with space for node:| SECTION | NODE | ZONE | ... | FLAGS |
- * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
- */
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-#define SECTIONS_WIDTH		SECTIONS_SHIFT
-#else
-#define SECTIONS_WIDTH		0
-#endif
-
-#define ZONES_WIDTH		ZONES_SHIFT
-
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
-#define NODES_WIDTH		NODES_SHIFT
-#else
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-#error "Vmemmap: No space for nodes field in page flags"
-#endif
-#define NODES_WIDTH		0
-#endif
-
-/* Page flags: | [SECTION] | [NODE] | ZONE | ... | FLAGS | */
+/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NID] | ... | FLAGS | */
 #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
 #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
-
-/*
- * We are going to use the flags for the page to node mapping if its in
- * there.  This includes the case where there is no node, so it is implicit.
- */
-#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
-#define NODE_NOT_IN_PAGE_FLAGS
-#endif
+#define LAST_NID_PGOFF		(ZONES_PGOFF - LAST_NID_WIDTH)
 
 /*
  * Define the bit shifts to access each section.  For non-existent
@@ -634,6 +608,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
+#define LAST_NID_PGSHIFT	(LAST_NID_PGOFF * (LAST_NID_WIDTH != 0))
 
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
 #ifdef NODE_NOT_IN_PAGE_FLAGS
@@ -655,6 +630,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
+#define LAST_NID_MASK		((1UL << LAST_NID_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
@@ -693,6 +669,51 @@ static inline int page_to_nid(const struct page *page)
 }
 #endif
 
+#ifdef CONFIG_SCHED_NUMA
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	return xchg(&page->_last_nid, nid);
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return page->_last_nid;
+}
+#else
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	unsigned long old_flags, flags;
+	int last_nid;
+
+	do {
+		old_flags = flags = page->flags;
+		last_nid = (flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+
+		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+
+	return last_nid;
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+}
+#endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
+#else /* CONFIG_SCHED_NUMA */
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	return page_to_nid(page);
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return page_to_nid(page);
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 static inline struct zone *page_zone(const struct page *page)
 {
 	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
@@ -1078,6 +1099,9 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
 extern unsigned long do_mremap(unsigned long addr,
 			       unsigned long old_len, unsigned long new_len,
 			       unsigned long flags, unsigned long new_addr);
+extern void change_protection(struct vm_area_struct *vma, unsigned long start,
+			      unsigned long end, pgprot_t newprot,
+			      int dirty_accountable);
 extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
@@ -1548,6 +1572,21 @@ static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
 }
 #endif
 
+static inline pgprot_t vma_prot_none(struct vm_area_struct *vma)
+{
+	/*
+	 * obtain PROT_NONE by removing READ|WRITE|EXEC privs
+	 */
+	vm_flags_t vmflags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
+	return pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vmflags));
+}
+
+static inline void
+change_prot_none(struct vm_area_struct *vma, unsigned long start, unsigned long end)
+{
+	change_protection(vma, start, end, vma_prot_none(vma), 0);
+}
+
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
@@ -1569,6 +1608,7 @@ struct page *follow_page(struct vm_area_struct *, unsigned long address,
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
+#define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 31f8a3a..01c1d04 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
 #include <linux/uprobes.h>
+#include <linux/page-flags-layout.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -175,6 +176,10 @@ struct page {
 	 */
 	void *shadow;
 #endif
+
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+	int _last_nid;
+#endif
 }
 /*
  * The struct page can be forced to be double word aligned so that atomic ops
@@ -398,6 +403,11 @@ struct mm_struct {
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	struct cpumask cpumask_allocation;
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long numa_next_scan;
+	unsigned long numa_scan_offset;
+	int numa_scan_seq;
+#endif
 	struct uprobes_state uprobes_state;
 };
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 50aaca8..c9fcd8f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -15,7 +15,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
-#include <generated/bounds.h>
+#include <linux/page-flags-layout.h>
 #include <linux/atomic.h>
 #include <asm/page.h>
 
@@ -137,7 +137,6 @@ enum zone_stat_item {
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
 	NUMA_FOREIGN,		/* was intended here, hit elsewhere */
-	NUMA_INTERLEAVE_HIT,	/* interleaver preferred this zone */
 	NUMA_LOCAL,		/* allocation from local node */
 	NUMA_OTHER,		/* allocation from other node */
 #endif
@@ -318,16 +317,6 @@ enum zone_type {
  * match the requested limits. See gfp_zone() in include/linux/gfp.h
  */
 
-#if MAX_NR_ZONES < 2
-#define ZONES_SHIFT 0
-#elif MAX_NR_ZONES <= 2
-#define ZONES_SHIFT 1
-#elif MAX_NR_ZONES <= 4
-#define ZONES_SHIFT 2
-#else
-#error ZONES_SHIFT -- too many zones configured adjust calculation
-#endif
-
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -1030,8 +1019,6 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
-#define SECTIONS_SHIFT		(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
-
 #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
 #define PFN_SECTION_SHIFT	(SECTION_SIZE_BITS - PAGE_SHIFT)
 
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
new file mode 100644
index 0000000..586ddb6
--- /dev/null
+++ b/include/linux/page-flags-layout.h
@@ -0,0 +1,83 @@
+#ifndef _LINUX_PAGE_FLAGS_LAYOUT
+#define _LINUX_PAGE_FLAGS_LAYOUT
+
+#include <linux/numa.h>
+#include <generated/bounds.h>
+
+#if MAX_NR_ZONES < 2
+#define ZONES_SHIFT 0
+#elif MAX_NR_ZONES <= 2
+#define ZONES_SHIFT 1
+#elif MAX_NR_ZONES <= 4
+#define ZONES_SHIFT 2
+#else
+#error ZONES_SHIFT -- too many zones configured adjust calculation
+#endif
+
+#ifdef CONFIG_SPARSEMEM
+#include <asm/sparsemem.h>
+
+/* 
+ * SECTION_SHIFT    		#bits space required to store a section #
+ */
+#define SECTIONS_SHIFT         (MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
+#endif
+
+/*
+ * page->flags layout:
+ *
+ * There are five possibilities for how page->flags get laid out.  The first
+ * (and second) is for the normal case, without sparsemem. The third is for
+ * sparsemem when there is plenty of space for node and section. The last is
+ * when we have run out of space and have to fall back to an alternate (slower)
+ * way of determining the node.
+ *
+ * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE |            ... | FLAGS |
+ *     "      plus space for last_nid:|       NODE     | ZONE | LAST_NID | ... | FLAGS |
+ * classic sparse with space for node:| SECTION | NODE | ZONE |            ... | FLAGS |
+ *     "      plus space for last_nid:| SECTION | NODE | ZONE | LAST_NID | ... | FLAGS |
+ * classic sparse no space for node:  | SECTION |     ZONE    |            ... | FLAGS |
+ */
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+
+#define SECTIONS_WIDTH		SECTIONS_SHIFT
+#else
+#define SECTIONS_WIDTH		0
+#endif
+
+#define ZONES_WIDTH		ZONES_SHIFT
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define NODES_WIDTH		NODES_SHIFT
+#else
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#error "Vmemmap: No space for nodes field in page flags"
+#endif
+#define NODES_WIDTH		0
+#endif
+
+#ifdef CONFIG_SCHED_NUMA
+#define LAST_NID_SHIFT	NODES_SHIFT
+#else
+#define LAST_NID_SHIFT	0
+#endif
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_NID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define LAST_NID_WIDTH	LAST_NID_SHIFT
+#else
+#define LAST_NID_WIDTH	0
+#endif
+
+/*
+ * We are going to use the flags for the page to node mapping if its in
+ * there.  This includes the case where there is no node, so it is implicit.
+ */
+#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#define NODE_NOT_IN_PAGE_FLAGS
+#endif
+
+#if defined(CONFIG_SCHED_NUMA) && LAST_NID_WIDTH == 0
+#define LAST_NID_NOT_IN_PAGE_FLAGS
+#endif
+
+#endif /* _LINUX_PAGE_FLAGS_LAYOUT */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..63c011e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -823,6 +823,7 @@ enum cpu_idle_type {
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
+#define SD_NUMA			0x4000	/* cross-node balancing */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
@@ -1479,6 +1480,17 @@ struct task_struct {
 	short il_next;
 	short pref_node_fork;
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	int node;			/* task home node   */
+	int numa_scan_seq;
+	int numa_migrate_seq;
+	unsigned int numa_task_period;
+	u64 node_stamp;			/* migration stamp  */
+	unsigned long numa_contrib;
+	unsigned long *numa_faults;
+	struct callback_head numa_work;
+#endif /* CONFIG_SCHED_NUMA */
+
 	struct rcu_head rcu;
 
 	/*
@@ -1553,6 +1565,24 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+#ifdef CONFIG_SCHED_NUMA
+static inline int tsk_home_node(struct task_struct *p)
+{
+	return p->node;
+}
+
+extern void task_numa_fault(int node, int pages);
+#else
+static inline int tsk_home_node(struct task_struct *p)
+{
+	return -1;
+}
+
+static inline void task_numa_fault(int node, int pages)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
@@ -1990,6 +2020,11 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
+extern unsigned int sysctl_sched_numa_task_period_min;
+extern unsigned int sysctl_sched_numa_task_period_max;
+extern unsigned int sysctl_sched_numa_scan_size;
+extern unsigned int sysctl_sched_numa_settle_count;
+
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
@@ -2000,18 +2035,17 @@ extern unsigned int sysctl_sched_shares_window;
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos);
-#endif
-#ifdef CONFIG_SCHED_DEBUG
+
 static inline unsigned int get_sysctl_timer_migration(void)
 {
 	return sysctl_timer_migration;
 }
-#else
+#else /* CONFIG_SCHED_DEBUG */
 static inline unsigned int get_sysctl_timer_migration(void)
 {
 	return 1;
 }
-#endif
+#endif /* CONFIG_SCHED_DEBUG */
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
@@ -2072,6 +2106,7 @@ extern int sched_setscheduler(struct task_struct *, int,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern void sched_setnode(struct task_struct *p, int node);
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 23e62e0..a2bcd04 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -20,6 +20,8 @@ enum {
 	MPOL_PREFERRED,
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
+	MPOL_LOCAL,
+	MPOL_NOOP,		/* retain existing policy for range */
 	MPOL_MAX,	/* always last member of enum */
 };
 
@@ -47,9 +49,16 @@ enum mpol_rebind_step {
 
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform to mapping */
-#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
-#define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
+#define MPOL_MF_MOVE	 (1<<1)	/* Move pages owned by this process to conform
+				   to policy */
+#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to policy */
+#define MPOL_MF_LAZY	 (1<<3)	/* Modifies '_MOVE:  lazy migrate on fault */
+#define MPOL_MF_INTERNAL (1<<4)	/* Internal flags start here */
+
+#define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
+			 MPOL_MF_MOVE     | 	\
+			 MPOL_MF_MOVE_ALL |	\
+			 MPOL_MF_LAZY)
 
 /*
  * Internal flags that share the struct mempolicy flags word with
@@ -59,6 +68,8 @@ enum mpol_rebind_step {
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
+#define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
+#define MPOL_F_HOME	(1 << 4) /* this is the home-node policy */
 
 
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..c8d1f59 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -696,6 +696,20 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+#
+# For architectures that (ab)use NUMA to represent different memory regions
+# all cpu-local but of different latencies, such as SuperH.
+#
+config EMBEDDED_NUMA
+	bool
+
+config SCHED_NUMA
+	bool "Memory placement aware NUMA scheduler"
+	default n
+	depends on SMP && NUMA && MIGRATION && !EMBEDDED_NUMA
+	help
+	  This option adds support for automatic NUMA aware memory/task placement.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..67221c0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1533,6 +1533,21 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
+
+#ifdef CONFIG_SCHED_NUMA
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
+		p->mm->numa_next_scan = jiffies;
+		p->mm->numa_scan_seq = 0;
+	}
+
+	p->node = -1;
+	p->node_stamp = 0ULL;
+	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
+	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
+	p->numa_faults = NULL;
+	p->numa_task_period = sysctl_sched_numa_task_period_min;
+	p->numa_work.next = &p->numa_work;
+#endif /* CONFIG_SCHED_NUMA */
 }
 
 /*
@@ -1774,6 +1789,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		task_numa_free(prev);
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
@@ -5484,7 +5500,9 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_id);
 
-static void update_top_cache_domain(int cpu)
+DEFINE_PER_CPU(struct sched_domain *, sd_node);
+
+static void update_domain_cache(int cpu)
 {
 	struct sched_domain *sd;
 	int id = cpu;
@@ -5495,6 +5513,15 @@ static void update_top_cache_domain(int cpu)
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_id, cpu) = id;
+
+	for_each_domain(cpu, sd) {
+		if (cpumask_equal(sched_domain_span(sd),
+				  cpumask_of_node(cpu_to_node(cpu))))
+			goto got_node;
+	}
+	sd = NULL;
+got_node:
+	rcu_assign_pointer(per_cpu(sd_node, cpu), sd);
 }
 
 /*
@@ -5537,7 +5564,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
-	update_top_cache_domain(cpu);
+	update_domain_cache(cpu);
 }
 
 /* cpus with isolated domains */
@@ -5959,6 +5986,45 @@ static struct sched_domain_topology_level default_topology[] = {
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#ifdef CONFIG_SCHED_NUMA
+
+/*
+ * Requeues a task ensuring its on the right load-balance list so
+ * that it might get migrated to its new home.
+ *
+ * Since home-node is pure preference there's no hard migrate to force
+ * us anywhere, this also allows us to call this from atomic context if
+ * required.
+ */
+void sched_setnode(struct task_struct *p, int node)
+{
+	unsigned long flags;
+	int on_rq, running;
+	struct rq *rq;
+
+	if (!sched_feat(NUMA_MIGRATION))
+		return;
+
+	rq = task_rq_lock(p, &flags);
+	on_rq = p->on_rq;
+	running = task_current(rq, p);
+
+	if (on_rq)
+		dequeue_task(rq, p, 0);
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
+
+	p->node = node;
+
+	if (running)
+		p->sched_class->set_curr_task(rq);
+	if (on_rq)
+		enqueue_task(rq, p, 0);
+	task_rq_unlock(rq, p, &flags);
+}
+
+#endif /* CONFIG_SCHED_NUMA */
+
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
@@ -6004,6 +6070,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
+					| 1*SD_NUMA
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
@@ -6865,6 +6932,12 @@ void __init sched_init(void)
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
+#ifdef CONFIG_SCHED_NUMA
+		INIT_LIST_HEAD(&rq->offnode_tasks);
+		rq->onnode_running = 0;
+		rq->offnode_running = 0;
+		rq->offnode_weight = 0;
+#endif
 
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..c9a5f75 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -132,6 +132,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	SEQ_printf(m, " %d/%d", p->node, cpu_to_node(task_cpu(p)));
+#endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..9f7406e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -18,6 +18,9 @@
  *
  *  Adaptive scheduling granularity, math enhancements by Peter Zijlstra
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ *  NUMA placement, statistics and algorithm by Andrea Arcangeli,
+ *  CFS balancing changes by Peter Zijlstra. Copyright (C) 2012 Red Hat, Inc.
  */
 
 #include <linux/latencytop.h>
@@ -26,6 +29,9 @@
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/random.h>
+#include <linux/mempolicy.h>
+#include <linux/task_work.h>
 
 #include <trace/events/sched.h>
 
@@ -773,6 +779,243 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /**************************************************
+ * Scheduling class numa methods.
+ *
+ * The purpose of the NUMA bits are to maintain compute (task) and data
+ * (memory) locality. We try and achieve this by making tasks stick to
+ * a particular node (their home node) but if fairness mandates they run
+ * elsewhere for long enough, we let the memory follow them.
+ *
+ * Tasks start out with their home-node unset (-1) this effectively means
+ * they act !NUMA until we've established the task is busy enough to bother
+ * with placement.
+ *
+ * We keep a home-node per task and use periodic fault scans to try and
+ * estalish a task<->page relation. This assumes the task<->page relation is a
+ * compute<->data relation, this is false for things like virt. and n:m
+ * threading solutions but its the best we can do given the information we
+ * have.
+ */
+
+static unsigned long task_h_load(struct task_struct *p);
+
+#ifdef CONFIG_SCHED_NUMA
+static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
+{
+	struct list_head *tasks = &rq->cfs_tasks;
+
+	if (tsk_home_node(p) != cpu_to_node(task_cpu(p))) {
+		p->numa_contrib = task_h_load(p);
+		rq->offnode_weight += p->numa_contrib;
+		rq->offnode_running++;
+		tasks = &rq->offnode_tasks;
+	} else
+		rq->onnode_running++;
+
+	return tasks;
+}
+
+static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
+{
+	if (tsk_home_node(p) != cpu_to_node(task_cpu(p))) {
+		rq->offnode_weight -= p->numa_contrib;
+		rq->offnode_running--;
+	} else
+		rq->onnode_running--;
+}
+
+/*
+ * numa task sample period in ms: 5s
+ */
+unsigned int sysctl_sched_numa_task_period_min = 100;
+unsigned int sysctl_sched_numa_task_period_max = 100*16;
+unsigned int sysctl_sched_numa_scan_size = 256;   /* MB */
+
+/*
+ * Wait for the 2-sample stuff to settle before migrating again
+ */
+unsigned int sysctl_sched_numa_settle_count = 2;
+
+static void task_numa_placement(struct task_struct *p)
+{
+	unsigned long faults, max_faults = 0;
+	int node, max_node = -1;
+	int seq = ACCESS_ONCE(p->mm->numa_scan_seq);
+
+	if (p->numa_scan_seq == seq)
+		return;
+
+	p->numa_scan_seq = seq;
+
+	for (node = 0; node < nr_node_ids; node++) {
+		faults = p->numa_faults[node];
+
+		if (faults > max_faults) {
+			max_faults = faults;
+			max_node = node;
+		}
+
+		p->numa_faults[node] /= 2;
+	}
+
+	if (max_node == -1)
+		return;
+
+	if (p->node != max_node) {
+		p->numa_task_period = sysctl_sched_numa_task_period_min;
+		if (sched_feat(NUMA_SETTLE) &&
+		    (seq - p->numa_migrate_seq) <= (int)sysctl_sched_numa_settle_count)
+			return;
+		p->numa_migrate_seq = seq;
+		sched_setnode(p, max_node);
+	} else {
+		p->numa_task_period = min(sysctl_sched_numa_task_period_max,
+				p->numa_task_period * 2);
+	}
+}
+
+/*
+ * Got a PROT_NONE fault for a page on @node.
+ */
+void task_numa_fault(int node, int pages)
+{
+	struct task_struct *p = current;
+
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(unsigned long) * nr_node_ids;
+
+		p->numa_faults = kzalloc(size, GFP_KERNEL);
+		if (!p->numa_faults)
+			return;
+	}
+
+	task_numa_placement(p);
+
+	p->numa_faults[node] += pages;
+}
+
+/*
+ * The expensive part of numa migration is done from task_work context.
+ * Triggered from task_tick_numa().
+ */
+void task_numa_work(struct callback_head *work)
+{
+	unsigned long migrate, next_scan, now = jiffies;
+	struct task_struct *p = current;
+	struct mm_struct *mm = p->mm;
+	struct vm_area_struct *vma;
+	unsigned long offset, end;
+	long length;
+
+	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
+
+	work->next = work; /* protect against double add */
+	/*
+	 * Who cares about NUMA placement when they're dying.
+	 *
+	 * NOTE: make sure not to dereference p->mm before this check,
+	 * exit_task_work() happens _after_ exit_mm() so we could be called
+	 * without p->mm even though we still had it when we enqueued this
+	 * work.
+	 */
+	if (p->flags & PF_EXITING)
+		return;
+
+	/*
+	 * Enforce maximal scan/migration frequency..
+	 */
+	migrate = mm->numa_next_scan;
+	if (time_before(now, migrate))
+		return;
+
+	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_task_period_min);
+	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
+		return;
+
+
+	offset = mm->numa_scan_offset;
+	length = sysctl_sched_numa_scan_size;
+	length <<= 20;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, offset);
+again:
+	if (!vma) {
+		ACCESS_ONCE(mm->numa_scan_seq)++;
+		offset = 0;
+		vma = mm->mmap;
+	}
+	while (vma && !vma_migratable(vma)) {
+		vma = vma->vm_next;
+		if (!vma)
+			goto again;
+	}
+
+	offset = max(offset, vma->vm_start);
+	end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
+	length -= end - offset;
+
+	change_prot_none(vma, offset, end);
+
+	offset = end;
+
+	if (length > 0) {
+		vma = vma->vm_next;
+		goto again;
+	}
+	mm->numa_scan_offset = offset;
+	up_read(&mm->mmap_sem);
+
+}
+
+/*
+ * Drive the periodic memory faults..
+ */
+void task_tick_numa(struct rq *rq, struct task_struct *curr)
+{
+	struct callback_head *work = &curr->numa_work;
+	u64 period, now;
+
+	/*
+	 * We don't care about NUMA placement if we don't have memory.
+	 */
+	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
+		return;
+
+	/*
+	 * Using runtime rather than walltime has the dual advantage that
+	 * we (mostly) drive the selection from busy threads and that the
+	 * task needs to have done some actual work before we bother with
+	 * NUMA placement.
+	 */
+	now = curr->se.sum_exec_runtime;
+	period = (u64)curr->numa_task_period * NSEC_PER_MSEC;
+
+	if (now - curr->node_stamp > period) {
+		curr->node_stamp = now;
+
+		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
+			init_task_work(work, task_numa_work); /* TODO: move this into sched_fork() */
+			task_work_add(curr, work, true);
+		}
+	}
+}
+#else
+static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
+{
+	return NULL;
+}
+
+static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
+{
+}
+
+static void task_tick_numa(struct rq *rq, struct task_struct *curr)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
+/**************************************************
  * Scheduling class queueing methods:
  */
 
@@ -783,9 +1026,17 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (!parent_entity(se))
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
-	if (entity_is_task(se))
-		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
-#endif
+	if (entity_is_task(se)) {
+		struct rq *rq = rq_of(cfs_rq);
+		struct task_struct *p = task_of(se);
+		struct list_head *tasks = &rq->cfs_tasks;
+
+		if (tsk_home_node(p) != -1)
+			tasks = account_numa_enqueue(rq, p);
+
+		list_add(&se->group_node, tasks);
+	}
+#endif /* CONFIG_SMP */
 	cfs_rq->nr_running++;
 }
 
@@ -795,8 +1046,14 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
+		struct task_struct *p = task_of(se);
+
 		list_del_init(&se->group_node);
+
+		if (tsk_home_node(p) != -1)
+			account_numa_dequeue(rq_of(cfs_rq), p);
+	}
 	cfs_rq->nr_running--;
 }
 
@@ -2681,6 +2938,35 @@ done:
 	return target;
 }
 
+#ifdef CONFIG_SCHED_NUMA
+static inline bool pick_numa_rand(int n)
+{
+	return !(get_random_int() % n);
+}
+
+/*
+ * Pick a random elegible CPU in the target node, hopefully faster
+ * than doing a least-loaded scan.
+ */
+static int numa_select_node_cpu(struct task_struct *p, int node)
+{
+	int weight = cpumask_weight(cpumask_of_node(node));
+	int i, cpu = -1;
+
+	for_each_cpu_and(i, cpumask_of_node(node), tsk_cpus_allowed(p)) {
+		if (cpu < 0 || pick_numa_rand(weight))
+			cpu = i;
+	}
+
+	return cpu;
+}
+#else
+static int numa_select_node_cpu(struct task_struct *p, int node)
+{
+	return -1;
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -2701,6 +2987,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int new_cpu = cpu;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
+	int node = tsk_home_node(p);
 
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
@@ -2712,6 +2999,36 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	rcu_read_lock();
+	if (sched_feat_numa(NUMA_TTWU_BIAS) && node != -1) {
+		/*
+		 * For fork,exec find the idlest cpu in the home-node.
+		 */
+		if (sd_flag & (SD_BALANCE_FORK|SD_BALANCE_EXEC)) {
+			int node_cpu = numa_select_node_cpu(p, node);
+			if (node_cpu < 0)
+				goto find_sd;
+
+			new_cpu = cpu = node_cpu;
+			sd = per_cpu(sd_node, cpu);
+			goto pick_idlest;
+		}
+
+		/*
+		 * For wake, pretend we were running in the home-node.
+		 */
+		if (cpu_to_node(prev_cpu) != node) {
+			int node_cpu = numa_select_node_cpu(p, node);
+			if (node_cpu < 0)
+				goto find_sd;
+
+			if (sched_feat_numa(NUMA_TTWU_TO))
+				cpu = node_cpu;
+			else
+				prev_cpu = node_cpu;
+		}
+	}
+
+find_sd:
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -2738,6 +3055,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		goto unlock;
 	}
 
+pick_idlest:
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
@@ -3060,9 +3378,14 @@ struct lb_env {
 
 	unsigned int		flags;
 
+	struct list_head	*tasks;
+
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+
+	struct rq *		(*find_busiest_queue)(struct lb_env *,
+						      struct sched_group *);
 };
 
 /*
@@ -3077,11 +3400,28 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 	check_preempt_curr(env->dst_rq, p, 0);
 }
 
+static int task_numa_hot(struct task_struct *p, struct lb_env *env)
+{
+	int from_dist, to_dist;
+	int node = tsk_home_node(p);
+
+	if (!sched_feat_numa(NUMA_HOT) || node == -1)
+		return 0; /* no node preference */
+
+	from_dist = node_distance(cpu_to_node(env->src_cpu), node);
+	to_dist = node_distance(cpu_to_node(env->dst_cpu), node);
+
+	if (to_dist < from_dist)
+		return 0; /* getting closer is ok */
+
+	return 1; /* stick to where we are */
+}
+
 /*
  * Is this task likely cache-hot:
  */
 static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+task_hot(struct task_struct *p, struct lb_env *env)
 {
 	s64 delta;
 
@@ -3104,7 +3444,7 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (sysctl_sched_migration_cost == 0)
 		return 0;
 
-	delta = now - p->se.exec_start;
+	delta = env->src_rq->clock_task - p->se.exec_start;
 
 	return delta < (s64)sysctl_sched_migration_cost;
 }
@@ -3161,7 +3501,9 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
+	tsk_cache_hot = task_hot(p, env);
+	if (env->idle == CPU_NOT_IDLE)
+		tsk_cache_hot |= task_numa_hot(p, env);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
@@ -3187,11 +3529,11 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
  *
  * Called with both runqueues locked.
  */
-static int move_one_task(struct lb_env *env)
+static int __move_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 
-	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
+	list_for_each_entry_safe(p, n, env->tasks, se.group_node) {
 		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
 			continue;
 
@@ -3210,7 +3552,20 @@ static int move_one_task(struct lb_env *env)
 	return 0;
 }
 
-static unsigned long task_h_load(struct task_struct *p);
+static int move_one_task(struct lb_env *env)
+{
+	if (sched_feat_numa(NUMA_PULL)) {
+		env->tasks = offnode_tasks(env->src_rq);
+		if (__move_one_task(env))
+			return 1;
+	}
+
+	env->tasks = &env->src_rq->cfs_tasks;
+	if (__move_one_task(env))
+		return 1;
+
+	return 0;
+}
 
 static const unsigned int sched_nr_migrate_break = 32;
 
@@ -3223,7 +3578,6 @@ static const unsigned int sched_nr_migrate_break = 32;
  */
 static int move_tasks(struct lb_env *env)
 {
-	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
 	int pulled = 0;
@@ -3231,8 +3585,9 @@ static int move_tasks(struct lb_env *env)
 	if (env->imbalance <= 0)
 		return 0;
 
-	while (!list_empty(tasks)) {
-		p = list_first_entry(tasks, struct task_struct, se.group_node);
+again:
+	while (!list_empty(env->tasks)) {
+		p = list_first_entry(env->tasks, struct task_struct, se.group_node);
 
 		env->loop++;
 		/* We've more or less seen every task there is, call it quits */
@@ -3243,7 +3598,7 @@ static int move_tasks(struct lb_env *env)
 		if (env->loop > env->loop_break) {
 			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
-			break;
+			goto out;
 		}
 
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
@@ -3271,7 +3626,7 @@ static int move_tasks(struct lb_env *env)
 		 * the critical section.
 		 */
 		if (env->idle == CPU_NEWLY_IDLE)
-			break;
+			goto out;
 #endif
 
 		/*
@@ -3279,13 +3634,20 @@ static int move_tasks(struct lb_env *env)
 		 * weighted load.
 		 */
 		if (env->imbalance <= 0)
-			break;
+			goto out;
 
 		continue;
 next:
-		list_move_tail(&p->se.group_node, tasks);
+		list_move_tail(&p->se.group_node, env->tasks);
+	}
+
+	if (env->tasks == offnode_tasks(env->src_rq)) {
+		env->tasks = &env->src_rq->cfs_tasks;
+		env->loop = 0;
+		goto again;
 	}
 
+out:
 	/*
 	 * Right now, this is one of only two places move_task() is called,
 	 * so we can safely collect move_task() stats here rather than
@@ -3440,6 +3802,14 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+#ifdef CONFIG_SCHED_NUMA
+	struct sched_group *numa_group; /* group which has offnode_tasks */
+	unsigned long numa_group_weight;
+	unsigned long numa_group_running;
+
+	unsigned long this_offnode_running;
+	unsigned long this_onnode_running;
+#endif
 };
 
 /*
@@ -3455,6 +3825,11 @@ struct sg_lb_stats {
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long numa_offnode_weight;
+	unsigned long numa_offnode_running;
+	unsigned long numa_onnode_running;
+#endif
 };
 
 /**
@@ -3483,6 +3858,121 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
+#ifdef CONFIG_SCHED_NUMA
+static inline void update_sg_numa_stats(struct sg_lb_stats *sgs, struct rq *rq)
+{
+	sgs->numa_offnode_weight += rq->offnode_weight;
+	sgs->numa_offnode_running += rq->offnode_running;
+	sgs->numa_onnode_running += rq->onnode_running;
+}
+
+/*
+ * Since the offnode lists are indiscriminate (they contain tasks for all other
+ * nodes) it is impossible to say if there's any task on there that wants to
+ * move towards the pulling cpu. Therefore select a random offnode list to pull
+ * from such that eventually we'll try them all.
+ *
+ * Select a random group that has offnode tasks as sds->numa_group
+ */
+static inline void update_sd_numa_stats(struct sched_domain *sd,
+		struct sched_group *group, struct sd_lb_stats *sds,
+		int local_group, struct sg_lb_stats *sgs)
+{
+	if (!(sd->flags & SD_NUMA))
+		return;
+
+	if (local_group) {
+		sds->this_offnode_running = sgs->numa_offnode_running;
+		sds->this_onnode_running  = sgs->numa_onnode_running;
+		return;
+	}
+
+	if (!sgs->numa_offnode_running)
+		return;
+
+	if (!sds->numa_group || pick_numa_rand(sd->span_weight / group->group_weight)) {
+		sds->numa_group = group;
+		sds->numa_group_weight = sgs->numa_offnode_weight;
+		sds->numa_group_running = sgs->numa_offnode_running;
+	}
+}
+
+/*
+ * Pick a random queue from the group that has offnode tasks.
+ */
+static struct rq *find_busiest_numa_queue(struct lb_env *env,
+					  struct sched_group *group)
+{
+	struct rq *busiest = NULL, *rq;
+	int cpu;
+
+	for_each_cpu_and(cpu, sched_group_cpus(group), env->cpus) {
+		rq = cpu_rq(cpu);
+		if (!rq->offnode_running)
+			continue;
+		if (!busiest || pick_numa_rand(group->group_weight))
+			busiest = rq;
+	}
+
+	return busiest;
+}
+
+/*
+ * Called in case of no other imbalance, if there is a queue running offnode
+ * tasksk we'll say we're imbalanced anyway to nudge these tasks towards their
+ * proper node.
+ */
+static inline int check_numa_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
+{
+	if (!sched_feat(NUMA_PULL_BIAS))
+		return 0;
+
+	if (!sds->numa_group)
+		return 0;
+
+	/*
+	 * Only pull an offnode task home if we've got offnode or !numa tasks to trade for it.
+	 */
+	if (!sds->this_offnode_running &&
+	    !(sds->this_nr_running - sds->this_onnode_running - sds->this_offnode_running))
+		return 0;
+
+	env->imbalance = sds->numa_group_weight / sds->numa_group_running;
+	sds->busiest = sds->numa_group;
+	env->find_busiest_queue = find_busiest_numa_queue;
+	return 1;
+}
+
+static inline bool need_active_numa_balance(struct lb_env *env)
+{
+	return env->find_busiest_queue == find_busiest_numa_queue &&
+			env->src_rq->offnode_running == 1 &&
+			env->src_rq->nr_running == 1;
+}
+
+#else /* CONFIG_SCHED_NUMA */
+
+static inline void update_sg_numa_stats(struct sg_lb_stats *sgs, struct rq *rq)
+{
+}
+
+static inline void update_sd_numa_stats(struct sched_domain *sd,
+		struct sched_group *group, struct sd_lb_stats *sds,
+		int local_group, struct sg_lb_stats *sgs)
+{
+}
+
+static inline int check_numa_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
+{
+	return 0;
+}
+
+static inline bool need_active_numa_balance(struct lb_env *env)
+{
+	return false;
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -3698,6 +4188,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
+
+		update_sg_numa_stats(sgs, rq);
 	}
 
 	/*
@@ -3851,6 +4343,8 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
+		update_sd_numa_stats(env->sd, sg, sds, local_group, &sgs);
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -4081,7 +4575,7 @@ find_busiest_group(struct lb_env *env, int *balance)
 
 	/* There is no busy sibling group to pull tasks from */
 	if (!sds.busiest || sds.busiest_nr_running == 0)
-		goto out_balanced;
+		goto ret;
 
 	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
@@ -4103,14 +4597,14 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 * don't try and pull any tasks.
 	 */
 	if (sds.this_load >= sds.max_load)
-		goto out_balanced;
+		goto ret;
 
 	/*
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
 	if (sds.this_load >= sds.avg_load)
-		goto out_balanced;
+		goto ret;
 
 	if (env->idle == CPU_IDLE) {
 		/*
@@ -4137,6 +4631,9 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
+	if (check_numa_busiest_group(env, &sds))
+		return sds.busiest;
+
 ret:
 	env->imbalance = 0;
 	return NULL;
@@ -4215,6 +4712,9 @@ static int need_active_balance(struct lb_env *env)
 			return 1;
 	}
 
+	if (need_active_numa_balance(env))
+		return 1;
+
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
@@ -4236,13 +4736,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	struct lb_env env = {
-		.sd		= sd,
-		.dst_cpu	= this_cpu,
-		.dst_rq		= this_rq,
-		.dst_grpmask    = sched_group_cpus(sd->groups),
-		.idle		= idle,
-		.loop_break	= sched_nr_migrate_break,
-		.cpus		= cpus,
+		.sd		    = sd,
+		.dst_cpu	    = this_cpu,
+		.dst_rq		    = this_rq,
+		.dst_grpmask        = sched_group_cpus(sd->groups),
+		.idle		    = idle,
+		.loop_break	    = sched_nr_migrate_break,
+		.cpus		    = cpus,
+		.find_busiest_queue = find_busiest_queue,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4261,11 +4762,13 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(&env, group);
+	busiest = env.find_busiest_queue(&env, group);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
 	}
+	env.src_rq  = busiest;
+	env.src_cpu = busiest->cpu;
 
 	BUG_ON(busiest == env.dst_rq);
 
@@ -4284,6 +4787,10 @@ redo:
 		env.src_cpu   = busiest->cpu;
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
+		if (sched_feat_numa(NUMA_PULL))
+			env.tasks = offnode_tasks(busiest);
+		else
+			env.tasks = &busiest->cfs_tasks;
 
 		update_h_load(env.src_cpu);
 more_balance:
@@ -4954,6 +5461,9 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	if (sched_feat_numa(NUMA))
+		task_tick_numa(rq, curr);
 }
 
 /*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index eebefca..1d11f6c 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -61,3 +61,17 @@ SCHED_FEAT(TTWU_QUEUE, true)
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
+
+#ifdef CONFIG_SCHED_NUMA
+/* Do the working set probing faults: */
+SCHED_FEAT(NUMA,           true)
+/* Do actual migration/placement based on the working set information: */
+SCHED_FEAT(NUMA_MIGRATION, true)
+SCHED_FEAT(NUMA_HOT,       true)
+SCHED_FEAT(NUMA_TTWU_BIAS, false)
+SCHED_FEAT(NUMA_TTWU_TO,   false)
+SCHED_FEAT(NUMA_PULL,      true)
+SCHED_FEAT(NUMA_PULL_BIAS, true)
+SCHED_FEAT(NUMA_SETTLE,    true)
+#endif
+
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..e68cef1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3,6 +3,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/slab.h>
 
 #include "cpupri.h"
 
@@ -418,6 +419,13 @@ struct rq {
 
 	struct list_head cfs_tasks;
 
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long    onnode_running;
+	unsigned long    offnode_running;
+	unsigned long	 offnode_weight;
+	struct list_head offnode_tasks;
+#endif
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -486,6 +494,27 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+#ifdef CONFIG_SCHED_NUMA
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+	return &rq->offnode_tasks;
+}
+
+static inline void task_numa_free(struct task_struct *p)
+{
+	kfree(p->numa_faults);
+}
+#else /* CONFIG_SCHED_NUMA */
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+	return NULL;
+}
+
+static inline void task_numa_free(struct task_struct *p)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
@@ -529,6 +558,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
+DECLARE_PER_CPU(struct sched_domain *, sd_node);
 
 extern int group_balance_cpu(struct sched_group *sg);
 
@@ -648,6 +678,12 @@ extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 #endif /* SCHED_DEBUG && HAVE_JUMP_LABEL */
 
+#ifdef CONFIG_SCHED_NUMA
+#define sched_feat_numa(x) sched_feat(x)
+#else
+#define sched_feat_numa(x) (0)
+#endif
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 26f65ea..0f0cb60 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -301,6 +301,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
+#ifdef CONFIG_SMP
 	{
 		.procname	= "sched_tunable_scaling",
 		.data		= &sysctl_sched_tunable_scaling,
@@ -347,7 +348,38 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-#endif
+#endif /* CONFIG_SMP */
+#ifdef CONFIG_SCHED_NUMA
+	{
+		.procname	= "sched_numa_task_period_min_ms",
+		.data		= &sysctl_sched_numa_task_period_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_task_period_max_ms",
+		.data		= &sysctl_sched_numa_task_period_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_scan_size_mb",
+		.data		= &sysctl_sched_numa_scan_size,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_settle_count",
+		.data		= &sysctl_sched_numa_settle_count,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_SCHED_NUMA */
+#endif /* CONFIG_SCHED_DEBUG */
 	{
 		.procname	= "sched_rt_period_us",
 		.data		= &sysctl_sched_rt_period,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40f17c3..5aa935a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -18,6 +18,7 @@
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
+#include <linux/migrate.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -710,7 +711,8 @@ out:
 	 * run pte_offset_map on the pmd, if an huge pmd could
 	 * materialize from under us from a different thread.
 	 */
-	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
+	if (unlikely(pmd_none(*pmd)) &&
+	    unlikely(__pte_alloc(mm, vma, pmd, address)))
 		return VM_FAULT_OOM;
 	/* if an huge pmd materialized from under us just retry later */
 	if (unlikely(pmd_trans_huge(*pmd)))
@@ -725,6 +727,152 @@ out:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
+bool pmd_numa(struct vm_area_struct *vma, pmd_t pmd)
+{
+	/*
+	 * See pte_prot_none().
+	 */
+	if (pmd_same(pmd, pmd_modify(pmd, vma->vm_page_prot)))
+		return false;
+
+	return pmd_same(pmd, pmd_modify(pmd, vma_prot_none(vma)));
+}
+
+void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+			   unsigned long address, pmd_t *pmd,
+			   unsigned int flags, pmd_t entry)
+{
+	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct page *new_page = NULL;
+	struct page *page = NULL;
+	int node, lru;
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry)))
+		goto unlock;
+
+	if (unlikely(pmd_trans_splitting(entry))) {
+		spin_unlock(&mm->page_table_lock);
+		wait_split_huge_page(vma->anon_vma, pmd);
+		return;
+	}
+
+	page = pmd_page(entry);
+	if (page) {
+		VM_BUG_ON(!PageCompound(page) || !PageHead(page));
+
+		get_page(page);
+		node = mpol_misplaced(page, vma, haddr);
+		if (node != -1)
+			goto migrate;
+	}
+
+fixup:
+	/* change back to regular protection */
+	entry = pmd_modify(entry, vma->vm_page_prot);
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache_pmd(vma, address, entry);
+
+unlock:
+	spin_unlock(&mm->page_table_lock);
+	if (page) {
+		task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
+		put_page(page);
+	}
+	return;
+
+migrate:
+	spin_unlock(&mm->page_table_lock);
+
+	lock_page(page);
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry))) {
+		spin_unlock(&mm->page_table_lock);
+		unlock_page(page);
+		put_page(page);
+		return;
+	}
+	spin_unlock(&mm->page_table_lock);
+
+	new_page = alloc_pages_node(node,
+	    (GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT,
+	    HPAGE_PMD_ORDER);
+
+	if (!new_page)
+		goto alloc_fail;
+
+	lru = PageLRU(page);
+
+	if (lru && isolate_lru_page(page)) /* does an implicit get_page() */
+		goto alloc_fail;
+
+	if (!trylock_page(new_page))
+		BUG();
+
+	/* anon mapping, we can simply copy page->mapping to the new page: */
+	new_page->mapping = page->mapping;
+	new_page->index = page->index;
+
+	migrate_page_copy(new_page, page);
+
+	WARN_ON(PageLRU(new_page));
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry))) {
+		spin_unlock(&mm->page_table_lock);
+		if (lru)
+			putback_lru_page(page);
+
+		unlock_page(new_page);
+		ClearPageActive(new_page);	/* Set by migrate_page_copy() */
+		new_page->mapping = NULL;
+		put_page(new_page);		/* Free it */
+
+		unlock_page(page);
+		put_page(page);			/* Drop the local reference */
+
+		return;
+	}
+
+	entry = mk_pmd(new_page, vma->vm_page_prot);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	entry = pmd_mkhuge(entry);
+
+	page_add_new_anon_rmap(new_page, vma, haddr);
+
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache_pmd(vma, address, entry);
+	page_remove_rmap(page);
+	spin_unlock(&mm->page_table_lock);
+
+	put_page(page);			/* Drop the rmap reference */
+
+	task_numa_fault(node, HPAGE_PMD_NR);
+
+	if (lru)
+		put_page(page);		/* drop the LRU isolation reference */
+
+	unlock_page(new_page);
+	unlock_page(page);
+	put_page(page);			/* Drop the local reference */
+
+	return;
+
+alloc_fail:
+	if (new_page)
+		put_page(new_page);
+
+	unlock_page(page);
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, entry))) {
+		put_page(page);
+		page = NULL;
+		goto unlock;
+	}
+	goto fixup;
+}
+
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *vma)
@@ -1296,6 +1444,7 @@ static void __split_huge_page_refcount(struct page *page)
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
+		page_xchg_last_nid(page, page_last_nid(page_tail));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
@@ -1343,63 +1492,60 @@ static int __split_huge_page_map(struct page *page,
 	int ret = 0, i;
 	pgtable_t pgtable;
 	unsigned long haddr;
+	pgprot_t prot;
 
 	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
-	if (pmd) {
-		pgtable = pgtable_trans_huge_withdraw(mm);
-		pmd_populate(mm, &_pmd, pgtable);
-
-		haddr = address;
-		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
-			pte_t *pte, entry;
-			BUG_ON(PageCompound(page+i));
-			entry = mk_pte(page + i, vma->vm_page_prot);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (!pmd_write(*pmd))
-				entry = pte_wrprotect(entry);
-			else
-				BUG_ON(page_mapcount(page) != 1);
-			if (!pmd_young(*pmd))
-				entry = pte_mkold(entry);
-			pte = pte_offset_map(&_pmd, haddr);
-			BUG_ON(!pte_none(*pte));
-			set_pte_at(mm, haddr, pte, entry);
-			pte_unmap(pte);
-		}
+	if (!pmd)
+		goto unlock;
 
-		smp_wmb(); /* make pte visible before pmd */
-		/*
-		 * Up to this point the pmd is present and huge and
-		 * userland has the whole access to the hugepage
-		 * during the split (which happens in place). If we
-		 * overwrite the pmd with the not-huge version
-		 * pointing to the pte here (which of course we could
-		 * if all CPUs were bug free), userland could trigger
-		 * a small page size TLB miss on the small sized TLB
-		 * while the hugepage TLB entry is still established
-		 * in the huge TLB. Some CPU doesn't like that. See
-		 * http://support.amd.com/us/Processor_TechDocs/41322.pdf,
-		 * Erratum 383 on page 93. Intel should be safe but is
-		 * also warns that it's only safe if the permission
-		 * and cache attributes of the two entries loaded in
-		 * the two TLB is identical (which should be the case
-		 * here). But it is generally safer to never allow
-		 * small and huge TLB entries for the same virtual
-		 * address to be loaded simultaneously. So instead of
-		 * doing "pmd_populate(); flush_tlb_range();" we first
-		 * mark the current pmd notpresent (atomically because
-		 * here the pmd_trans_huge and pmd_trans_splitting
-		 * must remain set at all times on the pmd until the
-		 * split is complete for this pmd), then we flush the
-		 * SMP TLB and finally we write the non-huge version
-		 * of the pmd entry with pmd_populate.
-		 */
-		pmdp_invalidate(vma, address, pmd);
-		pmd_populate(mm, pmd, pgtable);
-		ret = 1;
+	prot = pmd_pgprot(*pmd);
+	pgtable = pgtable_trans_huge_withdraw(mm);
+	pmd_populate(mm, &_pmd, pgtable);
+
+	for (i = 0, haddr = address; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
+		pte_t *pte, entry;
+
+		BUG_ON(PageCompound(page+i));
+		entry = mk_pte(page + i, prot);
+		entry = pte_mkdirty(entry);
+		if (!pmd_young(*pmd))
+			entry = pte_mkold(entry);
+		pte = pte_offset_map(&_pmd, haddr);
+		BUG_ON(!pte_none(*pte));
+		set_pte_at(mm, haddr, pte, entry);
+		pte_unmap(pte);
 	}
+
+	smp_wmb(); /* make ptes visible before pmd, see __pte_alloc */
+	/*
+	 * Up to this point the pmd is present and huge.
+	 *
+	 * If we overwrite the pmd with the not-huge version, we could trigger
+	 * a small page size TLB miss on the small sized TLB while the hugepage
+	 * TLB entry is still established in the huge TLB.
+	 *
+	 * Some CPUs don't like that. See
+	 * http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum 383
+	 * on page 93.
+	 *
+	 * Thus it is generally safer to never allow small and huge TLB entries
+	 * for overlapping virtual addresses to be loaded. So we first mark the
+	 * current pmd not present, then we flush the TLB and finally we write
+	 * the non-huge version of the pmd entry with pmd_populate.
+	 *
+	 * The above needs to be done under the ptl because pmd_trans_huge and
+	 * pmd_trans_splitting must remain set on the pmd until the split is
+	 * complete. The ptl also protects against concurrent faults due to
+	 * making the pmd not-present.
+	 */
+	set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	pmd_populate(mm, pmd, pgtable);
+	ret = 1;
+
+unlock:
 	spin_unlock(&mm->page_table_lock);
 
 	return ret;
@@ -2287,10 +2433,8 @@ static void khugepaged_do_scan(void)
 {
 	struct page *hpage = NULL;
 	unsigned int progress = 0, pass_through_head = 0;
-	unsigned int pages = khugepaged_pages_to_scan;
 	bool wait = true;
-
-	barrier(); /* write khugepaged_pages_to_scan to local stack */
+	unsigned int pages = ACCESS_ONCE(khugepaged_pages_to_scan);
 
 	while (progress < pages) {
 		if (!khugepaged_prealloc_page(&hpage, &wait))
diff --git a/mm/memory.c b/mm/memory.c
index fb135ba..23d4bd4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -36,6 +36,8 @@
  *		(Gerhard.Wichert@pdb.siemens.de)
  *
  * Aug/Sep 2004 Changed to four level page tables (Andi Kleen)
+ *
+ * 2012 - NUMA placement page faults (Andrea Arcangeli, Peter Zijlstra)
  */
 
 #include <linux/kernel_stat.h>
@@ -57,6 +59,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/migrate.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -67,6 +70,10 @@
 
 #include "internal.h"
 
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+#warning Unfortunate NUMA config, growing page-frame for last_nid.
+#endif
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
@@ -1464,6 +1471,27 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
+static bool pte_numa(struct vm_area_struct *vma, pte_t pte)
+{
+	/*
+	 * For NUMA page faults, we use PROT_NONE ptes in VMAs with
+	 * "normal" vma->vm_page_prot protections.  Genuine PROT_NONE
+	 * VMAs should never get here, because the fault handling code
+	 * will notice that the VMA has no read or write permissions.
+	 *
+	 * This means we cannot get 'special' PROT_NONE faults from genuine
+	 * PROT_NONE maps, nor from PROT_WRITE file maps that do dirty
+	 * tracking.
+	 *
+	 * Neither case is really interesting for our current use though so we
+	 * don't care.
+	 */
+	if (pte_same(pte, pte_modify(pte, vma->vm_page_prot)))
+		return false;
+
+	return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
+}
+
 /**
  * follow_page - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
@@ -1517,6 +1545,8 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
 		goto out;
 	}
+	if ((flags & FOLL_NUMA) && pmd_numa(vma, *pmd))
+		goto no_page_table;
 	if (pmd_trans_huge(*pmd)) {
 		if (flags & FOLL_SPLIT) {
 			split_huge_page_pmd(mm, pmd);
@@ -1546,6 +1576,8 @@ split_fallthrough:
 	pte = *ptep;
 	if (!pte_present(pte))
 		goto no_page;
+	if ((flags & FOLL_NUMA) && pte_numa(vma, pte))
+		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
 
@@ -1697,6 +1729,19 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			(VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
 	vm_flags &= (gup_flags & FOLL_FORCE) ?
 			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
+
+	/*
+	 * If FOLL_FORCE and FOLL_NUMA are both set, handle_mm_fault
+	 * would be called on PROT_NONE ranges. We must never invoke
+	 * handle_mm_fault on PROT_NONE ranges or the NUMA hinting
+	 * page faults would unprotect the PROT_NONE ranges if
+	 * _PAGE_NUMA and _PAGE_PROTNONE are sharing the same pte/pmd
+	 * bitflag. So to avoid that, don't set FOLL_NUMA if
+	 * FOLL_FORCE is set.
+	 */
+	if (!(gup_flags & FOLL_FORCE))
+		gup_flags |= FOLL_NUMA;
+
 	i = 0;
 
 	do {
@@ -3433,6 +3478,93 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
+static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pte_t *ptep, pmd_t *pmd,
+			unsigned int flags, pte_t entry)
+{
+	struct page *page = NULL;
+	int node, page_nid = -1;
+	spinlock_t *ptl;
+	int account = 1;
+	int locked = 0;
+
+	ptl = pte_lockptr(mm, pmd);
+	spin_lock(ptl);
+	if (unlikely(!pte_same(*ptep, entry)))
+		goto out_unlock;
+
+	page = vm_normal_page(vma, address, entry);
+	if (page) {
+		get_page(page);
+		page_nid = page_to_nid(page);
+		node = mpol_misplaced(page, vma, address);
+		if (node != -1)
+			goto migrate;
+	}
+
+out_pte_upgrade_unlock:
+	flush_cache_page(vma, address, pte_pfn(entry));
+
+	ptep_modify_prot_start(mm, address, ptep);
+	entry = pte_modify(entry, vma->vm_page_prot);
+	ptep_modify_prot_commit(mm, address, ptep, entry);
+
+	/* No TLB flush needed because we upgraded the PTE */
+
+	update_mmu_cache(vma, address, ptep);
+
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
+out:
+	if (page) {
+		if (locked)
+			unlock_page(page);
+		if (account)
+			task_numa_fault(page_nid, 1);
+		put_page(page);
+	}
+
+	return 0;
+
+migrate:
+	pte_unmap_unlock(ptep, ptl);
+
+	locked = 1;
+	lock_page(page);
+
+	/*
+	 * We have to do this again, to make sure
+	 * we have not raced with a pte update
+	 * during the lock_page():
+	 */
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!pte_same(*ptep, entry)) {
+		account = 0;
+		goto out_unlock;
+	}
+	pte_unmap_unlock(ptep, ptl);
+
+	if (!migrate_misplaced_page(page, node)) {
+		/*
+		 * Successful migration - account the fault.
+		 * Note, we don't fix up the pte, that will
+		 * happen on the next fault.
+		 */
+		page_nid = node;
+		put_page(page);
+
+		goto out;
+	}
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!pte_same(*ptep, entry)) {
+		account = 0;
+		goto out_unlock;
+	}
+
+	goto out_pte_upgrade_unlock;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3453,7 +3585,7 @@ int handle_pte_fault(struct mm_struct *mm,
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = *pte;
+	entry = ACCESS_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
@@ -3471,6 +3603,9 @@ int handle_pte_fault(struct mm_struct *mm,
 					pte, pmd, flags, entry);
 	}
 
+	if (pte_numa(vma, entry))
+		return do_numa_page(mm, vma, address, pte, pmd, flags, entry);
+
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
 	if (unlikely(!pte_same(*pte, entry)))
@@ -3535,13 +3670,16 @@ retry:
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd = *pmd;
-		int ret;
+		int ret = 0;
 
 		barrier();
-		if (pmd_trans_huge(orig_pmd)) {
-			if (flags & FAULT_FLAG_WRITE &&
-			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd)) {
+		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
+			if (pmd_numa(vma, orig_pmd)) {
+				do_huge_pmd_numa_page(mm, vma, address, pmd,
+						      flags, orig_pmd);
+			}
+
+			if ((flags & FAULT_FLAG_WRITE) && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
 				/*
@@ -3551,18 +3689,20 @@ retry:
 				 */
 				if (unlikely(ret & VM_FAULT_OOM))
 					goto retry;
-				return ret;
 			}
-			return 0;
+
+			return ret;
 		}
 	}
 
+
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
 	 * run pte_offset_map on the pmd, if an huge pmd could
 	 * materialize from under us from a different thread.
 	 */
-	if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
+	if (unlikely(pmd_none(*pmd)) &&
+	    unlikely(__pte_alloc(mm, vma, pmd, address)))
 		return VM_FAULT_OOM;
 	/* if an huge pmd materialized from under us just retry later */
 	if (unlikely(pmd_trans_huge(*pmd)))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..d998810 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -117,6 +117,22 @@ static struct mempolicy default_policy = {
 	.flags = MPOL_F_LOCAL,
 };
 
+static struct mempolicy preferred_node_policy[MAX_NUMNODES];
+
+static struct mempolicy *get_task_policy(struct task_struct *p)
+{
+	struct mempolicy *pol = p->mempolicy;
+	int node;
+
+	if (!pol) {
+		node = tsk_home_node(p);
+		if (node != -1)
+			pol = &preferred_node_policy[node];
+	}
+
+	return pol;
+}
+
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
 	/*
@@ -251,10 +267,10 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (mode == MPOL_DEFAULT) {
+	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP) {
 		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
-		return NULL;	/* simply delete any existing policy */
+		return NULL;
 	}
 	VM_BUG_ON(!nodes);
 
@@ -269,6 +285,10 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 			     (flags & MPOL_F_RELATIVE_NODES)))
 				return ERR_PTR(-EINVAL);
 		}
+	} else if (mode == MPOL_LOCAL) {
+		if (!nodes_empty(*nodes))
+			return ERR_PTR(-EINVAL);
+		mode = MPOL_PREFERRED;
 	} else if (nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
@@ -579,22 +599,32 @@ check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		return ERR_PTR(-EFAULT);
 	prev = NULL;
 	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
+		unsigned long endvma = vma->vm_end;
+
+		if (endvma > end)
+			endvma = end;
+		if (vma->vm_start > start)
+			start = vma->vm_start;
+
 		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
 			if (!vma->vm_next && vma->vm_end < end)
 				return ERR_PTR(-EFAULT);
 			if (prev && prev->vm_end < vma->vm_start)
 				return ERR_PTR(-EFAULT);
 		}
-		if (!is_vm_hugetlb_page(vma) &&
-		    ((flags & MPOL_MF_STRICT) ||
+
+		if (is_vm_hugetlb_page(vma))
+			goto next;
+
+		if (flags & MPOL_MF_LAZY) {
+			change_prot_none(vma, start, endvma);
+			goto next;
+		}
+
+		if ((flags & MPOL_MF_STRICT) ||
 		     ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
-				vma_migratable(vma)))) {
-			unsigned long endvma = vma->vm_end;
+		      vma_migratable(vma))) {
 
-			if (endvma > end)
-				endvma = end;
-			if (vma->vm_start > start)
-				start = vma->vm_start;
 			err = check_pgd_range(vma, start, endvma, nodes,
 						flags, private);
 			if (err) {
@@ -602,6 +632,7 @@ check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 				break;
 			}
 		}
+next:
 		prev = vma;
 	}
 	return first;
@@ -1133,8 +1164,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	int err;
 	LIST_HEAD(pagelist);
 
-	if (flags & ~(unsigned long)(MPOL_MF_STRICT |
-				     MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+  	if (flags & ~(unsigned long)MPOL_MF_VALID)
 		return -EINVAL;
 	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
 		return -EPERM;
@@ -1142,7 +1172,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (start & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (mode == MPOL_DEFAULT)
+	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
 		flags &= ~MPOL_MF_STRICT;
 
 	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
@@ -1157,6 +1187,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
+	if (flags & MPOL_MF_LAZY)
+		new->flags |= MPOL_F_MOF;
+
 	/*
 	 * If we are using the default policy then operation
 	 * on discontinuous address spaces is okay after all
@@ -1193,21 +1226,23 @@ static long do_mbind(unsigned long start, unsigned long len,
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
-	err = PTR_ERR(vma);
-	if (!IS_ERR(vma)) {
-		int nr_failed = 0;
-
+	err = PTR_ERR(vma);	/* maybe ... */
+	if (!IS_ERR(vma) && mode != MPOL_NOOP)
 		err = mbind_range(mm, start, end, new);
 
+	if (!err) {
+		int nr_failed = 0;
+
 		if (!list_empty(&pagelist)) {
+			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
-						false, MIGRATE_SYNC);
+						  (unsigned long)vma,
+						  false, MIGRATE_SYNC);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
 
-		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
+		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
 		putback_lru_pages(&pagelist);
@@ -1546,7 +1581,7 @@ asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = task->mempolicy;
+	struct mempolicy *pol = get_task_policy(task);
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1587,11 +1622,29 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 	return NULL;
 }
 
+/* Do dynamic interleaving for a process */
+static unsigned interleave_nodes(struct mempolicy *policy)
+{
+	unsigned nid, next;
+	struct task_struct *me = current;
+
+	nid = me->il_next;
+	next = next_node(nid, policy->v.nodes);
+	if (next >= MAX_NUMNODES)
+		next = first_node(policy->v.nodes);
+	if (next < MAX_NUMNODES)
+		me->il_next = next;
+	return nid;
+}
+
 /* Return a zonelist indicated by gfp for node representing a mempolicy */
 static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
 	int nd)
 {
 	switch (policy->mode) {
+	case MPOL_INTERLEAVE:
+		nd = interleave_nodes(policy);
+		break;
 	case MPOL_PREFERRED:
 		if (!(policy->flags & MPOL_F_LOCAL))
 			nd = policy->v.preferred_node;
@@ -1613,21 +1666,6 @@ static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
 	return node_zonelist(nd, gfp);
 }
 
-/* Do dynamic interleaving for a process */
-static unsigned interleave_nodes(struct mempolicy *policy)
-{
-	unsigned nid, next;
-	struct task_struct *me = current;
-
-	nid = me->il_next;
-	next = next_node(nid, policy->v.nodes);
-	if (next >= MAX_NUMNODES)
-		next = first_node(policy->v.nodes);
-	if (next < MAX_NUMNODES)
-		me->il_next = next;
-	return nid;
-}
-
 /*
  * Depending on the memory policy provide a node from which to allocate the
  * next slab entry.
@@ -1864,21 +1902,6 @@ out:
 	return ret;
 }
 
-/* Allocate a page in interleaved policy.
-   Own path because it needs to do special accounting. */
-static struct page *alloc_page_interleave(gfp_t gfp, unsigned order,
-					unsigned nid)
-{
-	struct zonelist *zl;
-	struct page *page;
-
-	zl = node_zonelist(nid, gfp);
-	page = __alloc_pages(gfp, order, zl);
-	if (page && page_zone(page) == zonelist_zone(&zl->_zonerefs[0]))
-		inc_zone_page_state(page, NUMA_INTERLEAVE_HIT);
-	return page;
-}
-
 /**
  * 	alloc_pages_vma	- Allocate a page for a VMA.
  *
@@ -1915,17 +1938,6 @@ retry_cpuset:
 	pol = get_vma_policy(current, vma, addr);
 	cpuset_mems_cookie = get_mems_allowed();
 
-	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
-		unsigned nid;
-
-		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
-		mpol_cond_put(pol);
-		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
-			goto retry_cpuset;
-
-		return page;
-	}
 	zl = policy_zonelist(gfp, pol, node);
 	if (unlikely(mpol_needs_cond_ref(pol))) {
 		/*
@@ -1969,7 +1981,7 @@ retry_cpuset:
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = current->mempolicy;
+	struct mempolicy *pol = get_task_policy(current);
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
@@ -1983,12 +1995,9 @@ retry_cpuset:
 	 * No reference counting needed for current->mempolicy
 	 * nor system default_policy
 	 */
-	if (pol->mode == MPOL_INTERLEAVE)
-		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
-	else
-		page = __alloc_pages_nodemask(gfp, order,
-				policy_zonelist(gfp, pol, numa_node_id()),
-				policy_nodemask(gfp, pol));
+	page = __alloc_pages_nodemask(gfp, order,
+			policy_zonelist(gfp, pol, numa_node_id()),
+			policy_nodemask(gfp, pol));
 
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
@@ -2175,6 +2184,115 @@ static void sp_free(struct sp_node *n)
 	kmem_cache_free(sn_cache, n);
 }
 
+/**
+ * mpol_misplaced - check whether current page node is valid in policy
+ *
+ * @page   - page to be checked
+ * @vma    - vm area where page mapped
+ * @addr   - virtual address where page mapped
+ * @multi  - use multi-stage node binding
+ *
+ * Lookup current policy node id for vma,addr and "compare to" page's
+ * node id.
+ *
+ * Returns:
+ *	-1	- not misplaced, page is in the right node
+ *	node	- node id where the page should be
+ *
+ * Policy determination "mimics" alloc_page_vma().
+ * Called from fault path where we know the vma and faulting address.
+ */
+int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
+		   unsigned long addr)
+{
+	struct mempolicy *pol;
+	struct zone *zone;
+	int curnid = page_to_nid(page);
+	unsigned long pgoff;
+	int polnid = -1;
+	int ret = -1;
+
+	BUG_ON(!vma);
+
+	pol = get_vma_policy(current, vma, addr);
+	if (!(pol->flags & MPOL_F_MOF))
+		goto out;
+
+	switch (pol->mode) {
+	case MPOL_INTERLEAVE:
+		BUG_ON(addr >= vma->vm_end);
+		BUG_ON(addr < vma->vm_start);
+
+		pgoff = vma->vm_pgoff;
+		pgoff += (addr - vma->vm_start) >> PAGE_SHIFT;
+		polnid = offset_il_node(pol, vma, pgoff);
+		break;
+
+	case MPOL_PREFERRED:
+		if (pol->flags & MPOL_F_LOCAL)
+			polnid = numa_node_id();
+		else
+			polnid = pol->v.preferred_node;
+		break;
+
+	case MPOL_BIND:
+		/*
+		 * allows binding to multiple nodes.
+		 * use current page if in policy nodemask,
+		 * else select nearest allowed node, if any.
+		 * If no allowed nodes, use current [!misplaced].
+		 */
+		if (node_isset(curnid, pol->v.nodes))
+			goto out;
+		(void)first_zones_zonelist(
+				node_zonelist(numa_node_id(), GFP_HIGHUSER),
+				gfp_zone(GFP_HIGHUSER),
+				&pol->v.nodes, &zone);
+		polnid = zone->node;
+		break;
+
+	default:
+		BUG();
+	}
+
+	/*
+	 * Multi-stage node selection is used in conjunction with a periodic
+	 * migration fault to build a temporal task<->page relation. By
+	 * using a two-stage filter we remove short/unlikely relations.
+	 *
+	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can
+	 * equate a task's usage of a particular page (n_p) per total usage
+	 * of this page (n_t) (in a given time-span) to a probability.
+	 *
+	 * Our periodic faults will then sample this probability and getting
+	 * the same result twice in a row, given these samples are fully
+	 * independent, is then given by P(n)^2, provided our sample period
+	 * is sufficiently short compared to the usage pattern.
+	 *
+	 * This quadric squishes small probabilities, making it less likely
+	 * we act on an unlikely task<->page relation.
+	 */
+	if (pol->flags & MPOL_F_HOME) {
+		int last_nid;
+
+		/*
+		 * Migrate towards the current node, depends on
+		 * task_numa_placement() details.
+		 */
+		polnid = numa_node_id();
+		last_nid = page_xchg_last_nid(page, polnid);
+		if (last_nid != polnid)
+			goto out;
+	}
+
+	if (curnid != polnid)
+		ret = polnid;
+out:
+	mpol_cond_put(pol);
+
+	return ret;
+}
+
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
@@ -2355,6 +2473,15 @@ void __init numa_policy_init(void)
 				     sizeof(struct sp_node),
 				     0, SLAB_PANIC, NULL);
 
+	for_each_node(nid) {
+		preferred_node_policy[nid] = (struct mempolicy) {
+			.refcnt = ATOMIC_INIT(1),
+			.mode = MPOL_PREFERRED,
+			.flags = MPOL_F_MOF | MPOL_F_HOME,
+			.v = { .preferred_node = nid, },
+		};
+	}
+
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
 	 * enabled across suitably sized nodes (default is >= 16MB), or
@@ -2397,14 +2524,14 @@ void numa_default_policy(void)
  * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
  * Used only for mpol_parse_str() and mpol_to_str()
  */
-#define MPOL_LOCAL MPOL_MAX
 static const char * const policy_modes[] =
 {
 	[MPOL_DEFAULT]    = "default",
 	[MPOL_PREFERRED]  = "prefer",
 	[MPOL_BIND]       = "bind",
 	[MPOL_INTERLEAVE] = "interleave",
-	[MPOL_LOCAL]      = "local"
+	[MPOL_LOCAL]      = "local",
+	[MPOL_NOOP]	  = "noop",	/* should not actually be used */
 };
 
 
@@ -2450,12 +2577,12 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 	if (flags)
 		*flags++ = '\0';	/* terminate mode string */
 
-	for (mode = 0; mode <= MPOL_LOCAL; mode++) {
+	for (mode = 0; mode < MPOL_MAX; mode++) {
 		if (!strcmp(str, policy_modes[mode])) {
 			break;
 		}
 	}
-	if (mode > MPOL_LOCAL)
+	if (mode >= MPOL_MAX || mode == MPOL_NOOP)
 		goto out;
 
 	switch (mode) {
diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..6d16bff 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -225,7 +225,7 @@ static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 	struct buffer_head *bh = head;
 
 	/* Simple case, sync compaction */
-	if (mode != MIGRATE_ASYNC) {
+	if (mode != MIGRATE_ASYNC && mode != MIGRATE_FAULT) {
 		do {
 			get_bh(bh);
 			lock_buffer(bh);
@@ -279,12 +279,22 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page,
 		struct buffer_head *head, enum migrate_mode mode)
 {
-	int expected_count;
+	int expected_count = 0;
 	void **pslot;
 
+	if (mode == MIGRATE_FAULT) {
+		/*
+		 * MIGRATE_FAULT has an extra reference on the page and
+		 * otherwise acts like ASYNC, no point in delaying the
+		 * fault, we'll try again next time.
+		 */
+		expected_count++;
+	}
+
 	if (!mapping) {
 		/* Anonymous page without mapping */
-		if (page_count(page) != 1)
+		expected_count += 1;
+		if (page_count(page) != expected_count)
 			return -EAGAIN;
 		return 0;
 	}
@@ -294,7 +304,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	expected_count = 2 + page_has_private(page);
+	expected_count += 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
 		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
@@ -313,7 +323,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	 * the mapping back due to an elevated page count, we would have to
 	 * block waiting on other references to be dropped.
 	 */
-	if (mode == MIGRATE_ASYNC && head &&
+	if ((mode == MIGRATE_ASYNC || mode == MIGRATE_FAULT) && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
 		page_unfreeze_refs(page, expected_count);
 		spin_unlock_irq(&mapping->tree_lock);
@@ -407,7 +417,7 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
  */
 void migrate_page_copy(struct page *newpage, struct page *page)
 {
-	if (PageHuge(page))
+	if (PageHuge(page) || PageTransHuge(page))
 		copy_huge_page(newpage, page);
 	else
 		copy_highpage(newpage, page);
@@ -521,7 +531,7 @@ int buffer_migrate_page(struct address_space *mapping,
 	 * with an IRQ-safe spinlock held. In the sync case, the buffers
 	 * need to be locked now
 	 */
-	if (mode != MIGRATE_ASYNC)
+	if (mode != MIGRATE_ASYNC && mode != MIGRATE_FAULT)
 		BUG_ON(!buffer_migrate_lock_buffers(head, mode));
 
 	ClearPagePrivate(page);
@@ -687,7 +697,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 	struct anon_vma *anon_vma = NULL;
 
 	if (!trylock_page(page)) {
-		if (!force || mode == MIGRATE_ASYNC)
+		if (!force || mode == MIGRATE_ASYNC || mode == MIGRATE_FAULT)
 			goto out;
 
 		/*
@@ -1403,4 +1413,65 @@ int migrate_vmas(struct mm_struct *mm, const nodemask_t *to,
  	}
  	return err;
 }
-#endif
+
+/*
+ * Attempt to migrate a misplaced page to the specified destination
+ * node.
+ */
+int migrate_misplaced_page(struct page *page, int node)
+{
+	struct address_space *mapping = page_mapping(page);
+	int page_lru = page_is_file_cache(page);
+	struct page *newpage;
+	int ret = -EAGAIN;
+	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
+
+	/*
+	 * Don't migrate pages that are mapped in multiple processes.
+	 */
+	if (page_mapcount(page) != 1)
+		goto out;
+
+	/*
+	 * Never wait for allocations just to migrate on fault, but don't dip
+	 * into reserves. And, only accept pages from the specified node. No
+	 * sense migrating to a different "misplaced" page!
+	 */
+	if (mapping)
+		gfp = mapping_gfp_mask(mapping);
+	gfp &= ~__GFP_WAIT;
+	gfp |= __GFP_NOMEMALLOC | GFP_THISNODE;
+
+	newpage = alloc_pages_node(node, gfp, 0);
+	if (!newpage) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (isolate_lru_page(page)) {
+		put_page(newpage);
+		return -EBUSY;
+	}
+
+	inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
+	ret = __unmap_and_move(page, newpage, 0, 0, MIGRATE_FAULT);
+
+	if (ret != -EAGAIN) {
+		/*
+		 * A page that has been migrated has all references removed and will be
+		 * freed. A page that has not been migrated will have kepts its
+		 * references and be restored.
+		 */
+		dec_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
+		putback_lru_page(page);
+	}
+	/*
+	 * Move the new page to the LRU. If migration was not successful
+	 * then this will free the page.
+	 */
+	putback_lru_page(newpage);
+out:
+	return ret;
+}
+
+#endif /* CONFIG_NUMA */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index a409926..392b124 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -28,13 +28,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#ifndef pgprot_modify
-static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
-{
-	return newprot;
-}
-#endif
-
 static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
@@ -119,7 +112,7 @@ static inline void change_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
 	} while (pud++, addr = next, addr != end);
 }
 
-static void change_protection(struct vm_area_struct *vma,
+static void change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
 {
@@ -141,6 +134,20 @@ static void change_protection(struct vm_area_struct *vma,
 	flush_tlb_range(vma, start, end);
 }
 
+void change_protection(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end, pgprot_t newprot,
+		       int dirty_accountable)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	mmu_notifier_invalidate_range_start(mm, start, end);
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_change_protection(vma, start, end, newprot);
+	else
+		change_protection_range(vma, start, end, newprot, dirty_accountable);
+	mmu_notifier_invalidate_range_end(mm, start, end);
+}
+
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	unsigned long start, unsigned long end, unsigned long newflags)
@@ -213,12 +220,8 @@ success:
 		dirty_accountable = 1;
 	}
 
-	mmu_notifier_invalidate_range_start(mm, start, end);
-	if (is_vm_hugetlb_page(vma))
-		hugetlb_change_protection(vma, start, end, vma->vm_page_prot);
-	else
-		change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable);
-	mmu_notifier_invalidate_range_end(mm, start, end);
+	change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable);
+
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
 	perf_event_mmap(vma);
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index e642627..c1283dd 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -88,7 +88,8 @@ pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
 {
 	pte_t pte;
 	pte = ptep_get_and_clear((vma)->vm_mm, address, ptep);
-	flush_tlb_page(vma, address);
+	if (pte_accessible(pte))
+		flush_tlb_page(vma, address);
 	return pte;
 }
 #endif
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c737057..8fafa32 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -729,7 +729,6 @@ const char * const vmstat_text[] = {
 	"numa_hit",
 	"numa_miss",
 	"numa_foreign",
-	"numa_interleave",
 	"numa_local",
 	"numa_other",
 #endif

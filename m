Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1DYUYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34008 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab1DYUYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:20 -0400
Message-Id: <20110425200234.383523265@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 032/173] x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 831d52bc153971b70e64eccfbed2b232394f22f8 upstream.

Clearing the cpu in prev's mm_cpumask early will avoid the flush tlb
IPI's while the cr3 is still pointing to the prev mm.  And this window
can lead to the possibility of bogus TLB fills resulting in strange
failures.  One such problematic scenario is mentioned below.

 T1. CPU-1 is context switching from mm1 to mm2 context and got a NMI
     etc between the point of clearing the cpu from the mm_cpumask(mm1)
     and before reloading the cr3 with the new mm2.

 T2. CPU-2 is tearing down a specific vma for mm1 and will proceed with
     flushing the TLB for mm1.  It doesn't send the flush TLB to CPU-1
     as it doesn't see that cpu listed in the mm_cpumask(mm1).

 T3. After the TLB flush is complete, CPU-2 goes ahead and frees the
     page-table pages associated with the removed vma mapping.

 T4. CPU-2 now allocates those freed page-table pages for something
     else.

 T5. As the CR3 and TLB caches for mm1 is still active on CPU-1, CPU-1
     can potentially speculate and walk through the page-table caches
     and can insert new TLB entries.  As the page-table pages are
     already freed and being used on CPU-2, this page walk can
     potentially insert a bogus global TLB entry depending on the
     (random) contents of the page that is being used on CPU-2.

 T6. This bogus TLB entry being global will be active across future CR3
     changes and can result in weird memory corruption etc.

To avoid this issue, for the prev mm that is handing over the cpu to
another mm, clear the cpu from the mm_cpumask(prev) after the cr3 is
changed.

Marking it for -stable, though we haven't seen any reported failure that
can be attributed to this.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/mmu_context.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/include/asm-x86/mmu_context_32.h
===================================================================
--- longterm-2.6.27.orig/include/asm-x86/mmu_context_32.h	2011-01-23 10:52:33.000000000 +0100
+++ longterm-2.6.27/include/asm-x86/mmu_context_32.h	2011-04-25 13:24:51.827278137 +0200
@@ -17,8 +17,6 @@
 	int cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
 		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_OK;
 		per_cpu(cpu_tlbstate, cpu).active_mm = next;
@@ -28,6 +26,9 @@
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpu_clear(cpu, prev->cpu_vm_mask);
+
 		/*
 		 * load the LDT, if the LDT is different:
 		 */
Index: longterm-2.6.27/include/asm-x86/mmu_context_64.h
===================================================================
--- longterm-2.6.27.orig/include/asm-x86/mmu_context_64.h	2011-01-23 10:52:33.000000000 +0100
+++ longterm-2.6.27/include/asm-x86/mmu_context_64.h	2011-04-25 13:25:00.775278127 +0200
@@ -16,8 +16,6 @@
 {
 	unsigned cpu = smp_processor_id();
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
 		write_pda(mmu_state, TLBSTATE_OK);
 		write_pda(active_mm, next);
@@ -25,6 +23,9 @@
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpu_clear(cpu, prev->cpu_vm_mask);
+
 		if (unlikely(next->context.ldt != prev->context.ldt))
 			load_LDT_nolock(&next->context);
 	}



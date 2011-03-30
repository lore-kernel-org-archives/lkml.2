Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab1C3VHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab1C3VHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236782"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: suresh.b.siddha@intel.com, mingo@elte.hu, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [86/275] x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
Message-Id: <20110330210524.3D67F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mmu_context.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/x86/include/asm/mmu_context.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/mmu_context.h	2011-03-29 22:51:35.790807371 -0700
+++ linux-2.6.35.y/arch/x86/include/asm/mmu_context.h	2011-03-29 23:02:59.928302005 -0700
@@ -36,8 +36,6 @@
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		percpu_write(cpu_tlbstate.active_mm, next);
@@ -47,6 +45,9 @@
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+
 		/*
 		 * load the LDT, if the LDT is different:
 		 */

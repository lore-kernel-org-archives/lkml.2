Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1BPAZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:59 -0500
Received: from kroah.org ([198.145.64.141]:49938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab1BPAZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:51 2011
Message-Id: <20110216001451.473222737@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [264/272] x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -36,8 +36,6 @@ static inline void switch_mm(struct mm_s
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		percpu_write(cpu_tlbstate.active_mm, next);
@@ -47,6 +45,9 @@ static inline void switch_mm(struct mm_s
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+
 		/*
 		 * load the LDT, if the LDT is different:
 		 */



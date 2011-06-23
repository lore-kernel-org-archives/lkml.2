Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1FWSPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:15:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:34419 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1FWRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 080/247] x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
Date: Thu, 23 Jun 2011 13:32:28 -0400
Message-Id: <1308850515-15242-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/mmu_context.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4a2d4e0..8b5393e 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -36,8 +36,6 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		percpu_write(cpu_tlbstate.active_mm, next);
@@ -47,6 +45,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
+		/* stop flush ipis for the previous mm */
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+
 		/*
 		 * load the LDT, if the LDT is different:
 		 */
-- 
1.7.4.4


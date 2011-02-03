Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1BCS1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:27:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:39516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab1BCS1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:27:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,421,1291622400"; 
   d="scan'208";a="654147406"
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
In-Reply-To: <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
	 <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
	 <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 03 Feb 2011 10:27:17 -0800
Message-Id: <1296757637.4418.1482.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 20:03 -0800, Linus Torvalds wrote:
> On Wed, Feb 2, 2011 at 5:55 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > This looks pointless. Explain why this matters. Global entries are
> > never per-mm, so any global entries can never care about the
> > mm_cpumask.
> >
> > And for any normal entries it doesn't matter if the IPI gets lost,
> > since the TLB will be flushed (immediately afterwards) by the cr3
> > write.
> 
> Actually, for normal entries I could well imagine the code that wants
> to do a flush before freeing the page caring.
> 
> So I think the _patch_ may be correct, but the changelog is definitely
> not correct, and needs serious surgery to explain what the bug that
> this fixes actually is.

Linus, I updated the changelog to explain the failing case in more
detail. Please review. Thanks.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, mm: avoid stale tlb entries by clearing prev mm_cpumask after switching mm

Clearing the cpu in prev's mm_cpumask early will avoid the flush tlb IPI's while
the cr3 is still pointing to the prev mm. And this window can lead
to the stale (global) TLB entries in the scenarios like the one mentioned
below.

T1. CPU-1 is context switching from mm1 to mm2 context and got a NMI etc
between the point of clearing the cpu from the mm_cpumask(mm1) and before
reloading the cr3 with the new mm2.

T2. CPU-2 is tearing down a specific vma for mm1 and will proceed with flushing
the TLB for mm1. It doesn't send the flush TLB to CPU-1 as it doesn't see that
cpu listed in the mm_cpumask(mm1)

T3. After the TLB flush is complete, CPU-2 goes ahead and frees the
page-table pages associated with the removed vma mapping.

T4. CPU-2 now allocates those freed page-table pages for something else.

T5. As the CR3 and TLB caches for mm1 is still active on CPU-1, CPU-1 can
potentially speculate and walk through the page-table caches and can
insert new TLB entries. As the page-table pages are already freed and being
used on CPU-2, this page walk can potentially insert a stale global TLB entry 
depending on the contents of the page that is being used on CPU-2

T6. This stale TLB entry being global will be active across future CR3
changes and can result in weird memory corruption etc.

To avoid this issue, for the prev mm that is handing over the cpu to another mm,
clear the cpu from the mm_cpumask(prev) after the cr3 is changed.

Marking it for -stable, though we haven't seen any reported failure that
can be attributed to this.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org	[v2.6.32+]
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



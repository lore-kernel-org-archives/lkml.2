Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1BBUHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:07:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:26789 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1BBUHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,415,1291622400"; 
   d="scan'208";a="883731617"
Subject: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 02 Feb 2011 12:07:27 -0800
Message-Id: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the prev mm that is handing over the cpu to another mm, clear the cpu
from the mm_cpumask(prev) after the cr3 is changed.

Otherwise, clearing the mm_cpumask early will avoid the flush tlb IPI's while
the cr3 and TLB's are still pointing to the prev mm. And this window can lead
to the stale (global) TLB entries.

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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab2CVXcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:32:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:38224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2CVXca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:32:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="122207242"
Subject: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 16:33:39 -0700
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, tlb: switch cr3 in leave_mm() only when needed

Currently leave_mm() unconditionally switches the cr3 to swapper_pg_dir.
But there is no need to change the cr3, if we already left that mm.

intel_idle() for example calls leave_mm() on every deep c-state entry where
the CPU flushes the TLB for us. Similarly flush_tlb_all() was also calling
leave_mm() whenever the TLB is in LAZY state. Both these paths will be
improved with this change.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/tlb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..ad695cc 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -61,11 +61,11 @@ static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
  */
 void leave_mm(int cpu)
 {
+	struct mm_struct *active_mm = percpu_read(cpu_tlbstate.active_mm);
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
-	cpumask_clear_cpu(cpu,
-			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
-	load_cr3(swapper_pg_dir);
+	if (cpumask_test_and_clear_cpu(cpu, mm_cpumask(active_mm)))
+		load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
 



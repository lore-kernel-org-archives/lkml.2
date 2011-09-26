Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1IZCZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 22:25:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:40995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1IZCZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 22:25:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,441,1312182000"; 
   d="scan'208";a="70616716"
Subject: [patch] x86: tlb flush avoid superflous leave_mm() --resend
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 10:30:34 +0800
Message-ID: <1317004234.29510.173.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If just one page VA tlb is required to be flushed and current task is in lazy
TLB state, doing leave_mm() is superfluous because it flushes the whole TLB.
This can reduce some TLB miss.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..3041665 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -153,13 +153,13 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 */
 
 	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (f->flush_va == TLB_FLUSH_ALL)
+		if (f->flush_va == TLB_FLUSH_ALL) {
+			if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 				local_flush_tlb();
 			else
-				__flush_tlb_one(f->flush_va);
+				leave_mm(cpu);
 		} else
-			leave_mm(cpu);
+			__flush_tlb_one(f->flush_va);
 	}
 out:
 	ack_APIC_irq();
@@ -306,12 +306,8 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 
 	preempt_disable();
 
-	if (current->active_mm == mm) {
-		if (current->mm)
-			__flush_tlb_one(va);
-		else
-			leave_mm(smp_processor_id());
-	}
+	if (current->active_mm == mm)
+		__flush_tlb_one(va);
 
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, va);



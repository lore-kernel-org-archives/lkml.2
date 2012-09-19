Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2ISJGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:06:50 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53989 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2ISJGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:06:49 -0400
X-AuditID: b753bd60-932c5ba0000047ca-8a-50598aa31023
X-AuditID: b753bd60-932c5ba0000047ca-8a-50598aa31023
Subject: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
To: x86@kernel.org
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Alex Shi <alex.shi@intel.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 19 Sep 2012 18:04:17 +0900
Message-ID: <20120919090417.24381.87388.stgit@hpxw>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As TLB shootdown requests to other CPU cores are now done using function call
interrupts, TLB shootdowns entry in /proc/interrupts is always shown as 0.

This behavior change was introduced by commit 52aec3308db8 ("x86/tlb:
replace INVALIDATE_TLB_VECTOR by CALL_FUNCTION_VECTOR").

This patch reverts TLB shootdowns entry in /proc/interrupts to count TLB
shootdowns separately from the other function call interrupts.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/hardirq.h |    2 +-
 arch/x86/kernel/irq.c          |    5 +++--
 arch/x86/mm/tlb.c              |    3 +++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index d3895db..af60ab5 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -18,7 +18,7 @@ typedef struct {
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
-	unsigned int irq_tlb_count;
+	unsigned int irq_tlb_count;	/* double-counted in irq_call_count */
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	unsigned int irq_thermal_count;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..6dfa8b1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -92,7 +92,8 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count);
+		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
+					irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  Function call interrupts\n");
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
@@ -147,7 +148,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
-	sum += irq_stats(cpu)->irq_tlb_count;
+	/* irq_tlb_count is already added to irq_call_count */
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	sum += irq_stats(cpu)->irq_thermal_count;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..0a054db 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,6 +98,9 @@ static void flush_tlb_func(void *info)
 {
 	struct flush_tlb_info *f = info;
 
+	/* irq_call_cnt is also incremented; be subtracted on display */
+	inc_irq_stat(irq_tlb_count);
+
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 


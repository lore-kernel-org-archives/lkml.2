Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2I1GOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:14:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab2I1GOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:14:17 -0400
Date: Thu, 27 Sep 2012 23:13:58 -0700
From: tip-bot for Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Message-ID: <tip-fd0f5869724ff6195c6e7f12f8287c66a132e0ba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        tomoki.sekiyama.qu@hitachi.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com, tomoki.sekiyama.qu@hitachi.com,
        hpa@linux.intel.com
In-Reply-To: <20120926021128.22212.20440.stgit@hpxw>
References: <20120926021128.22212.20440.stgit@hpxw>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Distinguish TLB shootdown interrupts from other functions call interrupts
Git-Commit-ID: fd0f5869724ff6195c6e7f12f8287c66a132e0ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 27 Sep 2012 23:14:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd0f5869724ff6195c6e7f12f8287c66a132e0ba
Gitweb:     http://git.kernel.org/tip/fd0f5869724ff6195c6e7f12f8287c66a132e0ba
Author:     Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
AuthorDate: Wed, 26 Sep 2012 11:11:28 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Sep 2012 22:52:34 -0700

x86: Distinguish TLB shootdown interrupts from other functions call interrupts

As TLB shootdown requests to other CPU cores are now using function call
interrupts, TLB shootdowns entry in /proc/interrupts is always shown as 0.

This behavior change was introduced by commit 52aec3308db8 ("x86/tlb:
replace INVALIDATE_TLB_VECTOR by CALL_FUNCTION_VECTOR").

This patch reverts TLB shootdowns entry in /proc/interrupts to count TLB
shootdowns separately from the other function call interrupts.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Link: http://lkml.kernel.org/r/20120926021128.22212.20440.stgit@hpxw
Acked-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/hardirq.h |    4 ++++
 arch/x86/kernel/irq.c          |    4 ++--
 arch/x86/mm/tlb.c              |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index d3895db..81f04ce 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -18,6 +18,10 @@ typedef struct {
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
+	/*
+	 * irq_tlb_count is double-counted in irq_call_count, so it must be
+	 * subtracted from irq_call_count when displaying irq_call_count
+	 */
 	unsigned int irq_tlb_count;
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1f5f1d5..355b13f 100644
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
@@ -147,7 +148,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
-	sum += irq_stats(cpu)->irq_tlb_count;
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	sum += irq_stats(cpu)->irq_thermal_count;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a085c56..0777f04 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,6 +98,8 @@ static void flush_tlb_func(void *info)
 {
 	struct flush_tlb_info *f = info;
 
+	inc_irq_stat(irq_tlb_count);
+
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 

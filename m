Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1ESNzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:55:39 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:50612
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933245Ab1ESNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:55:32 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: [PATCH 1/7] powerpc: make irq_choose_cpu() available to all PIC drivers
Date: Thu, 19 May 2011 08:54:26 -0500
Message-ID: <1305813272-31826-2-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305813272-31826-1-git-send-email-timur@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stuart Yoder <stuart.yoder@freescale.com>

Move irq_choose_cpu() into arch/powerpc/kernel/irq.c so that it can be used
by other PIC drivers.  The function is not MPIC-specific.

Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
Signed-off-by: Timur Tabi <timur@freescale.com>
---
 arch/powerpc/include/asm/irq.h |    2 ++
 arch/powerpc/kernel/irq.c      |   35 +++++++++++++++++++++++++++++++++++
 arch/powerpc/sysdev/mpic.c     |   36 ------------------------------------
 3 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 67ab5fb..1792d84 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -342,5 +342,7 @@ extern int call_handle_irq(int irq, void *p1,
 			   struct thread_info *tp, void *func);
 extern void do_IRQ(struct pt_regs *regs);
 
+int irq_choose_cpu(const struct cpumask *mask);
+
 #endif /* _ASM_IRQ_H */
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index f621b7d..ce9bf93 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -870,6 +870,41 @@ unsigned int irq_find_mapping(struct irq_host *host,
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
+#ifdef CONFIG_SMP
+int irq_choose_cpu(const struct cpumask *mask)
+{
+	int cpuid;
+
+	if (cpumask_equal(mask, cpu_all_mask)) {
+		static int irq_rover;
+		static DEFINE_RAW_SPINLOCK(irq_rover_lock);
+		unsigned long flags;
+
+		/* Round-robin distribution... */
+do_round_robin:
+		raw_spin_lock_irqsave(&irq_rover_lock, flags);
+
+		irq_rover = cpumask_next(irq_rover, cpu_online_mask);
+		if (irq_rover >= nr_cpu_ids)
+			irq_rover = cpumask_first(cpu_online_mask);
+
+		cpuid = irq_rover;
+
+		raw_spin_unlock_irqrestore(&irq_rover_lock, flags);
+	} else {
+		cpuid = cpumask_first_and(mask, cpu_online_mask);
+		if (cpuid >= nr_cpu_ids)
+			goto do_round_robin;
+	}
+
+	return get_hard_smp_processor_id(cpuid);
+}
+#else
+int irq_choose_cpu(const struct cpumask *mask)
+{
+	return hard_smp_processor_id();
+}
+#endif
 
 unsigned int irq_radix_revmap_lookup(struct irq_host *host,
 				     irq_hw_number_t hwirq)
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index f91c065..5ae1142 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -571,42 +571,6 @@ static void __init mpic_scan_ht_pics(struct mpic *mpic)
 
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
-#ifdef CONFIG_SMP
-static int irq_choose_cpu(const struct cpumask *mask)
-{
-	int cpuid;
-
-	if (cpumask_equal(mask, cpu_all_mask)) {
-		static int irq_rover = 0;
-		static DEFINE_RAW_SPINLOCK(irq_rover_lock);
-		unsigned long flags;
-
-		/* Round-robin distribution... */
-	do_round_robin:
-		raw_spin_lock_irqsave(&irq_rover_lock, flags);
-
-		irq_rover = cpumask_next(irq_rover, cpu_online_mask);
-		if (irq_rover >= nr_cpu_ids)
-			irq_rover = cpumask_first(cpu_online_mask);
-
-		cpuid = irq_rover;
-
-		raw_spin_unlock_irqrestore(&irq_rover_lock, flags);
-	} else {
-		cpuid = cpumask_first_and(mask, cpu_online_mask);
-		if (cpuid >= nr_cpu_ids)
-			goto do_round_robin;
-	}
-
-	return get_hard_smp_processor_id(cpuid);
-}
-#else
-static int irq_choose_cpu(const struct cpumask *mask)
-{
-	return hard_smp_processor_id();
-}
-#endif
-
 #define mpic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
 
 /* Find an mpic associated with a given linux interrupt */
-- 
1.7.3.4



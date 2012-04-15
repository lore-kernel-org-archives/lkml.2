Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2DOGJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:09:31 -0400
Received: from [124.207.24.138] ([124.207.24.138]:38371 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DOGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:09:29 -0400
From: Lin Ming <mlin@ss.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org
Subject: [PATCH 2/2] xen: implement IRQ_WORK_VECTOR handler
Date: Sun, 15 Apr 2012 14:09:32 +0800
Message-Id: <1334470172-3861-3-git-send-email-mlin@ss.pku.edu.cn>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
References: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
---
 arch/x86/include/asm/xen/events.h |    1 +
 arch/x86/xen/smp.c                |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
index 1df3541..cc146d5 100644
--- a/arch/x86/include/asm/xen/events.h
+++ b/arch/x86/include/asm/xen/events.h
@@ -6,6 +6,7 @@ enum ipi_vector {
 	XEN_CALL_FUNCTION_VECTOR,
 	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 	XEN_SPIN_UNLOCK_VECTOR,
+	XEN_IRQ_WORK_VECTOR,
 
 	XEN_NR_IPIS,
 };
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 2dc6628..92ad12d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
+#include <linux/irq_work.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
@@ -41,10 +42,12 @@ cpumask_var_t xen_cpu_initialized_map;
 static DEFINE_PER_CPU(int, xen_resched_irq);
 static DEFINE_PER_CPU(int, xen_callfunc_irq);
 static DEFINE_PER_CPU(int, xen_callfuncsingle_irq);
+static DEFINE_PER_CPU(int, xen_irq_work);
 static DEFINE_PER_CPU(int, xen_debug_irq) = -1;
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
+static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
 
 /*
  * Reschedule call back.
@@ -143,6 +146,17 @@ static int xen_smp_intr_init(unsigned int cpu)
 		goto fail;
 	per_cpu(xen_callfuncsingle_irq, cpu) = rc;
 
+	callfunc_name = kasprintf(GFP_KERNEL, "irqwork%d", cpu);
+	rc = bind_ipi_to_irqhandler(XEN_IRQ_WORK_VECTOR,
+				    cpu,
+				    xen_irq_work_interrupt,
+				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    callfunc_name,
+				    NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(xen_irq_work, cpu) = rc;
+
 	return 0;
 
  fail:
@@ -155,6 +169,8 @@ static int xen_smp_intr_init(unsigned int cpu)
 	if (per_cpu(xen_callfuncsingle_irq, cpu) >= 0)
 		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu),
 				       NULL);
+	if (per_cpu(xen_irq_work, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
 
 	return rc;
 }
@@ -509,6 +525,9 @@ static inline int xen_map_vector(int vector)
 	case CALL_FUNCTION_SINGLE_VECTOR:
 		xen_vector = XEN_CALL_FUNCTION_SINGLE_VECTOR;
 		break;
+	case IRQ_WORK_VECTOR:
+		xen_vector = XEN_IRQ_WORK_VECTOR;
+		break;
 	default:
 		xen_vector = -1;
 		printk(KERN_ERR "xen: vector 0x%x is not implemented\n",
@@ -588,6 +607,16 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id)
+{
+	irq_enter();
+	inc_irq_stat(apic_irq_work_irqs);
+	irq_work_run();
+	irq_exit();
+
+	return IRQ_HANDLED;
+}
+
 static const struct smp_ops xen_smp_ops __initconst = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
@@ -634,6 +663,7 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
 	native_cpu_die(cpu);
 }
 
-- 
1.7.2.5


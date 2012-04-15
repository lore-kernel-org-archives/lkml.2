Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2DOGJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:09:54 -0400
Received: from [124.207.24.138] ([124.207.24.138]:38370 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2DOGJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:09:30 -0400
From: Lin Ming <mlin@ss.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org
Subject: [PATCH 1/2] xen: implement apic ipi interface
Date: Sun, 15 Apr 2012 14:09:31 +0800
Message-Id: <1334470172-3861-2-git-send-email-mlin@ss.pku.edu.cn>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
References: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Guthro <ben@guthro.net>

Map native ipi vector to xen vector.
Implement apic ipi interface with xen_send_IPI_one.

Signed-off-by: Ben Guthro <ben@guthro.net>
Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
---

Ben,

This patch was taken from part of your patch at:
https://lkml.org/lkml/2012/2/10/681

Is it OK that I added your SOB?

I did some change to map native ipi vector to xen vector.
Could you please review?

Thanks.

 arch/x86/xen/enlighten.c |    7 ++++
 arch/x86/xen/smp.c       |   81 +++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/xen/smp.h       |   12 +++++++
 3 files changed, 96 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/xen/smp.h

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f51beb..be7dbc8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -74,6 +74,7 @@
 
 #include "xen-ops.h"
 #include "mmu.h"
+#include "smp.h"
 #include "multicalls.h"
 
 EXPORT_SYMBOL_GPL(hypercall_page);
@@ -849,6 +850,12 @@ static void set_xen_basic_apic_ops(void)
 	apic->icr_write = xen_apic_icr_write;
 	apic->wait_icr_idle = xen_apic_wait_icr_idle;
 	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
+
+	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
+	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
+	apic->send_IPI_mask = xen_send_IPI_mask;
+	apic->send_IPI_all = xen_send_IPI_all;
+	apic->send_IPI_self = xen_send_IPI_self;
 }
 
 #endif
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 5fac691..2dc6628 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -465,8 +465,8 @@ static void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(const struct cpumask *mask,
-			      enum ipi_vector vector)
+static void __xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector)
 {
 	unsigned cpu;
 
@@ -478,7 +478,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 {
 	int cpu;
 
-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+	__xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
@@ -491,10 +491,83 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(cpumask_of(cpu),
+	__xen_send_IPI_mask(cpumask_of(cpu),
 			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
+static inline int xen_map_vector(int vector)
+{
+	int xen_vector;
+
+	switch (vector) {
+	case RESCHEDULE_VECTOR:
+		xen_vector = XEN_RESCHEDULE_VECTOR;
+		break;
+	case CALL_FUNCTION_VECTOR:
+		xen_vector = XEN_CALL_FUNCTION_VECTOR;
+		break;
+	case CALL_FUNCTION_SINGLE_VECTOR:
+		xen_vector = XEN_CALL_FUNCTION_SINGLE_VECTOR;
+		break;
+	default:
+		xen_vector = -1;
+		printk(KERN_ERR "xen: vector 0x%x is not implemented\n",
+			vector);
+	}
+
+	return xen_vector;
+}
+
+void xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector)
+{
+	int xen_vector = xen_map_vector(vector);
+
+	if (xen_vector >= 0)
+		__xen_send_IPI_mask(mask, xen_vector);
+}
+
+void xen_send_IPI_all(int vector)
+{
+	int xen_vector = xen_map_vector(vector);
+
+	if (xen_vector >= 0)
+		__xen_send_IPI_mask(cpu_online_mask, xen_vector);
+}
+
+void xen_send_IPI_self(int vector)
+{
+	int xen_vector = xen_map_vector(vector);
+
+	if (xen_vector >= 0)
+		xen_send_IPI_one(smp_processor_id(), xen_vector);
+}
+
+void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
+				int vector)
+{
+	unsigned cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	if (!(num_online_cpus() > 1))
+		return;
+
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+		if (this_cpu == cpu)
+			continue;
+
+		xen_smp_send_call_function_single_ipi(cpu);
+	}
+}
+
+void xen_send_IPI_allbutself(int vector)
+{
+	int xen_vector = xen_map_vector(vector);
+
+	if (xen_vector >= 0)
+		xen_send_IPI_mask_allbutself(cpu_online_mask, xen_vector);
+}
+
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
new file mode 100644
index 0000000..8981a76
--- /dev/null
+++ b/arch/x86/xen/smp.h
@@ -0,0 +1,12 @@
+#ifndef _XEN_SMP_H
+
+extern void xen_send_IPI_mask(const struct cpumask *mask,
+			      int vector);
+extern void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
+				int vector);
+extern void xen_send_IPI_allbutself(int vector);
+extern void physflat_send_IPI_allbutself(int vector);
+extern void xen_send_IPI_all(int vector);
+extern void xen_send_IPI_self(int vector);
+
+#endif
-- 
1.7.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2BWRmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:42:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:31087 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab2BWRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:42:39 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325480400"; 
   d="scan'208";a="22387552"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, david.vrabel@citrix.com,
        Ian.Campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH-WIP 07/13] xen/arm: receive xen events on arm
Date: Thu, 23 Feb 2012 17:48:28 +0000
Message-ID: <1330019314-20865-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile events.c and use IRQ 32 to receive events notifications.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/events.h |    9 +++++++++
 drivers/xen/events.c              |   36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
index efa7c61..94b4e90 100644
--- a/arch/arm/include/asm/xen/events.h
+++ b/arch/arm/include/asm/xen/events.h
@@ -1,9 +1,18 @@
 #ifndef _ASM_ARM_XEN_EVENTS_H
 #define _ASM_ARM_XEN_EVENTS_H
 
+#include <asm/ptrace.h>
+
 enum ipi_vector {
+	XEN_PLACEHOLDER_VECTOR,
+
 	/* Xen IPIs go here */
 	XEN_NR_IPIS,
 };
 
+static inline int xen_irqs_disabled(struct pt_regs *regs)
+{
+	return raw_irqs_disabled_flags(regs->ARM_cpsr);
+}
+
 #endif /* _ASM_ARM_XEN_EVENTS_H */
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6e075cd..18139ee 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -31,13 +31,15 @@
 #include <linux/irqnr.h>
 #include <linux/pci.h>
 
+#ifdef CONFIG_X86
 #include <asm/desc.h>
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
 #include <asm/io_apic.h>
-#include <asm/sync_bitops.h>
 #include <asm/xen/pci.h>
+#endif
+#include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
@@ -49,6 +51,8 @@
 #include <xen/interface/event_channel.h>
 #include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/hvm/params.h>
+#include <xen/interface/physdev.h>
+#include <xen/interface/sched.h>
 
 /*
  * This lock protects updates to the following mapping and reference-count
@@ -801,10 +805,12 @@ EXPORT_SYMBOL_GPL(xen_pirq_from_irq);
 int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	mutex_lock(&irq_mapping_update_lock);
 
 	irq = evtchn_to_irq[evtchn];
+	irq_clear_status_flags(irq, IRQ_NOREQUEST);
 
 	if (irq == -1) {
 		irq = xen_allocate_irq_dynamic();
@@ -813,6 +819,8 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 
 		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_edge_irq, "event");
+		desc = irq_to_desc(irq);
+		irq_clear_status_flags(irq, IRQ_NOREQUEST);
 
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
@@ -1282,7 +1290,9 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+#ifdef CONFIG_X86
 	exit_idle();
+#endif
 	irq_enter();
 
 	__xen_evtchn_do_upcall();
@@ -1707,6 +1717,7 @@ void __init xen_init_IRQ(void)
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		mask_evtchn(i);
 
+#ifdef CONFIG_X86
 	if (xen_hvm_domain()) {
 		xen_callback_vector();
 		native_init_IRQ();
@@ -1718,4 +1729,27 @@ void __init xen_init_IRQ(void)
 		if (xen_initial_domain())
 			pci_xen_initial_domain();
 	}
+#endif
 }
+#ifdef CONFIG_ARM
+#define IRQ_EVTCHN_CALLBACK 63
+irqreturn_t xen_arm_callback(int irq, void *arg)
+{
+	__xen_evtchn_do_upcall();
+	return 0;
+}
+
+int __init xen_init_IRQ_arm(void)
+{
+	int rc;
+	xen_init_IRQ();
+	rc = request_irq(IRQ_EVTCHN_CALLBACK, xen_arm_callback,
+			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
+			"events", "events");	
+	if (rc) {
+		printk(KERN_ERR "Error requesting IRQ %d\n", IRQ_EVTCHN_CALLBACK);
+	}
+	return rc;
+}
+core_initcall(xen_init_IRQ_arm);
+#endif
-- 
1.7.2.5


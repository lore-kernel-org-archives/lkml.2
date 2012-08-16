Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2HPP5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:57:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18584 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936Ab2HPP46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:56:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="34872811"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 15/25] xen/arm: receive Xen events on ARM
Date: Thu, 16 Aug 2012 16:36:07 +0100
Message-ID: <1345131377-14713-15-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile events.c on ARM.
Parse, map and enable the IRQ to get event notifications from the device
tree (node "/xen").

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/events.h |   18 ++++++++++++++++++
 arch/arm/xen/enlighten.c          |   33 +++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c          |    1 +
 arch/x86/xen/irq.c                |    1 +
 arch/x86/xen/xen-ops.h            |    1 -
 drivers/xen/events.c              |   17 ++++++++++++++---
 include/xen/events.h              |    2 ++
 7 files changed, 69 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/include/asm/xen/events.h

diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
new file mode 100644
index 0000000..94b4e90
--- /dev/null
+++ b/arch/arm/include/asm/xen/events.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_ARM_XEN_EVENTS_H
+#define _ASM_ARM_XEN_EVENTS_H
+
+#include <asm/ptrace.h>
+
+enum ipi_vector {
+	XEN_PLACEHOLDER_VECTOR,
+
+	/* Xen IPIs go here */
+	XEN_NR_IPIS,
+};
+
+static inline int xen_irqs_disabled(struct pt_regs *regs)
+{
+	return raw_irqs_disabled_flags(regs->ARM_cpsr);
+}
+
+#endif /* _ASM_ARM_XEN_EVENTS_H */
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 2e65e8d..14af29d 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -1,4 +1,5 @@
 #include <xen/xen.h>
+#include <xen/events.h>
 #include <xen/grant_table.h>
 #include <xen/hvm.h>
 #include <xen/interface/xen.h>
@@ -9,6 +10,8 @@
 #include <xen/xenbus.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -33,6 +36,8 @@ EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
 EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 
+static __read_mostly int xen_events_irq = -1;
+
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       unsigned long mfn, int nr,
@@ -74,6 +79,9 @@ static int __init xen_guest_init(void)
 	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
 		return 0;
 	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
+	xen_events_irq = irq_of_parse_and_map(node, 0);
+	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
+			version, xen_events_irq, xen_hvm_resume_frames);
 	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
@@ -115,3 +123,28 @@ static int __init xen_guest_init(void)
 	return 0;
 }
 core_initcall(xen_guest_init);
+
+static irqreturn_t xen_arm_callback(int irq, void *arg)
+{
+	xen_hvm_evtchn_do_upcall();
+	return IRQ_HANDLED;
+}
+
+static int __init xen_init_events(void)
+{
+	if (!xen_domain() || xen_events_irq < 0)
+		return -ENODEV;
+
+	xen_init_IRQ();
+
+	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
+			"events", xen_vcpu)) {
+		pr_err("Error requesting IRQ %d\n", xen_events_irq);
+		return -EINVAL;
+	}
+
+	enable_percpu_irq(xen_events_irq, 0);
+
+	return 0;
+}
+postcore_initcall(xen_init_events);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ff962d4..9f8b0ef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -33,6 +33,7 @@
 #include <linux/memblock.h>
 
 #include <xen/xen.h>
+#include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 1573376..01a4dc0 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -5,6 +5,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
+#include <xen/events.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 202d4c1..2368295 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -35,7 +35,6 @@ void xen_set_pat(u64);
 
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
-void __init xen_init_IRQ(void);
 void xen_enable_sysenter(void);
 void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7da65d3..c3516d3 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -31,14 +31,16 @@
 #include <linux/irqnr.h>
 #include <linux/pci.h>
 
+#ifdef CONFIG_X86
 #include <asm/desc.h>
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
 #include <asm/io_apic.h>
-#include <asm/sync_bitops.h>
 #include <asm/xen/page.h>
 #include <asm/xen/pci.h>
+#endif
+#include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
@@ -50,6 +52,9 @@
 #include <xen/interface/event_channel.h>
 #include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/hvm/params.h>
+#include <xen/interface/physdev.h>
+#include <xen/interface/sched.h>
+#include <asm/hw_irq.h>
 
 /*
  * This lock protects updates to the following mapping and reference-count
@@ -1377,7 +1382,9 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+#ifdef CONFIG_X86
 	exit_idle();
+#endif
 	irq_enter();
 
 	__xen_evtchn_do_upcall();
@@ -1786,9 +1793,9 @@ void xen_callback_vector(void)
 void xen_callback_vector(void) {}
 #endif
 
-void __init xen_init_IRQ(void)
+void xen_init_IRQ(void)
 {
-	int i, rc;
+	int i;
 
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
 				    GFP_KERNEL);
@@ -1804,6 +1811,7 @@ void __init xen_init_IRQ(void)
 
 	pirq_needs_eoi = pirq_needs_eoi_flag;
 
+#ifdef CONFIG_X86
 	if (xen_hvm_domain()) {
 		xen_callback_vector();
 		native_init_IRQ();
@@ -1811,6 +1819,7 @@ void __init xen_init_IRQ(void)
 		 * __acpi_register_gsi can point at the right function */
 		pci_xen_hvm_init();
 	} else {
+		int rc;
 		struct physdev_pirq_eoi_gmfn eoi_gmfn;
 
 		irq_ctx_init(smp_processor_id());
@@ -1826,4 +1835,6 @@ void __init xen_init_IRQ(void)
 		} else
 			pirq_needs_eoi = pirq_check_eoi_map;
 	}
+#endif
 }
+EXPORT_SYMBOL_GPL(xen_init_IRQ);
diff --git a/include/xen/events.h b/include/xen/events.h
index 04399b2..c6bfe01 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -109,4 +109,6 @@ int xen_irq_from_gsi(unsigned gsi);
 /* Determine whether to ignore this IRQ if it is passed to a guest. */
 int xen_test_irq_shared(int irq);
 
+/* initialize Xen IRQ subsystem */
+void xen_init_IRQ(void);
 #endif	/* _XEN_EVENTS_H */
-- 
1.7.2.5


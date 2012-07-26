Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2GZP4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:56:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:62588 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2GZP4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:56:50 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32691187"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 15/24] xen/arm: receive Xen events on ARM
Date: Thu, 26 Jul 2012 16:33:57 +0100
Message-ID: <1343316846-25860-15-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile events.c on ARM.
Parse, map and enable the IRQ to get event notifications from the device
tree (node "/xen").

On ARM Linux irqs are not enabled by default:

- call enable_percpu_irq for xen_events_irq (drivers are supposed
to call enable_irq after request_irq);

- reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
irq_startup, that is responsible for calling irq_unmask at startup time.
As a result event channels remain masked.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   33 +++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |    1 +
 arch/x86/xen/irq.c       |    1 +
 arch/x86/xen/xen-ops.h   |    1 -
 drivers/xen/events.c     |   18 +++++++++++++++---
 include/xen/events.h     |    2 ++
 6 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 854af1e..60d6d36 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -7,8 +7,11 @@
 #include <xen/grant_table.h>
 #include <xen/hvm.h>
 #include <xen/xenbus.h>
+#include <xen/events.h>
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
@@ -65,6 +70,9 @@ int __init xen_guest_init(void)
 	if (of_address_to_resource(node, 0, &res))
 		return -EINVAL;
 	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
+	xen_events_irq = irq_of_parse_and_map(node, 0);
+	pr_info("Xen support found, events_irq=%d gnttab_frame_pfn=%lx\n",
+			xen_events_irq, xen_hvm_resume_frames);
 	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
@@ -114,3 +122,28 @@ int __init xen_guest_init(void)
 }
 EXPORT_SYMBOL_GPL(xen_guest_init);
 core_initcall(xen_guest_init);
+
+static irqreturn_t xen_arm_callback(int irq, void *arg)
+{
+	xen_hvm_evtchn_do_upcall();
+	return 0;
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
index 6131d43..5a30502 100644
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
index 7da65d3..9b506b2 100644
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
@@ -834,6 +839,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		struct irq_info *info = info_for_irq(irq);
 		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
 	}
+	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
 
 out:
 	mutex_unlock(&irq_mapping_update_lock);
@@ -1377,7 +1383,9 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+#ifdef CONFIG_X86
 	exit_idle();
+#endif
 	irq_enter();
 
 	__xen_evtchn_do_upcall();
@@ -1786,9 +1794,9 @@ void xen_callback_vector(void)
 void xen_callback_vector(void) {}
 #endif
 
-void __init xen_init_IRQ(void)
+void xen_init_IRQ(void)
 {
-	int i, rc;
+	int i;
 
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
 				    GFP_KERNEL);
@@ -1804,6 +1812,7 @@ void __init xen_init_IRQ(void)
 
 	pirq_needs_eoi = pirq_needs_eoi_flag;
 
+#ifdef CONFIG_X86
 	if (xen_hvm_domain()) {
 		xen_callback_vector();
 		native_init_IRQ();
@@ -1811,6 +1820,7 @@ void __init xen_init_IRQ(void)
 		 * __acpi_register_gsi can point at the right function */
 		pci_xen_hvm_init();
 	} else {
+		int rc;
 		struct physdev_pirq_eoi_gmfn eoi_gmfn;
 
 		irq_ctx_init(smp_processor_id());
@@ -1826,4 +1836,6 @@ void __init xen_init_IRQ(void)
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


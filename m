Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0FCNNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:13:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52461 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0FCNLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:21 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908929"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 03/12] evtchn delivery on HVM
Date: Thu,  3 Jun 2010 14:10:36 +0100
Message-Id: <1275570645-27189-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:19.0335 (UTC) FILETIME=[41855370:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Set the callback to receive evtchns from Xen, using the
callback vector delivery mechanism.

The traditional way for receiving event channel notifications from Xen
is interrupts from the platform PCI device.
The callback vector is a newer alternative that allow us to receive
notifications on any vcpu and doesn't need any PCI support: we allocate
a vector exclusively to receive events, in the vector handler we don't
need to interact with the vlapic, therefore we avoid a VMEXIT.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/irq_vectors.h |    5 ++
 arch/x86/kernel/entry_32.S         |    2 +
 arch/x86/kernel/entry_64.S         |    3 +
 arch/x86/xen/enlighten.c           |   29 +++++++++++++
 arch/x86/xen/xen-ops.h             |    2 +
 drivers/xen/events.c               |   82 ++++++++++++++++++++++++++++++++---
 include/xen/events.h               |    7 +++
 include/xen/hvm.h                  |    6 +++
 include/xen/interface/features.h   |    3 +
 9 files changed, 132 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 8767d99..ab6ac1b 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -125,6 +125,11 @@
  */
 #define MCE_SELF_VECTOR			0xeb
 
+#ifdef CONFIG_XEN
+/* Xen vector callback to receive events in a HVM domain */
+#define XEN_HVM_EVTCHN_CALLBACK		0xe9
+#endif
+
 #define NR_VECTORS			 256
 
 #define FPU_IRQ				  13
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 44a8e0d..88ed128 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1147,6 +1147,8 @@ ENTRY(xen_failsafe_callback)
 .previous
 ENDPROC(xen_failsafe_callback)
 
+BUILD_INTERRUPT(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK)
+
 #endif	/* CONFIG_XEN */
 
 #ifdef CONFIG_FUNCTION_TRACER
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..d40c1e1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1329,6 +1329,9 @@ ENTRY(xen_failsafe_callback)
 	CFI_ENDPROC
 END(xen_failsafe_callback)
 
+apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
+	xen_hvm_callback_vector smp_xen_hvm_callback_vector
+
 #endif /* CONFIG_XEN */
 
 /*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c1f6545..ed34b30 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -11,6 +11,7 @@
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
 
+#include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/smp.h>
@@ -38,6 +39,7 @@
 #include <xen/interface/memory.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/hvm.h>
 #include <xen/hvc-console.h>
 
 #include <asm/paravirt.h>
@@ -78,6 +80,9 @@ struct shared_info xen_dummy_shared_info;
 
 void *xen_initial_gdt;
 
+__read_mostly int xen_have_vector_callback;
+EXPORT_SYMBOL_GPL(xen_have_vector_callback);
+
 /*
  * Point at some empty memory to start with. We map the real shared_info
  * page as soon as fixmap is up and running.
@@ -1278,6 +1283,24 @@ static void __init init_shared_info(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 }
 
+static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+	switch (action) {
+	case CPU_UP_PREPARE:
+		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
+	.notifier_call	= xen_hvm_cpu_notify,
+};
+
 void __init xen_guest_init(void)
 {
 	int r;
@@ -1291,4 +1314,10 @@ void __init xen_guest_init(void)
 		return;
 
 	init_shared_info();
+
+	if (xen_feature(XENFEAT_hvm_callback_vector))
+		xen_have_vector_callback = 1;
+	register_cpu_notifier(&xen_hvm_cpu_notifier);
+	have_vcpu_info_placement = 0;
+	x86_init.irqs.intr_init = xen_init_IRQ;
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f9153a3..0d0e0e6 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -38,6 +38,8 @@ void xen_enable_sysenter(void);
 void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
+void xen_callback_vector(void);
+
 void __init xen_build_dynamic_phys_to_machine(void);
 
 void xen_init_irq_ops(void);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index db8f506..8604604 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -29,6 +29,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 
+#include <asm/desc.h>
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
@@ -36,10 +37,14 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/xen.h>
+#include <xen/hvm.h>
 #include <xen/xen-ops.h>
 #include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
+#include <xen/interface/hvm/hvm_op.h>
+#include <xen/interface/hvm/params.h>
 
 /*
  * This lock protects updates to the following mapping and reference-count
@@ -617,17 +622,13 @@ static DEFINE_PER_CPU(unsigned, xed_nesting_count);
  * a bitset of words which contain pending event bits.  The second
  * level is a bitset of pending events themselves.
  */
-void xen_evtchn_do_upcall(struct pt_regs *regs)
+static void __xen_evtchn_do_upcall(void)
 {
 	int cpu = get_cpu();
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
  	unsigned count;
 
-	exit_idle();
-	irq_enter();
-
 	do {
 		unsigned long pending_words;
 
@@ -667,10 +668,26 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	} while(count != 1);
 
 out:
+
+	put_cpu();
+}
+
+void xen_evtchn_do_upcall(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	exit_idle();
+	irq_enter();
+
+	__xen_evtchn_do_upcall();
+
 	irq_exit();
 	set_irq_regs(old_regs);
+}
 
-	put_cpu();
+void xen_hvm_evtchn_do_upcall(void)
+{
+	__xen_evtchn_do_upcall();
 }
 
 /* Rebind a new event channel to an existing irq. */
@@ -933,6 +950,52 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
+int xen_set_callback_via(uint64_t via)
+{
+	struct xen_hvm_param a;
+	a.domid = DOMID_SELF;
+	a.index = HVM_PARAM_CALLBACK_IRQ;
+	a.value = via;
+	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
+}
+EXPORT_SYMBOL_GPL(xen_set_callback_via);
+
+void smp_xen_hvm_callback_vector(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	exit_idle();
+
+	irq_enter();
+
+	__xen_evtchn_do_upcall();
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
+/* the callback vector mechanism is a newer alternative way of receiving
+ * event channel notifications from Xen: we can receive vector callbacks
+ * on any vcpus and we don't need any PCI or IO APIC support */
+void xen_callback_vector(void)
+{
+	int rc;
+	uint64_t callback_via;
+	if (xen_have_vector_callback) {
+		callback_via = HVM_CALLBACK_VECTOR(XEN_HVM_EVTCHN_CALLBACK);
+		rc = xen_set_callback_via(callback_via);
+		if (rc) {
+			printk(KERN_ERR "request for callback vector failed\n");
+			xen_have_vector_callback = 0;
+			return;
+		}
+		printk(KERN_INFO "Xen HVM callback vector for event delivery is "
+				"enabled\n");
+		alloc_intr_gate(XEN_HVM_EVTCHN_CALLBACK, xen_hvm_callback_vector);
+	}
+}
+
 void __init xen_init_IRQ(void)
 {
 	int i;
@@ -947,5 +1010,10 @@ void __init xen_init_IRQ(void)
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		mask_evtchn(i);
 
-	irq_ctx_init(smp_processor_id());
+	if (xen_hvm_domain()) {
+		xen_callback_vector();
+		native_init_IRQ();
+	} else {
+		irq_ctx_init(smp_processor_id());
+	}
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index e68d59a..a15d932 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -56,4 +56,11 @@ void xen_poll_irq(int irq);
 /* Determine the IRQ which is bound to an event channel */
 unsigned irq_from_evtchn(unsigned int evtchn);
 
+/* Xen HVM evtchn vector callback */
+extern void xen_hvm_callback_vector(void);
+extern int xen_have_vector_callback;
+int xen_set_callback_via(uint64_t via);
+void xen_evtchn_do_upcall(struct pt_regs *regs);
+void xen_hvm_evtchn_do_upcall(void);
+
 #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/hvm.h b/include/xen/hvm.h
index 6b0d418..d0cf7a6 100644
--- a/include/xen/hvm.h
+++ b/include/xen/hvm.h
@@ -3,6 +3,7 @@
 #define XEN_HVM_H__
 
 #include <xen/interface/hvm/params.h>
+#include <asm/xen/hypercall.h>
 
 static inline int hvm_get_parameter(int idx, uint64_t *value)
 {
@@ -21,4 +22,9 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
        return r;
 }
 
+#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
+#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
+#define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
+                               HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
+
 #endif /* XEN_HVM_H__ */
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
index f51b641..8ab08b9 100644
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -41,6 +41,9 @@
 /* x86: Does this Xen host support the MMU_PT_UPDATE_PRESERVE_AD hypercall? */
 #define XENFEAT_mmu_pt_update_preserve_ad  5
 
+/* x86: Does this Xen host support the HVM callback vector type? */
+#define XENFEAT_hvm_callback_vector        8
+
 #define XENFEAT_NR_SUBMAPS 1
 
 #endif /* __XEN_PUBLIC_FEATURES_H__ */
-- 
1.7.0.4


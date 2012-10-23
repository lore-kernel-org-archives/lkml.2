Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2JWSZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:25:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39138 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab2JWSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:24:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/10] xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus.
Date: Tue, 23 Oct 2012 14:12:06 -0400
Message-Id: <1351015931-16991-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

Make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz},
as PVH only needs to send down gdtaddr and gdtsz in the
vcpu_guest_context structure..

For interrupts, PVH uses native_irq_ops so we can skip most of the
PV ones. In the future we can support the pirq_eoi_map..
Also VCPU hotplug is currently not available for PVH.

For events (and IRQs) we follow what PVHVM does - so use callback
vector.  Lastly, for XenBus we use the same logic that is used in
the PVHVM case.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
[v2: Rebased it]
[v3: Move 64-bit ifdef and based on Stefan add extra comments.]
[v4: Rebased it once more]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/interface.h |   11 ++++++++-
 arch/x86/xen/irq.c                   |    5 +++-
 arch/x86/xen/p2m.c                   |    2 +-
 arch/x86/xen/smp.c                   |   39 +++++++++++++++++++++++++--------
 drivers/xen/cpu_hotplug.c            |    4 ++-
 drivers/xen/events.c                 |    9 +++++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 +-
 7 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 6d2f75a..4c08f23 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -144,7 +144,16 @@ struct vcpu_guest_context {
     struct cpu_user_regs user_regs;         /* User-level CPU registers     */
     struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
     unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
-    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
+    union {
+	struct {
+		/* PV: GDT (machine frames, # ents).*/
+		unsigned long gdt_frames[16], gdt_ents;
+	} pv;
+	struct {
+		/* PVH: GDTR addr and size */
+		unsigned long gdtaddr, gdtsz;
+	} pvh;
+    } u;
     unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
     /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
     unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 01a4dc0..fcbe56a 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -5,6 +5,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
+#include <xen/features.h>
 #include <xen/events.h>
 
 #include <asm/xen/hypercall.h>
@@ -129,6 +130,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
 
 void __init xen_init_irq_ops(void)
 {
-	pv_irq_ops = xen_irq_ops;
+	/* For PVH we use default pv_irq_ops settings */
+	if (!xen_feature(XENFEAT_hvm_callback_vector))
+		pv_irq_ops = xen_irq_ops;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 }
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 95fb2aa..ea553c8 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -798,7 +798,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	unsigned topidx, mididx, idx;
 
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
 		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
 		return true;
 	}
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 6947c4e..448f737 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -68,9 +68,11 @@ static void __cpuinit cpu_bringup(void)
 	touch_softlockup_watchdog();
 	preempt_disable();
 
-	xen_enable_sysenter();
-	xen_enable_syscall();
-
+	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
+	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
+		xen_enable_sysenter();
+		xen_enable_syscall();
+	}
 	cpu = smp_processor_id();
 	smp_store_cpu_info(cpu);
 	cpu_data(cpu).x86_max_cores = 1;
@@ -230,10 +232,11 @@ static void __init xen_smp_prepare_boot_cpu(void)
 	BUG_ON(smp_processor_id() != 0);
 	native_smp_prepare_boot_cpu();
 
-	/* We've switched to the "real" per-cpu gdt, so make sure the
-	   old memory can be recycled */
-	make_lowmem_page_readwrite(xen_initial_gdt);
-
+	if (!xen_feature(XENFEAT_writable_page_tables)) {
+		/* We've switched to the "real" per-cpu gdt, so make sure the
+		 * old memory can be recycled */
+		make_lowmem_page_readwrite(xen_initial_gdt);
+	}
 	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
 }
@@ -311,7 +314,23 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
-	{
+	if (xen_feature(XENFEAT_auto_translated_physmap) &&
+	    xen_feature(XENFEAT_supervisor_mode_kernel)) {
+		/* Note: PVH is not supported on x86_32. */
+#ifdef CONFIG_X86_64
+		ctxt->user_regs.ds = __KERNEL_DS;
+		ctxt->user_regs.es = 0;
+		ctxt->user_regs.gs = 0;
+
+		/* GUEST_GDTR_BASE and */
+		ctxt->u.pvh.gdtaddr = (unsigned long)gdt;
+		/* GUEST_GDTR_LIMIT in the VMCS. */
+		ctxt->u.pvh.gdtsz = (unsigned long)(GDT_SIZE - 1);
+
+		ctxt->gs_base_user = (unsigned long)
+					per_cpu(irq_stack_union.gs_base, cpu);
+#endif
+	} else {
 		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 		ctxt->user_regs.ds = __USER_DS;
 		ctxt->user_regs.es = __USER_DS;
@@ -326,8 +345,8 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 		make_lowmem_page_readonly(gdt);
 		make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
 
-		ctxt->gdt_frames[0] = gdt_mfn;
-		ctxt->gdt_ents      = GDT_ENTRIES;
+		ctxt->u.pv.gdt_frames[0] = gdt_mfn;
+		ctxt->u.pv.gdt_ents      = GDT_ENTRIES;
 
 		ctxt->kernel_ss = __KERNEL_DS;
 		ctxt->kernel_sp = idle->thread.sp0;
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 4dcfced..de6bcf9 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -2,6 +2,7 @@
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
+#include <xen/features.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/cpu.h>
@@ -100,7 +101,8 @@ static int __init setup_vcpu_hotplug_event(void)
 	static struct notifier_block xsn_cpu = {
 		.notifier_call = setup_cpu_watcher };
 
-	if (!xen_pv_domain())
+	/* PVH TBD/FIXME: future work */
+	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
 		return -ENODEV;
 
 	register_xenstore_notifier(&xsn_cpu);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 59e10a1..7131fdd 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1774,7 +1774,7 @@ int xen_set_callback_via(uint64_t via)
 }
 EXPORT_SYMBOL_GPL(xen_set_callback_via);
 
-#ifdef CONFIG_XEN_PVHVM
+#ifdef CONFIG_X86
 /* Vector callbacks are better than PCI interrupts to receive event
  * channel notifications because we can receive vector callbacks on any
  * vcpu and we don't need PCI support or APIC interactions. */
@@ -1835,6 +1835,13 @@ void __init xen_init_IRQ(void)
 		if (xen_initial_domain())
 			pci_xen_initial_domain();
 
+		if (xen_feature(XENFEAT_hvm_callback_vector)) {
+			xen_callback_vector();
+			return;
+		}
+
+		/* PVH: TBD/FIXME: debug and fix eio map to work with pvh */
+
 		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 		eoi_gmfn.gmfn = virt_to_mfn(pirq_eoi_map);
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index bcf3ba4..356461e 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -44,6 +44,7 @@
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
 #include <xen/xen.h>
+#include <xen/features.h>
 
 #include "xenbus_probe.h"
 
@@ -741,7 +742,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
 
 void __init xenbus_ring_ops_init(void)
 {
-	if (xen_pv_domain())
+	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))
 		ring_ops = &ring_ops_pv;
 	else
 		ring_ops = &ring_ops_hvm;
-- 
1.7.7.6


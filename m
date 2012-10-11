Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2JKV5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:57:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46123 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab2JKV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:57:17 -0400
Date: Thu, 11 Oct 2012 14:57:11 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/7]: PVH: use native irq, enable callback, use HVM ring
 ops,...
Message-ID: <20121011145711.0d9c27df@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PVH: make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz}, PVH
only needs to send down gdtaddr and gdtsz. irq.c: PVH uses
native_irq_ops. vcpu hotplug is currently not available for PVH.
events.c: setup callback vector for PVH. Finally, PVH ring ops uses HVM
paths for xenbus.

Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
---
 arch/x86/include/asm/xen/interface.h |    8 +++++++-
 arch/x86/xen/irq.c                   |    5 ++++-
 arch/x86/xen/p2m.c                   |    2 +-
 arch/x86/xen/smp.c                   |    4 ++--
 drivers/xen/cpu_hotplug.c            |    4 +++-
 drivers/xen/events.c                 |    9 ++++++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 ++-
 7 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 555f94d..f11edb0 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -143,7 +143,13 @@ struct vcpu_guest_context {
     struct cpu_user_regs user_regs;         /* User-level CPU registers     */
     struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
     unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
-    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
+    union {
+	struct {
+		/* PV: GDT (machine frames, # ents).*/
+		unsigned long gdt_frames[16], gdt_ents;
+	} s;
+	unsigned long gdtaddr, gdtsz;	    /* PVH: GDTR addr and size */
+    } u;
     unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
     /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
     unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 1573376..31959a7 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -5,6 +5,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
+#include <xen/features.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -128,6 +129,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
 
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
index f58dca7..bd92698 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -324,8 +324,8 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	make_lowmem_page_readonly(gdt);
 	make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
 
-	ctxt->gdt_frames[0] = gdt_mfn;
-	ctxt->gdt_ents      = GDT_ENTRIES;
+	ctxt->u.s.gdt_frames[0] = gdt_mfn;
+	ctxt->u.s.gdt_ents      = GDT_ENTRIES;
 
 	ctxt->user_regs.cs = __KERNEL_CS;
 	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
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
index c60d162..a977612 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1767,7 +1767,7 @@ int xen_set_callback_via(uint64_t via)
 }
 EXPORT_SYMBOL_GPL(xen_set_callback_via);
 
-#ifdef CONFIG_XEN_PVHVM
+#ifdef CONFIG_X86
 /* Vector callbacks are better than PCI interrupts to receive event
  * channel notifications because we can receive vector callbacks on any
  * vcpu and we don't need PCI support or APIC interactions. */
@@ -1826,6 +1826,13 @@ void __init xen_init_IRQ(void)
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
index b3e146e..1bac743 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -44,6 +44,7 @@
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
 #include <xen/xen.h>
+#include <xen/features.h>
 
 #include "xenbus_probe.h"
 
@@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
 
 void __init xenbus_ring_ops_init(void)
 {
-	if (xen_pv_domain())
+	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))
 		ring_ops = &ring_ops_pv;
 	else
 		ring_ops = &ring_ops_hvm;
-- 
1.7.2.3


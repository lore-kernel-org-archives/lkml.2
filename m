Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2JRWi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:38:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16580 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab2JRWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:38:27 -0400
Date: Thu, 18 Oct 2012 15:38:19 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V3 2/6]: (RESEND) PVH: use native irq,
 enable callback, use HVM ring ops, smp, ...
Message-ID: <20121018153819.03a1d63e@mantra.us.oracle.com>
In-Reply-To: <1350557077.2460.113.camel@zakaz.uk.xensource.com>
References: <20121017173005.73a03eec@mantra.us.oracle.com>
	<1350557077.2460.113.camel@zakaz.uk.xensource.com>
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

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/include/asm/xen/interface.h |   11 +++++-
 arch/x86/xen/irq.c                   |    5 ++-
 arch/x86/xen/p2m.c                   |    2 +-
 arch/x86/xen/smp.c                   |   75 ++++++++++++++++++++++------------
 drivers/xen/cpu_hotplug.c            |    4 +-
 drivers/xen/events.c                 |    9 ++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 +-
 7 files changed, 77 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 555f94d..ac5ef76 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -143,7 +143,16 @@ struct vcpu_guest_context {
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
+	    unsigned long gdtaddr, gdtsz;
+	} pvh;
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
index f58dca7..cda1907 100644
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
@@ -300,8 +303,6 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	gdt = get_cpu_gdt_table(cpu);
 
 	ctxt->flags = VGCF_IN_KERNEL;
-	ctxt->user_regs.ds = __USER_DS;
-	ctxt->user_regs.es = __USER_DS;
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
@@ -310,35 +311,57 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
-	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
-	xen_copy_trap_info(ctxt->trap_ctxt);
+	/* check for autoxlated to get it right for 32bit kernel */
+	if (xen_feature(XENFEAT_auto_translated_physmap) &&
+	    xen_feature(XENFEAT_supervisor_mode_kernel)) {
 
-	ctxt->ldt_ents = 0;
+		ctxt->user_regs.ds = __KERNEL_DS;
+		ctxt->user_regs.es = 0;
+		ctxt->user_regs.gs = 0;
 
-	BUG_ON((unsigned long)gdt & ~PAGE_MASK);
+		ctxt->u.pvh.gdtaddr = (unsigned long)gdt;
+		ctxt->u.pvh.gdtsz = (unsigned long)(GDT_SIZE - 1);
 
-	gdt_mfn = arbitrary_virt_to_mfn(gdt);
-	make_lowmem_page_readonly(gdt);
-	make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
+#ifdef CONFIG_X86_64
+		/* Note: PVH is not supported on x86_32. */
+		ctxt->gs_base_user = (unsigned long)
+					per_cpu(irq_stack_union.gs_base, cpu);
+#endif
+	} else {
+		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
+		ctxt->user_regs.ds = __USER_DS;
+		ctxt->user_regs.es = __USER_DS;
 
-	ctxt->gdt_frames[0] = gdt_mfn;
-	ctxt->gdt_ents      = GDT_ENTRIES;
+		xen_copy_trap_info(ctxt->trap_ctxt);
 
-	ctxt->user_regs.cs = __KERNEL_CS;
-	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
+		ctxt->ldt_ents = 0;
 
-	ctxt->kernel_ss = __KERNEL_DS;
-	ctxt->kernel_sp = idle->thread.sp0;
+		BUG_ON((unsigned long)gdt & ~PAGE_MASK);
+
+		gdt_mfn = arbitrary_virt_to_mfn(gdt);
+		make_lowmem_page_readonly(gdt);
+		make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
+
+		ctxt->u.pv.gdt_frames[0] = gdt_mfn;
+		ctxt->u.pv.gdt_ents      = GDT_ENTRIES;
+
+		ctxt->kernel_ss = __KERNEL_DS;
+		ctxt->kernel_sp = idle->thread.sp0;
 
 #ifdef CONFIG_X86_32
-	ctxt->event_callback_cs     = __KERNEL_CS;
-	ctxt->failsafe_callback_cs  = __KERNEL_CS;
+		ctxt->event_callback_cs     = __KERNEL_CS;
+		ctxt->failsafe_callback_cs  = __KERNEL_CS;
 #endif
-	ctxt->event_callback_eip    = (unsigned long)xen_hypervisor_callback;
-	ctxt->failsafe_callback_eip = (unsigned long)xen_failsafe_callback;
+		ctxt->event_callback_eip    =
+					(unsigned long)xen_hypervisor_callback;
+		ctxt->failsafe_callback_eip =
+					(unsigned long)xen_failsafe_callback;
+	}
+	ctxt->user_regs.cs = __KERNEL_CS;
+	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
 
 	per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
 	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
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


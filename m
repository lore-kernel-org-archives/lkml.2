Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2JKWA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:00:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27818 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2JKWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:00:26 -0400
Date: Thu, 11 Oct 2012 15:00:19 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 5/7]: PVH: smp changes.
Message-ID: <20121011150019.07d2686f@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PVH: smp changes. This pertains to bringing up smp vcpus. PVH runs in
ring 0, so syscalls are native. Also, the vcpu context is send down via
the hcall to be set in the vmcs. gdtaddr and gdtsz are unionionized as
PVH only needs to send these two to be set in the vmcs

Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
---
 arch/x86/xen/smp.c |   75 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index bd92698..63a0bfb 100644
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
+		ctxt->u.gdtaddr = (unsigned long)gdt;
+		ctxt->u.gdtsz = (unsigned long)(GDT_SIZE - 1);
 
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
 
-	ctxt->u.s.gdt_frames[0] = gdt_mfn;
-	ctxt->u.s.gdt_ents      = GDT_ENTRIES;
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
+		ctxt->u.s.gdt_frames[0] = gdt_mfn;
+		ctxt->u.s.gdt_ents      = GDT_ENTRIES;
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
-- 
1.7.2.3


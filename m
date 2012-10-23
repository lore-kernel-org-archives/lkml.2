Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2JWSYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:24:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51613 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab2JWSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:24:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/10] xen/smp: Move the common CPU init code a bit to prep for PVH patch.
Date: Tue, 23 Oct 2012 14:12:05 -0400
Message-Id: <1351015931-16991-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PV and PVH code CPU init code share some functionality. The
PVH code ("xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus")
sets some of these up, but not all. To make it easier to read, this
patch removes the PV specific out of the generic way.

No functional change - just code movement.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
[v2: Fixed compile errors noticed by Fengguang Wu build system]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 353c50f..6947c4e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -300,8 +300,6 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	gdt = get_cpu_gdt_table(cpu);
 
 	ctxt->flags = VGCF_IN_KERNEL;
-	ctxt->user_regs.ds = __USER_DS;
-	ctxt->user_regs.es = __USER_DS;
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
@@ -310,35 +308,41 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
-	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
-	xen_copy_trap_info(ctxt->trap_ctxt);
+	{
+		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
+		ctxt->user_regs.ds = __USER_DS;
+		ctxt->user_regs.es = __USER_DS;
 
-	ctxt->ldt_ents = 0;
+		xen_copy_trap_info(ctxt->trap_ctxt);
 
-	BUG_ON((unsigned long)gdt & ~PAGE_MASK);
+		ctxt->ldt_ents = 0;
 
-	gdt_mfn = arbitrary_virt_to_mfn(gdt);
-	make_lowmem_page_readonly(gdt);
-	make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
+		BUG_ON((unsigned long)gdt & ~PAGE_MASK);
 
-	ctxt->gdt_frames[0] = gdt_mfn;
-	ctxt->gdt_ents      = GDT_ENTRIES;
+		gdt_mfn = arbitrary_virt_to_mfn(gdt);
+		make_lowmem_page_readonly(gdt);
+		make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
 
-	ctxt->user_regs.cs = __KERNEL_CS;
-	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
+		ctxt->gdt_frames[0] = gdt_mfn;
+		ctxt->gdt_ents      = GDT_ENTRIES;
 
-	ctxt->kernel_ss = __KERNEL_DS;
-	ctxt->kernel_sp = idle->thread.sp0;
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
1.7.7.6


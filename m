Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1BIIYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:24:03 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:55030 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1BIIYB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 9 Feb 2011 03:24:01 -0500
Message-Id: <4D525D520200007800030EE9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 09 Feb 2011 08:24:34 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: partly unify asm-offsets_{32,64}.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just consolidating the common parts. Full unification would seem
strait forward, but it's not clear the necessary #ifdef-s would be
acceptable.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/asm-offsets.c    |   70 ++++++++++++++++++++++++++++++
 arch/x86/kernel/asm-offsets_32.c |   69 -----------------------------
 arch/x86/kernel/asm-offsets_64.c |   90 ++++++---------------------------------
 3 files changed, 84 insertions(+), 145 deletions(-)

--- 2.6.38-rc4/arch/x86/kernel/asm-offsets.c
+++ 2.6.38-rc4-x86-asm-offsets/arch/x86/kernel/asm-offsets.c
@@ -1,5 +1,75 @@
+/*
+ * Generate definitions needed by assembly language modules.
+ * This code generates raw asm output which is post-processed to extract
+ * and format the required data.
+ */
+#define COMPILE_OFFSETS
+
+#include <linux/crypto.h>
+#include <linux/sched.h>
+#include <linux/stddef.h>
+#include <linux/hardirq.h>
+#include <linux/suspend.h>
+#include <linux/kbuild.h>
+#include <asm/processor.h>
+#include <asm/thread_info.h>
+#include <asm/sigframe.h>
+#include <asm/bootparam.h>
+#include <asm/suspend.h>
+
+#ifdef CONFIG_XEN
+#include <xen/interface/xen.h>
+#endif
+
 #ifdef CONFIG_X86_32
 # include "asm-offsets_32.c"
 #else
 # include "asm-offsets_64.c"
 #endif
+
+void common(void) {
+	BLANK();
+	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
+	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
+	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
+
+	BLANK();
+	OFFSET(TI_flags, thread_info, flags);
+	OFFSET(TI_status, thread_info, status);
+	OFFSET(TI_addr_limit, thread_info, addr_limit);
+	OFFSET(TI_preempt_count, thread_info, preempt_count);
+
+	BLANK();
+	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
+
+	BLANK();
+	OFFSET(pbe_address, pbe, address);
+	OFFSET(pbe_orig_address, pbe, orig_address);
+	OFFSET(pbe_next, pbe, next);
+
+#ifdef CONFIG_PARAVIRT
+	BLANK();
+	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
+	OFFSET(PARAVIRT_PATCH_pv_cpu_ops, paravirt_patch_template, pv_cpu_ops);
+	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
+	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
+	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
+	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
+	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
+	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
+	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
+#endif
+
+#ifdef CONFIG_XEN
+	BLANK();
+	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
+	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
+#endif
+
+	BLANK();
+	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
+	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
+	OFFSET(BP_version, boot_params, hdr.version);
+	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
+}
--- 2.6.38-rc4/arch/x86/kernel/asm-offsets_32.c
+++ 2.6.38-rc4-x86-asm-offsets/arch/x86/kernel/asm-offsets_32.c
@@ -1,26 +1,4 @@
-/*
- * Generate definitions needed by assembly language modules.
- * This code generates raw asm output which is post-processed
- * to extract and format the required data.
- */
-
-#include <linux/crypto.h>
-#include <linux/sched.h>
-#include <linux/signal.h>
-#include <linux/personality.h>
-#include <linux/suspend.h>
-#include <linux/kbuild.h>
 #include <asm/ucontext.h>
-#include <asm/sigframe.h>
-#include <asm/pgtable.h>
-#include <asm/fixmap.h>
-#include <asm/processor.h>
-#include <asm/thread_info.h>
-#include <asm/bootparam.h>
-#include <asm/elf.h>
-#include <asm/suspend.h>
-
-#include <xen/interface/xen.h>
 
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
@@ -51,21 +29,10 @@ void foo(void)
 	OFFSET(CPUINFO_x86_vendor_id, cpuinfo_x86, x86_vendor_id);
 	BLANK();
 
-	OFFSET(TI_task, thread_info, task);
-	OFFSET(TI_exec_domain, thread_info, exec_domain);
-	OFFSET(TI_flags, thread_info, flags);
-	OFFSET(TI_status, thread_info, status);
-	OFFSET(TI_preempt_count, thread_info, preempt_count);
-	OFFSET(TI_addr_limit, thread_info, addr_limit);
-	OFFSET(TI_restart_block, thread_info, restart_block);
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
 	OFFSET(TI_cpu, thread_info, cpu);
 	BLANK();
 
-	OFFSET(GDS_size, desc_ptr, size);
-	OFFSET(GDS_address, desc_ptr, address);
-	BLANK();
-
 	OFFSET(PT_EBX, pt_regs, bx);
 	OFFSET(PT_ECX, pt_regs, cx);
 	OFFSET(PT_EDX, pt_regs, dx);
@@ -85,42 +52,13 @@ void foo(void)
 	OFFSET(PT_OLDSS,  pt_regs, ss);
 	BLANK();
 
-	OFFSET(EXEC_DOMAIN_handler, exec_domain, handler);
 	OFFSET(IA32_RT_SIGFRAME_sigcontext, rt_sigframe, uc.uc_mcontext);
 	BLANK();
 
-	OFFSET(pbe_address, pbe, address);
-	OFFSET(pbe_orig_address, pbe, orig_address);
-	OFFSET(pbe_next, pbe, next);
-
 	/* Offset from the sysenter stack to tss.sp0 */
 	DEFINE(TSS_sysenter_sp0, offsetof(struct tss_struct, x86_tss.sp0) -
 		 sizeof(struct tss_struct));
 
-	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
-	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
-
-	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
-
-#ifdef CONFIG_PARAVIRT
-	BLANK();
-	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
-	OFFSET(PARAVIRT_PATCH_pv_cpu_ops, paravirt_patch_template, pv_cpu_ops);
-	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
-	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
-	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
-	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
-	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
-	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
-#endif
-
-#ifdef CONFIG_XEN
-	BLANK();
-	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
-	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
-#endif
-
 #if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_GUEST) || defined(CONFIG_LGUEST_MODULE)
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
@@ -139,11 +77,4 @@ void foo(void)
 	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
 	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
-
-	BLANK();
-	OFFSET(BP_scratch, boot_params, scratch);
-	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
-	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
-	OFFSET(BP_version, boot_params, hdr.version);
-	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
 }
--- 2.6.38-rc4/arch/x86/kernel/asm-offsets_64.c
+++ 2.6.38-rc4-x86-asm-offsets/arch/x86/kernel/asm-offsets_64.c
@@ -1,27 +1,4 @@
-/*
- * Generate definitions needed by assembly language modules.
- * This code generates raw asm output which is post-processed to extract
- * and format the required data.
- */
-#define COMPILE_OFFSETS
-
-#include <linux/crypto.h>
-#include <linux/sched.h> 
-#include <linux/stddef.h>
-#include <linux/errno.h> 
-#include <linux/hardirq.h>
-#include <linux/suspend.h>
-#include <linux/kbuild.h>
-#include <asm/processor.h>
-#include <asm/segment.h>
-#include <asm/thread_info.h>
 #include <asm/ia32.h>
-#include <asm/bootparam.h>
-#include <asm/suspend.h>
-
-#include <xen/interface/xen.h>
-
-#include <asm/sigframe.h>
 
 #define __NO_STUBS 1
 #undef __SYSCALL
@@ -33,41 +10,19 @@ static char syscalls[] = {
 
 int main(void)
 {
-#define ENTRY(entry) DEFINE(tsk_ ## entry, offsetof(struct task_struct, entry))
-	ENTRY(state);
-	ENTRY(flags); 
-	ENTRY(pid);
-	BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(TI_ ## entry, offsetof(struct thread_info, entry))
-	ENTRY(flags);
-	ENTRY(addr_limit);
-	ENTRY(preempt_count);
-	ENTRY(status);
-#ifdef CONFIG_IA32_EMULATION
-	ENTRY(sysenter_return);
-#endif
-	BLANK();
-#undef ENTRY
 #ifdef CONFIG_PARAVIRT
-	BLANK();
-	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
-	OFFSET(PARAVIRT_PATCH_pv_cpu_ops, paravirt_patch_template, pv_cpu_ops);
-	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
-	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
-	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_IRQ_adjust_exception_frame, pv_irq_ops, adjust_exception_frame);
-	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
 	OFFSET(PV_CPU_usergs_sysret32, pv_cpu_ops, usergs_sysret32);
 	OFFSET(PV_CPU_usergs_sysret64, pv_cpu_ops, usergs_sysret64);
-	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
 	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
-	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
+	BLANK();
 #endif
 
-
 #ifdef CONFIG_IA32_EMULATION
-#define ENTRY(entry) DEFINE(IA32_SIGCONTEXT_ ## entry, offsetof(struct sigcontext_ia32, entry))
+	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
+	BLANK();
+
+#define ENTRY(entry) OFFSET(IA32_SIGCONTEXT_ ## entry, sigcontext_ia32, entry)
 	ENTRY(ax);
 	ENTRY(bx);
 	ENTRY(cx);
@@ -79,15 +34,12 @@ int main(void)
 	ENTRY(ip);
 	BLANK();
 #undef ENTRY
-	DEFINE(IA32_RT_SIGFRAME_sigcontext,
-	       offsetof (struct rt_sigframe_ia32, uc.uc_mcontext));
+
+	OFFSET(IA32_RT_SIGFRAME_sigcontext, rt_sigframe_ia32, uc.uc_mcontext);
 	BLANK();
 #endif
-	DEFINE(pbe_address, offsetof(struct pbe, address));
-	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
-	DEFINE(pbe_next, offsetof(struct pbe, next));
-	BLANK();
-#define ENTRY(entry) DEFINE(pt_regs_ ## entry, offsetof(struct pt_regs, entry))
+
+#define ENTRY(entry) OFFSET(pt_regs_ ## entry, pt_regs, entry)
 	ENTRY(bx);
 	ENTRY(bx);
 	ENTRY(cx);
@@ -107,7 +59,8 @@ int main(void)
 	ENTRY(flags);
 	BLANK();
 #undef ENTRY
-#define ENTRY(entry) DEFINE(saved_context_ ## entry, offsetof(struct saved_context, entry))
+
+#define ENTRY(entry) OFFSET(saved_context_ ## entry, saved_context, entry)
 	ENTRY(cr0);
 	ENTRY(cr2);
 	ENTRY(cr3);
@@ -115,26 +68,11 @@ int main(void)
 	ENTRY(cr8);
 	BLANK();
 #undef ENTRY
-	DEFINE(TSS_ist, offsetof(struct tss_struct, x86_tss.ist));
-	BLANK();
-	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
-	BLANK();
-	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
 
+	OFFSET(TSS_ist, tss_struct, x86_tss.ist);
 	BLANK();
-	OFFSET(BP_scratch, boot_params, scratch);
-	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
-	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
-	OFFSET(BP_version, boot_params, hdr.version);
-	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
 
-	BLANK();
-	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-#ifdef CONFIG_XEN
-	BLANK();
-	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
-	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
-#undef ENTRY
-#endif
+	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+
 	return 0;
 }



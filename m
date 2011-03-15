Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab1COUTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:19:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab1COUTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:19:10 -0400
Date: Tue, 15 Mar 2011 21:18:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v2.6.39
Message-ID: <20110315201855.GA19691@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus


out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
arch/um/Kconfig.x86                # c49aa5b: x86: Remove dead config option X8
                                   # bfc39061: um, x86-64: Fix UML build after 

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86: Use bitmap library functions

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Borislav Petkov (1):
      x86, system.h: Drop unused __SAVE/__RESTORE macros

Jan Beulich (9):
      x86: Reduce back the alignment of the per-CPU data section
      x86: Partly unify asm-offsets_{32,64}.c
      x86-64: Add CFI annotations to lib/rwsem_64.S
      x86: Use {push,pop}_cfi in more places
      x86: Remove unused bits from lib/thunk_*.S
      um, x86-64: Fix UML build after adding CFI annotations to lib/rwsem_64.S
      x86: Fix a bogus unwind annotation in lib/semaphore_32.S
      x86: Really print supported CPUs if PROCESSOR_SELECT=y
      x86: Remove dead config option X86_CPU

Stratos Psomadakis (1):
      x86, asm: Cleanup unnecssary macros in asm-offsets.c


 arch/um/Kconfig.x86              |    5 ++
 arch/x86/Kconfig                 |    2 +
 arch/x86/Kconfig.cpu             |    5 --
 arch/x86/ia32/ia32entry.S        |   27 ++++--------
 arch/x86/include/asm/frame.h     |    6 +--
 arch/x86/include/asm/system.h    |    2 -
 arch/x86/kernel/asm-offsets.c    |   65 +++++++++++++++++++++++++++
 arch/x86/kernel/asm-offsets_32.c |   69 -----------------------------
 arch/x86/kernel/asm-offsets_64.c |   90 ++++++--------------------------------
 arch/x86/kernel/cpu/common.c     |    4 +-
 arch/x86/kernel/entry_32.S       |    5 +-
 arch/x86/kernel/entry_64.S       |    2 +-
 arch/x86/kernel/head_32.S        |    8 ++--
 arch/x86/kernel/ioport.c         |   20 ++------
 arch/x86/kernel/vmlinux.lds.S    |    2 +-
 arch/x86/lib/atomic64_386_32.S   |    6 +--
 arch/x86/lib/atomic64_cx8_32.S   |    6 +--
 arch/x86/lib/checksum_32.S       |   63 +++++++++------------------
 arch/x86/lib/rwsem_64.S          |   56 ++++++++++++++---------
 arch/x86/lib/semaphore_32.S      |   38 +++++----------
 arch/x86/lib/thunk_32.S          |   18 --------
 arch/x86/lib/thunk_64.S          |   27 -----------
 arch/x86/xen/xen-head.S          |    4 +-
 23 files changed, 186 insertions(+), 344 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 5ee3280..02fb017 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -10,6 +10,8 @@ endmenu
 
 config UML_X86
 	def_bool y
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 
 config 64BIT
 	bool
@@ -19,6 +21,9 @@ config X86_32
 	def_bool !64BIT
 	select HAVE_AOUT
 
+config X86_64
+	def_bool 64BIT
+
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..43214e3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -64,6 +64,8 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 283c5a6..ed47e6e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -294,11 +294,6 @@ config X86_GENERIC
 
 endif
 
-config X86_CPU
-	def_bool y
-	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
-
 #
 # Define implied options from the CPU selection here
 config X86_INTERNODE_CACHE_SHIFT
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..7c6aabd 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -126,26 +126,20 @@ ENTRY(ia32_sysenter_target)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
  	movl	%ebp,%ebp		/* zero extension */
-	pushq	$__USER32_DS
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $__USER32_DS
 	/*CFI_REL_OFFSET ss,0*/
-	pushq	%rbp
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rbp
 	CFI_REL_OFFSET rsp,0
-	pushfq
-	CFI_ADJUST_CFA_OFFSET 8
+	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
 	movl	8*3-THREAD_SIZE+TI_sysenter_return(%rsp), %r10d
 	CFI_REGISTER rip,r10
-	pushq	$__USER32_CS
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
 	movl	%eax, %eax
-	pushq	%r10
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %r10
 	CFI_REL_OFFSET rip,0
-	pushq	%rax
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rax
 	cld
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
@@ -182,11 +176,9 @@ sysexit_from_sys_call:
 	xorq	%r9,%r9
 	xorq	%r10,%r10
 	xorq	%r11,%r11
-	popfq
-	CFI_ADJUST_CFA_OFFSET -8
+	popfq_cfi
 	/*CFI_RESTORE rflags*/
-	popq	%rcx				/* User %esp */
-	CFI_ADJUST_CFA_OFFSET -8
+	popq_cfi %rcx				/* User %esp */
 	CFI_REGISTER rsp,rcx
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS_SYSEXIT32
@@ -421,8 +413,7 @@ ENTRY(ia32_syscall)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%eax
-	pushq %rax
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rax
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
index 06850a7..2c6fc9e 100644
--- a/arch/x86/include/asm/frame.h
+++ b/arch/x86/include/asm/frame.h
@@ -7,14 +7,12 @@
    frame pointer later */
 #ifdef CONFIG_FRAME_POINTER
 	.macro FRAME
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebp
 	CFI_REL_OFFSET ebp,0
 	movl %esp,%ebp
 	.endm
 	.macro ENDFRAME
-	popl %ebp
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebp
 	CFI_RESTORE ebp
 	.endm
 #else
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 33ecc3e..12569e6 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -98,8 +98,6 @@ do {									\
  */
 #define HAVE_DISABLE_HLT
 #else
-#define __SAVE(reg, offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
-#define __RESTORE(reg, offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
 /* frame pointer must be last for get_wchan */
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index cfa82c8..4f13faf 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -1,5 +1,70 @@
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
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 1a4088d..c29d631 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
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
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 4a6aeed..e72a119 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1d59834..5d98c46 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -675,7 +675,7 @@ void __init early_cpu_init(void)
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
-#ifdef PROCESSOR_SELECT
+#ifdef CONFIG_PROCESSOR_SELECT
 	printk(KERN_INFO "KERNEL supported cpus:\n");
 #endif
 
@@ -687,7 +687,7 @@ void __init early_cpu_init(void)
 		cpu_devs[count] = cpudev;
 		count++;
 
-#ifdef PROCESSOR_SELECT
+#ifdef CONFIG_PROCESSOR_SELECT
 		{
 			unsigned int j;
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..2878821 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
+	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
@@ -1409,8 +1409,7 @@ END(general_protection)
 #ifdef CONFIG_KVM_GUEST
 ENTRY(async_page_fault)
 	RING0_EC_FRAME
-	pushl $do_async_page_fault
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_async_page_fault
 	jmp error_code
 	CFI_ENDPROC
 END(apf_page_fault)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..bbd5c80 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1248,7 +1248,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 767d6c4..187aa63 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -73,7 +73,7 @@ MAPPING_BEYOND_END = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
  */
 KERNEL_PAGES = LOWMEM_PAGES
 
-INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE_asm
+INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE
 RESERVE_BRK(pagetables, INIT_MAP_SIZE)
 
 /*
@@ -623,7 +623,7 @@ ENTRY(initial_code)
  * BSS section
  */
 __PAGE_ALIGNED_BSS
-	.align PAGE_SIZE_asm
+	.align PAGE_SIZE
 #ifdef CONFIG_X86_PAE
 initial_pg_pmd:
 	.fill 1024*KPMDS,4,0
@@ -644,7 +644,7 @@ ENTRY(swapper_pg_dir)
 #ifdef CONFIG_X86_PAE
 __PAGE_ALIGNED_DATA
 	/* Page-aligned for the benefit of paravirt? */
-	.align PAGE_SIZE_asm
+	.align PAGE_SIZE
 ENTRY(initial_page_table)
 	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
 # if KPMDS == 3
@@ -662,7 +662,7 @@ ENTRY(initial_page_table)
 # else
 #  error "Kernel PMDs should be 1, 2 or 3"
 # endif
-	.align PAGE_SIZE_asm		/* needs to be page-sized too */
+	.align PAGE_SIZE		/* needs to be page-sized too */
 #endif
 
 .data
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8eec0ec..8c96897 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -14,22 +14,9 @@
 #include <linux/slab.h>
 #include <linux/thread_info.h>
 #include <linux/syscalls.h>
+#include <linux/bitmap.h>
 #include <asm/syscalls.h>
 
-/* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
-static void set_bitmap(unsigned long *bitmap, unsigned int base,
-		       unsigned int extent, int new_value)
-{
-	unsigned int i;
-
-	for (i = base; i < base + extent; i++) {
-		if (new_value)
-			__set_bit(i, bitmap);
-		else
-			__clear_bit(i, bitmap);
-	}
-}
-
 /*
  * this changes the io permissions bitmap in the current task.
  */
@@ -69,7 +56,10 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 	 */
 	tss = &per_cpu(init_tss, get_cpu());
 
-	set_bitmap(t->io_bitmap_ptr, from, num, !turn_on);
+	if (turn_on)
+		bitmap_clear(t->io_bitmap_ptr, from, num);
+	else
+		bitmap_set(t->io_bitmap_ptr, from, num);
 
 	/*
 	 * Search for a (possibly new) maximum. This is simple and stupid,
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..e9f7a3c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,7 +305,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU(PAGE_SIZE)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 2cda60a..e8e7e0d 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -15,14 +15,12 @@
 
 /* if you want SMP support, implement these with real spinlocks */
 .macro LOCK reg
-	pushfl
-	CFI_ADJUST_CFA_OFFSET 4
+	pushfl_cfi
 	cli
 .endm
 
 .macro UNLOCK reg
-	popfl
-	CFI_ADJUST_CFA_OFFSET -4
+	popfl_cfi
 .endm
 
 #define BEGIN(op) \
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index 71e080d..391a083 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -14,14 +14,12 @@
 #include <asm/dwarf2.h>
 
 .macro SAVE reg
-	pushl %\reg
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %\reg
 	CFI_REL_OFFSET \reg, 0
 .endm
 
 .macro RESTORE reg
-	popl %\reg
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %\reg
 	CFI_RESTORE \reg
 .endm
 
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index adbccd0..78d16a5 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -50,11 +50,9 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
 	   */		
 ENTRY(csum_partial)
 	CFI_STARTPROC
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
 	movl 16(%esp),%ecx	# Function arg: int len
@@ -132,11 +130,9 @@ ENTRY(csum_partial)
 	jz 8f
 	roll $8, %eax
 8:
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
 	ret
 	CFI_ENDPROC
@@ -148,11 +144,9 @@ ENDPROC(csum_partial)
 
 ENTRY(csum_partial)
 	CFI_STARTPROC
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
 	movl 16(%esp),%ecx	# Function arg: int len
@@ -260,11 +254,9 @@ ENTRY(csum_partial)
 	jz 90f
 	roll $8, %eax
 90: 
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
 	ret
 	CFI_ENDPROC
@@ -309,14 +301,11 @@ ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
 	subl  $4,%esp	
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edi
 	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl ARGBASE+16(%esp),%eax	# sum
 	movl ARGBASE+12(%esp),%ecx	# len
@@ -426,17 +415,13 @@ DST(	movb %cl, (%edi)	)
 
 .previous
 
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
-	popl %edi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edi
 	CFI_RESTORE edi
-	popl %ecx			# equivalent to addl $4,%esp
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx			# equivalent to addl $4,%esp
 	ret	
 	CFI_ENDPROC
 ENDPROC(csum_partial_copy_generic)
@@ -459,14 +444,11 @@ ENDPROC(csum_partial_copy_generic)
 		
 ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edi
 	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
 	movl ARGBASE+4(%esp),%esi	#src
 	movl ARGBASE+8(%esp),%edi	#dst	
@@ -527,14 +509,11 @@ DST(	movb %dl, (%edi)         )
 	jmp  7b			
 .previous				
 
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
-	popl %edi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edi
 	CFI_RESTORE edi
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
 	ret
 	CFI_ENDPROC
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 41fcf00..6774397 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem_64.S
@@ -23,43 +23,50 @@
 #include <asm/dwarf2.h>
 
 #define save_common_regs \
-	pushq %rdi; \
-	pushq %rsi; \
-	pushq %rcx; \
-	pushq %r8; \
-	pushq %r9; \
-	pushq %r10; \
-	pushq %r11
+	pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
+	pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
+	pushq_cfi %rcx; CFI_REL_OFFSET rcx, 0; \
+	pushq_cfi %r8;  CFI_REL_OFFSET r8,  0; \
+	pushq_cfi %r9;  CFI_REL_OFFSET r9,  0; \
+	pushq_cfi %r10; CFI_REL_OFFSET r10, 0; \
+	pushq_cfi %r11; CFI_REL_OFFSET r11, 0
 
 #define restore_common_regs \
-	popq %r11; \
-	popq %r10; \
-	popq %r9; \
-	popq %r8; \
-	popq %rcx; \
-	popq %rsi; \
-	popq %rdi
+	popq_cfi %r11; CFI_RESTORE r11; \
+	popq_cfi %r10; CFI_RESTORE r10; \
+	popq_cfi %r9;  CFI_RESTORE r9; \
+	popq_cfi %r8;  CFI_RESTORE r8; \
+	popq_cfi %rcx; CFI_RESTORE rcx; \
+	popq_cfi %rsi; CFI_RESTORE rsi; \
+	popq_cfi %rdi; CFI_RESTORE rdi
 
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
+	CFI_STARTPROC
 	save_common_regs
-	pushq %rdx
+	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 	movq %rax,%rdi
 	call rwsem_down_read_failed
-	popq %rdx
+	popq_cfi %rdx
+	CFI_RESTORE rdx
 	restore_common_regs
 	ret
-	ENDPROC(call_rwsem_down_read_failed)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_down_read_failed)
 
 ENTRY(call_rwsem_down_write_failed)
+	CFI_STARTPROC
 	save_common_regs
 	movq %rax,%rdi
 	call rwsem_down_write_failed
 	restore_common_regs
 	ret
-	ENDPROC(call_rwsem_down_write_failed)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
+	CFI_STARTPROC
 	decl %edx	/* do nothing if still outstanding active readers */
 	jnz 1f
 	save_common_regs
@@ -67,15 +74,20 @@ ENTRY(call_rwsem_wake)
 	call rwsem_wake
 	restore_common_regs
 1:	ret
-	ENDPROC(call_rwsem_wake)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_wake)
 
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
+	CFI_STARTPROC
 	save_common_regs
-	pushq %rdx
+	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 	movq %rax,%rdi
 	call rwsem_downgrade_wake
-	popq %rdx
+	popq_cfi %rdx
+	CFI_RESTORE rdx
 	restore_common_regs
 	ret
-	ENDPROC(call_rwsem_downgrade_wake)
+	CFI_ENDPROC
+ENDPROC(call_rwsem_downgrade_wake)
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..06691da 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)
@@ -74,29 +74,23 @@ ENTRY(__read_lock_failed)
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
 	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edx
 	CFI_REL_OFFSET edx,0
 	call rwsem_down_read_failed
-	pop %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edx
+	popl_cfi %ecx
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_down_read_failed)
 
 ENTRY(call_rwsem_down_write_failed)
 	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
 	calll rwsem_down_write_failed
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_down_write_failed)
@@ -105,12 +99,10 @@ ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
 	decw %dx    /* do nothing if still outstanding active readers */
 	jnz 1f
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
 	call rwsem_wake
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx
 1:	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_wake)
@@ -118,17 +110,13 @@ ENTRY(call_rwsem_wake)
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
 	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edx
 	CFI_REL_OFFSET edx,0
 	call rwsem_downgrade_wake
-	pop %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edx
+	popl_cfi %ecx
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_downgrade_wake)
diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 650b11e..2930ae0 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -7,24 +7,6 @@
 
 	#include <linux/linkage.h>
 
-#define ARCH_TRACE_IRQS_ON			\
-	pushl %eax;				\
-	pushl %ecx;				\
-	pushl %edx;				\
-	call trace_hardirqs_on;			\
-	popl %edx;				\
-	popl %ecx;				\
-	popl %eax;
-
-#define ARCH_TRACE_IRQS_OFF			\
-	pushl %eax;				\
-	pushl %ecx;				\
-	pushl %edx;				\
-	call trace_hardirqs_off;		\
-	popl %edx;				\
-	popl %ecx;				\
-	popl %eax;
-
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
 	.macro thunk_ra name,func
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index bf9a7d5..782b082 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -22,26 +22,6 @@
 	CFI_ENDPROC
 	.endm
 
-	/* rdi:	arg1 ... normal C conventions. rax is passed from C. */ 	
-	.macro thunk_retrax name,func
-	.globl \name
-\name:	
-	CFI_STARTPROC
-	SAVE_ARGS
-	call \func
-	jmp  restore_norax
-	CFI_ENDPROC
-	.endm
-	
-
-	.section .sched.text, "ax"
-#ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
-	thunk rwsem_down_read_failed_thunk,rwsem_down_read_failed
-	thunk rwsem_down_write_failed_thunk,rwsem_down_write_failed
-	thunk rwsem_wake_thunk,rwsem_wake
-	thunk rwsem_downgrade_thunk,rwsem_downgrade_wake
-#endif	
-	
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in rdi (arg1) */
 	.macro thunk_ra name,func
@@ -72,10 +52,3 @@ restore:
 	RESTORE_ARGS
 	ret	
 	CFI_ENDPROC
-	
-	CFI_STARTPROC
-	SAVE_ARGS
-restore_norax:	
-	RESTORE_ARGS 1
-	ret
-	CFI_ENDPROC
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1a5ff24..aaa7291 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -28,9 +28,9 @@ ENTRY(startup_xen)
 	__FINIT
 
 .pushsection .text
-	.align PAGE_SIZE_asm
+	.align PAGE_SIZE
 ENTRY(hypercall_page)
-	.skip PAGE_SIZE_asm
+	.skip PAGE_SIZE
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")

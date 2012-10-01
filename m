Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2JAN26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:28:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41164 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2JAN2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:28:55 -0400
Date: Mon, 1 Oct 2012 15:28:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.7
Message-ID: <20121001132850.GA22956@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: c416ddf5b909736f5b57d348f5de159693e699ad x86: Unspaghettize do_trap()

The one change that stands out is the alternatives patching 
change that prevents us from ever patching back instructions 
from SMP to UP: this simplifies things and speeds up CPU 
hotplug. Other than that it's smaller fixes, cleanups and 
improvements.

out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
kernel/cpu.c                       # 816afe4: x86/smp: Don't ever patch back to

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      x86: Unspaghettize do_trap()

Ian Campbell (1):
      x86: Drop unnecessary kernel_eflags variable on 64-bit

Jan Beulich (3):
      x86/64: Adjust types of temporaries used by ffs()/fls()/fls64()
      x86: Prefer TZCNT over BFS
      x86: Use REP BSF unconditionally

Rusty Russell (1):
      x86/smp: Don't ever patch back to UP if we unplug cpus

Tao Guo (1):
      x86_64: Work around old GAS bug


 Documentation/kernel-parameters.txt |   3 -
 arch/x86/include/asm/alternative.h  |   4 +-
 arch/x86/include/asm/bitops.h       |  14 ++---
 arch/x86/include/asm/calling.h      |  48 ++++++++--------
 arch/x86/include/asm/processor.h    |   1 -
 arch/x86/kernel/alternative.c       | 107 +++++++++---------------------------
 arch/x86/kernel/cpu/common.c        |   4 --
 arch/x86/kernel/entry_64.S          |  22 ++++----
 arch/x86/kernel/smpboot.c           |  20 +------
 arch/x86/kernel/traps.c             |  60 ++++++++++----------
 arch/x86/xen/smp.c                  |   6 +-
 kernel/cpu.c                        |  11 ----
 12 files changed, 101 insertions(+), 199 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..7aef334 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2638,9 +2638,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
-	smp-alt-once	[X86-32,SMP] On a hotplug CPU system, only
-			attempt to substitute SMP alternatives once at boot.
-
 	smsc-ircc2.nopnp	[HW] Don't use PNP to discover SMC devices
 	smsc-ircc2.ircc_cfg=	[HW] Device configuration I/O port
 	smsc-ircc2.ircc_sir=	[HW] SIR base I/O port
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 7078068..444704c 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -60,7 +60,7 @@ extern void alternatives_smp_module_add(struct module *mod, char *name,
 					void *locks, void *locks_end,
 					void *text, void *text_end);
 extern void alternatives_smp_module_del(struct module *mod);
-extern void alternatives_smp_switch(int smp);
+extern void alternatives_enable_smp(void);
 extern int alternatives_text_reserved(void *start, void *end);
 extern bool skip_smp_alternatives;
 #else
@@ -68,7 +68,7 @@ static inline void alternatives_smp_module_add(struct module *mod, char *name,
 					       void *locks, void *locks_end,
 					       void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
-static inline void alternatives_smp_switch(int smp) {}
+static inline void alternatives_enable_smp(void) {}
 static inline int alternatives_text_reserved(void *start, void *end)
 {
 	return 0;
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 72f5009..6dfd019 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -355,7 +355,7 @@ static int test_bit(int nr, const volatile unsigned long *addr);
  */
 static inline unsigned long __ffs(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm("rep; bsf %1,%0"
 		: "=r" (word)
 		: "rm" (word));
 	return word;
@@ -369,7 +369,7 @@ static inline unsigned long __ffs(unsigned long word)
  */
 static inline unsigned long ffz(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm("rep; bsf %1,%0"
 		: "=r" (word)
 		: "r" (~word));
 	return word;
@@ -417,10 +417,9 @@ static inline int ffs(int x)
 	 * We cannot do this on 32 bits because at the very least some
 	 * 486 CPUs did not behave this way.
 	 */
-	long tmp = -1;
 	asm("bsfl %1,%0"
 	    : "=r" (r)
-	    : "rm" (x), "0" (tmp));
+	    : "rm" (x), "0" (-1));
 #elif defined(CONFIG_X86_CMOV)
 	asm("bsfl %1,%0\n\t"
 	    "cmovzl %2,%0"
@@ -459,10 +458,9 @@ static inline int fls(int x)
 	 * We cannot do this on 32 bits because at the very least some
 	 * 486 CPUs did not behave this way.
 	 */
-	long tmp = -1;
 	asm("bsrl %1,%0"
 	    : "=r" (r)
-	    : "rm" (x), "0" (tmp));
+	    : "rm" (x), "0" (-1));
 #elif defined(CONFIG_X86_CMOV)
 	asm("bsrl %1,%0\n\t"
 	    "cmovzl %2,%0"
@@ -490,13 +488,13 @@ static inline int fls(int x)
 #ifdef CONFIG_X86_64
 static __always_inline int fls64(__u64 x)
 {
-	long bitpos = -1;
+	int bitpos = -1;
 	/*
 	 * AMD64 says BSRQ won't clobber the dest reg if x==0; Intel64 says the
 	 * dest reg is undefined if x==0, but their CPU architect says its
 	 * value is written to set it to the same as before.
 	 */
-	asm("bsrq %1,%0"
+	asm("bsrq %1,%q0"
 	    : "+r" (bitpos)
 	    : "rm" (x));
 	return bitpos + 1;
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index a9e3a74..7f8422a 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -49,38 +49,36 @@ For 32-bit we have the following conventions - kernel is built with
 #include "dwarf2.h"
 
 /*
- * 64-bit system call stack frame layout defines and helpers, for
- * assembly code (note that the seemingly unnecessary parentheses
- * are to prevent cpp from inserting spaces in expressions that get
- * passed to macros):
+ * 64-bit system call stack frame layout defines and helpers,
+ * for assembly code:
  */
 
-#define R15		  (0)
-#define R14		  (8)
-#define R13		 (16)
-#define R12		 (24)
-#define RBP		 (32)
-#define RBX		 (40)
+#define R15		  0
+#define R14		  8
+#define R13		 16
+#define R12		 24
+#define RBP		 32
+#define RBX		 40
 
 /* arguments: interrupts/non tracing syscalls only save up to here: */
-#define R11		 (48)
-#define R10		 (56)
-#define R9		 (64)
-#define R8		 (72)
-#define RAX		 (80)
-#define RCX		 (88)
-#define RDX		 (96)
-#define RSI		(104)
-#define RDI		(112)
-#define ORIG_RAX	(120)       /* + error_code */
+#define R11		 48
+#define R10		 56
+#define R9		 64
+#define R8		 72
+#define RAX		 80
+#define RCX		 88
+#define RDX		 96
+#define RSI		104
+#define RDI		112
+#define ORIG_RAX	120       /* + error_code */
 /* end of arguments */
 
 /* cpu exception frame or undefined in case of fast syscall: */
-#define RIP		(128)
-#define CS		(136)
-#define EFLAGS		(144)
-#define RSP		(152)
-#define SS		(160)
+#define RIP		128
+#define CS		136
+#define EFLAGS		144
+#define RSP		152
+#define SS		160
 
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d048cad..9738b39 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -423,7 +423,6 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
-extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index afb7ff7..af1f326 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -23,19 +23,6 @@
 
 #define MAX_PATCH_LEN (255-1)
 
-#ifdef CONFIG_HOTPLUG_CPU
-static int smp_alt_once;
-
-static int __init bootonly(char *str)
-{
-	smp_alt_once = 1;
-	return 1;
-}
-__setup("smp-alt-boot", bootonly);
-#else
-#define smp_alt_once 1
-#endif
-
 static int __initdata_or_module debug_alternative;
 
 static int __init debug_alt(char *str)
@@ -326,9 +313,6 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 {
 	const s32 *poff;
 
-	if (noreplace_smp)
-		return;
-
 	mutex_lock(&text_mutex);
 	for (poff = start; poff < end; poff++) {
 		u8 *ptr = (u8 *)poff + *poff;
@@ -359,7 +343,7 @@ struct smp_alt_module {
 };
 static LIST_HEAD(smp_alt_modules);
 static DEFINE_MUTEX(smp_alt);
-static int smp_mode = 1;	/* protected by smp_alt */
+static bool uniproc_patched = false;	/* protected by smp_alt */
 
 void __init_or_module alternatives_smp_module_add(struct module *mod,
 						  char *name,
@@ -368,19 +352,18 @@ void __init_or_module alternatives_smp_module_add(struct module *mod,
 {
 	struct smp_alt_module *smp;
 
-	if (noreplace_smp)
-		return;
+	mutex_lock(&smp_alt);
+	if (!uniproc_patched)
+		goto unlock;
 
-	if (smp_alt_once) {
-		if (boot_cpu_has(X86_FEATURE_UP))
-			alternatives_smp_unlock(locks, locks_end,
-						text, text_end);
-		return;
-	}
+	if (num_possible_cpus() == 1)
+		/* Don't bother remembering, we'll never have to undo it. */
+		goto smp_unlock;
 
 	smp = kzalloc(sizeof(*smp), GFP_KERNEL);
 	if (NULL == smp)
-		return; /* we'll run the (safe but slow) SMP code then ... */
+		/* we'll run the (safe but slow) SMP code then ... */
+		goto unlock;
 
 	smp->mod	= mod;
 	smp->name	= name;
@@ -392,11 +375,10 @@ void __init_or_module alternatives_smp_module_add(struct module *mod,
 		__func__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
-	mutex_lock(&smp_alt);
 	list_add_tail(&smp->next, &smp_alt_modules);
-	if (boot_cpu_has(X86_FEATURE_UP))
-		alternatives_smp_unlock(smp->locks, smp->locks_end,
-					smp->text, smp->text_end);
+smp_unlock:
+	alternatives_smp_unlock(locks, locks_end, text, text_end);
+unlock:
 	mutex_unlock(&smp_alt);
 }
 
@@ -404,24 +386,18 @@ void __init_or_module alternatives_smp_module_del(struct module *mod)
 {
 	struct smp_alt_module *item;
 
-	if (smp_alt_once || noreplace_smp)
-		return;
-
 	mutex_lock(&smp_alt);
 	list_for_each_entry(item, &smp_alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
-		mutex_unlock(&smp_alt);
-		DPRINTK("%s: %s\n", __func__, item->name);
 		kfree(item);
-		return;
+		break;
 	}
 	mutex_unlock(&smp_alt);
 }
 
-bool skip_smp_alternatives;
-void alternatives_smp_switch(int smp)
+void alternatives_enable_smp(void)
 {
 	struct smp_alt_module *mod;
 
@@ -436,34 +412,21 @@ void alternatives_smp_switch(int smp)
 	pr_info("lockdep: fixing up alternatives\n");
 #endif
 
-	if (noreplace_smp || smp_alt_once || skip_smp_alternatives)
-		return;
-	BUG_ON(!smp && (num_online_cpus() > 1));
+	/* Why bother if there are no other CPUs? */
+	BUG_ON(num_possible_cpus() == 1);
 
 	mutex_lock(&smp_alt);
 
-	/*
-	 * Avoid unnecessary switches because it forces JIT based VMs to
-	 * throw away all cached translations, which can be quite costly.
-	 */
-	if (smp == smp_mode) {
-		/* nothing */
-	} else if (smp) {
+	if (uniproc_patched) {
 		pr_info("switching to SMP code\n");
+		BUG_ON(num_online_cpus() != 1);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
 		clear_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_lock(mod->locks, mod->locks_end,
 					      mod->text, mod->text_end);
-	} else {
-		pr_info("switching to UP code\n");
-		set_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
-		set_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
-		list_for_each_entry(mod, &smp_alt_modules, next)
-			alternatives_smp_unlock(mod->locks, mod->locks_end,
-						mod->text, mod->text_end);
+		uniproc_patched = false;
 	}
-	smp_mode = smp;
 	mutex_unlock(&smp_alt);
 }
 
@@ -540,40 +503,22 @@ void __init alternative_instructions(void)
 
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
-	/* switch to patch-once-at-boottime-only mode and free the
-	 * tables in case we know the number of CPUs will never ever
-	 * change */
-#ifdef CONFIG_HOTPLUG_CPU
-	if (num_possible_cpus() < 2)
-		smp_alt_once = 1;
-#endif
-
 #ifdef CONFIG_SMP
-	if (smp_alt_once) {
-		if (1 == num_possible_cpus()) {
-			pr_info("switching to UP code\n");
-			set_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
-			set_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
-
-			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
-						_text, _etext);
-		}
-	} else {
+	/* Patch to UP if other cpus not imminent. */
+	if (!noreplace_smp && (num_present_cpus() == 1 || setup_max_cpus <= 1)) {
+		uniproc_patched = true;
 		alternatives_smp_module_add(NULL, "core kernel",
 					    __smp_locks, __smp_locks_end,
 					    _text, _etext);
-
-		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_present_cpus() == 1 || setup_max_cpus <= 1)
-			alternatives_smp_switch(0);
 	}
-#endif
- 	apply_paravirt(__parainstructions, __parainstructions_end);
 
-	if (smp_alt_once)
+	if (!uniproc_patched || num_possible_cpus() == 1)
 		free_init_pages("SMP alternatives",
 				(unsigned long)__smp_locks,
 				(unsigned long)__smp_locks_end);
+#endif
+
+	apply_paravirt(__parainstructions, __parainstructions_end);
 
 	restart_nmi();
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..9961e2e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1116,8 +1116,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1299,8 +1297,6 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 	xsave_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..2c67061 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -342,15 +342,15 @@ ENDPROC(native_usergs_sysret64)
 	.macro SAVE_ARGS_IRQ
 	cld
 	/* start from rbp in pt_regs and jump over */
-	movq_cfi rdi, RDI-RBP
-	movq_cfi rsi, RSI-RBP
-	movq_cfi rdx, RDX-RBP
-	movq_cfi rcx, RCX-RBP
-	movq_cfi rax, RAX-RBP
-	movq_cfi  r8,  R8-RBP
-	movq_cfi  r9,  R9-RBP
-	movq_cfi r10, R10-RBP
-	movq_cfi r11, R11-RBP
+	movq_cfi rdi, (RDI-RBP)
+	movq_cfi rsi, (RSI-RBP)
+	movq_cfi rdx, (RDX-RBP)
+	movq_cfi rcx, (RCX-RBP)
+	movq_cfi rax, (RAX-RBP)
+	movq_cfi  r8,  (R8-RBP)
+	movq_cfi  r9,  (R9-RBP)
+	movq_cfi r10, (R10-RBP)
+	movq_cfi r11, (R11-RBP)
 
 	/* Save rbp so that we can unwind from get_irq_regs() */
 	movq_cfi rbp, 0
@@ -384,7 +384,7 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 ENTRY(save_rest)
-	PARTIAL_FRAME 1 REST_SKIP+8
+	PARTIAL_FRAME 1 (REST_SKIP+8)
 	movq 5*8+16(%rsp), %r11	/* save return address */
 	movq_cfi rbx, RBX+16
 	movq_cfi rbp, RBP+16
@@ -440,7 +440,7 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	pushq_cfi kernel_eflags(%rip)
+	pushq_cfi $0x0002
 	popfq_cfi				# reset kernel eflags
 
 	call schedule_tail			# rdi: 'prev' task parameter
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c5a8c3..c80a33b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -665,7 +665,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	unsigned long boot_error = 0;
 	int timeout;
 
-	alternatives_smp_switch(1);
+	/* Just in case we booted with a single CPU. */
+	alternatives_enable_smp();
 
 	idle->thread.sp = (unsigned long) (((struct pt_regs *)
 			  (THREAD_SIZE +  task_stack_page(idle))) - 1);
@@ -1053,20 +1054,6 @@ out:
 	preempt_enable();
 }
 
-void arch_disable_nonboot_cpus_begin(void)
-{
-	/*
-	 * Avoid the smp alternatives switch during the disable_nonboot_cpus().
-	 * In the suspend path, we will be back in the SMP mode shortly anyways.
-	 */
-	skip_smp_alternatives = true;
-}
-
-void arch_disable_nonboot_cpus_end(void)
-{
-	skip_smp_alternatives = false;
-}
-
 void arch_enable_nonboot_cpus_begin(void)
 {
 	set_mtrr_aps_delayed_init();
@@ -1256,9 +1243,6 @@ void native_cpu_die(unsigned int cpu)
 		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
 			if (system_state == SYSTEM_RUNNING)
 				pr_info("CPU %u is now offline\n", cpu);
-
-			if (1 == num_online_cpus())
-				alternatives_smp_switch(0);
 			return;
 		}
 		msleep(100);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b481341..6ff7715 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -107,30 +107,45 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-static void __kprobes
-do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
-	long error_code, siginfo_t *info)
+static int __kprobes
+do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
+		  struct pt_regs *regs,	long error_code)
 {
-	struct task_struct *tsk = current;
-
 #ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK) {
 		/*
-		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
+		 * Traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
 		 * On nmi (interrupt 2), do_trap should not be called.
 		 */
-		if (trapnr < X86_TRAP_UD)
-			goto vm86_trap;
-		goto trap_signal;
+		if (trapnr < X86_TRAP_UD) {
+			if (!handle_vm86_trap((struct kernel_vm86_regs *) regs,
+						error_code, trapnr))
+				return 0;
+		}
+		return -1;
 	}
 #endif
+	if (!user_mode(regs)) {
+		if (!fixup_exception(regs)) {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_nr = trapnr;
+			die(str, regs, error_code);
+		}
+		return 0;
+	}
 
-	if (!user_mode(regs))
-		goto kernel_trap;
+	return -1;
+}
 
-#ifdef CONFIG_X86_32
-trap_signal:
-#endif
+static void __kprobes
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
+	long error_code, siginfo_t *info)
+{
+	struct task_struct *tsk = current;
+
+
+	if (!do_trap_no_signal(tsk, trapnr, str, regs, error_code))
+		return;
 	/*
 	 * We want error_code and trap_nr set for userspace faults and
 	 * kernelspace faults which result in die(), but not
@@ -158,23 +173,6 @@ trap_signal:
 		force_sig_info(signr, info, tsk);
 	else
 		force_sig(signr, tsk);
-	return;
-
-kernel_trap:
-	if (!fixup_exception(regs)) {
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_nr = trapnr;
-		die(str, regs, error_code);
-	}
-	return;
-
-#ifdef CONFIG_X86_32
-vm86_trap:
-	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
-						error_code, trapnr))
-		goto trap_signal;
-	return;
-#endif
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index f58dca7..353c50f 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -377,7 +377,8 @@ static int __cpuinit xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 		return rc;
 
 	if (num_online_cpus() == 1)
-		alternatives_smp_switch(1);
+		/* Just in case we booted with a single CPU. */
+		alternatives_enable_smp();
 
 	rc = xen_smp_intr_init(cpu);
 	if (rc)
@@ -424,9 +425,6 @@ static void xen_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
-
-	if (num_online_cpus() == 1)
-		alternatives_smp_switch(0);
 }
 
 static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 14d3258..f6bfe3e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -439,14 +439,6 @@ EXPORT_SYMBOL_GPL(cpu_up);
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
 
-void __weak arch_disable_nonboot_cpus_begin(void)
-{
-}
-
-void __weak arch_disable_nonboot_cpus_end(void)
-{
-}
-
 int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error = 0;
@@ -458,7 +450,6 @@ int disable_nonboot_cpus(void)
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
-	arch_disable_nonboot_cpus_begin();
 
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
@@ -474,8 +465,6 @@ int disable_nonboot_cpus(void)
 		}
 	}
 
-	arch_disable_nonboot_cpus_end();
-
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
 		/* Make sure the CPUs won't be enabled by someone else */

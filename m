Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1HLVKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:10:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:51363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1HLVKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:10:48 -0400
Date: Fri, 12 Aug 2011 21:10:14 GMT
Message-Id: <201108122110.p7CLAEWx002573@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/vdso fixes for 3.1
Cc: Andy Lutomirski <luto@mit.edu>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Aug 2011 21:10:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the collected set of vdso fixes, including the change to using
"real code protected by NX" for vsyscall=emulate.

This leaves vsyscall=emulate as the default (since we think it should
be "good enough" now); we can change that easily enough if it turns
out to be insufficient.

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-tip.git x86-vdso-for-linus

Andy Lutomirski (9):
      x86-64: Pad vDSO to a page boundary
      x86-64: Move the "user" vsyscall segment out of the data segment.
      x86-64: Work around gold bug 13023
      x86-64, xen: Enable the vvar mapping
      x86-64: Add user_64bit_mode paravirt op
      x86-64: Add vsyscall:emulate_vsyscall trace event
      x86: Remove unnecessary compile flag tweaks for vsyscall code
      x86-64: Wire up getcpu syscall
      x86-64: Rework vsyscall emulation and add vsyscall= parameter

H. Peter Anvin (1):
      Merge commit 'v3.0' into x86/vdso

 Documentation/ABI/stable/vdso          |   27 +++
 Documentation/kernel-parameters.txt    |   21 ++
 Documentation/vDSO/parse_vdso.c        |  256 ++++++++++++++++++++++++
 Documentation/vDSO/vdso_test.c         |  111 +++++++++++
 Documentation/x86/entry_64.txt         |   98 +++++++++
 arch/ia64/Kconfig                      |    3 +
 arch/ia64/include/asm/clocksource.h    |   10 +
 arch/ia64/kernel/cyclone.c             |    2 +-
 arch/ia64/kernel/time.c                |    2 +-
 arch/ia64/sn/kernel/sn2/timer.c        |    2 +-
 arch/x86/Kconfig                       |    4 +
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    8 +-
 arch/x86/include/asm/clocksource.h     |   18 ++
 arch/x86/include/asm/cpufeature.h      |    8 +-
 arch/x86/include/asm/desc.h            |    4 +-
 arch/x86/include/asm/fixmap.h          |    1 +
 arch/x86/include/asm/irq_vectors.h     |    2 +-
 arch/x86/include/asm/paravirt_types.h  |    6 +
 arch/x86/include/asm/pgtable_types.h   |    6 +-
 arch/x86/include/asm/ptrace.h          |   19 ++
 arch/x86/include/asm/traps.h           |    2 +
 arch/x86/include/asm/tsc.h             |    4 -
 arch/x86/include/asm/unistd_64.h       |    2 +
 arch/x86/include/asm/vgtod.h           |    3 +-
 arch/x86/include/asm/vsyscall.h        |   10 +-
 arch/x86/include/asm/vvar.h            |   24 +--
 arch/x86/kernel/Makefile               |   21 +--
 arch/x86/kernel/alternative.c          |   23 +--
 arch/x86/kernel/entry_64.S             |    3 +
 arch/x86/kernel/hpet.c                 |   11 +-
 arch/x86/kernel/paravirt.c             |    4 +
 arch/x86/kernel/step.c                 |    2 +-
 arch/x86/kernel/tsc.c                  |    2 +-
 arch/x86/kernel/vmlinux.lds.S          |   56 ++----
 arch/x86/kernel/vread_tsc_64.c         |   36 ----
 arch/x86/kernel/vsyscall_64.c          |  340 +++++++++++++++----------------
 arch/x86/kernel/vsyscall_emu_64.S      |   37 ++++
 arch/x86/kernel/vsyscall_trace.h       |   29 +++
 arch/x86/lib/copy_page_64.S            |    9 +-
 arch/x86/lib/memmove_64.S              |   11 +-
 arch/x86/mm/fault.c                    |   14 ++-
 arch/x86/vdso/Makefile                 |    1 +
 arch/x86/vdso/vclock_gettime.c         |  103 ++++++----
 arch/x86/vdso/vdso.S                   |   16 ++-
 arch/x86/vdso/vma.c                    |   58 ++++--
 arch/x86/xen/enlighten.c               |    4 +
 arch/x86/xen/mmu.c                     |    4 +-
 drivers/char/hpet.c                    |    2 +-
 include/linux/clocksource.h            |   15 +-
 include/linux/seccomp.h                |   10 +
 51 files changed, 1048 insertions(+), 420 deletions(-)
 create mode 100644 Documentation/ABI/stable/vdso
 create mode 100644 Documentation/vDSO/parse_vdso.c
 create mode 100644 Documentation/vDSO/vdso_test.c
 create mode 100644 Documentation/x86/entry_64.txt
 create mode 100644 arch/ia64/include/asm/clocksource.h
 create mode 100644 arch/x86/include/asm/clocksource.h
 delete mode 100644 arch/x86/kernel/vread_tsc_64.c
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S
 create mode 100644 arch/x86/kernel/vsyscall_trace.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e279b72..78926aa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2680,6 +2680,27 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vsyscall=	[X86-64]
+			Controls the behavior of vsyscalls (i.e. calls to
+			fixed addresses of 0xffffffffff600x00 from legacy
+			code).  Most statically-linked binaries and older
+			versions of glibc use these calls.  Because these
+			functions are at fixed addresses, they make nice
+			targets for exploits that can control RIP.
+
+			emulate     [default] Vsyscalls turn into traps and are
+			            emulated reasonably safely.
+
+			native      Vsyscalls are native syscall instructions.
+			            This is a little bit faster than trapping
+			            and makes a few dynamic recompilers work
+			            better than they would in emulation mode.
+			            It also makes exploits much easier to write.
+
+			none        Vsyscalls don't work at all.  This makes
+			            them quite hard to use for exploits but
+			            might break your system.
+
 	vt.cur_default=	[VT] Default cursor shape.
 			Format: 0xCCBBAA, where AA, BB, and CC are the same as
 			the parameters of the <Esc>[?A;B;Cc escape sequence;
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 7b439d9..41935fa 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -27,8 +27,8 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
 
 	desc->base2		= (info->base_addr & 0xff000000) >> 24;
 	/*
-	 * Don't allow setting of the lm bit. It is useless anyway
-	 * because 64bit system calls require __USER_CS:
+	 * Don't allow setting of the lm bit. It would confuse
+	 * user_64bit_mode and would get overridden by sysret anyway.
 	 */
 	desc->l			= 0;
 }
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index f9a3209..7e50f06 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -17,7 +17,6 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vector  204         : legacy x86_64 vsyscall emulation
  *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device interrupts
  *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
@@ -51,9 +50,6 @@
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
 #endif
-#ifdef CONFIG_X86_64
-# define VSYSCALL_EMU_VECTOR		0xcc
-#endif
 
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 2c76521..8e8b9a4 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -41,6 +41,7 @@
 
 #include <asm/desc_defs.h>
 #include <asm/kmap_types.h>
+#include <asm/pgtable_types.h>
 
 struct page;
 struct thread_struct;
@@ -63,6 +64,11 @@ struct paravirt_callee_save {
 struct pv_info {
 	unsigned int kernel_rpl;
 	int shared_kernel_pmd;
+
+#ifdef CONFIG_X86_64
+	u16 extra_user_64bit_cs;  /* __USER_CS if none */
+#endif
+
 	int paravirt_enabled;
 	const char *name;
 };
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 94e7618..3566454 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -131,6 +131,9 @@ struct pt_regs {
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt_types.h>
+#endif
 
 struct cpuinfo_x86;
 struct task_struct;
@@ -187,6 +190,22 @@ static inline int v8086_mode(struct pt_regs *regs)
 #endif
 }
 
+#ifdef CONFIG_X86_64
+static inline bool user_64bit_mode(struct pt_regs *regs)
+{
+#ifndef CONFIG_PARAVIRT
+	/*
+	 * On non-paravirt systems, this is the only long mode CPL 3
+	 * selector.  We do not allow long mode selectors in the LDT.
+	 */
+	return regs->cs == __USER_CS;
+#else
+	/* Headers are too twisted for this to go in paravirt.h. */
+	return regs->cs == __USER_CS || regs->cs == pv_info.extra_user_64bit_cs;
+#endif
+}
+#endif
+
 /*
  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
  * when it traps.  The previous stack will be directly underneath the saved
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 2bae0a5..0012d09 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -40,7 +40,6 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
-asmlinkage void emulate_vsyscall(void);
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
@@ -67,7 +66,6 @@ dotraplinkage void do_alignment_check(struct pt_regs *, long);
 dotraplinkage void do_machine_check(struct pt_regs *, long);
 #endif
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
-dotraplinkage void do_emulate_vsyscall(struct pt_regs *, long);
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *, long);
 #endif
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 705bf13..d92641c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -681,6 +681,8 @@ __SYSCALL(__NR_syncfs, sys_syncfs)
 __SYSCALL(__NR_sendmmsg, sys_sendmmsg)
 #define __NR_setns				308
 __SYSCALL(__NR_setns, sys_setns)
+#define __NR_getcpu				309
+__SYSCALL(__NR_getcpu, sys_getcpu)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 6010707..eaea1d3 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -27,6 +27,12 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
+/*
+ * Called on instruction fetch fault in vsyscall page.
+ * Returns true if handled.
+ */
+extern bool emulate_vsyscall(struct pt_regs *regs, unsigned long address);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0410557..82f2912 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -17,19 +17,6 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
-#
-# vsyscalls (which work on the user stack) should have
-# no stack-protector checks:
-#
-nostackp := $(call cc-option, -fno-stack-protector)
-CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
-CFLAGS_hpet.o		:= $(nostackp)
-CFLAGS_paravirt.o	:= $(nostackp)
-GCOV_PROFILE_vsyscall_64.o	:= n
-GCOV_PROFILE_hpet.o		:= n
-GCOV_PROFILE_tsc.o		:= n
-GCOV_PROFILE_paravirt.o		:= n
-
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..6419bb0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1111,7 +1111,6 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
-zeroentry emulate_vsyscall do_emulate_vsyscall
 
 
 	/* Reload gs selector with exception handling */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 613a793..d90272e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -307,6 +307,10 @@ struct pv_info pv_info = {
 	.paravirt_enabled = 0,
 	.kernel_rpl = 0,
 	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
+
+#ifdef CONFIG_X86_64
+	.extra_user_64bit_cs = __USER_CS,
+#endif
 };
 
 struct pv_init_ops pv_init_ops = {
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 7977f0c..c346d11 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -74,7 +74,7 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 
 #ifdef CONFIG_X86_64
 		case 0x40 ... 0x4f:
-			if (regs->cs != __USER_CS)
+			if (!user_64bit_mode(regs))
 				/* 32-bit mode: register increment */
 				return 0;
 			/* 64-bit mode: REX prefix */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9682ec5..6913369 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -872,12 +872,6 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 
-#ifdef CONFIG_X86_64
-	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
-	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
-	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
-#endif
-
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4aa9c54..0f703f1 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -71,7 +71,6 @@ PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
-	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
 	percpu PT_LOAD FLAGS(6);        /* RW_ */
 #endif
@@ -154,44 +153,16 @@ SECTIONS
 
 #ifdef CONFIG_X86_64
 
-#define VSYSCALL_ADDR (-10*1024*1024)
-
-#define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
-#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
-
-#define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
-#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
-
-	. = ALIGN(4096);
-	__vsyscall_0 = .;
-
-	. = VSYSCALL_ADDR;
-	.vsyscall : AT(VLOAD(.vsyscall)) {
-		*(.vsyscall_0)
-
-		. = 1024;
-		*(.vsyscall_1)
-
-		. = 2048;
-		*(.vsyscall_2)
-
-		. = 4096;  /* Pad the whole page. */
-	} :user =0xcc
-	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
-
-#undef VSYSCALL_ADDR
-#undef VLOAD_OFFSET
-#undef VLOAD
-#undef VVIRT_OFFSET
-#undef VVIRT
-
+	. = ALIGN(PAGE_SIZE);
 	__vvar_page = .;
 
 	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
+		/* work around gold bug 13023 */
+		__vvar_beginning_hack = .;
 
-	      /* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) 		\
-		. = offset;		\
+		/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) 			\
+		. = __vvar_beginning_hack + offset;	\
 		*(.vvar_ ## name)
 #define __VVAR_KERNEL_LDS
 #include <asm/vvar.h>
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dda7dff..18ae83d 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -18,9 +18,6 @@
  *  use the vDSO.
  */
 
-/* Disable profiling for userspace code: */
-#define DISABLE_BRANCH_PROFILING
-
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -50,12 +47,36 @@
 #include <asm/vgtod.h>
 #include <asm/traps.h>
 
+#define CREATE_TRACE_POINTS
+#include "vsyscall_trace.h"
+
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
+
+static int __init vsyscall_setup(char *str)
+{
+	if (str) {
+		if (!strcmp("emulate", str))
+			vsyscall_mode = EMULATE;
+		else if (!strcmp("native", str))
+			vsyscall_mode = NATIVE;
+		else if (!strcmp("none", str))
+			vsyscall_mode = NONE;
+		else
+			return -EINVAL;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+early_param("vsyscall", vsyscall_setup);
+
 void update_vsyscall_tz(void)
 {
 	unsigned long flags;
@@ -100,7 +121,7 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
 	       level, tsk->comm, task_pid_nr(tsk),
-	       message, regs->ip - 2, regs->cs,
+	       message, regs->ip, regs->cs,
 	       regs->sp, regs->ax, regs->si, regs->di);
 }
 
@@ -118,46 +139,39 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
-void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
+bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
 	struct task_struct *tsk;
 	unsigned long caller;
 	int vsyscall_nr;
 	long ret;
 
-	local_irq_enable();
-
 	/*
-	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
-	 * is bogus.
+	 * No point in checking CS -- the only way to get here is a user mode
+	 * trap to a high address, which means that we're in 64-bit user code.
 	 */
-	if (regs->cs != __USER_CS) {
-		/*
-		 * If we trapped from kernel mode, we might as well OOPS now
-		 * instead of returning to some random address and OOPSing
-		 * then.
-		 */
-		BUG_ON(!user_mode(regs));
 
-		/* Compat mode and non-compat 32-bit CS should both segfault. */
-		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc from 32-bit mode");
-		goto sigsegv;
+	WARN_ON_ONCE(address != regs->ip);
+
+	if (vsyscall_mode == NONE) {
+		warn_bad_vsyscall(KERN_INFO, regs,
+				  "vsyscall attempted with vsyscall=none");
+		return false;
 	}
 
-	/*
-	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
-	 * and int 0xcc is two bytes long.
-	 */
-	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
+	vsyscall_nr = addr_to_vsyscall_nr(address);
+
+	trace_emulate_vsyscall(vsyscall_nr);
+
 	if (vsyscall_nr < 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc (exploit attempt?)");
+				  "misaligned vsyscall (exploit attempt or buggy program) -- look up the vsyscall kernel parameter if you need a workaround");
 		goto sigsegv;
 	}
 
 	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
-		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "vsyscall with bad stack (exploit attempt?)");
 		goto sigsegv;
 	}
 
@@ -202,13 +216,11 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	regs->ip = caller;
 	regs->sp += 8;
 
-	local_irq_disable();
-	return;
+	return true;
 
 sigsegv:
-	regs->ip -= 2;  /* The faulting instruction should be the int 0xcc. */
 	force_sig(SIGSEGV, current);
-	local_irq_disable();
+	return true;
 }
 
 /*
@@ -256,15 +268,21 @@ cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 
 void __init map_vsyscall(void)
 {
-	extern char __vsyscall_0;
-	unsigned long physaddr_page0 = __pa_symbol(&__vsyscall_0);
+	extern char __vsyscall_page;
+	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
 	extern char __vvar_page;
 	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
-	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
-	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
+	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_vsyscall,
+		     vsyscall_mode == NATIVE
+		     ? PAGE_KERNEL_VSYSCALL
+		     : PAGE_KERNEL_VVAR);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_FIRST_PAGE) !=
+		     (unsigned long)VSYSCALL_START);
+
 	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) != (unsigned long)VVAR_ADDRESS);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
+		     (unsigned long)VVAR_ADDRESS);
 }
 
 static int __init vsyscall_init(void)
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index ffa845e..c9596a9 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -7,21 +7,31 @@
  */
 
 #include <linux/linkage.h>
+
 #include <asm/irq_vectors.h>
+#include <asm/page_types.h>
+#include <asm/unistd_64.h>
+
+__PAGE_ALIGNED_DATA
+	.globl __vsyscall_page
+	.balign PAGE_SIZE, 0xcc
+	.type __vsyscall_page, @object
+__vsyscall_page:
+
+	mov $__NR_gettimeofday, %rax
+	syscall
+	ret
 
-/* The unused parts of the page are filled with 0xcc by the linker script. */
+	.balign 1024, 0xcc
+	mov $__NR_time, %rax
+	syscall
+	ret
 
-.section .vsyscall_0, "a"
-ENTRY(vsyscall_0)
-	int $VSYSCALL_EMU_VECTOR
-END(vsyscall_0)
+	.balign 1024, 0xcc
+	mov $__NR_getcpu, %rax
+	syscall
+	ret
 
-.section .vsyscall_1, "a"
-ENTRY(vsyscall_1)
-	int $VSYSCALL_EMU_VECTOR
-END(vsyscall_1)
+	.balign 4096, 0xcc
 
-.section .vsyscall_2, "a"
-ENTRY(vsyscall_2)
-	int $VSYSCALL_EMU_VECTOR
-END(vsyscall_2)
+	.size __vsyscall_page, 4096
diff --git a/arch/x86/kernel/vsyscall_trace.h b/arch/x86/kernel/vsyscall_trace.h
new file mode 100644
index 0000000..a8b2ede
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_trace.h
@@ -0,0 +1,29 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vsyscall
+
+#if !defined(__VSYSCALL_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __VSYSCALL_TRACE_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(emulate_vsyscall,
+
+	    TP_PROTO(int nr),
+
+	    TP_ARGS(nr),
+
+	    TP_STRUCT__entry(__field(int, nr)),
+
+	    TP_fast_assign(
+			   __entry->nr = nr;
+			   ),
+
+	    TP_printk("nr = %d", __entry->nr)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../arch/x86/kernel
+#define TRACE_INCLUDE_FILE vsyscall_trace
+#include <trace/define_trace.h>
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4d09df0..247aae3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -105,7 +105,7 @@ check_prefetch_opcode(struct pt_regs *regs, unsigned char *instr,
 		 * but for now it's good enough to assume that long
 		 * mode only uses well known segments or kernel.
 		 */
-		return (!user_mode(regs)) || (regs->cs == __USER_CS);
+		return (!user_mode(regs) || user_64bit_mode(regs));
 #endif
 	case 0x60:
 		/* 0x64 thru 0x67 are valid prefixes in all modes. */
@@ -720,6 +720,18 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		if (is_errata100(regs, address))
 			return;
 
+#ifdef CONFIG_X86_64
+		/*
+		 * Instruction fetch faults in the vsyscall page might need
+		 * emulation.
+		 */
+		if (unlikely((error_code & PF_INSTR) &&
+			     ((address & ~0xfff) == VSYSCALL_START))) {
+			if (emulate_vsyscall(regs, address))
+				return;
+		}
+#endif
+
 		if (unlikely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1b979c1..01f5e3b 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -9,6 +9,7 @@ __PAGE_ALIGNED_DATA
 vdso_start:
 	.incbin "arch/x86/vdso/vdso.so"
 vdso_end:
+	.align PAGE_SIZE /* extra data here leaks to userspace. */
 
 .previous
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 974a528..e2345af 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -951,6 +951,10 @@ static const struct pv_info xen_info __initconst = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
 
+#ifdef CONFIG_X86_64
+	.extra_user_64bit_cs = FLAT_USER_CS64,
+#endif
+
 	.name = "Xen",
 };
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f987bde..8cce339 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+	case VVAR_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
@@ -1956,7 +1957,8 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
+	    idx == VVAR_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}

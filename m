Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1HKAbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:31:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:48257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1HKAbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:31:34 -0400
Date: Thu, 11 Aug 2011 00:31:25 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-3ae36655b97a03fa1decf72f04078ef945647c1a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu>
References: <8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Rework vsyscall emulation and add vsyscall= parameter
Git-Commit-ID: 3ae36655b97a03fa1decf72f04078ef945647c1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Aug 2011 00:31:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ae36655b97a03fa1decf72f04078ef945647c1a
Gitweb:     http://git.kernel.org/tip/3ae36655b97a03fa1decf72f04078ef945647c1a
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 10 Aug 2011 11:15:32 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 10 Aug 2011 19:26:46 -0500

x86-64: Rework vsyscall emulation and add vsyscall= parameter

There are three choices:

vsyscall=native: Vsyscalls are native code that issues the
corresponding syscalls.

vsyscall=emulate (default): Vsyscalls are emulated by instruction
fault traps, tested in the bad_area path.  The actual contents of
the vsyscall page is the same as the vsyscall=native case except
that it's marked NX.  This way programs that make assumptions about
what the code in the page does will not be confused when they read
that code.

vsyscall=none: Trying to execute a vsyscall will segfault.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |   21 +++++++++
 arch/x86/include/asm/irq_vectors.h  |    4 --
 arch/x86/include/asm/traps.h        |    2 -
 arch/x86/include/asm/vsyscall.h     |    6 +++
 arch/x86/kernel/entry_64.S          |    1 -
 arch/x86/kernel/traps.c             |    6 ---
 arch/x86/kernel/vmlinux.lds.S       |   33 --------------
 arch/x86/kernel/vsyscall_64.c       |   79 +++++++++++++++++++++-------------
 arch/x86/kernel/vsyscall_emu_64.S   |   36 ++++++++++------
 arch/x86/mm/fault.c                 |   12 +++++
 10 files changed, 111 insertions(+), 89 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index aa47be7..9cfd6bb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2657,6 +2657,27 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index a563c50..2c224e1 100644
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
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e949793..46792d9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1123,7 +1123,6 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
-zeroentry emulate_vsyscall do_emulate_vsyscall
 
 
 	/* Reload gs selector with exception handling */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index fbc097a..b9b6716 100644
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
index 8f3a265..0f703f1 100644
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
@@ -174,38 +173,6 @@ SECTIONS
 
        . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
 
-#define VSYSCALL_ADDR (-10*1024*1024)
-
-#define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
-#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
-
-#define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
-#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
-
-	__vsyscall_0 = .;
-
-	. = VSYSCALL_ADDR;
-	.vsyscall : AT(VLOAD(.vsyscall)) {
-		/* work around gold bug 13023 */
-		__vsyscall_beginning_hack = .;
-		*(.vsyscall_0)
-
-		. = __vsyscall_beginning_hack + 1024;
-		*(.vsyscall_1)
-
-		. = __vsyscall_beginning_hack + 2048;
-		*(.vsyscall_2)
-
-		. = __vsyscall_beginning_hack + 4096;  /* Pad the whole page. */
-	} :user =0xcc
-	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
-
-#undef VSYSCALL_ADDR
-#undef VLOAD_OFFSET
-#undef VLOAD
-#undef VVIRT_OFFSET
-#undef VVIRT
-
 #endif /* CONFIG_X86_64 */
 
 	/* Init code and data - will be freed after init */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index bf8e9ff..18ae83d 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -56,6 +56,27 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
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
 
@@ -118,45 +139,39 @@ static int addr_to_vsyscall_nr(unsigned long addr)
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
+	/*
+	 * No point in checking CS -- the only way to get here is a user mode
+	 * trap to a high address, which means that we're in 64-bit user code.
+	 */
 
-	if (!user_64bit_mode(regs)) {
-		/*
-		 * If we trapped from kernel mode, we might as well OOPS now
-		 * instead of returning to some random address and OOPSing
-		 * then.
-		 */
-		BUG_ON(!user_mode(regs));
+	WARN_ON_ONCE(address != regs->ip);
 
-		/* Compat mode and non-compat 32-bit CS should both segfault. */
-		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc from 32-bit mode");
-		goto sigsegv;
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
 
 	trace_emulate_vsyscall(vsyscall_nr);
 
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
 
@@ -201,13 +216,11 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
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
@@ -255,15 +268,21 @@ cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 
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
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c1d0182..e58935c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
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
 

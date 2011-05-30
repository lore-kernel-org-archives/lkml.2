Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1E3Dti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:38 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:64801 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab1E3Dtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:35 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-8a-4de313d05128
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 04/10] x86-64: Replace vsyscall gettimeofday fallback with int 0xcc
Date: Sun, 29 May 2011 23:48:41 -0400
Message-Id: <c1e81b6521b0ae2c8999fbd18c0280b225ad98bc.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsUixCmqrXtB+LGvwdZNVhZz1q9hs+i7cpTd
	YtY1XovPG/6xWRz49ZTN4v3V7WwWl3fNYbN40nyd0WLLpWZWiw8TN7BZbN40ldniUd9bdosf
	Gx6zOvB6fG/tY/E4duYwo8ettj/MHjtn3WX32LxCy+P/yyNsHptWdbJ5vDt3jt3jxIzfLB7H
	zzh7fN4kF8AdxWWTkpqTWZZapG+XwJWx/VRCwSX7ipNnJzE3MP4w7mLk5JAQMJHYfqqHFcIW
	k7hwbz1bFyMXh5DAPkaJO9ceMEE4GxglZq/vhXKeMUm8+LqVHaSFTUBFomMpSBUHh4iAvsTV
	z4wgNcwCz5klHjzcBTZWWCBMYt7LvUwgNouAqsSyhjVsIDavQJBEy8PnjBCrFSSuXJnHAmJz
	ChhInLxzD8wWApo579ZbNlziExgFFjAyrGKUTcmt0s1NzMwpTk3WLU5OzMtLLdI10cvNLNFL
	TSndxAiOEEn+HYzfDiodYhTgYFTi4bUseuQrxJpYVlyZe4hRkoNJSZT3keBjXyG+pPyUyozE
	4oz4otKc1OJDjBIczEoivOq/gMp5UxIrq1KL8mFS0hwsSuK8syTVfYUE0hNLUrNTUwtSi2Cy
	MhwcShK8YcBEICRYlJqeWpGWmVOCkGbi4AQZzgM0XB9kMW9xQWJucWY6RP4Uoy5H49odBxmF
	WPLy81KlxHltQAYJgBRllObBzYEltleM4kBvCfNeEQKq4gEmRbhJr4CWMAEt6X33EGRJSSJC
	SqqBcULVGZ0EleVTvOsOfX4gYRY9cfqGw14CznfZU1k+1ytumdi8UOLL5J/eSU/+3O5m/zF/
	28awQm6BlZ+sHad9S491ZHVjfnmR45fL8asHlPecfGfD427z3F+g4f1zXqVfWlmr5sfPiU36
	WGvTnmsheL1qyy3Xha/rV6d0598wSN+v6Cs7LWyTjhJLcUaioRZzUXEiACAjJGRHAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the only way to issue a syscall with side effects through the
vsyscall page is to call a misaligned instruction.  I haven't
checked for that.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/irq_vectors.h |    6 ++-
 arch/x86/include/asm/traps.h       |    4 ++
 arch/x86/include/asm/vsyscall.h    |    6 +++
 arch/x86/kernel/entry_64.S         |    2 +
 arch/x86/kernel/traps.c            |    4 ++
 arch/x86/kernel/vsyscall_64.c      |   83 +++++++++++++++++++++++++++++++++---
 6 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..a563c50 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -17,7 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts
+ *  Vector  204         : legacy x86_64 vsyscall emulation
+ *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device interrupts
  *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
@@ -50,6 +51,9 @@
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
 #endif
+#ifdef CONFIG_X86_64
+# define VSYSCALL_EMU_VECTOR		0xcc
+#endif
 
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0310da6..2bae0a5 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_TRAPS_H
 #define _ASM_X86_TRAPS_H
 
+#include <linux/kprobes.h>
+
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
@@ -38,6 +40,7 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
+asmlinkage void emulate_vsyscall(void);
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
@@ -64,6 +67,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *, long);
 dotraplinkage void do_machine_check(struct pt_regs *, long);
 #endif
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_emulate_vsyscall(struct pt_regs *, long);
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *, long);
 #endif
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d555973..293ae08 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -31,6 +31,12 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
+/* Emulation */
+static inline bool in_vsyscall_page(unsigned long addr)
+{
+	return (addr & ~(PAGE_SIZE - 1)) == VSYSCALL_START;
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..bee7e81 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1121,6 +1121,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
+zeroentry emulate_vsyscall do_emulate_vsyscall
+
 
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..72f0f6a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -872,6 +872,10 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 
+	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
+	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3e8dac7..53d2237 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -32,6 +32,8 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
+#include <linux/syscalls.h>
+#include <linux/ratelimit.h>
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
@@ -44,10 +46,10 @@
 #include <asm/desc.h>
 #include <asm/topology.h>
 #include <asm/vgtod.h>
+#include <asm/traps.h>
 
 #define __vsyscall(nr) \
 		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
-#define __syscall_clobber "r11","cx","memory"
 
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
@@ -84,6 +86,26 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
+static void warn_bad_vsyscall(struct pt_regs *regs, bool is_warning,
+			      const char *message)
+{
+	struct task_struct *tsk;
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+	if (!show_unhandled_signals || !__ratelimit(&rs))
+		return;
+
+	tsk = current;
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
+	       is_warning ? KERN_WARNING : KERN_INFO,
+	       tsk->comm, task_pid_nr(tsk),
+	       message,
+	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	if (!in_vsyscall_page(regs->ip - 2))
+		print_vma_addr(" in ", regs->ip - 2);
+	printk("\n");
+}
+
 /* RED-PEN may want to readd seq locking, but then the variable should be
  * write-once.
  */
@@ -92,13 +114,14 @@ static __always_inline void do_get_tz(struct timezone * tz)
 	*tz = VVAR(vsyscall_gtod_data).sys_tz;
 }
 
-static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
+static __always_inline int fallback_gettimeofday(struct timeval *tv)
 {
 	int ret;
-	asm volatile("syscall"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
+	/* Invoke do_emulate_vsyscall. */
+	asm volatile("movb $0xce, %%al;\n\t"
+		     "int %[vec]"
+		     : "=a" (ret)
+		     : "D" (tv), [vec] "i" (VSYSCALL_EMU_VECTOR));
 	return ret;
 }
 
@@ -113,7 +136,7 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 
 		vread = VVAR(vsyscall_gtod_data).clock.vread;
 		if (unlikely(!vread)) {
-			gettimeofday(tv,NULL);
+			fallback_gettimeofday(tv);
 			return;
 		}
 
@@ -214,6 +237,52 @@ static long __vsyscall(3) venosys_1(void)
 	return -ENOSYS;
 }
 
+void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
+{
+	long ret;
+
+	/* Kernel code must never get here. */
+	BUG_ON(!user_mode(regs));
+
+	local_irq_enable();
+
+	if ((regs->ax & 0xFF) != 0xce) {
+		warn_bad_vsyscall(regs, false, "illegal int 0xcc "
+				  "(exploit attempt?)");
+		force_sig(SIGSEGV, current);
+		goto out;
+	}
+
+	if (!in_vsyscall_page(regs->ip)) {
+		/*
+		 * We allow the call because tools like ThreadSpotter
+		 * might copy the int 0xcc instruction to user memory.
+		 * We make it annoying, though, to try to persuade
+		 * the authors to stop doing that...
+		 */
+		warn_bad_vsyscall(regs, true, "int 0xcc in user code (exploit"
+				  " attempt? legacy instrumented code?)");
+	}
+
+	if (current->seccomp.mode) {
+		do_exit(SIGKILL);
+		goto out;
+	}
+
+	ret = sys_gettimeofday((struct timeval __user *)regs->di, NULL);
+	if (ret == -EFAULT) {
+		warn_bad_vsyscall(regs, true, "int 0xcc faulted (exploit "
+				  "attempt?)");
+		force_sig(SIGSEGV, current);
+		goto out;
+	}
+
+	regs->ax = ret;
+
+out:
+	local_irq_disable();
+}
+
 /* Assume __initcall executes before all user space. Hopefully kmod
    doesn't violate that. We'll find out if it does. */
 static void __cpuinit vsyscall_set_cpu(int cpu)
-- 
1.7.5.1


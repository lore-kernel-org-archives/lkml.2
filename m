Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1E3Duv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:50:51 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:58888 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab1E3Dtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:47 -0400
X-AuditID: 1209190c-b7c65ae00000117c-6e-4de313e2a5bf
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
Subject: [PATCH v2 08/10] x86-64: Emulate vsyscalls
Date: Sun, 29 May 2011 23:48:45 -0400
Message-Id: <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsUixG6nrvtI+LGvwaJ1nBZz1q9hs+i7cpTd
	YtY1XovPG/6xWRz49ZTN4v3V7WwWl3fNYbN40nyd0WLLpWZWiw8TN7BZbN40ldniUd9bdosf
	Gx6zOvB6fG/tY/E4duYwo8ettj/MHjtn3WX32LxCy+P/yyNsHptWdbJ5vDt3jt3jxIzfLB7H
	zzh7fN4kF8AdxWWTkpqTWZZapG+XwJXR1nePveCXW8Wul0vYGxhPW3QxcnJICJhI7Jq/lBnC
	FpO4cG89WxcjF4eQwD5GiQmzW1ggnA2MEjP3r2WFcJ4xSTw428EI0sImoCLRsfQBUxcjB4eI
	gL7E1c+MIDXMAs+ZJR483MUKUiMsYCyx5/s7sBUsAqoSn+ZMZwGxeQWCJA5M2sgEsVpB4sqV
	eWBxTgEDiZN37oHZQkAz5916y4ZLfAKjwAJGhlWMsim5Vbq5iZk5xanJusXJiXl5qUW6hnq5
	mSV6qSmlmxhBMcIpybOD8c1BpUOMAhyMSjy8xkWPfIVYE8uKK3MPMUpyMCmJ8j4SfOwrxJeU
	n1KZkVicEV9UmpNafIhRgoNZSYRX/RdQOW9KYmVValE+TEqag0VJnHeGpLqvkEB6Yklqdmpq
	QWoRTFaGg0NJgjcMmAqEBItS01Mr0jJzShDSTBycIMN5gIbrgyzmLS5IzC3OTIfIn2LU5Whc
	u+MgoxBLXn5eqpQ4rw3IIAGQoozSPLg5sNT2ilEc6C1h3itCQFU8wLQIN+kV0BImoCW97x6C
	LClJREhJNTB2l9gtXWD4VpXl3IY7shOXHP060bh17t/d5p8fcZr1pGw7w9CjUDO9RlSi6XtC
	s0TYUyPLMNWLr2UPfuSo+9V+Uf+E4NFt7yNP6varcwnOeyW7Pi5kV8CO8/53bEVnhUWmbeC/
	4uLRV5DzRV+qlVPP6G74jP3VbY/n5UjK7l5g/P++WIBpSKgSS3FGoqEWc1FxIgAVa0YZSAMA
	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a fair amount of code in the vsyscall page, and who knows
what will happen if an exploit jumps into the middle of it.  Reduce
the risk by replacing most of it with short magic incantations that
are useless if entered in the middle.  This change can be disabled
by CONFIG_UNSAFE_VSYSCALLS (default y).

This causes vsyscalls to be a little more expensive than real
syscalls.  Fortunately sensible programs don't use them.

Some care is taken to make sure that tools like valgrind and
ThreadSpotter still work.

This patch is not perfect: the vread_tsc and vread_hpet functions
are still at a fixed address.  Fixing that might involve making
alternative patching work in the vDSO.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/Kconfig                  |   17 +++++
 arch/x86/kernel/Makefile          |    3 +
 arch/x86/kernel/vsyscall_64.c     |  121 +++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/vsyscall_emu_64.S |   40 ++++++++++++
 4 files changed, 176 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..186018b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1650,6 +1650,23 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
+config UNSAFE_VSYSCALLS
+	def_bool y
+	prompt "Unsafe fast legacy vsyscalls"
+	depends on X86_64
+	---help---
+	  Legacy user code expects to be able to issue three syscalls
+	  by calling fixed addresses in kernel space.  If you say N,
+	  then the kernel traps and emulates these calls.  If you say
+	  Y, then there is actual executable code at a fixed address
+	  to implement these calls efficiently.
+
+	  On a system with recent enough glibc (probably 2.14 or
+	  newer) and no static binaries, you can say N without a
+	  performance penalty to improve security
+
+	  If unsure, say Y.
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a24521b..b901781 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -42,6 +42,9 @@ obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
+ifndef CONFIG_UNSAFE_VSYSCALLS
+	obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+endif
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 71fa506..5b3d62a 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -48,9 +48,6 @@
 #include <asm/vgtod.h>
 #include <asm/traps.h>
 
-#define __vsyscall(nr) \
-		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
-
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
@@ -96,6 +93,7 @@ static void warn_bad_vsyscall(struct pt_regs *regs, bool is_warning,
 		return;
 
 	tsk = current;
+
 	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
 	       is_warning ? KERN_WARNING : KERN_INFO,
 	       tsk->comm, task_pid_nr(tsk),
@@ -106,6 +104,12 @@ static void warn_bad_vsyscall(struct pt_regs *regs, bool is_warning,
 	printk("\n");
 }
 
+#ifdef CONFIG_UNSAFE_VSYSCALLS
+
+#define __vsyscall(nr)							\
+	__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
+
+
 /* RED-PEN may want to readd seq locking, but then the variable should be
  * write-once.
  */
@@ -117,8 +121,11 @@ static __always_inline void do_get_tz(struct timezone * tz)
 static __always_inline int fallback_gettimeofday(struct timeval *tv)
 {
 	int ret;
-	/* Invoke do_emulate_vsyscall. */
-	asm volatile("movb $0xce, %%al;\n\t"
+	/*
+	 * Invoke do_emulate_vsyscall.  Intentionally incompatible with
+	 * the CONFIG_UNSAFE_VSYSCALLS=n case.
+	 */
+	asm volatile("mov $0xce, %%al;\n\t"
 		     "int %[vec]"
 		     : "=a" (ret)
 		     : "D" (tv), [vec] "i" (VSYSCALL_EMU_VECTOR));
@@ -237,6 +244,8 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	long ret;
 
 	/* Kernel code must never get here. */
+	if (!user_mode(regs))
+		early_printk("oh crap!\n");
 	BUG_ON(!user_mode(regs));
 
 	local_irq_enable();
@@ -278,6 +287,106 @@ out:
 	local_irq_disable();
 }
 
+#else /* CONFIG_UNSAFE_VSYSCALLS=n below */
+
+static inline unsigned long vsyscall_intcc_addr(int vsyscall_nr)
+{
+	return VSYSCALL_START + 1024*vsyscall_nr + 2;
+}
+
+void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
+{
+	u8 vsyscall_nr, al;
+	long ret;
+
+	/* Kernel code must never get here. */
+	BUG_ON(!user_mode(regs));
+
+	local_irq_enable();
+
+	/*
+	 * Decode the vsyscall number.
+	 * 0xcc -> 0, 0xce -> 1, 0xf0 -> 2; see vsyscall_emu_64.S for why.
+	 */
+	al = regs->ax & 0xff;
+	vsyscall_nr = (al - 0xcc) >> 1;
+	if (vsyscall_nr > 2 || al != (vsyscall_nr << 1) + 0xcc) {
+		warn_bad_vsyscall(regs, false, "illegal int 0xcc "
+				  "(exploit attempt?)");
+		force_sig(SIGSEGV, current);
+		goto out;
+	}
+
+	if (regs->ip - 2 != vsyscall_intcc_addr(vsyscall_nr)) {
+		if (in_vsyscall_page(regs->ip - 2)) {
+			/* This should not be possible. */
+			warn_bad_vsyscall(regs, true, "int 0xcc severe badness"
+					  " (exploit attempt?)");
+			force_sig(SIGSEGV, current);
+			goto out;
+		} else {
+			/*
+			 * We allow the call because tools like ThreadSpotter
+			 * might copy the int 0xcc instruction to user memory.
+			 * We make it annoying, though, to try to persuade
+			 * the authors to stop doing that...
+			 */
+			warn_bad_vsyscall(regs, true, "int 0xcc in user code "
+					  "(exploit attempt? legacy "
+					  "instrumented code?)");
+		}
+	}
+
+	if (current->seccomp.mode) {
+		do_exit(SIGKILL);
+		goto out;
+	}
+
+	switch(vsyscall_nr)
+	{
+	case 0:
+		ret = sys_gettimeofday(
+			(struct timeval __user *)regs->di,
+			(struct timezone __user *)regs->si);
+		break;
+
+	case 1:
+		ret = sys_time((time_t __user *)regs->di);
+		break;
+
+	case 2:
+		ret = sys_getcpu((unsigned __user *)regs->di,
+				 (unsigned __user *)regs->si,
+				 0);
+		break;
+
+	default:
+		unreachable();
+	}
+
+	if (ret == -EFAULT) {
+		/*
+		 * Bad news -- userspace fed a bad pointer to a vsyscall.
+		 *
+		 * With a real vsyscall, that would have caused SIGSEGV.
+		 * To make writing reliable exploits using the emulated
+		 * vsyscalls harder, generate SIGSEGV here as well.
+		 */
+		warn_bad_vsyscall(regs, false,
+				  "vsyscall fault (exploit attempt?)");
+		force_sig(SIGSEGV, current);
+		goto out;
+	}
+
+	regs->ax = ret;
+
+out:
+	local_irq_disable();
+	return;
+}
+
+#endif /* CONFIG_UNSAFE_VSYSCALLS */
+
 /* Assume __initcall executes before all user space. Hopefully kmod
    doesn't violate that. We'll find out if it does. */
 static void __cpuinit vsyscall_set_cpu(int cpu)
@@ -331,11 +440,13 @@ void __init map_vsyscall(void)
 
 static int __init vsyscall_init(void)
 {
+#ifdef CONFIG_UNSAFE_VSYSCALLS
 	BUG_ON(((unsigned long) &vgettimeofday !=
 			VSYSCALL_ADDR(__NR_vgettimeofday)));
 	BUG_ON((unsigned long) &vtime != VSYSCALL_ADDR(__NR_vtime));
 	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
 	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
+#endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
new file mode 100644
index 0000000..3e1cad2
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -0,0 +1,40 @@
+/*
+ * vsyscall_emu_64.S: Vsyscall emulation page
+ * Copyright (c) 2011 Andy Lutomirski
+ * Subject to the GNU General Public License, version 2
+*/
+
+#include <linux/linkage.h>
+#include <asm/irq_vectors.h>
+
+/*
+ * These magic incantations are chosen so that they fault if entered anywhere
+ * other than an instruction boundary.  The movb instruction is two bytes, and
+ * the int imm8 instruction is also two bytes, so the only misaligned places
+ * to enter are the immediate values for the two instructions.  0xcc is int3
+ * (always faults), 0xce is into (faults on x64-64, and 32-bit code can't get
+ * here), and 0xf0 is lock (lock int is invalid).
+ *
+ * The unused parts of the page are filled with 0xcc by the linker script.
+ */
+
+.section .vsyscall_0, "a"
+ENTRY(vsyscall_0)
+	movb $0xcc, %al
+	int $VSYSCALL_EMU_VECTOR
+	ret
+END(vsyscall_0)
+
+.section .vsyscall_1, "a"
+ENTRY(vsyscall_1)
+	movb $0xce, %al
+	int $VSYSCALL_EMU_VECTOR
+	ret
+END(vsyscall_1)
+
+.section .vsyscall_2, "a"
+ENTRY(vsyscall_2)
+	movb $0xf0, %al
+	int $VSYSCALL_EMU_VECTOR
+	ret
+END(vsyscall_2)
-- 
1.7.5.1


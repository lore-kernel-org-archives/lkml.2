Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1FESDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:03:15 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:45316 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab1FESDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:03:10 -0400
X-AuditID: 1209190c-b7c65ae00000117c-0f-4debc4e55ef7
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Date: Sun,  5 Jun 2011 13:50:24 -0400
Message-Id: <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA3VSWUwTURT1daYz04bBcaj0gUtMxUDAWk1MfB/GGI1m/Kgxfml/cKADbexC
	Oq2hfigguKBQ+NAQwCVGo5BGSNGwBZFSQVEBEUGI4oJ1KQU0xIC4dkD0y79z7zn33HfzDoWx
	r+TxlNnmFBw23qIhlDhLbknUBgNj+vV555aiyhovgYr775IoMDBNovIBGk3V/iTQIz9Ed2aD
	BJp8Wk+gJ02VBGp43k+gt8cGAbrZd0yORr3vMfSptJZAdb6zGHpTPE6ivslPOJqpHZVvZbnp
	gmKc63jYDrjh498x7mLjZ8BdOTlDco3lL0iu7noy9+tjgOBKw88A56s+RXAT3d0kd6/sG851
	PtzOTflWcv76MLFnsUG52ShYzIcEh27LAaXp9Usya/AEyK4IV5A5oNpaCBQUZDbCyioPNo9j
	Ye9IDVEIlBTL3AbwccvbP0UNgEXePny+CMpg6fHWuRGCSYAnr76SFQKKUjE6+HQKSBqMuSiH
	vgencUkTwyA48u7rnB5n1sD8/Mo5TDN74f1zX4A0C5lVsKfaLrUVzHrYO/hILmE2Yukfv0/8
	r18CmEtgUTVYYbQe1lp5s0UU0rViOm+zCQ7thnVWs3OdYHT5gPR5irioBhBu0/gBQwFNFN3i
	HdOzcv6Q6Lb6QRwl0yylL7VHWtFpdqPbxIumVIfLIoh+AClMo6KPqEJ6ljby7sOCw75ALaNw
	jZoui0vUs0wm7xQOCkKW4Fhgl1OUBtJJkcCwSxxCppCdYbY4/9EySiGZR0XMN0kaWsziraI5
	c57vAlrq1r3xNsDiNrtNiFfTIel1jCQyuWx/fRaCGQLqyFkxtEKyiorE9q9TKLJEFlnSuU26
	QHTy/6j4HLA7OfvCFc9wQIXtsDfSZT+q2q6pPW09a5tzOoY/XI7enpp63r2zvduT1lwQ635J
	Jo20rJ2dHTqTlLKrqFDM6Ik2nChKOMpltDtrp4M62OzKatUHV1cN/TJ4VcayG6HEU7ldihLD
	sGv/hJfNlDfl7TubEoZif+60NT9dx8x+1OCiid+QjDlE/jf1xnflcwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a fair amount of code in the vsyscall page.  It contains a
syscall instruction (in the gettimeofday fallback) and who knows
what will happen if an exploit jumps into the middle of some other
code.

Reduce the risk by replacing the vsyscalls with short magic
incantations that cause the kernel to emulate the real vsyscalls.
These incantations are useless if entered in the middle.

This causes vsyscalls to be a little more expensive than real
syscalls.  Fortunately sensible programs don't use them.

Less fortunately, current glibc uses the vsyscall for time() even in
dynamic binaries.  So there's a CONFIG_UNSAFE_VSYSCALLS (default y)
option that leaves in the native code for time().  That should go
away in awhile when glibc gets fixed.

Some care is taken to make sure that tools like valgrind and
ThreadSpotter still work.

This patch is not perfect: the vread_tsc and vread_hpet functions
are still at a fixed address.  Fixing that might involve making
alternative patching work in the vDSO.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/Kconfig                   |   17 +++
 arch/x86/include/asm/irq_vectors.h |    6 +-
 arch/x86/include/asm/traps.h       |    4 +
 arch/x86/include/asm/vsyscall.h    |    6 +
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/entry_64.S         |    2 +
 arch/x86/kernel/traps.c            |    6 +
 arch/x86/kernel/vsyscall_64.c      |  253 +++++++++++++++++++++---------------
 arch/x86/kernel/vsyscall_emu_64.S  |   42 ++++++
 9 files changed, 233 insertions(+), 104 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..79e5d8a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1646,6 +1646,23 @@ config COMPAT_VDSO
 
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
+	  to implement time() efficiently.
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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90b06d4..cc0469a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -44,6 +44,7 @@ obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
+obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 72c4a77..e949793 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1123,6 +1123,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
+zeroentry emulate_vsyscall do_emulate_vsyscall
+
 
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..fbc097a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -872,6 +872,12 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 
+#ifdef CONFIG_X86_64
+	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
+	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
+#endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index c7fe325..52ba392 100644
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
@@ -44,10 +46,7 @@
 #include <asm/desc.h>
 #include <asm/topology.h>
 #include <asm/vgtod.h>
-
-#define __vsyscall(nr) \
-		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
-#define __syscall_clobber "r11","cx","memory"
+#include <asm/traps.h>
 
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
@@ -84,73 +83,45 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-/* RED-PEN may want to readd seq locking, but then the variable should be
- * write-once.
- */
-static __always_inline void do_get_tz(struct timezone * tz)
+static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
+			      const char *message)
 {
-	*tz = VVAR(vsyscall_gtod_data).sys_tz;
+	struct task_struct *tsk;
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+
+	if (!show_unhandled_signals || !__ratelimit(&rs))
+		return;
+
+	tsk = current;
+
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
+	       level, tsk->comm, task_pid_nr(tsk),
+	       message,
+	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	if (!in_vsyscall_page(regs->ip - 2))
+		print_vma_addr(" in ", regs->ip - 2);
+	printk("\n");
 }
 
-static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
-{
-	int ret;
-	asm volatile("syscall"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
-	return ret;
-}
+/* al values for each vsyscall; see vsyscall_emu_64.S for why. */
+static u8 vsyscall_nr_to_al[] = {0xcc, 0xce, 0xf0};
 
-static __always_inline void do_vgettimeofday(struct timeval * tv)
+static int al_to_vsyscall_nr(u8 al)
 {
-	cycle_t now, base, mask, cycle_delta;
-	unsigned seq;
-	unsigned long mult, shift, nsec;
-	cycle_t (*vread)(void);
-	do {
-		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
-
-		vread = VVAR(vsyscall_gtod_data).clock.vread;
-		if (unlikely(!vread)) {
-			gettimeofday(tv,NULL);
-			return;
-		}
-
-		now = vread();
-		base = VVAR(vsyscall_gtod_data).clock.cycle_last;
-		mask = VVAR(vsyscall_gtod_data).clock.mask;
-		mult = VVAR(vsyscall_gtod_data).clock.mult;
-		shift = VVAR(vsyscall_gtod_data).clock.shift;
-
-		tv->tv_sec = VVAR(vsyscall_gtod_data).wall_time_sec;
-		nsec = VVAR(vsyscall_gtod_data).wall_time_nsec;
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
-
-	/* calculate interval: */
-	cycle_delta = (now - base) & mask;
-	/* convert to nsecs: */
-	nsec += (cycle_delta * mult) >> shift;
-
-	while (nsec >= NSEC_PER_SEC) {
-		tv->tv_sec += 1;
-		nsec -= NSEC_PER_SEC;
-	}
-	tv->tv_usec = nsec / NSEC_PER_USEC;
+	int i;
+	for (i = 0; i < ARRAY_SIZE(vsyscall_nr_to_al); i++)
+		if (vsyscall_nr_to_al[i] == al)
+			return i;
+	return -1;
 }
 
-int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
-{
-	if (tv)
-		do_vgettimeofday(tv);
-	if (tz)
-		do_get_tz(tz);
-	return 0;
-}
+#ifdef CONFIG_UNSAFE_VSYSCALLS
 
 /* This will break when the xtime seconds get inaccurate, but that is
  * unlikely */
-time_t __vsyscall(1) vtime(time_t *t)
+time_t __attribute__ ((unused, __section__(".vsyscall_1"))) notrace
+vtime(time_t *t)
 {
 	unsigned seq;
 	time_t result;
@@ -167,48 +138,127 @@ time_t __vsyscall(1) vtime(time_t *t)
 	return result;
 }
 
-/* Fast way to get current CPU and node.
-   This helps to do per node and per CPU caches in user space.
-   The result is not guaranteed without CPU affinity, but usually
-   works out because the scheduler tries to keep a thread on the same
-   CPU.
+#endif /* CONFIG_UNSAFE_VSYSCALLS */
+
+/* If CONFIG_UNSAFE_VSYSCALLS=y, then this is incorrect for vsyscall_nr == 1. */
+static inline unsigned long vsyscall_intcc_addr(int vsyscall_nr)
+{
+	return VSYSCALL_START + 1024*vsyscall_nr + 2;
+}
 
-   tcache must point to a two element sized long array.
-   All arguments can be NULL. */
-long __vsyscall(2)
-vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
+void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
-	unsigned int p;
-	unsigned long j = 0;
-
-	/* Fast cache - only recompute value once per jiffies and avoid
-	   relatively costly rdtscp/cpuid otherwise.
-	   This works because the scheduler usually keeps the process
-	   on the same CPU and this syscall doesn't guarantee its
-	   results anyways.
-	   We do this here because otherwise user space would do it on
-	   its own in a likely inferior way (no access to jiffies).
-	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = VVAR(jiffies))) {
-		p = tcache->blob[1];
-	} else if (VVAR(vgetcpu_mode) == VGETCPU_RDTSCP) {
-		/* Load per CPU data from RDTSCP */
-		native_read_tscp(&p);
-	} else {
-		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	static DEFINE_RATELIMIT_STATE(rs, 3600 * HZ, 3);
+	struct task_struct *tsk;
+	const char *vsyscall_name;
+	int vsyscall_nr;
+	long ret;
+
+	/* Kernel code must never get here. */
+	BUG_ON(!user_mode(regs));
+
+	local_irq_enable();
+
+	vsyscall_nr = al_to_vsyscall_nr(regs->ax & 0xff);
+	if (vsyscall_nr < 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "illegal int 0xcc "
+				  "(exploit attempt?)");
+		goto sigsegv;
 	}
-	if (tcache) {
-		tcache->blob[0] = j;
-		tcache->blob[1] = p;
+
+	if (regs->ip - 2 != vsyscall_intcc_addr(vsyscall_nr)) {
+		if (in_vsyscall_page(regs->ip - 2)) {
+			/* This should not be possible. */
+			warn_bad_vsyscall(KERN_WARNING, regs,
+					  "int 0xcc bogus magic "
+					  "(exploit attempt?)");
+			goto sigsegv;
+		} else {
+			/*
+			 * We allow the call because tools like ThreadSpotter
+			 * might copy the int 0xcc instruction to user memory.
+			 * We make it annoying, though, to try to persuade
+			 * the authors to stop doing that...
+			 */
+			warn_bad_vsyscall(KERN_WARNING, regs,
+					  "int 0xcc in user code "
+					  "(exploit attempt? legacy "
+					  "instrumented code?)");
+		}
 	}
-	if (cpu)
-		*cpu = p & 0xfff;
-	if (node)
-		*node = p >> 12;
-	return 0;
-}
 
+	tsk = current;
+	if (tsk->seccomp.mode) {
+		do_exit(SIGKILL);
+		goto out;
+	}
+
+	switch (vsyscall_nr) {
+	case 0:
+		vsyscall_name = "gettimeofday";
+		ret = sys_gettimeofday(
+			(struct timeval __user *)regs->di,
+			(struct timezone __user *)regs->si);
+		break;
+
+	case 1:
+#ifdef CONFIG_UNSAFE_VSYSCALLS
+		warn_bad_vsyscall(KERN_WARNING, regs, "bogus time() vsyscall "
+				  "emulation (exploit attempt?)");
+		goto sigsegv;
+#else
+		vsyscall_name = "time";
+		ret = sys_time((time_t __user *)regs->di);
+		break;
+#endif
+
+	case 2:
+		vsyscall_name = "getcpu";
+		ret = sys_getcpu((unsigned __user *)regs->di,
+				 (unsigned __user *)regs->si,
+				 0);
+		break;
+
+	default:
+		BUG();
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
+		warn_bad_vsyscall(KERN_INFO, regs,
+				  "vsyscall fault (exploit attempt?)");
+		goto sigsegv;
+	}
+
+	regs->ax = ret;
+
+	if (__ratelimit(&rs)) {
+		unsigned long caller;
+		if (get_user(caller, (unsigned long __user *)regs->sp))
+			caller = 0;  /* no need to crash on this fault. */
+		printk(KERN_INFO "%s[%d] emulated legacy vsyscall %s(); "
+		       "upgrade your code to avoid a performance hit. "
+		       "ip:%lx sp:%lx caller:%lx",
+		       tsk->comm, task_pid_nr(tsk), vsyscall_name,
+		       regs->ip - 2, regs->sp, caller);
+		if (caller)
+			print_vma_addr(" in ", caller);
+		printk("\n");
+	}
+
+out:
+	local_irq_disable();
+	return;
+
+sigsegv:
+	regs->ip -= 2;  /* The faulting instruction should be the int 0xcc. */
+	force_sig(SIGSEGV, current);
 }
 
 /* Assume __initcall executes before all user space. Hopefully kmod
@@ -264,11 +314,8 @@ void __init map_vsyscall(void)
 
 static int __init vsyscall_init(void)
 {
-	BUG_ON(((unsigned long) &vgettimeofday !=
-			VSYSCALL_ADDR(__NR_vgettimeofday)));
-	BUG_ON((unsigned long) &vtime != VSYSCALL_ADDR(__NR_vtime));
-	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
-	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
+	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
+
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
new file mode 100644
index 0000000..7ebde61
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -0,0 +1,42 @@
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
+#ifndef CONFIG_UNSAFE_VSYSCALLS
+.section .vsyscall_1, "a"
+ENTRY(vsyscall_1)
+	movb $0xce, %al
+	int $VSYSCALL_EMU_VECTOR
+	ret
+END(vsyscall_1)
+#endif
+
+.section .vsyscall_2, "a"
+ENTRY(vsyscall_2)
+	movb $0xf0, %al
+	int $VSYSCALL_EMU_VECTOR
+	ret
+END(vsyscall_2)
-- 
1.7.5.2


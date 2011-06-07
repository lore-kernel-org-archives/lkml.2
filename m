Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1FGIF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:05:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1FGIF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:05:27 -0400
Date: Tue, 7 Jun 2011 08:03:58 GMT
From: tip-bot for Andy Lutomirski <luto@MIT.EDU>
Message-ID: <tip-5cec93c216db77c45f7ce970d46283bcb1933884@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        luto@MIT.EDU, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, luto@MIT.EDU,
        Louis.Rilling@kerlabs.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
In-Reply-To: <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
References: <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Emulate legacy vsyscalls
Git-Commit-ID: 5cec93c216db77c45f7ce970d46283bcb1933884
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 08:04:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cec93c216db77c45f7ce970d46283bcb1933884
Gitweb:     http://git.kernel.org/tip/5cec93c216db77c45f7ce970d46283bcb1933884
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Sun, 5 Jun 2011 13:50:24 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Jun 2011 10:02:35 +0200

x86-64: Emulate legacy vsyscalls

There's a fair amount of code in the vsyscall page.  It contains
a syscall instruction (in the gettimeofday fallback) and who
knows what will happen if an exploit jumps into the middle of
some other code.

Reduce the risk by replacing the vsyscalls with short magic
incantations that cause the kernel to emulate the real
vsyscalls. These incantations are useless if entered in the
middle.

This causes vsyscalls to be a little more expensive than real
syscalls.  Fortunately sensible programs don't use them.
The only exception is time() which is still called by glibc
through the vsyscall - but calling time() millions of times
per second is not sensible. glibc has this fixed in the
development tree.

This patch is not perfect: the vread_tsc and vread_hpet
functions are still at a fixed address.  Fixing that might
involve making alternative patching work in the vDSO.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu
[ Removed the CONFIG option - it's simpler to just do it unconditionally. Tidied up the code as well. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |    6 +-
 arch/x86/include/asm/traps.h       |    4 +
 arch/x86/include/asm/vsyscall.h    |   12 ++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/entry_64.S         |    2 +
 arch/x86/kernel/traps.c            |    6 +
 arch/x86/kernel/vsyscall_64.c      |  261 +++++++++++++++++-------------------
 arch/x86/kernel/vsyscall_emu_64.S  |   27 ++++
 include/linux/seccomp.h            |   10 ++
 9 files changed, 189 insertions(+), 140 deletions(-)

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
index d555973..bb710cb 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -31,6 +31,18 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
+/* Emulation */
+
+static inline bool is_vsyscall_entry(unsigned long addr)
+{
+	return (addr & ~0xC00UL) == VSYSCALL_START;
+}
+
+static inline int vsyscall_entry_nr(unsigned long addr)
+{
+	return (addr & 0xC00UL) >> 10;
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
index 70a5f6e..10cd8ac 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -2,6 +2,8 @@
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.
  *
+ *  [ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
+ *
  *  Thanks to hpa@transmeta.com for some useful hint.
  *  Special thanks to Ingo Molnar for his early experience with
  *  a different vsyscall implementation for Linux/IA32 and for the name.
@@ -11,10 +13,9 @@
  *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
  *  jumping out of line if necessary. We cannot add more with this
  *  mechanism because older kernels won't return -ENOSYS.
- *  If we want more than four we need a vDSO.
  *
- *  Note: the concept clashes with user mode linux. If you use UML and
- *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
+ *  Note: the concept clashes with user mode linux.  UML users should
+ *  use the vDSO.
  */
 
 /* Disable profiling for userspace code: */
@@ -32,6 +33,8 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
+#include <linux/syscalls.h>
+#include <linux/ratelimit.h>
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
@@ -44,10 +47,7 @@
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
@@ -71,146 +71,129 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	unsigned long flags;
 
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vread = clock->vread;
-	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
-	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = mult;
-	vsyscall_gtod_data.clock.shift = clock->shift;
-	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
-	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic = *wtm;
-	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
+	vsyscall_gtod_data.clock.vread		= clock->vread;
+	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
+	vsyscall_gtod_data.clock.mask		= clock->mask;
+	vsyscall_gtod_data.clock.mult		= mult;
+	vsyscall_gtod_data.clock.shift		= clock->shift;
+	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
+	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
+	vsyscall_gtod_data.wall_to_monotonic	= *wtm;
+	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
+
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
-}
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
+	struct task_struct *tsk;
 
-static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
-{
-	int ret;
-	asm volatile("syscall"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
-	return ret;
-}
+	if (!show_unhandled_signals || !__ratelimit(&rs))
+		return;
 
-static __always_inline void do_vgettimeofday(struct timeval * tv)
-{
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
-}
+	tsk = current;
 
-int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
-{
-	if (tv)
-		do_vgettimeofday(tv);
-	if (tz)
-		do_get_tz(tz);
-	return 0;
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	       level, tsk->comm, task_pid_nr(tsk),
+	       message, regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
 }
 
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
-time_t __vsyscall(1) vtime(time_t *t)
+void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
-	unsigned seq;
-	time_t result;
+	const char *vsyscall_name;
+	struct task_struct *tsk;
+	unsigned long caller;
+	int vsyscall_nr;
+	long ret;
+
+	/* Kernel code must never get here. */
+	BUG_ON(!user_mode(regs));
+
+	local_irq_enable();
+
+	/*
+	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
+	 * and int 0xcc is two bytes long.
+	 */
+	if (!is_vsyscall_entry(regs->ip - 2)) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "illegal int 0xcc (exploit attempt?)");
+		goto sigsegv;
+	}
+	vsyscall_nr = vsyscall_entry_nr(regs->ip - 2);
 
-	do {
-		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
+	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
+		goto sigsegv;
+	}
 
-		result = VVAR(vsyscall_gtod_data).wall_time_sec;
+	tsk = current;
+	if (seccomp_mode(&tsk->seccomp))
+		do_exit(SIGKILL);
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
+		vsyscall_name = "time";
+		ret = sys_time((time_t __user *)regs->di);
+		break;
+
+	case 2:
+		vsyscall_name = "getcpu";
+		ret = sys_getcpu((unsigned __user *)regs->di,
+				 (unsigned __user *)regs->si,
+				 0);
+		break;
+
+	default:
+		/*
+		 * If we get here, then vsyscall_nr indicates that int 0xcc
+		 * happened at an address in the vsyscall page that doesn't
+		 * contain int 0xcc.  That can't happen.
+		 */
+		BUG();
+	}
 
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
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
 
-	if (t)
-		*t = result;
-	return result;
-}
+	regs->ax = ret;
 
-/* Fast way to get current CPU and node.
-   This helps to do per node and per CPU caches in user space.
-   The result is not guaranteed without CPU affinity, but usually
-   works out because the scheduler tries to keep a thread on the same
-   CPU.
+	/* Emulate a ret instruction. */
+	regs->ip = caller;
+	regs->sp += 8;
 
-   tcache must point to a two element sized long array.
-   All arguments can be NULL. */
-long __vsyscall(2)
-vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
-{
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
-	}
-	if (tcache) {
-		tcache->blob[0] = j;
-		tcache->blob[1] = p;
-	}
-	if (cpu)
-		*cpu = p & 0xfff;
-	if (node)
-		*node = p >> 12;
-	return 0;
+	local_irq_disable();
+	return;
+
+sigsegv:
+	regs->ip -= 2;  /* The faulting instruction should be the int 0xcc. */
+	force_sig(SIGSEGV, current);
 }
 
-/* Assume __initcall executes before all user space. Hopefully kmod
-   doesn't violate that. We'll find out if it does. */
+/*
+ * Assume __initcall executes before all user space. Hopefully kmod
+ * doesn't violate that. We'll find out if it does.
+ */
 static void __cpuinit vsyscall_set_cpu(int cpu)
 {
 	unsigned long d;
@@ -221,13 +204,15 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
 	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
 		write_rdtscp_aux((node << 12) | cpu);
 
-	/* Store cpu number in limit so that it can be loaded quickly
-	   in user space in vgetcpu.
-	   12 bits for the CPU and 8 bits for the node. */
+	/*
+	 * Store cpu number in limit so that it can be loaded quickly
+	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
+	 */
 	d = 0x0f40000000000ULL;
 	d |= cpu;
 	d |= (node & 0xf) << 12;
 	d |= (node >> 4) << 48;
+
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
@@ -241,8 +226,10 @@ static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
+
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
+
 	return NOTIFY_DONE;
 }
 
@@ -256,21 +243,17 @@ void __init map_vsyscall(void)
 	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
 	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
-		     (unsigned long)VVAR_ADDRESS);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) != (unsigned long)VVAR_ADDRESS);
 }
 
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
+
 	return 0;
 }
-
 __initcall(vsyscall_init);
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
new file mode 100644
index 0000000..ffa845e
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -0,0 +1,27 @@
+/*
+ * vsyscall_emu_64.S: Vsyscall emulation page
+ *
+ * Copyright (c) 2011 Andy Lutomirski
+ *
+ * Subject to the GNU General Public License, version 2
+ */
+
+#include <linux/linkage.h>
+#include <asm/irq_vectors.h>
+
+/* The unused parts of the page are filled with 0xcc by the linker script. */
+
+.section .vsyscall_0, "a"
+ENTRY(vsyscall_0)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_0)
+
+.section .vsyscall_1, "a"
+ENTRY(vsyscall_1)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_1)
+
+.section .vsyscall_2, "a"
+ENTRY(vsyscall_2)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_2)
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..cc7a4e9 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -19,6 +19,11 @@ static inline void secure_computing(int this_syscall)
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
 
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return s->mode;
+}
+
 #else /* CONFIG_SECCOMP */
 
 #include <linux/errno.h>
@@ -37,6 +42,11 @@ static inline long prctl_set_seccomp(unsigned long arg2)
 	return -EINVAL;
 }
 
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SECCOMP */
 
 #endif /* _LINUX_SECCOMP_H */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab1EZSuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:50:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:43295 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab1EZSuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:50:32 -0400
Date: Thu, 26 May 2011 20:50:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86 vdso updates
Message-ID: <alpine.LFD.2.02.1105262049180.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vdso-for-linus

Thanks,

	tglx

------------------>
Andy Lutomirski (8):
      x86-64: Clean up vdso/kernel shared variables
      x86-64: Remove unnecessary barrier in vread_tsc
      x86-64: Don't generate cmov in vread_tsc
      x86-64: Vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
      x86-64: Move vread_tsc into a new file with sensible options
      x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
      x86-64: Add time to vDSO
      x86-64: Optimize vDSO time()

Thomas Gleixner (1):
      x86: vdso: Remove unused variable


 arch/x86/include/asm/tsc.h      |    4 ++
 arch/x86/include/asm/vdso.h     |   14 -------
 arch/x86/include/asm/vgtod.h    |    2 -
 arch/x86/include/asm/vsyscall.h |   12 +-----
 arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++
 arch/x86/kernel/Makefile        |    8 +++--
 arch/x86/kernel/time.c          |    2 +-
 arch/x86/kernel/tsc.c           |   19 ----------
 arch/x86/kernel/vmlinux.lds.S   |   34 ++++++------------
 arch/x86/kernel/vread_tsc_64.c  |   36 +++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c   |   46 ++++++++++--------------
 arch/x86/vdso/Makefile          |   17 ++++++++-
 arch/x86/vdso/vclock_gettime.c  |   74 ++++++++++++++++++++++++++++-----------
 arch/x86/vdso/vdso.lds.S        |    9 +----
 arch/x86/vdso/vextern.h         |   16 --------
 arch/x86/vdso/vgetcpu.c         |    3 +-
 arch/x86/vdso/vma.c             |   27 --------------
 arch/x86/vdso/vvar.c            |   12 ------
 18 files changed, 202 insertions(+), 185 deletions(-)
 create mode 100644 arch/x86/include/asm/vvar.h
 create mode 100644 arch/x86/kernel/vread_tsc_64.c
 delete mode 100644 arch/x86/vdso/vextern.h
 delete mode 100644 arch/x86/vdso/vvar.c

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 83e2efd..9db5583 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -51,6 +51,10 @@ extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
 
+#ifdef CONFIG_X86_64
+extern cycles_t vread_tsc(void);
+#endif
+
 /*
  * Boot-time check whether the TSCs are synchronized across
  * all CPUs/cores:
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 9064052..bb05228 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -1,20 +1,6 @@
 #ifndef _ASM_X86_VDSO_H
 #define _ASM_X86_VDSO_H
 
-#ifdef CONFIG_X86_64
-extern const char VDSO64_PRELINK[];
-
-/*
- * Given a pointer to the vDSO image, find the pointer to VDSO64_name
- * as that symbol is defined in the vDSO sources or linker script.
- */
-#define VDSO64_SYMBOL(base, name)					\
-({									\
-	extern const char VDSO64_##name[];				\
-	(void *)(VDSO64_##name - VDSO64_PRELINK + (unsigned long)(base)); \
-})
-#endif
-
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
 extern const char VDSO32_PRELINK[];
 
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 3d61e20..646b4c1 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -23,8 +23,6 @@ struct vsyscall_gtod_data {
 	struct timespec wall_to_monotonic;
 	struct timespec wall_time_coarse;
 };
-extern struct vsyscall_gtod_data __vsyscall_gtod_data
-__section_vsyscall_gtod_data;
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d0983d2..d555973 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -16,27 +16,19 @@ enum vsyscall_num {
 #ifdef __KERNEL__
 #include <linux/seqlock.h>
 
-#define __section_vgetcpu_mode __attribute__ ((unused, __section__ (".vgetcpu_mode"), aligned(16)))
-#define __section_jiffies __attribute__ ((unused, __section__ (".jiffies"), aligned(16)))
-
 /* Definitions for CONFIG_GENERIC_TIME definitions */
-#define __section_vsyscall_gtod_data __attribute__ \
-	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
-#define __section_vsyscall_clock __attribute__ \
-	((unused, __section__ (".vsyscall_clock"),aligned(16)))
 #define __vsyscall_fn \
 	__attribute__ ((unused, __section__(".vsyscall_fn"))) notrace
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
 
-extern int __vgetcpu_mode;
-extern volatile unsigned long __jiffies;
-
 /* kernel space (writeable) */
 extern int vgetcpu_mode;
 extern struct timezone sys_tz;
 
+#include <asm/vvar.h>
+
 extern void map_vsyscall(void);
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
new file mode 100644
index 0000000..341b355
--- /dev/null
+++ b/arch/x86/include/asm/vvar.h
@@ -0,0 +1,52 @@
+/*
+ * vvar.h: Shared vDSO/kernel variable declarations
+ * Copyright (c) 2011 Andy Lutomirski
+ * Subject to the GNU General Public License, version 2
+ *
+ * A handful of variables are accessible (read-only) from userspace
+ * code in the vsyscall page and the vdso.  They are declared here.
+ * Some other file must define them with DEFINE_VVAR.
+ *
+ * In normal kernel code, they are used like any other variable.
+ * In user code, they are accessed through the VVAR macro.
+ *
+ * Each of these variables lives in the vsyscall page, and each
+ * one needs a unique offset within the little piece of the page
+ * reserved for vvars.  Specify that offset in DECLARE_VVAR.
+ * (There are 896 bytes available.  If you mess up, the linker will
+ * catch it.)
+ */
+
+/* Offset of vars within vsyscall page */
+#define VSYSCALL_VARS_OFFSET (3072 + 128)
+
+#if defined(__VVAR_KERNEL_LDS)
+
+/* The kernel linker script defines its own magic to put vvars in the
+ * right place.
+ */
+#define DECLARE_VVAR(offset, type, name) \
+	EMIT_VVAR(name, VSYSCALL_VARS_OFFSET + offset)
+
+#else
+
+#define DECLARE_VVAR(offset, type, name)				\
+	static type const * const vvaraddr_ ## name =			\
+		(void *)(VSYSCALL_START + VSYSCALL_VARS_OFFSET + (offset));
+
+#define DEFINE_VVAR(type, name)						\
+	type __vvar_ ## name						\
+	__attribute__((section(".vsyscall_var_" #name), aligned(16)))
+
+#define VVAR(name) (*vvaraddr_ ## name)
+
+#endif
+
+/* DECLARE_VVAR(offset, type, name) */
+
+DECLARE_VVAR(0, volatile unsigned long, jiffies)
+DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+
+#undef DECLARE_VVAR
+#undef VSYSCALL_VARS_OFFSET
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2508064..f5abe3a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -8,7 +8,6 @@ CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
-CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_pvclock.o = -pg
@@ -24,13 +23,16 @@ endif
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
-CFLAGS_tsc.o		:= $(nostackp)
+CFLAGS_vread_tsc_64.o	:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
 GCOV_PROFILE_tsc.o		:= n
 GCOV_PROFILE_paravirt.o		:= n
 
+# vread_tsc_64 is hot and should be fully optimized:
+CFLAGS_REMOVE_vread_tsc_64.o = -pg -fno-optimize-sibling-calls
+
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
@@ -39,7 +41,7 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 25a28a2..00cbb27 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -23,7 +23,7 @@
 #include <asm/time.h>
 
 #ifdef CONFIG_X86_64
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
+DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
 #endif
 
 unsigned long profile_pc(struct pt_regs *regs)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9335bf7..6cc6922 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -763,25 +763,6 @@ static cycle_t read_tsc(struct clocksource *cs)
 		ret : clocksource_tsc.cycle_last;
 }
 
-#ifdef CONFIG_X86_64
-static cycle_t __vsyscall_fn vread_tsc(void)
-{
-	cycle_t ret;
-
-	/*
-	 * Surround the RDTSC by barriers, to make sure it's not
-	 * speculated to outside the seqlock critical section and
-	 * does not cause time warps:
-	 */
-	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
-	rdtsc_barrier();
-
-	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
-		ret : __vsyscall_gtod_data.clock.cycle_last;
-}
-#endif
-
 static void resume_tsc(struct clocksource *cs)
 {
 	clocksource_tsc.cycle_last = 0;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 49927a8..74b5ad4 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -161,6 +161,12 @@ SECTIONS
 
 #define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
+#define EMIT_VVAR(x, offset) .vsyscall_var_ ## x	\
+	ADDR(.vsyscall_0) + offset		 	\
+	: AT(VLOAD(.vsyscall_var_ ## x)) {     		\
+		*(.vsyscall_var_ ## x)			\
+	}						\
+	x = VVIRT(.vsyscall_var_ ## x);
 
 	. = ALIGN(4096);
 	__vsyscall_0 = .;
@@ -175,18 +181,6 @@ SECTIONS
 		*(.vsyscall_fn)
 	}
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
-		*(.vsyscall_gtod_data)
-	}
-
-	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
-	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
-		*(.vsyscall_clock)
-	}
-	vsyscall_clock = VVIRT(.vsyscall_clock);
-
-
 	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
 		*(.vsyscall_1)
 	}
@@ -194,21 +188,14 @@ SECTIONS
 		*(.vsyscall_2)
 	}
 
-	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
-		*(.vgetcpu_mode)
-	}
-	vgetcpu_mode = VVIRT(.vgetcpu_mode);
-
-	. = ALIGN(L1_CACHE_BYTES);
-	.jiffies : AT(VLOAD(.jiffies)) {
-		*(.jiffies)
-	}
-	jiffies = VVIRT(.jiffies);
-
 	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
 		*(.vsyscall_3)
 	}
 
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+
 	. = __vsyscall_0 + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
@@ -216,6 +203,7 @@ SECTIONS
 #undef VLOAD
 #undef VVIRT_OFFSET
 #undef VVIRT
+#undef EMIT_VVAR
 
 #endif /* CONFIG_X86_64 */
 
diff --git a/arch/x86/kernel/vread_tsc_64.c b/arch/x86/kernel/vread_tsc_64.c
new file mode 100644
index 0000000..a81aa9e
--- /dev/null
+++ b/arch/x86/kernel/vread_tsc_64.c
@@ -0,0 +1,36 @@
+/* This code runs in userspace. */
+
+#define DISABLE_BRANCH_PROFILING
+#include <asm/vgtod.h>
+
+notrace cycle_t __vsyscall_fn vread_tsc(void)
+{
+	cycle_t ret;
+	u64 last;
+
+	/*
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)vget_cycles();
+
+	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
+}
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dcbb28c..5f6ad03 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -49,15 +49,8 @@
 		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
 #define __syscall_clobber "r11","cx","memory"
 
-/*
- * vsyscall_gtod_data contains data that is :
- * - readonly from vsyscalls
- * - written by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
- * Try to keep this structure as small as possible to avoid cache line ping pongs
- */
-int __vgetcpu_mode __section_vgetcpu_mode;
-
-struct vsyscall_gtod_data __vsyscall_gtod_data __section_vsyscall_gtod_data =
+DEFINE_VVAR(int, vgetcpu_mode);
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
 	.lock = SEQLOCK_UNLOCKED,
 	.sysctl_enabled = 1,
@@ -97,7 +90,7 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
  */
 static __always_inline void do_get_tz(struct timezone * tz)
 {
-	*tz = __vsyscall_gtod_data.sys_tz;
+	*tz = VVAR(vsyscall_gtod_data).sys_tz;
 }
 
 static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
@@ -126,23 +119,24 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 	unsigned long mult, shift, nsec;
 	cycle_t (*vread)(void);
 	do {
-		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
 
-		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
+		vread = VVAR(vsyscall_gtod_data).clock.vread;
+		if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled ||
+			     !vread)) {
 			gettimeofday(tv,NULL);
 			return;
 		}
 
 		now = vread();
-		base = __vsyscall_gtod_data.clock.cycle_last;
-		mask = __vsyscall_gtod_data.clock.mask;
-		mult = __vsyscall_gtod_data.clock.mult;
-		shift = __vsyscall_gtod_data.clock.shift;
+		base = VVAR(vsyscall_gtod_data).clock.cycle_last;
+		mask = VVAR(vsyscall_gtod_data).clock.mask;
+		mult = VVAR(vsyscall_gtod_data).clock.mult;
+		shift = VVAR(vsyscall_gtod_data).clock.shift;
 
-		tv->tv_sec = __vsyscall_gtod_data.wall_time_sec;
-		nsec = __vsyscall_gtod_data.wall_time_nsec;
-	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
+		tv->tv_sec = VVAR(vsyscall_gtod_data).wall_time_sec;
+		nsec = VVAR(vsyscall_gtod_data).wall_time_nsec;
+	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
 
 	/* calculate interval: */
 	cycle_delta = (now - base) & mask;
@@ -171,15 +165,15 @@ time_t __vsyscall(1) vtime(time_t *t)
 {
 	unsigned seq;
 	time_t result;
-	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
+	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
 		return time_syscall(t);
 
 	do {
-		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
 
-		result = __vsyscall_gtod_data.wall_time_sec;
+		result = VVAR(vsyscall_gtod_data).wall_time_sec;
 
-	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
+	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
 
 	if (t)
 		*t = result;
@@ -208,9 +202,9 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	   We do this here because otherwise user space would do it on
 	   its own in a likely inferior way (no access to jiffies).
 	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = __jiffies)) {
+	if (tcache && tcache->blob[0] == (j = VVAR(jiffies))) {
 		p = tcache->blob[1];
-	} else if (__vgetcpu_mode == VGETCPU_RDTSCP) {
+	} else if (VVAR(vgetcpu_mode) == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
 		native_read_tscp(&p);
 	} else {
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index b6552b1..bef0bc9 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -11,7 +11,7 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
 # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
@@ -37,11 +37,24 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
+#
+# Don't omit frame pointers for ease of userspace debugging, but do
+# optimize sibling calls.
+#
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
-       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector)
+       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
+       -fno-omit-frame-pointer -foptimize-sibling-calls
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
+#
+# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
+#
+CFLAGS_REMOVE_vdso-note.o = -pg
+CFLAGS_REMOVE_vclock_gettime.o = -pg
+CFLAGS_REMOVE_vgetcpu.o = -pg
+CFLAGS_REMOVE_vvar.o = -pg
+
 targets += vdso-syms.lds
 obj-$(VDSO64-y)			+= vdso-syms.lds
 
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index ee55754..a724905 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -2,7 +2,7 @@
  * Copyright 2006 Andi Kleen, SUSE Labs.
  * Subject to the GNU Public License, v.2
  *
- * Fast user context implementation of clock_gettime and gettimeofday.
+ * Fast user context implementation of clock_gettime, gettimeofday, and time.
  *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
@@ -22,9 +22,8 @@
 #include <asm/hpet.h>
 #include <asm/unistd.h>
 #include <asm/io.h>
-#include "vextern.h"
 
-#define gtod vdso_vsyscall_gtod_data
+#define gtod (&VVAR(vsyscall_gtod_data))
 
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
@@ -56,22 +55,6 @@ notrace static noinline int do_realtime(struct timespec *ts)
 	return 0;
 }
 
-/* Copy of the version in kernel/time.c which we cannot directly access */
-notrace static void
-vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
-{
-	while (nsec >= NSEC_PER_SEC) {
-		nsec -= NSEC_PER_SEC;
-		++sec;
-	}
-	while (nsec < 0) {
-		nsec += NSEC_PER_SEC;
-		--sec;
-	}
-	ts->tv_sec = sec;
-	ts->tv_nsec = nsec;
-}
-
 notrace static noinline int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
@@ -82,7 +65,17 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-	vset_normalized_timespec(ts, secs, ns);
+
+	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
+	 * are all guaranteed to be nonnegative.
+	 */
+	while (ns >= NSEC_PER_SEC) {
+		ns -= NSEC_PER_SEC;
+		++secs;
+	}
+	ts->tv_sec = secs;
+	ts->tv_nsec = ns;
+
 	return 0;
 }
 
@@ -107,7 +100,17 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-	vset_normalized_timespec(ts, secs, ns);
+
+	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
+	 * guaranteed to be between 0 and NSEC_PER_SEC.
+	 */
+	if (ns >= NSEC_PER_SEC) {
+		ns -= NSEC_PER_SEC;
+		++secs;
+	}
+	ts->tv_sec = secs;
+	ts->tv_nsec = ns;
+
 	return 0;
 }
 
@@ -157,3 +160,32 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 }
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
+
+/* This will break when the xtime seconds get inaccurate, but that is
+ * unlikely */
+
+static __always_inline long time_syscall(long *t)
+{
+	long secs;
+	asm volatile("syscall"
+		     : "=a" (secs)
+		     : "0" (__NR_time), "D" (t) : "cc", "r11", "cx", "memory");
+	return secs;
+}
+
+notrace time_t __vdso_time(time_t *t)
+{
+	time_t result;
+
+	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
+		return time_syscall(t);
+
+	/* This is atomic on x86_64 so we don't need any locks. */
+	result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
+
+	if (t)
+		*t = result;
+	return result;
+}
+int time(time_t *t)
+	__attribute__((weak, alias("__vdso_time")));
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 4e5dd3b..b96b267 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -23,15 +23,10 @@ VERSION {
 		__vdso_gettimeofday;
 		getcpu;
 		__vdso_getcpu;
+		time;
+		__vdso_time;
 	local: *;
 	};
 }
 
 VDSO64_PRELINK = VDSO_PRELINK;
-
-/*
- * Define VDSO64_x for each VEXTERN(x), for use via VDSO64_SYMBOL.
- */
-#define VEXTERN(x)	VDSO64_ ## x = vdso_ ## x;
-#include "vextern.h"
-#undef	VEXTERN
diff --git a/arch/x86/vdso/vextern.h b/arch/x86/vdso/vextern.h
deleted file mode 100644
index 1683ba2..0000000
--- a/arch/x86/vdso/vextern.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef VEXTERN
-#include <asm/vsyscall.h>
-#define VEXTERN(x) \
-	extern typeof(x) *vdso_ ## x __attribute__((visibility("hidden")));
-#endif
-
-#define VMAGIC 0xfeedbabeabcdefabUL
-
-/* Any kernel variables used in the vDSO must be exported in the main
-   kernel's vmlinux.lds.S/vsyscall.h/proper __section and
-   put into vextern.h and be referenced as a pointer with vdso prefix.
-   The main kernel later fills in the values.   */
-
-VEXTERN(jiffies)
-VEXTERN(vgetcpu_mode)
-VEXTERN(vsyscall_gtod_data)
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 9fbc6b2..5463ad5 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -11,14 +11,13 @@
 #include <linux/time.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
-#include "vextern.h"
 
 notrace long
 __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
 {
 	unsigned int p;
 
-	if (*vdso_vgetcpu_mode == VGETCPU_RDTSCP) {
+	if (VVAR(vgetcpu_mode) == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
 		native_read_tscp(&p);
 	} else {
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 4b5d26f..7abd2be 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -15,9 +15,6 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 
-#include "vextern.h"		/* Just for VMAGIC.  */
-#undef VEXTERN
-
 unsigned int __read_mostly vdso_enabled = 1;
 
 extern char vdso_start[], vdso_end[];
@@ -26,20 +23,10 @@ extern unsigned short vdso_sync_cpuid;
 static struct page **vdso_pages;
 static unsigned vdso_size;
 
-static inline void *var_ref(void *p, char *name)
-{
-	if (*(void **)p != (void *)VMAGIC) {
-		printk("VDSO: variable %s broken\n", name);
-		vdso_enabled = 0;
-	}
-	return p;
-}
-
 static int __init init_vdso_vars(void)
 {
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
-	char *vbase;
 
 	vdso_size = npages << PAGE_SHIFT;
 	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
@@ -54,20 +41,6 @@ static int __init init_vdso_vars(void)
 		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
 	}
 
-	vbase = vmap(vdso_pages, npages, 0, PAGE_KERNEL);
-	if (!vbase)
-		goto oom;
-
-	if (memcmp(vbase, "\177ELF", 4)) {
-		printk("VDSO: I'm broken; not ELF\n");
-		vdso_enabled = 0;
-	}
-
-#define VEXTERN(x) \
-	*(typeof(__ ## x) **) var_ref(VDSO64_SYMBOL(vbase, x), #x) = &__ ## x;
-#include "vextern.h"
-#undef VEXTERN
-	vunmap(vbase);
 	return 0;
 
  oom:
diff --git a/arch/x86/vdso/vvar.c b/arch/x86/vdso/vvar.c
deleted file mode 100644
index 1b7e703..0000000
--- a/arch/x86/vdso/vvar.c
+++ /dev/null
@@ -1,12 +0,0 @@
-/* Define pointer to external vDSO variables.
-   These are part of the vDSO. The kernel fills in the real addresses
-   at boot time. This is done because when the vdso is linked the
-   kernel isn't yet and we don't know the final addresses. */
-#include <linux/kernel.h>
-#include <linux/time.h>
-#include <asm/vsyscall.h>
-#include <asm/timex.h>
-#include <asm/vgtod.h>
-
-#define VEXTERN(x) typeof (__ ## x) *const vdso_ ## x = (void *)VMAGIC;
-#include "vextern.h"

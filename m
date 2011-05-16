Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1EPQB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:01:56 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:55465 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab1EPQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:01:53 -0400
X-AuditID: 12074422-b7b0eae000007f48-be-4dd14a799237
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 1/6] x86-64: Clean up vdso/kernel shared variables
Date: Mon, 16 May 2011 12:00:58 -0400
Message-Id: <5062fb3d104744b00b45afec76bf78e504785370.1305560561.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsUixCmqrFvpddHXoP2QocXFtotsFn1XjrJb
	HLn2nd3iYuM2Fos551tYLPa9P8tmcXnXHDaLLZeaWS02b5rKbPGo7y27xY8Nj1kduD26H31i
	9LjylMNjy8qbTB632v4we8zf+ZHRY+esu+wem1Z1snm8O3eO3ePEjN8sHp83yQVwRXHZpKTm
	ZJalFunbJXBlvL35lqngRhtjxZ3N85gaGJ/mdTFyckgImEj0PrzICmGLSVy4t56ti5GLQ0hg
	H6PEn6ctbCAJIYENjBKNf0ohEs+YJObfW8QMkmATUJHoWPqAqYuRg0NEQEhi6d06kBpmgbXM
	Evu6FzOB1AgLuEpcutPMDmKzCKhKHPy6BczmFQiSuP5kByPEZgWJK1fmsYDYnAIGEtsPb2GG
	WKwv0bXmPyMu8QmMAgsYGVYxyqbkVunmJmbmFKcm6xYnJ+blpRbpmurlZpbopaaUbmIERQK7
	i9IOxp8HlQ4xCnAwKvHw/nG66CvEmlhWXJl7iFGSg0lJlNfAFSjEl5SfUpmRWJwRX1Sak1p8
	iFGCg1lJhPdM/QVfId6UxMqq1KJ8mJQ0B4uSOO8cSXVfIYH0xJLU7NTUgtQimKwMB4eSBO9q
	T6ChgkWp6akVaZk5JQhpJg5OkOE8QMMvgNTwFhck5hZnpkPkTzHqcnx+dOgAoxBLXn5eqpQ4
	7w6QIgGQoozSPLg5sAT2ilEc6C1h3mMgVTzA5Ac36RXQEiagJatOgXxQXJKIkJJqYFzAy9kk
	rhUu6lvrGGz46qxfxLO87jep5Ye/3Vg6cW2wtXL/HrW1zFNq3TPCD68Uqw7b/2+F2514ZlaG
	Cu+PAr1bPq18q6yeqOdzf81S18bNv41u1M5MMMxYZD7f3TBk3vaahpD0xeXNn68w9Dhqt3t5
	eT6MYsk5bNt+5PFUjrfCaxzeK1x7qMRSnJFoqMVcVJwIAHp1Mxw7AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variables that are shared between the vdso and the kernel are
currently a bit of a mess.  They are each defined with their own
magic, they are accessed differently in the kernel, the vsyscall page,
and the vdso, and one of them (vsyscall_clock) doesn't even really
exist.

This changes them all to use a common mechanism.  All of them are
delcared in vvar.h with a fixed address (validated by the linker
script).  In the kernel (as before), they look like ordinary
read-write variables.  In the vsyscall page and the vdso, they are
accessed through a new macro VVAR, which gives read-only access.

The vdso is now loaded verbatim into memory without any fixups.  As a
side bonus, access from the vdso is faster because a level of
indirection is removed.

While we're at it, pack jiffies and vgetcpu_mode into the same
cacheline.
---
 arch/x86/include/asm/vdso.h     |   14 ----------
 arch/x86/include/asm/vgtod.h    |    2 -
 arch/x86/include/asm/vsyscall.h |   12 +-------
 arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/time.c          |    2 +-
 arch/x86/kernel/tsc.c           |    4 +-
 arch/x86/kernel/vmlinux.lds.S   |   34 ++++++++-----------------
 arch/x86/kernel/vsyscall_64.c   |   46 +++++++++++++++-------------------
 arch/x86/vdso/Makefile          |    2 +-
 arch/x86/vdso/vclock_gettime.c  |    3 +-
 arch/x86/vdso/vdso.lds.S        |    7 -----
 arch/x86/vdso/vextern.h         |   16 ------------
 arch/x86/vdso/vgetcpu.c         |    3 +-
 arch/x86/vdso/vma.c             |   27 --------------------
 arch/x86/vdso/vvar.c            |   12 ---------
 15 files changed, 91 insertions(+), 145 deletions(-)
 create mode 100644 arch/x86/include/asm/vvar.h
 delete mode 100644 arch/x86/vdso/vextern.h
 delete mode 100644 arch/x86/vdso/vvar.c

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
index ffe5755..bc46566 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -777,8 +777,8 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	ret = (cycle_t)vget_cycles();
 	rdtsc_barrier();
 
-	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
-		ret : __vsyscall_gtod_data.clock.cycle_last;
+	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
+		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
 }
 #endif
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..bbe6cc2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -160,6 +160,12 @@ SECTIONS
 
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
@@ -174,18 +180,6 @@ SECTIONS
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
@@ -193,21 +187,14 @@ SECTIONS
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
@@ -215,6 +202,7 @@ SECTIONS
 #undef VLOAD
 #undef VVIRT_OFFSET
 #undef VVIRT
+#undef EMIT_VVAR
 
 #endif /* CONFIG_X86_64 */
 
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
index b6552b1..a651861 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -11,7 +11,7 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
 # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index ee55754..0b873d4 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -22,9 +22,8 @@
 #include <asm/hpet.h>
 #include <asm/unistd.h>
 #include <asm/io.h>
-#include "vextern.h"
 
-#define gtod vdso_vsyscall_gtod_data
+#define gtod (&VVAR(vsyscall_gtod_data))
 
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 4e5dd3b..81f2500 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -28,10 +28,3 @@ VERSION {
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
-- 
1.7.5.1


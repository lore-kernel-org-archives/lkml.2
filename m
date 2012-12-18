Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2LRJm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:42:27 -0500
Received: from www84.your-server.de ([213.133.104.84]:50131 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab2LRJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:20 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
Date: Tue, 18 Dec 2012 10:40:56 +0100
Message-Id: <1355823656-13902-7-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355823656-13902-1-git-send-email-stefani@seibold.net>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch adds support for 32 bit VDSO.

For 32 bit programs running on a 32 bit kernel, the same mechanism is
used as for 64 bit programs running on a 64 bit kernel.

For 32 bit programs running under a 64 bit IA32_EMULATION, it is a
little bit more tricky. In this case the VVAR and HPET will be mapped
into the 32 bit address space, by cutting of the upper 32 bit. So the
address for this will not changed in the view of the 32 bit VDSO. The
HPET will be mapped in this case at 0xff5fe000 and the VVAR at 0xff5ff000.

The transformation between the in 64 bit kernel representation and the 32 bit
abi will be also provided.

So we have one VDSO Source for all.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/vgtod.h          |   4 +-
 arch/x86/include/asm/vsyscall.h       |   1 -
 arch/x86/include/asm/vvar.h           |   1 +
 arch/x86/kernel/Makefile              |   1 +
 arch/x86/kernel/hpet.c                |   9 ++-
 arch/x86/vdso/Makefile                |   6 ++
 arch/x86/vdso/vclock_gettime.c        | 108 ++++++++++++++++++++++++++--------
 arch/x86/vdso/vdso32-setup.c          |  43 ++++++++++++++
 arch/x86/vdso/vdso32/vclock_gettime.c |  29 +++++++++
 arch/x86/vdso/vdso32/vdso32.lds.S     |   3 +
 11 files changed, 179 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/vdso/vdso32/vclock_gettime.c

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 86afff8..74c80d4 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_X86_VGTOD_H
 #define _ASM_X86_VGTOD_H
 
-#include <asm/vsyscall.h>
-#include <linux/clocksource.h>
+#include <linux/seqcount.h>
+#include <uapi/linux/time.h>
 
 struct vsyscall_gtod_data {
 	seqcount_t	seq;
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index eaea1d3..24730cb 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -14,7 +14,6 @@ enum vsyscall_num {
 #define VSYSCALL_ADDR(vsyscall_nr) (VSYSCALL_START+VSYSCALL_SIZE*(vsyscall_nr))
 
 #ifdef __KERNEL__
-#include <linux/seqlock.h>
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 8084d55..1e71e6c 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -50,5 +50,6 @@
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
 DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+DECLARE_VVAR(512, const void __iomem *, vsyscall_hpet)
 
 #undef DECLARE_VVAR
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 91ce48f..298a0b1 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -26,6 +26,7 @@ obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o
+obj-y			+= vsyscall_gtod.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 859bb2d..4b7bb5d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -69,14 +69,19 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 
 #ifdef CONFIG_X86_64
 #include <asm/pgtable.h>
+#else
+#include <asm/vvar.h>
 #endif
 
+DEFINE_VVAR(const void __iomem *, vsyscall_hpet);
+
+#include <linux/mm.h>
+
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_64
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
-#endif
+	vsyscall_hpet = (const void __iomem *)fix_to_virt(VSYSCALL_HPET);
 }
 
 static inline void hpet_clear_mapping(void)
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..e136314 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -145,8 +145,14 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
 $(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
 
+KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=3 -freg-struct-return
+$(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
+				 $(obj)/vdso32/vclock_gettime.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 4df6c37..e856bd8 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -4,6 +4,8 @@
  *
  * Fast user context implementation of clock_gettime, gettimeofday, and time.
  *
+ * 32 Bit compat layer by Stefani Seibold <stefani@seibold.net>
+ *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
  */
@@ -11,20 +13,35 @@
 /* Disable profiling for userspace code: */
 #define DISABLE_BRANCH_PROFILING
 
-#include <linux/kernel.h>
-#include <linux/posix-timers.h>
 #include <linux/time.h>
-#include <linux/string.h>
-#include <asm/vsyscall.h>
 #include <asm/fixmap.h>
 #include <asm/vgtod.h>
 #include <asm/timex.h>
-#include <asm/hpet.h>
 #include <asm/unistd.h>
-#include <asm/io.h>
+#include <asm/clocksource.h>
+#ifdef CONFIG_X86_32
+#include <asm/vvar.h>
+#endif
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
+struct abi_timeval {
+	long	tv_sec;		/* seconds */
+	long	tv_usec;	/* microseconds */
+};
+
+struct abi_timespec {
+	long	tv_sec;		/* seconds */
+	long	tv_nsec;	/* microseconds */
+};
+
+typedef long abi_time_t;
+
+static inline u32 readl(const volatile void __iomem *addr)
+{
+	return *(const volatile u32 *) addr;
+}
+
 notrace static cycle_t vread_tsc(void)
 {
 	cycle_t ret;
@@ -47,7 +64,7 @@ notrace static cycle_t vread_tsc(void)
 
 	/*
 	 * GCC likes to generate cmov here, but this branch is extremely
-	 * predictable (it's just a funciton of time and the likely is
+	 * predictable (it's just a function of time and the likely is
 	 * very likely) and there's a data dependence, so force GCC
 	 * to generate a branch instead.  I don't barrier() because
 	 * we don't actually need a barrier, and if this function
@@ -57,6 +74,7 @@ notrace static cycle_t vread_tsc(void)
 	return last;
 }
 
+#ifndef BUILD_VDSO32
 static notrace cycle_t vread_hpet(void)
 {
 	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
@@ -70,7 +88,8 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	return ret;
 }
 
-notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+notrace static long vdso_fallback_gtod(struct abi_timeval *tv,
+		struct timezone *tz)
 {
 	long ret;
 
@@ -78,11 +97,34 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
 	return ret;
 }
+#else
+static notrace cycle_t vread_hpet(void)
+{
+	return readl(VVAR(vsyscall_hpet) + 0xf0);
+}
+
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+	asm("call VDSO32_vsyscall" : "=a" (ret) :
+	    "a" (__NR_ia32_clock_gettime), "b" (clock), "c" (ts) : "memory");
+	return ret;
+}
+
+notrace static long vdso_fallback_gtod(struct abi_timeval *tv,
+		struct timezone *tz)
+{
+	long ret;
 
+	asm("call VDSO32_vsyscall" : "=a" (ret) :
+	    "a" (__NR_ia32_gettimeofday), "b" (tv), "c" (tz) : "memory");
+	return ret;
+}
+#endif
 
 notrace static inline u64 vgetsns(void)
 {
-	long v;
+	u64 v;
 	cycles_t cycles;
 	if (gtod->clock.vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
@@ -158,7 +200,8 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 	return 0;
 }
 
-notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+notrace static inline int do_vdso_clock_gettime(clockid_t clock,
+		struct timespec *ts)
 {
 	int ret = VCLOCK_NONE;
 
@@ -179,45 +222,60 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 		return vdso_fallback_gettime(clock, ts);
 	return 0;
 }
-int clock_gettime(clockid_t, struct timespec *)
+
+notrace int __vdso_clock_gettime(clockid_t clock, struct abi_timespec *ts)
+{
+	struct timespec tmp;
+	int ret;
+
+	ret = do_vdso_clock_gettime(clock, &tmp);
+	if (!ret) {
+		ts->tv_sec = tmp.tv_sec;
+		ts->tv_nsec = tmp.tv_nsec;
+	}
+	return ret;
+}
+int clock_gettime(clockid_t, struct abi_timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+notrace inline int __vdso_gettimeofday(struct abi_timeval *tv,
+		struct timezone *tz)
 {
 	long ret = VCLOCK_NONE;
+	struct timeval tmp;
+
+	ret = do_realtime((struct timespec *)&tmp);
+
+	if (unlikely(ret == VCLOCK_NONE))
+		return vdso_fallback_gtod(tv, tz);
 
-	if (likely(tv != NULL)) {
-		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-			     offsetof(struct timespec, tv_nsec) ||
-			     sizeof(*tv) != sizeof(struct timespec));
-		ret = do_realtime((struct timespec *)tv);
-		tv->tv_usec /= 1000;
-	}
 	if (unlikely(tz != NULL)) {
 		/* Avoid memcpy. Some old compilers fail to inline it */
 		tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
 		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
 	}
 
-	if (ret == VCLOCK_NONE)
-		return vdso_fallback_gtod(tv, tz);
+	tv->tv_sec = tmp.tv_sec;
+	tv->tv_usec = tmp.tv_usec;
+	tv->tv_usec /= 1000;
+
 	return 0;
 }
-int gettimeofday(struct timeval *, struct timezone *)
+int gettimeofday(struct abi_timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
 
 /*
  * This will break when the xtime seconds get inaccurate, but that is
  * unlikely
  */
-notrace time_t __vdso_time(time_t *t)
+notrace long __vdso_time(long *t)
 {
 	/* This is atomic on x86_64 so we don't need any locks. */
-	time_t result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
+	long result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
 
 	if (t)
 		*t = result;
 	return result;
 }
-int time(time_t *t)
+long time(long *t)
 	__attribute__((weak, alias("__vdso_time")));
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0faad64..15fc014 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -194,6 +195,9 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 }
 
 static struct page *vdso32_pages[1];
+#ifdef CONFIG_IA32_EMULATION
+static struct page *vvar_pages[1];
+#endif
 
 #ifdef CONFIG_X86_64
 
@@ -279,7 +283,11 @@ int __init sysenter_setup(void)
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	const void *vsyscall;
 	size_t vsyscall_len;
+#ifdef CONFIG_IA32_EMULATION
+	extern char __vvar_page;
 
+	vvar_pages[0] = virt_to_page(&__vvar_page);
+#endif
 	vdso32_pages[0] = virt_to_page(syscall_page);
 
 #ifdef CONFIG_X86_32
@@ -310,6 +318,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	bool compat;
+#ifdef CONFIG_IA32_EMULATION
+	extern unsigned long hpet_address;
+#endif
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -352,6 +363,38 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			goto up_fail;
 	}
 
+#ifdef CONFIG_IA32_EMULATION
+	ret = install_special_mapping(mm, VVAR_ADDRESS & 0xffffffff, PAGE_SIZE,
+			VM_READ|VM_EXEC, vvar_pages);
+
+	if (ret)
+		goto up_fail;
+
+	if (hpet_address) {
+		struct vm_area_struct *vma;
+			
+		vma = _install_special_mapping(mm,
+				__fix_to_virt(VSYSCALL_HPET) & 0xffffffff,
+				PAGE_SIZE, VM_READ|VM_EXEC|VM_IO|VM_LOCKED,
+				NULL);
+
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto up_fail;
+		}
+
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+		ret = io_remap_pfn_range(vma,
+				vma->vm_start,
+				hpet_address >> PAGE_SHIFT,
+				PAGE_SIZE,
+				vma->vm_page_prot);
+		if (ret)
+			goto up_fail;
+	}
+#endif
+
 	current_thread_info()->sysenter_return =
 		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
 
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
new file mode 100644
index 0000000..895c772
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -0,0 +1,29 @@
+/*
+ * Copyright 2012 Stefani Seibold <stefani@seibold.net>
+ * Subject to the GNU Public License, v.2
+ *
+ * 32 Bit compat layer for fast user context implementation of clock_gettime,
+ * gettimeofday, and time.
+ */
+
+#ifdef CONFIG_X86_64
+
+#include <asm/unistd_32_ia32.h>
+
+typedef long long __kernel_long_t;
+typedef unsigned long long __kernel_ulong_t;
+#define __kernel_long_t __kernel_long_t
+
+#define _STRUCT_TIMESPEC
+struct timespec {
+	long long tv_sec;
+	long long tv_nsec;
+};
+#else
+
+#define __NR_ia32_gettimeofday	__NR_gettimeofday
+#define __NR_ia32_clock_gettime	__NR_clock_gettime
+#endif
+
+#define BUILD_VDSO32
+#include "../vclock_gettime.c"
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 976124b..cd96168 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -24,6 +24,9 @@ VERSION
 		__kernel_vsyscall;
 		__kernel_sigreturn;
 		__kernel_rt_sigreturn;
+		__vdso_clock_gettime;
+		__vdso_gettimeofday;
+		__vdso_time;
 	local: *;
 	};
 }
-- 
1.8.0


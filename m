Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2LLUUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:20:48 -0500
Received: from www84.your-server.de ([213.133.104.84]:54417 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2LLUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:20:46 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net
Cc: stefani@seibold.net
Subject: [PATCH] Add VDSO time function support for x86 32-bit kernel
Date: Wed, 12 Dec 2012 21:19:32 +0100
Message-Id: <1355343572-23074-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This small patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
and vdso_time() support to the VDSO for x86 32-bit kernels.

The reason to do this was to get a fast reliable time stamp. Many developers
uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
time functions a fast and reliable way, because the kernel knows the
best time source and the P- and C-state of the CPU.

The helper library to use the VDSO functions can be download at
http://http://seibold.net/vdso.c
The libary is very small, only 228 lines of code. Compile it with
gcc -Wall -O3 -fpic vdso.c -lrt -shared -o libvdso.so
and use it with LD_PRELOAD=<path>/libvdso.so

This kind of helper must be integrated into glibc, for x86 64-bit and
PowerPC it is already there.

Some benchmark results (all measurements are in nano seconds):

Intel(R) Celeron(TM) CPU 400MHz

Average time kernel call:
 gettimeofday(): 1039
 clock_gettime(): 1578
 time(): 526
Average time VDSO call:
 gettimeofday(): 378
 clock_gettime(): 303
 time(): 60

Celeron(R) Dual-Core CPU T3100 1.90GHz

 Average time kernel call:
  gettimeofday(): 209
  clock_gettime(): 406
  time(): 135
 Average time VDSO call:
  gettimeofday(): 51
  clock_gettime(): 43
  time(): 10

So you can see a performance increase between 4 and 13, depending on the
CPU and the function.

The patch is against kernel 3.7. Please apply if you like it.

Changelog:
25.11.2012 - first release and proof of concept for linux 3.4
11.12.2012 - Port to linux 3.7 and code cleanup
12.12.2012 - fixes suggested by Andy Lutomirski
           - fixes suggested by John Stultz
           - use call VDSO32_vsyscall instead of int 80
           - code cleanup

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/Kconfig                      |  4 +-
 arch/x86/include/asm/clocksource.h    |  4 --
 arch/x86/include/asm/fixmap.h         |  3 +-
 arch/x86/include/asm/vgtod.h          |  1 +
 arch/x86/include/asm/vvar.h           |  7 +++
 arch/x86/kernel/Makefile              |  1 +
 arch/x86/kernel/hpet.c                |  9 ++--
 arch/x86/kernel/setup.c               |  2 +
 arch/x86/kernel/tsc.c                 |  2 -
 arch/x86/kernel/vmlinux.lds.S         |  4 --
 arch/x86/kernel/vsyscall_64.c         | 49 ------------------
 arch/x86/kernel/vsyscall_gtod.c       | 93 +++++++++++++++++++++++++++++++++++
 arch/x86/vdso/Makefile                |  1 +
 arch/x86/vdso/vclock_gettime.c        | 25 +++++++++-
 arch/x86/vdso/vdso32/vclock_gettime.c |  7 +++
 arch/x86/vdso/vdso32/vdso32.lds.S     |  5 ++
 16 files changed, 151 insertions(+), 66 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_gtod.c
 create mode 100644 arch/x86/vdso/vdso32/vclock_gettime.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..b8c2c74 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -100,9 +100,9 @@ config X86
 	select GENERIC_CMOS_UPDATE
 	select CLOCKSOURCE_WATCHDOG
 	select GENERIC_CLOCKEVENTS
-	select ARCH_CLOCKSOURCE_DATA if X86_64
+	select ARCH_CLOCKSOURCE_DATA
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
-	select GENERIC_TIME_VSYSCALL if X86_64
+	select GENERIC_TIME_VSYSCALL
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
index 0bdbbb3..67d68b9 100644
--- a/arch/x86/include/asm/clocksource.h
+++ b/arch/x86/include/asm/clocksource.h
@@ -3,8 +3,6 @@
 #ifndef _ASM_X86_CLOCKSOURCE_H
 #define _ASM_X86_CLOCKSOURCE_H
 
-#ifdef CONFIG_X86_64
-
 #define VCLOCK_NONE 0  /* No vDSO clock available.	*/
 #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
 #define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
@@ -13,6 +11,4 @@ struct arch_clocksource_data {
 	int vclock_mode;
 };
 
-#endif /* CONFIG_X86_64 */
-
 #endif /* _ASM_X86_CLOCKSOURCE_H */
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 4da3c0c..b26e9e0 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -78,9 +78,10 @@ enum fixed_addresses {
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
+#endif
 	VVAR_PAGE,
 	VSYSCALL_HPET,
-#endif
+
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 46e24d3..eb87b53 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -27,4 +27,5 @@ struct vsyscall_gtod_data {
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
+extern void map_vgtod(void);
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index de656ac..6f71098 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -17,7 +17,11 @@
  */
 
 /* Base address of vvars.  This is not ABI. */
+#ifdef CONFIG_X86_64
 #define VVAR_ADDRESS (-10*1024*1024 - 4096)
+#else
+#define VVAR_ADDRESS 0xffffd000
+#endif
 
 #if defined(__VVAR_KERNEL_LDS)
 
@@ -46,5 +50,8 @@
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
 DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+#ifdef CONFIG_X86_32
+DECLARE_VVAR(512, const void __iomem *, vsyscall_hpet)
+#endif
 
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
index 1460a5d..38887ca 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -69,13 +69,18 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 
 #ifdef CONFIG_X86_64
 #include <asm/pgtable.h>
+#else
+#include <asm/vvar.h>
+
+DEFINE_VVAR(const void __iomem *, vsyscall_hpet);
 #endif
 
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_64
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
+#ifdef CONFIG_X86_32
+	vsyscall_hpet = (const void __iomem *)fix_to_virt(VSYSCALL_HPET);
 #endif
 }
 
@@ -752,9 +757,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
-#ifdef CONFIG_X86_64
 	.archdata	= { .vclock_mode = VCLOCK_HPET },
-#endif
 };
 
 static int hpet_clocksource_register(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..c2f6bbb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -114,6 +114,7 @@
 #include <asm/mce.h>
 #include <asm/alternative.h>
 #include <asm/prom.h>
+#include <asm/vgtod.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -997,6 +998,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_64
 	map_vsyscall();
 #endif
+	map_vgtod();
 
 	generic_apic_probe();
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..078cc9a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -772,9 +772,7 @@ static struct clocksource clocksource_tsc = {
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
-#ifdef CONFIG_X86_64
 	.archdata               = { .vclock_mode = VCLOCK_TSC },
-#endif
 };
 
 void mark_tsc_unstable(char *reason)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 22a1530..31a0cdd 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -151,8 +151,6 @@ SECTIONS
 		_edata = .;
 	} :data
 
-#ifdef CONFIG_X86_64
-
 	. = ALIGN(PAGE_SIZE);
 	__vvar_page = .;
 
@@ -173,8 +171,6 @@ SECTIONS
 
        . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
 
-#endif /* CONFIG_X86_64 */
-
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
 	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3a3e8c9..dfc9727 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -54,7 +54,6 @@
 #include "vsyscall_trace.h"
 
 DEFINE_VVAR(int, vgetcpu_mode);
-DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
 
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
@@ -77,48 +76,6 @@ static int __init vsyscall_setup(char *str)
 }
 early_param("vsyscall", vsyscall_setup);
 
-void update_vsyscall_tz(void)
-{
-	vsyscall_gtod_data.sys_tz = sys_tz;
-}
-
-void update_vsyscall(struct timekeeper *tk)
-{
-	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
-
-	write_seqcount_begin(&vdata->seq);
-
-	/* copy vsyscall data */
-	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->clock.cycle_last		= tk->clock->cycle_last;
-	vdata->clock.mask		= tk->clock->mask;
-	vdata->clock.mult		= tk->mult;
-	vdata->clock.shift		= tk->shift;
-
-	vdata->wall_time_sec		= tk->xtime_sec;
-	vdata->wall_time_snsec		= tk->xtime_nsec;
-
-	vdata->monotonic_time_sec	= tk->xtime_sec
-					+ tk->wall_to_monotonic.tv_sec;
-	vdata->monotonic_time_snsec	= tk->xtime_nsec
-					+ (tk->wall_to_monotonic.tv_nsec
-						<< tk->shift);
-	while (vdata->monotonic_time_snsec >=
-					(((u64)NSEC_PER_SEC) << tk->shift)) {
-		vdata->monotonic_time_snsec -=
-					((u64)NSEC_PER_SEC) << tk->shift;
-		vdata->monotonic_time_sec++;
-	}
-
-	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
-	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
-
-	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
-							tk->wall_to_monotonic);
-
-	write_seqcount_end(&vdata->seq);
-}
-
 static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 			      const char *message)
 {
@@ -366,8 +323,6 @@ void __init map_vsyscall(void)
 {
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
-	extern char __vvar_page;
-	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_vsyscall,
 		     vsyscall_mode == NATIVE
@@ -375,10 +330,6 @@ void __init map_vsyscall(void)
 		     : PAGE_KERNEL_VVAR);
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_FIRST_PAGE) !=
 		     (unsigned long)VSYSCALL_START);
-
-	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
-		     (unsigned long)VVAR_ADDRESS);
 }
 
 static int __init vsyscall_init(void)
diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
new file mode 100644
index 0000000..9b96488
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -0,0 +1,93 @@
+/*
+ *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
+ *  Copyright 2003 Andi Kleen, SuSE Labs.
+ *
+ *  Modified for x86 32 bit architecture by
+ *  Stefani Seibold <stefani@seibold.net>
+ *
+ *  Thanks to hpa@transmeta.com for some useful hint.
+ *  Special thanks to Ingo Molnar for his early experience with
+ *  a different vsyscall implementation for Linux/IA32 and for the name.
+ *
+ */
+
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/timer.h>
+#include <linux/seqlock.h>
+#include <linux/jiffies.h>
+#include <linux/sysctl.h>
+#include <linux/topology.h>
+#include <linux/timekeeper_internal.h>
+#include <linux/ratelimit.h>
+
+#include <asm/vsyscall.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+#include <asm/unistd.h>
+#include <asm/fixmap.h>
+#include <asm/errno.h>
+#include <asm/io.h>
+#include <asm/segment.h>
+#include <asm/desc.h>
+#include <asm/topology.h>
+#include <asm/vgtod.h>
+#include <asm/traps.h>
+
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
+
+void update_vsyscall_tz(void)
+{
+	vsyscall_gtod_data.sys_tz = sys_tz;
+}
+
+void update_vsyscall(struct timekeeper *tk)
+{
+	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
+
+	write_seqcount_begin(&vdata->seq);
+
+	/* copy vsyscall data */
+	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
+	vdata->clock.cycle_last		= tk->clock->cycle_last;
+	vdata->clock.mask		= tk->clock->mask;
+	vdata->clock.mult		= tk->mult;
+	vdata->clock.shift		= tk->shift;
+
+	vdata->wall_time_sec		= tk->xtime_sec;
+	vdata->wall_time_snsec		= tk->xtime_nsec;
+
+	vdata->monotonic_time_sec	= tk->xtime_sec
+					+ tk->wall_to_monotonic.tv_sec;
+	vdata->monotonic_time_snsec	= tk->xtime_nsec
+					+ (tk->wall_to_monotonic.tv_nsec
+						<< tk->shift);
+	while (vdata->monotonic_time_snsec >=
+					(((u64)NSEC_PER_SEC) << tk->shift)) {
+		vdata->monotonic_time_snsec -=
+					((u64)NSEC_PER_SEC) << tk->shift;
+		vdata->monotonic_time_sec++;
+	}
+
+	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
+	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
+
+	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
+							tk->wall_to_monotonic);
+
+	write_seqcount_end(&vdata->seq);
+}
+
+void __init map_vgtod(void)
+{
+	extern char __vvar_page;
+	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
+
+	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
+		     (unsigned long)VVAR_ADDRESS);
+#endif
+}
+
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..959221b 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -147,6 +147,7 @@ $(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
 
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
+				 $(obj)/vdso32/vclock_gettime.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 4df6c37..3490e1c 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -57,6 +57,7 @@ notrace static cycle_t vread_tsc(void)
 	return last;
 }
 
+#ifdef CONFIG_X86_64
 static notrace cycle_t vread_hpet(void)
 {
 	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
@@ -78,11 +79,33 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
 	return ret;
 }
+#else
+static notrace cycle_t vread_hpet(void)
+{
+	return readl(VVAR(vsyscall_hpet) + HPET_COUNTER);
+}
 
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+	asm("call VDSO32_vsyscall" : "=a" (ret) :
+	    "a" (__NR_clock_gettime), "b" (clock), "c" (ts) : "memory");
+	return ret;
+}
+
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+
+	asm("call VDSO32_vsyscall" : "=a" (ret) :
+	    "a" (__NR_gettimeofday), "b" (tv), "c" (tz) : "memory");
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
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
new file mode 100644
index 0000000..c9a1909
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -0,0 +1,7 @@
+/*
+ * since vgtod layout differs between X86_64 and x86_32, it is not possible to
+ * provide a 32 bit vclock with a 64 bit kernel
+ */
+#ifdef CONFIG_X86_32
+#include "../vclock_gettime.c"
+#endif
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 976124b..197d50f 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -24,6 +24,11 @@ VERSION
 		__kernel_vsyscall;
 		__kernel_sigreturn;
 		__kernel_rt_sigreturn;
+#ifdef CONFIG_X86_32
+		__vdso_clock_gettime;
+		__vdso_gettimeofday;
+		__vdso_time;
+#endif
 	local: *;
 	};
 }
-- 
1.8.0


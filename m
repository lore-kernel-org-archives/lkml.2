Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2LQWSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:18:10 -0500
Received: from www84.your-server.de ([213.133.104.84]:39848 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2LQWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:14:13 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH] Add 32 bit VDSO time function support
Date: Mon, 17 Dec 2012 23:12:45 +0100
Message-Id: <1355782365-11307-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
and vdso_time() to the 32 bit VDSO.

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

Some benchmark linux 32 bit results (all measurements are in nano seconds):

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
17.12.2012 - support for IA32_EMULATION, this includes
             - code cleanup
             - include cleanup to fix compile warnings and errors
	     - move out seqcount from seqlock, enable use in VDSO
	     - map FIXMAP and HPET into the 32 bit address space

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/Kconfig                      |   4 +-
 arch/x86/include/asm/clocksource.h    |   4 -
 arch/x86/include/asm/fixmap.h         |   6 +-
 arch/x86/include/asm/vgtod.h          |  10 ++-
 arch/x86/include/asm/vsyscall.h       |   1 -
 arch/x86/include/asm/vvar.h           |   5 ++
 arch/x86/kernel/Makefile              |   1 +
 arch/x86/kernel/hpet.c                |  11 ++-
 arch/x86/kernel/setup.c               |   2 +
 arch/x86/kernel/tsc.c                 |   2 -
 arch/x86/kernel/vmlinux.lds.S         |   4 -
 arch/x86/kernel/vsyscall_64.c         |  49 -----------
 arch/x86/kernel/vsyscall_gtod.c       |  93 +++++++++++++++++++++
 arch/x86/mm/init_32.c                 |   1 +
 arch/x86/vdso/Makefile                |   6 ++
 arch/x86/vdso/vclock_gettime.c        | 108 ++++++++++++++++++------
 arch/x86/vdso/vdso32-setup.c          |  41 ++++++++++
 arch/x86/vdso/vdso32/vclock_gettime.c |  29 +++++++
 arch/x86/vdso/vdso32/vdso32.lds.S     |   3 +
 include/linux/clocksource.h           |   1 -
 include/linux/mm.h                    |   3 +
 include/linux/seqcount.h              | 150 ++++++++++++++++++++++++++++++++++
 include/linux/seqlock.h               | 145 +-------------------------------
 include/linux/time.h                  |   3 +-
 include/linux/timekeeper_internal.h   |   1 +
 include/linux/types.h                 |   2 +
 mm/mmap.c                             |  20 ++++-
 27 files changed, 457 insertions(+), 248 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_gtod.c
 create mode 100644 arch/x86/vdso/vdso32/vclock_gettime.c
 create mode 100644 include/linux/seqcount.h

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
index 4da3c0c..75ebc52 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -16,7 +16,8 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
-#include <asm/acpi.h>
+#include <linux/bug.h>
+#include <asm/pgtable_types.h>
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #ifdef CONFIG_X86_32
@@ -78,9 +79,10 @@ enum fixed_addresses {
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
index 46e24d3..74c80d4 100644
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
@@ -13,7 +13,7 @@ struct vsyscall_gtod_data {
 		cycle_t	mask;
 		u32	mult;
 		u32	shift;
-	} clock;
+	} __attribute__((aligned(4),packed)) clock;
 
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
@@ -24,7 +24,9 @@ struct vsyscall_gtod_data {
 	struct timezone sys_tz;
 	struct timespec wall_time_coarse;
 	struct timespec monotonic_time_coarse;
-};
+} __attribute__((aligned(4),packed));
+
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
+extern void map_vgtod(void);
 #endif /* _ASM_X86_VGTOD_H */
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
index de656ac..1e71e6c 100644
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
 
@@ -46,5 +50,6 @@
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
index 1460a5d..4b7bb5d 100644
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
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..394e563 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -52,6 +52,7 @@
 #include <asm/cacheflush.h>
 #include <asm/page_types.h>
 #include <asm/init.h>
+#include <asm/numa_32.h>
 
 unsigned long highstart_pfn, highend_pfn;
 
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
index 0faad64..02fe183 100644
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
@@ -352,6 +363,36 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
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
+		struct vm_area_struct *vma = _install_special_mapping(mm,
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
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4dceaf8..84ed093 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -19,7 +19,6 @@
 #include <asm/io.h>
 
 /* clocksource cycle base type */
-typedef u64 cycle_t;
 struct clocksource;
 
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcaab4e..82a992b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1435,6 +1435,9 @@ extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
+				   unsigned long addr, unsigned long len,
+				   unsigned long flags, struct page **pages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/include/linux/seqcount.h b/include/linux/seqcount.h
new file mode 100644
index 0000000..a810136
--- /dev/null
+++ b/include/linux/seqcount.h
@@ -0,0 +1,150 @@
+/*
+ * Version using sequence counter only.
+ * This can be used when code has its own mutex protecting the
+ * updating starting before the write_seqcountbeqin() and ending
+ * after the write_seqcount_end().
+ */
+
+#ifndef __LINUX_SEQCOUNT_H
+#define __LINUX_SEQCOUNT_H
+
+#include <asm/processor.h>
+#include <asm/barrier.h>
+
+typedef struct seqcount {
+	unsigned sequence;
+} seqcount_t;
+
+#define SEQCNT_ZERO { 0 }
+#define seqcount_init(x) do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+
+/**
+ * __read_seqcount_begin - begin a seq-read critical section (without barrier)
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * __read_seqcount_begin is like read_seqcount_begin, but has no smp_rmb()
+ * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
+ * provided before actually loading any of the variables that are to be
+ * protected in this critical section.
+ *
+ * Use carefully, only in critical code, and comment how the barrier is
+ * provided.
+ */
+static inline unsigned __read_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret;
+
+repeat:
+	ret = ACCESS_ONCE(s->sequence);
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+	return ret;
+}
+
+/**
+ * read_seqcount_begin - begin a seq-read critical section
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * read_seqcount_begin opens a read critical section of the given seqcount.
+ * Validity of the critical section is tested by checking read_seqcount_retry
+ * function.
+ */
+static inline unsigned read_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret = __read_seqcount_begin(s);
+	smp_rmb();
+	return ret;
+}
+
+/**
+ * raw_seqcount_begin - begin a seq-read critical section
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * raw_seqcount_begin opens a read critical section of the given seqcount.
+ * Validity of the critical section is tested by checking read_seqcount_retry
+ * function.
+ *
+ * Unlike read_seqcount_begin(), this function will not wait for the count
+ * to stabilize. If a writer is active when we begin, we will fail the
+ * read_seqcount_retry() instead of stabilizing at the beginning of the
+ * critical section.
+ */
+static inline unsigned raw_seqcount_begin(const seqcount_t *s)
+{
+	unsigned ret = ACCESS_ONCE(s->sequence);
+	smp_rmb();
+	return ret & ~1;
+}
+
+/**
+ * __read_seqcount_retry - end a seq-read critical section (without barrier)
+ * @s: pointer to seqcount_t
+ * @start: count, from read_seqcount_begin
+ * Returns: 1 if retry is required, else 0
+ *
+ * __read_seqcount_retry is like read_seqcount_retry, but has no smp_rmb()
+ * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
+ * provided before actually loading any of the variables that are to be
+ * protected in this critical section.
+ *
+ * Use carefully, only in critical code, and comment how the barrier is
+ * provided.
+ */
+static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
+{
+	return unlikely(s->sequence != start);
+}
+
+/**
+ * read_seqcount_retry - end a seq-read critical section
+ * @s: pointer to seqcount_t
+ * @start: count, from read_seqcount_begin
+ * Returns: 1 if retry is required, else 0
+ *
+ * read_seqcount_retry closes a read critical section of the given seqcount.
+ * If the critical section was invalid, it must be ignored (and typically
+ * retried).
+ */
+static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
+{
+	smp_rmb();
+
+	return __read_seqcount_retry(s, start);
+}
+
+
+/*
+ * Sequence counter only version assumes that callers are using their
+ * own mutexing.
+ */
+static inline void write_seqcount_begin(seqcount_t *s)
+{
+	s->sequence++;
+	smp_wmb();
+}
+
+static inline void write_seqcount_end(seqcount_t *s)
+{
+	smp_wmb();
+	s->sequence++;
+}
+
+/**
+ * write_seqcount_barrier - invalidate in-progress read-side seq operations
+ * @s: pointer to seqcount_t
+ *
+ * After write_seqcount_barrier, no read-side seq operations will complete
+ * successfully and see data older than this.
+ */
+static inline void write_seqcount_barrier(seqcount_t *s)
+{
+	smp_wmb();
+	s->sequence += 2;
+}
+
+#endif /* __LINUX_SEQCOUNT_H */
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 600060e2..f8e8235 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/preempt.h>
 #include <asm/processor.h>
+#include <linux/seqcount.h>
 
 typedef struct {
 	unsigned sequence;
@@ -108,150 +109,6 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 	return unlikely(sl->sequence != start);
 }
 
-
-/*
- * Version using sequence counter only.
- * This can be used when code has its own mutex protecting the
- * updating starting before the write_seqcountbeqin() and ending
- * after the write_seqcount_end().
- */
-
-typedef struct seqcount {
-	unsigned sequence;
-} seqcount_t;
-
-#define SEQCNT_ZERO { 0 }
-#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
-
-/**
- * __read_seqcount_begin - begin a seq-read critical section (without barrier)
- * @s: pointer to seqcount_t
- * Returns: count to be passed to read_seqcount_retry
- *
- * __read_seqcount_begin is like read_seqcount_begin, but has no smp_rmb()
- * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
- * provided before actually loading any of the variables that are to be
- * protected in this critical section.
- *
- * Use carefully, only in critical code, and comment how the barrier is
- * provided.
- */
-static inline unsigned __read_seqcount_begin(const seqcount_t *s)
-{
-	unsigned ret;
-
-repeat:
-	ret = ACCESS_ONCE(s->sequence);
-	if (unlikely(ret & 1)) {
-		cpu_relax();
-		goto repeat;
-	}
-	return ret;
-}
-
-/**
- * read_seqcount_begin - begin a seq-read critical section
- * @s: pointer to seqcount_t
- * Returns: count to be passed to read_seqcount_retry
- *
- * read_seqcount_begin opens a read critical section of the given seqcount.
- * Validity of the critical section is tested by checking read_seqcount_retry
- * function.
- */
-static inline unsigned read_seqcount_begin(const seqcount_t *s)
-{
-	unsigned ret = __read_seqcount_begin(s);
-	smp_rmb();
-	return ret;
-}
-
-/**
- * raw_seqcount_begin - begin a seq-read critical section
- * @s: pointer to seqcount_t
- * Returns: count to be passed to read_seqcount_retry
- *
- * raw_seqcount_begin opens a read critical section of the given seqcount.
- * Validity of the critical section is tested by checking read_seqcount_retry
- * function.
- *
- * Unlike read_seqcount_begin(), this function will not wait for the count
- * to stabilize. If a writer is active when we begin, we will fail the
- * read_seqcount_retry() instead of stabilizing at the beginning of the
- * critical section.
- */
-static inline unsigned raw_seqcount_begin(const seqcount_t *s)
-{
-	unsigned ret = ACCESS_ONCE(s->sequence);
-	smp_rmb();
-	return ret & ~1;
-}
-
-/**
- * __read_seqcount_retry - end a seq-read critical section (without barrier)
- * @s: pointer to seqcount_t
- * @start: count, from read_seqcount_begin
- * Returns: 1 if retry is required, else 0
- *
- * __read_seqcount_retry is like read_seqcount_retry, but has no smp_rmb()
- * barrier. Callers should ensure that smp_rmb() or equivalent ordering is
- * provided before actually loading any of the variables that are to be
- * protected in this critical section.
- *
- * Use carefully, only in critical code, and comment how the barrier is
- * provided.
- */
-static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
-{
-	return unlikely(s->sequence != start);
-}
-
-/**
- * read_seqcount_retry - end a seq-read critical section
- * @s: pointer to seqcount_t
- * @start: count, from read_seqcount_begin
- * Returns: 1 if retry is required, else 0
- *
- * read_seqcount_retry closes a read critical section of the given seqcount.
- * If the critical section was invalid, it must be ignored (and typically
- * retried).
- */
-static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
-{
-	smp_rmb();
-
-	return __read_seqcount_retry(s, start);
-}
-
-
-/*
- * Sequence counter only version assumes that callers are using their
- * own mutexing.
- */
-static inline void write_seqcount_begin(seqcount_t *s)
-{
-	s->sequence++;
-	smp_wmb();
-}
-
-static inline void write_seqcount_end(seqcount_t *s)
-{
-	smp_wmb();
-	s->sequence++;
-}
-
-/**
- * write_seqcount_barrier - invalidate in-progress read-side seq operations
- * @s: pointer to seqcount_t
- *
- * After write_seqcount_barrier, no read-side seq operations will complete
- * successfully and see data older than this.
- */
-static inline void write_seqcount_barrier(seqcount_t *s)
-{
-	smp_wmb();
-	s->sequence+=2;
-}
-
 /*
  * Possible sw/hw IRQ protected versions of the interfaces.
  */
diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..edfab8a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -2,9 +2,8 @@
 #define _LINUX_TIME_H
 
 # include <linux/cache.h>
-# include <linux/seqlock.h>
 # include <linux/math64.h>
-#include <uapi/linux/time.h>
+# include <uapi/linux/time.h>
 
 extern struct timezone sys_tz;
 
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index e1d558e..9a55a0c 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -9,6 +9,7 @@
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
+#include <linux/seqlock.h>
 
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
diff --git a/include/linux/types.h b/include/linux/types.h
index 1cc0e4b..3ff59cf 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -74,6 +74,8 @@ typedef __kernel_time_t		time_t;
 typedef __kernel_clock_t	clock_t;
 #endif
 
+typedef u64 cycle_t;
+
 #ifndef _CADDR_T
 #define _CADDR_T
 typedef __kernel_caddr_t	caddr_t;
diff --git a/mm/mmap.c b/mm/mmap.c
index 9a796c4..dd85d21 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2515,7 +2515,7 @@ static const struct vm_operations_struct special_mapping_vmops = {
  * The array pointer and the pages it points to are assumed to stay alive
  * for as long as this mapping might exist.
  */
-int install_special_mapping(struct mm_struct *mm,
+struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
@@ -2524,7 +2524,7 @@ int install_special_mapping(struct mm_struct *mm,
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_mm = mm;
@@ -2545,11 +2545,23 @@ int install_special_mapping(struct mm_struct *mm,
 
 	perf_event_mmap(vma);
 
-	return 0;
+	return vma;
 
 out:
 	kmem_cache_free(vm_area_cachep, vma);
-	return ret;
+	return ERR_PTR(ret);
+}
+
+int install_special_mapping(struct mm_struct *mm,
+			    unsigned long addr, unsigned long len,
+			    unsigned long vm_flags, struct page **pages)
+{
+	struct vm_area_struct *vma = _install_special_mapping(mm,
+			    addr, len, vm_flags, pages);
+
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
+	return 0;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
-- 
1.8.0


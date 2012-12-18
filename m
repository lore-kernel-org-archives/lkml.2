Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2LRJnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:43:00 -0500
Received: from www84.your-server.de ([213.133.104.84]:50127 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2LRJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:18 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 2/6] Make vsyscall_gtod_data handling x86 generic
Date: Tue, 18 Dec 2012 10:40:52 +0100
Message-Id: <1355823656-13902-3-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355823656-13902-1-git-send-email-stefani@seibold.net>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch move the vsyscall_gtod_data handling out of vsyscall_64.c
into an additonal file vsyscall_gtod.c and make the functions
available for x86 32 bit kernels.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/Kconfig                   |  4 +-
 arch/x86/include/asm/fixmap.h      |  6 +-
 arch/x86/include/asm/clocksource.h |  4 --
 arch/x86/include/asm/vgtod.h       |  1 +
 arch/x86/include/asm/vvar.h        |  4 ++
 arch/x86/kernel/hpet.c             |  2 -
 arch/x86/kernel/setup.c            |  2 +
 arch/x86/kernel/tsc.c              |  2 -
 arch/x86/kernel/vmlinux.lds.S      |  4 --
 arch/x86/kernel/vsyscall_64.c      | 49 --------------------
 arch/x86/kernel/vsyscall_gtod.c    | 93 ++++++++++++++++++++++++++++++++++++++
 10 files changed, 102 insertions(+), 63 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_gtod.c

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
index de656ac..8084d55 100644
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
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..859bb2d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -752,9 +752,7 @@ static struct clocksource clocksource_hpet = {
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
-- 
1.8.0


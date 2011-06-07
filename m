Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab1FGTdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:33:41 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62176 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab1FGTdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:33:21 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-40-4dee7cf1198f
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 5/5] x86-64: Move vread_tsc and vread_hpet into the vDSO
Date: Tue,  7 Jun 2011 15:32:42 -0400
Message-Id: <9479879070446ab1dcdfb303f9aee3c7dbe8a0fd.1307474707.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsUixCmqrPux5p2vQesGFYu+K0fZLS7vmsNm
	seVSM6vFjw2PWR1YPG61/WH22DnrLrvHplWdbB6fN8kFsERx2aSk5mSWpRbp2yVwZbx871mw
	J7ri1e2LjA2Mv7y6GDk5JARMJE7cWM4OYYtJXLi3nq2LkYtDSGAfo8SVjj/MEM56RokJVxdB
	ZQ4xSdyddAGshU1ARaJj6QOmLkYODhEBIYmld+tAwswCaRJzr/9iAbGFBTwkXs5+zAxiswio
	Snx5fBcszisQJHGt4yMrSKuEgILE+VX5ICangIHEv9u1IKaQgL7Ehi+C2EUnMAosYGRYxSib
	klulm5uYmVOcmqxbnJyYl5dapGusl5tZopeaUrqJERx6knw7GL8eVDrEKMDBqMTDWxDyzleI
	NbGsuDL3EKMkB5OSKK9hNVCILyk/pTIjsTgjvqg0J7X4EKMEB7OSCO+M6299hXhTEiurUovy
	YVLSHCxK4rwzJdV9hQTSE0tSs1NTC1KLYLIyHBxKErypwBgTEixKTU+tSMvMKUFIM3Fwggzn
	ARr+GmQxb3FBYm5xZjpE/hSjMcehk68OMnJsPfH2IKMQS15+XqqUOC8fyDgBkNKM0jy4abD0
	8YpRHOg5Yd5EkCoeYOqBm/cKaBUT0KrTZ0H+KC5JREhJNTBuDOpeksKVeft+6+rJ265tufFW
	1S9w/ekH3BWSu1mNW2S7cz6nlpz8fHpi6Tfvcqkp4ndZLDreP/OSzdotc/Hw42kP4i+G6bws
	jC78uX6P0rbovIw68bmHgvt8Y47PnnuNJWba4eul0wUfRqefycrqStvQLvvWZtvSoCUX2Aqf
	lDOU6UpONH2qxFKckWioxVxUnAgAkzE9WfoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vsyscall page now consists entirely of trap instructions.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/clocksource.h |    6 +++-
 arch/x86/include/asm/tsc.h         |    4 ---
 arch/x86/include/asm/vgtod.h       |    2 +-
 arch/x86/include/asm/vsyscall.h    |    4 ---
 arch/x86/kernel/Makefile           |    7 +----
 arch/x86/kernel/alternative.c      |    8 -----
 arch/x86/kernel/hpet.c             |    9 +-----
 arch/x86/kernel/tsc.c              |    2 +-
 arch/x86/kernel/vmlinux.lds.S      |    3 --
 arch/x86/kernel/vread_tsc_64.c     |   36 -------------------------
 arch/x86/kernel/vsyscall_64.c      |    2 +-
 arch/x86/vdso/vclock_gettime.c     |   52 +++++++++++++++++++++++++++++++----
 12 files changed, 56 insertions(+), 79 deletions(-)
 delete mode 100644 arch/x86/kernel/vread_tsc_64.c

diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
index a5df33f..3882c65 100644
--- a/arch/x86/include/asm/clocksource.h
+++ b/arch/x86/include/asm/clocksource.h
@@ -7,8 +7,12 @@
 
 #define __ARCH_HAS_CLOCKSOURCE_DATA
 
+#define VCLOCK_NONE 0  /* No vDSO clock available.	*/
+#define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
+#define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
+
 struct arch_clocksource_data {
-	cycle_t (*vread)(void);
+	int vclock_mode;
 };
 
 #endif /* CONFIG_X86_64 */
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9db5583..83e2efd 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -51,10 +51,6 @@ extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
 
-#ifdef CONFIG_X86_64
-extern cycles_t vread_tsc(void);
-#endif
-
 /*
  * Boot-time check whether the TSCs are synchronized across
  * all CPUs/cores:
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index aa5add8..815285b 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -13,7 +13,7 @@ struct vsyscall_gtod_data {
 
 	struct timezone sys_tz;
 	struct { /* extract of a clocksource struct */
-		cycle_t (*vread)(void);
+		int vclock_mode;
 		cycle_t	cycle_last;
 		cycle_t	mask;
 		u32	mult;
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index bb710cb..fa904ab 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -16,10 +16,6 @@ enum vsyscall_num {
 #ifdef __KERNEL__
 #include <linux/seqlock.h>
 
-/* Definitions for CONFIG_GENERIC_TIME definitions */
-#define __vsyscall_fn \
-	__attribute__ ((unused, __section__(".vsyscall_fn"))) notrace
-
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cc0469a..2deef3d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,17 +24,12 @@ endif
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
-CFLAGS_vread_tsc_64.o	:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
 GCOV_PROFILE_tsc.o		:= n
-GCOV_PROFILE_vread_tsc_64.o	:= n
 GCOV_PROFILE_paravirt.o		:= n
 
-# vread_tsc_64 is hot and should be fully optimized:
-CFLAGS_REMOVE_vread_tsc_64.o = -pg -fno-optimize-sibling-calls
-
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
@@ -43,7 +38,7 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ddb207b..c638228 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -14,7 +14,6 @@
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
-#include <asm/vsyscall.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
@@ -250,7 +249,6 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-extern char __vsyscall_0;
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -294,12 +292,6 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 
-#ifdef CONFIG_X86_64
-		/* vsyscall code is not mapped yet. resolve it manually. */
-		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
-			instr = __va(instr - (u8*)VSYSCALL_START + (u8*)__pa_symbol(&__vsyscall_0));
-		}
-#endif
 		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 0e07257..d10cc00 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -738,13 +738,6 @@ static cycle_t read_hpet(struct clocksource *cs)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
-#ifdef CONFIG_X86_64
-static cycle_t __vsyscall_fn vread_hpet(void)
-{
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
-}
-#endif
-
 static struct clocksource clocksource_hpet = {
 	.name		= "hpet",
 	.rating		= 250,
@@ -753,7 +746,7 @@ static struct clocksource clocksource_hpet = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
-	.archdata	= { .vread = vread_hpet },
+	.archdata	= { .vclock_mode = VCLOCK_HPET },
 #endif
 };
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index e7a74b8..56c633a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -777,7 +777,7 @@ static struct clocksource clocksource_tsc = {
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 #ifdef CONFIG_X86_64
-	.archdata               = { .vread = vread_tsc },
+	.archdata               = { .vclock_mode = VCLOCK_TSC },
 #endif
 };
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 8017471..4aa9c54 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -169,9 +169,6 @@ SECTIONS
 	.vsyscall : AT(VLOAD(.vsyscall)) {
 		*(.vsyscall_0)
 
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.vsyscall_fn)
-
 		. = 1024;
 		*(.vsyscall_1)
 
diff --git a/arch/x86/kernel/vread_tsc_64.c b/arch/x86/kernel/vread_tsc_64.c
deleted file mode 100644
index a81aa9e..0000000
--- a/arch/x86/kernel/vread_tsc_64.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/* This code runs in userspace. */
-
-#define DISABLE_BRANCH_PROFILING
-#include <asm/vgtod.h>
-
-notrace cycle_t __vsyscall_fn vread_tsc(void)
-{
-	cycle_t ret;
-	u64 last;
-
-	/*
-	 * Empirically, a fence (of type that depends on the CPU)
-	 * before rdtsc is enough to ensure that rdtsc is ordered
-	 * with respect to loads.  The various CPU manuals are unclear
-	 * as to whether rdtsc can be reordered with later loads,
-	 * but no one has ever seen it happen.
-	 */
-	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
-
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
-
-	if (likely(ret >= last))
-		return ret;
-
-	/*
-	 * GCC likes to generate cmov here, but this branch is extremely
-	 * predictable (it's just a funciton of time and the likely is
-	 * very likely) and there's a data dependence, so force GCC
-	 * to generate a branch instead.  I don't barrier() because
-	 * we don't actually need a barrier, and if this function
-	 * ever gets inlined it will generate worse code.
-	 */
-	asm volatile ("");
-	return last;
-}
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index eb0d3ef..584431f 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -73,7 +73,7 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vread		= clock->archdata.vread;
+	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
 	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
 	vsyscall_gtod_data.clock.mask		= clock->mask;
 	vsyscall_gtod_data.clock.mult		= mult;
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index cf54813..9869bac 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -25,6 +25,43 @@
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
+notrace static cycle_t vread_tsc(void)
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
+
+static notrace cycle_t vread_hpet(void)
+{
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
@@ -36,9 +73,12 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 notrace static inline long vgetns(void)
 {
 	long v;
-	cycles_t (*vread)(void);
-	vread = gtod->clock.vread;
-	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
+	cycles_t cycles;
+	if (gtod->clock.vclock_mode == VCLOCK_TSC)
+		cycles = vread_tsc();
+	else
+		cycles = vread_hpet();
+	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
@@ -118,11 +158,11 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	switch (clock) {
 	case CLOCK_REALTIME:
-		if (likely(gtod->clock.vread))
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
 			return do_realtime(ts);
 		break;
 	case CLOCK_MONOTONIC:
-		if (likely(gtod->clock.vread))
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
 			return do_monotonic(ts);
 		break;
 	case CLOCK_REALTIME_COARSE:
@@ -139,7 +179,7 @@ int clock_gettime(clockid_t, struct timespec *)
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
-	if (likely(gtod->clock.vread)) {
+	if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
 		if (likely(tv != NULL)) {
 			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
 				     offsetof(struct timespec, tv_nsec) ||
-- 
1.7.5.2


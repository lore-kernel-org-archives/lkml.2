Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1DGCFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:05:09 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:55064 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932194Ab1DGCE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:59 -0400
X-AuditID: 12074425-b7c8cae00000429f-d5-4d9d1bd33920
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFT/PATCH v2 5/6] x86-64: Move vread_tsc into a new file with sensible options
Date: Wed,  6 Apr 2011 22:04:02 -0400
Message-Id: <6fc6093ec1acb82860cb941d63b2b9aa288bae4c.1302137785.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixCmqrXtZeq6vwck9PBZ9V46yWxy59p3d
	4vKuOWwWWy41s1ps3jSV2eLHhsesDmwet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3j8ya5
	ALYoLpuU1JzMstQifbsEroznkyUKJplWzJ51nLGBcZVWFyMnh4SAicTSZfdYIGwxiQv31rN1
	MXJxCAnsY5RoO/yQCcJZzyjRtfU2K4TzlEmid85psBY2ARWJjqUPgKo4OEQEhCSW3q0DqWEW
	2M4osWF5OwtIXFggQuLaDEuQchYBVYl7Fz+zgdi8AkESV2dfZe9iZAfaLCfRHAgS5RQwkLj4
	5T8riC0koC8xufcbIy7xCYwCCxgZVjHKpuRW6eYmZuYUpybrFicn5uWlFula6OVmluilppRu
	YgQFKruL6g7GCYeUDjEKcDAq8fCGds7xFWJNLCuuzD3EKMnBpCTK2ykx11eILyk/pTIjsTgj
	vqg0J7X4EKMEB7OSCK+SEFCONyWxsiq1KB8mJc3BoiTOO19S3VdIID2xJDU7NbUgtQgmK8PB
	oSTBmwCMSCHBotT01Iq0zJwShDQTByfIcB6g4RPEQYYXFyTmFmemQ+RPMepy/N9yaB+jEEte
	fl6qlDhvGsggAZCijNI8uDmwBPOKURzoLWHeQJAqHmBygpv0CmgJE9CShefmgCwpSURISTUw
	brq2zvFh6/3I+fK+a7k8vujVXWUVf8lR9EmVN7RYRuP5Bt/ZH7m/7pygO2Xa8axTpmYuJ9Sa
	NeTkHGIZ4lJZt2WKfwn9bjWRva/q459tSrccTqlNYG2dmBoQVBru/Hjjvkezj29Us7kyXSbq
	5uyZq326Kqe7b3Pjnbd2lfSVFyFMu9ROvflxVYmlOCPRUIu5qDgRAMyc0PULAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc is short and hot, and it's userspace code so the usual
reasons to keep frame pointers around, enable -pg, and turn off
sibling calls don't apply.

(OK, turning off sibling calls has no effect.  But it might
someday...)

As an added benefit, tsc.c is profilable now.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/tsc.h     |    4 +++
 arch/x86/kernel/Makefile       |    8 +++--
 arch/x86/kernel/tsc.c          |   53 --------------------------------------
 arch/x86/kernel/vread_tsc_64.c |   55 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 56 deletions(-)
 create mode 100644 arch/x86/kernel/vread_tsc_64.c

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 1ca132f..8f2b3c6 100644
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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..7626fb8 100644
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
+CFLAGS_REMOVE_vread_tsc_64.o = -pg -fno-omit-frame-pointer -fno-optimize-sibling-calls
+
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
@@ -39,7 +41,7 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 69ff619..5346381 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -763,59 +763,6 @@ static cycle_t read_tsc(struct clocksource *cs)
 		ret : clocksource_tsc.cycle_last;
 }
 
-#ifdef CONFIG_X86_64
-static cycle_t __vsyscall_fn vread_tsc(void)
-{
-	cycle_t ret;
-	u64 zero, last;
-
-	/*
-	 * rdtsc is unordered, and we want it to be ordered like
-	 * a load with respect to other CPUs (and we don't want
-	 * it to execute absurdly early wrt code on this CPU).
-	 * rdtsc_barrier() is a barrier that provides this ordering
-	 * with respect to *earlier* loads.  (Which barrier to use
-	 * depends on the CPU.)
-	 */
-	rdtsc_barrier();
-
-	asm volatile ("rdtsc\n\t"
-		      "shl $0x20,%%rdx\n\t"
-		      "or %%rdx,%%rax\n\t"
-		      "shl $0x20,%%rdx"
-		      : "=a" (ret), "=d" (zero) : : "cc");
-
-	/*
-	 * zero == 0, but as far as the processor is concerned, zero
-	 * depends on the output of rdtsc.  So we can use it as a
-	 * load barrier by loading something that depends on it.
-	 * x86-64 keeps all loads in order wrt each other, so this
-	 * ensures that rdtsc is ordered wrt all later loads.
-	 */
-
-	/*
-	 * This doesn't multiply 'zero' by anything, which generates
-	 * very slightly nicer code than multiplying it by 8.
-	 */
-	last = *( (cycle_t *)
-		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
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
-#endif
-
 static void resume_tsc(struct clocksource *cs)
 {
 	clocksource_tsc.cycle_last = 0;
diff --git a/arch/x86/kernel/vread_tsc_64.c b/arch/x86/kernel/vread_tsc_64.c
new file mode 100644
index 0000000..856330e
--- /dev/null
+++ b/arch/x86/kernel/vread_tsc_64.c
@@ -0,0 +1,55 @@
+/* This code runs in userspace. */
+
+#define DISABLE_BRANCH_PROFILING
+#include <asm/vgtod.h>
+
+notrace cycle_t __vsyscall_fn vread_tsc(void)
+{
+	cycle_t ret;
+	u64 zero, last;
+
+	/*
+	 * rdtsc is unordered, and we want it to be ordered like
+	 * a load with respect to other CPUs (and we don't want
+	 * it to execute absurdly early wrt code on this CPU).
+	 * rdtsc_barrier() is a barrier that provides this ordering
+	 * with respect to *earlier* loads.  (Which barrier to use
+	 * depends on the CPU.)
+	 */
+	rdtsc_barrier();
+
+	asm volatile ("rdtsc\n\t"
+		      "shl $0x20,%%rdx\n\t"
+		      "or %%rdx,%%rax\n\t"
+		      "shl $0x20,%%rdx"
+		      : "=a" (ret), "=d" (zero) : : "cc");
+
+	/*
+	 * zero == 0, but as far as the processor is concerned, zero
+	 * depends on the output of rdtsc.  So we can use it as a
+	 * load barrier by loading something that depends on it.
+	 * x86-64 keeps all loads in order wrt each other, so this
+	 * ensures that rdtsc is ordered wrt all later loads.
+	 */
+
+	/*
+	 * This doesn't multiply 'zero' by anything, which generates
+	 * very slightly nicer code than multiplying it by 8.
+	 */
+	last = *( (cycle_t *)
+		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
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
-- 
1.7.4


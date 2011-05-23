Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1EWNd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:33:57 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:59982 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825Ab1EWNdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:33:05 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-60-4dda620bb360
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
Subject: [PATCH v5 5/8] x86-64: Move vread_tsc into a new file with sensible options
Date: Mon, 23 May 2011 09:31:28 -0400
Message-Id: <99c6d7f5efa3ccb65b4ac6eb443e1ab7bad47d7b.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsUixCmqrMuddMvXYN4Za4uLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DK2NvWy17QpVXxZuVu9gbGpUpdjJwcEgImErcX3WKBsMUkLtxbz9bFyMUhJLCP
	UWJu+z0mCGcDo8Th4ytZIZxnTBIbJrexg7SwCahIdCx9AFTFwSEiICSx9G4dSA2zwFpmiX3d
	i5lAaoQFQiQeP1oKtoJFQFWi+8IENhCbVyBI4k73O2aI1QoSV67MA6vhFDCQmL/7JJgtJKAv
	MenoUpziExgFFjAyrGKUTcmt0s1NzMwpTk3WLU5OzMtLLdI11svNLNFLTSndxAiOBEm+HYxf
	DyodYhTgYFTi4d2gedNXiDWxrLgy9xCjJAeTkiivS/wtXyG+pPyUyozE4oz4otKc1OJDjBIc
	zEoivA3aN3yFeFMSK6tSi/JhUtIcLErivDMl1X2FBNITS1KzU1MLUotgsjIcHEoSvGmJQEMF
	i1LTUyvSMnNKENJMHJwgw3mAhveC1PAWFyTmFmemQ+RPMepyTL39+wCjEEtefl6qlDhvHEiR
	AEhRRmke3BxYAnvFKA70ljBvAEgVDzD5wU16BbSECWiJxN+bIEtKEhFSUg2MVQLT3pXF9Uls
	dAlJyBfYvnbXVL3LmyvXmJ6+Me0T19sAzdfZ1qwTNhjrvJ/6bOl2tooMs3s3Zc7OiVM5He+1
	6MkVf8e5PW0xPObvXGbt+2oj6zlVwVg8NMvU6LPJgUnTdbu3emjcaFUsXFxnc82D8dndfCPP
	/zqMvb92ygQHx2oJTV6wcBmXEktxRqKhFnNRcSIAqQ2N0TsDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc is short and hot, and it's userspace code so the usual
reasons to enable -pg and turn off sibling calls don't apply.

(OK, turning off sibling calls has no effect.  But it might
someday...)

As an added benefit, tsc.c is profilable now.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/tsc.h     |    4 ++++
 arch/x86/kernel/Makefile       |    8 +++++---
 arch/x86/kernel/tsc.c          |   34 ----------------------------------
 arch/x86/kernel/vread_tsc_64.c |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 37 deletions(-)
 create mode 100644 arch/x86/kernel/vread_tsc_64.c

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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7338ef2..a24521b 100644
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
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 24249a5..6cc6922 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -763,40 +763,6 @@ static cycle_t read_tsc(struct clocksource *cs)
 		ret : clocksource_tsc.cycle_last;
 }
 
-#ifdef CONFIG_X86_64
-static cycle_t __vsyscall_fn vread_tsc(void)
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
-#endif
-
 static void resume_tsc(struct clocksource *cs)
 {
 	clocksource_tsc.cycle_last = 0;
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
-- 
1.7.5.1


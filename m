Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab1EJOQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:16:11 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:46414 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932648Ab1EJOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:16:07 -0400
X-AuditID: 12074423-b7babae000007c6b-8d-4dc948a734ba
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 5/6] x86-64: Move vread_tsc into a new file with sensible options
Date: Tue, 10 May 2011 10:15:07 -0400
Message-Id: <84f1b1e345955d38309678d578ccdff9de6eca7b.1305035945.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsUixCmqrLvc46SvwaL5BhYX2y6yWfRdOcpu
	ceTad3aLOedbWCz2vT/LZnF51xw2iy2Xmlkt1k59w2KxedNUZotHfW/ZLX5seMzqwO1x5SmH
	x5aVN5k8brX9YfaYv/Mjo8fOWXfZPTat6mTzeHfuHLvHiRm/WTw2n672+LxJLoArissmJTUn
	syy1SN8ugSvj6K85TAUntCoevrJtYLyj1MXIySEhYCJxpHcuC4QtJnHh3nq2LkYuDiGBfYwS
	J1a9ZYRwNjBKnG7thnKeMUns3d3JBtLCJqAi0bH0AVMXIweHiICQxNK7dSBhZoHFzBJf7zuB
	2MICIRJ7z2wD28AioCqxcms7O4jNKxAksfDZfVaIzQoSV67MA6vhFDCQeHv4H9h4IQF9iUVL
	j+EUn8AosICRYRWjbEpulW5uYmZOcWqybnFyYl5eapGumV5uZoleakrpJkZQDLC7KO9g/HNQ
	6RCjAAejEg9vOeMJXyHWxLLiytxDjJIcTEqivJddTvoK8SXlp1RmJBZnxBeV5qQWH2KU4GBW
	EuGd9xOonDclsbIqtSgfJiXNwaIkzjtXUt1XSCA9sSQ1OzW1ILUIJivDwaEkwSsPjHUhwaLU
	9NSKtMycEoQ0EwcnyHAeoOG2IDW8xQWJucWZ6RD5U4y6HNPbmg8wCrHk5eelSonzaoMUCYAU
	ZZTmwc2Bpa5XjOJAbwnzcoFU8QDTHtykV0BLmICWmG8A+aC4JBEhJdXA2JVcuVK1mjdB+pWE
	ndXepm2urDXyO00+1vKY/7LYuH7Xz0BJB7kZWpr9U3uPSk+OebvI4mcTQ9H30tqYwGPFWTcC
	ZN94HvW41xzz6RqvxazS5ebzlVdON5vqsH+td+bCK8fNOYw2Sc9cdN2UPdtqe6djsV0Kr2dn
	9527oXwZYstq4u+/7rFRYinOSDTUYi4qTgQASnyo3TgDAAA=
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
 arch/x86/include/asm/tsc.h     |    4 ++++
 arch/x86/kernel/Makefile       |    8 +++++---
 arch/x86/kernel/tsc.c          |   34 ----------------------------------
 arch/x86/kernel/vread_tsc_64.c |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 37 deletions(-)
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
index db4c6e6..5346381 100644
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


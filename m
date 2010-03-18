Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0CRFwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 01:52:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:40978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0CRFwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 01:52:32 -0400
Date: Thu, 18 Mar 2010 05:51:42 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, benh@kernel.crashing.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100318050513.GA6575@drongo>
References: <20100318050513.GA6575@drongo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] powerpc/perf_events: Fix call-graph recording, add perf_arch_fetch_caller_regs
Message-ID: <tip-9eff26ea48bfbe2885b158742a7512a097ec911b@git.kernel.org>
Git-Commit-ID: 9eff26ea48bfbe2885b158742a7512a097ec911b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 05:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9eff26ea48bfbe2885b158742a7512a097ec911b
Gitweb:     http://git.kernel.org/tip/9eff26ea48bfbe2885b158742a7512a097ec911b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 18 Mar 2010 16:05:13 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 06:48:29 +0100

powerpc/perf_events: Fix call-graph recording, add perf_arch_fetch_caller_regs

This implements a powerpc version of perf_arch_fetch_caller_regs
to get correct call-graphs.

It's implemented in assembly because that way we can be sure there isn't
a stack frame for perf_arch_fetch_caller_regs.  If it was in C, gcc might
or might not create a stack frame for it, which would affect the number
of levels we have to skip.

With this, we see results from perf record -e lock:lock_acquire like
this:

 # Samples: 24878
 #
 # Overhead         Command      Shared Object  Symbol
 # ........  ..............  .................  ......
 #
    14.99%            perf  [kernel.kallsyms]  [k] ._raw_spin_lock
                      |
                      --- ._raw_spin_lock
                         |
                         |--25.00%-- .alloc_fd
                         |          (nil)
                         |          |
                         |          |--50.00%-- .anon_inode_getfd
                         |          |          .sys_perf_event_open
                         |          |          syscall_exit
                         |          |          syscall
                         |          |          create_counter
                         |          |          __cmd_record
                         |          |          run_builtin
                         |          |          main
                         |          |          0xfd2e704
                         |          |          0xfd2e8c0
                         |          |          (nil)

... etc.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: anton@samba.org
Cc: linuxppc-dev@ozlabs.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100318050513.GA6575@drongo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/include/asm/asm-compat.h |    2 ++
 arch/powerpc/kernel/misc.S            |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/asm-compat.h b/arch/powerpc/include/asm/asm-compat.h
index c1b475a..a9b91ed 100644
--- a/arch/powerpc/include/asm/asm-compat.h
+++ b/arch/powerpc/include/asm/asm-compat.h
@@ -28,6 +28,7 @@
 #define PPC_LLARX(t, a, b, eh)	PPC_LDARX(t, a, b, eh)
 #define PPC_STLCX	stringify_in_c(stdcx.)
 #define PPC_CNTLZL	stringify_in_c(cntlzd)
+#define PPC_LR_STKOFF	16
 
 /* Move to CR, single-entry optimized version. Only available
  * on POWER4 and later.
@@ -51,6 +52,7 @@
 #define PPC_STLCX	stringify_in_c(stwcx.)
 #define PPC_CNTLZL	stringify_in_c(cntlzw)
 #define PPC_MTOCRF	stringify_in_c(mtcrf)
+#define PPC_LR_STKOFF	4
 
 #endif
 
diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
index 2d29752..b485a87 100644
--- a/arch/powerpc/kernel/misc.S
+++ b/arch/powerpc/kernel/misc.S
@@ -127,3 +127,31 @@ _GLOBAL(__setup_cpu_power7)
 _GLOBAL(__restore_cpu_power7)
 	/* place holder */
 	blr
+
+#ifdef CONFIG_EVENT_TRACING
+/*
+ * Get a minimal set of registers for our caller's nth caller.
+ * r3 = regs pointer, r5 = n.
+ *
+ * We only get R1 (stack pointer), NIP (next instruction pointer)
+ * and LR (link register).  These are all we can get in the
+ * general case without doing complicated stack unwinding, but
+ * fortunately they are enough to do a stack backtrace, which
+ * is all we need them for.
+ */
+_GLOBAL(perf_arch_fetch_caller_regs)
+	mr	r6,r1
+	cmpwi	r5,0
+	mflr	r4
+	ble	2f
+	mtctr	r5
+1:	PPC_LL	r6,0(r6)
+	bdnz	1b
+	PPC_LL	r4,PPC_LR_STKOFF(r6)
+2:	PPC_LL	r7,0(r6)
+	PPC_LL	r7,PPC_LR_STKOFF(r7)
+	PPC_STL	r6,GPR1-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
+	blr
+#endif /* CONFIG_EVENT_TRACING */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0CRFFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 01:05:23 -0400
Received: from ozlabs.org ([203.10.76.45]:41510 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0CRFFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 01:05:22 -0400
Date: Thu, 18 Mar 2010 16:05:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, linuxppc-dev@ozlabs.org
Subject: [PATCH v2] powerpc/perf_events: Implement
 perf_arch_fetch_caller_regs
Message-ID: <20100318050513.GA6575@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a powerpc version of perf_arch_fetch_caller_regs.
It's implemented in assembly because that way we can be sure there
isn't a stack frame for perf_arch_fetch_caller_regs.  If it was in
C, gcc might or might not create a stack frame for it, which would
affect the number of levels we have to skip.

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
---
 arch/powerpc/include/asm/asm-compat.h |    2 ++
 arch/powerpc/kernel/misc.S            |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

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

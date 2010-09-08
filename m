Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0IHSmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:42:42 -0400
Received: from king.tilera.com ([72.1.168.226]:43246 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0IHSma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:42:30 -0400
Message-Id: <201009081842.o88IgTRl028005@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 8 Sep 2010 13:43:25 -0400
Subject: [PATCH] arch/tile: Change struct sigcontext to be more useful
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 08 Sep 2010 18:42:29.0759 (UTC) FILETIME=[974928F0:01CB4F85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than just using pt_regs, it now contains the actual saved
state explicitly, similar to pt_regs.  By doing it this way, we
provide a cleaner API for userspace (or equivalently, we avoid the
need for libc to provide its own definition of sigcontext).

While we're at it, move PT_FLAGS_xxx to where they are not visible
from userspace.  And always pass siginfo and mcontext to signal
handlers, even if they claim they don't need it, since sometimes
they actually try to use it anyway in practice.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/ptrace.h     |   15 ++++++---------
 arch/tile/include/asm/sigcontext.h |   18 +++++++++++++-----
 arch/tile/include/asm/signal.h     |    1 +
 arch/tile/kernel/signal.c          |   27 +++++++++++++++------------
 arch/tile/kernel/stack.c           |    2 +-
 5 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index acdae81..4a02bb0 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -51,10 +51,7 @@ typedef uint_reg_t pt_reg_t;
 
 /*
  * This struct defines the way the registers are stored on the stack during a
- * system call/exception.  It should be a multiple of 8 bytes to preserve
- * normal stack alignment rules.
- *
- * Must track <sys/ucontext.h> and <sys/procfs.h>
+ * system call or exception.  "struct sigcontext" has the same shape.
  */
 struct pt_regs {
 	/* Saved main processor registers; 56..63 are special. */
@@ -80,11 +77,6 @@ struct pt_regs {
 
 #endif /* __ASSEMBLY__ */
 
-/* Flag bits in pt_regs.flags */
-#define PT_FLAGS_DISABLE_IRQ    1  /* on return to kernel, disable irqs */
-#define PT_FLAGS_CALLER_SAVES   2  /* caller-save registers are valid */
-#define PT_FLAGS_RESTORE_REGS   4  /* restore callee-save regs on return */
-
 #define PTRACE_GETREGS		12
 #define PTRACE_SETREGS		13
 #define PTRACE_GETFPREGS	14
@@ -101,6 +93,11 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
+/* Flag bits in pt_regs.flags */
+#define PT_FLAGS_DISABLE_IRQ    1  /* on return to kernel, disable irqs */
+#define PT_FLAGS_CALLER_SAVES   2  /* caller-save registers are valid */
+#define PT_FLAGS_RESTORE_REGS   4  /* restore callee-save regs on return */
+
 #ifndef __ASSEMBLY__
 
 #define instruction_pointer(regs) ((regs)->pc)
diff --git a/arch/tile/include/asm/sigcontext.h b/arch/tile/include/asm/sigcontext.h
index 7cd7672..5e2d033 100644
--- a/arch/tile/include/asm/sigcontext.h
+++ b/arch/tile/include/asm/sigcontext.h
@@ -15,13 +15,21 @@
 #ifndef _ASM_TILE_SIGCONTEXT_H
 #define _ASM_TILE_SIGCONTEXT_H
 
-/* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
-#include <asm/ptrace.h>
-
-/* Must track <sys/ucontext.h> */
+#include <arch/abi.h>
 
+/*
+ * struct sigcontext has the same shape as struct pt_regs,
+ * but is simplified since we know the fault is from userspace.
+ */
 struct sigcontext {
-	struct pt_regs regs;
+	uint_reg_t gregs[53];	/* General-purpose registers.  */
+	uint_reg_t tp;		/* Aliases gregs[TREG_TP].  */
+	uint_reg_t sp;		/* Aliases gregs[TREG_SP].  */
+	uint_reg_t lr;		/* Aliases gregs[TREG_LR].  */
+	uint_reg_t pc;		/* Program counter.  */
+	uint_reg_t ics;		/* In Interrupt Critical Section?  */
+	uint_reg_t faultnum;	/* Fault number.  */
+	uint_reg_t pad[5];
 };
 
 #endif /* _ASM_TILE_SIGCONTEXT_H */
diff --git a/arch/tile/include/asm/signal.h b/arch/tile/include/asm/signal.h
index eb0253f..c1ee1d6 100644
--- a/arch/tile/include/asm/signal.h
+++ b/arch/tile/include/asm/signal.h
@@ -24,6 +24,7 @@
 #include <asm-generic/signal.h>
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+struct pt_regs;
 int restore_sigcontext(struct pt_regs *, struct sigcontext __user *, long *);
 int setup_sigcontext(struct sigcontext __user *, struct pt_regs *);
 void do_signal(struct pt_regs *regs);
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index d0fd94f..fb28e85 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -61,13 +61,19 @@ int restore_sigcontext(struct pt_regs *regs,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+	/*
+	 * Enforce that sigcontext is like pt_regs, and doesn't mess
+	 * up our stack alignment rules.
+	 */
+	BUILD_BUG_ON(sizeof(struct sigcontext) != sizeof(struct pt_regs));
+	BUILD_BUG_ON(sizeof(struct sigcontext) % 8 != 0);
+
 	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
-		err |= __get_user(((long *)regs)[i],
-				  &((long __user *)(&sc->regs))[i]);
+		err |= __get_user(regs->regs[i], &sc->gregs[i]);
 
 	regs->faultnum = INT_SWINT_1_SIGRETURN;
 
-	err |= __get_user(*pr0, &sc->regs.regs[0]);
+	err |= __get_user(*pr0, &sc->gregs[0]);
 	return err;
 }
 
@@ -112,8 +118,7 @@ int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
 	int i, err = 0;
 
 	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
-		err |= __put_user(((long *)regs)[i],
-				  &((long __user *)(&sc->regs))[i]);
+		err |= __put_user(regs->regs[i], &sc->gregs[i]);
 
 	return err;
 }
@@ -203,19 +208,17 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * Set up registers for signal handler.
 	 * Registers that we don't modify keep the value they had from
 	 * user-space at the time we took the signal.
+	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
+	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
 	regs->pc = (unsigned long) ka->sa.sa_handler;
 	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp = (unsigned long) frame;
 	regs->lr = restorer;
 	regs->regs[0] = (unsigned long) usig;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		/* Need extra arguments, so mark to restore caller-saves. */
-		regs->regs[1] = (unsigned long) &frame->info;
-		regs->regs[2] = (unsigned long) &frame->uc;
-		regs->flags |= PT_FLAGS_CALLER_SAVES;
-	}
+	regs->regs[1] = (unsigned long) &frame->info;
+	regs->regs[2] = (unsigned long) &frame->uc;
+	regs->flags |= PT_FLAGS_CALLER_SAVES;
 
 	/*
 	 * Notify any tracer that was single-stepping it.
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 38a68b0..ea2e0ce 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -175,7 +175,7 @@ static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt)
 			pr_err("  <received signal %d>\n",
 			       frame->info.si_signo);
 		}
-		return &frame->uc.uc_mcontext.regs;
+		return (struct pt_regs *)&frame->uc.uc_mcontext;
 	}
 	return NULL;
 }
-- 
1.6.5.2


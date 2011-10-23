Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1JWKVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:21:44 -0400
Received: from mail.southpole.se ([193.12.106.18]:34915 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab1JWKUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:20:24 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>, linux-mips@linux-mips.org
Subject: [PATCH RFC 4/8] mips: implement syscall restart generically
Date: Sun, 23 Oct 2011 12:19:58 +0200
Message-Id: <04ce50ed7e9e9a949a3c0b447c3aec0a8c6face4.1319364492.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
In-Reply-To: <cover.1319364492.git.jonas@southpole.se>
References: <cover.1319364492.git.jonas@southpole.se>
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 65222-08643
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Manipulating task state to effect re-execution of an interrupted syscall
used to be purely architecture specific code.  However, as most arch's
were essentially just making minor adjustments to almost identical logic,
this code could be moved to a common implementation.

The generic variant introduces the function handle_syscall_restart() to be
called after get_signal_to_deliver().  The architecture specific register
manipulations required to effect the actual restart are now implemented
in the generic syscall interface found in asm/syscall.h

This patch transitions this architecture's signal handling code over to
using the generic syscall restart code by:

i)  Implementing the register manipulations in asm/syscall.h
ii) Replacing the restart logic with a call to handle_syscall_restart

Cc: linux-mips@linux-mips.org
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/mips/include/asm/syscall.h |   91 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/signal.c       |   40 +----------------
 2 files changed, 94 insertions(+), 37 deletions(-)
 create mode 100644 arch/mips/include/asm/syscall.h

diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
new file mode 100644
index 0000000..7280d95
--- /dev/null
+++ b/arch/mips/include/asm/syscall.h
@@ -0,0 +1,91 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Copyright (C) 2011 Jonas Bonn <jonas@southpole.se>
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H
+
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <asm/unistd.h>
+
+static inline int
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->regs[0] ?: -1;
+}
+
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->regs[2] = regs->regs[0];
+	regs->regs[7] = regs->regs[26];
+}
+
+static inline void
+syscall_clear(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->regs[0] = 0;
+}
+
+static inline void
+syscall_restart(struct task_struct *task, struct pt_regs *regs)
+{
+	syscall_rollback(task, regs);
+	regs->cp0_epc -= 4;
+}
+
+static inline void
+syscall_do_restartblock(struct task_struct *task, struct pt_regs *regs)
+{
+	regs->regs[2] = current->thread.abi->restart;
+	regs->regs[7] = regs->regs[26];
+	regs->cp0_epc -= 4;
+}
+
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+{
+	/*
+	 * r7 == 1 if syscall returns error
+	 * r2 contains _positive_ result
+	 */
+	if (regs->regs[7])
+		return -regs->regs[2];
+	else
+		return 0;
+}
+
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->gpr[2];
+}
+
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+			 int error, long val)
+{
+	regs->gpr[2] = (long) error ? -error : val;
+}
+
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned int i, unsigned int n, unsigned long *args)
+{
+	/* TODO */
+}
+
+static inline void
+syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned int i, unsigned int n, const unsigned long *args)
+{
+	/* TODO */
+}
+
+#endif
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index dbbe0ce..13f2864 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -547,27 +547,6 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	struct mips_abi *abi = current->thread.abi;
 	void *vdso = current->mm->context.vdso;
 
-	if (regs->regs[0]) {
-		switch(regs->regs[2]) {
-		case ERESTART_RESTARTBLOCK:
-		case ERESTARTNOHAND:
-			regs->regs[2] = EINTR;
-			break;
-		case ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
-				regs->regs[2] = EINTR;
-				break;
-			}
-		/* fallthrough */
-		case ERESTARTNOINTR:
-			regs->regs[7] = regs->regs[26];
-			regs->regs[2] = regs->regs[0];
-			regs->cp0_epc -= 4;
-		}
-
-		regs->regs[0] = 0;		/* Don't deal with this again.  */
-	}
-
 	if (sig_uses_siginfo(ka))
 		ret = abi->setup_rt_frame(vdso + abi->rt_signal_return_offset,
 					  ka, regs, sig, oldset, info);
@@ -609,6 +588,9 @@ static void do_signal(struct pt_regs *regs)
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	handle_syscall_restart(regs, &ka, (signr > 0));
+
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
@@ -625,22 +607,6 @@ static void do_signal(struct pt_regs *regs)
 		return;
 	}
 
-	if (regs->regs[0]) {
-		if (regs->regs[2] == ERESTARTNOHAND ||
-		    regs->regs[2] == ERESTARTSYS ||
-		    regs->regs[2] == ERESTARTNOINTR) {
-			regs->regs[2] = regs->regs[0];
-			regs->regs[7] = regs->regs[26];
-			regs->cp0_epc -= 4;
-		}
-		if (regs->regs[2] == ERESTART_RESTARTBLOCK) {
-			regs->regs[2] = current->thread.abi->restart;
-			regs->regs[7] = regs->regs[26];
-			regs->cp0_epc -= 4;
-		}
-		regs->regs[0] = 0;	/* Don't deal with this again.  */
-	}
-
 	/*
 	 * If there's no signal to deliver, we just put the saved sigmask
 	 * back
-- 
1.7.5.4


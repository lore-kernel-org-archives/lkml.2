Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1CBRRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:17:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61221 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab1CBRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nli8zYIt1Yuh1tYNZzX1PHOsELYCwbOCiTqs5XHbt/e9fPMjjg5nq1S61VQWVrWLDy
         sNBeMAzz2qyvooIW4SaWQBFkYovg7GhexVT6jR3hC6SC65c4a4UxV0A5LgjDkT9D63fw
         c/c9RdaezBglG1d3x3OFsRAgxunvqdsBcHWcU=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] x86: correct stack dump info when CONFIG_FRAME_POINTER=y
Date: Thu,  3 Mar 2011 02:17:12 +0900
Message-Id: <1299086232-29639-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current stack dump code scans entire stack and check each entry
contains a pointer to kernel code. If CONFIG_FRAME_POINTER=y it
could mark whether the pointer is valid or not based on value of
the frame pointer. A invalid entry could be preceded by '?' sign.

However this was not going to happen because scan start point was
always higher than the frame pointer so that they could not meet.
So all of the entries were marked invalid.

This patch fixes this by winding up the frame pointer to desired
stack frame. End result looks like below.

before:
[    3.508329] Call Trace:
[    3.508551]  [<ffffffff814f35c9>] ? panic+0x91/0x199
[    3.508662]  [<ffffffff814f3739>] ? printk+0x68/0x6a
[    3.508770]  [<ffffffff81a981b2>] ? mount_block_root+0x257/0x26e
[    3.508876]  [<ffffffff81a9821f>] ? mount_root+0x56/0x5a
[    3.508975]  [<ffffffff81a98393>] ? prepare_namespace+0x170/0x1a9
[    3.509216]  [<ffffffff81a9772b>] ? kernel_init+0x1d2/0x1e2
[    3.509335]  [<ffffffff81003894>] ? kernel_thread_helper+0x4/0x10
[    3.509442]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
[    3.509542]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
[    3.509641]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

after:
[    3.522991] Call Trace:
[    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
[    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
[    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
[    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
[    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
[    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
[    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
[    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
[    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/include/asm/stacktrace.h |   24 +++++++++++++++---------
 arch/x86/kernel/dumpstack_32.c    |    2 +-
 arch/x86/kernel/dumpstack_64.c    |    2 +-
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 52b5c7ed3608..7fef7b27418c 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -60,25 +60,31 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 
 #ifdef CONFIG_FRAME_POINTER
 static inline unsigned long
-stack_frame(struct task_struct *task, struct pt_regs *regs)
+stack_frame(struct task_struct *task, struct pt_regs *regs,
+	    unsigned long *stack)
 {
 	unsigned long bp;
 
-	if (regs)
-		return regs->bp;
-
-	if (task == current) {
+	if (regs) {
+		bp = regs->bp;
+	} else if (task == current) {
 		/* Grab bp right from our regs */
 		get_bp(bp);
-		return bp;
+	} else {
+		/* bp is the last reg pushed by switch_to */
+		bp = *(unsigned long *)task->thread.sp;
 	}
 
-	/* bp is the last reg pushed by switch_to */
-	return *(unsigned long *)task->thread.sp;
+	/* wind up to desired stack frame */
+	while (bp < (unsigned long) stack)
+		bp = *(unsigned long *) bp;
+
+	return bp;
 }
 #else
 static inline unsigned long
-stack_frame(struct task_struct *task, struct pt_regs *regs)
+stack_frame(struct task_struct *task, struct pt_regs *regs,
+	    unsigned long *stack)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 74cc1eda384b..b0b96dc11d00 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -35,7 +35,7 @@ void dump_trace(struct task_struct *task,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-	bp = stack_frame(task, regs);
+	bp = stack_frame(task, regs, stack);
 	for (;;) {
 		struct thread_info *context;
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a6b6fcf7f0ae..19a36deb8db8 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -161,7 +161,7 @@ void dump_trace(struct task_struct *task,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-	bp = stack_frame(task, regs);
+	bp = stack_frame(task, regs, stack);
 	/*
 	 * Print function call entries in all stacks, starting at the
 	 * current stack address. If the stacks consist of nested
-- 
1.7.4


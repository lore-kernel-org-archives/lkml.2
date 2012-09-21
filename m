Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2IUQ1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:27:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab2IUQ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:26:57 -0400
From: Mark Salter <msalter@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 1/3] c6x: add ret_from_kernel_thread(), simplify kernel_thread()
Date: Fri, 21 Sep 2012 12:26:37 -0400
Message-Id: <1348244799-16013-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1348244799-16013-1-git-send-email-msalter@redhat.com>
References: <20120917032651.GU13973@ZenIV.linux.org.uk>
 <1348244799-16013-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/kernel/entry.S   |   20 ++++++++++++++++++++
 arch/c6x/kernel/process.c |   38 ++++++++++++--------------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
index 30b37e5..6e6bd9d 100644
--- a/arch/c6x/kernel/entry.S
+++ b/arch/c6x/kernel/entry.S
@@ -400,6 +400,26 @@ ret_from_fork_2:
 	STW	.D2T2	B0,*+SP(REGS_A4+8)
 ENDPROC(ret_from_fork)
 
+ENTRY(ret_from_kernel_thread)
+#ifdef CONFIG_C6X_BIG_KERNEL
+	MVKL	.S1	schedule_tail,A0
+	MVKH	.S1	schedule_tail,A0
+	B	.S2X	A0
+#else
+	B	.S2	schedule_tail
+#endif
+	LDW	.D2T2	*+SP(REGS_A0+8),B10 /* get fn  */
+	ADDKPC	.S2	0f,B3,3
+0:
+	B	.S2	B10		   /* call fn */
+	LDW	.D2T1	*+SP(REGS_A1+8),A4 /* get arg */
+	MVKL	.S2	sys_exit,B11
+	MVKH	.S2	sys_exit,B11
+	ADDKPC	.S2	0f,B3,1
+0:
+	BNOP	.S2	B11,5	/* jump to sys_exit */
+ENDPROC(ret_from_kernel_thread)
+
 	;;
 	;; These are the interrupt handlers, responsible for calling __do_IRQ()
 	;; int6 is used for syscalls (see _system_call entry)
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 45e924a..d2ffc9b 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -25,6 +25,7 @@ void	(*c6x_restart)(void);
 void	(*c6x_halt)(void);
 
 extern asmlinkage void ret_from_fork(void);
+extern asmlinkage void ret_from_kernel_thread(void);
 
 /*
  * power off function, if any
@@ -103,36 +104,21 @@ void machine_power_off(void)
 	halt_loop();
 }
 
-static void kernel_thread_helper(int dummy, void *arg, int (*fn)(void *))
-{
-	do_exit(fn(arg));
-}
-
 /*
  * Create a kernel thread
  */
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
-	struct pt_regs regs;
-
-	/*
-	 * copy_thread sets a4 to zero (child return from fork)
-	 * so we can't just set things up to directly return to
-	 * fn.
-	 */
-	memset(&regs, 0, sizeof(regs));
-	regs.b4 = (unsigned long) arg;
-	regs.a6 = (unsigned long) fn;
-	regs.pc = (unsigned long) kernel_thread_helper;
-	local_save_flags(regs.csr);
-	regs.csr |= 1;
-	regs.tsr = 5; /* Set GEE and GIE in TSR */
+	struct pt_regs regs = {
+		.a0 = (unsigned long)fn,
+		.a1 = (unsigned long)arg,
+		.tsr = 0, /* kernel mode */
+	};
 
 	/* Ok, create the new process.. */
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, -1, &regs,
 		       0, NULL, NULL);
 }
-EXPORT_SYMBOL(kernel_thread);
 
 void flush_thread(void)
 {
@@ -192,21 +178,21 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	childregs = task_pt_regs(p);
 
 	*childregs = *regs;
-	childregs->a4 = 0;
 
-	if (usp == -1)
+	if (usp == -1) {
 		/* case of  __kernel_thread: we return to supervisor space */
 		childregs->sp = (unsigned long)(childregs + 1);
-	else
+		p->thread.pc = (unsigned long) ret_from_kernel_thread;
+	} else {
 		/* Otherwise use the given stack */
 		childregs->sp = usp;
+		p->thread.pc = (unsigned long) ret_from_fork;
+	}
 
 	/* Set usp/ksp */
 	p->thread.usp = childregs->sp;
-	/* switch_to uses stack to save/restore 14 callee-saved regs */
 	thread_saved_ksp(p) = (unsigned long)childregs - 8;
-	p->thread.pc = (unsigned int) ret_from_fork;
-	p->thread.wchan	= (unsigned long) ret_from_fork;
+	p->thread.wchan	= p->thread.pc;
 #ifdef __DSBT__
 	{
 		unsigned long dp;
-- 
1.7.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2KGJtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:49:43 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:58068 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2KGJtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:49:02 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 29/31] ARC: switch to generic kernel_thread()
Date: Wed,  7 Nov 2012 10:47:52 +0100
Message-Id: <1352281674-2186-30-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig          |    1 +
 arch/arc/kernel/process.c |   29 +++++++++--------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index d6983afa..f3aacfc 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -17,6 +17,7 @@ config ARC
 	select GENERIC_FIND_FIRST_BIT
 	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index fee3e11..d2bb27f 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -142,22 +142,6 @@ void cpu_idle(void)
 	}
 }
 
-int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs = {
-		.r0 = (unsigned long)arg,
-		.r1 = (unsigned long)fn
-	};
-
-	regs.status32 = read_aux_reg(0xa);
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL,
-		       NULL);
-
-}
-EXPORT_SYMBOL(kernel_thread);
-
 asmlinkage void ret_from_fork(void);
 asmlinkage void ret_from_kernel_thread(void) __attribute__((noreturn));
 
@@ -192,7 +176,7 @@ asmlinkage void ret_from_kernel_thread(void) __attribute__((noreturn));
  * ------------------  <===== END of PAGE
  */
 int copy_thread(unsigned long clone_flags,
-		unsigned long usp, unsigned long topstk,
+		unsigned long usp, unsigned long arg,
 		struct task_struct *p, struct pt_regs *regs)
 {
 	struct pt_regs *c_regs;        /* child's pt_regs */
@@ -213,10 +197,12 @@ int copy_thread(unsigned long clone_flags,
 	 */
 	p->thread.ksp = (unsigned long)c_callee;	/* THREAD_KSP */
 
-	/* Copy parents pt regs on child's kernel mode stack */
-	*c_regs = *regs;
+	if (unlikely(p->flags & PF_KTHREAD)) {
+		memset(c_regs, 0, sizeof(struct pt_regs));
+		c_regs->r0 = arg; /* argument to kernel thread */
+		c_regs->r1 = usp;  /* function */
+		c_regs->status32 = read_aux_reg(0xa);
 
-	if (!(user_mode(regs))) {
 		c_regs->sp =
 		    (unsigned long)task_thread_info(p) + (THREAD_SIZE - 4);
 
@@ -232,6 +218,9 @@ int copy_thread(unsigned long clone_flags,
 	childksp[0] = 0;				/* for POP fp */
 	childksp[1] = (unsigned long)ret_from_fork;	/* for POP blink */
 
+	/* Copy parents pt regs on child's kernel mode stack */
+	*c_regs = *regs;
+
 	c_regs->sp = usp;
 	c_regs->r0 = 0;		/* fork returns 0 in child */
 
-- 
1.7.4.1


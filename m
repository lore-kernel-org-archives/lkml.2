Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2KGJ5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:57:47 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:40405 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2KGJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:57:35 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 28/31] ARC: split ret_from_fork, simplify kernel_thread()
Date: Wed,  7 Nov 2012 10:47:51 +0100
Message-Id: <1352281674-2186-29-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/entry.S   |    8 ++++++++
 arch/arc/kernel/process.c |   32 +++++++++++++-------------------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index fe9a17c..46d0280 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -580,6 +580,14 @@ ARC_ENTRY ret_from_fork
 	b @ret_from_exception
 ARC_EXIT ret_from_fork
 
+ARC_ENTRY ret_from_kernel_thread
+	bl  @schedule_tail
+	ld  r1, [sp, PT_r1]
+	j.d [r1]
+	ld  r0, [sp, PT_r0]
+	j   @sys_exit
+ARC_EXIT ret_from_kernel_thread
+
 ;################### Special Sys Call Wrappers ##########################
 
 ARC_ENTRY sys_execve_wrapper
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index c116fa5..fee3e11 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -142,24 +142,13 @@ void cpu_idle(void)
 	}
 }
 
-void kernel_thread_helper(void)
-{
-	__asm__ __volatile__(
-		"mov   r0, r2	\n\t"
-		"mov   r1, r3	\n\t"
-		"j     [r1]	\n\t");
-}
-
 int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
 {
-	struct pt_regs regs;
+	struct pt_regs regs = {
+		.r0 = (unsigned long)arg,
+		.r1 = (unsigned long)fn
+	};
 
-	memset(&regs, 0, sizeof(regs));
-
-	regs.r2 = (unsigned long)arg;
-	regs.r3 = (unsigned long)fn;
-	regs.blink = (unsigned long)do_exit;
-	regs.ret = (unsigned long)kernel_thread_helper;
 	regs.status32 = read_aux_reg(0xa);
 
 	/* Ok, create the new process.. */
@@ -170,6 +159,7 @@ int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
 EXPORT_SYMBOL(kernel_thread);
 
 asmlinkage void ret_from_fork(void);
+asmlinkage void ret_from_kernel_thread(void) __attribute__((noreturn));
 
 /* Layout of Child kernel mode stack as setup at the end of this function is
  *
@@ -226,18 +216,22 @@ int copy_thread(unsigned long clone_flags,
 	/* Copy parents pt regs on child's kernel mode stack */
 	*c_regs = *regs;
 
-	/* __switch_to expects FP(0), BLINK(return addr) at top of stack */
-	childksp[0] = 0;				/* for POP fp */
-	childksp[1] = (unsigned long)ret_from_fork;	/* for POP blink */
-
 	if (!(user_mode(regs))) {
 		c_regs->sp =
 		    (unsigned long)task_thread_info(p) + (THREAD_SIZE - 4);
+
+		/* __switch_to expects FP(0), BLINK(return addr) at top */
+		childksp[0] = 0;			/* fp */
+		childksp[1] = (unsigned long)ret_from_kernel_thread; /* blink */
 		return 0;
 	}
 
 	/*--------- User Task Only --------------*/
 
+	/* __switch_to expects FP(0), BLINK(return addr) at top of stack */
+	childksp[0] = 0;				/* for POP fp */
+	childksp[1] = (unsigned long)ret_from_fork;	/* for POP blink */
+
 	c_regs->sp = usp;
 	c_regs->r0 = 0;		/* fork returns 0 in child */
 
-- 
1.7.4.1


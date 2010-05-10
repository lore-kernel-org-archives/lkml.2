Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab0EJO1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:27:44 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62643 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0EJO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n1h+Mce2e4aXnN5UV7wOzyA44IWXVQ/54d8CzyTzvJbH5yHtZgXjBKOtbGoKyUYdI8
         TWy8w0MwhPDovIXL3PSQXRavXzabnH42r6oGR94PTHISx66/8KO7FNX9Qzk/6EeAuJuv
         3LoyRUR1yuKlcw7uIJo727DRWee/LTWD/krVg=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Date: Mon, 10 May 2010 22:27:15 +0800
Message-Id: <1273501635-28403-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch fixes the 'unannotated irqs-on' lockdep warning below:

	CPU: Testing write buffer coherency: ok
	------------[ cut here ]------------
	WARNING: at kernel/lockdep.c:3145 check_flags+0xcc/0x1dc()
	Modules linked in:
	[<c0035120>] (unwind_backtrace+0x0/0xf8) from [<c0355374>] (dump_stack+0x20/0x24)
	[<c0355374>] (dump_stack+0x20/0x24) from [<c0060c04>] (warn_slowpath_common+0x58/0x70)
	[<c0060c04>] (warn_slowpath_common+0x58/0x70) from [<c0060c3c>] (warn_slowpath_null+0x20/0x24)
	[<c0060c3c>] (warn_slowpath_null+0x20/0x24) from [<c008f224>] (check_flags+0xcc/0x1dc)
	[<c008f224>] (check_flags+0xcc/0x1dc) from [<c00945dc>] (lock_acquire+0x50/0x140)
	[<c00945dc>] (lock_acquire+0x50/0x140) from [<c0358434>] (_raw_spin_lock+0x50/0x88)
	[<c0358434>] (_raw_spin_lock+0x50/0x88) from [<c00fd114>] (set_task_comm+0x2c/0x60)
	[<c00fd114>] (set_task_comm+0x2c/0x60) from [<c007e184>] (kthreadd+0x30/0x108)
	[<c007e184>] (kthreadd+0x30/0x108) from [<c0030104>] (kernel_thread_exit+0x0/0x8)
	---[ end trace 1b75b31a2719ed1c ]---
	possible reason: unannotated irqs-on.
	irq event stamp: 3
	hardirqs last  enabled at (2): [<c0059bb0>] finish_task_switch+0x48/0xb0
	hardirqs last disabled at (3): [<c002f0b0>] ret_slow_syscall+0xc/0x1c
	softirqs last  enabled at (0): [<c005f3e0>] copy_process+0x394/0xe5c
	softirqs last disabled at (0): [<(null)>] (null)

This patch introduces macro of trace_ret_hardirqs_on, which will
call trace_hardirqs_on if I flag in the stored CPSR is zero.

In the path of returning to user-space, the patch replaces disable_irq
with disable_irq_notrace in ret_to_user to avoid the 'unannotated irqs-on'
lockdep warning since hardirqs is always enabled before returning to user.

In the path of returning to kernel-space, the patch still replaces
disable_irq with disable_irq_notrace in __xxx_svc handler and adds
trace_hardirqs_on before calling svc_exit to trace the possible hardirqs on
event for avoiding the possible 'unannotated irqs-on' lockdep warning.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/kernel/entry-armv.S   |   31 +++++++++++++++++--------------
 arch/arm/kernel/entry-common.S |    2 +-
 arch/arm/kernel/entry-header.S |    7 +++++++
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index e6a0fb0..7202adf 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -204,13 +204,15 @@ __dabt_svc:
 	@
 	@ IRQs off again before pulling preserved data off the stack
 	@
-	disable_irq
+	disable_irq_notrace
 
 	@
 	@ restore SPSR and restart the instruction
+	@ trace possible hardirqs on event before returning
 	@
-	ldr	r2, [sp, #S_PSR]
-	svc_exit r2				@ return from exception
+	ldr	r4, [sp, #S_PSR]
+	trace_ret_hardirqs_on r4
+	svc_exit r4				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__dabt_svc)
 
@@ -235,10 +237,7 @@ __irq_svc:
 	blne	svc_preempt
 #endif
 	ldr	r4, [sp, #S_PSR]		@ irqs are already disabled
-#ifdef CONFIG_TRACE_IRQFLAGS
-	tst	r4, #PSR_I_BIT
-	bleq	trace_hardirqs_on
-#endif
+	trace_ret_hardirqs_on r4
 	svc_exit r4				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__irq_svc)
@@ -291,13 +290,15 @@ __und_svc:
 	@
 	@ IRQs off again before pulling preserved data off the stack
 	@
-1:	disable_irq
+1:	disable_irq_notrace
 
 	@
 	@ restore SPSR and restart the instruction
+	@ trace possible hardirqs on event before returning
 	@
-	ldr	r2, [sp, #S_PSR]		@ Get SVC cpsr
-	svc_exit r2				@ return from exception
+	ldr	r4, [sp, #S_PSR]		@ Get SVC cpsr
+	trace_ret_hardirqs_on r4
+	svc_exit r4				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__und_svc)
 
@@ -327,13 +328,15 @@ __pabt_svc:
 	@
 	@ IRQs off again before pulling preserved data off the stack
 	@
-	disable_irq
+	disable_irq_notrace
 
 	@
 	@ restore SPSR and restart the instruction
-	@
-	ldr	r2, [sp, #S_PSR]
-	svc_exit r2				@ return from exception
+	@ trace possible hardirqs on event before returning
+	@	
+	ldr	r4, [sp, #S_PSR]
+	trace_ret_hardirqs_on r4
+	svc_exit r4				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__pabt_svc)
 
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 2c1db77..ed471a7 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -58,7 +58,7 @@ work_resched:
  */
 ENTRY(ret_to_user)
 ret_slow_syscall:
-	disable_irq				@ disable interrupts
+	disable_irq_notrace				@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]
 	tst	r1, #_TIF_WORK_MASK
 	bne	work_pending
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index d93f976..ac51ce3 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -30,6 +30,13 @@
 #error "Please fix"
 #endif
 
+	.macro trace_ret_hardirqs_on, rspsr
+#ifdef CONFIG_TRACE_IRQFLAGS
+	tst 	\rspsr, #PSR_I_BIT
+	bleq	trace_hardirqs_on
+#endif
+	.endm
+
 	.macro	zero_fp
 #ifdef CONFIG_FRAME_POINTER
 	mov	fp, #0
-- 
1.6.2.5


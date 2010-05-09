Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0EID4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 23:56:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45775 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0EID4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 23:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uI/mNejD8M/FfNKZj1MZfWX/IsKIVjl1FRTDdOygEl7kIaNXQha6lgSailfBu4EBEN
         CzoBo3yqcZpjBbwc01orBR6vZDfWe2A+Vo9cf5gJ18BXzuKxkj8gFY66f5Qg+0z3d5ho
         7g5ttJQ+M3hMgQFabW40kg9TmQBhT9DT8yX90=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ARM: fix inbalance of hardirqs trace before return to user or exception
Date: Sun,  9 May 2010 11:56:19 +0800
Message-Id: <1273377379-18078-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch introduces macro of trace_ret_hardirqs_on, which will
call asm_trace_hardirqs_on if I flag in the stored CPSR is zero.

The patch adds trace_ret_hardirqs_on before returning to user
or exception mode once disable_irq was called explicitly, which does
fix the inbalance of hardirqs trace and make lockdep happy. The patch
does fix this kind of lockdep warning below:

	PU: Testing write buffer coherency: ok
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
	devtmpfs: initialized

The patch refers to implementation on x86, suggested by Peter.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/kernel/entry-armv.S   |   14 ++++++++++----
 arch/arm/kernel/entry-common.S |    8 ++++++++
 arch/arm/kernel/entry-header.S |    9 +++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index e6a0fb0..47abf42 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -210,6 +210,13 @@ __dabt_svc:
 	@ restore SPSR and restart the instruction
 	@
 	ldr	r2, [sp, #S_PSR]
+
+	@
+	@trace hardirqs on if hardirq will be enabled before
+	@returning from exception
+	@
+	trace_ret_hardirqs_on r2
+
 	svc_exit r2				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__dabt_svc)
@@ -235,10 +242,7 @@ __irq_svc:
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
@@ -297,6 +301,7 @@ __und_svc:
 	@ restore SPSR and restart the instruction
 	@
 	ldr	r2, [sp, #S_PSR]		@ Get SVC cpsr
+	trace_ret_hardirqs_on r2
 	svc_exit r2				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__und_svc)
@@ -333,6 +338,7 @@ __pabt_svc:
 	@ restore SPSR and restart the instruction
 	@
 	ldr	r2, [sp, #S_PSR]
+	trace_ret_hardirqs_on r2
 	svc_exit r2				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__pabt_svc)
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 2c1db77..282576f 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -66,6 +66,14 @@ no_work_pending:
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
 
+	@
+	@trace hardirqs on if hardirq will be enabled before
+	@returning to user
+	@
+#ifdef CONFIG_TRACE_IRQFLAGS
+	ldr	r1, [sp, #S_PSR]	@ get calling cpsr
+	trace_ret_hardirqs_on r1
+#endif
 	restore_user_regs fast = 0, offset = 0
 ENDPROC(ret_to_user)
 
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index d93f976..85f4b5b 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -30,6 +30,15 @@
 #error "Please fix"
 #endif
 
+	.macro trace_ret_hardirqs_on, rspsr
+#ifdef CONFIG_TRACE_IRQFLAGS
+	tst 	\rspsr, #PSR_I_BIT
+	bne	1f
+	asm_trace_hardirqs_on
+1:
+#endif
+	.endm
+
 	.macro	zero_fp
 #ifdef CONFIG_FRAME_POINTER
 	mov	fp, #0
-- 
1.6.2.5


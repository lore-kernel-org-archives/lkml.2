Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab0EAOjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:39:20 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64393 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab0EAOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:33 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v21 087/100] powerpc: wire up checkpoint and restart syscalls
Date: Sat,  1 May 2010 10:16:09 -0400
Message-Id: <1272723382-19470-88-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Changelog [v21]:
 - Fix build break with CONFIG_CHECKPOINT=n
Changelog [v19]:
 - Checkpoint/powerpc: fix up checkpoint syscall, tidy restart

Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
---
 arch/powerpc/include/asm/systbl.h |    2 ++
 arch/powerpc/include/asm/unistd.h |    4 +++-
 arch/powerpc/kernel/checkpoint.c  |   18 ++++++++++++++++++
 arch/powerpc/kernel/entry_32.S    |   23 +++++++++++++++++++++++
 arch/powerpc/kernel/entry_64.S    |   16 ++++++++++++++++
 arch/powerpc/kernel/process.c     |    1 +
 6 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index f94fc43..b5afba3 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -327,3 +327,5 @@ COMPAT_SYS_SPU(preadv)
 COMPAT_SYS_SPU(pwritev)
 COMPAT_SYS(rt_tgsigqueueinfo)
 PPC_SYS(eclone)
+PPC_SYS(checkpoint)
+PPC_SYS(restart)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 4cdbd5c..54f6ecb 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -346,10 +346,12 @@
 #define __NR_pwritev		321
 #define __NR_rt_tgsigqueueinfo	322
 #define __NR_eclone		323
+#define __NR_checkpoint		324
+#define __NR_restart		325
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		324
+#define __NR_syscalls		326
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/kernel/checkpoint.c b/arch/powerpc/kernel/checkpoint.c
index 492c604..9aeab89 100644
--- a/arch/powerpc/kernel/checkpoint.c
+++ b/arch/powerpc/kernel/checkpoint.c
@@ -530,3 +530,21 @@ int restore_mm_context(struct ckpt_ctx *ctx, struct mm_struct *mm)
 {
 	return 0;
 }
+
+int sys_checkpoint(unsigned long pid, unsigned long fd, unsigned long flags,
+		   unsigned long logfd, unsigned long p5, unsigned long p6,
+		   struct pt_regs *regs)
+{
+	CHECK_FULL_REGS(regs);
+
+	return do_sys_checkpoint(pid, fd, flags, logfd);
+}
+
+int sys_restart(unsigned long pid, unsigned long fd, unsigned long flags,
+		unsigned long logfd, unsigned long p5, unsigned long p6,
+		struct pt_regs *regs)
+{
+	CHECK_FULL_REGS(regs);
+
+	return do_sys_restart(pid, fd, flags, logfd);
+}
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 579f1da..853814b 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -594,6 +594,29 @@ ppc_eclone:
 	stw	r0,_TRAP(r1)		/* register set saved */
 	b	sys_eclone
 
+/* To handle self-checkpoint we must save nvpgprs */
+	.globl	ppc_checkpoint
+ppc_checkpoint:
+	SAVE_NVGPRS(r1)
+	lwz	r0,_TRAP(r1)
+	rlwinm	r0,r0,0,0,30		/* clear LSB to indicate full */
+	stw	r0,_TRAP(r1)		/* register set saved */
+	b	sys_checkpoint
+
+/* The full register set must be restored upon return from restart.
+ * Save nvgprs unconditionally so the caller's state is
+ * restored correctly in case of error.
+ */
+	.globl	ppc_restart
+ppc_restart:
+	SAVE_NVGPRS(r1)
+	lwz	r0,_TRAP(r1)
+	rlwinm	r0,r0,0,0,30		/* clear LSB to indicate full */
+	stw	r0,_TRAP(r1)		/* register set saved */
+	bl	sys_restart
+	REST_NVGPRS(r1)
+	b ret_from_syscall
+
 	.globl	ppc_swapcontext
 ppc_swapcontext:
 	SAVE_NVGPRS(r1)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index b763340..228f592 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -349,6 +349,22 @@ _GLOBAL(ppc_eclone)
 	bl	.sys_eclone
 	b	syscall_exit
 
+/* To handle self-checkpoint we must save nvpgprs */
+_GLOBAL(ppc_checkpoint)
+	bl	.save_nvgprs
+	bl	.sys_checkpoint
+	b	syscall_exit
+
+/* The full register set must be restored upon return from restart.
+ * Save nvgprs unconditionally so the caller's state is
+ * restored correctly in case of error.
+ */
+_GLOBAL(ppc_restart)
+	bl	.save_nvgprs
+	bl	.sys_restart
+	REST_NVGPRS(r1)
+	b	syscall_exit
+
 _GLOBAL(ppc32_swapcontext)
 	bl	.save_nvgprs
 	bl	.compat_sys_swapcontext
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index b183287..1664586 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -30,6 +30,7 @@
 #include <linux/init_task.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/checkpoint.h>
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
 #include <linux/utsname.h>
-- 
1.6.3.3


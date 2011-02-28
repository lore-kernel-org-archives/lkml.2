Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1CAThY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:37:24 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab1CAThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:18 -0500
Message-Id: <201103011934.p21JYb4Q010297@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 13:08:32 -0500
Subject: [PATCH] arch/tile: bug fix: exec'ed task thought it was still single-stepping
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:37.0373 (UTC) FILETIME=[B35DAED0:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To handle single-step, tile mmap's a page of memory in the process
space for each thread and uses it to construct a version of the
instruction that we want to single step.  If the process exec's,
though, we lose that mapping, and the kernel needs to be aware that
it will need to recreate it if the exec'ed process than tries to
single-step as well.

Also correct some int32_t to s32 for better kernel style.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/ptrace.h |    3 +++
 arch/tile/kernel/process.c     |    4 ++++
 arch/tile/kernel/single_step.c |   21 +++++++++++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index ac6d343..6be2246 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -141,6 +141,9 @@ struct single_step_state {
 /* Single-step the instruction at regs->pc */
 extern void single_step_once(struct pt_regs *regs);
 
+/* Clean up after execve(). */
+extern void single_step_execve(void);
+
 struct task_struct;
 
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index e90eb53..5db8b5b 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -574,6 +574,8 @@ SYSCALL_DEFINE4(execve, const char __user *, path,
 		goto out;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
+	if (error == 0)
+		single_step_execve();
 out:
 	return error;
 }
@@ -593,6 +595,8 @@ long compat_sys_execve(const char __user *path,
 		goto out;
 	error = compat_do_execve(filename, argv, envp, regs);
 	putname(filename);
+	if (error == 0)
+		single_step_execve();
 out:
 	return error;
 }
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 1eb3b39..84a729e 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -56,7 +56,7 @@ enum mem_op {
 	MEMOP_STORE_POSTINCR
 };
 
-static inline tile_bundle_bits set_BrOff_X1(tile_bundle_bits n, int32_t offset)
+static inline tile_bundle_bits set_BrOff_X1(tile_bundle_bits n, s32 offset)
 {
 	tile_bundle_bits result;
 
@@ -254,6 +254,18 @@ P("\n");
 	return bundle;
 }
 
+/*
+ * Called after execve() has started the new image.  This allows us
+ * to reset the info state.  Note that the the mmap'ed memory, if there
+ * was any, has already been unmapped by the exec.
+ */
+void single_step_execve(void)
+{
+	struct thread_info *ti = current_thread_info();
+	kfree(ti->step_state);
+	ti->step_state = NULL;
+}
+
 /**
  * single_step_once() - entry point when single stepping has been triggered.
  * @regs: The machine register state
@@ -373,7 +385,7 @@ void single_step_once(struct pt_regs *regs)
 		/* branches */
 		case BRANCH_OPCODE_X1:
 		{
-			int32_t offset = signExtend17(get_BrOff_X1(bundle));
+			s32 offset = signExtend17(get_BrOff_X1(bundle));
 
 			/*
 			 * For branches, we use a rewriting trick to let the
@@ -731,4 +743,9 @@ void single_step_once(struct pt_regs *regs)
 	__insn_mtspr(SPR_SINGLE_STEP_EN_K_K, 1 << USER_PL);
 }
 
+void single_step_execve(void)
+{
+	/* Nothing */
+}
+
 #endif /* !__tilegx__ */
-- 
1.6.5.2


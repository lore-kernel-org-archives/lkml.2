Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2BVU5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:57:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50391 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2BVU5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:57:36 -0500
Date: Wed, 22 Feb 2012 12:57:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
cc: Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] i387: fix x86-64 preemption-unsafe user stack
 save/restore
In-Reply-To: <alpine.LFD.2.02.1202221256130.20522@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202221256450.20522@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221255150.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221256130.20522@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Feb 2012 09:15:04 -0800

[ Upstream commit 15d8791cae75dca27bfda8ecfe87dca9379d6bb0 ]

Commit 5b1cbac37798 ("i387: make irq_fpu_usable() tests more robust")
added a sanity check to the #NM handler to verify that we never cause
the "Device Not Available" exception in kernel mode.

However, that check actually pinpointed a (fundamental) race where we do
cause that exception as part of the signal stack FPU state save/restore
code.

Because we use the floating point instructions themselves to save and
restore state directly from user mode, we cannot do that atomically with
testing the TS_USEDFPU bit: the user mode access itself may cause a page
fault, which causes a task switch, which saves and restores the FP/MMX
state from the kernel buffers.

This kind of "recursive" FP state save is fine per se, but it means that
when the signal stack save/restore gets restarted, it will now take the
'#NM' exception we originally tried to avoid.  With preemption this can
happen even without the page fault - but because of the user access, we
cannot just disable preemption around the save/restore instruction.

There are various ways to solve this, including using the
"enable/disable_page_fault()" helpers to not allow page faults at all
during the sequence, and fall back to copying things by hand without the
use of the native FP state save/restore instructions.

However, the simplest thing to do is to just allow the #NM from kernel
space, but fix the race in setting and clearing CR0.TS that this all
exposed: the TS bit changes and the TS_USEDFPU bit absolutely have to be
atomic wrt scheduling, so while the actual state save/restore can be
interrupted and restarted, the act of actually clearing/setting CR0.TS
and the TS_USEDFPU bit together must not.

Instead of just adding random "preempt_disable/enable()" calls to what
is already excessively ugly code, this introduces some helper functions
that mostly mirror the "kernel_fpu_begin/end()" functionality, just for
the user state instead.

Those helper functions should probably eventually replace the other
ad-hoc CR0.TS and TS_USEDFPU tests too, but I'll need to think about it
some more: the task switching functionality in particular needs to
expose the difference between the 'prev' and 'next' threads, while the
new helper functions intentionally were written to only work with
'current'.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org	# Fixes preemption bug and helps backporting
---
 arch/x86/include/asm/i387.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/xsave.c     |   10 +++-------
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 262bea981aa5..6e87fa43c357 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -400,6 +400,48 @@ static inline void irq_ts_restore(int TS_state)
 }
 
 /*
+ * The question "does this thread have fpu access?"
+ * is slightly racy, since preemption could come in
+ * and revoke it immediately after the test.
+ *
+ * However, even in that very unlikely scenario,
+ * we can just assume we have FPU access - typically
+ * to save the FP state - we'll just take a #NM
+ * fault and get the FPU access back.
+ *
+ * The actual user_fpu_begin/end() functions
+ * need to be preemption-safe, though.
+ *
+ * NOTE! user_fpu_end() must be used only after you
+ * have saved the FP state, and user_fpu_begin() must
+ * be used only immediately before restoring it.
+ * These functions do not do any save/restore on
+ * their own.
+ */
+static inline int user_has_fpu(void)
+{
+	return current_thread_info()->status & TS_USEDFPU;
+}
+
+static inline void user_fpu_end(void)
+{
+	preempt_disable();
+	current_thread_info()->status &= ~TS_USEDFPU;
+	stts();
+	preempt_enable();
+}
+
+static inline void user_fpu_begin(void)
+{
+	preempt_disable();
+	if (!user_has_fpu()) {
+		clts();
+		current_thread_info()->status |= TS_USEDFPU;
+	}
+	preempt_enable();
+}
+
+/*
  * These disable preemption on their own and are safe
  */
 static inline void save_init_fpu(struct task_struct *tsk)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a3911343976b..86f1f09a738a 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -168,7 +168,7 @@ int save_i387_xstate(void __user *buf)
 	if (!used_math())
 		return 0;
 
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+	if (user_has_fpu()) {
 		if (use_xsave())
 			err = xsave_user(buf);
 		else
@@ -176,8 +176,7 @@ int save_i387_xstate(void __user *buf)
 
 		if (err)
 			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
+		user_fpu_end();
 	} else {
 		sanitize_i387_state(tsk);
 		if (__copy_to_user(buf, &tsk->thread.fpu.state->fxsave,
@@ -292,10 +291,7 @@ int restore_i387_xstate(void __user *buf)
 			return err;
 	}
 
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
+	user_fpu_begin();
 	if (use_xsave())
 		err = restore_user_xstate(buf);
 	else
-- 
1.7.9.188.g12766.dirty


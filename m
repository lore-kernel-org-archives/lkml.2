Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2HXWOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:14:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2HXWOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:14:35 -0400
Date: Fri, 24 Aug 2012 15:14:21 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-cc50fae05beb2db9f4587bbb1a0d6aba2af5b407@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: remove unnecessary user_fpu_end()
  in save_xstate_sig()
Git-Commit-ID: cc50fae05beb2db9f4587bbb1a0d6aba2af5b407
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Aug 2012 15:14:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc50fae05beb2db9f4587bbb1a0d6aba2af5b407
Gitweb:     http://git.kernel.org/tip/cc50fae05beb2db9f4587bbb1a0d6aba2af5b407
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 24 Aug 2012 14:12:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Aug 2012 14:26:48 -0700

x86, fpu: remove unnecessary user_fpu_end() in save_xstate_sig()

Few lines below we do drop_fpu() which is more safer. Remove the
unnecessary user_fpu_end() in save_xstate_sig(), which allows
the drop_fpu() to ignore any pending exceptions from the user-space
and drop the current fpu.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h |   17 +++--------------
 arch/x86/kernel/xsave.c             |    1 -
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index fe95ad0..fac39e9 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -412,22 +412,11 @@ static inline void __drop_fpu(struct task_struct *tsk)
 }
 
 /*
- * The actual user_fpu_begin/end() functions
- * need to be preemption-safe.
+ * Need to be preemption-safe.
  *
- * NOTE! user_fpu_end() must be used only after you
- * have saved the FP state, and user_fpu_begin() must
- * be used only immediately before restoring it.
- * These functions do not do any save/restore on
- * their own.
+ * NOTE! user_fpu_begin() must be used only immediately before restoring
+ * it. This function does not do any save/restore on their own.
  */
-static inline void user_fpu_end(void)
-{
-	preempt_disable();
-	__thread_fpu_end(current);
-	preempt_enable();
-}
-
 static inline void user_fpu_begin(void)
 {
 	preempt_disable();
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 6cfc7d9..f0bb844 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -254,7 +254,6 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		/* Update the thread's fxstate to save the fsave header. */
 		if (ia32_fxstate)
 			fpu_fxsave(&tsk->thread.fpu);
-		user_fpu_end();
 	} else {
 		sanitize_i387_state(tsk);
 		if (__copy_to_user(buf_fx, xsave, xstate_size))

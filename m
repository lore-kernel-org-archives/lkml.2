Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2ISADI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:03:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2ISADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:03:06 -0400
Date: Tue, 18 Sep 2012 17:02:54 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-377ffbcc536a5a6666dc077395163ab149c02610@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: remove unnecessary user_fpu_end()
  in save_xstate_sig()
Git-Commit-ID: 377ffbcc536a5a6666dc077395163ab149c02610
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 18 Sep 2012 17:03:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  377ffbcc536a5a6666dc077395163ab149c02610
Gitweb:     http://git.kernel.org/tip/377ffbcc536a5a6666dc077395163ab149c02610
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 24 Aug 2012 14:12:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Sep 2012 15:52:06 -0700

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
index 78169d1..52202a6 100644
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
index 07ddc87..4ac5f2e 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -255,7 +255,6 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		/* Update the thread's fxstate to save the fsave header. */
 		if (ia32_fxstate)
 			fpu_fxsave(&tsk->thread.fpu);
-		user_fpu_end();
 	} else {
 		sanitize_i387_state(tsk);
 		if (__copy_to_user(buf_fx, xsave, xstate_size))

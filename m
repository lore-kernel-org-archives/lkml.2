Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab2HXVPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:15:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:7595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2HXVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967384"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/6] x86, fpu: remove unnecessary user_fpu_end() in save_xstate_sig()
Date: Fri, 24 Aug 2012 14:12:58 -0700
Message-Id: <1345842782-24175-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few lines below we do drop_fpu() which is more safer. Remove the
unnecessary user_fpu_end() in save_xstate_sig(), which allows
the drop_fpu() to ignore any pending exceptions from the user-space
and drop the current fpu.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
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
-- 
1.7.6.5


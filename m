Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229Ab2HXVQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:16:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:7595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab2HXVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967378"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/6] x86, fpu: drop_fpu() before restoring new state from sigframe
Date: Fri, 24 Aug 2012 14:12:57 -0700
Message-Id: <1345842782-24175-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to save the state with unlazy_fpu(), that is about to get overwritten
by the state from the signal frame. Instead use drop_fpu() and continue
to restore the new state.

Also fold the stop_fpu_preload() into drop_fpu().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/fpu-internal.h |    7 +------
 arch/x86/kernel/xsave.c             |    8 +++-----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index ba83a08..fe95ad0 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -448,17 +448,12 @@ static inline void save_init_fpu(struct task_struct *tsk)
 	preempt_enable();
 }
 
-static inline void stop_fpu_preload(struct task_struct *tsk)
-{
-	tsk->fpu_counter = 0;
-}
-
 static inline void drop_fpu(struct task_struct *tsk)
 {
 	/*
 	 * Forget coprocessor state..
 	 */
-	stop_fpu_preload(tsk);
+	tsk->fpu_counter = 0;
 	preempt_disable();
 	__drop_fpu(tsk);
 	preempt_enable();
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a23d100..6cfc7d9 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -381,16 +381,14 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
 		struct user_i387_ia32_struct env;
 
-		stop_fpu_preload(tsk);
-		unlazy_fpu(tsk);
+		drop_fpu(tsk);
 
 		if (__copy_from_user(xsave, buf_fx, state_size) ||
-		    __copy_from_user(&env, buf, sizeof(env))) {
-			drop_fpu(tsk);
+		    __copy_from_user(&env, buf, sizeof(env)))
 			return -1;
-		}
 
 		sanitize_restored_xstate(tsk, &env, xstate_bv, fx_only);
+		set_used_math();
 	} else {
 		/*
 		 * For 64-bit frames and 32-bit fsave frames, restore the user
-- 
1.7.6.5


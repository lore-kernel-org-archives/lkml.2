Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2HXWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:13:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2HXWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:13:41 -0400
Date: Fri, 24 Aug 2012 15:13:28 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-739390035c5fba2132fa424309786ff7bdd2cc1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345842782-24175-2-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-2-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: drop_fpu()
  before restoring new state from sigframe
Git-Commit-ID: 739390035c5fba2132fa424309786ff7bdd2cc1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Aug 2012 15:13:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  739390035c5fba2132fa424309786ff7bdd2cc1e
Gitweb:     http://git.kernel.org/tip/739390035c5fba2132fa424309786ff7bdd2cc1e
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 24 Aug 2012 14:12:57 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Aug 2012 14:26:47 -0700

x86, fpu: drop_fpu() before restoring new state from sigframe

No need to save the state with unlazy_fpu(), that is about to get overwritten
by the state from the signal frame. Instead use drop_fpu() and continue
to restore the new state.

Also fold the stop_fpu_preload() into drop_fpu().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1345842782-24175-2-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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

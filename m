Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2JCSWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:22:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48759 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2JCSWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:22:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] rcu: Remove rcu_switch()
Date: Wed,  3 Oct 2012 20:21:52 +0200
Message-Id: <1349288512-2635-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only there to call rcu_user_hooks_switch(). Let's
just call rcu_user_hooks_switch() directly, we don't need this
function in the middle.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/rcupdate.h |    2 ++
 include/linux/sched.h    |    8 --------
 kernel/sched/core.c      |    2 +-
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..5d009de 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -204,6 +204,8 @@ static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
 static inline void rcu_user_enter_after_irq(void) { }
 static inline void rcu_user_exit_after_irq(void) { }
+static inline void rcu_user_hooks_switch(struct task_struct *prev,
+					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
 extern void exit_rcu(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9d51e26..65e2694 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1886,14 +1886,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 
 #endif
 
-static inline void rcu_switch(struct task_struct *prev,
-			      struct task_struct *next)
-{
-#ifdef CONFIG_RCU_USER_QS
-	rcu_user_hooks_switch(prev, next);
-#endif
-}
-
 static inline void tsk_restore_flags(struct task_struct *task,
 				unsigned long orig_flags, unsigned long flags)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c177472..a48bef7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1887,7 +1887,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch(prev, next);
+	rcu_user_hooks_switch(prev, next);
 	switch_to(prev, next, prev);
 
 	barrier();
-- 
1.7.5.4


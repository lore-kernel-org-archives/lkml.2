Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2JJXr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:47:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62895 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JJXr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:47:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2] rcu: Remove rcu_switch()
Date: Thu, 11 Oct 2012 01:47:16 +0200
Message-Id: <1349912836-11780-1-git-send-email-fweisbec@gmail.com>
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
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/um/drivers/mconsole_kern.c |    2 +-
 include/linux/rcupdate.h        |    2 ++
 include/linux/sched.h           |    8 --------
 kernel/sched/core.c             |    2 +-
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index c17de0d..0b989af 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -705,7 +705,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch(from, to);
+	rcu_user_hooks_switch(from, to);
 	switch_to(from, to, from);
 }
 
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
index fade317..c300c7c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1887,14 +1887,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 
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
index dd036fe..b53a485 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2081,7 +2081,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch(prev, next);
+	rcu_user_hooks_switch(prev, next);
 	switch_to(prev, next, prev);
 
 	barrier();
-- 
1.7.5.4


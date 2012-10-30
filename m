Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965070Ab2J3Rgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:36:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58931 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965006Ab2J3RcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Richard Weinberger <richard@nod.at>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/5] rcu: Remove rcu_switch()
Date: Tue, 30 Oct 2012 10:19:19 -0700
Message-Id: <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030171906.GA27431@linux.vnet.ibm.com>
References: <20121030171906.GA27431@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-6078-0000-0000-0000114AA884
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
index 79ccfe6..49e3b49 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -648,7 +648,7 @@ static void stack_proc(void *arg)
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
index 0dd42a0..432cc5e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1844,14 +1844,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 
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
index 2d8927f..68414fa 100644
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
1.7.8


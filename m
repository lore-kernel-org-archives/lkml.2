Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1FGMD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:03:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:52948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1FGMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:03:23 -0400
Date: Tue, 7 Jun 2011 12:03:01 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-6c6c54e1807faf116724451ef2bd14993780470a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <1307115427.2353.3456.camel@twins>
References: <1307115427.2353.3456.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix/clarify set_task_cpu() locking rules
Git-Commit-ID: 6c6c54e1807faf116724451ef2bd14993780470a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 12:03:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c6c54e1807faf116724451ef2bd14993780470a
Gitweb:     http://git.kernel.org/tip/6c6c54e1807faf116724451ef2bd14993780470a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 3 Jun 2011 17:37:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Jun 2011 12:26:40 +0200

sched: Fix/clarify set_task_cpu() locking rules

Sergey reported a CONFIG_PROVE_RCU warning in push_rt_task where
set_task_cpu() was called with both relevant rq->locks held, which
should be sufficient for running tasks since holding its rq->lock
will serialize against sched_move_task().

Update the comments and fix the task_group() lockdep test.

Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1307115427.2353.3456.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2fe98ed..3f2e502 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -605,10 +605,10 @@ static inline int cpu_of(struct rq *rq)
 /*
  * Return the group to which this tasks belongs.
  *
- * We use task_subsys_state_check() and extend the RCU verification
- * with lockdep_is_held(&p->pi_lock) because cpu_cgroup_attach()
- * holds that lock for each task it moves into the cgroup. Therefore
- * by holding that lock, we pin the task to the current cgroup.
+ * We use task_subsys_state_check() and extend the RCU verification with
+ * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
+ * task it moves into the cgroup. Therefore by holding either of those locks,
+ * we pin the task to the current cgroup.
  */
 static inline struct task_group *task_group(struct task_struct *p)
 {
@@ -616,7 +616,8 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock));
+			lockdep_is_held(&p->pi_lock) ||
+			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -2200,6 +2201,16 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
+	/*
+	 * The caller should hold either p->pi_lock or rq->lock, when changing
+	 * a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable tasks.
+	 *
+	 * sched_move_task() holds both and thus holding either pins the cgroup,
+	 * see set_task_rq().
+	 *
+	 * Furthermore, all task_rq users should acquire both locks, see
+	 * task_rq_lock().
+	 */
 	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
 				      lockdep_is_held(&task_rq(p)->lock)));
 #endif

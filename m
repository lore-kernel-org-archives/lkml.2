Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1FCPhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:37:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:54979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1FCPhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:37:22 -0400
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20110531172651.GA4478@swordfish.minsk.epam.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 17:37:07 +0200
Message-ID: <1307115427.2353.3456.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 20:26 +0300, Sergey Senozhatsky wrote:
>  [  152.262791] kernel/sched.c:619 invoked rcu_dereference_check() without protection!
>  [  152.262795] 
>  [  152.262841] stack backtrace:
>  [  152.262846] Pid: 16, comm: watchdog/1 Not tainted 3.0.0-rc1-dbg-00441-g1d5f9cc-dirty #599
>  [  152.262851] Call Trace:
>  [  152.262860]  [<ffffffff8106e17b>] lockdep_rcu_dereference+0xa7/0xaf
>  [  152.262868]  [<ffffffff810369f4>] set_task_cpu+0x1ed/0x3ce
>  [  152.262876]  [<ffffffff8123a5d7>] ? plist_check_head+0x94/0x98
>  [  152.262883]  [<ffffffff8123a72d>] ? plist_del+0x82/0x89
>  [  152.262889]  [<ffffffff8102b139>] ? dequeue_task_rt+0x33/0x38
>  [  152.262895]  [<ffffffff8102e3ac>] ? dequeue_task+0x82/0x89
>  [  152.262902]  [<ffffffff81036fc0>] push_rt_task.part.131+0x1bb/0x247
>  [  152.262909]  [<ffffffff81037138>] post_schedule_rt+0x1b/0x24
>  [  152.262918]  [<ffffffff81477c1c>] schedule+0x989/0xa9e 

Does the below cure the issue? (completely untested)

---
Subject: sched: Fix/clarify set_task_cpu() locking rules
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Jun 03 17:28:08 CEST 2011

Sergey reported a CONFIG_PROVE_RCU warning in push_rt_task where
set_task_cpu() was called with both relevant rq->locks held, which
should be sufficient for running tasks since holding its rq->lock will
serialize against sched_move_task().

Update the comments and fix the task_group() lockdep test.

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-k3lie1tjkcp3626dn5r5ihge@git.kernel.org
---
 kernel/sched.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
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
@@ -616,7 +616,8 @@ static inline struct task_group *task_gr
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock));
+			lockdep_is_held(&p->pi_lock) ||
+			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -2200,6 +2201,16 @@ void set_task_cpu(struct task_struct *p,
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
+	/*
+	 * The caller should hold either p->pi_lock or rq->lock, when changing
+	 * a task's CPU.
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


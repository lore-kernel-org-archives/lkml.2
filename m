Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0FHNe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:34:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0FHNe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:34:56 -0400
Subject: Re: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked 
 rcu_dereference_check() without protection!
From: Peter Zijlstra <peterz@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Vivek Goyal <vgoyal@redhat.com>,
       Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       nauman@google.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <AANLkTimXVlgzHivCQberLdrFP8BH_nJzt8_ozUNHG_aI@mail.gmail.com>
References: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
	 <20100608001929.GF2387@linux.vnet.ibm.com>
	 <AANLkTikl13cJNuU32JzRarrUnoh5DYHr-Tbnv9B-UjsG@mail.gmail.com>
	 <1275986441.5408.111.camel@twins>
	 <AANLkTimXVlgzHivCQberLdrFP8BH_nJzt8_ozUNHG_aI@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Jun 2010 15:34:35 +0200
Message-ID: <1276004075.2987.208.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 09:14 -0400, Miles Lane wrote:

>   CC      kernel/sched.o
> kernel/sched.c: In function ‘task_group’:
> kernel/sched.c:321: error: implicit declaration of function ‘task_rq’
> kernel/sched.c:321: error: invalid type argument of ‘->’ (have ‘int’)
> make[1]: *** [kernel/sched.o] Error 1
> 
> I had to apply with fuzz.  Did it mess up?


No, I probably did.. task_rq() is defined on line 636 or thereabouts,
and this function landed around line 320.

Ahh, and it compiled here because I have CGROUP_SCHED=y, but
PROVE_RCU=n, so that whole check expression disappears and is never
evaluated...

/me fixes

---
Subject: sched: PROVE_RCU vs cpu_cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jun 08 11:40:42 CEST 2010

PROVE_RCU has a few issues with the cpu_cgroup because the scheduler
typically holds rq->lock around the css rcu derefs but the generic
cgroup code doesn't (and can't) know about that lock.

Provide means to add extra checks to the css dereference and use that
in the scheduler to annotate its users.

The addition of rq->lock to these checks is correct because the
cgroup_subsys::attach() method takes the rq->lock for each task it
moves, therefore by holding that lock, we ensure the task is pinned to
the current cgroup and the RCU dereference is valid.

That leaves one genuine race in __sched_setscheduler() where we used
task_group() without holding any of the required locks and thus raced
with the cgroup code. Solve this by moving the check under the rq->lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/cgroup.h |   20 +++++---
 kernel/sched.c         |  115 +++++++++++++++++++++++++------------------------
 2 files changed, 73 insertions(+), 62 deletions(-)

Index: linux-2.6/include/linux/cgroup.h
===================================================================
--- linux-2.6.orig/include/linux/cgroup.h
+++ linux-2.6/include/linux/cgroup.h
@@ -525,13 +525,21 @@ static inline struct cgroup_subsys_state
 	return cgrp->subsys[subsys_id];
 }
 
-static inline struct cgroup_subsys_state *task_subsys_state(
-	struct task_struct *task, int subsys_id)
+/*
+ * function to get the cgroup_subsys_state which allows for extra
+ * rcu_dereference_check() conditions, such as locks used during the
+ * cgroup_subsys::attach() methods.
+ */
+#define task_subsys_state_check(task, subsys_id, __c)			\
+	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
+			      rcu_read_lock_held() ||			\
+			      lockdep_is_held(&task->alloc_lock) ||	\
+			      cgroup_lock_is_held() || (__c))
+
+static inline struct cgroup_subsys_state *
+task_subsys_state(struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
-				     rcu_read_lock_held() ||
-				     lockdep_is_held(&task->alloc_lock) ||
-				     cgroup_lock_is_held());
+	return task_subsys_state_check(task, subsys_id, false);
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -306,52 +306,6 @@ static int init_task_group_load = INIT_T
  */
 struct task_group init_task_group;
 
-/* return group to which a task belongs */
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	struct task_group *tg;
-
-#ifdef CONFIG_CGROUP_SCHED
-	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
-				struct task_group, css);
-#else
-	tg = &init_task_group;
-#endif
-	return tg;
-}
-
-/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
-{
-	/*
-	 * Strictly speaking this rcu_read_lock() is not needed since the
-	 * task_group is tied to the cgroup, which in turn can never go away
-	 * as long as there are tasks attached to it.
-	 *
-	 * However since task_group() uses task_subsys_state() which is an
-	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
-	 */
-	rcu_read_lock();
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
-#endif
-	rcu_read_unlock();
-}
-
-#else
-
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	return NULL;
-}
-
 #endif	/* CONFIG_CGROUP_SCHED */
 
 /* CFS-related fields in a runqueue */
@@ -644,6 +598,49 @@ static inline int cpu_of(struct rq *rq)
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+#ifdef CONFIG_CGROUP_SCHED
+
+/*
+ * Return the group to which this tasks belongs.
+ *
+ * We use task_subsys_state_check() and extend the RCU verification
+ * with lockdep_is_held(&task_rq(p)->lock) because cpu_cgroup_attach()
+ * holds that lock for each task it moves into the cgroup. Therefore
+ * by holding that lock, we pin the task to the current cgroup.
+ */
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	struct cgroup_subsys_state *css;
+
+	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
+			lockdep_is_held(&task_rq(p)->lock));
+	return container_of(css, struct task_group, css);
+}
+
+/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
+{
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
+	p->se.parent = task_group(p)->se[cpu];
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
+	p->rt.parent = task_group(p)->rt_se[cpu];
+#endif
+}
+
+#else /* CONFIG_CGROUP_SCHED */
+
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CGROUP_SCHED */
+
 inline void update_rq_clock(struct rq *rq)
 {
 	if (!rq->skip_clock_update)
@@ -4465,16 +4462,6 @@ recheck:
 	}
 
 	if (user) {
-#ifdef CONFIG_RT_GROUP_SCHED
-		/*
-		 * Do not allow realtime tasks into groups that have no runtime
-		 * assigned.
-		 */
-		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
-			return -EPERM;
-#endif
-
 		retval = security_task_setscheduler(p, policy, param);
 		if (retval)
 			return retval;
@@ -4490,6 +4477,22 @@ recheck:
 	 * runqueue lock must be held.
 	 */
 	rq = __task_rq_lock(p);
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (user) {
+		/*
+		 * Do not allow realtime tasks into groups that have no runtime
+		 * assigned.
+		 */
+		if (rt_bandwidth_enabled() && rt_policy(policy) &&
+				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+			__task_rq_unlock(rq);
+			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+			return -EPERM;
+		}
+	}
+#endif
+
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;


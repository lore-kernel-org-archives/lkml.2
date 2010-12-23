Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0LWSYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 13:24:43 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56764 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0LWSYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:24:42 -0500
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Miklos Vajna <vmiklos@frugalware.org>, Mike Galbraith <efault@gmx.de>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <1293107624.2170.642.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop> <1293027112.2170.140.camel@laptop>
	 <20101222151434.GW10557@genesis.frugalware.org>
	 <1293037718.2170.155.camel@laptop> <1293050173.2170.389.camel@laptop>
	 <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
	 <1293106330.2170.618.camel@laptop>  <1293107624.2170.642.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 19:24:30 +0100
Message-ID: <1293128670.2170.748.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 13:33 +0100, Peter Zijlstra wrote:

>  systemd-1       0d..1. 2070793us : sched_destroy_group: se: f69e43c0, load: 1024
>  systemd-1       0d..1. 2070794us : sched_destroy_group: cfs_rq: f69e4720, nr: 1, load: 1024
>  systemd-1       0d..1. 2070794us : __print_runqueue:  cfs_rq: f69e4720, nr: 1, load: 1024
>  systemd-1       0d..1. 2070795us : __print_runqueue:  curr: (null)
>  systemd-1       0d..1. 2070796us : __print_runqueue:  se: f6a8eb4c, comm: systemd-tmpfile/1243, load: 1024
>  systemd-1       0d..1. 2070796us : _raw_spin_unlock_irqrestore <-sched_destroy_group
> 
> So somehow it manages to destroy a group with a task attached.

Its even weirder:

 systemd-1       0d..1. 1663489us : sched_destroy_group: se: f69e7360, load: 1024
 systemd-1       0d..1. 1663489us : sched_destroy_group: cfs_rq: f69e72a0, nr: 1, load: 1024
 systemd-1       0d..1. 1663491us : __print_runqueue:  cfs_rq: f69e72a0, nr: 1, load: 1024, cgroup: /system/systemd-sysctl.service
 systemd-1       0d..1. 1663491us : __print_runqueue:  curr: (null)
 systemd-1       0d..1. 1663493us : __print_runqueue:  se: f69d95bc, comm: systemd-sysctl/1209, load: 1024, cgroup: /
 systemd-1       0d..1. 1663496us : do_invalid_op <-error_code

The task enqueued to the cfs_rq doesn't match the cgroup, the thing is,
I don't see a cpu_cgroup_attach/sched_move_task call in the log, nor
does a BUG_ON() validating the task's cgroup against the cfs_rq's cgroup
on account_entity_enqueue() trigger.

So it looks like a task changes cgroup without passing through the
cgroup_subsys::attach method, which afaict isn't supposed to happen.

---
 kernel/sched.c      |   26 ++++++++++++++-
 kernel/sched_fair.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..bc30efb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8033,10 +8033,20 @@ static void free_fair_sched_group(struct task_group *tg)
 	int i;
 
 	for_each_possible_cpu(i) {
-		if (tg->cfs_rq)
+		if (tg->cfs_rq) {
+			struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+			if (cfs_rq) {
+				trace_printk("cfs_rq: %p, nr: %ld, load: %ld\n", 
+						cfs_rq, cfs_rq->nr_running, cfs_rq->load.weight);
+			}
 			kfree(tg->cfs_rq[i]);
-		if (tg->se)
+		}
+		if (tg->se) {
+			struct sched_entity *se = tg->se[i];
+			if (se)
+				trace_printk("se: %p, load: %ld\n", se, se->load.weight);
 			kfree(tg->se[i]);
+		}
 	}
 
 	kfree(tg->cfs_rq);
@@ -8092,6 +8102,18 @@ static inline void register_fair_sched_group(struct task_group *tg, int cpu)
 
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
+	struct sched_entity *se = tg->se[cpu];
+
+	trace_printk("se: %p, load: %ld\n", se, se->load.weight);
+	trace_printk("cfs_rq: %p, nr: %ld, load: %ld\n", 
+			cfs_rq, cfs_rq->nr_running, cfs_rq->load.weight);
+
+	if (cfs_rq->nr_running) {
+		print_runqueue(cfs_rq);
+		BUG();
+	}
+
 	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
 }
 #else /* !CONFG_FAIR_GROUP_SCHED */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index db3f674..37d918a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -333,6 +333,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	trace_printk("%p to %p, %ld tasks\n", se, cfs_rq, cfs_rq->nr_running);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -364,6 +366,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	trace_printk("%p from %p, %ld left\n", se, cfs_rq, cfs_rq->nr_running);
+
 	if (cfs_rq->rb_leftmost == &se->run_node) {
 		struct rb_node *next_node;
 
@@ -394,6 +398,70 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 	return rb_entry(last, struct sched_entity, run_node);
 }
 
+#define INDENT(i) ((i)*2), "                                  "
+
+static void notrace __print_runqueue(struct cfs_rq *cfs_rq, int indent);
+
+static __always_inline
+char *task_group_path(struct task_group *tg, char *buf, int buflen)
+{
+	/* may be NULL if the underlying cgroup isn't fully-created yet */
+	if (!tg->css.cgroup)
+		buf[0] = '\0';
+	else
+		cgroup_path(tg->css.cgroup, buf, buflen);
+
+	return buf;
+}
+
+static void __always_inline
+__print_entity(struct sched_entity *se, char *name, int indent)
+{
+	if (!se) {
+		trace_printk("%.*s %s: %p\n", INDENT(indent), name, se);
+		return;
+	}
+
+	if (entity_is_task(se)) {
+		struct task_struct *p = task_of(se);
+		char buf[64];
+
+		trace_printk("%.*s %s: %p, comm: %s/%d, load: %ld, cgroup: %s\n",
+				INDENT(indent), name, 
+				se, p->comm, p->pid, se->load.weight,
+				task_group_path(task_group(p), buf, sizeof(buf)));
+	} else {
+		trace_printk("%.*s %s: %p, load: %ld, ", 
+				INDENT(indent), name,
+				se, se->load.weight);
+		__print_runqueue(group_cfs_rq(se), indent+1);
+	}
+}
+
+static void notrace __print_runqueue(struct cfs_rq *cfs_rq, int indent)
+{
+	struct rb_node *n;
+	char buf[64];
+
+	trace_printk("%.*s cfs_rq: %p, nr: %ld, load: %ld, cgroup: %s\n", 
+			INDENT(indent),
+			cfs_rq, cfs_rq->nr_running,
+			cfs_rq->load.weight,
+			task_group_path(cfs_rq->tg, buf, sizeof(buf)));
+
+	__print_entity(cfs_rq->curr, "curr", indent);
+
+	for (n = cfs_rq->rb_leftmost; n; n = rb_next(n)) {
+		struct sched_entity *se = rb_entry(n, struct sched_entity, run_node);
+		__print_entity(se, "se", indent);
+	}
+}
+
+void notrace print_runqueue(struct cfs_rq *cfs_rq)
+{
+	__print_runqueue(cfs_rq, 0);
+}
+
 /**************************************************************
  * Scheduling class statistics methods:
  */
@@ -631,6 +699,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, se->load.weight);
 		list_add(&se->group_node, &cfs_rq->tasks);
+		BUG_ON(task_group(task_of(se)) != cfs_rq->tg);
 	}
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
@@ -1047,6 +1116,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
+	print_runqueue(&rq->cfs);
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
@@ -1055,6 +1125,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		flags = ENQUEUE_WAKEUP;
 	}
 
+	trace_printk("add task: %p, %s/%d\n", &p->se, p->comm, p->pid);
+	print_runqueue(&rq->cfs);
+
 	hrtick_update(rq);
 }
 
@@ -1068,6 +1141,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
+	print_runqueue(&rq->cfs);
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
@@ -1077,6 +1151,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		flags |= DEQUEUE_SLEEP;
 	}
 
+	trace_printk("del task: %p, %s/%d\n", &p->se, p->comm, p->pid);
+	print_runqueue(&rq->cfs);
+
 	hrtick_update(rq);
 }
 
@@ -1719,6 +1796,8 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 
+	print_runqueue(&rq->cfs);
+
 	if (!cfs_rq->nr_running)
 		return NULL;
 
@@ -1731,6 +1810,9 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	p = task_of(se);
 	hrtick_start_fair(rq, p);
 
+	trace_printk("picked: %p, %s/%d\n", se, p->comm, p->pid);
+	print_runqueue(&rq->cfs);
+
 	return p;
 }
 
@@ -1742,10 +1824,15 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
 	struct sched_entity *se = &prev->se;
 	struct cfs_rq *cfs_rq;
 
+	print_runqueue(&rq->cfs);
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		put_prev_entity(cfs_rq, se);
 	}
+
+	trace_printk("put: %p, %s/%d\n", se, prev->comm, prev->pid);
+	print_runqueue(&rq->cfs);
+
 }
 
 #ifdef CONFIG_SMP
@@ -3819,8 +3906,10 @@ static void set_curr_task_fair(struct rq *rq)
 {
 	struct sched_entity *se = &rq->curr->se;
 
+	print_runqueue(&rq->cfs);
 	for_each_sched_entity(se)
 		set_next_entity(cfs_rq_of(se), se);
+	print_runqueue(&rq->cfs);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED


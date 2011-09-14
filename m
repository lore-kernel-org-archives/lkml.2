Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1INNkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:40:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:53138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab1INNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:39:56 -0400
Message-Id: <20110914133750.739484417@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 14 Sep 2011 15:30:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
References: <20110914133034.687048806@chello.nl>
Content-Disposition: inline; filename=sched-wakeup-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide means to queue wakeup targets for later mass wakeup.

This is useful for locking primitives that can effect multiple wakeups
per operation and want to avoid lock internal lock contention by
delaying the wakeups until we've released the lock internal locks.

Alternatively it can be used to avoid issuing multiple wakeups, and
thus save a few cycles, in packet processing. Queue all target tasks
and wakeup once you've processed all packets. That way you avoid
waking the target task multiple times if there were multiple packets
for the same task.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c        |   21 +++++++++++++++++++++
 2 files changed, 65 insertions(+)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1065,6 +1065,19 @@ struct uts_namespace;
 struct rq;
 struct sched_domain;
 
+struct wake_list_head {
+	struct wake_list_node *first;
+};
+
+struct wake_list_node {
+	struct wake_list_node *next;
+};
+
+#define WAKE_LIST_TAIL ((struct wake_list_node *)0x01)
+
+#define WAKE_LIST(name) \
+	struct wake_list_head name = { WAKE_LIST_TAIL }
+
 /*
  * wake flags
  */
@@ -1255,6 +1268,8 @@ struct task_struct {
 	unsigned int btrace_seq;
 #endif
 
+	struct wake_list_node wake_list;
+
 	unsigned int policy;
 	cpumask_t cpus_allowed;
 
@@ -2143,6 +2158,35 @@ extern void wake_up_new_task(struct task
 extern void sched_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
+static inline void
+wake_list_add(struct wake_list_head *head, struct task_struct *p)
+{
+	struct wake_list_node *n = &p->wake_list;
+
+	get_task_struct(p);
+	/*
+	 * Atomically grab the task, if ->wake_list is !0 already it means
+	 * its already queued (either by us or someone else) and will get the
+	 * wakeup due to that.
+	 *
+	 * This cmpxchg() implies a full barrier, which pairs with the write
+	 * barrier implied by the wakeup in wake_up_list().
+	 */
+	if (cmpxchg(&n->next, 0, n) != 0) {
+		/* It was already queued, drop the extra ref and we're done. */
+		put_task_struct(p);
+		return;
+	}
+
+	/*
+	 * The head is context local, there can be no concurrency.
+	 */
+	n->next = head->first;
+	head->first = n;
+}
+
+extern void wake_up_list(struct wake_list_head *head, unsigned int state);
+
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
 extern void __flush_signals(struct task_struct *);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2916,6 +2916,25 @@ int wake_up_state(struct task_struct *p,
 	return try_to_wake_up(p, state, 0);
 }
 
+void wake_up_list(struct wake_list_head *head, unsigned int state)
+{
+	struct wake_list_node *n = head->first;
+	struct task_struct *p;
+
+	while (n != WAKE_LIST_TAIL) {
+		p = container_of(n, struct task_struct, wake_list);
+		n = n->next;
+
+		p->wake_list.next = NULL;
+		/*
+		 * wake_up_state() implies a wmb() to pair with the queueing
+		 * in wake_list_add() so as not to miss wakeups.
+		 */
+		wake_up_state(p, state);
+		put_task_struct(p);
+	}
+}
+
 /*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
@@ -2943,6 +2962,8 @@ static void __sched_fork(struct task_str
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
+
+	p->wake_list.next = NULL;
 }
 
 /*



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1ILOGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:06:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1ILOGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:06:19 -0400
Subject: [PATCH 7/5] sched: Convert to use llist
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 12 Sep 2011 16:05:53 +0200
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315836353.26517.42.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Convert to use llist
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Sep 12 13:06:17 CEST 2011

Use the generic llist primitives..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   48 ++++++++++--------------------------------------
 2 files changed, 12 insertions(+), 39 deletions(-)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -90,6 +90,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
+#include <linux/llist.h>
 
 #include <asm/processor.h>
 
@@ -1225,7 +1226,7 @@ struct task_struct {
 	unsigned int ptrace;
 
 #ifdef CONFIG_SMP
-	struct task_struct *wake_entry;
+	struct llist_node wake_entry;
 	int on_cpu;
 #endif
 	int on_rq;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -702,7 +702,7 @@ struct rq {
 #endif
 
 #ifdef CONFIG_SMP
-	struct task_struct *wake_list;
+	struct llist_head wake_list;
 #endif
 };
 
@@ -2698,42 +2698,26 @@ static int ttwu_remote(struct task_struc
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_do_pending(struct task_struct *list)
+static void sched_ttwu_pending(void)
 {
 	struct rq *rq = this_rq();
+	struct llist_node *llist = llist_del_all(&rq->wake_list);
+	struct task_struct *p;
 
 	raw_spin_lock(&rq->lock);
 
-	while (list) {
-		struct task_struct *p = list;
-		list = list->wake_entry;
+	while (llist) {
+		p = llist_entry(llist, struct task_struct, wake_entry);
+		llist = llist_next(llist);
 		ttwu_do_activate(rq, p, 0);
 	}
 
 	raw_spin_unlock(&rq->lock);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void sched_ttwu_pending(void)
-{
-	struct rq *rq = this_rq();
-	struct task_struct *list = xchg(&rq->wake_list, NULL);
-
-	if (!list)
-		return;
-
-	sched_ttwu_do_pending(list);
-}
-
-#endif /* CONFIG_HOTPLUG_CPU */
-
 void scheduler_ipi(void)
 {
-	struct rq *rq = this_rq();
-	struct task_struct *list = xchg(&rq->wake_list, NULL);
-
-	if (!list)
+	if (llist_empty(&this_rq()->wake_list))
 		return;
 
 	/*
@@ -2750,25 +2734,13 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	sched_ttwu_do_pending(list);
+	sched_ttwu_pending();
 	irq_exit();
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-	struct task_struct *next = rq->wake_list;
-
-	for (;;) {
-		struct task_struct *old = next;
-
-		p->wake_entry = next;
-		next = cmpxchg(&rq->wake_list, old, p);
-		if (next == old)
-			break;
-	}
-
-	if (!next)
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
 		smp_send_reschedule(cpu);
 }
 


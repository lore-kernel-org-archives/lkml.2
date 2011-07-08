Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1GHM7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:59:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:32954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1GHM7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:59:09 -0400
Date: Fri, 8 Jul 2011 12:58:41 GMT
From: tip-bot for Dima Zavin <dima@android.com>
Message-ID: <tip-732375c6a5a4cc825b676c922d547aba96b8ce15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, peterz@infradead.org, dwalker@codeaurora.org,
        rostedt@goodmis.org, dima@android.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, peterz@infradead.org, dwalker@codeaurora.org,
        rostedt@goodmis.org, dima@android.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1310084879-10351-2-git-send-email-dima@android.com>
References: <1310084879-10351-2-git-send-email-dima@android.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] plist: Remove the need to supply locks to plist heads
Git-Commit-ID: 732375c6a5a4cc825b676c922d547aba96b8ce15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Jul 2011 12:58:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  732375c6a5a4cc825b676c922d547aba96b8ce15
Gitweb:     http://git.kernel.org/tip/732375c6a5a4cc825b676c922d547aba96b8ce15
Author:     Dima Zavin <dima@android.com>
AuthorDate: Thu, 7 Jul 2011 17:27:59 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 Jul 2011 14:02:53 +0200

plist: Remove the need to supply locks to plist heads

This was legacy code brought over from the RT tree and
is no longer necessary.

Signed-off-by: Dima Zavin <dima@android.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Walker <dwalker@codeaurora.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/1310084879-10351-2-git-send-email-dima@android.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/plist.h   |   55 ++--------------------------------------------
 include/linux/rtmutex.h |    4 +-
 kernel/fork.c           |    2 +-
 kernel/futex.c          |    2 +-
 kernel/pm_qos_params.c  |    6 ++--
 kernel/rtmutex.c        |    2 +-
 kernel/sched.c          |    4 +-
 lib/plist.c             |    7 +-----
 8 files changed, 14 insertions(+), 68 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index c9b9f32..aa0fb39 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -77,14 +77,9 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/spinlock_types.h>
 
 struct plist_head {
 	struct list_head node_list;
-#ifdef CONFIG_DEBUG_PI_LIST
-	raw_spinlock_t *rawlock;
-	spinlock_t *spinlock;
-#endif
 };
 
 struct plist_node {
@@ -93,37 +88,13 @@ struct plist_node {
 	struct list_head	node_list;
 };
 
-#ifdef CONFIG_DEBUG_PI_LIST
-# define PLIST_HEAD_LOCK_INIT(_lock)		.spinlock = _lock
-# define PLIST_HEAD_LOCK_INIT_RAW(_lock)	.rawlock = _lock
-#else
-# define PLIST_HEAD_LOCK_INIT(_lock)
-# define PLIST_HEAD_LOCK_INIT_RAW(_lock)
-#endif
-
-#define _PLIST_HEAD_INIT(head)				\
-	.node_list = LIST_HEAD_INIT((head).node_list)
-
 /**
  * PLIST_HEAD_INIT - static struct plist_head initializer
  * @head:	struct plist_head variable name
- * @_lock:	lock to initialize for this list
- */
-#define PLIST_HEAD_INIT(head, _lock)			\
-{							\
-	_PLIST_HEAD_INIT(head),				\
-	PLIST_HEAD_LOCK_INIT(&(_lock))			\
-}
-
-/**
- * PLIST_HEAD_INIT_RAW - static struct plist_head initializer
- * @head:	struct plist_head variable name
- * @_lock:	lock to initialize for this list
  */
-#define PLIST_HEAD_INIT_RAW(head, _lock)		\
+#define PLIST_HEAD_INIT(head)				\
 {							\
-	_PLIST_HEAD_INIT(head),				\
-	PLIST_HEAD_LOCK_INIT_RAW(&(_lock))		\
+	.node_list = LIST_HEAD_INIT((head).node_list)	\
 }
 
 /**
@@ -141,31 +112,11 @@ struct plist_node {
 /**
  * plist_head_init - dynamic struct plist_head initializer
  * @head:	&struct plist_head pointer
- * @lock:	spinlock protecting the list (debugging)
  */
 static inline void
-plist_head_init(struct plist_head *head, spinlock_t *lock)
+plist_head_init(struct plist_head *head)
 {
 	INIT_LIST_HEAD(&head->node_list);
-#ifdef CONFIG_DEBUG_PI_LIST
-	head->spinlock = lock;
-	head->rawlock = NULL;
-#endif
-}
-
-/**
- * plist_head_init_raw - dynamic struct plist_head initializer
- * @head:	&struct plist_head pointer
- * @lock:	raw_spinlock protecting the list (debugging)
- */
-static inline void
-plist_head_init_raw(struct plist_head *head, raw_spinlock_t *lock)
-{
-	INIT_LIST_HEAD(&head->node_list);
-#ifdef CONFIG_DEBUG_PI_LIST
-	head->rawlock = lock;
-	head->spinlock = NULL;
-#endif
 }
 
 /**
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 8d522ff..de17134 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -66,7 +66,7 @@ struct hrtimer_sleeper;
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .wait_list = PLIST_HEAD_INIT_RAW(mutexname.wait_list, mutexname.wait_lock) \
+	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
 
@@ -100,7 +100,7 @@ extern void rt_mutex_unlock(struct rt_mutex *lock);
 
 #ifdef CONFIG_RT_MUTEXES
 # define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters, tsk.pi_lock),	\
+	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters),	\
 	INIT_RT_MUTEX_DEBUG(tsk)
 #else
 # define INIT_RT_MUTEXES(tsk)
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..7517a53 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1013,7 +1013,7 @@ static void rt_mutex_init_task(struct task_struct *p)
 {
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init_raw(&p->pi_waiters, &p->pi_lock);
+	plist_head_init(&p->pi_waiters);
 	p->pi_blocked_on = NULL;
 #endif
 }
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..3fbc76c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2697,7 +2697,7 @@ static int __init futex_init(void)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
+		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}
 
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 6824ca7..37f05d0 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -74,7 +74,7 @@ static DEFINE_SPINLOCK(pm_qos_lock);
 static struct pm_qos_object null_pm_qos;
 static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
 static struct pm_qos_object cpu_dma_pm_qos = {
-	.requests = PLIST_HEAD_INIT(cpu_dma_pm_qos.requests, pm_qos_lock),
+	.requests = PLIST_HEAD_INIT(cpu_dma_pm_qos.requests),
 	.notifiers = &cpu_dma_lat_notifier,
 	.name = "cpu_dma_latency",
 	.target_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
@@ -84,7 +84,7 @@ static struct pm_qos_object cpu_dma_pm_qos = {
 
 static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
 static struct pm_qos_object network_lat_pm_qos = {
-	.requests = PLIST_HEAD_INIT(network_lat_pm_qos.requests, pm_qos_lock),
+	.requests = PLIST_HEAD_INIT(network_lat_pm_qos.requests),
 	.notifiers = &network_lat_notifier,
 	.name = "network_latency",
 	.target_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
@@ -95,7 +95,7 @@ static struct pm_qos_object network_lat_pm_qos = {
 
 static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
 static struct pm_qos_object network_throughput_pm_qos = {
-	.requests = PLIST_HEAD_INIT(network_throughput_pm_qos.requests, pm_qos_lock),
+	.requests = PLIST_HEAD_INIT(network_throughput_pm_qos.requests),
 	.notifiers = &network_throughput_notifier,
 	.name = "network_throughput",
 	.target_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index ab44911..255e166 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -890,7 +890,7 @@ void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 {
 	lock->owner = NULL;
 	raw_spin_lock_init(&lock->wait_lock);
-	plist_head_init_raw(&lock->wait_list, &lock->wait_lock);
+	plist_head_init(&lock->wait_list);
 
 	debug_rt_mutex_init(lock, name);
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..71bc127 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7781,7 +7781,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
-	plist_head_init_raw(&rt_rq->pushable_tasks, &rq->lock);
+	plist_head_init(&rt_rq->pushable_tasks);
 #endif
 
 	rt_rq->rt_time = 0;
@@ -7986,7 +7986,7 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init_raw(&init_task.pi_waiters, &init_task.pi_lock);
+	plist_head_init(&init_task.pi_waiters);
 #endif
 
 	/*
diff --git a/lib/plist.c b/lib/plist.c
index 0ae7e64..a0a4da4 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -56,11 +56,6 @@ static void plist_check_list(struct list_head *top)
 
 static void plist_check_head(struct plist_head *head)
 {
-	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
-	if (head->rawlock)
-		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
-	if (head->spinlock)
-		WARN_ON_SMP(!spin_is_locked(head->spinlock));
 	if (!plist_head_empty(head))
 		plist_check_list(&plist_first(head)->prio_list);
 	plist_check_list(&head->node_list);
@@ -180,7 +175,7 @@ static int  __init plist_test(void)
 	unsigned int r = local_clock();
 
 	printk(KERN_INFO "start plist test\n");
-	plist_head_init(&test_head, NULL);
+	plist_head_init(&test_head);
 	for (i = 0; i < ARRAY_SIZE(test_node); i++)
 		plist_node_init(test_node + i, 0);
 

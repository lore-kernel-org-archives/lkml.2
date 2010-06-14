Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0FNVkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:46951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab0FNVjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:25 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/30] workqueue: kill RT workqueue
Date: Mon, 14 Jun 2010 23:37:20 +0200
Message-Id: <1276551467-21246-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With stop_machine() converted to use cpu_stop, RT workqueue doesn't
have any user left.  Kill RT workqueue support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   20 +++++++++-----------
 kernel/workqueue.c        |    6 ------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 9466e86..0697946 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -181,12 +181,11 @@ static inline void destroy_work_on_stack(struct work_struct *work) { }
 
 
 extern struct workqueue_struct *
-__create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, int rt, struct lock_class_key *key,
-		       const char *lock_name);
+__create_workqueue_key(const char *name, int singlethread, int freezeable,
+		       struct lock_class_key *key, const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
+#define __create_workqueue(name, singlethread, freezeable)	\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -197,19 +196,18 @@ __create_workqueue_key(const char *name, int singlethread,
 		__lock_name = #name;				\
 								\
 	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), (rt), &__key,	\
+			       (freezeable), &__key,		\
 			       __lock_name);			\
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
+#define __create_workqueue(name, singlethread, freezeable)	\
+	__create_workqueue_key((name), (singlethread), (freezeable), \
 			       NULL, NULL)
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
-#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
+#define create_workqueue(name) __create_workqueue((name), 0, 0)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
+#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 327d2de..1a47fbf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -62,7 +62,6 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
-	int rt;
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
@@ -947,7 +946,6 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct workqueue_struct *wq = cwq->wq;
 	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
@@ -963,8 +961,6 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	 */
 	if (IS_ERR(p))
 		return PTR_ERR(p);
-	if (cwq->wq->rt)
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
 	trace_workqueue_creation(cwq->thread, cpu);
@@ -986,7 +982,6 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
-						int rt,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -1008,7 +1003,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
-	wq->rt = rt;
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
-- 
1.6.4.2


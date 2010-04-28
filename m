Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0D1FaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 01:30:16 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:51602 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0D1FaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 01:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V/Lfb8rVWEM3b28YmTuBRyebzW76I6t2dsiabXy47h5Hi0ip8E+LXcXZwL92bOFNvj
         x7CCYk/6eTsPMU0U510neMTklz6lX0XyUDza0ZgBgXPOgNgaQJz0xbb3JbynlKzOAqXj
         z1MYxi2BSFVzlJd7gZQLTGNDMR6nt1JNd25Cw=
From: Changli Gao <xiaosuo@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [RFC] sched: implement the exclusive wait queue as a LIFO queue
Date: Wed, 28 Apr 2010 13:03:06 +0800
Message-Id: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

implement the exclusive wait queue as a LIFO queue

If the exclusive wait queue is also a LIFO queue as the normal wait queue, the
process who goes to sleep recently, will be woke up first. As its memory is
more likely in cache, we will get better performance. And when there are many
processes waiting on a exclusive wait queue, some of them may not be woke up,
if the others can handle the workload, and it will reduce the load of
the scheduler.

Note: before applying this patch, you need my previous patch patched first.
https://patchwork.kernel.org/patch/95600/

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/eventpoll.c       |    3 +--
 include/linux/wait.h |   17 +++++++----------
 kernel/sched.c       |    8 ++++----
 kernel/wait.c        |    9 +++------
 4 files changed, 15 insertions(+), 22 deletions(-)
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..e9b3ebe 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1140,8 +1140,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue(&ep->wq, &wait);
+		__add_wait_queue_ex(&ep->wq, &wait);
 
 		for (;;) {
 			/*
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..95c127d 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -30,8 +30,6 @@ typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, v
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
 struct __wait_queue {
-	unsigned int flags;
-#define WQ_FLAG_EXCLUSIVE	0x01
 	void *private;
 	wait_queue_func_t func;
 	struct list_head task_list;
@@ -50,6 +48,7 @@ struct wait_bit_queue {
 struct __wait_queue_head {
 	spinlock_t lock;
 	struct list_head task_list;
+	struct list_head task_list_ex;
 };
 typedef struct __wait_queue_head wait_queue_head_t;
 
@@ -69,7 +68,8 @@ struct task_struct;
 
 #define __WAIT_QUEUE_HEAD_INITIALIZER(name) {				\
 	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),		\
-	.task_list	= { &(name).task_list, &(name).task_list } }
+	.task_list	= { &(name).task_list, &(name).task_list },	\
+	.task_list_ex	= { &(name).task_list_ex, &(name).task_list_ex } }
 
 #define DECLARE_WAIT_QUEUE_HEAD(name) \
 	wait_queue_head_t name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
@@ -97,7 +97,6 @@ extern void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *)
 
 static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
 {
-	q->flags = 0;
 	q->private = p;
 	q->func = default_wake_function;
 }
@@ -105,14 +104,13 @@ static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
 static inline void init_waitqueue_func_entry(wait_queue_t *q,
 					wait_queue_func_t func)
 {
-	q->flags = 0;
 	q->private = NULL;
 	q->func = func;
 }
 
 static inline int waitqueue_active(wait_queue_head_t *q)
 {
-	return !list_empty(&q->task_list);
+	return !list_empty(&q->task_list) || !list_empty(&q->task_list);
 }
 
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
@@ -127,10 +125,10 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
-static inline void __add_wait_queue_tail(wait_queue_head_t *head,
+static inline void __add_wait_queue_ex(wait_queue_head_t *head,
 						wait_queue_t *new)
 {
-	list_add_tail(&new->task_list, &head->task_list);
+	list_add(&new->task_list, &head->task_list_ex);
 }
 
 static inline void __remove_wait_queue(wait_queue_head_t *head,
@@ -409,8 +407,7 @@ do {									\
 static inline void add_wait_queue_exclusive_locked(wait_queue_head_t *q,
 						   wait_queue_t * wait)
 {
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue_tail(q,  wait);
+	__add_wait_queue_ex(q,  wait);
 }
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index be5ab70..59b1534 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3903,11 +3903,11 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 {
 	wait_queue_t *curr, *next;
 
-	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
-		unsigned flags = curr->flags;
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list)
+		curr->func(curr, mode, wake_flags, key);
 
-		if (curr->func(curr, mode, wake_flags, key) &&
-				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
+	list_for_each_entry_safe(curr, next, &q->task_list_ex, task_list) {
+		if (curr->func(curr, mode, wake_flags, key) && !--nr_exclusive)
 			break;
 	}
 }
diff --git a/kernel/wait.c b/kernel/wait.c
index c4bd3d8..a0559df 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -15,6 +15,7 @@ void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
 	spin_lock_init(&q->lock);
 	lockdep_set_class(&q->lock, key);
 	INIT_LIST_HEAD(&q->task_list);
+	INIT_LIST_HEAD(&q->task_list_ex);
 }
 
 EXPORT_SYMBOL(__init_waitqueue_head);
@@ -23,7 +24,6 @@ void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
-	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	__add_wait_queue(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
@@ -34,9 +34,8 @@ void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
-	__add_wait_queue_tail(q, wait);
+	__add_wait_queue_ex(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive);
@@ -69,7 +68,6 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
 
-	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue(q, wait);
@@ -83,10 +81,9 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
 
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
-		__add_wait_queue_tail(q, wait);
+		__add_wait_queue_ex(q, wait);
 	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }

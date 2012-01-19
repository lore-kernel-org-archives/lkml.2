Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab2ASBOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:14:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34441 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab2ASBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:44 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] elevator: make elevator_init_fn() return 0/-errno
Date: Wed, 18 Jan 2012 17:11:22 -0800
Message-Id: <1326935490-11827-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326935490-11827-1-git-send-email-tj@kernel.org>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elevator_ops->elevator_init_fn() has a weird return value.  It returns
a void * which the caller should assign to q->elevator->elevator_data
and %NULL return denotes init failure.

Update such that it returns integer 0/-errno and sets elevator_data
directly as necessary.

This makes the interface more conventional and eases further cleanup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c      |    9 +++++----
 block/deadline-iosched.c |    8 +++++---
 block/elevator.c         |   12 ++----------
 block/noop-iosched.c     |    8 +++++---
 include/linux/elevator.h |    2 +-
 5 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5a2e670..fd39a44 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3661,7 +3661,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	kfree(cfqd);
 }
 
-static void *cfq_init_queue(struct request_queue *q)
+static int cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
 	int i, j;
@@ -3670,7 +3670,7 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
-		return NULL;
+		return -ENOMEM;
 
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
@@ -3697,7 +3697,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
 		kfree(cfqg);
 		kfree(cfqd);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	rcu_read_lock();
@@ -3728,6 +3728,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
 	cfqd->queue = q;
+	q->elevator->elevator_data = cfqd;
 
 	init_timer(&cfqd->idle_slice_timer);
 	cfqd->idle_slice_timer.function = cfq_idle_slice_timer;
@@ -3752,7 +3753,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	return cfqd;
+	return 0;
 }
 
 /*
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 7bf12d7..599b12e 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -337,13 +337,13 @@ static void deadline_exit_queue(struct elevator_queue *e)
 /*
  * initialize elevator private data (deadline_data).
  */
-static void *deadline_init_queue(struct request_queue *q)
+static int deadline_init_queue(struct request_queue *q)
 {
 	struct deadline_data *dd;
 
 	dd = kmalloc_node(sizeof(*dd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!dd)
-		return NULL;
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dd->fifo_list[READ]);
 	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
@@ -354,7 +354,9 @@ static void *deadline_init_queue(struct request_queue *q)
 	dd->writes_starved = writes_starved;
 	dd->front_merges = 1;
 	dd->fifo_batch = fifo_batch;
-	return dd;
+
+	q->elevator->elevator_data = dd;
+	return 0;
 }
 
 /*
diff --git a/block/elevator.c b/block/elevator.c
index 42543e3..8dc65b1 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -168,14 +168,6 @@ static struct elevator_type *elevator_get(const char *name)
 	return e;
 }
 
-static int elevator_init_queue(struct request_queue *q)
-{
-	q->elevator->elevator_data = q->elevator->type->ops.elevator_init_fn(q);
-	if (q->elevator->elevator_data)
-		return 0;
-	return -ENOMEM;
-}
-
 static char chosen_elevator[ELV_NAME_MAX];
 
 static int __init elevator_setup(char *str)
@@ -271,7 +263,7 @@ int elevator_init(struct request_queue *q, char *name)
 	if (!q->elevator)
 		return -ENOMEM;
 
-	err = elevator_init_queue(q);
+	err = e->ops.elevator_init_fn(q);
 	if (err) {
 		kobject_put(&q->elevator->kobj);
 		return err;
@@ -974,7 +966,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	if (!q->elevator)
 		goto fail_init;
 
-	err = elevator_init_queue(q);
+	err = new_e->ops.elevator_init_fn(q);
 	if (err) {
 		kobject_put(&q->elevator->kobj);
 		goto fail_init;
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 413a0b1..5d1bf70 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -59,15 +59,17 @@ noop_latter_request(struct request_queue *q, struct request *rq)
 	return list_entry(rq->queuelist.next, struct request, queuelist);
 }
 
-static void *noop_init_queue(struct request_queue *q)
+static int noop_init_queue(struct request_queue *q)
 {
 	struct noop_data *nd;
 
 	nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
 	if (!nd)
-		return NULL;
+		return -ENOMEM;
+
 	INIT_LIST_HEAD(&nd->queue);
-	return nd;
+	q->elevator->elevator_data = nd;
+	return 0;
 }
 
 static void noop_exit_queue(struct elevator_queue *e)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c24f3d7..d7726c9 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -33,7 +33,7 @@ typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
 
-typedef void *(elevator_init_fn) (struct request_queue *);
+typedef int (elevator_init_fn) (struct request_queue *);
 typedef void (elevator_exit_fn) (struct elevator_queue *);
 
 struct elevator_ops
-- 
1.7.7.3


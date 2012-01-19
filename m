Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2ASBLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:11:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40268 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2ASBLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:41 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/12] elevator: clear auxiliary data earlier during elevator switch
Date: Wed, 18 Jan 2012 17:11:21 -0800
Message-Id: <1326935490-11827-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326935490-11827-1-git-send-email-tj@kernel.org>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elevator switch tries hard to keep as much as context until new
elevator is ready so that it can revert to the original state if
initializing the new elevator fails for some reason.  Unfortunately,
with more auxiliary contexts to manage, this makes elevator init and
exit paths too complex and fragile.

This patch makes elevator_switch() unregister the current elevator and
flush icq's before start initializing the new one.  As we still keep
the old elevator itself, the only difference is that we lose icq's on
rare occassions of switching failure, which isn't critical at all.

Note that this makes explicit elevator parameter to
elevator_init_queue() and __elv_register_queue() unnecessary as they
always can use the current elevator.

This patch enables block cgroup cleanups.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator.c |   88 +++++++++++++++++++++++++++---------------------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 91e18f8..42543e3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -168,11 +168,10 @@ static struct elevator_type *elevator_get(const char *name)
 	return e;
 }
 
-static int elevator_init_queue(struct request_queue *q,
-			       struct elevator_queue *eq)
+static int elevator_init_queue(struct request_queue *q)
 {
-	eq->elevator_data = eq->type->ops.elevator_init_fn(q);
-	if (eq->elevator_data)
+	q->elevator->elevator_data = q->elevator->type->ops.elevator_init_fn(q);
+	if (q->elevator->elevator_data)
 		return 0;
 	return -ENOMEM;
 }
@@ -235,7 +234,6 @@ static void elevator_release(struct kobject *kobj)
 int elevator_init(struct request_queue *q, char *name)
 {
 	struct elevator_type *e = NULL;
-	struct elevator_queue *eq;
 	int err;
 
 	if (unlikely(q->elevator))
@@ -269,17 +267,16 @@ int elevator_init(struct request_queue *q, char *name)
 		}
 	}
 
-	eq = elevator_alloc(q, e);
-	if (!eq)
+	q->elevator = elevator_alloc(q, e);
+	if (!q->elevator)
 		return -ENOMEM;
 
-	err = elevator_init_queue(q, eq);
+	err = elevator_init_queue(q);
 	if (err) {
-		kobject_put(&eq->kobj);
+		kobject_put(&q->elevator->kobj);
 		return err;
 	}
 
-	q->elevator = eq;
 	return 0;
 }
 EXPORT_SYMBOL(elevator_init);
@@ -848,8 +845,9 @@ static struct kobj_type elv_ktype = {
 	.release	= elevator_release,
 };
 
-int __elv_register_queue(struct request_queue *q, struct elevator_queue *e)
+int elv_register_queue(struct request_queue *q)
 {
+	struct elevator_queue *e = q->elevator;
 	int error;
 
 	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
@@ -867,11 +865,6 @@ int __elv_register_queue(struct request_queue *q, struct elevator_queue *e)
 	}
 	return error;
 }
-
-int elv_register_queue(struct request_queue *q)
-{
-	return __elv_register_queue(q, q->elevator);
-}
 EXPORT_SYMBOL(elv_register_queue);
 
 void elv_unregister_queue(struct request_queue *q)
@@ -954,39 +947,47 @@ EXPORT_SYMBOL_GPL(elv_unregister);
  */
 static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 {
-	struct elevator_queue *old_elevator, *e;
+	struct elevator_queue *old = q->elevator;
+	bool registered = old->registered;
 	int err;
 
-	/* allocate new elevator */
-	e = elevator_alloc(q, new_e);
-	if (!e)
-		return -ENOMEM;
-
-	err = elevator_init_queue(q, e);
-	if (err) {
-		kobject_put(&e->kobj);
-		return err;
-	}
-
-	/* turn on BYPASS and drain all requests w/ elevator private data */
+	/*
+	 * Turn on BYPASS and drain all requests w/ elevator private data.
+	 * Block layer doesn't call into a quiesced elevator - all requests
+	 * are directly put on the dispatch list without elevator data
+	 * using INSERT_BACK.  All requests have SOFTBARRIER set and no
+	 * merge happens either.
+	 */
 	elv_quiesce_start(q);
 
-	/* unregister old queue, register new one and kill old elevator */
-	if (q->elevator->registered) {
+	/* unregister and clear all auxiliary data of the old elevator */
+	if (registered)
 		elv_unregister_queue(q);
-		err = __elv_register_queue(q, e);
-		if (err)
-			goto fail_register;
-	}
 
-	/* done, clear io_cq's, switch elevators and turn off BYPASS */
 	spin_lock_irq(q->queue_lock);
 	ioc_clear_queue(q);
-	old_elevator = q->elevator;
-	q->elevator = e;
 	spin_unlock_irq(q->queue_lock);
 
-	elevator_exit(old_elevator);
+	/* allocate, init and register new elevator */
+	err = -ENOMEM;
+	q->elevator = elevator_alloc(q, new_e);
+	if (!q->elevator)
+		goto fail_init;
+
+	err = elevator_init_queue(q);
+	if (err) {
+		kobject_put(&q->elevator->kobj);
+		goto fail_init;
+	}
+
+	if (registered) {
+		err = elv_register_queue(q);
+		if (err)
+			goto fail_register;
+	}
+
+	/* done, kill the old one and finish */
+	elevator_exit(old);
 	elv_quiesce_end(q);
 
 	blk_add_trace_msg(q, "elv switch: %s", e->type->elevator_name);
@@ -994,11 +995,10 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	return 0;
 
 fail_register:
-	/*
-	 * switch failed, exit the new io scheduler and reattach the old
-	 * one again (along with re-adding the sysfs dir)
-	 */
-	elevator_exit(e);
+	elevator_exit(q->elevator);
+fail_init:
+	/* switch failed, restore and re-register old elevator */
+	q->elevator = old;
 	elv_register_queue(q);
 	elv_quiesce_end(q);
 
-- 
1.7.7.3


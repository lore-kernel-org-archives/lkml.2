Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1J2Xt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63252 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1J2Xtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:55 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] block: reorder elevator switch sequence
Date: Sat, 29 Oct 2011 16:49:39 -0700
Message-Id: <1319932187-7631-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elevator switch sequence first attached the new elevator, then tried
registering it (sysfs) and if that failed attached back the old
elevator.  However, sysfs registration doesn't require the elevator to
be attached, so there is no reason to do the "detach, attach new,
register, maybe re-attach old" sequence.  It can just do "register,
detach, attach".

* elevator_init_queue() is updated to set ->elevator_data directly and
  return 0 / -errno.  This allows elevator_exit() on an unattached
  elevator.

* __elv_unregister_queue() which was necessary to unregister
  unattached q is removed in favor of __elv_register_queue() which can
  register unattached q.

* elevator_attach() becomes a single assignment and obscures more then
  it helps.  Dropped.

This will help cleaning up io_context handling across elevator switch.

This patch doesn't introduce visible behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/elevator.c |   91 ++++++++++++++++++++++--------------------------------
 1 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6a343e8..a16c2d1 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -168,17 +168,13 @@ static struct elevator_type *elevator_get(const char *name)
 	return e;
 }
 
-static void *elevator_init_queue(struct request_queue *q,
-				 struct elevator_queue *eq)
+static int elevator_init_queue(struct request_queue *q,
+			       struct elevator_queue *eq)
 {
-	return eq->ops->elevator_init_fn(q);
-}
-
-static void elevator_attach(struct request_queue *q, struct elevator_queue *eq,
-			   void *data)
-{
-	q->elevator = eq;
-	eq->elevator_data = data;
+	eq->elevator_data = eq->ops->elevator_init_fn(q);
+	if (eq->elevator_data)
+		return 0;
+	return -ENOMEM;
 }
 
 static char chosen_elevator[ELV_NAME_MAX];
@@ -241,7 +237,7 @@ int elevator_init(struct request_queue *q, char *name)
 {
 	struct elevator_type *e = NULL;
 	struct elevator_queue *eq;
-	void *data;
+	int err;
 
 	if (unlikely(q->elevator))
 		return 0;
@@ -278,13 +274,13 @@ int elevator_init(struct request_queue *q, char *name)
 	if (!eq)
 		return -ENOMEM;
 
-	data = elevator_init_queue(q, eq);
-	if (!data) {
+	err = elevator_init_queue(q, eq);
+	if (err) {
 		kobject_put(&eq->kobj);
-		return -ENOMEM;
+		return err;
 	}
 
-	elevator_attach(q, eq, data);
+	q->elevator = eq;
 	return 0;
 }
 EXPORT_SYMBOL(elevator_init);
@@ -856,9 +852,8 @@ static struct kobj_type elv_ktype = {
 	.release	= elevator_release,
 };
 
-int elv_register_queue(struct request_queue *q)
+int __elv_register_queue(struct request_queue *q, struct elevator_queue *e)
 {
-	struct elevator_queue *e = q->elevator;
 	int error;
 
 	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
@@ -876,19 +871,22 @@ int elv_register_queue(struct request_queue *q)
 	}
 	return error;
 }
-EXPORT_SYMBOL(elv_register_queue);
 
-static void __elv_unregister_queue(struct elevator_queue *e)
+int elv_register_queue(struct request_queue *q)
 {
-	kobject_uevent(&e->kobj, KOBJ_REMOVE);
-	kobject_del(&e->kobj);
-	e->registered = 0;
+	return __elv_register_queue(q, q->elevator);
 }
+EXPORT_SYMBOL(elv_register_queue);
 
 void elv_unregister_queue(struct request_queue *q)
 {
-	if (q)
-		__elv_unregister_queue(q->elevator);
+	if (q) {
+		struct elevator_queue *e = q->elevator;
+
+		kobject_uevent(&e->kobj, KOBJ_REMOVE);
+		kobject_del(&e->kobj);
+		e->registered = 0;
+	}
 }
 EXPORT_SYMBOL(elv_unregister_queue);
 
@@ -928,50 +926,36 @@ EXPORT_SYMBOL_GPL(elv_unregister);
 static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 {
 	struct elevator_queue *old_elevator, *e;
-	void *data;
 	int err;
 
-	/*
-	 * Allocate new elevator
-	 */
+	/* allocate new elevator */
 	e = elevator_alloc(q, new_e);
 	if (!e)
 		return -ENOMEM;
 
-	data = elevator_init_queue(q, e);
-	if (!data) {
+	err = elevator_init_queue(q, e);
+	if (err) {
 		kobject_put(&e->kobj);
-		return -ENOMEM;
+		return err;
 	}
 
-	/*
-	 * Turn on BYPASS and drain all requests w/ elevator private data
-	 */
+	/* turn on BYPASS and drain all requests w/ elevator private data */
 	elv_quiesce_start(q);
 
-	/*
-	 * Remember old elevator.
-	 */
-	old_elevator = q->elevator;
-
-	/*
-	 * attach and start new elevator
-	 */
-	spin_lock_irq(q->queue_lock);
-	elevator_attach(q, e, data);
-	spin_unlock_irq(q->queue_lock);
-
-	if (old_elevator->registered) {
-		__elv_unregister_queue(old_elevator);
-
-		err = elv_register_queue(q);
+	/* unregister old queue, register new one and kill old elevator */
+	if (q->elevator->registered) {
+		elv_unregister_queue(q);
+		err = __elv_register_queue(q, e);
 		if (err)
 			goto fail_register;
 	}
 
-	/*
-	 * finally exit old elevator and turn off BYPASS.
-	 */
+	/* done, replace the old one with new one and turn off BYPASS */
+	spin_lock_irq(q->queue_lock);
+	old_elevator = q->elevator;
+	q->elevator = e;
+	spin_unlock_irq(q->queue_lock);
+
 	elevator_exit(old_elevator);
 	elv_quiesce_end(q);
 
@@ -985,7 +969,6 @@ fail_register:
 	 * one again (along with re-adding the sysfs dir)
 	 */
 	elevator_exit(e);
-	q->elevator = old_elevator;
 	elv_register_queue(q);
 	elv_quiesce_end(q);
 
-- 
1.7.3.1


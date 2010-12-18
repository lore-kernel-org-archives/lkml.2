Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0LRNKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 08:10:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42557 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab0LRNKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 08:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hh5rpJTEdgtvk/AKTum6Frbvew3NGQir6uUYiw46btNL1/rL7f08dgmv2oZFlvwv9E
         77DNROHIDqNTgcu6/Ab/nWJ6hzhHJCwglJjYT/90K3gJAp3xZW5gQIMAjuERbTKATgE/
         gLsfK8+zT28PsvPbtfrvadK0zdp4QZwbH+bdI=
MIME-Version: 1.0
Date: Sat, 18 Dec 2010 21:10:18 +0800
Message-ID: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
Subject: [PATCH] replace ida in workqueue with page-sized buffer
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The id of worker of global work queue is monitored with kernel library, ida.

The ida in global work queue is redefined to be page-sized buffer,
which is allocated when initializing workqueue.

The new id allocator could monitor ids in the rage from 0 to INT_MAX.
The buffer is used to store freed ids, and if the peak number of ids,
in workqueue as whole, is not out of the capacity of the allocated
buffer, there is no more allocation of buffer after initializing.

The advantage looks that the new allocator runs faster.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/workqueue.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/workqueue.c	2010-12-18 20:34:48.000000000 +0800
@@ -40,7 +40,6 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#include <linux/idr.h>

 #include "workqueue_sched.h"

@@ -137,6 +136,13 @@ struct worker {
 	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
 };

+struct ida_s {
+	int	id;
+	int	freed;
+	int	alloc;
+	int	*buf;
+};
+
 /*
  * Global per-cpu workqueue.  There's one and only one for each cpu
  * and all works are queued and processed here regardless of their
@@ -159,7 +165,7 @@ struct global_cwq {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */

-	struct ida		worker_ida;	/* L: for worker IDs */
+	struct ida_s		worker_ida;	/* L: for worker IDs */

 	struct task_struct	*trustee;	/* L: for gcwq shutdown */
 	unsigned int		trustee_state;	/* L: trustee state */
@@ -1280,6 +1286,34 @@ static struct worker *alloc_worker(void)
 	return worker;
 }

+static inline void ida_free_id(struct ida_s *ida, int id)
+{
+	if (id == ida->id -1)
+		ida->id--;
+	else if (ida->freed < ida->alloc) {
+		ida->buf[ida->freed] = id;
+		ida->freed++;
+	}
+}
+
+static inline int ida_alloc_id(struct ida_s *ida)
+{
+	int id;
+
+	if (ida->freed) {
+		ida->freed--;
+		return ida->buf[ida->freed];
+	}
+
+	id = ida->id;
+	if (id < INT_MAX)
+		ida->id++;
+	else
+		id = -ENOSPC;
+
+	return id;
+}
+
 /**
  * create_worker - create a new workqueue worker
  * @gcwq: gcwq the new worker will belong to
@@ -1302,14 +1336,12 @@ static struct worker *create_worker(stru
 	int id = -1;

 	spin_lock_irq(&gcwq->lock);
-	while (ida_get_new(&gcwq->worker_ida, &id)) {
-		spin_unlock_irq(&gcwq->lock);
-		if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))
-			goto fail;
-		spin_lock_irq(&gcwq->lock);
-	}
+	id = ida_alloc_id(&gcwq->worker_ida);
 	spin_unlock_irq(&gcwq->lock);

+	if (id < 0)
+		return NULL;
+
 	worker = alloc_worker();
 	if (!worker)
 		goto fail;
@@ -1343,7 +1375,7 @@ static struct worker *create_worker(stru
 fail:
 	if (id >= 0) {
 		spin_lock_irq(&gcwq->lock);
-		ida_remove(&gcwq->worker_ida, id);
+		ida_free_id(&gcwq->worker_ida, id);
 		spin_unlock_irq(&gcwq->lock);
 	}
 	kfree(worker);
@@ -1399,7 +1431,7 @@ static void destroy_worker(struct worker
 	kfree(worker);

 	spin_lock_irq(&gcwq->lock);
-	ida_remove(&gcwq->worker_ida, id);
+	ida_free_id(&gcwq->worker_ida, id);
 }

 static void idle_worker_timeout(unsigned long __gcwq)
@@ -3640,6 +3672,18 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */

+static int __init init_ida(struct ida_s *ida, int pages)
+{
+	ida->buf = kzalloc(pages * PAGE_SIZE, GFP_KERNEL);
+	if (! ida->buf)
+		return -ENOMEM;
+
+	ida->alloc = (pages * PAGE_SIZE) / sizeof(int);
+	ida->freed = 0;
+	ida->id = 0;
+	return 0;
+}
+
 static int __init init_workqueues(void)
 {
 	unsigned int cpu;
@@ -3667,7 +3711,7 @@ static int __init init_workqueues(void)
 		setup_timer(&gcwq->mayday_timer, gcwq_mayday_timeout,
 			    (unsigned long)gcwq);

-		ida_init(&gcwq->worker_ida);
+		BUG_ON(0 != init_ida(&gcwq->worker_ida, 1));

 		gcwq->trustee_state = TRUSTEE_DONE;
 		init_waitqueue_head(&gcwq->trustee_wait);

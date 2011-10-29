Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab1J2XvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:51:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840Ab1J2XuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:50:02 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] block, cfq: move icq cache management to block core
Date: Sat, 29 Oct 2011 16:49:44 -0700
Message-Id: <1319932187-7631-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let elevators set ->icq_size and ->icq_align in elevator_type and
elv_register() and elv_unregister() respectively create and destroy
kmem_cache for icq.

* elv_register() now can return failure.  All callers updated.

* icq caches are automatically named "ELVNAME_io_cq".

* cfq_slab_setup/kill() are collapsed into cfq_init/exit().

* While at it, minor indentation change for iosched_cfq.elevator_name
  for consistency.

This will help moving icq management to block core.  This doesn't
introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c      |   48 ++++++++++++++-------------------------------
 block/deadline-iosched.c |    4 +--
 block/elevator.c         |   37 +++++++++++++++++++++++++++++++++-
 block/noop-iosched.c     |    4 +--
 include/linux/elevator.h |   11 +++++++++-
 5 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 048fa69..06e59ab 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3914,34 +3914,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	return cfqd;
 }
 
-static void cfq_slab_kill(void)
-{
-	/*
-	 * Caller already ensured that pending RCU callbacks are completed,
-	 * so we should have no busy allocations at this point.
-	 */
-	if (cfq_pool)
-		kmem_cache_destroy(cfq_pool);
-	if (cfq_icq_pool)
-		kmem_cache_destroy(cfq_icq_pool);
-}
-
-static int __init cfq_slab_setup(void)
-{
-	cfq_pool = KMEM_CACHE(cfq_queue, 0);
-	if (!cfq_pool)
-		goto fail;
-
-	cfq_icq_pool = KMEM_CACHE(cfq_io_cq, 0);
-	if (!cfq_icq_pool)
-		goto fail;
-
-	return 0;
-fail:
-	cfq_slab_kill();
-	return -ENOMEM;
-}
-
 /*
  * sysfs parts below -->
  */
@@ -4053,8 +4025,10 @@ static struct elevator_type iosched_cfq = {
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
 	},
+	.icq_size	=	sizeof(struct cfq_io_cq),
+	.icq_align	=	__alignof__(struct cfq_io_cq),
 	.elevator_attrs =	cfq_attrs,
-	.elevator_name =	"cfq",
+	.elevator_name	=	"cfq",
 	.elevator_owner =	THIS_MODULE,
 };
 
@@ -4072,6 +4046,8 @@ static struct blkio_policy_type blkio_policy_cfq;
 
 static int __init cfq_init(void)
 {
+	int ret;
+
 	/*
 	 * could be 0 on HZ < 1000 setups
 	 */
@@ -4086,10 +4062,17 @@ static int __init cfq_init(void)
 #else
 		cfq_group_idle = 0;
 #endif
-	if (cfq_slab_setup())
+	cfq_pool = KMEM_CACHE(cfq_queue, 0);
+	if (!cfq_pool)
 		return -ENOMEM;
 
-	elv_register(&iosched_cfq);
+	ret = elv_register(&iosched_cfq);
+	if (ret) {
+		kmem_cache_destroy(cfq_pool);
+		return ret;
+	}
+	cfq_icq_pool = iosched_cfq.icq_cache;
+
 	blkio_policy_register(&blkio_policy_cfq);
 
 	return 0;
@@ -4099,8 +4082,7 @@ static void __exit cfq_exit(void)
 {
 	blkio_policy_unregister(&blkio_policy_cfq);
 	elv_unregister(&iosched_cfq);
-	rcu_barrier();	/* make sure all cic RCU frees are complete */
-	cfq_slab_kill();
+	kmem_cache_destroy(cfq_pool);
 }
 
 module_init(cfq_init);
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index c644137..7bf12d7 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -448,9 +448,7 @@ static struct elevator_type iosched_deadline = {
 
 static int __init deadline_init(void)
 {
-	elv_register(&iosched_deadline);
-
-	return 0;
+	return elv_register(&iosched_deadline);
 }
 
 static void __exit deadline_exit(void)
diff --git a/block/elevator.c b/block/elevator.c
index c5c6214..cca049f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -886,15 +886,36 @@ void elv_unregister_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(elv_unregister_queue);
 
-void elv_register(struct elevator_type *e)
+int elv_register(struct elevator_type *e)
 {
 	char *def = "";
 
+	/* create icq_cache if requested */
+	if (e->icq_size) {
+		if (WARN_ON(e->icq_size < sizeof(struct io_cq)) ||
+		    WARN_ON(e->icq_align < __alignof__(struct io_cq)))
+			return -EINVAL;
+
+		snprintf(e->icq_cache_name, sizeof(e->icq_cache_name),
+			 "%s_io_cq", e->elevator_name);
+		e->icq_cache = kmem_cache_create(e->icq_cache_name, e->icq_size,
+						 e->icq_align, 0, NULL);
+		if (!e->icq_cache)
+			return -ENOMEM;
+	}
+
+	/* register, don't allow duplicate names */
 	spin_lock(&elv_list_lock);
-	BUG_ON(elevator_find(e->elevator_name));
+	if (elevator_find(e->elevator_name)) {
+		spin_unlock(&elv_list_lock);
+		if (e->icq_cache)
+			kmem_cache_destroy(e->icq_cache);
+		return -EBUSY;
+	}
 	list_add_tail(&e->list, &elv_list);
 	spin_unlock(&elv_list_lock);
 
+	/* print pretty message */
 	if (!strcmp(e->elevator_name, chosen_elevator) ||
 			(!*chosen_elevator &&
 			 !strcmp(e->elevator_name, CONFIG_DEFAULT_IOSCHED)))
@@ -902,14 +923,26 @@ void elv_register(struct elevator_type *e)
 
 	printk(KERN_INFO "io scheduler %s registered%s\n", e->elevator_name,
 								def);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(elv_register);
 
 void elv_unregister(struct elevator_type *e)
 {
+	/* unregister */
 	spin_lock(&elv_list_lock);
 	list_del_init(&e->list);
 	spin_unlock(&elv_list_lock);
+
+	/*
+	 * Destroy icq_cache if it exists.  icq's are RCU managed.  Make
+	 * sure all RCU operations are complete before proceeding.
+	 */
+	if (e->icq_cache) {
+		rcu_barrier();
+		kmem_cache_destroy(e->icq_cache);
+		e->icq_cache = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(elv_unregister);
 
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 06389e9..413a0b1 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -94,9 +94,7 @@ static struct elevator_type elevator_noop = {
 
 static int __init noop_init(void)
 {
-	elv_register(&elevator_noop);
-
-	return 0;
+	return elv_register(&elevator_noop);
 }
 
 static void __exit noop_exit(void)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 04958ef..d3d3e28 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -78,10 +78,19 @@ struct elv_fs_entry {
  */
 struct elevator_type
 {
+	/* managed by elevator core */
+	struct kmem_cache *icq_cache;
+
+	/* fields provided by elevator implementation */
 	struct elevator_ops ops;
+	size_t icq_size;
+	size_t icq_align;
 	struct elv_fs_entry *elevator_attrs;
 	char elevator_name[ELV_NAME_MAX];
 	struct module *elevator_owner;
+
+	/* managed by elevator core */
+	char icq_cache_name[ELV_NAME_MAX + 5];	/* elvname + "_io_cq" */
 	struct list_head list;
 };
 
@@ -127,7 +136,7 @@ extern void elv_drain_elevator(struct request_queue *);
 /*
  * io scheduler registration
  */
-extern void elv_register(struct elevator_type *);
+extern int elv_register(struct elevator_type *);
 extern void elv_unregister(struct elevator_type *);
 
 /*
-- 
1.7.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622Ab0GTUgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:36:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:38637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758680Ab0GTUfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:35:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] fscache: convert object to use workqueue instead of slow-work
Date: Tue, 20 Jul 2010 22:34:56 +0200
Message-Id: <1279658102-20069-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279658102-20069-1-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 20:35:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make fscache object state transition callbacks use workqueue instead
of slow-work.  New dedicated unbound CPU workqueue fscache_object_wq
is created.  get/put callbacks are renamed and modified to take
@object and called directly from the enqueue wrapper and the work
function.  While at it, make all open coded instances of get/put to
use fscache_get/put_object().

* Unbound workqueue is used.

* work_busy() output is printed instead of slow-work flags in object
  debugging outputs.  They mean basically the same thing bit-for-bit.

* sysctl fscache.object_max_active added to control concurrency.  The
  default value is nr_cpus clamped between 4 and
  WQ_UNBOUND_MAX_ACTIVE.

* slow_work_sleep_till_thread_needed() is replaced with fscache
  private implementation fscache_object_sleep_till_congested() which
  waits on fscache_object_wq congestion.

* debugfs support is dropped for now.  Tracing API based debug
  facility is planned to be added.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
---
 Documentation/filesystems/caching/fscache.txt |   10 +-
 fs/cachefiles/namei.c                         |   13 ++--
 fs/fscache/internal.h                         |    7 ++
 fs/fscache/main.c                             |   76 ++++++++++++++++++
 fs/fscache/object-list.c                      |   11 +--
 fs/fscache/object.c                           |  106 ++++++++++++------------
 include/linux/fscache-cache.h                 |    9 ++-
 7 files changed, 158 insertions(+), 74 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index a91e2e2..770267a 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -343,8 +343,8 @@ This will look something like:
 	[root@andromeda ~]# head /proc/fs/fscache/objects
 	OBJECT   PARENT   STAT CHLDN OPS OOP IPR EX READS EM EV F S | NETFS_COOKIE_DEF TY FL NETFS_DATA       OBJECT_KEY, AUX_DATA
 	======== ======== ==== ===== === === === == ===== == == = = | ================ == == ================ ================
-	   17e4b        2 ACTV     0   0   0   0  0     0 7b  4 0 8 | NFS.fh           DT  0 ffff88001dd82820 010006017edcf8bbc93b43298fdfbe71e50b57b13a172c0117f38472, e567634700000000000000000000000063f2404a000000000000000000000000c9030000000000000000000063f2404a
-	   1693a        2 ACTV     0   0   0   0  0     0 7b  4 0 8 | NFS.fh           DT  0 ffff88002db23380 010006017edcf8bbc93b43298fdfbe71e50b57b1e0162c01a2df0ea6, 420ebc4a000000000000000000000000420ebc4a0000000000000000000000000e1801000000000000000000420ebc4a
+	   17e4b        2 ACTV     0   0   0   0  0     0 7b  4 0 0 | NFS.fh           DT  0 ffff88001dd82820 010006017edcf8bbc93b43298fdfbe71e50b57b13a172c0117f38472, e567634700000000000000000000000063f2404a000000000000000000000000c9030000000000000000000063f2404a
+	   1693a        2 ACTV     0   0   0   0  0     0 7b  4 0 0 | NFS.fh           DT  0 ffff88002db23380 010006017edcf8bbc93b43298fdfbe71e50b57b1e0162c01a2df0ea6, 420ebc4a000000000000000000000000420ebc4a0000000000000000000000000e1801000000000000000000420ebc4a
 
 where the first set of columns before the '|' describe the object:
 
@@ -362,7 +362,7 @@ where the first set of columns before the '|' describe the object:
 	EM	Object's event mask
 	EV	Events raised on this object
 	F	Object flags
-	S	Object slow-work work item flags
+	S	Object work item busy state mask (1:pending 2:running)
 
 and the second set of columns describe the object's cookie, if present:
 
@@ -395,8 +395,8 @@ and the following paired letters:
 	w	Show objects that don't have pending writes
 	R	Show objects that have outstanding reads
 	r	Show objects that don't have outstanding reads
-	S	Show objects that have slow work queued
-	s	Show objects that don't have slow work queued
+	S	Show objects that have work queued
+	s	Show objects that don't have work queued
 
 If neither side of a letter pair is given, then both are implied.  For example:
 
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index f4a7840..42c7faf 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -37,9 +37,9 @@ void __cachefiles_printk_object(struct cachefiles_object *object,
 
 	printk(KERN_ERR "%sobject: OBJ%x\n",
 	       prefix, object->fscache.debug_id);
-	printk(KERN_ERR "%sobjstate=%s fl=%lx swfl=%lx ev=%lx[%lx]\n",
+	printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
 	       prefix, fscache_object_states[object->fscache.state],
-	       object->fscache.flags, object->fscache.work.flags,
+	       object->fscache.flags, work_busy(&object->fscache.work),
 	       object->fscache.events,
 	       object->fscache.event_mask & FSCACHE_OBJECT_EVENTS_MASK);
 	printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
@@ -212,7 +212,7 @@ wait_for_old_object:
 
 		/* if the object we're waiting for is queued for processing,
 		 * then just put ourselves on the queue behind it */
-		if (slow_work_is_queued(&xobject->fscache.work)) {
+		if (work_pending(&xobject->fscache.work)) {
 			_debug("queue OBJ%x behind OBJ%x immediately",
 			       object->fscache.debug_id,
 			       xobject->fscache.debug_id);
@@ -220,8 +220,7 @@ wait_for_old_object:
 		}
 
 		/* otherwise we sleep until either the object we're waiting for
-		 * is done, or the slow-work facility wants the thread back to
-		 * do other work */
+		 * is done, or the fscache_object is congested */
 		wq = bit_waitqueue(&xobject->flags, CACHEFILES_OBJECT_ACTIVE);
 		init_wait(&wait);
 		requeue = false;
@@ -229,8 +228,8 @@ wait_for_old_object:
 			prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
 			if (!test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags))
 				break;
-			requeue = slow_work_sleep_till_thread_needed(
-				&object->fscache.work, &timeout);
+
+			requeue = fscache_object_sleep_till_congested(&timeout);
 		} while (timeout > 0 && !requeue);
 		finish_wait(wq, &wait);
 
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index edd7434..6e0b5fb 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -82,6 +82,13 @@ extern unsigned fscache_defer_lookup;
 extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
+extern struct workqueue_struct *fscache_object_wq;
+DECLARE_PER_CPU(wait_queue_head_t, fscache_object_cong_wait);
+
+static inline bool fscache_object_congested(void)
+{
+	return workqueue_congested(WORK_CPU_UNBOUND, fscache_object_wq);
+}
 
 extern int fscache_wait_bit(void *);
 extern int fscache_wait_bit_interruptible(void *);
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index add6bdb..bb8d4c3 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/completion.h>
 #include <linux/slab.h>
+#include <linux/seq_file.h>
 #include "internal.h"
 
 MODULE_DESCRIPTION("FS Cache Manager");
@@ -40,22 +41,89 @@ MODULE_PARM_DESC(fscache_debug,
 		 "FS-Cache debugging mask");
 
 struct kobject *fscache_root;
+struct workqueue_struct *fscache_object_wq;
+
+DEFINE_PER_CPU(wait_queue_head_t, fscache_object_cong_wait);
+
+/* these values serve as lower bounds, will be adjusted in fscache_init() */
+static unsigned fscache_object_max_active = 4;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *fscache_sysctl_header;
+
+static int fscache_max_active_sysctl(struct ctl_table *table, int write,
+				     void __user *buffer,
+				     size_t *lenp, loff_t *ppos)
+{
+	struct workqueue_struct **wqp = table->extra1;
+	unsigned int *datap = table->data;
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret == 0)
+		workqueue_set_max_active(*wqp, *datap);
+	return ret;
+}
+
+ctl_table fscache_sysctls[] = {
+	{
+		.procname	= "object_max_active",
+		.data		= &fscache_object_max_active,
+		.maxlen		= sizeof(unsigned),
+		.mode		= 0644,
+		.proc_handler	= fscache_max_active_sysctl,
+		.extra1		= &fscache_object_wq,
+	},
+	{}
+};
+
+ctl_table fscache_sysctls_root[] = {
+	{
+		.procname	= "fscache",
+		.mode		= 0555,
+		.child		= fscache_sysctls,
+	},
+	{}
+};
+#endif
 
 /*
  * initialise the fs caching module
  */
 static int __init fscache_init(void)
 {
+	unsigned int nr_cpus = num_possible_cpus();
+	unsigned int cpu;
 	int ret;
 
 	ret = slow_work_register_user(THIS_MODULE);
 	if (ret < 0)
 		goto error_slow_work;
 
+	fscache_object_max_active =
+		clamp_val(nr_cpus,
+			  fscache_object_max_active, WQ_UNBOUND_MAX_ACTIVE);
+
+	ret = -ENOMEM;
+	fscache_object_wq = alloc_workqueue("fscache_object", WQ_UNBOUND,
+					    fscache_object_max_active);
+	if (!fscache_object_wq)
+		goto error_object_wq;
+
+	for_each_possible_cpu(cpu)
+		init_waitqueue_head(&per_cpu(fscache_object_cong_wait, cpu));
+
 	ret = fscache_proc_init();
 	if (ret < 0)
 		goto error_proc;
 
+#ifdef CONFIG_SYSCTL
+	ret = -ENOMEM;
+	fscache_sysctl_header = register_sysctl_table(fscache_sysctls_root);
+	if (!fscache_sysctl_header)
+		goto error_sysctl;
+#endif
+
 	fscache_cookie_jar = kmem_cache_create("fscache_cookie_jar",
 					       sizeof(struct fscache_cookie),
 					       0,
@@ -78,8 +146,14 @@ static int __init fscache_init(void)
 error_kobj:
 	kmem_cache_destroy(fscache_cookie_jar);
 error_cookie_jar:
+#ifdef CONFIG_SYSCTL
+	unregister_sysctl_table(fscache_sysctl_header);
+error_sysctl:
+#endif
 	fscache_proc_cleanup();
 error_proc:
+	destroy_workqueue(fscache_object_wq);
+error_object_wq:
 	slow_work_unregister_user(THIS_MODULE);
 error_slow_work:
 	return ret;
@@ -96,7 +170,9 @@ static void __exit fscache_exit(void)
 
 	kobject_put(fscache_root);
 	kmem_cache_destroy(fscache_cookie_jar);
+	unregister_sysctl_table(fscache_sysctl_header);
 	fscache_proc_cleanup();
+	destroy_workqueue(fscache_object_wq);
 	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index 4a8eb31..ebe29c5 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -34,8 +34,8 @@ struct fscache_objlist_data {
 #define FSCACHE_OBJLIST_CONFIG_NOREADS	0x00000200	/* show objects without active reads */
 #define FSCACHE_OBJLIST_CONFIG_EVENTS	0x00000400	/* show objects with events */
 #define FSCACHE_OBJLIST_CONFIG_NOEVENTS	0x00000800	/* show objects without no events */
-#define FSCACHE_OBJLIST_CONFIG_WORK	0x00001000	/* show objects with slow work */
-#define FSCACHE_OBJLIST_CONFIG_NOWORK	0x00002000	/* show objects without slow work */
+#define FSCACHE_OBJLIST_CONFIG_WORK	0x00001000	/* show objects with work */
+#define FSCACHE_OBJLIST_CONFIG_NOWORK	0x00002000	/* show objects without work */
 
 	u8		buf[512];	/* key and aux data buffer */
 };
@@ -231,12 +231,11 @@ static int fscache_objlist_show(struct seq_file *m, void *v)
 		       READS, NOREADS);
 		FILTER(obj->events & obj->event_mask,
 		       EVENTS, NOEVENTS);
-		FILTER(obj->work.flags & ~(1UL << SLOW_WORK_VERY_SLOW),
-		       WORK, NOWORK);
+		FILTER(work_busy(&obj->work), WORK, NOWORK);
 	}
 
 	seq_printf(m,
-		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx %1lx | ",
+		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx %1x | ",
 		   obj->debug_id,
 		   obj->parent ? obj->parent->debug_id : -1,
 		   fscache_object_states_short[obj->state],
@@ -249,7 +248,7 @@ static int fscache_objlist_show(struct seq_file *m, void *v)
 		   obj->event_mask & FSCACHE_OBJECT_EVENTS_MASK,
 		   obj->events,
 		   obj->flags,
-		   obj->work.flags);
+		   work_busy(&obj->work));
 
 	no_cookie = true;
 	keylen = auxlen = 0;
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 0b589a9..b6b897c 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -14,7 +14,6 @@
 
 #define FSCACHE_DEBUG_LEVEL COOKIE
 #include <linux/module.h>
-#include <linux/seq_file.h>
 #include "internal.h"
 
 const char *fscache_object_states[FSCACHE_OBJECT__NSTATES] = {
@@ -50,12 +49,8 @@ const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5] = {
 	[FSCACHE_OBJECT_DEAD]		= "DEAD",
 };
 
-static void fscache_object_slow_work_put_ref(struct slow_work *);
-static int  fscache_object_slow_work_get_ref(struct slow_work *);
-static void fscache_object_slow_work_execute(struct slow_work *);
-#ifdef CONFIG_SLOW_WORK_DEBUG
-static void fscache_object_slow_work_desc(struct slow_work *, struct seq_file *);
-#endif
+static int  fscache_get_object(struct fscache_object *);
+static void fscache_put_object(struct fscache_object *);
 static void fscache_initialise_object(struct fscache_object *);
 static void fscache_lookup_object(struct fscache_object *);
 static void fscache_object_available(struct fscache_object *);
@@ -64,17 +59,6 @@ static void fscache_withdraw_object(struct fscache_object *);
 static void fscache_enqueue_dependents(struct fscache_object *);
 static void fscache_dequeue_object(struct fscache_object *);
 
-const struct slow_work_ops fscache_object_slow_work_ops = {
-	.owner		= THIS_MODULE,
-	.get_ref	= fscache_object_slow_work_get_ref,
-	.put_ref	= fscache_object_slow_work_put_ref,
-	.execute	= fscache_object_slow_work_execute,
-#ifdef CONFIG_SLOW_WORK_DEBUG
-	.desc		= fscache_object_slow_work_desc,
-#endif
-};
-EXPORT_SYMBOL(fscache_object_slow_work_ops);
-
 /*
  * we need to notify the parent when an op completes that we had outstanding
  * upon it
@@ -345,7 +329,7 @@ unsupported_event:
 /*
  * execute an object
  */
-static void fscache_object_slow_work_execute(struct slow_work *work)
+void fscache_object_work_func(struct work_struct *work)
 {
 	struct fscache_object *object =
 		container_of(work, struct fscache_object, work);
@@ -359,23 +343,9 @@ static void fscache_object_slow_work_execute(struct slow_work *work)
 	if (object->events & object->event_mask)
 		fscache_enqueue_object(object);
 	clear_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	fscache_put_object(object);
 }
-
-/*
- * describe an object for slow-work debugging
- */
-#ifdef CONFIG_SLOW_WORK_DEBUG
-static void fscache_object_slow_work_desc(struct slow_work *work,
-					  struct seq_file *m)
-{
-	struct fscache_object *object =
-		container_of(work, struct fscache_object, work);
-
-	seq_printf(m, "FSC: OBJ%x: %s",
-		   object->debug_id,
-		   fscache_object_states_short[object->state]);
-}
-#endif
+EXPORT_SYMBOL(fscache_object_work_func);
 
 /*
  * initialise an object
@@ -393,7 +363,6 @@ static void fscache_initialise_object(struct fscache_object *object)
 	_enter("");
 	ASSERT(object->cookie != NULL);
 	ASSERT(object->cookie->parent != NULL);
-	ASSERT(list_empty(&object->work.link));
 
 	if (object->events & ((1 << FSCACHE_OBJECT_EV_ERROR) |
 			      (1 << FSCACHE_OBJECT_EV_RELEASE) |
@@ -671,10 +640,8 @@ static void fscache_drop_object(struct fscache_object *object)
 		object->parent = NULL;
 	}
 
-	/* this just shifts the object release to the slow work processor */
-	fscache_stat(&fscache_n_cop_put_object);
-	object->cache->ops->put_object(object);
-	fscache_stat_d(&fscache_n_cop_put_object);
+	/* this just shifts the object release to the work processor */
+	fscache_put_object(object);
 
 	_leave("");
 }
@@ -758,12 +725,10 @@ void fscache_withdrawing_object(struct fscache_cache *cache,
 }
 
 /*
- * allow the slow work item processor to get a ref on an object
+ * get a ref on an object
  */
-static int fscache_object_slow_work_get_ref(struct slow_work *work)
+static int fscache_get_object(struct fscache_object *object)
 {
-	struct fscache_object *object =
-		container_of(work, struct fscache_object, work);
 	int ret;
 
 	fscache_stat(&fscache_n_cop_grab_object);
@@ -773,13 +738,10 @@ static int fscache_object_slow_work_get_ref(struct slow_work *work)
 }
 
 /*
- * allow the slow work item processor to discard a ref on a work item
+ * discard a ref on a work item
  */
-static void fscache_object_slow_work_put_ref(struct slow_work *work)
+static void fscache_put_object(struct fscache_object *object)
 {
-	struct fscache_object *object =
-		container_of(work, struct fscache_object, work);
-
 	fscache_stat(&fscache_n_cop_put_object);
 	object->cache->ops->put_object(object);
 	fscache_stat_d(&fscache_n_cop_put_object);
@@ -792,8 +754,48 @@ void fscache_enqueue_object(struct fscache_object *object)
 {
 	_enter("{OBJ%x}", object->debug_id);
 
-	slow_work_enqueue(&object->work);
+	if (fscache_get_object(object) >= 0) {
+		wait_queue_head_t *cong_wq =
+			&get_cpu_var(fscache_object_cong_wait);
+
+		if (queue_work(fscache_object_wq, &object->work)) {
+			if (fscache_object_congested())
+				wake_up(cong_wq);
+		} else
+			fscache_put_object(object);
+
+		put_cpu_var(fscache_object_cong_wait);
+	}
+}
+
+/**
+ * fscache_object_sleep_till_congested - Sleep until object wq is congested
+ * @timoutp: Scheduler sleep timeout
+ *
+ * Allow an object handler to sleep until the object workqueue is congested.
+ *
+ * The caller must set up a wake up event before calling this and must have set
+ * the appropriate sleep mode (such as TASK_UNINTERRUPTIBLE) and tested its own
+ * condition before calling this function as no test is made here.
+ *
+ * %true is returned if the object wq is congested, %false otherwise.
+ */
+bool fscache_object_sleep_till_congested(signed long *timeoutp)
+{
+	wait_queue_head_t *cong_wq = &__get_cpu_var(fscache_object_cong_wait);
+	DEFINE_WAIT(wait);
+
+	if (fscache_object_congested())
+		return true;
+
+	add_wait_queue_exclusive(cong_wq, &wait);
+	if (!fscache_object_congested())
+		*timeoutp = schedule_timeout(*timeoutp);
+	finish_wait(cong_wq, &wait);
+
+	return fscache_object_congested();
 }
+EXPORT_SYMBOL_GPL(fscache_object_sleep_till_congested);
 
 /*
  * enqueue the dependents of an object for metadata-type processing
@@ -819,9 +821,7 @@ static void fscache_enqueue_dependents(struct fscache_object *object)
 
 		/* sort onto appropriate lists */
 		fscache_enqueue_object(dep);
-		fscache_stat(&fscache_n_cop_put_object);
-		dep->cache->ops->put_object(dep);
-		fscache_stat_d(&fscache_n_cop_put_object);
+		fscache_put_object(dep);
 
 		if (!list_empty(&object->dependents))
 			cond_resched_lock(&object->lock);
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index c57db27..27c8df5 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -21,6 +21,7 @@
 #include <linux/fscache.h>
 #include <linux/sched.h>
 #include <linux/slow-work.h>
+#include <linux/workqueue.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
 
@@ -389,7 +390,7 @@ struct fscache_object {
 	struct fscache_cache	*cache;		/* cache that supplied this object */
 	struct fscache_cookie	*cookie;	/* netfs's file/index object */
 	struct fscache_object	*parent;	/* parent object */
-	struct slow_work	work;		/* attention scheduling record */
+	struct work_struct	work;		/* attention scheduling record */
 	struct list_head	dependents;	/* FIFO of dependent objects */
 	struct list_head	dep_link;	/* link in parent's dependents list */
 	struct list_head	pending_ops;	/* unstarted operations on this object */
@@ -411,7 +412,7 @@ extern const char *fscache_object_states[];
 	(test_bit(FSCACHE_IOERROR, &(obj)->cache->flags) &&	\
 	 (obj)->state >= FSCACHE_OBJECT_DYING)
 
-extern const struct slow_work_ops fscache_object_slow_work_ops;
+extern void fscache_object_work_func(struct work_struct *work);
 
 /**
  * fscache_object_init - Initialise a cache object description
@@ -433,7 +434,7 @@ void fscache_object_init(struct fscache_object *object,
 	spin_lock_init(&object->lock);
 	INIT_LIST_HEAD(&object->cache_link);
 	INIT_HLIST_NODE(&object->cookie_link);
-	vslow_work_init(&object->work, &fscache_object_slow_work_ops);
+	INIT_WORK(&object->work, fscache_object_work_func);
 	INIT_LIST_HEAD(&object->dependents);
 	INIT_LIST_HEAD(&object->dep_link);
 	INIT_LIST_HEAD(&object->pending_ops);
@@ -534,6 +535,8 @@ extern void fscache_io_error(struct fscache_cache *cache);
 extern void fscache_mark_pages_cached(struct fscache_retrieval *op,
 				      struct pagevec *pagevec);
 
+extern bool fscache_object_sleep_till_congested(signed long *timeoutp);
+
 extern enum fscache_checkaux fscache_check_aux(struct fscache_object *object,
 					       const void *data,
 					       uint16_t datalen);
-- 
1.6.4.2


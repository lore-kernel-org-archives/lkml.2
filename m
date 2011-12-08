Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab1LHUPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:15:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58472 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1LHUPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:15:10 -0500
Date: Thu, 8 Dec 2011 23:15:03 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Add refcount type and refcount misuse debugging
Message-ID: <20111208201503.GA28687@p183.telecom.by>
References: <20111206230107.GA22471@p183.telecom.by>
 <20111206163054.f5e916e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206163054.f5e916e3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is quite a lot of idiomatic code which does

	if (atomic_dec_and_test(&obj->refcnt))
		[destroy obj]

Bugs like double-frees in this case are dereferred and it may not be
immediately obvious that double-free has happened.

The answer is to wrap reference count debugging to every such operation.

Enter _refcnt_t (non-atomic version), refcnt_t (atomic version)
datatypes
and CONFIG_DEBUG_REFCNT config option.

The latter directly checks for
a) GET on dead object
b) PUT on dead object (aka double PUT)
(and indirectly for memory corruptions turning positive integers into
negative)

All of this has basic idea coming from grsecurity/PaX's
CONFIG_PAX_REFCOUNT code.
The main difference is that developer has to opt in into new code.

Differences in code generation if CONFIG_DEBUG_REFCNT is enabled (on x86)
come from DEC => XADD change (1 byte) and additional comparison+UD2 (~10 bytes).
If this is a problem refcnt_get/refcnt_put can be uninlined.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/md/dm-thin.c    |   10 ++---
 fs/proc/generic.c       |    4 +-
 fs/proc/internal.h      |    2 -
 fs/proc/root.c          |    3 +
 include/linux/proc_fs.h |    4 +-
 include/linux/refcnt.h  |   90 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug       |    3 +
 7 files changed, 105 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -12,6 +12,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/refcnt.h>
 #include <linux/slab.h>
 
 #define	DM_MSG_PREFIX	"thin"
@@ -494,7 +495,7 @@ struct pool {
 	struct workqueue_struct *wq;
 	struct work_struct worker;
 
-	unsigned ref_count;
+	_refcnt_t ref_count;
 
 	spinlock_t lock;
 	struct bio_list deferred_bios;
@@ -1548,7 +1549,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		err_p = ERR_PTR(-ENOMEM);
 		goto bad_endio_hook_pool;
 	}
-	pool->ref_count = 1;
+	_refcnt_init(&pool->ref_count);
 	pool->pool_md = pool_md;
 	pool->md_dev = metadata_dev;
 	__pool_table_insert(pool);
@@ -1575,14 +1576,13 @@ bad_pool:
 static void __pool_inc(struct pool *pool)
 {
 	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
-	pool->ref_count++;
+	_refcnt_get(&pool->ref_count);
 }
 
 static void __pool_dec(struct pool *pool)
 {
 	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
-	BUG_ON(!pool->ref_count);
-	if (!--pool->ref_count)
+	if (_refcnt_put(&pool->ref_count))
 		__pool_destroy(pool);
 }
 
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -624,7 +624,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
-	atomic_set(&ent->count, 1);
+	refcnt_init(&ent->refcnt);
 	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
 	ent->pde_unload_completion = NULL;
@@ -774,7 +774,7 @@ static void free_proc_entry(struct proc_dir_entry *de)
 
 void pde_put(struct proc_dir_entry *pde)
 {
-	if (atomic_dec_and_test(&pde->count))
+	if (refcnt_put(&pde->refcnt))
 		free_proc_entry(pde);
 }
 
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -110,7 +110,7 @@ void task_mem(struct seq_file *, struct mm_struct *);
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 {
-	atomic_inc(&pde->count);
+	refcnt_get(&pde->refcnt);
 	return pde;
 }
 void pde_put(struct proc_dir_entry *pde);
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -9,6 +9,7 @@
 #include <asm/uaccess.h>
 
 #include <linux/errno.h>
+#include <linux/refcnt.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
@@ -188,7 +189,7 @@ struct proc_dir_entry proc_root = {
 	.namelen	= 5, 
 	.mode		= S_IFDIR | S_IRUGO | S_IXUGO, 
 	.nlink		= 2, 
-	.count		= ATOMIC_INIT(1),
+	.refcnt		= REFCNT_INIT,
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -1,11 +1,11 @@
 #ifndef _LINUX_PROC_FS_H
 #define _LINUX_PROC_FS_H
 
+#include <linux/refcnt.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/spinlock.h>
 #include <linux/magic.h>
-#include <linux/atomic.h>
 
 struct net;
 struct completion;
@@ -69,7 +69,7 @@ struct proc_dir_entry {
 	void *data;
 	read_proc_t *read_proc;
 	write_proc_t *write_proc;
-	atomic_t count;		/* use count */
+	refcnt_t refcnt;
 	int pde_users;	/* number of callers into module in progress */
 	struct completion *pde_unload_completion;
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
--- /dev/null
+++ b/include/linux/refcnt.h
@@ -0,0 +1,90 @@
+/*
+ * Use these types iff
+ * a) object is created with refcount 1, and
+ * b) every GET does +1, and
+ * c) every PUT does -1, and
+ * d) once refcount reaches 0, object is destroyed.
+ *
+ * Do not use otherwise.
+ *
+ * Use underscored version if refcount manipulations are already under
+ * some sort of locking making additional atomicity unnecessary.
+ */
+#ifndef _LINUX_REFCNT_H
+#define _LINUX_REFCNT_H
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#include <linux/types.h>
+
+typedef struct {
+	int n;
+} _refcnt_t;
+#define _REFCNT_INIT	((_refcnt_t){ .n = 1 })
+
+static inline void _refcnt_init(_refcnt_t *refcnt)
+{
+	refcnt->n = 1;
+}
+
+static inline void _refcnt_get(_refcnt_t *refcnt)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_REFCNT))
+		BUG_ON(refcnt->n < 1);
+	refcnt->n++;
+}
+
+/*
+ * Return 1 if PUT turned out to be last PUT, return 0 otherwise.
+ *
+ *	if (_refcnt_put(&obj->refcnt)) {
+ *		[destroy object]
+ *	}
+ */
+static inline int _refcnt_put(_refcnt_t *refcnt)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_REFCNT))
+		BUG_ON(refcnt->n < 1);
+	refcnt->n--;
+	return refcnt->n == 0;
+}
+
+typedef struct {
+	atomic_t n;
+} refcnt_t;
+#define REFCNT_INIT	((refcnt_t){ .n = ATOMIC_INIT(1) })
+
+static inline void refcnt_init(refcnt_t *refcnt)
+{
+	atomic_set(&refcnt->n, 1);
+}
+
+static inline void refcnt_get(refcnt_t *refcnt)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_REFCNT)) {
+		int rv;
+
+		rv = atomic_inc_return(&refcnt->n);
+		BUG_ON(rv < 2);
+	} else
+		atomic_inc(&refcnt->n);
+}
+
+/*
+ * Return 1 if PUT turned out to be last PUT, return 0 otherwise.
+ *
+ *	if (refcnt_put(&obj->refcnt)) {
+ *		[destroy object]
+ *	}
+ */
+static inline int refcnt_put(refcnt_t *refcnt)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_REFCNT)) {
+		int rv;
+
+		rv = atomic_dec_return(&refcnt->n);
+		BUG_ON(rv < 0);
+		return rv == 0;
+	} else
+		return atomic_dec_and_test(&refcnt->n);
+}
+#endif
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1276,3 +1276,6 @@ source "lib/Kconfig.kmemcheck"
 
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
+
+config DEBUG_REFCNT
+	bool "Debug reference count objects"

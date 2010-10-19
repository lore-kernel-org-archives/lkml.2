Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0JSW7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:59:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0JSW7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:59:33 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/6] IMA: move read/write counters into struct inode
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Tue, 19 Oct 2010 18:58:13 -0400
Message-ID: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA currently alocated an inode integrity structure for every inode in
core.  This stucture is about 120 bytes long.  Most files however
(especially on a system which doesn't make use of IMA) will never need any
of this space.  The problem is that if IMA is enabled we need to know
information about the number of readers and the number of writers for every
inode on the box.  At the moment we collect that information in the per
inode iint structure and waste the rest of the space.  This patch moves those
counters into the struct inode so we can eventually stop allocating an IMA
integrity structure except when absolutely needed.

This patch does the minimum needed to move the location of the data.  Further
cleanups, especially the location of counter updates, may still be possible.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/inode.c                        |    2 ++
 include/linux/fs.h                |    6 +++++
 include/linux/ima.h               |    5 ++++
 security/integrity/ima/ima.h      |    3 --
 security/integrity/ima/ima_iint.c |   32 +++++++++++--------------
 security/integrity/ima/ima_main.c |   48 +++++++++++++++++++++----------------
 6 files changed, 54 insertions(+), 42 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..5d7ce1e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,6 +24,7 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include <linux/ima.h>
 
 /*
  * This is needed for the following functions:
@@ -224,6 +225,7 @@ static struct inode *alloc_inode(struct super_block *sb)
 void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
+	ima_check_counters(inode);
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
 #ifdef CONFIG_FS_POSIX_ACL
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5fb4dfd..3a402b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -776,6 +776,12 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+#ifdef CONFIG_IMA
+	/* all protected by i_mutex */
+	long			i_readers; /* struct files open RO */
+	long			i_writers; /* struct files open WR */
+	long			i_opencount; /* total open files (readers + writers) */
+#endif
 #ifdef CONFIG_FS_POSIX_ACL
 	struct posix_acl	*i_acl;
 	struct posix_acl	*i_default_acl;
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 975837e..1c4bdb9 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -21,6 +21,7 @@ extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern void ima_counts_get(struct file *file);
+extern void ima_check_counters(struct inode *inode);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -58,5 +59,9 @@ static inline void ima_counts_get(struct file *file)
 	return;
 }
 
+static inline void ima_check_counters(struct inode *inode)
+{
+	return;
+}
 #endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3fbcd1d..e500fe3 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -104,9 +104,6 @@ struct ima_iint_cache {
 	unsigned long flags;
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
-	long readcount;		/* measured files readcount */
-	long writecount;	/* measured files writecount */
-	long opencount;		/* opens reference count */
 	struct kref refcount;	/* ima_iint_cache reference count */
 	struct rcu_head rcu;
 };
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index afba4ae..c584938 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -73,6 +73,20 @@ out:
 	return rc;
 }
 
+void ima_check_counters(struct inode *inode)
+{
+	if (inode->i_readers)
+		printk(KERN_INFO "%s: readcount: %ld\n", __func__, inode->i_readers);
+	if (inode->i_writers)
+		printk(KERN_INFO "%s: writers: %ld\n", __func__, inode->i_writers);
+	if (inode->i_opencount)
+		printk(KERN_INFO "%s: opencount: %ld\n", __func__, inode->i_opencount);
+
+	inode->i_readers = 0;
+	inode->i_writers = 0;
+	inode->i_opencount = 0;
+}
+
 /* iint_free - called when the iint refcount goes to zero */
 void iint_free(struct kref *kref)
 {
@@ -80,21 +94,6 @@ void iint_free(struct kref *kref)
 						   refcount);
 	iint->version = 0;
 	iint->flags = 0UL;
-	if (iint->readcount != 0) {
-		printk(KERN_INFO "%s: readcount: %ld\n", __func__,
-		       iint->readcount);
-		iint->readcount = 0;
-	}
-	if (iint->writecount != 0) {
-		printk(KERN_INFO "%s: writecount: %ld\n", __func__,
-		       iint->writecount);
-		iint->writecount = 0;
-	}
-	if (iint->opencount != 0) {
-		printk(KERN_INFO "%s: opencount: %ld\n", __func__,
-		       iint->opencount);
-		iint->opencount = 0;
-	}
 	kref_init(&iint->refcount);
 	kmem_cache_free(iint_cache, iint);
 }
@@ -131,9 +130,6 @@ static void init_once(void *foo)
 	iint->version = 0;
 	iint->flags = 0UL;
 	mutex_init(&iint->mutex);
-	iint->readcount = 0;
-	iint->writecount = 0;
-	iint->opencount = 0;
 	kref_init(&iint->refcount);
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e662b89..a70700b 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -97,18 +97,19 @@ out:
  */
 enum iint_pcr_error { TOMTOU, OPEN_WRITERS };
 static void ima_read_write_check(enum iint_pcr_error error,
-				 struct ima_iint_cache *iint,
 				 struct inode *inode,
 				 const unsigned char *filename)
 {
+	BUG_ON(!mutex_is_locked(&inode->i_mutex));
+
 	switch (error) {
 	case TOMTOU:
-		if (iint->readcount > 0)
+		if (inode->i_readers > 0)
 			ima_add_violation(inode, filename, "invalid_pcr",
 					  "ToMToU");
 		break;
 	case OPEN_WRITERS:
-		if (iint->writecount > 0)
+		if (inode->i_writers > 0)
 			ima_add_violation(inode, filename, "invalid_pcr",
 					  "open_writers");
 		break;
@@ -118,15 +119,15 @@ static void ima_read_write_check(enum iint_pcr_error error,
 /*
  * Update the counts given an fmode_t
  */
-static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
+static void ima_inc_counts(struct inode *inode, fmode_t mode)
 {
-	BUG_ON(!mutex_is_locked(&iint->mutex));
+	BUG_ON(!mutex_is_locked(&inode->i_mutex));
 
-	iint->opencount++;
+	inode->i_opencount++;
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		iint->readcount++;
+		inode->i_readers++;
 	if (mode & FMODE_WRITE)
-		iint->writecount++;
+		inode->i_writers++;
 }
 
 /*
@@ -154,6 +155,7 @@ void ima_counts_get(struct file *file)
 	if (!iint)
 		return;
 	mutex_lock(&iint->mutex);
+	mutex_lock(&inode->i_mutex);
 	if (!ima_initialized)
 		goto out;
 	rc = ima_must_measure(iint, inode, MAY_READ, FILE_CHECK);
@@ -161,12 +163,13 @@ void ima_counts_get(struct file *file)
 		goto out;
 
 	if (mode & FMODE_WRITE) {
-		ima_read_write_check(TOMTOU, iint, inode, dentry->d_name.name);
+		ima_read_write_check(TOMTOU, inode, dentry->d_name.name);
 		goto out;
 	}
-	ima_read_write_check(OPEN_WRITERS, iint, inode, dentry->d_name.name);
+	ima_read_write_check(OPEN_WRITERS, inode, dentry->d_name.name);
 out:
-	ima_inc_counts(iint, file->f_mode);
+	ima_inc_counts(inode, file->f_mode);
+	mutex_unlock(&inode->i_mutex);
 	mutex_unlock(&iint->mutex);
 
 	kref_put(&iint->refcount, iint_free);
@@ -180,25 +183,26 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 {
 	mode_t mode = file->f_mode;
 	BUG_ON(!mutex_is_locked(&iint->mutex));
+	BUG_ON(!mutex_is_locked(&inode->i_mutex));
 
-	iint->opencount--;
+	inode->i_opencount--;
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		iint->readcount--;
+		inode->i_readers--;
 	if (mode & FMODE_WRITE) {
-		iint->writecount--;
-		if (iint->writecount == 0) {
+		inode->i_writers--;
+		if (inode->i_writers == 0) {
 			if (iint->version != inode->i_version)
 				iint->flags &= ~IMA_MEASURED;
 		}
 	}
 
-	if (((iint->opencount < 0) ||
-	     (iint->readcount < 0) ||
-	     (iint->writecount < 0)) &&
+	if (((inode->i_opencount < 0) ||
+	     (inode->i_readers < 0) ||
+	     (inode->i_writers < 0)) &&
 	    !ima_limit_imbalance(file)) {
 		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld o:%ld)\n",
-		       __func__, iint->readcount, iint->writecount,
-		       iint->opencount);
+		       __func__, inode->i_readers, inode->i_writers,
+		       inode->i_opencount);
 		dump_stack();
 	}
 }
@@ -208,7 +212,7 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
  * @file: pointer to file structure being freed
  *
  * Flag files that changed, based on i_version;
- * and decrement the iint readcount/writecount.
+ * and decrement the i_readers/i_writers.
  */
 void ima_file_free(struct file *file)
 {
@@ -222,8 +226,10 @@ void ima_file_free(struct file *file)
 		return;
 
 	mutex_lock(&iint->mutex);
+	mutex_lock(&inode->i_mutex);
 	ima_dec_counts(iint, inode, file);
 	mutex_unlock(&iint->mutex);
+	mutex_unlock(&inode->i_mutex);
 	kref_put(&iint->refcount, iint_free);
 }
 


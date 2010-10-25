Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab0JYSnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:43:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759426Ab0JYSnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:43:04 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 07/11] IMA: move read counter into struct inode
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:41:59 -0400
Message-ID: <20101025184159.20504.54447.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA currently allocated an inode integrity structure for every inode in
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
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 fs/inode.c                        |    1 +
 include/linux/fs.h                |    4 ++++
 security/integrity/ima/ima.h      |    3 +--
 security/integrity/ima/ima_api.c  |    2 +-
 security/integrity/ima/ima_iint.c |   11 +++++------
 security/integrity/ima/ima_main.c |   35 ++++++++++-------------------------
 6 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..56d909d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,6 +24,7 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include <linux/ima.h>
 
 /*
  * This is needed for the following functions:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5fb4dfd..cb9dbd0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -772,6 +772,10 @@ struct inode {
 
 	unsigned int		i_flags;
 
+#if CONFIG_IMA
+	/* protected by i_lock */
+	unsigned int		i_readcount; /* struct files open RO */
+#endif
 	atomic_t		i_writecount;
 #ifdef CONFIG_SECURITY
 	void			*i_security;
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index b546b90..27849e1 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -70,6 +70,7 @@ int ima_init(void);
 void ima_cleanup(void);
 int ima_fs_init(void);
 void ima_fs_cleanup(void);
+int ima_inode_alloc(struct inode *inode);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode);
 int ima_calc_hash(struct file *file, char *digest);
@@ -106,8 +107,6 @@ struct ima_iint_cache {
 	unsigned char flags;
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
-	/* protected by inode->i_lock */
-	unsigned int readcount;	/* measured files readcount */
 	struct kref refcount;	/* ima_iint_cache reference count */
 };
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 52015d0..d3963de 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -116,7 +116,7 @@ int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
 {
 	int must_measure;
 
-	if (iint->flags & IMA_MEASURED)
+	if (iint && iint->flags & IMA_MEASURED)
 		return 1;
 
 	must_measure = ima_match_policy(inode, function, mask);
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index e68891f..0936a71 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -124,11 +124,6 @@ void iint_free(struct kref *kref)
 						   refcount);
 	iint->version = 0;
 	iint->flags = 0UL;
-	if (iint->readcount != 0) {
-		printk(KERN_INFO "%s: readcount: %u\n", __func__,
-		       iint->readcount);
-		iint->readcount = 0;
-	}
 	kref_init(&iint->refcount);
 	kmem_cache_free(iint_cache, iint);
 }
@@ -143,6 +138,11 @@ void ima_inode_free(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
+	if (inode->i_readcount)
+		printk(KERN_INFO "%s: readcount: %u\n", __func__, inode->i_readcount);
+
+	inode->i_readcount = 0;
+
 	spin_lock(&ima_iint_lock);
 	iint = __ima_iint_find(inode);
 	if (iint)
@@ -160,7 +160,6 @@ static void init_once(void *foo)
 	iint->version = 0;
 	iint->flags = 0UL;
 	mutex_init(&iint->mutex);
-	iint->readcount = 0;
 	kref_init(&iint->refcount);
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 24660bf..2a77b14 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -86,17 +86,6 @@ out:
 }
 
 /*
- * Update the counts given an fmode_t
- */
-static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
-{
-	assert_spin_locked(&iint->inode->i_lock);
-
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		iint->readcount++;
-}
-
-/*
  * ima_counts_get - increment file counts
  *
  * Maintain read/write counters for all files, but only
@@ -112,27 +101,23 @@ void ima_counts_get(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	fmode_t mode = file->f_mode;
-	struct ima_iint_cache *iint;
 	int rc;
 	bool send_tomtou = false, send_writers = false;
 
-	if (!iint_initialized || !S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		return;
-	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return;
-	mutex_lock(&iint->mutex);
+
 	spin_lock(&inode->i_lock);
 
 	if (!ima_initialized)
 		goto out;
 
-	rc = ima_must_measure(iint, inode, MAY_READ, FILE_CHECK);
+	rc = ima_must_measure(NULL, inode, MAY_READ, FILE_CHECK);
 	if (rc < 0)
 		goto out;
 
 	if (mode & FMODE_WRITE) {
-		if (iint->readcount)
+		if (inode->i_readcount)
 			send_tomtou = true;
 		goto out;
 	}
@@ -140,10 +125,10 @@ void ima_counts_get(struct file *file)
 	if (atomic_read(&inode->i_writecount) > 0)
 		send_writers = true;
 out:
-	ima_inc_counts(iint, file->f_mode);
+	/* remember the vfs deals with i_writecount */
+	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		inode->i_readcount++;
 	spin_unlock(&inode->i_lock);
-	mutex_unlock(&iint->mutex);
-	kref_put(&iint->refcount, iint_free);
 
 	if (send_tomtou)
 		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
@@ -166,9 +151,9 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 	assert_spin_locked(&inode->i_lock);
 
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
-		if (unlikely(iint->readcount == 0))
+		if (unlikely(inode->i_readcount == 0))
 			dump = true;
-		iint->readcount--;
+		inode->i_readcount--;
 	}
 	if (mode & FMODE_WRITE) {
 		if (atomic_read(&inode->i_writecount) <= 0)
@@ -180,7 +165,7 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 
 	if (dump && !ima_limit_imbalance(file)) {
 		printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
-		       __func__, iint->readcount);
+		       __func__, inode->i_readcount);
 		dump_stack();
 	}
 }


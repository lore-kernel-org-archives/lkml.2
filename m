Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1BNUag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:30:36 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58999 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1BNUab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:30:31 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>, torvalds@linux-foundation.org,
        eparis@redhat.com, viro@zeniv.linux.org.uk,
        Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 3/4] IMA: maintain i_readcount in the VFS layer
Date: Mon, 14 Feb 2011 15:29:56 -0500
Message-Id: <1297715397-4141-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297715397-4141-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1297715397-4141-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_counts_get() updated the readcount and invalidated the PCR,
as necessary. Only update the i_readcount in the VFS layer.
Move the PCR invalidation checks to ima_file_check(), where it
belongs.

Maintaining the i_readcount in the VFS layer, will allow other
subsystems to use i_readcount.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Eric Paris <eparis@redhat.com>
---
 fs/file_table.c                   |    5 ++++-
 fs/open.c                         |    3 ++-
 include/linux/ima.h               |    6 ------
 security/integrity/ima/ima_iint.c |    2 --
 security/integrity/ima/ima_main.c |   25 ++++++++-----------------
 5 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index c3dee38..0c724de 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -190,7 +190,8 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 		file_take_write(file);
 		WARN_ON(mnt_clone_write(path->mnt));
 	}
-	ima_counts_get(file);
+	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		i_readcount_inc(path->dentry->d_inode);
 	return file;
 }
 EXPORT_SYMBOL(alloc_file);
@@ -251,6 +252,8 @@ static void __fput(struct file *file)
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
 	file_sb_list_del(file);
+	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		i_readcount_dec(inode);
 	if (file->f_mode & FMODE_WRITE)
 		drop_file_write_access(file);
 	file->f_path.dentry = NULL;
diff --git a/fs/open.c b/fs/open.c
index 4197b9e..0d485c5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -688,7 +688,8 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 		if (error)
 			goto cleanup_all;
 	}
-	ima_counts_get(f);
+	if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		i_readcount_inc(inode);
 
 	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 975837e..09e6e62 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -20,7 +20,6 @@ extern void ima_inode_free(struct inode *inode);
 extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
-extern void ima_counts_get(struct file *file);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -53,10 +52,5 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
 	return 0;
 }
 
-static inline void ima_counts_get(struct file *file)
-{
-	return;
-}
-
 #endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index f005355..68efe3b 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -141,8 +141,6 @@ void ima_inode_free(struct inode *inode)
 		printk(KERN_INFO "%s: readcount: %u\n", __func__,
 		       atomic_read(&inode->i_readcount));
 
-	atomic_set(&inode->i_readcount, 0);
-
 	if (!IS_IMA(inode))
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 6e8cb93..69b4856 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -86,17 +86,16 @@ out:
 }
 
 /*
- * ima_counts_get - increment file counts
+ * ima_rdwr_violation_check
  *
- * Maintain read/write counters for all files, but only
- * invalidate the PCR for measured files:
+ * Only invalidate the PCR for measured files:
  * 	- Opening a file for write when already open for read,
  *	  results in a time of measure, time of use (ToMToU) error.
  *	- Opening a file for read when already open for write,
  * 	  could result in a file measurement error.
  *
  */
-void ima_counts_get(struct file *file)
+static void ima_rdwr_violation_check(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -104,13 +103,10 @@ void ima_counts_get(struct file *file)
 	int rc;
 	bool send_tomtou = false, send_writers = false;
 
-	if (!S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) || !ima_initialized)
 		return;
 
-	spin_lock(&inode->i_lock);
-
-	if (!ima_initialized)
-		goto out;
+	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
 
 	if (mode & FMODE_WRITE) {
 		if (atomic_read(&inode->i_readcount) && IS_IMA(inode))
@@ -125,11 +121,7 @@ void ima_counts_get(struct file *file)
 	if (atomic_read(&inode->i_writecount) > 0)
 		send_writers = true;
 out:
-	/* remember the vfs deals with i_writecount */
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		atomic_inc(&inode->i_readcount);
-
-	spin_unlock(&inode->i_lock);
+	mutex_unlock(&inode->i_mutex);
 
 	if (send_tomtou)
 		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
@@ -158,7 +150,6 @@ static void ima_dec_counts(struct inode *inode, struct file *file)
 			}
 			return;
 		}
-		atomic_dec(&inode->i_readcount);
 	}
 }
 
@@ -203,8 +194,7 @@ static void ima_file_free_noiint(struct inode *inode, struct file *file)
  * ima_file_free - called on __fput()
  * @file: pointer to file structure being freed
  *
- * Flag files that changed, based on i_version;
- * and decrement the i_readcount.
+ * Flag files that changed, based on i_version
  */
 void ima_file_free(struct file *file)
 {
@@ -318,6 +308,7 @@ int ima_file_check(struct file *file, int mask)
 {
 	int rc;
 
+	ima_rdwr_violation_check(file);
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				 FILE_CHECK);
-- 
1.7.3.4


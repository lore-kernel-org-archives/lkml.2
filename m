Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215Ab0J1WDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:03:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60680 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060Ab0J1WC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:02:29 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/4] IMA: maintain i_readcount in the VFS layer
Date: Thu, 28 Oct 2010 18:02:03 -0400
Message-Id: <1288303325-9628-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
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
---
 fs/file_table.c                   |    5 ++++-
 fs/inode.c                        |    3 +++
 fs/open.c                         |    3 ++-
 include/linux/ima.h               |    6 ------
 security/integrity/ima/ima_iint.c |    2 --
 security/integrity/ima/ima_main.c |   21 ++++++---------------
 6 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index a04bdd8..f7b7029 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -191,7 +191,8 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 		file_take_write(file);
 		WARN_ON(mnt_clone_write(path->mnt));
 	}
-	ima_counts_get(file);
+	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		iget_readcount(path->dentry->d_inode);
 	return file;
 }
 EXPORT_SYMBOL(alloc_file);
@@ -252,6 +253,8 @@ static void __fput(struct file *file)
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
 	file_sb_list_del(file);
+	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		iput_readcount(inode);
 	if (file->f_mode & FMODE_WRITE)
 		drop_file_write_access(file);
 	file->f_path.dentry = NULL;
diff --git a/fs/inode.c b/fs/inode.c
index 56d909d..1e806e0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -139,6 +139,9 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_nlink = 1;
 	inode->i_uid = 0;
 	inode->i_gid = 0;
+#ifdef CONFIG_IMA
+	inode->i_readcount = 0;
+#endif
 	atomic_set(&inode->i_writecount, 0);
 	inode->i_size = 0;
 	inode->i_blocks = 0;
diff --git a/fs/open.c b/fs/open.c
index d74e198..a6da4f7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -688,7 +688,8 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 		if (error)
 			goto cleanup_all;
 	}
-	ima_counts_get(f);
+	if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		iget_readcount(inode);
 
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
index c442e47..c4e381a 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -140,8 +140,6 @@ void ima_inode_free(struct inode *inode)
 	if (inode->i_readcount)
 		printk(KERN_INFO "%s: readcount: %u\n", __func__, inode->i_readcount);
 
-	inode->i_readcount = 0;
-
 	if (!IS_IMA(inode))
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 203de97..ce2cd73 100644
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
@@ -104,14 +103,11 @@ void ima_counts_get(struct file *file)
 	int rc;
 	bool send_tomtou = false, send_writers = false;
 
-	if (!S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) || !ima_initialized)
 		return;
 
 	spin_lock(&inode->i_lock);
 
-	if (!ima_initialized)
-		goto out;
-
 	if (mode & FMODE_WRITE) {
 		if (inode->i_readcount && IS_IMA(inode))
 			send_tomtou = true;
@@ -125,10 +121,6 @@ void ima_counts_get(struct file *file)
 	if (atomic_read(&inode->i_writecount) > 0)
 		send_writers = true;
 out:
-	/* remember the vfs deals with i_writecount */
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		inode->i_readcount++;
-
 	spin_unlock(&inode->i_lock);
 
 	if (send_tomtou)
@@ -157,7 +149,6 @@ static void ima_dec_counts(struct inode *inode, struct file *file)
 			}
 			return;
 		}
-		inode->i_readcount--;
 	}
 }
 
@@ -202,8 +193,7 @@ static void ima_file_free_noiint(struct inode *inode, struct file *file)
  * ima_file_free - called on __fput()
  * @file: pointer to file structure being freed
  *
- * Flag files that changed, based on i_version;
- * and decrement the i_readcount.
+ * Flag files that changed, based on i_version
  */
 void ima_file_free(struct file *file)
 {
@@ -317,6 +307,7 @@ int ima_file_check(struct file *file, int mask)
 {
 	int rc;
 
+	ima_rdwr_violation_check(file);
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				 FILE_CHECK);
-- 
1.7.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab2C2OoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:44:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39337 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab2C2On1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:43:27 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v4 10/12] ima: defer calling __fput()
Date: Thu, 29 Mar 2012 10:41:38 -0400
Message-Id: <1333032100-4159-11-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032914-5518-0000-0000-0000034CAE74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_file_free(), which is called on __fput(), updates the file data
hash stored as an extended attribute to reflect file changes.  If a
file is closed before it is munmapped, __fput() is called with the
mmap_sem taken.  With IMA-appraisal enabled, this results in an
mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count to
defer the __fput() being called until after the mmap_sem is released.

The number of __fput() calls needing to be deferred is minimal.  Only
those files in policy, that were closed prior to the munmap and were
mmapped write, need to defer the __fput().

With this patch, on a clean F16 install, from boot to login, only
5 out of ~100,000 mmap_sem held fput() calls were deferred.

Changelog v4:
- ima_defer_fput() performance improvements
- move ima_defer_fput() call from remove_vma() to __fput()
- only defer mmapped files opened for write
- remove unnecessary ima_fput_mempool_destroy()

Changelog v3:
- use slab mempool (suggested by Dmitry Kasatkin)
- renamed a few functions based on Matt Helsley's review
- define ima_fput_mempool as static (fix sparse error)
- fix ima_defer_fput() stub definition

Changelog v2:
- based on discussions with: Tyler Hicks (use workqueues),
  Dave Hansen (defer only IMA related files), and
  Dmitry Kasatkin (add new IMA hook)
- use slab memory for allocating work

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 fs/file_table.c                       |    5 ++
 include/linux/ima.h                   |    5 ++
 security/integrity/ima/ima_appraise.c |   81 +++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 554161a..b91f039 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -229,6 +229,11 @@ static void __fput(struct file *file)
 	struct vfsmount *mnt = file->f_path.mnt;
 	struct inode *inode = dentry->d_inode;
 
+	if (current->mm && rwsem_is_locked(&current->mm->mmap_sem)) {
+		if (ima_defer_fput(file) == 0)
+			return;
+	}
+
 	might_sleep();
 
 	fsnotify_close(file);
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 2c7223d..bbfac16 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -47,6 +47,7 @@ extern void ima_inode_post_setattr(struct dentry *dentry);
 extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len);
 extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+extern int ima_defer_fput(struct file *file);
 #else
 static inline void ima_inode_post_setattr(struct dentry *dentry)
 {
@@ -66,5 +67,9 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 {
 	return 0;
 }
+static inline int ima_defer_fput(struct file *file)
+{
+	return 1;
+}
 #endif /* CONFIG_IMA_APPRAISE_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index becc7e0..220b20e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/mempool.h>
 #include <linux/xattr.h>
 #include <linux/magic.h>
 #include <linux/ima.h>
@@ -226,3 +227,83 @@ int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 	}
 	return result;
 }
+
+struct ima_fput_req {
+	struct file *file;
+	struct work_struct work;
+};
+static struct kmem_cache *ima_fput_slab;
+static mempool_t *ima_fput_mempool;
+
+static void ima_deferred_fput(struct work_struct *work)
+{
+	struct ima_fput_req *deferred = container_of(work, struct ima_fput_req,
+						     work);
+
+	fput(deferred->file);
+	mempool_free(deferred, ima_fput_mempool);
+}
+
+/**
+ * ima_defer_fput - defer calling __fput() for mmaped files
+ * @file: pointer to file structure to be freed
+ *
+ * The i_mutex is taken by ima_file_free(), called on  __fput(), to
+ * update 'security.ima' to reflect the current file data hash.  When
+ * a file is closed before it is munmapped, __fput() is called with
+ * the mmap_sem taken, resulting in an mmap_sem/i_mutex lockdep.
+ * This function defers calling __fput() until after the mmap_sem is
+ * released.
+ *
+ * Return 0 on success, 1 when unnecessary, or errno on failure.
+ */
+int ima_defer_fput(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	struct ima_fput_req *defer;
+	int result;
+
+	if (!(file->f_mode & FMODE_WRITE) || !IS_IMA(inode))
+		return 1;
+
+	defer = mempool_alloc(ima_fput_mempool, GFP_NOIO);
+	if (!defer)	/* should never happen */
+		return -ENOMEM;
+
+	get_file(file);
+
+	defer->file = file;
+	INIT_WORK(&defer->work, ima_deferred_fput);
+	result = schedule_work(&defer->work);
+	if (result == 0) {
+		pr_info("ima: fput already scheduled\n");
+		mempool_free(defer, ima_fput_mempool);
+		fput_atomic(file);
+	}
+	return 0;
+}
+
+static int __init ima_fput_mempool_create(void)
+{
+	ima_fput_slab = kmem_cache_create("ima_fput",
+					   sizeof(struct ima_fput_req),
+					   0, 0, NULL);
+	if (!ima_fput_slab) {
+		pr_info("ima: failed kmem_cache_create\n");
+		goto err_out;
+	}
+
+	ima_fput_mempool = mempool_create_slab_pool(1, ima_fput_slab);
+	if (!ima_fput_mempool)  {
+		pr_info("ima: failed mempool_create_slab_pool\n");
+		goto free_slab;
+	}
+	return 0;
+
+free_slab:
+	kmem_cache_destroy(ima_fput_slab);
+err_out:
+	return -ENOMEM;
+}
+security_initcall(ima_fput_mempool_create);
-- 
1.7.6.5


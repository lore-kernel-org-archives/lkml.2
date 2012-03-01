Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab2CATQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:16:07 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:48470 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2CATQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:16:01 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 09/11] ima: delay calling __fput()
Date: Thu,  1 Mar 2012 14:10:46 -0500
Message-Id: <1330629048-5933-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030119-4242-0000-0000-000000EEF223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a file is closed before it is munmapped, __fput() is called with
the mmap_sem taken.  With IMA-appraisal enabled, this results in an
mmap_sem/i_mutex lockdep.  ima_delay_fput() increments the f_count
to delay __fput() being called until after the mmap_sem is released.

On slab alloc failure, 'security.ima' will be updated, but it would
be updated immediately, instead of being deferred, causing the
existing lockdep.

Changelog:
- Based on discussions with: Tyler Hicks (use workqueues),
  Dave Hansen (defer only IMA related files), and
  Dmitry Kasatkin (add new IMA hook)
- use slab for allocating workqueue

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/ima.h                   |    5 +++
 mm/mmap.c                             |    1 +
 security/integrity/ima/ima_appraise.c |   60 +++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 2c7223d..93b6b37 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -47,6 +47,7 @@ extern void ima_inode_post_setattr(struct dentry *dentry);
 extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len);
 extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+extern void ima_delay_fput(struct file *file);
 #else
 static inline void ima_inode_post_setattr(struct dentry *dentry)
 {
@@ -66,5 +67,9 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 {
 	return 0;
 }
+static void ima_delay_fput(struct file *file)
+{
+	return;
+}
 #endif /* CONFIG_IMA_APPRAISE_H */
 #endif /* _LINUX_IMA_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 4c16a0a..95adc72 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -232,6 +232,7 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
 	if (vma->vm_file) {
+		ima_delay_fput(vma->vm_file);
 		fput(vma->vm_file);
 		if (vma->vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(vma->vm_mm);
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index a29eb03..62527e3 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -223,3 +223,63 @@ int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 	}
 	return result;
 }
+
+struct wq_info {
+	struct file *file;
+	struct work_struct work;
+};
+static struct kmem_cache *wq_cache;
+
+static void ima_delayed_fput(struct work_struct *work)
+{
+	struct wq_info *info = container_of(work, struct wq_info, work);
+
+	fput(info->file);
+	kmem_cache_free(wq_cache, info);
+}
+
+/**
+ * ima_delay_fput - delay calling __fput() for mmaped files
+ * @file: pointer to file structure to be freed
+ *
+ * The i_mutex is taken by ima_file_free(), called on  __fput(), to
+ * update 'security.ima' to reflect the current file data hash.  When
+ * a file is closed before it is munmapped, __fput() is called with
+ * the mmap_sem taken, resulting in an mmap_sem/i_mutex lockdep.
+ * This function delays calling __fput() until after the mmap_sem is
+ * released.
+ */
+void ima_delay_fput(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	struct wq_info *info;
+
+	if (!IS_IMA(inode))
+		return;
+
+	info = kmem_cache_alloc(wq_cache, GFP_KERNEL);
+	if (!info)
+		return;
+
+	get_file(file);
+
+	info->file = file;
+	INIT_WORK(&info->work, ima_delayed_fput);
+	schedule_work(&info->work);
+}
+
+static void init_once(void *foo)
+{
+	struct wq_info *info = foo;
+	
+	memset(info, 0, sizeof *info);
+}
+
+static int __init ima_wq_cache_init(void)
+{
+	wq_cache = kmem_cache_create("wq_cache", sizeof(struct wq_info),
+			      0, SLAB_PANIC, init_once);
+	return 0;
+}
+security_initcall(ima_wq_cache_init);
-- 
1.7.6.5


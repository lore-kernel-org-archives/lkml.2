Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0ETXt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:49:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49265 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0ETXtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:49:25 -0400
Date: Thu, 20 May 2010 18:42:23 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <kirkland@canonical.com>,
       Ecryptfs <ecryptfs-devel@lists.launchpad.net>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] vfs/eCryptfs: Handle ioctl calls with unlocked and compat
 functions
Message-ID: <20100520234223.GA1133@ecryptfs>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
 <1274289855-10001-2-git-send-regression-fweisbec@gmail.com>
 <20100520233942.GA1086@ecryptfs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520233942.GA1086@ecryptfs>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lower filesystems that only implement unlocked_ioctl aren't being
passed ioctl calls because eCryptfs only checked for
lower_file->f_op->ioctl and returned -ENOTTY if it was NULL.

eCryptfs shouldn't implement ioctl(), since it doesn't require the BKL.
Instead, unlocked_ioctl() should be used and vfs_ioctl() can be called
on the lower file since it handles locking, if necessary.  This requires
vfs_ioctl() to be exported.

Also implements compat_ioctl() function by simply passing the call on
to the lower filesystem's compat_ioctl() function.

Reported-by: James Dupin <james.dupin@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
---
 fs/ecryptfs/file.c |   56 ++++++++++++++++++++++++++++++++-------------------
 fs/ioctl.c         |    4 +-
 include/linux/fs.h |    1 +
 3 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index e7440a6..4632ac8 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -294,12 +294,40 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
 	return rc;
 }
 
-static int ecryptfs_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg);
+static long
+ecryptfs_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long rc = -ENOTTY;
+	struct file *lower_file = NULL;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (lower_file)
+		rc = vfs_ioctl(lower_file, cmd, arg);
+	return rc;
+}
+
+#ifdef CONFIG_COMPAT
+static long
+ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long rc = -ENOTTY;
+	struct file *lower_file = NULL;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (lower_file && lower_file->f_op && lower_file->f_op->compat_ioctl)
+		rc = lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
+	return rc;
+}
+#endif
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ecryptfs_compat_ioctl,
+#endif
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
 	.release = ecryptfs_release,
@@ -315,7 +343,10 @@ const struct file_operations ecryptfs_main_fops = {
 	.write = do_sync_write,
 	.aio_write = generic_file_aio_write,
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ecryptfs_compat_ioctl,
+#endif
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -324,20 +355,3 @@ const struct file_operations ecryptfs_main_fops = {
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
 };
-
-static int
-ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
-{
-	int rc = 0;
-	struct file *lower_file = NULL;
-
-	if (ecryptfs_file_to_private(file))
-		lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file && lower_file->f_op && lower_file->f_op->ioctl)
-		rc = lower_file->f_op->ioctl(ecryptfs_inode_to_lower(inode),
-					     lower_file, cmd, arg);
-	else
-		rc = -ENOTTY;
-	return rc;
-}
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 7faefb4..549b8e9 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -34,8 +34,7 @@
  *
  * Returns 0 on success, -errno on error.
  */
-static long vfs_ioctl(struct file *filp, unsigned int cmd,
-		      unsigned long arg)
+long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int error = -ENOTTY;
 
@@ -57,6 +56,7 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
  out:
 	return error;
 }
+EXPORT_SYMBOL(vfs_ioctl);
 
 static int ioctl_fibmap(struct file *filp, int __user *p)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..d862c81 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1922,6 +1922,7 @@ extern char * getname(const char __user *);
 /* fs/ioctl.c */
 
 extern int ioctl_preallocate(struct file *filp, void __user *argp);
+extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
-- 
1.7.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0D0OZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:25:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab0D0OZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:25:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>,
       =?utf-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>
Subject: [PATCH 1/7] logfs: push down BKL into ioctl function
Date: Tue, 27 Apr 2010 16:24:19 +0200
Message-Id: <1272378265-10909-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/q19lofORHxonVv0va/z0Kfu9uVLI3FdnJRr+
 ab5X19PR7G5+9phksKXC0UJ/w+2262WEmDkgPbT3/o66XUvvyS
 FE6EB45wdIkr4qXa9VOMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sure that logfs doesn't rely on the BKL, but right now,
we're just pushing it down.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jörn Engel <joern@logfs.org>
---
 fs/logfs/dir.c   |    2 +-
 fs/logfs/file.c  |   18 +++++++++++++++---
 fs/logfs/logfs.h |    4 ++--
 fs/smbfs/ioctl.c |    2 +-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 2396a85..a801b5e 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -821,7 +821,7 @@ const struct inode_operations logfs_dir_iops = {
 };
 const struct file_operations logfs_dir_fops = {
 	.fsync		= logfs_fsync,
-	.ioctl		= logfs_ioctl,
+	.unlocked_ioctl	= logfs_unlocked_ioctl,
 	.readdir	= logfs_readdir,
 	.read		= generic_read_dir,
 };
diff --git a/fs/logfs/file.c b/fs/logfs/file.c
index 370f367..1dbc342 100644
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@ -8,6 +8,7 @@
 #include "logfs.h"
 #include <linux/sched.h>
 #include <linux/writeback.h>
+#include <linux/smp_lock.h>
 
 static int logfs_write_begin(struct file *file, struct address_space *mapping,
 		loff_t pos, unsigned len, unsigned flags,
@@ -171,9 +172,9 @@ static int logfs_releasepage(struct page *page, gfp_t only_xfs_uses_this)
 }
 
 
-int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		unsigned long arg)
+static long logfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct logfs_inode *li = logfs_inode(inode);
 	unsigned int oldflags, flags;
 	int err;
@@ -209,6 +210,17 @@ int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	}
 }
 
+long logfs_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = logfs_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 int logfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct super_block *sb = dentry->d_inode->i_sb;
@@ -243,7 +255,7 @@ const struct file_operations logfs_reg_fops = {
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= logfs_fsync,
-	.ioctl		= logfs_ioctl,
+	.unlocked_ioctl	= logfs_unlocked_ioctl,
 	.llseek		= generic_file_llseek,
 	.mmap		= generic_file_readonly_mmap,
 	.open		= generic_file_open,
diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index 0a3df1a..8432c51 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -501,8 +501,8 @@ extern const struct inode_operations logfs_reg_iops;
 extern const struct file_operations logfs_reg_fops;
 extern const struct address_space_operations logfs_reg_aops;
 int logfs_readpage(struct file *file, struct page *page);
-int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		unsigned long arg);
+long logfs_unlocked_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg);
 int logfs_fsync(struct file *file, struct dentry *dentry, int datasync);
 
 /* gc.c */
diff --git a/fs/smbfs/ioctl.c b/fs/smbfs/ioctl.c
index dbae1f8..910215b 100644
--- a/fs/smbfs/ioctl.c
+++ b/fs/smbfs/ioctl.c
@@ -26,7 +26,7 @@ int
 smb_ioctl(struct inode *inode, struct file *filp,
 	  unsigned int cmd, unsigned long arg)
 {
-	struct smb_sb_info *server = server_from_inode(inode);
+	struct smb_sb_info *server = server_from_inode(filp->f_path.dentry->d_inode);
 	struct smb_conn_opt opt;
 	int result = -EINVAL;
 
-- 
1.6.3.3


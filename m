Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2LRKFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:05:19 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37379 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab2LRKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:05:17 -0500
Subject: [PATCH] fuse: truncate file if async dio failed - v2
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Tue, 18 Dec 2012 14:05:08 +0400
Message-ID: <20121218100441.12980.71134.stgit@maximpc.sw.ru>
In-Reply-To: <20121214152113.27155.58793.stgit@maximpc.sw.ru>
References: <20121214152113.27155.58793.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch improves error handling in fuse_direct_IO(): if we successfully
submitted several fuse requests on behalf of synchronous direct write
extending file and some of them failed, let's try to do our best to clean-up.

Changed in v2: reuse fuse_do_setattr(). Thanks to Brian for suggestion.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dir.c    |   17 +++++++++--------
 fs/fuse/file.c   |   27 +++++++++++++++++++++++++--
 fs/fuse/fuse_i.h |    3 +++
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 20b52a5..049d4c2 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1532,10 +1532,9 @@ void fuse_release_nowrite(struct inode *inode)
  * vmtruncate() doesn't allow for this case, so do the rlimit checking
  * and the actual truncation by hand.
  */
-static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
-			   struct file *file)
+int fuse_do_setattr(struct inode *inode, struct iattr *attr,
+		    struct file *file)
 {
-	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 	struct fuse_setattr_in inarg;
@@ -1544,9 +1543,6 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	loff_t oldsize;
 	int err;
 
-	if (!fuse_allow_task(fc, current))
-		return -EACCES;
-
 	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
 		attr->ia_valid |= ATTR_FORCE;
 
@@ -1641,10 +1637,15 @@ error:
 
 static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 {
+	struct inode *inode = entry->d_inode;
+
+	if (!fuse_allow_task(get_fuse_conn(inode), current))
+		return -EACCES;
+
 	if (attr->ia_valid & ATTR_FILE)
-		return fuse_do_setattr(entry, attr, attr->ia_file);
+		return fuse_do_setattr(inode, attr, attr->ia_file);
 	else
-		return fuse_do_setattr(entry, attr, NULL);
+		return fuse_do_setattr(inode, attr, NULL);
 }
 
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 05eed23..d9a0568 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2340,6 +2340,25 @@ int fuse_notify_poll_wakeup(struct fuse_conn *fc,
 	return 0;
 }
 
+static void fuse_do_truncate(struct file *file)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct iattr attr;
+	int err;
+
+	attr.ia_valid = ATTR_SIZE;
+	attr.ia_size = i_size_read(inode);
+
+	attr.ia_file = file;
+	attr.ia_valid |= ATTR_FILE;
+
+	err = fuse_do_setattr(inode, &attr, file);
+
+	if (err)
+		printk(KERN_WARNING "failed to truncate to %lld with error "
+		       "%d\n", i_size_read(inode), err);
+}
+
 static ssize_t
 fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs)
@@ -2400,8 +2419,12 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		kfree(io);
 	}
 
-	if (rw == WRITE && ret > 0)
-		fuse_write_update_size(inode, pos);
+	if (rw == WRITE) {
+		if (ret > 0)
+			fuse_write_update_size(inode, pos);
+		else if (ret < 0 && offset + count > i_size)
+			fuse_do_truncate(file);
+	}
 
 	return ret;
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 91b5192..d4f7f07 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -840,4 +840,7 @@ int fuse_dev_release(struct inode *inode, struct file *file);
 
 void fuse_write_update_size(struct inode *inode, loff_t pos);
 
+int fuse_do_setattr(struct inode *inode, struct iattr *attr,
+		    struct file *file);
+
 #endif /* _FS_FUSE_I_H */


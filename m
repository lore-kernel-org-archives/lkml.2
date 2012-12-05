Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2LEQn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:43:28 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26962 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2LEQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:43:27 -0500
Subject: [PATCH] fuse: Fix O_DIRECT operations vs cached writeback misorder -
 v2
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Wed, 05 Dec 2012 20:43:04 +0400
Message-ID: <20121205164242.19642.90960.stgit@maximpc.sw.ru>
In-Reply-To: <20121116171012.3196.35933.stgit@maximpc.sw.ru>
References: <20121116171012.3196.35933.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is:

1. write cached data to a file
2. read directly from the same file (via another fd)

The 2nd operation may read stale data, i.e. the one that was in a file
before the 1st op. Problem is in how fuse manages writeback.

When direct op occurs the core kernel code calls filemap_write_and_wait
to flush all the cached ops in flight. But fuse acks the writeback right
after the ->writepages callback exits w/o waiting for the real write to
happen. Thus the subsequent direct op proceeds while the real writeback
is still in flight. This is a problem for backends that reorder operation.

Fix this by making the fuse direct IO callback explicitly wait on the
in-flight writeback to finish.

Changed in v2:
 - do not wait on writeback if fuse_direct_io() call came from
   CUSE (because it doesn't use fuse inodes)

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    5 +++--
 fs/fuse/file.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h |   13 ++++++++++++-
 3 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index ee8d550..7e19bd2 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -93,7 +93,7 @@ static ssize_t cuse_read(struct file *file, char __user *buf, size_t count,
 {
 	loff_t pos = 0;
 
-	return fuse_direct_io(file, buf, count, &pos, 0);
+	return fuse_direct_io(file, buf, count, &pos, FUSE_DIO_CUSE);
 }
 
 static ssize_t cuse_write(struct file *file, const char __user *buf,
@@ -104,7 +104,8 @@ static ssize_t cuse_write(struct file *file, const char __user *buf,
 	 * No locking or generic_write_checks(), the server is
 	 * responsible for locking and sanity checks.
 	 */
-	return fuse_direct_io(file, buf, count, &pos, 1);
+	return fuse_direct_io(file, buf, count, &pos,
+			      FUSE_DIO_WRITE | FUSE_DIO_CUSE);
 }
 
 static int cuse_open(struct inode *inode, struct file *file)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f2da298..d4ee020 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -349,6 +349,31 @@ u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
 	return (u64) v0 + ((u64) v1 << 32);
 }
 
+static bool fuse_range_is_writeback(struct inode *inode, pgoff_t idx_from,
+				    pgoff_t idx_to)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_req *req;
+	bool found = false;
+
+	spin_lock(&fc->lock);
+	list_for_each_entry(req, &fi->writepages, writepages_entry) {
+		pgoff_t curr_index;
+
+		BUG_ON(req->inode != inode);
+		curr_index = req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
+		if (!(idx_from >= curr_index + req->num_pages ||
+		      idx_to < curr_index)) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&fc->lock);
+
+	return found;
+}
+
 /*
  * Check if page is under writeback
  *
@@ -393,6 +418,19 @@ static int fuse_wait_on_page_writeback(struct inode *inode, pgoff_t index)
 	return 0;
 }
 
+static void fuse_wait_on_writeback(struct inode *inode, pgoff_t start,
+				   size_t bytes)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	pgoff_t idx_from, idx_to;
+
+	idx_from = start >> PAGE_CACHE_SHIFT;
+	idx_to = (start + bytes - 1) >> PAGE_CACHE_SHIFT;
+
+	wait_event(fi->page_waitq,
+		   !fuse_range_is_writeback(inode, idx_from, idx_to));
+}
+
 static int fuse_flush(struct file *file, fl_owner_t id)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1158,8 +1196,10 @@ static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
 }
 
 ssize_t fuse_direct_io(struct file *file, const char __user *buf,
-		       size_t count, loff_t *ppos, int write)
+		       size_t count, loff_t *ppos, int flags)
 {
+	int write = flags & FUSE_DIO_WRITE;
+	int cuse = flags & FUSE_DIO_CUSE;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 	size_t nmax = write ? fc->max_write : fc->max_read;
@@ -1181,6 +1221,10 @@ ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 			break;
 		}
 
+		if (!cuse)
+			fuse_wait_on_writeback(file->f_mapping->host, pos,
+					       nbytes);
+
 		if (write)
 			nres = fuse_send_write(req, file, pos, nbytes, owner);
 		else
@@ -1241,7 +1285,7 @@ static ssize_t __fuse_direct_write(struct file *file, const char __user *buf,
 
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res) {
-		res = fuse_direct_io(file, buf, count, ppos, 1);
+		res = fuse_direct_io(file, buf, count, ppos, FUSE_DIO_WRITE);
 		if (res > 0) {
 			struct fuse_inode *fi = get_fuse_inode(inode);
 			fuse_write_update_size(inode, *ppos);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 72645e8..ec67597 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -788,8 +788,19 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
 
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir);
+
+/**
+ * fuse_direct_io() flags
+ */
+
+/** If set, it is WRITE; otherwise - READ */
+#define FUSE_DIO_WRITE (1 << 0)
+
+/** CUSE pass fuse_direct_io() a file which f_mapping->host is not from FUSE */
+#define FUSE_DIO_CUSE  (1 << 1)
+
 ssize_t fuse_direct_io(struct file *file, const char __user *buf,
-		       size_t count, loff_t *ppos, int write);
+		       size_t count, loff_t *ppos, int flags);
 long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		   unsigned int flags);
 long fuse_ioctl_common(struct file *file, unsigned int cmd,


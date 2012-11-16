Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2KPRKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:10:38 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:39046 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab2KPRKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:10:36 -0500
Subject: [PATCH 12/14] fuse: Fix O_DIRECT operations vs cached writeback
 misorder
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:10:20 +0400
Message-ID: <20121116171012.3196.35933.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
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

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b73fe2a..741e9b4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -348,6 +348,31 @@ u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
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
@@ -392,6 +417,19 @@ static int fuse_wait_on_page_writeback(struct inode *inode, pgoff_t index)
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
@@ -1178,6 +1216,8 @@ ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 			break;
 		}
 
+		fuse_wait_on_writeback(file->f_mapping->host, pos, nbytes);
+
 		if (write)
 			nres = fuse_send_write(req, file, pos, nbytes, owner);
 		else


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2KVTcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:32:33 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:40506 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab2KVTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:32:28 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org
Subject: [PATCH v4 29/31] afs: add support for read_iter and write_iter
Date: Wed, 21 Nov 2012 16:41:09 -0600
Message-Id: <1353537671-26284-30-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
---
 fs/afs/file.c     | 4 ++--
 fs/afs/internal.h | 3 +--
 fs/afs/write.c    | 9 ++++-----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 8f6e923..27b9b66 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -32,8 +32,8 @@ const struct file_operations afs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= afs_file_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= afs_file_write,
 	.mmap		= generic_file_readonly_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= afs_fsync,
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index a306bb6..9c048ff 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -747,8 +747,7 @@ extern int afs_write_end(struct file *file, struct address_space *mapping,
 extern int afs_writepage(struct page *, struct writeback_control *);
 extern int afs_writepages(struct address_space *, struct writeback_control *);
 extern void afs_pages_written_back(struct afs_vnode *, struct afs_call *);
-extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
-			      unsigned long, loff_t);
+extern ssize_t afs_file_write(struct kiocb *, struct iov_iter *, loff_t);
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, loff_t, loff_t, int);
 
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 9aa52d9..2c2a6d2 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -624,16 +624,15 @@ void afs_pages_written_back(struct afs_vnode *vnode, struct afs_call *call)
 /*
  * write to an AFS file
  */
-ssize_t afs_file_write(struct kiocb *iocb, const struct iovec *iov,
-		       unsigned long nr_segs, loff_t pos)
+ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct dentry *dentry = iocb->ki_filp->f_path.dentry;
 	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
 	ssize_t result;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 
 	_enter("{%x.%u},{%zu},%lu,",
-	       vnode->fid.vid, vnode->fid.vnode, count, nr_segs);
+	       vnode->fid.vid, vnode->fid.vnode, count, iter->nr_segs);
 
 	if (IS_SWAPFILE(&vnode->vfs_inode)) {
 		printk(KERN_INFO
@@ -644,7 +643,7 @@ ssize_t afs_file_write(struct kiocb *iocb, const struct iovec *iov,
 	if (!count)
 		return 0;
 
-	result = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	result = generic_file_write_iter(iocb, iter, pos);
 	if (IS_ERR_VALUE(result)) {
 		_leave(" = %zd", result);
 		return result;
-- 
1.8.0


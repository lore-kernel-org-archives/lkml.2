Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab0FJDy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:54:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59790 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0FJDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:54:28 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH v2] ocfs2: Let ocfs2_setattr use new truncate sequence.
Date: Thu, 10 Jun 2010 11:53:06 +0800
Message-Id: <1276141986-9200-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C1061E8.019F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let ocfs2 use the new truncate sequence. The changes include:
1. Remove the extra check for inode_newsize_ok since Christoph
   has moved it into inode_change_ok. So we will check it at the
   beginning of ocfs2_setattr.
2. Use truncate_setsize directly since we don't implement our
   own ->truncate and what we need is "update i_size and
   truncate_pagecache" which truncate_setsize now does.
3. For direct write, ocfs2 actually don't allow write to pass
   i_size(see ocfs2_prepare_inode_for_write), so we don't have
   a chance to increase i_size. So remove the bogus check.

Cc: Joel Becker <joel.becker@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c |   34 +++++-----------------------------
 1 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1fb0985..764fffb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -983,10 +983,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (size_change && attr->ia_size != i_size_read(inode)) {
-		status = inode_newsize_ok(inode, attr->ia_size);
-		if (status)
-			goto bail_unlock;
-
 		if (i_size_read(inode) > attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
 				status = ocfs2_begin_ordered_truncate(inode,
@@ -1052,22 +1048,13 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	/*
-	 * This will intentionally not wind up calling truncate_setsize(),
-	 * since all the work for a size change has been done above.
-	 * Otherwise, we could get into problems with truncate as
-	 * ip_alloc_sem is used there to protect against i_size
-	 * changes.
-	 *
-	 * XXX: this means the conditional below can probably be removed.
+	 * Since all the work for a size change has been done above.
+	 * Call truncate_setsize directly to change size and truncate
+	 * pagecache.
 	 */
 	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		status = vmtruncate(inode, attr->ia_size);
-		if (status) {
-			mlog_errno(status);
-			goto bail_commit;
-		}
-	}
+	    attr->ia_size != i_size_read(inode))
+		truncate_setsize(inode, attr->ia_size);
 
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
@@ -2122,17 +2109,6 @@ relock:
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
-			/*
-			 * direct write may have instantiated a few
-			 * blocks outside i_size. Trim these off again.
-			 * Don't need i_size_read because we hold i_mutex.
-			 *
-			 * XXX(truncate): this looks buggy because ocfs2 did not
-			 * actually implement ->truncate.  Take a look at
-			 * the new truncate sequence and update this accordingly
-			 */
-			if (*ppos + count > inode->i_size)
-				truncate_setsize(inode, inode->i_size);
 			ret = written;
 			goto out_dio;
 		}
-- 
1.5.5


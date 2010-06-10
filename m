Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0FJFJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:09:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63638 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0FJFJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:09:08 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
Date: Thu, 10 Jun 2010 13:08:05 +0800
Message-Id: <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100610044234.GD26335@laptop>
References: <20100610044234.GD26335@laptop>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C107368.0147:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let ocfs2 use the new truncate sequence. The changes include:
1. Use truncate_setsize directly since we don't implement our
   own ->truncate and what we need is "update i_size and
   truncate_pagecache" which truncate_setsize now does.
2. For direct write, ocfs2 actually don't allow write to pass
   i_size(see ocfs2_prepare_inode_for_write), so we don't have
   a chance to increase i_size. So remove the bogus check.

Cc: Joel Becker <joel.becker@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c |   32 ++++++--------------------------
 1 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1fb0985..8b5447e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -987,7 +987,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		if (status)
 			goto bail_unlock;
 
-		if (i_size_read(inode) > attr->ia_size) {
+		if (inode->i_size > attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
 				status = ocfs2_begin_ordered_truncate(inode,
 								      attr->ia_size);
@@ -1052,22 +1052,13 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
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
+	    attr->ia_size != inode->i_size)
+		truncate_setsize(inode, attr->ia_size);
 
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
@@ -2122,17 +2113,6 @@ relock:
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


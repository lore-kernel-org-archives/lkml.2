Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1KWAmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:42:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759517Ab1KWAmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:09 2011
Message-Id: <20111123002409.367744238@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [51/53] xfs: fix ->write_inode return values
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

patch 58d84c4ee0389ddeb86238d5d8359a982c9f7a5b upstream.

Currently we always redirty an inode that was attempted to be written out
synchronously but has been cleaned by an AIL pushed internall, which is
rather bogus.  Fix that by doing the i_update_core check early on and
return 0 for it.  Also include async calls for it, as doing any work for
those is just as pointless.  While we're at it also fix the sign for the
EIO return in case of a filesystem shutdown, and fix the completely
non-sensical locking around xfs_log_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_super.c |   34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -878,33 +878,17 @@ xfs_log_inode(
 	struct xfs_trans	*tp;
 	int			error;
 
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		/* we need to return with the lock hold shared */
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		return error;
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Note - it's possible that we might have pushed ourselves out of the
-	 * way during trans_reserve which would flush the inode.  But there's
-	 * no guarantee that the inode buffer has actually gone out yet (it's
-	 * delwri).  Plus the buffer could be pinned anyway if it's part of
-	 * an inode in another recent transaction.  So we play it safe and
-	 * fire off the transaction anyway.
-	 */
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp, 0);
-	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
-
-	return error;
+	return xfs_trans_commit(tp, 0);
 }
 
 STATIC int
@@ -919,7 +903,9 @@ xfs_fs_write_inode(
 	trace_xfs_write_inode(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
+	if (!ip->i_update_core)
+		return 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		/*
@@ -930,12 +916,10 @@ xfs_fs_write_inode(
 		 * of synchronous log foces dramatically.
 		 */
 		xfs_ioend_wait(ip);
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if (ip->i_update_core) {
-			error = xfs_log_inode(ip);
-			if (error)
-				goto out_unlock;
-		}
+		error = xfs_log_inode(ip);
+		if (error)
+			goto out;
+		return 0;
 	} else {
 		/*
 		 * We make this non-blocking if the inode is contended, return



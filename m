Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0DVUp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:45:58 -0400
Received: from kroah.org ([198.145.64.141]:37208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0DVT1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:41 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:09 2010
Message-Id: <20100422190909.113628274@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Dave Chinner <david@fromorbit.com>, Alex Elder <aelder@sgi.com>
Subject: [019/197] xfs: Avoid inodes in reclaim when flushing from inode cache
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 018027be90a6946e8cf3f9b17b5582384f7ed117 upstream

The reclaim code will handle flushing of dirty inodes before reclaim
occurs, so avoid them when determining whether an inode is a
candidate for flushing to disk when walking the radix trees.  This
is based on a test patch from Christoph Hellwig.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -179,26 +179,31 @@ xfs_sync_inode_valid(
 	struct xfs_perag	*pag)
 {
 	struct inode		*inode = VFS_I(ip);
+	int			error = EFSCORRUPTED;
 
 	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		read_unlock(&pag->pag_ici_lock);
-		return EFSCORRUPTED;
-	}
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		goto out_unlock;
 
-	/* If we can't get a reference on the inode, it must be in reclaim. */
-	if (!igrab(inode)) {
-		read_unlock(&pag->pag_ici_lock);
-		return ENOENT;
-	}
-	read_unlock(&pag->pag_ici_lock);
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	error = ENOENT;
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock;
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		goto out_unlock;
+
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
-		return ENOENT;
+		goto out_unlock;
 	}
 
-	return 0;
+	/* inode is valid */
+	error = 0;
+out_unlock:
+	read_unlock(&pag->pag_ici_lock);
+	return error;
 }
 
 STATIC int



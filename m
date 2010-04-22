Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0DVUpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:45:34 -0400
Received: from kroah.org ([198.145.64.141]:37214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab0DVT1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:09 2010
Message-Id: <20100422190909.201572751@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Dave Chinner <david@fromorbit.com>, Alex Elder <aelder@sgi.com>
Subject: [020/197] xfs: reclaim all inodes by background tree walks
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 57817c68229984818fea9e614d6f95249c3fb098 upstream

We cannot do direct inode reclaim without taking the flush lock to
ensure that we do not reclaim an inode under IO. We check the inode
is clean before doing direct reclaim, but this is not good enough
because the inode flush code marks the inode clean once it has
copied the in-core dirty state to the backing buffer.

It is the flush lock that determines whether the inode is still
under IO, even though it is marked clean, and the inode is still
required at IO completion so we can't reclaim it even though it is
clean in core. Hence the requirement that we need to take the flush
lock even on clean inodes because this guarantees that the inode
writeback IO has completed and it is safe to reclaim the inode.

With delayed write inode flushing, we could end up waiting a long
time on the flush lock even for a clean inode. The background
reclaim already handles this efficiently, so avoid all the problems
by killing the direct reclaim path altogether.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_super.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -953,16 +953,14 @@ xfs_fs_destroy_inode(
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
 
 	/*
-	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise delay the flush operation.
+	 * We always use background reclaim here because even if the
+	 * inode is clean, it still may be under IO and hence we have
+	 * to take the flush lock. The background reclaim path handles
+	 * this more efficiently than we can here, so simply let background
+	 * reclaim tear down all inodes.
 	 */
-	if (!xfs_inode_clean(ip)) {
-		xfs_inode_set_reclaim_tag(ip);
-		return;
-	}
-
 out_reclaim:
-	xfs_ireclaim(ip);
+	xfs_inode_set_reclaim_tag(ip);
 }
 
 /*



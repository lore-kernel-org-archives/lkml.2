Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0DVUpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:45:07 -0400
Received: from kroah.org ([198.145.64.141]:37222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab0DVT1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:09 2010
Message-Id: <20100422190909.292577470@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Dave Chinner <david@fromorbit.com>, Alex Elder <aelder@sgi.com>
Subject: [021/197] xfs: fix stale inode flush avoidance
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 4b6a46882cca8349e8942e2650c33b11bc571c92 upstream

When reclaiming stale inodes, we need to guarantee that inodes are
unpinned before returning with a "clean" status. If we don't we can
reclaim inodes that are pinned, leading to use after free in the
transaction subsystem as transactions complete.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_inode.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2878,13 +2878,9 @@ xfs_iflush(
 
 	/*
 	 * If the inode isn't dirty, then just release the inode flush lock and
-	 * do nothing. Treat stale inodes the same; we cannot rely on the
-	 * backing buffer remaining stale in cache for the remaining life of
-	 * the stale inode and so xfs_itobp() below may give us a buffer that
-	 * no longer contains inodes below. Doing this stale check here also
-	 * avoids forcing the log on pinned, stale inodes.
+	 * do nothing.
 	 */
-	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
+	if (xfs_inode_clean(ip)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
@@ -2908,6 +2904,19 @@ xfs_iflush(
 	xfs_iunpin_wait(ip);
 
 	/*
+	 * For stale inodes we cannot rely on the backing buffer remaining
+	 * stale in cache for the remaining life of the stale inode and so
+	 * xfs_itobp() below may give us a buffer that no longer contains
+	 * inodes below. We have to check this after ensuring the inode is
+	 * unpinned so that it is safe to reclaim the stale inode after the
+	 * flush call.
+	 */
+	if (xfs_iflags_test(ip, XFS_ISTALE)) {
+		xfs_ifunlock(ip);
+		return 0;
+	}
+
+	/*
 	 * This may have been unpinned because the filesystem is shutting
 	 * down forcibly. If that's the case we must not write this inode
 	 * to disk, because the log record didn't make it to disk!



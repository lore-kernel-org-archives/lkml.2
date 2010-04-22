Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0DVUoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:44:38 -0400
Received: from kroah.org ([198.145.64.141]:37250 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab0DVT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:09 2010
Message-Id: <20100422190909.635239163@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
Subject: [025/197] xfs: remove invalid barrier optimization from xfs_fsync
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@lst.de>

commit e8b217e7530c6a073ac69f1c85b922d93fdf5647 upstream

Date: Tue, 2 Feb 2010 10:16:26 +1100
We always need to flush the disk write cache and can't skip it just because
the no inode attributes have changed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_vnodeops.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -597,7 +597,7 @@ xfs_fsync(
 {
 	xfs_trans_t	*tp;
 	int		error = 0;
-	int		log_flushed = 0, changed = 1;
+	int		log_flushed = 0;
 
 	xfs_itrace_entry(ip);
 
@@ -627,19 +627,11 @@ xfs_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
 		if (xfs_ipincount(ip)) {
 			error = _xfs_log_force(ip->i_mount, (xfs_lsn_t)0,
 				      XFS_LOG_FORCE | XFS_LOG_SYNC,
 				      &log_flushed);
-		} else {
-			/*
-			 * If the inode is not pinned and nothing has changed
-			 * we don't need to flush the cache.
-			 */
-			changed = 0;
 		}
 	} else	{
 		/*
@@ -674,7 +666,7 @@ xfs_fsync(
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
+	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
 		/*
 		 * If the log write didn't issue an ordered tag we need
 		 * to flush the disk cache for the data device now.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0DVUKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:10:40 -0400
Received: from kroah.org ([198.145.64.141]:60029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758129Ab0DVUBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:17 2010
Message-Id: <20100422195417.155245787@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>,
       Dave Chinner <david@fromorbit.com>
Subject: [117/139] xfs: fix locking for inode cache radix tree tag updates
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit f1f724e4b523d444c5a598d74505aefa3d6844d2 upstream.

The radix-tree code requires it's users to serialize tag updates
against other updates to the tree.  While XFS protects tag updates
against each other it does not serialize them against updates of the
tree contents, which can lead to tag corruption.  Fix the inode
cache to always take pag_ici_lock in exclusive mode when updating
radix tree tags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Patrick Schreurs <patrick@news-service.com>
Tested-by: Patrick Schreurs <patrick@news-service.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |    4 ++--
 fs/xfs/xfs_iget.c           |   19 +++++++++++++------
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -693,12 +693,12 @@ xfs_inode_set_reclaim_tag(
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
 
-	read_lock(&pag->pag_ici_lock);
+	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	__xfs_inode_set_reclaim_tag(pag, ip);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
+	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 }
 
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -190,13 +190,12 @@ xfs_iget_cache_hit(
 		trace_xfs_iget_reclaim(ip);
 
 		/*
-		 * We need to set XFS_INEW atomically with clearing the
-		 * reclaimable tag so that we do have an indicator of the
-		 * inode still being initialized.
+		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
+		 * from stomping over us while we recycle the inode.  We can't
+		 * clear the radix tree reclaimable tag yet as it requires
+		 * pag_ici_lock to be held exclusive.
 		 */
-		ip->i_flags |= XFS_INEW;
-		ip->i_flags &= ~XFS_IRECLAIMABLE;
-		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
+		ip->i_flags |= XFS_IRECLAIM;
 
 		spin_unlock(&ip->i_flags_lock);
 		read_unlock(&pag->pag_ici_lock);
@@ -216,7 +215,15 @@ xfs_iget_cache_hit(
 			trace_xfs_iget_reclaim(ip);
 			goto out_error;
 		}
+
+		write_lock(&pag->pag_ici_lock);
+		spin_lock(&ip->i_flags_lock);
+		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
+		ip->i_flags |= XFS_INEW;
+		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 		inode->i_state = I_NEW;
+		spin_unlock(&ip->i_flags_lock);
+		write_unlock(&pag->pag_ici_lock);
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {



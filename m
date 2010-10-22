Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab0JVTGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:06:06 -0400
Received: from kroah.org ([198.145.64.141]:34323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759457Ab0JVS4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.921638761@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Weiner <hannes@cmpxchg.org>, Alex Elder <aelder@sgi.com>
Subject: [073/103] xfs: properly account for reclaimed inodes
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 081003fff467ea0e727f66d5d435b4f473a789b3 upstream.

When marking an inode reclaimable, a per-AG counter is increased, the
inode is tagged reclaimable in its per-AG tree, and, when this is the
first reclaimable inode in the AG, the AG entry in the per-mount tree
is also tagged.

When an inode is finally reclaimed, however, it is only deleted from
the per-AG tree.  Neither the counter is decreased, nor is the parent
tree's AG entry untagged properly.

Since the tags in the per-mount tree are not cleared, the inode
shrinker iterates over all AGs that have had reclaimable inodes at one
point in time.

The counters on the other hand signal an increasing amount of slab
objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
per-filesystem context" this is not a real issue anymore because the
shrinker bails out after one iteration.

But the problem was observable on a machine running v2.6.34, where the
reclaimable work increased and each process going into direct reclaim
eventually got stuck on the xfs inode shrinking path, trying to scan
several million objects.

Fix this by properly unwinding the reclaimable-state tracking of an
inode when it is reclaimed.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |   16 ++++++++++++----
 fs/xfs/linux-2.6/xfs_sync.h |    1 +
 fs/xfs/xfs_iget.c           |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -711,13 +711,10 @@ xfs_inode_set_reclaim_tag(
 }
 
 void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
+__xfs_inode_clear_reclaim(
 	xfs_perag_t	*pag,
 	xfs_inode_t	*ip)
 {
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 	pag->pag_ici_reclaimable--;
 	if (!pag->pag_ici_reclaimable) {
 		/* clear the reclaim tag from the perag radix tree */
@@ -731,6 +728,17 @@ __xfs_inode_clear_reclaim_tag(
 	}
 }
 
+void
+__xfs_inode_clear_reclaim_tag(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+	__xfs_inode_clear_reclaim(pag, ip);
+}
+
 /*
  * Inodes in different states need to be treated differently, and the return
  * value of xfs_iflush is not sufficient to get this right. The following table
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -47,6 +47,7 @@ int xfs_reclaim_inodes(struct xfs_mount
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -492,6 +492,7 @@ xfs_ireclaim(
 	write_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root, agino))
 		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
 



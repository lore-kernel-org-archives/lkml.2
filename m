Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0JAHoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:44:01 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:52390 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0JAHoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:44:00 -0400
Date: Fri, 1 Oct 2010 09:43:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: xfs@oss.sgi.com
Cc: John Hawley <warthog9@kernel.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [patch] xfs: properly account for reclaimed inodes
Message-ID: <20101001074354.GF2618@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 fs/xfs/linux-2.6/xfs_sync.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d59c4a6..81976ff 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -668,14 +668,11 @@ xfs_inode_set_reclaim_tag(
 	xfs_perag_put(pag);
 }
 
-void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
+STATIC void
+__xfs_inode_clear_reclaim(
 	xfs_perag_t	*pag,
 	xfs_inode_t	*ip)
 {
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 	pag->pag_ici_reclaimable--;
 	if (!pag->pag_ici_reclaimable) {
 		/* clear the reclaim tag from the perag radix tree */
@@ -689,6 +686,17 @@ __xfs_inode_clear_reclaim_tag(
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
@@ -838,6 +846,7 @@ reclaim:
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
 		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
 	write_unlock(&pag->pag_ici_lock);
 
 	/*
-- 
1.7.2.3


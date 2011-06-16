Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab1FPHMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:12:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36614 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105Ab1FPHLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:39 -0400
X-Sasl-enc: ddjW29+y8cSMe6TwqVmxv7w2806jmTsFa6ZA+C3CH4JC 1308208298
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:12 2011
Message-Id: <20110616002912.091647643@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Weiner <hannes@cmpxchg.org>, Alex Elder <aelder@sgi.com>
Subject: [82/85] xfs: properly account for reclaimed inodes
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
Backported-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |   16 ++++++++++++----
 fs/xfs/linux-2.6/xfs_sync.h |    1 +
 fs/xfs/xfs_iget.c           |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -712,16 +712,24 @@ xfs_inode_set_reclaim_tag(
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
 }
 
+void
+__xfs_inode_clear_reclaim_tag(
+       xfs_mount_t     *mp,
+       xfs_perag_t     *pag,
+       xfs_inode_t     *ip)
+{
+       radix_tree_tag_clear(&pag->pag_ici_root,
+                       XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+       __xfs_inode_clear_reclaim(pag, ip);
+}
+
 STATIC int
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -48,6 +48,7 @@ int xfs_reclaim_inodes(struct xfs_mount
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -499,6 +499,7 @@ xfs_ireclaim(
 	write_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root, agino))
 		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 



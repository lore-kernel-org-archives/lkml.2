Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800Ab2EOCS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:57 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53216 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947Ab2EOCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 068/179] xfs: properly account for reclaimed inodes
Date: Mon, 14 May 2012 22:12:44 -0400
Message-ID: <1337048075-6132-69-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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

[PG: upstream has xfs_reclaim_inode in fs/xfs/linux-2.6/xfs_sync.c
 but in 34 baseline, it is xfs_ireclaim in fs/xfs/xfs_iget.c so
 drop the STATIC and add a prototype for it. ]

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   10 +++++++++-
 fs/xfs/linux-2.6/xfs_sync.h |    2 ++
 fs/xfs/xfs_iget.c           |    1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index a427c63..c5a69a4 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -707,6 +707,14 @@ xfs_inode_set_reclaim_tag(
 }
 
 void
+__xfs_inode_clear_reclaim(
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	pag->pag_ici_reclaimable--;
+}
+
+void
 __xfs_inode_clear_reclaim_tag(
 	xfs_mount_t	*mp,
 	xfs_perag_t	*pag,
@@ -714,7 +722,7 @@ __xfs_inode_clear_reclaim_tag(
 {
 	radix_tree_tag_clear(&pag->pag_ici_root,
 			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	pag->pag_ici_reclaimable--;
+	__xfs_inode_clear_reclaim(pag, ip);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index cdcbaac..bf82419 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -49,6 +49,8 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim(struct xfs_perag *pag, struct xfs_inode *ip);
+
 
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 5ac3be0..14364c4 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -495,6 +495,7 @@ xfs_ireclaim(
 	write_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root, agino))
 		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
 
-- 
1.7.9.6


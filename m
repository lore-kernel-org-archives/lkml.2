Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0DVUrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:47:22 -0400
Received: from kroah.org ([198.145.64.141]:37175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab0DVT1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:36 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190908.664726284@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>
Subject: [014/197] xfs: check for not fully initialized inodes in xfs_ireclaim
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@infradead.org>

commit b44b1126279b60597f96bbe77507b1650f88a969 upstream

Add an assert for inodes not added to the inode cache in xfs_ireclaim,
to make sure we're not going to introduce something like the
famous nfsd inode cache bug again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_iget.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -511,17 +511,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	if (!radix_tree_delete(&pag->pag_ici_root, agino))
+		ASSERT(0);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 



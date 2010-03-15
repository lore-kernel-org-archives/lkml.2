Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab0COPLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:11:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab0COPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:11:39 -0400
Date: Mon, 15 Mar 2010 11:11:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
	assfail+0x1b/0x20 SS:ESP 0068:f687bf14
Message-ID: <20100315151136.GA1401@infradead.org>
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan> <4B9E46F9.8090209@sandeen.net> <alpine.DEB.2.00.1003151042390.9496@p34.internal.lan> <4B9E4863.80905@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9E4863.80905@sandeen.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 09:46:59AM -0500, Eric Sandeen wrote:
> Ok, then you hit an ASSERT_ALWAYS
> 
> There are only a few:

If the box is a nfs server I suspect it's a reclaimable state one and
the patch below should help:

---

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: fix locking for inode cache radix tree tag updates

The radix-tree code requires it's users to serialize tag updates against
other updates to the tree.  While XFS protects tag updates against each
other it does not serialize them against updates of the tree contents,
which can lead to tag corruption.  Fix the inode cache to always take
pag_ici_lock in exclusive mode when updating radix tree tags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Patrick Schreurs <patrick@news-service.com>
Tested-by: Patrick Schreurs <patrick@news-service.com>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-02-10 13:08:41.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-02-10 15:53:28.739570272 +0100
@@ -687,12 +687,12 @@ xfs_inode_set_reclaim_tag(
 	struct xfs_perag *pag;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	read_lock(&pag->pag_ici_lock);
+	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	__xfs_inode_set_reclaim_tag(pag, ip);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
+	write_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
 }
 
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-02-04 17:28:35.000000000 +0100
+++ xfs/fs/xfs/xfs_iget.c	2010-02-10 15:53:55.504284758 +0100
@@ -190,13 +190,12 @@ xfs_iget_cache_hit(
 		trace_xfs_iget_reclaim(ip);
 
 		/*
-		 * We need to set XFS_INEW atomically with clearing the
-		 * reclaimable tag so that we do have an indicator of the
-		 * inode still being initialized.
+		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
+		 * from stomping over us while we recycle the inode.  We can't
+		 * clear the radix tree reclaimable tag yet as it requires
+		 * pag_ici_lock to be helt exclusive.
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0DVT1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:37 -0400
Received: from kroah.org ([198.145.64.141]:37145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0DVT1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190908.307904873@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>
Subject: [010/197] xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@infradead.org>

commit c56c9631cbe88f08854a56ff9776c1f310916830 upstream

When xfs_free_eofblocks is called from ->release the VM might already
hold the mmap_sem, but in the write path we take the iolock before
taking the mmap_sem in the generic write code.

Switch xfs_free_eofblocks to only trylock the iolock if called from
->release and skip trimming the prellocated blocks in that case.
We'll still free them later on the final iput.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_rw.h       |    7 -------
 fs/xfs/xfs_vnodeops.c |   34 ++++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 15 deletions(-)

--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -37,13 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
 }
 
 /*
- * Flags for xfs_free_eofblocks
- */
-#define XFS_FREE_EOF_LOCK	(1<<0)
-#define XFS_FREE_EOF_NOLOCK	(1<<1)
-
-
-/*
  * helper function to extract extent size hint from inode
  */
 STATIC_INLINE xfs_extlen_t
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -709,6 +709,11 @@ xfs_fsync(
 }
 
 /*
+ * Flags for xfs_free_eofblocks
+ */
+#define XFS_FREE_EOF_TRYLOCK	(1<<0)
+
+/*
  * This is called by xfs_inactive to free any blocks beyond eof
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
@@ -726,7 +731,6 @@ xfs_free_eofblocks(
 	xfs_filblks_t	map_len;
 	int		nimaps;
 	xfs_bmbt_irec_t	imap;
-	int		use_iolock = (flags & XFS_FREE_EOF_LOCK);
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -768,14 +772,19 @@ xfs_free_eofblocks(
 		 * cache and we can't
 		 * do that within a transaction.
 		 */
-		if (use_iolock)
+		if (flags & XFS_FREE_EOF_TRYLOCK) {
+			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+				xfs_trans_cancel(tp, 0);
+				return 0;
+			}
+		} else {
 			xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		}
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			if (use_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
 
@@ -812,8 +821,7 @@ xfs_free_eofblocks(
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
 		}
-		xfs_iunlock(ip, (use_iolock ? (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)
-					    : XFS_ILOCK_EXCL));
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL);
 	}
 	return error;
 }
@@ -1113,7 +1121,17 @@ xfs_release(
 		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+
+			/*
+			 * If we can't get the iolock just skip truncating
+			 * the blocks past EOF because we could deadlock
+			 * with the mmap_sem otherwise.  We'll get another
+			 * chance to drop them once the last reference to
+			 * the inode is dropped, so we'll never leak blocks
+			 * permanently.
+			 */
+			error = xfs_free_eofblocks(mp, ip,
+						   XFS_FREE_EOF_TRYLOCK);
 			if (error)
 				return error;
 		}
@@ -1184,7 +1202,7 @@ xfs_inactive(
 		     (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		      (ip->i_delayed_blks != 0)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			error = xfs_free_eofblocks(mp, ip, 0);
 			if (error)
 				return VN_INACTIVE_CACHE;
 		}



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1JWGi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:38:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1JWGeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:08 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:40 2011
Message-Id: <20111023062540.221964043@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:47 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
        Christoph Hellwig <hch@lst.de>
Subject: [19/27] xfs: force the log if we encounter pinned buffers in .iop_pushbuf
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 17b38471c3c07a49f0bbc2ecc2e92050c164e226 upstream

We need to check for pinned buffers even in .iop_pushbuf given that inode
items flush into the same buffers that may be pinned directly due operations
on the unlinked inode list operating directly on buffers.  To do this add a
return value to .iop_pushbuf that tells the AIL push about this and use
the existing log force mechanisms to unpin it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/quota/xfs_dquot_item.c |   10 +++++++---
 fs/xfs/xfs_buf_item.c         |    3 ++-
 fs/xfs/xfs_inode_item.c       |   10 +++++++---
 fs/xfs/xfs_trans.h            |    2 +-
 fs/xfs/xfs_trans_ail.c        |    9 +++++++--
 5 files changed, 24 insertions(+), 10 deletions(-)

--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -183,13 +183,14 @@ xfs_qm_dqunpin_wait(
  * search the buffer cache can be a time consuming thing, and AIL lock is a
  * spinlock.
  */
-STATIC void
+STATIC bool
 xfs_qm_dquot_logitem_pushbuf(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_buf		*bp;
+	bool			ret = true;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
@@ -201,17 +202,20 @@ xfs_qm_dquot_logitem_pushbuf(
 	if (completion_done(&dqp->q_flush) ||
 	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_dqunlock(dqp);
-		return;
+		return true;
 	}
 
 	bp = xfs_incore(dqp->q_mount->m_ddev_targp, qlip->qli_format.qlf_blkno,
 			dqp->q_mount->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
 	xfs_dqunlock(dqp);
 	if (!bp)
-		return;
+		return true;
 	if (XFS_BUF_ISDELAYWRITE(bp))
 		xfs_buf_delwri_promote(bp);
+	if (XFS_BUF_ISPINNED(bp))
+		ret = false;
 	xfs_buf_relse(bp);
+	return ret;
 }
 
 /*
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -632,7 +632,7 @@ xfs_buf_item_push(
  * the xfsbufd to get this buffer written. We have to unlock the buffer
  * to allow the xfsbufd to write it, too.
  */
-STATIC void
+STATIC bool
 xfs_buf_item_pushbuf(
 	struct xfs_log_item	*lip)
 {
@@ -646,6 +646,7 @@ xfs_buf_item_pushbuf(
 
 	xfs_buf_delwri_promote(bp);
 	xfs_buf_relse(bp);
+	return true;
 }
 
 STATIC void
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -713,13 +713,14 @@ xfs_inode_item_committed(
  * marked delayed write. If that's the case, we'll promote it and that will
  * allow the caller to write the buffer by triggering the xfsbufd to run.
  */
-STATIC void
+STATIC bool
 xfs_inode_item_pushbuf(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp;
+	bool			ret = true;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
@@ -730,7 +731,7 @@ xfs_inode_item_pushbuf(
 	if (completion_done(&ip->i_flush) ||
 	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return;
+		return true;
 	}
 
 	bp = xfs_incore(ip->i_mount->m_ddev_targp, iip->ili_format.ilf_blkno,
@@ -738,10 +739,13 @@ xfs_inode_item_pushbuf(
 
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	if (!bp)
-		return;
+		return true;
 	if (XFS_BUF_ISDELAYWRITE(bp))
 		xfs_buf_delwri_promote(bp);
+	if (XFS_BUF_ISPINNED(bp))
+		ret = false;
 	xfs_buf_relse(bp);
+	return ret;
 }
 
 /*
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -350,7 +350,7 @@ typedef struct xfs_item_ops {
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_push)(xfs_log_item_t *);
-	void (*iop_pushbuf)(xfs_log_item_t *);
+	bool (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 } xfs_item_ops_t;
 
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -478,8 +478,13 @@ xfs_ail_worker(
 
 		case XFS_ITEM_PUSHBUF:
 			XFS_STATS_INC(xs_push_ail_pushbuf);
-			IOP_PUSHBUF(lip);
-			ailp->xa_last_pushed_lsn = lsn;
+
+			if (!IOP_PUSHBUF(lip)) {
+				stuck++;
+				flush_log = 1;
+			} else {
+				ailp->xa_last_pushed_lsn = lsn;
+			}
 			push_xfsbufd = 1;
 			break;
 



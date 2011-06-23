Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab1FWSPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:15:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:34415 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765Ab1FWRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dave Chinner <dchinner@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 105/247] xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
Date: Thu, 23 Jun 2011 13:32:53 -0400
Message-Id: <1308850515-15242-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1920779e67cbf5ea8afef317777c5bf2b8096188 upstream.

Inode numbers may come from somewhere external to the filesystem
(e.g. file handles, bulkstat information) and so are inherently
untrusted. Rename the flag we use for these lookups to make it
obvious we are doing a lookup of an untrusted inode number and need
to verify it completely before trying to read it from disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/linux-2.6/xfs_export.c |    9 ++++-----
 fs/xfs/xfs_ialloc.c           |   11 +++++++----
 fs/xfs/xfs_inode.c            |    2 +-
 fs/xfs/xfs_inode.h            |    2 +-
 fs/xfs/xfs_itable.c           |    2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index 846b75a..92c84a1 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -128,12 +128,11 @@ xfs_nfs_get_inode(
 		return ERR_PTR(-ESTALE);
 
 	/*
-	 * The XFS_IGET_BULKSTAT means that an invalid inode number is just
-	 * fine and not an indication of a corrupted filesystem.  Because
-	 * clients can send any kind of invalid file handle, e.g. after
-	 * a restore on the server we have to deal with this case gracefully.
+	 * The XFS_IGET_UNTRUSTED means that an invalid inode number is just
+	 * fine and not an indication of a corrupted filesystem as clients can
+	 * send invalid file handles and we have to handle it gracefully..
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_BULKSTAT,
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED,
 			 XFS_ILOCK_SHARED, &ip, 0);
 	if (error) {
 		/*
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 0c946c8..d8fd366 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1251,7 +1251,7 @@ xfs_imap_lookup(
 		return error;
 
 	/* for untrusted inodes check it is allocated first */
-	if ((flags & XFS_IGET_BULKSTAT) &&
+	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
 		return EINVAL;
 
@@ -1292,8 +1292,11 @@ xfs_imap(
 	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
 	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 #ifdef DEBUG
-		/* no diagnostics for bulkstat, ino comes from userspace */
-		if (flags & XFS_IGET_BULKSTAT)
+		/*
+		 * Don't output diagnostic information for untrusted inodes
+		 * as they can be invalid without implying corruption.
+		 */
+		if (flags & XFS_IGET_UNTRUSTED)
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
@@ -1329,7 +1332,7 @@ xfs_imap(
 	 * inodes in stale state on disk. Hence we have to do a btree lookup
 	 * in all cases where an untrusted inode number is passed.
 	 */
-	if (flags & XFS_IGET_BULKSTAT) {
+	if (flags & XFS_IGET_UNTRUSTED) {
 		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0ffd564..078811f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -177,7 +177,7 @@ xfs_imap_to_bp(
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (iget_flags & XFS_IGET_BULKSTAT) {
+			if (iget_flags & XFS_IGET_UNTRUSTED) {
 				xfs_trans_brelse(tp, bp);
 				return XFS_ERROR(EINVAL);
 			}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9965e40..6b31b38 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -500,7 +500,7 @@ do { \
  * Flags for xfs_iget()
  */
 #define XFS_IGET_CREATE		0x1
-#define XFS_IGET_BULKSTAT	0x2
+#define XFS_IGET_UNTRUSTED	0x2
 
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
 			    xfs_ino_t, struct xfs_dinode **,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 83d7827..2acd12f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,7 +80,7 @@ xfs_bulkstat_one_int(
 		return XFS_ERROR(ENOMEM);
 
 	error = xfs_iget(mp, NULL, ino,
-			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
+			 XFS_IGET_UNTRUSTED, XFS_ILOCK_SHARED, &ip, bno);
 	if (error) {
 		*stat = BULKSTAT_RV_NOTHING;
 		goto out_free;
-- 
1.7.4.4


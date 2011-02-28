Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1B1Qqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:46:43 -0500
Received: from kroah.org ([198.145.64.141]:48082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab1B1Qhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:09 2011
Message-Id: <20110228162409.238495322@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dannf@debian.org
Subject: [35/68] xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 1920779e67cbf5ea8afef317777c5bf2b8096188

Inode numbers may come from somewhere external to the filesystem
(e.g. file handles, bulkstat information) and so are inherently
untrusted. Rename the flag we use for these lookups to make it
obvious we are doing a lookup of an untrusted inode number and need
to verify it completely before trying to read it from disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[dannf: backported to 2.6.32.y]
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_export.c |    9 ++++-----
 fs/xfs/xfs_ialloc.c           |   11 +++++++----
 fs/xfs/xfs_inode.c            |    2 +-
 fs/xfs/xfs_inode.h            |    2 +-
 fs/xfs/xfs_itable.c           |    2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -127,12 +127,11 @@ xfs_nfs_get_inode(
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
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1256,7 +1256,7 @@ xfs_imap_lookup(
 		return error;
 
 	/* for untrusted inodes check it is allocated first */
-	if ((flags & XFS_IGET_BULKSTAT) &&
+	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
 		return EINVAL;
 
@@ -1297,8 +1297,11 @@ xfs_imap(
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
@@ -1334,7 +1337,7 @@ xfs_imap(
 	 * inodes in stale state on disk. Hence we have to do a btree lookup
 	 * in all cases where an untrusted inode number is passed.
 	 */
-	if (flags & XFS_IGET_BULKSTAT) {
+	if (flags & XFS_IGET_UNTRUSTED) {
 		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
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
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -558,7 +558,7 @@ do { \
  * Flags for xfs_iget()
  */
 #define XFS_IGET_CREATE		0x1
-#define XFS_IGET_BULKSTAT	0x2
+#define XFS_IGET_UNTRUSTED	0x2
 
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
 			    xfs_ino_t, struct xfs_dinode **,
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



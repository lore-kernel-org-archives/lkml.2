Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1B1Qhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:45 -0500
Received: from kroah.org ([198.145.64.141]:48098 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab1B1Qhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:09 2011
Message-Id: <20110228162409.435886249@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dannf@debian.org
Subject: [37/68] xfs: fix untrusted inode number lookup
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 4536f2ad8b330453d7ebec0746c4374eadd649b1

Commit 7124fe0a5b619d65b739477b3b55a20bf805b06d ("xfs: validate untrusted inode
numbers during lookup") changes the inode lookup code to do btree lookups for
untrusted inode numbers. This change made an invalid assumption about the
alignment of inodes and hence incorrectly calculated the first inode in the
cluster. As a result, some inode numbers were being incorrectly considered
invalid when they were actually valid.

The issue was not picked up by the xfstests suite because it always runs fsr
and dump (the two utilities that utilise the bulkstat interface) on cache hot
inodes and hence the lookup code in the cold cache path was not sufficiently
exercised to uncover this intermittent problem.

Fix the issue by relaxing the btree lookup criteria and then checking if the
record returned contains the inode number we are lookup for. If it we get an
incorrect record, then the inode number is invalid.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[dannf: Backported to 2.6.32.y]
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_ialloc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1220,7 +1220,6 @@ xfs_imap_lookup(
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
-	xfs_agino_t		startino;
 	int			error;
 	int			i;
 
@@ -1236,13 +1235,13 @@ xfs_imap_lookup(
 	}
 
 	/*
-	 * derive and lookup the exact inode record for the given agino. If the
-	 * record cannot be found, then it's an invalid inode number and we
-	 * should abort.
+	 * Lookup the inode record for the given agino. If the record cannot be
+	 * found, then it's an invalid inode number and we should abort. Once
+	 * we have a record, we need to ensure it contains the inode number
+	 * we are looking up.
 	 */
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-	startino = agino & ~(XFS_IALLOC_INODES(mp) - 1);
-	error = xfs_inobt_lookup(cur, startino, XFS_LOOKUP_EQ, &i);
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
 			error = xfs_inobt_get_rec(cur, &rec, &i);
@@ -1255,6 +1254,11 @@ xfs_imap_lookup(
 	if (error)
 		return error;
 
+	/* check that the returned record contains the required inode */
+	if (rec.ir_startino > agino ||
+	    rec.ir_startino + XFS_IALLOC_INODES(mp) <= agino)
+		return EINVAL;
+
 	/* for untrusted inodes check it is allocated first */
 	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))



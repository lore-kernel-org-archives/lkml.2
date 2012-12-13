Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab2LMOpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:45:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2LMOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 113/241] xfs: drop buffer io reference when a bad bio is built
Date: Thu, 13 Dec 2012 11:57:58 -0200
Message-Id: <1355407206-17100-114-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit d69043c42d8c6414fa28ad18d99973aa6c1c2e24 upstream.

Error handling in xfs_buf_ioapply_map() does not handle IO reference
counts correctly. We increment the b_io_remaining count before
building the bio, but then fail to decrement it in the failure case.
This leads to the buffer never running IO completion and releasing
the reference that the IO holds, so at unmount we can leak the
buffer. This leak is captured by this assert failure during unmount:

XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/xfs_mount.c, line: 273

This is not a new bug - the b_io_remaining accounting has had this
problem for a long, long time - it's just very hard to get a
zero length bio being built by this code...

Further, the buffer IO error can be overwritten on a multi-segment
buffer by subsequent bio completions for partial sections of the
buffer. Hence we should only set the buffer error status if the
buffer is not already carrying an error status. This ensures that a
partial IO error on a multi-segment buffer will not be lost. This
part of the problem is a regression, however.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/xfs/xfs_buf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 269b35c..9fade8c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1135,9 +1135,14 @@ xfs_buf_bio_end_io(
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
 
-	xfs_buf_ioerror(bp, -error);
+	/*
+	 * don't overwrite existing errors - otherwise we can lose errors on
+	 * buffers that require multiple bios to complete.
+	 */
+	if (!bp->b_error)
+		xfs_buf_ioerror(bp, -error);
 
-	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
 	_xfs_buf_ioend(bp, 1);
@@ -1213,6 +1218,11 @@ next_chunk:
 		if (size)
 			goto next_chunk;
 	} else {
+		/*
+		 * This is guaranteed not to be the last io reference count
+		 * because the caller (xfs_buf_iorequest) holds a count itself.
+		 */
+		atomic_dec(&bp->b_io_remaining);
 		xfs_buf_ioerror(bp, EIO);
 		bio_put(bio);
 	}
-- 
1.7.9.5


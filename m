Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2LMOEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44264 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2LMOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 065/241] xfs: fix buffer shudown reference count mismatch
Date: Thu, 13 Dec 2012 11:57:10 -0200
Message-Id: <1355407206-17100-66-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 03b1293edad462ad1ad62bcc5160c76758e450d5 upstream.

When we shut down the filesystem, we have to unpin and free all the
buffers currently active in the CIL. To do this we unpin and remove
them in one operation as a result of a failed iclogbuf write. For
buffers, we do this removal via a simultated IO completion of after
marking the buffer stale.

At the time we do this, we have two references to the buffer - the
active LRU reference and the buf log item.  The LRU reference is
removed by marking the buffer stale, and the active CIL reference is
by the xfs_buf_iodone() callback that is run by
xfs_buf_do_callbacks() during ioend processing (via the bp->b_iodone
callback).

However, ioend processing requires one more reference - that of the
IO that it is completing. We don't have this reference, so we free
the buffer prematurely and use it after it is freed. For buffers
marked with XBF_ASYNC, this leads to assert failures in
xfs_buf_rele() on debug kernels because the b_hold count is zero.

Fix this by making sure we take the necessary IO reference before
starting IO completion processing on the stale buffer, and set the
XBF_ASYNC flag to ensure that IO completion processing removes all
the active references from the buffer to ensure it is fully torn
down.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/xfs/xfs_buf_item.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d9e4511..d4e4a21 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -459,7 +459,25 @@ xfs_buf_item_unpin(
 		}
 		xfs_buf_relse(bp);
 	} else if (freed && remove) {
+		/*
+		 * There are currently two references to the buffer - the active
+		 * LRU reference and the buf log item. What we are about to do
+		 * here - simulate a failed IO completion - requires 3
+		 * references.
+		 *
+		 * The LRU reference is removed by the xfs_buf_stale() call. The
+		 * buf item reference is removed by the xfs_buf_iodone()
+		 * callback that is run by xfs_buf_do_callbacks() during ioend
+		 * processing (via the bp->b_iodone callback), and then finally
+		 * the ioend processing will drop the IO reference if the buffer
+		 * is marked XBF_ASYNC.
+		 *
+		 * Hence we need to take an additional reference here so that IO
+		 * completion processing doesn't free the buffer prematurely.
+		 */
 		xfs_buf_lock(bp);
+		xfs_buf_hold(bp);
+		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_UNDONE(bp);
 		xfs_buf_stale(bp);
-- 
1.7.9.5


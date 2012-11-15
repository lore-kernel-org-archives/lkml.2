Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab2KOE1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:27:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:49536 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993122Ab2KOEMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Chinner <dchinner@redhat.com>, Mark Tinguely <tinguely@sgi.com>,
        Ben Myers <bpm@sgi.com>
Subject: [ 66/66] xfs: fix buffer shudown reference count mismatch
Date: Wed, 14 Nov 2012 20:11:11 -0800
Message-Id: <20121115040943.896591966@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_buf_item.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -526,7 +526,25 @@ xfs_buf_item_unpin(
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



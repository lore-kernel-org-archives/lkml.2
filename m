Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0GMHvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:51:23 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:59800 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752212Ab0GMHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:51:21 -0400
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH 1/2] xfs: don't block on buffer read errors
Date: Tue, 13 Jul 2010 17:50:49 +1000
Message-Id: <1279007450-10457-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279007450-10457-1-git-send-email-david@fromorbit.com>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_buf_read() fails to detect dispatch errors before attempting to
wait on sychronous IO. If there was an error, it will get stuck
forever, waiting for an I/O that was never started. Make sure the
error is detected correctly.

Further, such a failure can leave locked pages in the page cache
which will cause a later operation to hang on the page. Ensure that
we correctly process pages in the buffers when we get a dispatch
error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 76bb13c..ec79634 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -578,7 +578,7 @@ _xfs_buf_read(
 			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
 
 	status = xfs_buf_iorequest(bp);
-	if (!status && !(flags & XBF_ASYNC))
+	if (!(status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC)))
 		status = xfs_buf_iowait(bp);
 	return status;
 }
@@ -1280,8 +1280,19 @@ submit_io:
 		if (size)
 			goto next_chunk;
 	} else {
-		bio_put(bio);
+		/*
+		 * if we get here, no pages were added to the bio. However,
+		 * we can't just error out here - if the pages are locked then
+		 * we have to unlock them otherwise we can hang on a later
+		 * access to the page.
+		 */
 		xfs_buf_ioerror(bp, EIO);
+		if (bp->b_flags & _XBF_PAGE_LOCKED) {
+			int i;
+			for (i = 0; i < bp->b_page_count; i++)
+				unlock_page(bp->b_pages[i]);
+		}
+		bio_put(bio);
 	}
 }
 
-- 
1.7.1


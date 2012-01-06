Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283Ab2AFKVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:21:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35731 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030269Ab2AFKVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:21:40 -0500
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Alex Elder <aelder@sgi.com>, xfs masters <xfs-masters@oss.sgi.com>,
        xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/1] xfs: serialise unaligned direct IOs
Date: Fri,  6 Jan 2012 16:03:10 +0530
Message-Id: <1325845990-5664-1-git-send-email-amit.sahrawat83@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Sahrawat<amit.sahrawat83@gmail.com>

[ This patch published in 2.6.38 kernel(Original reference
http://oss.sgi.com/archives/xfs/2011-01/msg00013.html), but
can not be applied to 2.6.35 kernel directly, because of the
absence of required function, its reimplmented to resolve
xfstest test 240 fail.]

When two concurrent unaligned, non-overlapping direct IOs are issued
to the same block, the direct Io layer will race to zero the block.
The result is that one of the concurrent IOs will overwrite data
written by the other IO with zeros. This is demonstrated by the
xfsqa test 240.

To avoid this problem, serialise all unaligned direct IOs to an
inode with a big hammer. We need a big hammer approach as we need to
serialise AIO as well, so we can't just block writes on locks.
Hence, the big hammer is calling xfs_ioend_wait() while holding out
other unaligned direct IOs from starting.

We don't bother trying to serialised aligned vs unaligned IOs as
they are overlapping IO and the result of concurrent overlapping IOs
is undefined - the result of either IO is a valid result so we let
them race. Hence we only penalise unaligned IO, which already has a
major overhead compared to aligned IO so this isn't a major problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   39 ++++++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 257a56b..b943aa1 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -629,6 +629,7 @@ xfs_file_aio_write(
 	int			iolock;
 	int			eventsent = 0;
 	size_t			ocount = 0, count;
+	int			unaligned_io = 0;
 	int			need_i_mutex;
 
 	XFS_STATS_INC(xs_write_calls);
@@ -709,8 +710,26 @@ start:
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			return XFS_ERROR(-EINVAL);
 		}
+	/*
+	 * In most cases the direct IO writes will be done with IOLOCK_SHARED
+	 * allowing them to be done in parallel with reads and other direct IO
+	 * writes. However,if the IO is not aligned to filesystem blocks, the
+	 * direct IO layer needs to do sub-block zeroing and that requires
+	 * serialisation against other direct IOs to the same block. In this
+	 * case we need to serialise the submission of the unaligned IOs so
+	 * that we don't get racing block zeroing in the dio layer.
+	 * To avoid the problem with aio, we also need to wait for outstanding
+	 * IOs to complete so that unwritten extent conversion is completed
+	 * before we try to map the overlapping block. This is currently
+	 * implemented by hitting it with a big hammer (i.e. xfs_ioend_wait()).
+	 */
+
+		if ((pos & mp->m_blockmask) ||
+		   ((pos + count) & mp->m_blockmask))
+			unaligned_io = 1;
 
-		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
+		if (!need_i_mutex &&
+		   (unaligned_io || mapping->nrpages || pos > ip->i_size)) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
 			need_i_mutex = 1;
@@ -769,12 +788,18 @@ start:
 		}
 
 		if (need_i_mutex) {
-			/* demote the lock now the cached pages are gone */
-			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-			mutex_unlock(&inode->i_mutex);
-
-			iolock = XFS_IOLOCK_SHARED;
-			need_i_mutex = 0;
+			if (unaligned_io)
+				xfs_ioend_wait(ip);
+			else {
+				/*
+				 * demote the lock now the cached pages
+				 * are gone if we can
+				 */
+				xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+				iolock = XFS_IOLOCK_SHARED;
+				mutex_unlock(&inode->i_mutex);
+				need_i_mutex = 0;
+			}
 		}
 
 		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
-- 
1.7.2.3


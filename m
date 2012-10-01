Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab2JAXBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:13 -0400
Received: from 1wt.eu ([62.212.114.60]:35276 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab2JAXA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:59 -0400
Message-Id: <20121001225200.321008899@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Ben Myers <bpm@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 064/180] xfs: Fix oops on IO error during xlog_recover_process_iunlinks()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit d97d32edcd732110758799ae60af725e5110b3dc upstream.

When an IO error happens during inode deletion run from
xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
count with the fact that read of a buffer which was read a while ago can
really fail which results in the oops on
  agi = XFS_BUF_TO_AGI(agibp);

Fix the problem by cleaning up the buffer handling in
xlog_recover_process_iunlinks() as suggested by Dave Chinner. We release buffer
lock but keep buffer reference to AG buffer. That is enough for buffer to stay
pinned in memory and we don't have to call xfs_read_agi() all the time.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/xfs/xfs_log_recover.c |   33 +++++++++++----------------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 844a99b..bae2c99 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3298,37 +3298,26 @@ xlog_recover_process_iunlinks(
 			 */
 			continue;
 		}
+		/*
+		 * Unlock the buffer so that it can be acquired in the normal
+		 * course of the transaction to truncate and free each inode.
+		 * Because we are not racing with anyone else here for the AGI
+		 * buffer, we don't even need to hold it locked to read the
+		 * initial unlinked bucket entries out of the buffer. We keep
+		 * buffer reference though, so that it stays pinned in memory
+		 * while we need the buffer.
+		 */
 		agi = XFS_BUF_TO_AGI(agibp);
+		xfs_buf_unlock(agibp);
 
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
 			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 			while (agino != NULLAGINO) {
-				/*
-				 * Release the agi buffer so that it can
-				 * be acquired in the normal course of the
-				 * transaction to truncate and free the inode.
-				 */
-				xfs_buf_relse(agibp);
-
 				agino = xlog_recover_process_one_iunlink(mp,
 							agno, agino, bucket);
-
-				/*
-				 * Reacquire the agibuffer and continue around
-				 * the loop. This should never fail as we know
-				 * the buffer was good earlier on.
-				 */
-				error = xfs_read_agi(mp, NULL, agno, &agibp);
-				ASSERT(error == 0);
-				agi = XFS_BUF_TO_AGI(agibp);
 			}
 		}
-
-		/*
-		 * Release the buffer for the current agi so we can
-		 * go on to the next one.
-		 */
-		xfs_buf_relse(agibp);
+		xfs_buf_rele(agibp);
 	}
 
 	mp->m_dmevmask = mp_dmevmask;
-- 
1.7.2.1.45.g54fbc




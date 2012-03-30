Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936324Ab2C3Vil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:38:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51831 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936223Ab2C3VcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:10 -0400
X-Sasl-enc: h82pLdVC2HjLOK2ybnnjnv20bxlJzFccICMUHPDc5e5B 1333143129
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:57 2012
Message-Id: <20120330194857.147602518@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>
Subject: [ 154/175] xfs: Fix oops on IO error during xlog_recover_process_iunlinks()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/xfs/xfs_log_recover.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3161,37 +3161,26 @@ xlog_recover_process_iunlinks(
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



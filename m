Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0CQT7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:59:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab0CQT7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:59:14 -0400
Message-ID: <4BA13490.5070201@suse.com>
Date: Wed, 17 Mar 2010 15:59:12 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.3 Thunderbird/3.0.3
MIME-Version: 1.0
To: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] reiserfs: Properly honor read-only devices
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The reiserfs journal behaves inconsistently when determining whether
 to allow a mount of a read-only device.

 This is due to the use of the continue_replay variable to short circuit
 the journal scanning. If it's set, it's assumed that there are
 transactions to replay, but there may not be. If it's unset, it's assumed
 that there aren't any, and that may not be the case either.

 I've observed two failure cases:
 1) Where a clean file system on a read-only device refuses to mount
 2) Where a clean file system on a read-only device passes the
    optimization and then tries writing the journal header to update
    the latest mount id.

 The former is easily observable by using a freshly created file system
 on a read-only loopback device.

 This patch moves the check into journal_read_transaction, where it
 can bail out before it's about to replay a transaction. That way it
 can go through and skip transactions where appropriate, yet still
 refuse to mount a file system with outstanding transactions.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/journal.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2217,6 +2217,15 @@ static int journal_read_transaction(stru
 		brelse(d_bh);
 		return 1;
 	}
+
+	if (bdev_read_only(sb->s_bdev)) {
+		reiserfs_warning(sb, "clm-2076",
+				 "device is readonly, unable to replay log");
+		brelse(c_bh);
+		brelse(d_bh);
+		return -EROFS;
+	}
+
 	trans_id = get_desc_trans_id(desc);
 	/* now we know we've got a good transaction, and it was inside the valid time ranges */
 	log_blocks = kmalloc(get_desc_trans_len(desc) *
@@ -2459,12 +2468,6 @@ static int journal_read(struct super_blo
 		goto start_log_replay;
 	}
 
-	if (continue_replay && bdev_read_only(sb->s_bdev)) {
-		reiserfs_warning(sb, "clm-2076",
-				 "device is readonly, unable to replay log");
-		return -1;
-	}
-
 	/* ok, there are transactions that need to be replayed.  start with the first log block, find
 	 ** all the valid transactions, and pick out the oldest.
 	 */
-- 
Jeff Mahoney
SUSE Labs

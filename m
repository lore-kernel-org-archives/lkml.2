Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab0HLA32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:29:28 -0400
Received: from kroah.org ([198.145.64.141]:43706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099Ab0HKX7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:24 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:04 2010
Message-Id: <20100811235504.622475162@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>
Subject: [098/111] reiserfs: properly honor read-only devices
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 3f8b5ee33293d43ca360771b535dfae8c57259dc upstream.

The reiserfs journal behaves inconsistently when determining whether to
allow a mount of a read-only device.

This is due to the use of the continue_replay variable to short circuit
the journal scanning.  If it's set, it's assumed that there are
transactions to replay, but there may not be.  If it's unset, it's assumed
that there aren't any, and that may not be the case either.

I've observed two failure cases:
1) Where a clean file system on a read-only device refuses to mount
2) Where a clean file system on a read-only device passes the
   optimization and then tries writing the journal header to update
   the latest mount id.

The former is easily observable by using a freshly created file system on
a read-only loopback device.

This patch moves the check into journal_read_transaction, where it can
bail out before it's about to replay a transaction.  That way it can go
through and skip transactions where appropriate, yet still refuse to mount
a file system with outstanding transactions.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/journal.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2184,6 +2184,15 @@ static int journal_read_transaction(stru
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
@@ -2422,12 +2431,6 @@ static int journal_read(struct super_blo
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



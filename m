Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0ICKel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:34:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:35789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab0ICKb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:26 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 35/41] jbd2: replace barriers with explicit flush / FUA usage
Date: Fri,  3 Sep 2010 12:29:50 +0200
Message-Id: <1283509796-1510-36-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for journal commits and remove the
EOPNOTSUPP detection for barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/jbd2/commit.c |   43 ++++---------------------------------------
 1 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d6aeb1f..f204e27 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -134,25 +134,11 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
-				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
-		ret = submit_bh(WRITE_SYNC_PLUG | WRITE_BARRIER, bh);
-		if (ret == -EOPNOTSUPP) {
-			printk(KERN_WARNING
-			       "JBD2: Disabling barriers on %s, "
-			       "not supported by device\n", journal->j_devname);
-			write_lock(&journal->j_state_lock);
-			journal->j_flags &= ~JBD2_BARRIER;
-			write_unlock(&journal->j_state_lock);
-
-			/* And try again, without the barrier */
-			lock_buffer(bh);
-			set_buffer_uptodate(bh);
-			clear_buffer_dirty(bh);
-			ret = submit_bh(WRITE_SYNC_PLUG, bh);
-		}
-	} else {
+				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
+		ret = submit_bh(WRITE_SYNC_PLUG | WRITE_FLUSH_FUA, bh);
+	else
 		ret = submit_bh(WRITE_SYNC_PLUG, bh);
-	}
+
 	*cbh = bh;
 	return ret;
 }
@@ -166,29 +152,8 @@ static int journal_wait_on_commit_record(journal_t *journal,
 {
 	int ret = 0;
 
-retry:
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
-	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
-		printk(KERN_WARNING
-		       "JBD2: %s: disabling barries on %s - not supported "
-		       "by device\n", __func__, journal->j_devname);
-		write_lock(&journal->j_state_lock);
-		journal->j_flags &= ~JBD2_BARRIER;
-		write_unlock(&journal->j_state_lock);
-
-		lock_buffer(bh);
-		clear_buffer_dirty(bh);
-		set_buffer_uptodate(bh);
-		bh->b_end_io = journal_end_buffer_io_sync;
-
-		ret = submit_bh(WRITE_SYNC_PLUG, bh);
-		if (ret) {
-			unlock_buffer(bh);
-			return ret;
-		}
-		goto retry;
-	}
 
 	if (unlikely(!buffer_uptodate(bh)))
 		ret = -EIO;
-- 
1.7.1


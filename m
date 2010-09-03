Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab0ICKdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:33:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:35797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab0ICKb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:27 -0400
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
Subject: [PATCH 33/41] jbd: replace barriers with explicit flush / FUA usage
Date: Fri,  3 Sep 2010 12:29:48 +0200
Message-Id: <1283509796-1510-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:47 +0000 (UTC)
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
 fs/jbd/commit.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 95d8c11..484c5e5 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -137,34 +137,10 @@ static int journal_write_commit_record(journal_t *journal,
 	JBUFFER_TRACE(descriptor, "write commit block");
 	set_buffer_dirty(bh);
 
-	if (journal->j_flags & JFS_BARRIER) {
-		ret = __sync_dirty_buffer(bh, WRITE_SYNC | WRITE_BARRIER);
-
-		/*
-		 * Is it possible for another commit to fail at roughly
-		 * the same time as this one?  If so, we don't want to
-		 * trust the barrier flag in the super, but instead want
-		 * to remember if we sent a barrier request
-		 */
-		if (ret == -EOPNOTSUPP) {
-			char b[BDEVNAME_SIZE];
-
-			printk(KERN_WARNING
-				"JBD: barrier-based sync failed on %s - "
-				"disabling barriers\n",
-				bdevname(journal->j_dev, b));
-			spin_lock(&journal->j_state_lock);
-			journal->j_flags &= ~JFS_BARRIER;
-			spin_unlock(&journal->j_state_lock);
-
-			/* And try again, without the barrier */
-			set_buffer_uptodate(bh);
-			set_buffer_dirty(bh);
-			ret = sync_dirty_buffer(bh);
-		}
-	} else {
+	if (journal->j_flags & JFS_BARRIER)
+		ret = __sync_dirty_buffer(bh, WRITE_SYNC | WRITE_FLUSH_FUA);
+	else
 		ret = sync_dirty_buffer(bh);
-	}
 
 	put_bh(bh);		/* One for getblk() */
 	journal_put_journal_head(descriptor);
-- 
1.7.1


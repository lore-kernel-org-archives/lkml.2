Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0HYPyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:54:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:52825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0HYPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:53:57 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/30] jbd: replace barriers with explicit flush / FUA usage
Date: Wed, 25 Aug 2010 17:47:41 +0200
Message-Id: <1282751267-3530-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 15:53:25 +0000 (UTC)
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


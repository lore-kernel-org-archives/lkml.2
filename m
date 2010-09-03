Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0ICKeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:34:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:35787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108Ab0ICKb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 34/41] jbd2: Modify ASYNC_COMMIT code to not rely on queue draining on barrier
Date: Fri,  3 Sep 2010 12:29:49 +0200
Message-Id: <1283509796-1510-35-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
feature is set. This property is going away so make JBD2 wait for buffers it
needs on its own before submitting the cache flush.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/jbd2/commit.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7c068c1..d6aeb1f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -701,6 +701,16 @@ start_journal_io:
 		}
 	}
 
+	err = journal_finish_inode_data_buffers(journal, commit_transaction);
+	if (err) {
+		printk(KERN_WARNING
+			"JBD2: Detected IO errors while flushing file data "
+		       "on %s\n", journal->j_devname);
+		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
+			jbd2_journal_abort(journal, err);
+		err = 0;
+	}
+
 	/* 
 	 * If the journal is not located on the file system device,
 	 * then we must flush the file system device before we issue
@@ -719,19 +729,6 @@ start_journal_io:
 						 &cbh, crc32_sum);
 		if (err)
 			__jbd2_journal_abort_hard(journal);
-		if (journal->j_flags & JBD2_BARRIER)
-			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
-				BLKDEV_IFL_WAIT);
-	}
-
-	err = journal_finish_inode_data_buffers(journal, commit_transaction);
-	if (err) {
-		printk(KERN_WARNING
-			"JBD2: Detected IO errors while flushing file data "
-		       "on %s\n", journal->j_devname);
-		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
-			jbd2_journal_abort(journal, err);
-		err = 0;
 	}
 
 	/* Lo and behold: we have just managed to send a transaction to
@@ -845,6 +842,12 @@ wait_for_iobuf:
 	}
 	if (!err && !is_journal_aborted(journal))
 		err = journal_wait_on_commit_record(journal, cbh);
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
+				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
+	    journal->j_flags & JBD2_BARRIER) {
+		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
+				   BLKDEV_IFL_WAIT);
+	}
 
 	if (err)
 		jbd2_journal_abort(journal, err);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0HZJml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0HZJmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:42:39 -0400
Message-ID: <4C7635BC.10402@suse.de>
Date: Thu, 26 Aug 2010 11:37:00 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        sshtylyov@mvista.com
Subject: [PATCH UPDATED 24.5/30] jbd2: Modify ASYNC_COMMIT code to not rely
 on queue draining on barrier
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <4C762476.2020802@suse.de>
In-Reply-To: <4C762476.2020802@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
feature is set. This property is going away so make JBD2 wait for buffers it
needs on its own before submitting the cache flush.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Fixed overindentation noticed by Sergei.  git tree updated accordingly.

Thanks.

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


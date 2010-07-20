Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464Ab0GTUIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:08:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0GTUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=V+3w5vovm78EefOz1HME6AsozQpnGPHmBCRWXFkePZNsgTi1b/Qgw7+DscOKpOQM4j
         RNHeXUa5TfFGkhR2Sz3CZtjDp+RyCyJG/F5ua6Vk6Ak60enI8Y/1poqe6XIOzDDWDjvx
         IH9WqnWm67fwns8/oWjC6Wu1YO1Ui6FxktFzg=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
        "Linux-Kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfq: improve fsync performance for small files
Date: Tue, 20 Jul 2010 22:09:04 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33.4cz; KDE/4.2.4; i686; ; )
Cc: Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007202209.04627.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fsync performance for small files achieved by cfq on high-end disks is
lower than what deadline can achieve, due to idling introduced between
the sync write happening in process context and the journal commit.

Moreover, when competing with a sequential reader, a process writing
small files and fsync-ing them is starved.

This patch fixes the two problems by:
- marking journal commits as WRITE_SYNC, so that they get the REQ_NOIDLE
  flag set,
- force all queues that have REQ_NOIDLE requests to be put in the noidle
  tree.

Having the queue associated to the fsync-ing process and the one associated
 to journal commits in the noidle tree allows:
- switching between them without idling,
- fairness vs. competing idling queues, since they will be serviced only
  after the noidle tree expires its slice.

Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   18 ++++--------------
 fs/jbd/commit.c     |    2 +-
 fs/jbd2/commit.c    |    2 +-
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index eb4086f..49dada4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -216,7 +216,6 @@ struct cfq_data {
 	enum wl_type_t serving_type;
 	unsigned long workload_expires;
 	struct cfq_group *serving_group;
-	bool noidle_tree_requires_idle;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -2126,7 +2125,6 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
 	cfq_log(cfqd, "workload slice:%d", slice);
 	cfqd->workload_expires = jiffies + slice;
-	cfqd->noidle_tree_requires_idle = false;
 }
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
@@ -3108,7 +3106,9 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
 		cfq_mark_cfqq_deep(cfqq);
 
-	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
+	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
+		enable_idle = 0;
+	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
 	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
@@ -3421,17 +3421,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_slice_expired(cfqd, 1);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
-			cfqd->noidle_tree_requires_idle |=
-				!(rq->cmd_flags & REQ_NOIDLE);
-			/*
-			 * Idling is enabled for SYNC_WORKLOAD.
-			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
-			 * only if we processed at least one !REQ_NOIDLE request
-			 */
-			if (cfqd->serving_type == SYNC_WORKLOAD
-			    || cfqd->noidle_tree_requires_idle
-			    || cfqq->cfqg->nr_cfqq == 1)
-				cfq_arm_slice_timer(cfqd);
+			cfq_arm_slice_timer(cfqd);
 		}
 	}
 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 28a9dda..d97a0c6 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -317,7 +317,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
-	int write_op = WRITE;
+	int write_op = WRITE_SYNC;
 
 	/*
 	 * First job: lock down the current transaction and wait for
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 75716d3..a078744 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -369,7 +369,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
-	int write_op = WRITE;
+	int write_op = WRITE_SYNC;
 
 	/*
 	 * First job: lock down the current transaction and wait for
-- 
1.6.2.5



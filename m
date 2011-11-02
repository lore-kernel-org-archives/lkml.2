Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab1KCCII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:08:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933577Ab1KCBgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.197767137@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: [088/107] cfq: break apart merged cfqqs if they stop cooperating
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Jeff Moyer <jmoyer@redhat.com>

commit e6c5bc737ab71e4af6025ef7d150f5a26ae5f146 upstream.

cfq_queues are merged if they are issuing requests within the mean seek
distance of one another.  This patch detects when the coopearting stops and
breaks the queues back up.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 3 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -38,6 +38,12 @@ static int cfq_slice_idle = HZ / 125;
  */
 #define CFQ_MIN_TT		(2)
 
+/*
+ * Allow merged cfqqs to perform this amount of seeky I/O before
+ * deciding to break the queues up again.
+ */
+#define CFQQ_COOP_TOUT		(HZ)
+
 #define CFQ_SLICE_SCALE		(5)
 #define CFQ_HW_QUEUE_MIN	(5)
 
@@ -116,6 +122,7 @@ struct cfq_queue {
 	u64 seek_total;
 	sector_t seek_mean;
 	sector_t last_request_pos;
+	unsigned long seeky_start;
 
 	pid_t pid;
 
@@ -1041,6 +1048,11 @@ static struct cfq_queue *cfq_close_coope
 {
 	struct cfq_queue *cfqq;
 
+	if (!cfq_cfqq_sync(cur_cfqq))
+		return NULL;
+	if (CFQQ_SEEKY(cur_cfqq))
+		return NULL;
+
 	/*
 	 * We should notice if some of the queues are cooperating, eg
 	 * working closely on the same area of the disk. In that case,
@@ -1055,6 +1067,8 @@ static struct cfq_queue *cfq_close_coope
 	 */
 	if (!cfq_cfqq_sync(cfqq))
 		return NULL;
+	if (CFQQ_SEEKY(cfqq))
+		return NULL;
 
 	return cfqq;
 }
@@ -1186,7 +1200,7 @@ static int cfqq_process_refs(struct cfq_
 
 static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 {
-	int process_refs;
+	int process_refs, new_process_refs;
 	struct cfq_queue *__cfqq;
 
 	/* Avoid a circular list and skip interim queue merges */
@@ -1204,8 +1218,17 @@ static void cfq_setup_merge(struct cfq_q
 	if (process_refs == 0)
 		return;
 
-	cfqq->new_cfqq = new_cfqq;
-	atomic_add(process_refs, &new_cfqq->ref);
+	/*
+	 * Merge in the direction of the lesser amount of work.
+	 */
+	new_process_refs = cfqq_process_refs(new_cfqq);
+	if (new_process_refs >= process_refs) {
+		cfqq->new_cfqq = new_cfqq;
+		atomic_add(process_refs, &new_cfqq->ref);
+	} else {
+		new_cfqq->new_cfqq = cfqq;
+		atomic_add(new_process_refs, &cfqq->ref);
+	}
 }
 
 /*
@@ -2040,6 +2063,19 @@ cfq_update_io_seektime(struct cfq_data *
 	total = cfqq->seek_total + (cfqq->seek_samples/2);
 	do_div(total, cfqq->seek_samples);
 	cfqq->seek_mean = (sector_t)total;
+
+	/*
+	 * If this cfqq is shared between multiple processes, check to
+	 * make sure that those processes are still issuing I/Os within
+	 * the mean seek distance.  If not, it may be time to break the
+	 * queues apart again.
+	 */
+	if (cfq_cfqq_coop(cfqq)) {
+		if (CFQQ_SEEKY(cfqq) && !cfqq->seeky_start)
+			cfqq->seeky_start = jiffies;
+		else if (!CFQQ_SEEKY(cfqq))
+			cfqq->seeky_start = 0;
+	}
 }
 
 /*
@@ -2410,6 +2446,32 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, s
 	return cic_to_cfqq(cic, 1);
 }
 
+static int should_split_cfqq(struct cfq_queue *cfqq)
+{
+	if (cfqq->seeky_start &&
+	    time_after(jiffies, cfqq->seeky_start + CFQQ_COOP_TOUT))
+		return 1;
+	return 0;
+}
+
+/*
+ * Returns NULL if a new cfqq should be allocated, or the old cfqq if this
+ * was the last process referring to said cfqq.
+ */
+static struct cfq_queue *
+split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
+{
+	if (cfqq_process_refs(cfqq) == 1) {
+		cfqq->seeky_start = 0;
+		cfqq->pid = current->pid;
+		cfq_clear_cfqq_coop(cfqq);
+		return cfqq;
+	}
+
+	cic_set_cfqq(cic, NULL, 1);
+	cfq_put_queue(cfqq);
+	return NULL;
+}
 /*
  * Allocate cfq data structures associated with this request.
  */
@@ -2432,12 +2494,23 @@ cfq_set_request(struct request_queue *q,
 	if (!cic)
 		goto queue_fail;
 
+new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
 		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
+		 * If the queue was seeky for too long, break it apart.
+		 */
+		if (cfq_cfqq_coop(cfqq) && should_split_cfqq(cfqq)) {
+			cfq_log_cfqq(cfqd, cfqq, "breaking apart cfqq");
+			cfqq = split_cfqq(cic, cfqq);
+			if (!cfqq)
+				goto new_queue;
+		}
+
+		/*
 		 * Check to see if this queue is scheduled to merge with
 		 * another, closely cooperating queue.  The merging of
 		 * queues happens here as it must be done in process context.



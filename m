Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1KCCC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:02:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933956Ab1KCBiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221457.913137227@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: [085/107] cfq: calculate the seek_mean per cfq_queue not per cfq_io_context
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Jeff Moyer <jmoyer@redhat.com>

commit b2c18e1e08a5a9663094d57bb4be2f02226ee61c upstream.

async cfq_queue's are already shared between processes within the same
priority, and forthcoming patches will change the mapping of cic to sync
cfq_queue from 1:1 to 1:N.  So, calculate the seekiness of a process
based on the cfq_queue instead of the cfq_io_context.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c       |   68 ++++++++++++++++++++++------------------------
 include/linux/iocontext.h |    5 ---
 2 files changed, 33 insertions(+), 40 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -112,6 +112,11 @@ struct cfq_queue {
 	unsigned short ioprio, org_ioprio;
 	unsigned short ioprio_class, org_ioprio_class;
 
+	unsigned int seek_samples;
+	u64 seek_total;
+	sector_t seek_mean;
+	sector_t last_request_pos;
+
 	pid_t pid;
 };
 
@@ -967,16 +972,16 @@ static inline sector_t cfq_dist_from_las
 		return cfqd->last_position - blk_rq_pos(rq);
 }
 
-#define CIC_SEEK_THR	8 * 1024
-#define CIC_SEEKY(cic)	((cic)->seek_mean > CIC_SEEK_THR)
+#define CFQQ_SEEK_THR		8 * 1024
+#define CFQQ_SEEKY(cfqq)	((cfqq)->seek_mean > CFQQ_SEEK_THR)
 
-static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
+static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+			       struct request *rq)
 {
-	struct cfq_io_context *cic = cfqd->active_cic;
-	sector_t sdist = cic->seek_mean;
+	sector_t sdist = cfqq->seek_mean;
 
-	if (!sample_valid(cic->seek_samples))
-		sdist = CIC_SEEK_THR;
+	if (!sample_valid(cfqq->seek_samples))
+		sdist = CFQQ_SEEK_THR;
 
 	return cfq_dist_from_last(cfqd, rq) <= sdist;
 }
@@ -1005,7 +1010,7 @@ static struct cfq_queue *cfqq_close(stru
 	 * will contain the closest sector.
 	 */
 	__cfqq = rb_entry(parent, struct cfq_queue, p_node);
-	if (cfq_rq_close(cfqd, __cfqq->next_rq))
+	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
 		return __cfqq;
 
 	if (blk_rq_pos(__cfqq->next_rq) < sector)
@@ -1016,7 +1021,7 @@ static struct cfq_queue *cfqq_close(stru
 		return NULL;
 
 	__cfqq = rb_entry(node, struct cfq_queue, p_node);
-	if (cfq_rq_close(cfqd, __cfqq->next_rq))
+	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
 		return __cfqq;
 
 	return NULL;
@@ -1039,13 +1044,6 @@ static struct cfq_queue *cfq_close_coope
 	struct cfq_queue *cfqq;
 
 	/*
-	 * A valid cfq_io_context is necessary to compare requests against
-	 * the seek_mean of the current cfqq.
-	 */
-	if (!cfqd->active_cic)
-		return NULL;
-
-	/*
 	 * We should notice if some of the queues are cooperating, eg
 	 * working closely on the same area of the disk. In that case,
 	 * we can group them together and don't waste time idling.
@@ -1115,7 +1113,7 @@ static void cfq_arm_slice_timer(struct c
 	 * seeks. so allow a little bit of time for him to submit a new rq
 	 */
 	sl = cfqd->cfq_slice_idle;
-	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
+	if (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq))
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
@@ -1958,33 +1956,33 @@ cfq_update_io_thinktime(struct cfq_data
 }
 
 static void
-cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_io_context *cic,
+cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		       struct request *rq)
 {
 	sector_t sdist;
 	u64 total;
 
-	if (!cic->last_request_pos)
+	if (!cfqq->last_request_pos)
 		sdist = 0;
-	else if (cic->last_request_pos < blk_rq_pos(rq))
-		sdist = blk_rq_pos(rq) - cic->last_request_pos;
+	else if (cfqq->last_request_pos < blk_rq_pos(rq))
+		sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
 	else
-		sdist = cic->last_request_pos - blk_rq_pos(rq);
+		sdist = cfqq->last_request_pos - blk_rq_pos(rq);
 
 	/*
 	 * Don't allow the seek distance to get too large from the
 	 * odd fragment, pagein, etc
 	 */
-	if (cic->seek_samples <= 60) /* second&third seek */
-		sdist = min(sdist, (cic->seek_mean * 4) + 2*1024*1024);
+	if (cfqq->seek_samples <= 60) /* second&third seek */
+		sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*1024);
 	else
-		sdist = min(sdist, (cic->seek_mean * 4)	+ 2*1024*64);
+		sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*64);
 
-	cic->seek_samples = (7*cic->seek_samples + 256) / 8;
-	cic->seek_total = (7*cic->seek_total + (u64)256*sdist) / 8;
-	total = cic->seek_total + (cic->seek_samples/2);
-	do_div(total, cic->seek_samples);
-	cic->seek_mean = (sector_t)total;
+	cfqq->seek_samples = (7*cfqq->seek_samples + 256) / 8;
+	cfqq->seek_total = (7*cfqq->seek_total + (u64)256*sdist) / 8;
+	total = cfqq->seek_total + (cfqq->seek_samples/2);
+	do_div(total, cfqq->seek_samples);
+	cfqq->seek_mean = (sector_t)total;
 }
 
 /*
@@ -2006,11 +2004,11 @@ cfq_update_idle_window(struct cfq_data *
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfqd->cfq_latency && cfqd->hw_tag && CIC_SEEKY(cic)))
+	    (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		unsigned int slice_idle = cfqd->cfq_slice_idle;
-		if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
+		if (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq))
 			slice_idle = msecs_to_jiffies(CFQ_MIN_TT);
 		if (cic->ttime_mean > slice_idle)
 			enable_idle = 0;
@@ -2077,7 +2075,7 @@ cfq_should_preempt(struct cfq_data *cfqd
 	 * if this request is as-good as one we would expect from the
 	 * current cfqq, let it preempt
 	 */
-	if (cfq_rq_close(cfqd, rq) && (!cfq_cfqq_coop(new_cfqq) ||
+	if (cfq_rq_close(cfqd, cfqq, rq) && (!cfq_cfqq_coop(new_cfqq) ||
 	    cfqd->busy_queues == 1)) {
 		/*
 		 * Mark new queue coop_preempt, so its coop flag will not be
@@ -2127,10 +2125,10 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 		cfqq->meta_pending++;
 
 	cfq_update_io_thinktime(cfqd, cic);
-	cfq_update_io_seektime(cfqd, cic, rq);
+	cfq_update_io_seektime(cfqd, cfqq, rq);
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
-	cic->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
+	cfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
 
 	if (cfqq == cfqd->active_queue) {
 		/*
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -40,16 +40,11 @@ struct cfq_io_context {
 	struct io_context *ioc;
 
 	unsigned long last_end_request;
-	sector_t last_request_pos;
 
 	unsigned long ttime_total;
 	unsigned long ttime_samples;
 	unsigned long ttime_mean;
 
-	unsigned int seek_samples;
-	u64 seek_total;
-	sector_t seek_mean;
-
 	struct list_head queue_list;
 	struct hlist_node cic_list;
 



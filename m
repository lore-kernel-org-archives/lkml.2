Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1IPDFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 23:05:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:30530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab1IPDFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 23:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48975220"
Subject: [patch]cfq-iosched: delete deep seeky queue idle logic
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 11:09:37 +0800
Message-ID: <1316142577.29510.130.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently Maxim and I discussed why his aiostress workload performs poorly. If
you didn't follow the discussion, here are the issues we found:
1. cfq seeky dection isn't good. Assume a task accesses sector A, B, C, D, A+1,
B+1, C+1, D+1, A+2...Accessing A, B, C, D is random. cfq will detect the queue
as seeky, but since when accessing A+1, A+1 is already in disk cache, this
should be detected as sequential really. Not sure if any real workload has such
access patern, and seems not easy to have a clean fix too. Any idea for this?

2. deep seeky queue idle. This makes raid performs poorly. I would think we
revert the logic. Deep queue is more popular with high end hardware. In such
hardware, we'd better not do idle.
Note, currently we set a queue's slice after the first request is finished.
This means the drive already idles a little time. If the queue is truely deep,
new requests should already come in, so idle isn't required.
Looks Vivek used to post a patch to rever it, but it gets ignored.
http://us.generation-nt.com/patch-cfq-iosched-revert-logic-deep-queues-help-198339681.html

Signed-off-by: Shaohua Li<shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a33bd43..f75439e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -334,7 +334,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
-	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
 };
 
@@ -363,7 +362,6 @@ CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
-CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
@@ -2375,17 +2373,6 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto keep_queue;
 	}
 
-	/*
-	 * This is a deep seek queue, but the device is much faster than
-	 * the queue can deliver, don't idle
-	 **/
-	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
-	    (cfq_cfqq_slice_new(cfqq) ||
-	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
-		cfq_clear_cfqq_deep(cfqq);
-		cfq_clear_cfqq_idle_window(cfqq);
-	}
-
 	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
 		cfqq = NULL;
 		goto keep_queue;
@@ -3298,13 +3285,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
-		cfq_mark_cfqq_deep(cfqq);
-
 	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
 		enable_idle = 0;
 	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
+	    CFQQ_SEEKY(cfqq))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime.ttime_samples)) {
 		if (cic->ttime.ttime_mean > cfqd->cfq_slice_idle)
@@ -3874,11 +3858,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 		 */
 		if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 			goto out_kick;
-
-		/*
-		 * Queue depth flag is reset only when the idle didn't succeed
-		 */
-		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
 	cfq_slice_expired(cfqd, timed_out);



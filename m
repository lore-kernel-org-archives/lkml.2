Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0CYAUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:20:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0CYAUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:20:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=u7V3kuxTYyruFiDC9kRYIbV9NumWc9yVD7ArjRCCAwV+VjR9t+yPWeE/6xamgSbMq
	KH6nnPzmd2h+BVxYPeEiw==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] cfq-iosched: Add additional blktrace log messages in CFQ for
	easier debugging.
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, vgoyal@redhat.com,
       ctalbott@google.com
Date: Wed, 24 Mar 2010 17:19:34 -0700
Message-ID: <20100325001856.18289.83328.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These extra logging messages have helped us debug some issues we've noticed in
earlier IO controller versions and should be useful now as well. The extra
logging covers:
- idling behavior. Since there are so many conditions based on which we decide
to idle or not, this patch adds a log message for some conditions that we've
found useful.
- workload slices and current prio and workload type

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 block/cfq-iosched.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e6910dc..556124a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1646,6 +1646,10 @@ static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 	if (!cfqq)
 		cfqq = cfq_get_next_queue(cfqd);
 
+	if (cfqq)
+		cfq_log_cfqq(cfqd, cfqq, "New timeslice for wl_prio:%d "
+				"wl_type:%d", cfqd->serving_prio,
+				cfqd->serving_type);
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -1789,7 +1793,11 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	return service_tree->count == 1 && cfq_cfqq_sync(cfqq);
+	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
+		return 1;
+	cfq_log_cfqq(cfqd, cfqq, "Not idling. queue_count:%d",
+			service_tree->count);
+	return 0;
 }
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
@@ -1834,8 +1842,11 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * time slice.
 	 */
 	if (sample_valid(cic->ttime_samples) &&
-	    (cfqq->slice_end - jiffies < cic->ttime_mean))
+	    (cfqq->slice_end - jiffies < cic->ttime_mean)) {
+		cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%d",
+				cic->ttime_mean);
 		return;
+	}
 
 	cfq_mark_cfqq_wait_request(cfqq);
 
@@ -2043,6 +2054,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
+	cfq_log(cfqd, "workload slice:%d", slice);
 	cfqd->workload_expires = jiffies + slice;
 	cfqd->noidle_tree_requires_idle = false;
 }
@@ -3309,6 +3321,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		if (cfq_should_wait_busy(cfqd, cfqq)) {
 			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
 			cfq_mark_cfqq_wait_busy(cfqq);
+			cfq_log_cfqq(cfqd, cfqq, "will busy wait");
 		}
 
 		/*


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0CYBi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:38:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0CYBi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:38:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=oXpo0lw84kJAx6u/LPcIpVuSIK6G6XC8ZhCNMgoYEMgLt6Ia48Hv9fj5qEG7MV/i2
	DiGFyCcd5k9fjMznMOkCg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH][v2] cfq-iosched: Add additional blktrace log messages in CFQ
	for easier debugging.
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, vgoyal@redhat.com,
       ctalbott@google.com
Date: Wed, 24 Mar 2010 18:38:35 -0700
Message-ID: <20100325013655.6103.13377.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have helped us debug some issues we've noticed in earlier IO
controller versions and should be useful now as well. The extra logging
covers:
- idling behavior. Since there are so many conditions based on which we decide
to idle or not, this patch adds a log message for some conditions that we've
found useful.
- workload slices and current prio and workload type

Changelog from v1:
o moved log message from cfq_set_active_queue() to __cfq_set_active_queue()
o changed queue_count to st->count

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 block/cfq-iosched.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e6910dc..a946b73 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1517,7 +1517,8 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 				   struct cfq_queue *cfqq)
 {
 	if (cfqq) {
-		cfq_log_cfqq(cfqd, cfqq, "set_active");
+		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
+				cfqd->serving_prio, cfqd->serving_type);
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
 		cfqq->allocated_slice = 0;
@@ -1789,7 +1790,11 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	return service_tree->count == 1 && cfq_cfqq_sync(cfqq);
+	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
+		return 1;
+	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
+			service_tree->count);
+	return 0;
 }
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
@@ -1834,8 +1839,11 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
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
 
@@ -2043,6 +2051,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
+	cfq_log(cfqd, "workload slice:%d", slice);
 	cfqd->workload_expires = jiffies + slice;
 	cfqd->noidle_tree_requires_idle = false;
 }
@@ -3309,6 +3318,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		if (cfq_should_wait_busy(cfqd, cfqq)) {
 			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
 			cfq_mark_cfqq_wait_busy(cfqq);
+			cfq_log_cfqq(cfqd, cfqq, "will busy wait");
 		}
 
 		/*


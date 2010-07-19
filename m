Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721Ab0GSROi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab0GSROg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:14:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [PATCH 1/3] cfq-iosched: Improve time slice charging logic
Date: Mon, 19 Jul 2010 13:14:10 -0400
Message-Id: <1279559652-2775-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1279559652-2775-1-git-send-email-vgoyal@redhat.com>
References: <1279559652-2775-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Currently in CFQ there are many situations where don't know how
  much time slice has been consumed by a queue. For example, all
  the random reader/writer queues where we don't idle on
  individual queues and we expire the queue either immediately
  after the request dispatch.

- In this case time consumed by a queue is just a memory copy
  operation. Actually time measurement is possible only if we
  idle on a queue and allow dispatch from a queue for significant
  amount of time.

- As of today, in such cases we calculate the time since the
  dispatch from the queue started and charge all that time.
  Generally this rounds to 1 jiffy but in some cases it can
  be more. For example, if we are driving high request queue
  depth and driver is too busy and does not ask for new
  requests for 8-10 jiffies. In such cases, the active queue
  gets charged very unfairly.

- So fundamentally, whole notion of charging for time slice
  is valid only if we have been idling on the queue. Otherwise
  in an NCQ queue, there might be other requests on the queue
  and we can not do the time slice calculation.

- This patch tweaks the slice charging logic a bit so that
  in the cases where we can't know the amount of time, we
  start charging in terms of number of requests dispatched
  (IOPS). This practically switching CFQ fairness model to
  fairness in terms of IOPS with slice_idle=0.

- As of today this will primarily be useful only with
  group_idle patches so that we get fairness in terms of
  IOPS across groups. The idea is that on fast storage
  one can run CFQ with slice_idle=0 and still get IO
  controller working without losing too much of
  throughput.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7982b83..f44064c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -896,16 +896,34 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 		 * if there are mutiple queues in the group, each can dispatch
 		 * a single request on seeky media and cause lots of seek time
 		 * and group will never know it.
+		 *
+		 * If drive is NCQ and we are driving deep queue depths, then
+		 * it is not reasonable to charge the slice since dispatch
+		 * started because this time will include time taken by all
+		 * the other requests in the queue.
+		 *
+		 * Actually there is no reasonable way to know the disk time
+		 * here and we need to come up with some approximation. If
+		 * disk is non NCQ, we should be driving request queue depth
+		 * 1, then charge for time since dispatch start and this will
+		 * account for seek time properly on seeky media. If request
+		 * queue depth is high, then charge for number of requests
+		 * dispatched from the queue. This will sort of becoming
+		 * charging in terms of IOPS.
 		 */
-		slice_used = max_t(unsigned, (jiffies - cfqq->dispatch_start),
-					1);
+		if (cfqq->cfqd->hw_tag == 0)
+			slice_used = max_t(unsigned,
+					(jiffies - cfqq->dispatch_start), 1);
+		else
+			slice_used = cfqq->slice_dispatch;
 	} else {
 		slice_used = jiffies - cfqq->slice_start;
 		if (slice_used > cfqq->allocated_slice)
 			slice_used = cfqq->allocated_slice;
 	}
 
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u", slice_used);
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u, sl_disp=%u", slice_used,
+			cfqq->slice_dispatch);
 	return slice_used;
 }
 
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1FTOQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab1FTOQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:16:36 -0400
Date: Mon, 20 Jun 2011 10:16:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: Tao Ma <tm@tao.ma>
Subject: [PATCH] cfq: Fix starvation of async writes in presence of heavy
 sync workload
Message-ID: <20110620141631.GA4749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In presence of heavy sync workload CFQ can starve asnc writes.
If one launches multiple readers (say 16), then one can notice
that CFQ can withhold dispatch of WRITEs for a very long time say
200 or 300 seconds.

Basically CFQ schedules an async queue but does not dispatch any
writes because it is waiting for exisintng sync requests in queue to
finish. While it is waiting, one or other reader gets queued up and
preempts the async queue. So we did schedule the async queue but never
dispatched anything from it. This can repeat for long time hence
practically starving Writers.

This patch allows async queue to dispatch atleast 1 requeust once
it gets scheduled and denies preemption if async queue has been
waiting for sync requests to drain and has not been able to dispatch
a request yet.

One concern with this fix is that how does it impact readers
in presence of heavy writting going on.

I did a test where I launch firefox, load a website and close
firefox and measure the time. I ran the test 3 times and took
average.

- Vanilla kernel time ~= 1 minute 40 seconds
- Patched kenrel time ~= 1 minute 35 seconds

Basically it looks like that for this test times have not
changed much for this test. But I would not claim that it does
not impact reader's latencies at all. It might show up in
other workloads.

I think we anyway need to fix writer starvation. If this patch
causes issues, then we need to look at reducing writer's
queue depth further to improve latencies for readers.

Reported-and-Tested-by: Tao Ma <tm@tao.ma>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-06-10 10:05:34.660781278 -0400
+++ linux-2.6/block/cfq-iosched.c	2011-06-20 08:29:13.328186380 -0400
@@ -3315,8 +3315,15 @@ cfq_should_preempt(struct cfq_data *cfqd
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
 	 */
-	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
+	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq)) {
+		/*
+		 * Allow atleast one dispatch otherwise this can repeat
+		 * and writes can be starved completely
+		 */
+		if (!cfqq->slice_dispatch)
+			return false;
 		return true;
+	}
 
 	if (new_cfqq->cfqg != cfqq->cfqg)
 		return false;



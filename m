Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0FUTuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:50:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab0FUTuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:50:04 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/2] cfq: allow dispatching of both sync and async I/O together
Date: Mon, 21 Jun 2010 15:49:49 -0400
Message-Id: <1277149789-4493-3-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In testing a workload that has a single fsync-ing process and another
process that does a sequential buffered read, I was unable to tune CFQ
to reach the throughput of deadline.  This patch, along with the previous
one, brought CFQ in line with deadline when setting slice_idle to 0.

I'm not sure what the original reason for not allowing sync and async
I/O to be dispatched together was.  If there is a workload I should be
testing that shows the inherent problems of this, please point me at it
and I will resume testing.  Until and unless that workload is identified,
please consider applying this patch.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 572a050..dab836e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2296,18 +2296,6 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned int max_dispatch;
 
-	/*
-	 * Drain async requests before we start sync IO
-	 */
-	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_flight[BLK_RW_ASYNC])
-		return false;
-
-	/*
-	 * If this is an async queue and we have sync IO in flight, let it wait
-	 */
-	if (cfqd->rq_in_flight[BLK_RW_SYNC] && !cfq_cfqq_sync(cfqq))
-		return false;
-
 	max_dispatch = max_t(unsigned int, cfqd->cfq_quantum / 2, 1);
 	if (cfq_class_idle(cfqq))
 		max_dispatch = 1;
-- 
1.6.5.2


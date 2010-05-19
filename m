Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0ESUdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0ESUdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:33:39 -0400
Date: Wed, 19 May 2010 16:33:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: Revert the logic of deep queues
Message-ID: <20100519203336.GB3394@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This patch basically reverts following commit.

        76280af cfq-iosched: idling on deep seeky sync queues

o Idling in CFQ is bad on high end storage. This is especially more true of
  random reads. Idling works very well for SATA disks with single
  spindle but harms a lot on powerful storage boxes.

  So even if deep queues can be little unfair to other random workload with
  shallow depths, treat deep queues as sync-noidle workload and not sync,
  because with sync workload we dispatch IO from only one queue at a time
  and idle and we don't drive enough queue depth to keep the array busy.

o I am running aio-stress (random reads) as follows.

  aio-stress -s 2g -O -t 4 -r 64k aio5 aio6 aio7 aio8 -o 3

  Following are results with various combinations.

  deadline:		232.94 MB/s

  without patch
  -------------
  cfq default		75.32 MB/s
  cfq, quantum=64	134.58 MB/s

  with patch
  ----------
  cfq default		78.37 MB/s
  cfq, quantum=64	213.94 MB

  Note that with the patch applied, cfq really scales well if "quantum" is
  increased and comes close to deadline performance.

o Point being that on powerful arrays one queue is not sufficient to keep
  array busy. This is already a bottleneck for sequential workloads. Lets
  not aggravate the problem by marking random read queues as sync and
  giving them exclusive access and hence effectively serializing the
  access to array.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5f127cf..3336bd7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -313,7 +313,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
-	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
 };
 
@@ -342,7 +341,6 @@ CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
-CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
@@ -3036,11 +3034,8 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
-		cfq_mark_cfqq_deep(cfqq);
-
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
+	    CFQQ_SEEKY(cfqq))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
@@ -3593,11 +3588,6 @@ static void cfq_idle_slice_timer(unsigned long data)
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
-- 
1.6.5.2


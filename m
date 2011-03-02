Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab1CBMnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:43:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:5809 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab1CBMno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:43:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="892963401"
Date: Wed, 2 Mar 2011 20:43:41 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com, jmoyer@redhat.com,
        czoccolo@gmail.com, guijianfeng@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: cfq-iosched preempt issues
Message-ID: <20110302124341.GA23940@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue preemption is good for some workloads and not for others. With commit
f8ae6e3eb825, the impact is amplified. I currently have two issues with it:
1. In a multi-threaded workload, each thread runs a random read/write (for
example, mmap write) with iodepth 1. I found the queue depth gets smaller
with commit f8ae6e3eb825. The reason is write gets preempted, so more threads
are waitting for write, and on the other hand, there are less threads doing
read. This will make the queue depth small, so performance drops a little.
So in this case, speed up write can speed up read too, but we can't detect
it.
2. cfq_may_dispatch doesn't limit queue depth if the queue is the sole queue.
What about if there are two queues, one sync and one async? If the sync queue's
think time is small, we can treat it as the sole queue, because the sync queue
will preempt async queue, so we don't need care about the async queue's latency.
The issue exists before, but f8ae6e3eb825 amplifies it. Below is a patch for it.

Any idea?

Thanks,
Shaohua
-----------------------------------------------
Subject: cfq-iosched: don't limlit sync queue depth with only one such sync queue

If there are a sync and an async queue and the sync queue's think time is small,
we can ignore the sync queue's dispatch quantum. Because the sync queue will
always preempt the async queue, we don't need to care about async's latency.
In the same way, we can optimize a RT queue too to improve performance.
This can fix a performance regression of aiostress test, which is introduced by
commit f8ae6e3eb825. The issue should exist even without the commit, but the
commit amplifies the impact.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   91 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 18 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-03-02 14:58:19.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-03-02 15:48:38.000000000 +0800
@@ -1150,6 +1150,20 @@ void cfq_unlink_blkio_group(void *key, s
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
+static bool cfq_have_cfqgs(struct cfq_data *cfqd)
+{
+	struct hlist_node *pos;
+	struct cfq_group *cfqg;
+	int cnt = 0;
+
+	hlist_for_each_entry(cfqg, pos, &cfqd->cfqg_list, cfqd_node) {
+		cnt++;
+		if (cnt > 1)
+			break;
+	}
+	return cnt > 1;
+}
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
@@ -1169,6 +1183,12 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfq
 static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
 static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 
+static inline bool cfq_have_cfqgs(struct cfq_data *cfqd)
+{
+	return false;
+}
+
+
 #endif /* GROUP_IOSCHED */
 
 /*
@@ -2381,6 +2401,57 @@ static inline bool cfq_slice_used_soon(s
 	return false;
 }
 
+static unsigned int cfq_queue_max_quantum(struct cfq_data *cfqd,
+	struct cfq_queue *cfqq)
+{
+	int sync = cfq_cfqq_sync(cfqq);
+	enum wl_prio_t prio = cfqq_prio(cfqq);
+	struct cfq_group *cfqg = cfqq->cfqg;
+	int sync_queues_cnt, async_queues_cnt;
+	struct cfq_io_context *cic = RQ_CIC(cfqq->next_rq);
+
+	/* Sole queue user, no limit */
+	if (cfqd->busy_queues == 1)
+		return -1;
+
+	if (cfq_have_cfqgs(cfqd) || (!sync && prio != RT_WORKLOAD))
+		goto normal;
+
+	sync_queues_cnt = cfqg->service_trees[prio][SYNC_NOIDLE_WORKLOAD].count
+		+ cfqg->service_trees[prio][SYNC_WORKLOAD].count;
+	async_queues_cnt = cfqg->service_trees[prio][ASYNC_WORKLOAD].count;
+	/*
+	 * If a queue is a sole sync queue and think time is small, we can ignore
+	 * async queue here and give the sync queue no dispatch limit, because a
+	 * sync queue can preempt async queue.
+	 *
+	 * If the queue is RT, we don't need check BE, because even the
+	 * queue is expired, the dispatcher will select RT queue again next time.
+	 *
+	 * If the queue is BE, we don't check RT here, because dispatcher will
+	 * switch to RT next time, so we at most dispatch one extra request.
+	 */
+	if (((!sync && prio == RT_WORKLOAD && sync_queues_cnt == 0 &&
+		async_queues_cnt == 1) || sync_queues_cnt == 1) &&
+		sample_valid(cic->ttime_samples) &&
+		cic->ttime_mean < cfqd->cfq_slice_idle)
+		return -1;
+normal:
+	/*
+	 * We have other queues, don't allow more IO from this one
+	 */
+	if (cfq_slice_used_soon(cfqd, cfqq))
+		return 0;
+	else
+		/*
+		 * Normally we start throttling cfqq when cfq_quantum/2
+		 * requests have been dispatched. But we can drive
+		 * deeper queue depths at the beginning of slice
+		 * subjected to upper limit of cfq_quantum.
+		 * */
+		return cfqd->cfq_quantum;
+}
+
 static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned int max_dispatch;
@@ -2411,25 +2482,9 @@ static bool cfq_may_dispatch(struct cfq_
 		if (cfq_class_idle(cfqq))
 			return false;
 
-		/*
-		 * We have other queues, don't allow more IO from this one
-		 */
-		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
+		max_dispatch = cfq_queue_max_quantum(cfqd, cfqq);
+		if (max_dispatch == 0)
 			return false;
-
-		/*
-		 * Sole queue user, no limit
-		 */
-		if (cfqd->busy_queues == 1)
-			max_dispatch = -1;
-		else
-			/*
-			 * Normally we start throttling cfqq when cfq_quantum/2
-			 * requests have been dispatched. But we can drive
-			 * deeper queue depths at the beginning of slice
-			 * subjected to upper limit of cfq_quantum.
-			 * */
-			max_dispatch = cfqd->cfq_quantum;
 	}
 
 	/*

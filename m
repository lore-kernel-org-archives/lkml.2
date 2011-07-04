Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1GDFgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:36:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:61668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1GDFgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:36:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="21242872"
Subject: [PATCH 3/3]Subject: CFQ: add think time check for group
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 13:36:36 +0800
Message-ID: <1309757796.15392.239.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: CFQ: add think time check for group

Currently when the last queue of a group has no request, we don't expire
the queue to hope request from the group comes soon, so the group doesn't
miss its share. But if the think time is big, the assumption isn't correct
and we just waste bandwidth. In such case, we don't do idle.

[global]
runtime=30
direct=1

[test1]
cgroup=test1
cgroup_weight=1000
rw=randread
ioengine=libaio
size=500m
runtime=30
directory=/mnt
filename=file1
thinktime=9000

[test2]
cgroup=test2
cgroup_weight=1000
rw=randread
ioengine=libaio
size=500m
runtime=30
directory=/mnt
filename=file2

	patched		base
test1	64k		39k
test2	540k		540k
total	604k		578k

group1 gets much better throughput because it waits less time.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-07-01 13:45:24.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-07-01 13:48:18.000000000 +0800
@@ -215,6 +215,7 @@ struct cfq_group {
 #endif
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
+	struct cfq_ttime ttime;
 };
 
 /*
@@ -1062,6 +1063,8 @@ static struct cfq_group * cfq_alloc_cfqg
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
+	cfqg->ttime.last_end_request = jiffies;
+
 	/*
 	 * Take the initial reference that will be released on destroy
 	 * This can be thought of a joint reference by cgroup and
@@ -2385,8 +2388,9 @@ static struct cfq_queue *cfq_select_queu
 	 * this group, wait for requests to complete.
 	 */
 check_group_idle:
-	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
-	    && cfqq->cfqg->dispatched) {
+	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1 &&
+	    cfqq->cfqg->dispatched && !cfq_io_thinktime_big(cfqq->cfqg->ttime,
+	    cfqd->cfq_group_idle)) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
@@ -3245,6 +3249,9 @@ cfq_update_io_thinktime(struct cfq_data
 		__cfq_update_io_thinktime(&service_tree->ttime,
 			cfqd->cfq_slice_idle);
 	}
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	__cfq_update_io_thinktime(&cfqg->ttime, cfqd->cfq_group_idle);
+#endif
 }
 
 static void
@@ -3536,7 +3543,9 @@ static bool cfq_should_wait_busy(struct
 	if (cfqq->cfqg->nr_cfqq > 1)
 		return false;
 
-	if (cfq_slice_used(cfqq))
+	/* we are the only queue in the group */
+	if (cfq_slice_used(cfqq) &&
+	    !cfq_io_thinktime_big(cfqq->cfqg->ttime, cfqd->cfq_group_idle))
 		return true;
 
 	/* if slice left is less than think time, wait busy */
@@ -3593,6 +3602,10 @@ static void cfq_completed_request(struct
 			cfqd->last_delayed_sync = now;
 	}
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	cfqq->cfqg->ttime.last_end_request = now;
+#endif
+
 	/*
 	 * If this is the active queue, check if it needs to be expired,
 	 * or if we want to idle in case it has no pending requests.



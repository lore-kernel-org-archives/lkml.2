Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab1GLBiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:38:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:42021 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541Ab1GLBiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,517,1304319600"; 
   d="scan'208";a="25979616"
Subject: [PATCH 3/3]CFQ: add think time check for group
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 09:38:01 +0800
Message-ID: <1310434681.15392.286.camel@sli10-conroe>
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
test2	548k		540k
total	604k		578k

group1 gets much better throughput because it waits less time.

To check if the patch changes behavior of queue without think time. I also
tried to give test1 2ms think time or no think time. The test result is stable.
The thoughput doesn't change with/without the patch.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-07-12 09:19:13.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-07-12 09:26:32.000000000 +0800
@@ -213,6 +213,7 @@ struct cfq_group {
 #endif
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
+	struct cfq_ttime ttime;
 };
 
 /*
@@ -1072,6 +1073,8 @@ static struct cfq_group * cfq_alloc_cfqg
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
+	cfqg->ttime.last_end_request = jiffies;
+
 	/*
 	 * Take the initial reference that will be released on destroy
 	 * This can be thought of a joint reference by cgroup and
@@ -2395,8 +2398,9 @@ static struct cfq_queue *cfq_select_queu
 	 * this group, wait for requests to complete.
 	 */
 check_group_idle:
-	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
-	    && cfqq->cfqg->dispatched) {
+	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1 &&
+	    cfqq->cfqg->dispatched &&
+	    !cfq_io_thinktime_big(cfqd, &cfqq->cfqg->ttime, true)) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
@@ -3254,6 +3258,9 @@ cfq_update_io_thinktime(struct cfq_data
 		__cfq_update_io_thinktime(&cfqq->service_tree->ttime,
 			cfqd->cfq_slice_idle);
 	}
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	__cfq_update_io_thinktime(&cfqq->cfqg->ttime, cfqd->cfq_group_idle);
+#endif
 }
 
 static void
@@ -3545,6 +3552,10 @@ static bool cfq_should_wait_busy(struct
 	if (cfqq->cfqg->nr_cfqq > 1)
 		return false;
 
+	/* the only queue in the group, but think time is big */
+	if (cfq_io_thinktime_big(cfqd, &cfqq->cfqg->ttime, true))
+		return false;
+
 	if (cfq_slice_used(cfqq))
 		return true;
 
@@ -3605,6 +3616,10 @@ static void cfq_completed_request(struct
 			cfqd->last_delayed_sync = now;
 	}
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	cfqq->cfqg->ttime.last_end_request = now;
+#endif
+
 	/*
 	 * If this is the active queue, check if it needs to be expired,
 	 * or if we want to idle in case it has no pending requests.



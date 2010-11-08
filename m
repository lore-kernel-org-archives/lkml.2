Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0KHCH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:07:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:24182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0KHCHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,311,1286175600"; 
   d="scan'208";a="345726687"
Subject: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, vgoyal@redhat.com, czoccolo@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 10:07:18 +0800
Message-ID: <1289182038.23014.190.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A queue is idle at cfq_dispatch_requests(), but it gets noidle later. Unless
other task explictly does unplug or all requests are drained, we will not
deliever requests to the disk even cfq_arm_slice_timer doesn't make the
queue idle. For example, cfq_should_idle() returns true because of
service_tree->count == 1, and then other queues are added. Note, I didn't
see obvious performance impacts so far with the patch, but just thought
this could be a problem.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-11-08 08:41:20.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-11-08 08:43:51.000000000 +0800
@@ -3265,6 +3265,10 @@ cfq_should_preempt(struct cfq_data *cfqd
 	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
 		return true;
 
+	/* An idle queue should not be idle now for some reason */
+	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq))
+		return true;
+
 	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
 		return false;
 
@@ -3508,8 +3512,25 @@ static void cfq_completed_request(struct
 		}
 	}
 
-	if (!cfqd->rq_in_driver)
+	if (!cfqd->rq_in_driver) {
 		cfq_schedule_dispatch(cfqd);
+		return;
+	}
+	/*
+	 * A queue is idle at cfq_dispatch_requests(), but it gets noidle
+	 * later. We schedule a dispatch if the queue has no requests,
+	 * otherwise the disk is actually in idle till all requests
+	 * are finished even cfq_arm_slice_timer doesn't make the queue idle
+	 * */
+	cfqq = cfqd->active_queue;
+	if (!cfqq)
+		return;
+
+	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq) &&
+	    (!cfqd->cfq_group_idle || cfqq->cfqg->nr_cfqq > 1)) {
+		cfq_del_timer(cfqd, cfqq);
+		cfq_schedule_dispatch(cfqd);
+	}
 }
 
 /*



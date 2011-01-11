Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1AKIwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:52:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:27197 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1AKIwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:52:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,306,1291622400"; 
   d="scan'208";a="645612212"
Subject: [PATCH 2/2]block cfq: compensate preempted queue even if it has no
 slice assigned
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 16:51:57 +0800
Message-ID: <1294735917.1949.638.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a queue is preempted before it gets slice assigned, the queue doesn't get
compensation, which looks unfair. For such queue, we compensate it for a whole
slice.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-01-10 15:37:33.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-01-10 15:54:28.000000000 +0800
@@ -605,8 +605,8 @@ cfq_group_slice(struct cfq_data *cfqd, s
 	return cfq_target_latency * cfqg->weight / st->total_weight;
 }
 
-static inline void
-cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+static inline unsigned
+cfq_scaled_group_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
 	if (cfqd->cfq_latency) {
@@ -632,6 +632,14 @@ cfq_set_prio_slice(struct cfq_data *cfqd
 				    low_slice);
 		}
 	}
+	return slice;
+}
+
+static inline void
+cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	unsigned slice = cfq_scaled_group_slice(cfqd, cfqq);
+
 	cfqq->slice_start = jiffies;
 	cfqq->slice_end = jiffies + slice;
 	cfqq->allocated_slice = slice;
@@ -1672,8 +1680,11 @@ __cfq_slice_expired(struct cfq_data *cfq
 	/*
 	 * store what was left of this slice, if the queue idled/timed out
 	 */
-	if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
-		cfqq->slice_resid = cfqq->slice_end - jiffies;
+	if (timed_out) {
+		if (cfq_cfqq_slice_new(cfqq))
+			cfqq->slice_resid = cfq_scaled_group_slice(cfqd, cfqq);
+		else
+			cfqq->slice_resid = cfqq->slice_end - jiffies;
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 



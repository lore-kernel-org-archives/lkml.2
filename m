Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1COC5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 22:57:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:53875 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1COC5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 22:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,320,1297065600"; 
   d="scan'208";a="667278765"
Subject: [PATCH]cfq-iosched: removing unnecessary think time checking
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 10:57:31 +0800
Message-ID: <1300157851.2337.78.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing think time checking. A high thinktime queue might means the queue
dispatches several requests and then do away. Limitting such queue seems
meaningless. And also this can simplify code. This is suggested by Vivek.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-03-10 13:52:13.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-03-10 13:53:08.000000000 +0800
@@ -2418,19 +2418,14 @@ static bool cfq_may_dispatch(struct cfq_
 			return false;
 
 		/*
-		 * If there is only one sync queue, and its think time is
-		 * small, we can ignore async queue here and give the sync
+		 * If there is only one sync queue
+		 * we can ignore async queue here and give the sync
 		 * queue no dispatch limit. The reason is a sync queue can
 		 * preempt async queue, limiting the sync queue doesn't make
 		 * sense. This is useful for aiostress test.
 		 */
-		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1) {
-			struct cfq_io_context *cic = RQ_CIC(cfqq->next_rq);
-
-			if (sample_valid(cic->ttime_samples) &&
-				cic->ttime_mean < cfqd->cfq_slice_idle)
-				promote_sync = true;
-		}
+		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1)
+			promote_sync = true;
 
 		/*
 		 * We have other queues, don't allow more IO from this one



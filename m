Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2ASCIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:08:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:52592 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab2ASCHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:07:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113814367"
Subject: [patch]block,cfq: change code order
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 10:08:38 +0800
Message-ID: <1326938918.22361.652.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: block,cfq: change code order

cfq_slice_expired will change saved_workload_slice. It should be called
first so saved_workload_slice is correctly set to 0 after workload type
is changed.
This fixes the code order changed by 54b466e44b1c7.

Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ee55019..da21c24 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3117,17 +3117,18 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
  */
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	enum wl_type_t old_type = cfqq_type(cfqd->active_queue);
+
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
+	cfq_slice_expired(cfqd, 1);
 
 	/*
 	 * workload type is changed, don't save slice, otherwise preempt
 	 * doesn't happen
 	 */
-	if (cfqq_type(cfqd->active_queue) != cfqq_type(cfqq))
+	if (old_type != cfqq_type(cfqq))
 		cfqq->cfqg->saved_workload_slice = 0;
 
-	cfq_slice_expired(cfqd, 1);
-
 	/*
 	 * Put the new queue at the front of the of the current list,
 	 * so we know that it will be selected next.



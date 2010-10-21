Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0JUSYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 14:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0JUSYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 14:24:05 -0400
Date: Thu, 21 Oct 2010 14:24:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: Fix a gcc 4.5 warning and put some comments
Message-ID: <20101021182403.GA8378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Andi encountedred following warning with gcc 4.5

  linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
  linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array
  bounds

- Warning happens due to following code.

  slice = group_slice * count /
		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
		cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));

  gcc is complaining about cfqg->busy_queues_avg[] being indexed by CFQ
  prio classes (RT, BE and IDLE) while the array size is only 2.

- At run time, we never access cfqg->busy_queues_avg[IDLE] and return from
  function before this code hits.

- To fix warning increase the array size though it will remain unused. This
  patch also puts some comments to clarify some of the confusions.

- I have taken Jens's patch and modified it a bit.

- Compile tested with gcc 4.4 and boot tested. I don't have gcc 4.5
  running, Andi can you please test it with gcc 4.5 to make sure it
  worked.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6-block/block/cfq-iosched.c
===================================================================
--- linux-2.6-block.orig/block/cfq-iosched.c	2010-10-21 13:27:33.000000000 -0400
+++ linux-2.6-block/block/cfq-iosched.c	2010-10-21 13:35:48.132946331 -0400
@@ -160,6 +160,7 @@ enum wl_prio_t {
 	BE_WORKLOAD = 0,
 	RT_WORKLOAD = 1,
 	IDLE_WORKLOAD = 2,
+	CFQ_PRIO_NR,
 };
 
 /*
@@ -184,10 +185,19 @@ struct cfq_group {
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
-	/* Per group busy queus average. Useful for workload slice calc. */
-	unsigned int busy_queues_avg[2];
 	/*
-	 * rr lists of queues with requests, onle rr for each priority class.
+	 * Per group busy queus average. Useful for workload slice calc. We
+	 * create the array for each prio class but at run time it is used
+	 * only for RT and BE class and slot for IDLE class remains unused.
+	 * This is primarily done to avoid confusion and a gcc warning.
+	 */
+	unsigned int busy_queues_avg[CFQ_PRIO_NR];
+	/*
+	 * rr lists of queues with requests. We maintain service trees for
+	 * RT and BE classes. These trees are subdivided in subclasses
+	 * of SYNC, SYNC_NOIDLE and ASYNC based on workload type. For IDLE
+	 * class there is no subclassification and all the cfq queues go on
+	 * a single tree service_tree_idle.
 	 * Counts are embedded in the cfq_rb_root
 	 */
 	struct cfq_rb_root service_trees[2][3];

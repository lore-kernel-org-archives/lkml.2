Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0LWCpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:45:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:41617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab0LWCpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:45:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="365612826"
Subject: [PATCH 1/2]block cfq: don't use atomic_t for cfq_queue
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, vgoyal@redhat.com, jmoyer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 10:45:33 +0800
Message-ID: <1293072333.10593.21.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_queue->ref is used with queue_lock hold, so ref doesn't need to be an atomic
and atomic operation is slower.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-12-22 21:14:15.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-12-23 10:44:23.000000000 +0800
@@ -97,7 +97,7 @@ struct cfq_rb_root {
  */
 struct cfq_queue {
 	/* reference count */
-	atomic_t ref;
+	int ref;
 	/* various state flags, see below */
 	unsigned int flags;
 	/* parent cfq_data */
@@ -2040,7 +2040,7 @@ static int cfqq_process_refs(struct cfq_
 	int process_refs, io_refs;
 
 	io_refs = cfqq->allocated[READ] + cfqq->allocated[WRITE];
-	process_refs = atomic_read(&cfqq->ref) - io_refs;
+	process_refs = cfqq->ref - io_refs;
 	BUG_ON(process_refs < 0);
 	return process_refs;
 }
@@ -2080,10 +2080,10 @@ static void cfq_setup_merge(struct cfq_q
 	 */
 	if (new_process_refs >= process_refs) {
 		cfqq->new_cfqq = new_cfqq;
-		atomic_add(process_refs, &new_cfqq->ref);
+		new_cfqq->ref += process_refs;
 	} else {
 		new_cfqq->new_cfqq = cfqq;
-		atomic_add(new_process_refs, &cfqq->ref);
+		cfqq->ref += new_process_refs;
 	}
 }
 
@@ -2538,9 +2538,10 @@ static void cfq_put_queue(struct cfq_que
 	struct cfq_data *cfqd = cfqq->cfqd;
 	struct cfq_group *cfqg, *orig_cfqg;
 
-	BUG_ON(atomic_read(&cfqq->ref) <= 0);
+	BUG_ON(cfqq->ref <= 0);
 
-	if (!atomic_dec_and_test(&cfqq->ref))
+	cfqq->ref--;
+	if (cfqq->ref)
 		return;
 
 	cfq_log_cfqq(cfqd, cfqq, "put_queue");
@@ -2843,7 +2844,7 @@ static void cfq_init_cfqq(struct cfq_dat
 	RB_CLEAR_NODE(&cfqq->p_node);
 	INIT_LIST_HEAD(&cfqq->fifo);
 
-	atomic_set(&cfqq->ref, 0);
+	cfqq->ref = 0;
 	cfqq->cfqd = cfqd;
 
 	cfq_mark_cfqq_prio_changed(cfqq);
@@ -2979,11 +2980,11 @@ cfq_get_queue(struct cfq_data *cfqd, boo
 	 * pin the queue now that it's allocated, scheduler exit will prune it
 	 */
 	if (!is_sync && !(*async_cfqq)) {
-		atomic_inc(&cfqq->ref);
+		cfqq->ref++;
 		*async_cfqq = cfqq;
 	}
 
-	atomic_inc(&cfqq->ref);
+	cfqq->ref++;
 	return cfqq;
 }
 
@@ -3681,7 +3682,7 @@ new_queue:
 	}
 
 	cfqq->allocated[rw]++;
-	atomic_inc(&cfqq->ref);
+	cfqq->ref++;
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
@@ -3862,6 +3863,10 @@ static void *cfq_init_queue(struct reque
 	if (!cfqd)
 		return NULL;
 
+	/*
+	 * Don't need take queue_lock in the routine, since we are
+	 * initializing the ioscheduler, and nobody is using cfqd
+	 */
 	cfqd->cic_index = i;
 
 	/* Init root service tree */
@@ -3901,7 +3906,7 @@ static void *cfq_init_queue(struct reque
 	 * will not attempt to free it.
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
-	atomic_inc(&cfqd->oom_cfqq.ref);
+	cfqd->oom_cfqq.ref++;
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
 	INIT_LIST_HEAD(&cfqd->cic_list);



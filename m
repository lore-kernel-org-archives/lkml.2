Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab1FAQVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:21:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab1FAQVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:21:41 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch] iosched: prevent aliased requests from starving other I/O
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 01 Jun 2011 12:21:31 -0400
Message-ID: <x49tyc9y12s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jens,

If you recall, I posted an RFC patch for this back in July of last year:
http://lkml.org/lkml/2010/7/13/279

The basic problem is that a process can issue a never-ending stream of
async direct I/Os to the same sector on a device, thus starving out
other I/O in the system (due to the way the alias handling works in both
cfq and deadline).  The solution I proposed back then was to start
dispatching from the fifo after a certain number of aliases had been
dispatched.  Vivek asked why we had to treat aliases differently at all,
and I never had a good answer.  So, I put together a simple patch which
allows aliases to be added to the rb tree (it adds them to the right,
though that doesn't matter as the order isn't guaranteed anyway).  I
think this is the preferred solution, as it doesn't break up time slices
in CFQ or batches in deadline.  I've tested it, and it does solve the
starvation issue.  Let me know what you think.

Cheers,
Jeff

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7c52d68..a2fb14b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1501,16 +1501,11 @@ static void cfq_add_rq_rb(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 	struct cfq_data *cfqd = cfqq->cfqd;
-	struct request *__alias, *prev;
+	struct request *prev;
 
 	cfqq->queued[rq_is_sync(rq)]++;
 
-	/*
-	 * looks a little odd, but the first insert might return an alias.
-	 * if that happens, put the alias on the dispatch list
-	 */
-	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL)
-		cfq_dispatch_insert(cfqd->queue, __alias);
+	elv_rb_add(&cfqq->sort_list, rq);
 
 	if (!cfq_cfqq_on_rr(cfqq))
 		cfq_add_cfqq_rr(cfqd, cfqq);
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 5139c0e..c644137 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -77,10 +77,8 @@ static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 {
 	struct rb_root *root = deadline_rb_root(dd, rq);
-	struct request *__alias;
 
-	while (unlikely(__alias = elv_rb_add(root, rq)))
-		deadline_move_request(dd, __alias);
+	elv_rb_add(root, rq);
 }
 
 static inline void
diff --git a/block/elevator.c b/block/elevator.c
index b0b38ce..a3b64bc 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -353,7 +353,7 @@ static struct request *elv_rqhash_find(struct request_queue *q, sector_t offset)
  * RB-tree support functions for inserting/lookup/removal of requests
  * in a sorted RB tree.
  */
-struct request *elv_rb_add(struct rb_root *root, struct request *rq)
+void elv_rb_add(struct rb_root *root, struct request *rq)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -365,15 +365,12 @@ struct request *elv_rb_add(struct rb_root *root, struct request *rq)
 
 		if (blk_rq_pos(rq) < blk_rq_pos(__rq))
 			p = &(*p)->rb_left;
-		else if (blk_rq_pos(rq) > blk_rq_pos(__rq))
+		else if (blk_rq_pos(rq) >= blk_rq_pos(__rq))
 			p = &(*p)->rb_right;
-		else
-			return __rq;
 	}
 
 	rb_link_node(&rq->rb_node, parent, p);
 	rb_insert_color(&rq->rb_node, root);
-	return NULL;
 }
 EXPORT_SYMBOL(elv_rb_add);
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 21a8ebf..d800d51 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -146,7 +146,7 @@ extern struct request *elv_rb_latter_request(struct request_queue *, struct requ
 /*
  * rb support functions.
  */
-extern struct request *elv_rb_add(struct rb_root *, struct request *);
+extern void elv_rb_add(struct rb_root *, struct request *);
 extern void elv_rb_del(struct rb_root *, struct request *);
 extern struct request *elv_rb_find(struct rb_root *, sector_t);
 

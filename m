Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2F0Nzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:55:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61148 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2F0Nzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:55:51 -0400
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 21:55:51 +0800
Message-ID: <CAJd=RBC=cZO8boOQMqJi=q9H2tZNOfsu_=VrkFt4_ExJCrLePQ@mail.gmail.com>
Subject: [RFC patch] block: add round robin dispatch in noop IO scheduler
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requests are grouped according to IO context, and dispatched in round
robin, one request per context a time, then noop serves flash based
disk "fair"?


--- a/block/noop-iosched.c	Wed Jun 27 20:52:52 2012
+++ b/block/noop-iosched.c	Wed Jun 27 21:24:10 2012
@@ -7,25 +7,76 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include "blk.h"

 struct noop_data {
 	struct list_head queue;
 };

+struct noop_ioc {
+	struct io_cq icq;
+
+	struct list_head rr, fifo;
+};
+
+static inline struct noop_ioc *ioc_of(struct io_cq *icq)
+{
+	return (struct noop_ioc *)icq;
+}
+static inline struct noop_ioc *ioc_of_rq(struct request *rq)
+{
+	return ioc_of(rq->elv.icq);
+}
+
 static void noop_merged_requests(struct request_queue *q, struct request *rq,
 				 struct request *next)
 {
 	list_del_init(&next->queuelist);
 }

+static int noop_dispatch_force(struct request_queue *q)
+{
+	struct noop_data *nd = q->elevator->elevator_data;
+	int cnt = 0;
+
+	while (!list_empty(&nd->queue)) {
+		struct noop_ioc *ioc;
+		ioc = list_first_entry(&nd->queue, struct noop_ioc, rr);
+		list_del_init(&ioc->rr);
+
+		while (!list_empty(&ioc->fifo)) {
+			struct request *rq;
+			rq = list_first_entry(&ioc->fifo, struct request,
+							queuelist);
+			list_del_init(&rq->queuelist);
+			elv_dispatch_sort(q, rq);
+			++cnt;
+		}
+	}
+	return cnt;
+}
+
 static int noop_dispatch(struct request_queue *q, int force)
 {
 	struct noop_data *nd = q->elevator->elevator_data;
+	struct noop_ioc *ioc;
+
+	if (force)
+		return noop_dispatch_force(q);
+
+	if (list_empty(&nd->queue))
+		return 0;
+
+	ioc = list_first_entry(&nd->queue, struct noop_ioc, rr);
+	list_del_init(&ioc->rr);

-	if (!list_empty(&nd->queue)) {
+	if (!list_empty(&ioc->fifo)) {
 		struct request *rq;
-		rq = list_entry(nd->queue.next, struct request, queuelist);
+		rq = list_entry(ioc->fifo.next, struct request, queuelist);
 		list_del_init(&rq->queuelist);
+		/* dispatch round robin */
+		if (!list_empty(&ioc->fifo))
+			list_add_tail(&ioc->rr, &nd->queue);
 		elv_dispatch_sort(q, rq);
 		return 1;
 	}
@@ -35,16 +86,18 @@ static int noop_dispatch(struct request_
 static void noop_add_request(struct request_queue *q, struct request *rq)
 {
 	struct noop_data *nd = q->elevator->elevator_data;
+	struct noop_ioc *ioc = ioc_of_rq(rq);

-	list_add_tail(&rq->queuelist, &nd->queue);
+	list_add_tail(&rq->queuelist, &ioc->fifo);
+
+	if (list_empty(&ioc->rr))
+		list_add_tail(&ioc->rr, &nd->queue);
 }

 static struct request *
 noop_former_request(struct request_queue *q, struct request *rq)
 {
-	struct noop_data *nd = q->elevator->elevator_data;
-
-	if (rq->queuelist.prev == &nd->queue)
+	if (rq->queuelist.prev == &ioc_of_rq(rq)->fifo)
 		return NULL;
 	return list_entry(rq->queuelist.prev, struct request, queuelist);
 }
@@ -52,9 +105,7 @@ noop_former_request(struct request_queue
 static struct request *
 noop_latter_request(struct request_queue *q, struct request *rq)
 {
-	struct noop_data *nd = q->elevator->elevator_data;
-
-	if (rq->queuelist.next == &nd->queue)
+	if (rq->queuelist.next == &ioc_of_rq(rq)->fifo)
 		return NULL;
 	return list_entry(rq->queuelist.next, struct request, queuelist);
 }
@@ -80,6 +131,14 @@ static void noop_exit_queue(struct eleva
 	kfree(nd);
 }

+static void noop_init_icq(struct io_cq *icq)
+{
+	struct noop_ioc *ioc = ioc_of(icq);
+
+	INIT_LIST_HEAD(&ioc->rr);
+	INIT_LIST_HEAD(&ioc->fifo);
+}
+
 static struct elevator_type elevator_noop = {
 	.ops = {
 		.elevator_merge_req_fn		= noop_merged_requests,
@@ -89,7 +148,10 @@ static struct elevator_type elevator_noo
 		.elevator_latter_req_fn		= noop_latter_request,
 		.elevator_init_fn		= noop_init_queue,
 		.elevator_exit_fn		= noop_exit_queue,
+		.elevator_init_icq_fn		= noop_init_icq,
 	},
+	.icq_size  = sizeof(struct noop_ioc),
+	.icq_align = __alignof__(struct noop_ioc),
 	.elevator_name = "noop",
 	.elevator_owner = THIS_MODULE,
 };
--

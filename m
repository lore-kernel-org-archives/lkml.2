Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1HKAmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:42:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14073 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1HKAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:42:22 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-b8-4e43256b9aa7
Date: Thu, 11 Aug 2011 09:42:16 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [RFC PATCH v2] Add new elevator ops for request hint
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com,
        shli@kernel.org, linux-mmc@vger.kernel.org
Message-id: <20110811004216.GA24810@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 11 Aug 2011 00:42:54.0045 (UTC)
 FILETIME=[9B2958D0:01CC57BF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

Now eMMC device requires the upper layer information to improve the data
performance and reliability.

. Context ID
Using the context information, it can sort out the data internally and improve the performance.
The main problem is that it's needed to define "What's the context". 
Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead

. Data Tag
Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.

With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.

Sample usage is following in drivers/mmc/card/block.c

	struct elevator_queue *e = md->queue.queue->elevator;
	struct request_hint hint;
	int ret;

	if (e->ops->elevator_get_req_hint_fn && req)
		ret = e->ops->elevator_get_req_hint_fn(req, &hint);

Thank you,
Kyungmin Park
---
Changelog v2
- Don't add the request member. instead add new elevator ops

---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..5089f67 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3800,6 +3800,18 @@ queue_fail:
 	return 1;
 }
 
+static int cfq_get_request_hint(struct request *rq, struct request_hint *hint)
+{
+	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+
+	if (cfqq) {
+		hint->context = cfqq->pid;
+		hint->hot = !!(rq->cmd_flags & REQ_META);
+	}
+
+	return 0;
+}
+
 static void cfq_kick_queue(struct work_struct *work)
 {
 	struct cfq_data *cfqd =
@@ -4211,6 +4223,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_set_req_fn =		cfq_set_request,
 		.elevator_put_req_fn =		cfq_put_request,
+		.elevator_get_req_hint_fn =	cfq_get_request_hint,
 		.elevator_may_queue_fn =	cfq_may_queue,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e67c45..8d9592b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -71,6 +71,11 @@ enum rq_cmd_type_bits {
 
 #define BLK_MAX_CDB	16
 
+struct request_hint {
+	int context;			/* Context ID */
+	unsigned int hot:1;		/* Hot/cold */
+};
+
 /*
  * try to put the fields that are referenced together in the same cacheline.
  * if you modify this structure, be sure to check block/blk-core.c:blk_rq_init()
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d800d51..114d427 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,6 +26,7 @@ typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
+typedef int (elevator_get_req_hint_fn) (struct request *, struct request_hint *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
 
@@ -52,6 +53,7 @@ struct elevator_ops
 
 	elevator_set_req_fn *elevator_set_req_fn;
 	elevator_put_req_fn *elevator_put_req_fn;
+	elevator_get_req_hint_fn *elevator_get_req_hint_fn;
 
 	elevator_may_queue_fn *elevator_may_queue_fn;
 

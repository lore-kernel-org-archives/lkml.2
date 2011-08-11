Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1HKJDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:03:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58500 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab1HKJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:03:20 -0400
X-AuditID: cbfee61b-b7c3dae000002cb8-a4-4e439ad7a3d6
Date: Thu, 11 Aug 2011 18:03:10 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [RFC PATCH v3] Add new elevator ops for request context
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com,
        shli@kernel.org, linux-mmc@vger.kernel.org
Message-id: <20110811090310.GA6779@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 11 Aug 2011 09:03:53.0155 (UTC)
 FILETIME=[97C98930:01CC5805]
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
First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it will modify the ext4 filesystem to send the REQ_META flags to know it from device drivers

With these characteristics, it's helpful to teach the device. After some consideration. it's needed to use the elevator and request helpers

Sample usage is following in drivers/mmc/card/block.c

	int context;

	if (req)
		context = elv_get_request_context(md->queue.queue, req);

Thank you,
Kyungmin Park
---
Changelog v3
- Don't create the request_hint structure from Jens
- Make a helper function from Jens/Shaohua

Changelog v2
- Don't add the request member. instead add new elevator ops from Jens

---
 static void flush_end_io(struct request *flush_rq, int error)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..45187e3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3800,6 +3800,16 @@ queue_fail:
 	return 1;
 }
 
+static int cfq_get_request_context(struct request *rq)
+{
+	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+
+	if (cfqq)
+		return cfqq->pid;
+
+	return 0;
+}
+
 static void cfq_kick_queue(struct work_struct *work)
 {
 	struct cfq_data *cfqd =
@@ -4211,6 +4221,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_set_req_fn =		cfq_set_request,
 		.elevator_put_req_fn =		cfq_put_request,
+		.elevator_get_req_context_fn =	cfq_get_request_context,
 		.elevator_may_queue_fn =	cfq_may_queue,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e67c45..e564500 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -551,6 +551,19 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
 		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
+static inline int elv_get_request_context(struct request_queue *q,
+			struct request *rq)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (!(rq->cmd_flags & REQ_ELVPRIV))
+		return 0;
+
+	if (e->ops->elevator_get_req_context_fn)
+		return e->ops->elevator_get_req_context_fn(rq);
+
+	return 0;
+}
 
 /*
  * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d800d51..0005a6f 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,6 +26,7 @@ typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
+typedef int (elevator_get_req_context_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
 
@@ -52,6 +53,7 @@ struct elevator_ops
 
 	elevator_set_req_fn *elevator_set_req_fn;
 	elevator_put_req_fn *elevator_put_req_fn;
+	elevator_get_req_context_fn *elevator_get_req_context_fn;
 
 	elevator_may_queue_fn *elevator_may_queue_fn;
 

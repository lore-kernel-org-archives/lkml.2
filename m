Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1HIDrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 23:47:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32064 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1HIDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 23:47:31 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-b9-4e40add10221
Date: Tue, 09 Aug 2011 12:47:24 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [RFC PATCH] request: teach the device more intelligent
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com
Message-id: <20110809034724.GA22257@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 09 Aug 2011 03:48:04.0301 (UTC)
 FILETIME=[24905FD0:01CC5647]
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

Can you give your opinions and does it proper fields at requests?

Thank you,
Kyungmin Park
---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..d73bfa7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3790,6 +3790,7 @@ new_queue:
 	rq->elevator_private[0] = cic;
 	rq->elevator_private[1] = cfqq;
 	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->hint.context = (int) cfqq->pid;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	return 0;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e67c45..0145c10 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -69,6 +69,14 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_ATA_PC,
 };
 
+/*
+ * request hint
+ */
+struct request_hint {
+	int context;			/* Context ID */
+	int hot:1;			/* Hot/cold data */
+};
+
 #define BLK_MAX_CDB	16
 
 /*
@@ -139,6 +147,7 @@ struct request {
 
 	int ref_count;
 
+	struct request_hint hint;	/* request hint information */
 	void *special;		/* opaque pointer available for LLD use */
 	char *buffer;		/* kaddr of the current segment if available */
 

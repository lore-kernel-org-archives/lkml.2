Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2DRG0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50395 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab2DRG0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:26:12 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 04/11] block: Expedite DMPG and SWAPIN requests ahead of the queue
Date: Wed, 18 Apr 2012 11:55:25 +0530
Message-ID: <1334730332-22244-5-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilan Smith <ilan.smith@sandisk.com>

When expedite_swapin and expedite_dmpg are set, move the
requests ahead of the queue.

Signed-off-by: Ilan Smith <ilan.smith@sandisk.com>
Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 block/blk-core.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..0b54ee9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1305,6 +1305,12 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	if (bio->bi_rw & REQ_RAHEAD)
 		req->cmd_flags |= REQ_FAILFAST_MASK;
 
+	if (bio_swapin(bio) && blk_queue_exp_swapin(req->q))
+		req->cmd_flags |= REQ_RW_SWAPIN;
+
+	if (bio_dmpg(bio) && blk_queue_exp_dmpg(req->q))
+		req->cmd_flags |= REQ_RW_DMPG;
+
 	req->errors = 0;
 	req->__sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
@@ -1332,6 +1338,18 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 		goto get_rq;
 	}
 
+	if (bio_swapin(bio) && blk_queue_exp_swapin(q)) {
+		spin_lock_irq(q->queue_lock);
+		where = ELEVATOR_INSERT_FRONT;
+		goto get_rq;
+	}
+
+	if (bio_dmpg(bio) && blk_queue_exp_dmpg(q)) {
+		spin_lock_irq(q->queue_lock);
+		where = ELEVATOR_INSERT_FRONT;
+		goto get_rq;
+	}
+
 	/*
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
-- 
1.7.10.rc2


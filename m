Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab2FDOnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:43:11 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:37586 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2FDOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:43:08 -0400
From: Tao Guo <glorioustao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Guo <glorioustao@gmail.com>, Tao Guo <Tao.Guo@emc.com>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] umem: fix up unplugging
Date: Mon,  4 Jun 2012 10:41:51 -0400
Message-Id: <1338820911-4733-2-git-send-email-glorioustao@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
References: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In that patch, Jens removed the whole mm_unplug_device()
function, which used to be the trigger to make umem start to work.

We need to implement unplugging to make umem start to work, or I/O
will never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
---
 drivers/block/umem.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index aa27120..89cc9a6 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -513,6 +513,15 @@ static void process_page(unsigned long data)
 	}
 }
 
+static void mm_unplug(struct blk_plug_cb *cb)
+{
+	struct cardinfo *card = cb->q->queuedata;
+
+	spin_lock_irq(&card->lock);
+	activate(card);
+	spin_unlock_irq(&card->lock);
+}
+
 static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -523,6 +532,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !blk_check_plugged(q, mm_unplug))
+		activate(card);
 	spin_unlock_irq(&card->lock);
 
 	return;
-- 
1.7.7.6


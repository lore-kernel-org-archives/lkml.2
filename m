Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876Ab2FGRM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:12:26 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:48857 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2FGRMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:12:25 -0400
From: Tao Guo <glorioustao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Guo <glorioustao@gmail.com>, Tao Guo <Tao.Guo@emc.com>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH V2] umem: fix up unplugging
Date: Thu,  7 Jun 2012 13:07:15 -0400
Message-Id: <1339088835-2614-1-git-send-email-glorioustao@gmail.com>
X-Mailer: git-send-email 1.7.7.6
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression introduced by 7eaceaccab5f40 ("block: remove per-queue
plugging").  In that patch, Jens removed the whole mm_unplug_device()
function, which used to be the trigger to make umem start to work.

We need to implement unplugging to make umem start to work, or I/O will
never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>
Cc: <stable@vger.kernel.org>
---
 drivers/block/umem.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index aa27120..9a72277 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -513,6 +513,44 @@ static void process_page(unsigned long data)
 	}
 }
 
+struct mm_plug_cb {
+	struct blk_plug_cb cb;
+	struct cardinfo *card;
+};
+
+static void mm_unplug(struct blk_plug_cb *cb)
+{
+	struct mm_plug_cb *mmcb = container_of(cb, struct mm_plug_cb, cb);
+
+	spin_lock_irq(&mmcb->card->lock);
+	activate(mmcb->card);
+	spin_unlock_irq(&mmcb->card->lock);
+	kfree(mmcb);
+}
+
+static int mm_check_plugged(struct cardinfo *card)
+{
+	struct blk_plug *plug = current->plug;
+	struct mm_plug_cb *mmcb;
+
+	if (!plug)
+		return 0;
+
+	list_for_each_entry(mmcb, &plug->cb_list, cb.list) {
+		if (mmcb->cb.callback == mm_unplug && mmcb->card == card)
+			return 1;
+	}
+	/* Not currently on the callback list */
+	mmcb = kmalloc(sizeof(*mmcb), GFP_ATOMIC);
+	if (!mmcb)
+		return 0;
+
+	mmcb->card = card;
+	mmcb->cb.callback = mm_unplug;
+	list_add(&mmcb->cb.list, &plug->cb_list);
+	return 1;
+}
+
 static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -523,6 +561,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
+		activate(card);
 	spin_unlock_irq(&card->lock);
 
 	return;
-- 
1.7.7.6


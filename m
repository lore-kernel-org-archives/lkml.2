Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1L3PKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:10:25 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:29930 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1L3PKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:10:10 -0500
From: Tao Guo <glorioustao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: neilb@suse.de, axboe@fusionio.com, Tao Guo <glorioustao@gmail.com>,
        Tao Guo <Tao.Guo@emc.com>
Subject: [PATCH] umem: fix up unplugging.
Date: Fri, 30 Dec 2011 09:17:31 -0500
Message-Id: <1325254651-15379-1-git-send-email-glorioustao@gmail.com>
X-Mailer: git-send-email 1.7.7
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to implement unplugging to make umem start to work, or I/O
will never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
---
 drivers/block/umem.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index aa27120..c3bf98e 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -111,7 +111,8 @@ struct cardinfo {
 	int		current_idx;
 	sector_t	current_sector;
 
-	struct request_queue *queue;
+	struct request_queue	*queue;
+	struct blk_plug_cb	plug_cb;
 
 	struct mm_page {
 		dma_addr_t		page_dma;
@@ -513,6 +514,33 @@ static void process_page(unsigned long data)
 	}
 }
 
+static void mm_unplug(struct blk_plug_cb *cb)
+{
+	struct cardinfo *card = container_of(cb, struct cardinfo, plug_cb);
+
+	spin_lock_irq(&card->lock);
+	activate(card);
+	spin_unlock_irq(&card->lock);
+}
+
+int mm_check_plugged(struct cardinfo *card)
+{
+	struct blk_plug *plug = current->plug;
+	struct cardinfo *c;
+
+	if (!plug)
+		return 0;
+
+	list_for_each_entry(c, &plug->cb_list, plug_cb.list) {
+		if (c == card)
+			return 1;
+	}
+
+	/* set up unplug callback */
+	list_add(&card->plug_cb.list, &plug->cb_list);
+	return 1;
+}
+
 static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -523,6 +551,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
+		activate(card);
 	spin_unlock_irq(&card->lock);
 
 	return;
@@ -884,6 +914,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 	blk_queue_make_request(card->queue, mm_make_request);
 	card->queue->queue_lock = &card->lock;
 	card->queue->queuedata = card;
+	card->plug_cb.callback = mm_unplug;
 
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2GIOiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130Ab2GIOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:56 -0400
Message-Id: <20120709143116.945009227@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Guo <glorioustao@gmail.com>,
        Tao Guo <Tao.Guo@emc.com>, Neil Brown <neilb@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>
Subject: [ 02/48] umem: fix up unplugging
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Guo <glorioustao@gmail.com>

commit 32587371ad3db2f9d335de10dbd8cffd4fff5669 upstream.

Fix a regression introduced by 7eaceaccab5f40 ("block: remove per-queue
plugging").  In that patch, Jens removed the whole mm_unplug_device()
function, which used to be the trigger to make umem start to work.

We need to implement unplugging to make umem start to work, or I/O will
never be triggered.

Signed-off-by: Tao Guo <Tao.Guo@emc.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/umem.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

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



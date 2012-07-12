Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab2GLXIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:08:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162824Ab2GLXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Guo <Tao.Guo@emc.com>, Neil Brown <neilb@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>
Subject: [ 58/68] umem: fix up unplugging
Date: Thu, 12 Jul 2012 16:02:32 -0700
Message-Id: <20120712175040.562448685@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: <stable@vger.kernel.org>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/umem.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -513,6 +513,44 @@ static void process_page(unsigned long d
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
 static int mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -523,6 +561,8 @@ static int mm_make_request(struct reques
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
+		activate(card);
 	spin_unlock_irq(&card->lock);
 
 	return 0;



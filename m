Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1HCQBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:01:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1HCQAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:00:51 -0400
Date: Wed, 3 Aug 2011 18:00:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
Message-ID: <20110803160050.GA18882@redhat.com>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
 <4E318BD0.40202@lwfinger.net>
 <20110730113009.GA2847@redhat.com>
 <20110730113255.GB2847@redhat.com>
 <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
 <4E341DC4.9010107@01019freenet.de>
 <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 01:07:11PM -0400, Justin Piszcz wrote:
> Here you go, crash 2:
> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p1.jpg
> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p2.jpg

Here is next (draw) patch to test:

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2a6aa85..2d662f3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -725,14 +725,14 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 
-void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
+int rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	struct queue_entry *entry;
 	u32 reg;
 	u8 qid;
 
-	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
+	while (kfifo_peek(&rt2x00dev->txstatus_fifo, &reg)) {
 
 		/* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
 		 * qid is guaranteed to be one of the TX QIDs
@@ -742,25 +742,38 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		if (unlikely(!queue)) {
 			WARNING(rt2x00dev, "Got TX status for an unavailable "
 					   "queue %u, dropping\n", qid);
-			continue;
+			goto next_reg;
 		}
 
 		/*
 		 * Inside each queue, we process each entry in a chronological
 		 * order. We first check that the queue is not empty.
 		 */
-		entry = NULL;
-		while (!rt2x00queue_empty(queue)) {
+		while (1) {
+			entry = NULL;
+			if (rt2x00queue_empty(queue))
+				break;
+
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+
+			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags)) {
+				ERROR(rt2x00dev, "Data pending\n");
+				return 1;
+			}
+
 			if (rt2800_txdone_entry_check(entry, reg))
 				break;
 		}
 
-		if (!entry || rt2x00queue_empty(queue))
-			break;
-
-		rt2800_txdone_entry(entry, reg);
+		if (entry)
+			rt2800_txdone_entry(entry, reg);
+next_reg:
+		if (kfifo_get(&rt2x00dev->txstatus_fifo, &reg) != 1)
+			ERROR(rt2x00dev, "BUG on kfifo");
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index f2d1594..54d0d14 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -152,7 +152,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			  struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
-void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
+int rt2800_txdone(struct rt2x00_dev *rt2x00dev);
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ba82c97..a8a9f79 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -464,7 +464,8 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 	struct data_queue *queue;
 	struct queue_entry *entry;
 
-	rt2800_txdone(rt2x00dev);
+	if (rt2800_txdone(rt2x00dev))
+		goto out;
 
 	/*
 	 * Process any trailing TX status reports for IO failures,
@@ -488,6 +489,7 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 		}
 	}
 
+out:
 	/*
 	 * The hw may delay sending the packet after DMA complete
 	 * if the medium is busy, thus the TX_STA_FIFO entry is
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index ab8c16f..7635014 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -784,6 +784,57 @@ bool rt2x00queue_for_each_entry(struct data_queue *queue,
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_for_each_entry);
 
+static void rt2x00queue_validate(struct data_queue *queue)
+{
+	int idx0, idx1, idx2;
+	int tmp = 0;
+	int u;
+
+	switch (queue->qid) {
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		goto do_validate;
+	default:
+		return;
+	}
+
+do_validate:
+
+	idx0 = queue->index[2];
+	idx1 = queue->index[1];
+	idx2 = queue->index[0];
+
+	tmp = idx0 + queue->length;
+	if (tmp >= queue->limit)
+		tmp -= queue->limit;
+
+	if (tmp != idx2) {
+		u = 0;
+		goto print;
+	}
+
+	if (idx2 >= idx0) {
+		u = 1;
+		if (idx1 < idx0 || idx1 > idx2)
+			goto print;
+	} else {
+		bool check = (idx1 >= idx0 && idx1 < queue->limit) ||
+			     (idx1 >= 0 && idx1 <= idx2);
+
+		u = 2;
+		if (!check)
+			goto print;
+	}
+
+	return;
+
+print:
+	printk(KERN_CRIT "%s %d idx(%d, %d, %d) tmp %d\n", __func__, u, idx2, idx1, idx0, tmp);
+	BUG_ON(1);
+}
+
 struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index)
 {
@@ -800,6 +851,7 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 
 	entry = &queue->entries[queue->index[index]];
 
+	rt2x00queue_validate(queue);
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 
 	return entry;
@@ -832,6 +884,7 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 		queue->count++;
 	}
 
+	rt2x00queue_validate(queue);
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 8f90f62..de3720f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -265,14 +265,14 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
-	if (rt2x00dev->ops->lib->tx_dma_done)
-		rt2x00dev->ops->lib->tx_dma_done(entry);
-
 	/*
 	 * Report the frame as DMA done
 	 */
 	rt2x00lib_dmadone(entry);
 
+	if (rt2x00dev->ops->lib->tx_dma_done)
+		rt2x00dev->ops->lib->tx_dma_done(entry);
+
 	/*
 	 * Check if the frame was correctly uploaded
 	 */


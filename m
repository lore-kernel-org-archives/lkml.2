Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1JKRH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:07:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1JKRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:07:19 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:11 2011
Message-Id: <20111011165711.507647435@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:31 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [21/38] rt2x00: Serialize TX operations on a queue.
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 77a861c405da75d81e9e6e32c50eb7f9777777e8 upstream.

The rt2x00 driver gets frequent occurrences of the following error message
when operating under load:
phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the
non-full queue 2.

This is caused by simultaneous attempts from mac80211 to send a frame via
rt2x00, which are not properly serialized inside rt2x00queue_write_tx_frame,
causing the second frame to fail sending with the above mentioned error
message.

Fix this by introducing a per-queue spinlock to serialize the TX operations
on that queue.

Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   21 ++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -556,15 +556,21 @@ int rt2x00queue_write_tx_frame(struct da
 			       bool local)
 {
 	struct ieee80211_tx_info *tx_info;
-	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
+	struct queue_entry *entry;
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
 	u8 rate_idx, rate_flags;
+	int ret = 0;
+
+	spin_lock(&queue->tx_lock);
+
+	entry = rt2x00queue_get_entry(queue, Q_INDEX);
 
 	if (unlikely(rt2x00queue_full(queue))) {
 		ERROR(queue->rt2x00dev,
 		      "Dropping frame due to full tx queue %d.\n", queue->qid);
-		return -ENOBUFS;
+		ret = -ENOBUFS;
+		goto out;
 	}
 
 	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
@@ -573,7 +579,8 @@ int rt2x00queue_write_tx_frame(struct da
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
 		      queue->qid, DRV_PROJECT);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/*
@@ -635,7 +642,8 @@ int rt2x00queue_write_tx_frame(struct da
 	if (unlikely(rt2x00queue_write_tx_data(entry, &txdesc))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		entry->skb = NULL;
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	set_bit(ENTRY_DATA_PENDING, &entry->flags);
@@ -644,7 +652,9 @@ int rt2x00queue_write_tx_frame(struct da
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_kick_tx_queue(queue, &txdesc);
 
-	return 0;
+out:
+	spin_unlock(&queue->tx_lock);
+	return ret;
 }
 
 int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
@@ -1185,6 +1195,7 @@ static void rt2x00queue_init(struct rt2x
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
 	mutex_init(&queue->status_lock);
+	spin_lock_init(&queue->tx_lock);
 	spin_lock_init(&queue->index_lock);
 
 	queue->rt2x00dev = rt2x00dev;
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -432,6 +432,7 @@ enum data_queue_flags {
  * @flags: Entry flags, see &enum queue_entry_flags.
  * @status_lock: The mutex for protecting the start/stop/flush
  *	handling on this queue.
+ * @tx_lock: Spinlock to serialize tx operations on this queue.
  * @index_lock: Spinlock to protect index handling. Whenever @index, @index_done or
  *	@index_crypt needs to be changed this lock should be grabbed to prevent
  *	index corruption due to concurrency.
@@ -458,6 +459,7 @@ struct data_queue {
 	unsigned long flags;
 
 	struct mutex status_lock;
+	spinlock_t tx_lock;
 	spinlock_t index_lock;
 
 	unsigned int count;



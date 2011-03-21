Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1CUXvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:51:55 -0400
Received: from kroah.org ([198.145.64.141]:49265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1CUXPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.503017570@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [13/87] rt2x00: Fix crash on USB unplug
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ivo van Doorn <ivdoorn@gmail.com>

commit 070192dd2975c0e97bbdeac7623b755235c6db7d upstream.

By not scheduling the TX/RX completion worker threads
when Radio is disabled, or hardware has been unplugged,
the queues cannot be completely cleaned.

This causes crashes when the hardware has been unplugged while
the radio is still enabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 ++++++++++--
 drivers/net/wireless/rt2x00/rt2x00usb.c |    8 ++------
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -486,6 +486,10 @@ void rt2x00lib_rxdone(struct queue_entry
 	unsigned int header_length;
 	int rate_idx;
 
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
+	    !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		goto submit_entry;
+
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		goto submit_entry;
 
@@ -570,9 +574,13 @@ void rt2x00lib_rxdone(struct queue_entry
 	entry->skb = skb;
 
 submit_entry:
-	rt2x00dev->ops->lib->clear_entry(entry);
-	rt2x00queue_index_inc(entry->queue, Q_INDEX);
+	entry->flags = 0;
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags)) {
+		rt2x00dev->ops->lib->clear_entry(entry);
+		rt2x00queue_index_inc(entry->queue, Q_INDEX);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -226,9 +226,7 @@ static void rt2x00usb_interrupt_txdone(s
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.
 	 */
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
 }
 
 static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
@@ -424,9 +422,7 @@ static void rt2x00usb_interrupt_rxdone(s
 	 * Schedule the delayed work for reading the RX status
 	 * from the device.
 	 */
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
 }
 
 /*



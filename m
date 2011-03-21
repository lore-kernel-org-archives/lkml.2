Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1CUXvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:51:54 -0400
Received: from kroah.org ([198.145.64.141]:49270 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1CUXPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.609073464@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Stezenbach <js@sig21.net>, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [14/87] rt2x00: fix hang when unplugging USB device in use
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Stezenbach <js@sig21.net>

commit d7bb5f845f437662296adbfeaab8fbfce1c32289 upstream.

When an rt2x00 USB device is unplugged while in use, it reliably
hangs the whole system.  After some time the watchdog prints:

BUG: soft lockup - CPU#0 stuck for 64s! [kworker/u:0:5]
...
[<c01a88d8>] (usb_submit_urb+0x0/0x2ac) from [<bf0e752c>] (rt2x00usb_kick_rx_entry+0xb4/0xe8 [rt2x00usb])
[<bf0e7478>] (rt2x00usb_kick_rx_entry+0x0/0xe8 [rt2x00usb]) from [<bf0e7588>] (rt2x00usb_clear_entry+x28/0x2c [rt2x00usb])
[<bf0e7560>] (rt2x00usb_clear_entry+0x0/0x2c [rt2x00usb]) from [<bf0d5bc4>] (rt2x00lib_rxdone+0x2e0/0x2f8 [rt2x00lib])
[<bf0d58e4>] (rt2x00lib_rxdone+0x0/0x2f8 [rt2x00lib]) from [<bf0e7e00>] (rt2x00usb_work_rxdone+0x54/0x74 [rt2x00usb])
[<bf0e7dac>] (rt2x00usb_work_rxdone+0x0/0x74 [rt2x00usb]) from [<c00542b4>] (process_one_work+0x20c/0x35c)

Clear the DEVICE_STATE_PRESENT flag when usb_submit_urb()
returns -ENODEV to fix this.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -235,6 +235,7 @@ static void rt2x00usb_kick_tx_entry(stru
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	u32 length;
+	int status;
 
 	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags))
 		return;
@@ -251,7 +252,10 @@ static void rt2x00usb_kick_tx_entry(stru
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
-	if (usb_submit_urb(entry_priv->urb, GFP_ATOMIC)) {
+	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+	if (status) {
+		if (status == -ENODEV)
+			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
 	}
@@ -450,6 +454,7 @@ void rt2x00usb_clear_entry(struct queue_
 	    to_usb_device_intf(entry->queue->rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	int pipe;
+	int status;
 
 	entry->flags = 0;
 
@@ -460,7 +465,12 @@ void rt2x00usb_clear_entry(struct queue_
 				rt2x00usb_interrupt_rxdone, entry);
 
 		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		if (usb_submit_urb(entry_priv->urb, GFP_ATOMIC)) {
+
+		status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+		if (status) {
+			if (status == -ENODEV)
+				clear_bit(DEVICE_STATE_PRESENT,
+					  &entry->queue->rt2x00dev->flags);
 			set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 			rt2x00lib_dmadone(entry);
 		}



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1H0O7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab1H0O7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:56 2011
Message-Id: <20110826215056.193751256@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [32/35] rt2x00: fix order of entry flags modification
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit df71c9cfceea801e7e26e2c74241758ef9c042e5 upstream.

In rt2800usb_work_txdone we check flags in order:

- ENTRY_OWNER_DEVICE_DATA
- ENTRY_DATA_STATUS_PENDING
- ENTRY_DATA_IO_FAILED

Modify flags in separate order in rt2x00usb_interrupt_txdone, to avoid
processing entries in _txdone with wrong flags or skip processing
ready entries.

Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -262,23 +262,20 @@ static void rt2x00usb_interrupt_txdone(s
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
-
-	if (rt2x00dev->ops->lib->tx_dma_done)
-		rt2x00dev->ops->lib->tx_dma_done(entry);
-
-	/*
-	 * Report the frame as DMA done
-	 */
-	rt2x00lib_dmadone(entry);
-
 	/*
 	 * Check if the frame was correctly uploaded
 	 */
 	if (urb->status)
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
 
+	if (rt2x00dev->ops->lib->tx_dma_done)
+		rt2x00dev->ops->lib->tx_dma_done(entry);
 	/*
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.



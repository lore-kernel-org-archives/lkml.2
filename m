Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1CUQhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:37:06 -0400
Received: from realvnc.com ([146.101.152.142]:45700 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1CUQhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:37:04 -0400
X-Greylist: delayed 2668 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 12:37:03 EDT
From: Toby Gray <toby.gray@realvnc.com>
To: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Toby Gray <toby.gray@realvnc.com>
Subject: [PATCH] USB: cdc-acm: Prevent data loss when filling tty buffer.
Date: Mon, 21 Mar 2011 15:52:25 +0000
Message-Id: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending large quantities of data through a CDC ACM channel it is possible
for data to be lost when attempting to copy the data to the tty buffer. This
occurs due to the return value from tty_insert_flip_string not being checked.

This patch adds checking for how many bytes have been inserted into the tty
buffer and returns any remaining bytes back to the filled read buffer list.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
---
 drivers/usb/class/cdc-acm.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f492a7f..63133c7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -392,6 +392,7 @@ static void acm_rx_tasklet(unsigned long _acm)
 	struct acm_ru *rcv;
 	unsigned long flags;
 	unsigned char throttled;
+	int copied;
 
 	dbg("Entering acm_rx_tasklet");
 
@@ -423,12 +424,14 @@ next_buffer:
 
 	dbg("acm_rx_tasklet: procesing buf 0x%p, size = %d", buf, buf->size);
 
+	copied = 0;
 	if (tty) {
 		spin_lock_irqsave(&acm->throttle_lock, flags);
 		throttled = acm->throttle;
 		spin_unlock_irqrestore(&acm->throttle_lock, flags);
 		if (!throttled) {
-			tty_insert_flip_string(tty, buf->base, buf->size);
+			copied = tty_insert_flip_string(tty,
+							buf->base, buf->size);
 			tty_flip_buffer_push(tty);
 		} else {
 			tty_kref_put(tty);
@@ -440,9 +443,26 @@ next_buffer:
 		}
 	}
 
-	spin_lock_irqsave(&acm->read_lock, flags);
-	list_add(&buf->list, &acm->spare_read_bufs);
-	spin_unlock_irqrestore(&acm->read_lock, flags);
+	if (copied == buf->size || !tty) {
+		spin_lock_irqsave(&acm->read_lock, flags);
+		list_add(&buf->list, &acm->spare_read_bufs);
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+	} else {
+		tty_kref_put(tty);
+		dbg("Partial buffer fill");
+		if (copied > 0) {
+			memmove(buf->base,
+				buf->base + copied,
+				buf->size - copied);
+			buf->size -= copied;
+		}
+
+		spin_lock_irqsave(&acm->read_lock, flags);
+		list_add(&buf->list, &acm->filled_read_bufs);
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+		return;
+	}
+
 	goto next_buffer;
 
 urbs:
-- 
1.7.0.4


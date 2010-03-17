Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0CQWIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:08:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:8092 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0CQWID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qNmPLskIoAJnFMfhC40LgwkqwnZ3WoTgdy1QjLj6oaFkTXbdkTXgoak3wrMUir2eJO
         d8tzLbsw1EMf+AEYolku3VrhjgVdWksH4EV6u5Yms4KpZI1ST6WFWG1tFulMYGcsVuVm
         SsFmyWKNwJpHM3g2Y4Zx/ESYuglqBHjatY64Q=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 6/9] USB: serial: fix generic chars_in_buffer
Date: Wed, 17 Mar 2010 23:00:42 +0100
Message-Id: <1268863245-17230-7-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure chars_in_buffer accounts also for data in host stack queues.

This fixes the problem with tty_wait_until_sent returning too soon at
close which could cause the final write urb to be cancelled.

Reported-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/generic.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index ba61c74..8d6d790 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -308,10 +308,14 @@ static int usb_serial_generic_write_start(struct usb_serial_port *port)
 		/* don't have to grab the lock here, as we will
 		   retry if != 0 */
 		port->write_urb_busy = 0;
-	} else
-		result = count;
+		return result;
+	}
 
-	return result;
+	spin_lock_irqsave(&port->lock, flags);
+	port->tx_bytes_flight += count;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return count;
 }
 
 /**
@@ -399,7 +403,7 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 	if (serial->type->max_in_flight_urbs)
 		chars = port->tx_bytes_flight;
 	else
-		chars = kfifo_len(&port->write_fifo);
+		chars = kfifo_len(&port->write_fifo) + port->tx_bytes_flight;
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, chars);
@@ -509,7 +513,10 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 			port->urbs_in_flight = 0;
 		spin_unlock_irqrestore(&port->lock, flags);
 	} else {
+		spin_lock_irqsave(&port->lock, flags);
+		port->tx_bytes_flight -= urb->transfer_buffer_length;
 		port->write_urb_busy = 0;
+		spin_unlock_irqrestore(&port->lock, flags);
 
 		if (status)
 			kfifo_reset_out(&port->write_fifo);
-- 
1.7.0.2


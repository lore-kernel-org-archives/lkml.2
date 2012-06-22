Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab2FVPWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:22:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40734 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762276Ab2FVPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:22:53 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/12] usb: fix sillies in the metro USB driver
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:38:45 +0100
Message-ID: <20120622153655.1405.21453.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bits noticed doing the termios conversion

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/metro-usb.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
index 81423f7..bad5f0c 100644
--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -130,20 +130,14 @@ static void metrousb_read_int_callback(struct urb *urb)
 
 	/* Set the data read from the usb port into the serial port buffer. */
 	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dev_err(&port->dev, "%s - bad tty pointer - exiting\n",
-			__func__);
-		return;
-	}
-
 	if (tty && urb->actual_length) {
 		/* Loop through the data copying each byte to the tty layer. */
 		tty_insert_flip_string(tty, data, urb->actual_length);
 
 		/* Force the data to the tty layer. */
 		tty_flip_buffer_push(tty);
+		tty_kref_put(tty);
 	}
-	tty_kref_put(tty);
 
 	/* Set any port variables. */
 	spin_lock_irqsave(&metro_priv->lock, flags);


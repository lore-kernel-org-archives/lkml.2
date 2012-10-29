Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab2J2WIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:08:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:47642 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759133Ab2J2Vh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 057/101] USB: metro-usb: fix io after disconnect
Date: Mon, 29 Oct 2012 14:35:10 -0700
Message-Id: <20121029213246.594821540@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2ee44fbeac92c36e53779a57ee84cfee1affe418 upstream.

Make sure no control urb is submitted during close after a disconnect by
checking the disconnected flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/metro-usb.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -188,16 +188,13 @@ static void metrousb_cleanup(struct usb_
 {
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->dev) {
-		/* Shutdown any interrupt in urbs. */
-		if (port->interrupt_in_urb) {
-			usb_unlink_urb(port->interrupt_in_urb);
-			usb_kill_urb(port->interrupt_in_urb);
-		}
+	usb_unlink_urb(port->interrupt_in_urb);
+	usb_kill_urb(port->interrupt_in_urb);
 
-		/* Send deactivate cmd to device */
+	mutex_lock(&port->serial->disc_mutex);
+	if (!port->serial->disconnected)
 		metrousb_send_unidirectional_cmd(UNI_CMD_CLOSE, port);
-	}
+	mutex_unlock(&port->serial->disc_mutex);
 }
 
 static int metrousb_open(struct tty_struct *tty, struct usb_serial_port *port)



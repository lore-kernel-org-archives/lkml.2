Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313Ab2J2Vhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:47721 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761224Ab2J2Vhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 062/101] USB: quatech2: fix io after disconnect
Date: Mon, 29 Oct 2012 14:35:15 -0700
Message-Id: <20121029213247.183125268@linuxfoundation.org>
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

commit 2f0295adf6438188c4cd0868f2b1976a2b034e1d upstream.

Make sure no control urb is submitted during close after a disconnect by
checking the disconnected flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/quatech2.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -429,6 +429,12 @@ static void qt2_close(struct usb_serial_
 	port_priv->urb_in_use = false;
 	spin_unlock_irqrestore(&port_priv->urb_lock, flags);
 
+	mutex_lock(&port->serial->disc_mutex);
+	if (port->serial->disconnected) {
+		mutex_unlock(&port->serial->disc_mutex);
+		return;
+	}
+
 	/* flush the port transmit buffer */
 	i = usb_control_msg(serial->dev,
 			    usb_rcvctrlpipe(serial->dev, 0),
@@ -460,6 +466,7 @@ static void qt2_close(struct usb_serial_
 		dev_err(&port->dev, "%s - close port failed %i\n",
 			__func__, i);
 
+	mutex_unlock(&port->serial->disc_mutex);
 }
 
 static void qt2_disconnect(struct usb_serial *serial)



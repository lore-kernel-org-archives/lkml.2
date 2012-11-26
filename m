Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab2KZRPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab2KZRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 242/270] USB: quatech2: fix io after disconnect
Date: Mon, 26 Nov 2012 14:58:52 -0200
Message-Id: <1353949160-26803-243-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2f0295adf6438188c4cd0868f2b1976a2b034e1d upstream.

Make sure no control urb is submitted during close after a disconnect by
checking the disconnected flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/quatech2.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index d170271..09d736a 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -434,6 +434,12 @@ static void qt2_close(struct usb_serial_port *port)
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
@@ -465,6 +471,7 @@ static void qt2_close(struct usb_serial_port *port)
 		dev_err(&port->dev, "%s - close port failed %i\n",
 			__func__, i);
 
+	mutex_unlock(&port->serial->disc_mutex);
 }
 
 static void qt2_disconnect(struct usb_serial *serial)
-- 
1.7.9.5


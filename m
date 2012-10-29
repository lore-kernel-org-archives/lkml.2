Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513Ab2J2WFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:05:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:47791 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761323Ab2J2Vhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 061/101] USB: quatech2: fix close and disconnect urb handling
Date: Mon, 29 Oct 2012 14:35:14 -0700
Message-Id: <20121029213247.065871482@linuxfoundation.org>
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

commit 8e512ab0b675da20e023439a5811e3f2554e6852 upstream.

Kill urbs unconditionally at close and disconnect.

Note that URB status is not valid outside of completion handler.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/quatech2.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -425,8 +425,7 @@ static void qt2_close(struct usb_serial_
 	port_priv->is_open = false;
 
 	spin_lock_irqsave(&port_priv->urb_lock, flags);
-	if (port_priv->write_urb->status == -EINPROGRESS)
-		usb_kill_urb(port_priv->write_urb);
+	usb_kill_urb(port_priv->write_urb);
 	port_priv->urb_in_use = false;
 	spin_unlock_irqrestore(&port_priv->urb_lock, flags);
 
@@ -467,8 +466,7 @@ static void qt2_disconnect(struct usb_se
 {
 	struct qt2_serial_private *serial_priv = usb_get_serial_data(serial);
 
-	if (serial_priv->read_urb->status == -EINPROGRESS)
-		usb_kill_urb(serial_priv->read_urb);
+	usb_kill_urb(serial_priv->read_urb);
 }
 
 static int get_serial_info(struct usb_serial_port *port,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab2KZRYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:24:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934009Ab2KZROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 239/270] USB: metro-usb: fix io after disconnect
Date: Mon, 26 Nov 2012 14:58:49 -0200
Message-Id: <1353949160-26803-240-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2ee44fbeac92c36e53779a57ee84cfee1affe418 upstream.

Make sure no control urb is submitted during close after a disconnect by
checking the disconnected flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/metro-usb.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
index d47eb06..aafd914 100644
--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -188,16 +188,13 @@ static void metrousb_cleanup(struct usb_serial_port *port)
 {
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->dev) {
-		/* Shutdown any interrupt in urbs. */
-		if (port->interrupt_in_urb) {
-			usb_unlink_urb(port->interrupt_in_urb);
-			usb_kill_urb(port->interrupt_in_urb);
-		}
-
-		/* Send deactivate cmd to device */
+	usb_unlink_urb(port->interrupt_in_urb);
+	usb_kill_urb(port->interrupt_in_urb);
+
+	mutex_lock(&port->serial->disc_mutex);
+	if (!port->serial->disconnected)
 		metrousb_send_unidirectional_cmd(UNI_CMD_CLOSE, port);
-	}
+	mutex_unlock(&port->serial->disc_mutex);
 }
 
 static int metrousb_open(struct tty_struct *tty, struct usb_serial_port *port)
-- 
1.7.9.5


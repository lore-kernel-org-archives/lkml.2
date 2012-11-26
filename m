Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab2KZRPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab2KZRPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 244/270] USB: opticon: fix memory leak in error path
Date: Mon, 26 Nov 2012 14:58:54 -0200
Message-Id: <1353949160-26803-245-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit acbf0e5263de563e25f7c104868e4490b9e72b13 upstream.

Fix memory leak in write error path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/opticon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 5ba2700..623358a 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -289,7 +289,7 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (!dr) {
 		dev_err(&port->dev, "out of memory\n");
 		count = -ENOMEM;
-		goto error;
+		goto error_no_dr;
 	}
 
 	dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT;
@@ -319,6 +319,8 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	return count;
 error:
+	kfree(dr);
+error_no_dr:
 	usb_free_urb(urb);
 error_no_urb:
 	kfree(buffer);
-- 
1.7.9.5


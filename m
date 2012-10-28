Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab2J1Xpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:45:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41916 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305Ab2J1X1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:25 -0400
Message-Id: <20121028231602.445158429@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 082/105] USB: opticon: fix memory leak in error path
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit acbf0e5263de563e25f7c104868e4490b9e72b13 upstream.

Fix memory leak in write error path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/opticon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 459c288..6aba731 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -286,7 +286,7 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (!dr) {
 		dev_err(&port->dev, "out of memory\n");
 		count = -ENOMEM;
-		goto error;
+		goto error_no_dr;
 	}
 
 	dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT;
@@ -316,6 +316,8 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	return count;
 error:
+	kfree(dr);
+error_no_dr:
 	usb_free_urb(urb);
 error_no_urb:
 	kfree(buffer);



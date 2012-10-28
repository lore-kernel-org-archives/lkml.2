Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2J1XpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:45:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562Ab2J1X10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:26 -0400
Message-Id: <20121028231602.112752191@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:57 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 081/105] USB: opticon: fix DMA from stack
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

commit ea0dbebffe118724cd4df7d9b071ea8ee48d48f0 upstream.

Make sure to allocate the control-message buffer dynamically as some
platforms cannot do DMA from stack.

Note that only the first byte of the old buffer was used.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/opticon.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 41b1647..459c288 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -155,7 +155,11 @@ static int send_control_msg(struct usb_serial_port *port, u8 requesttype,
 {
 	struct usb_serial *serial = port->serial;
 	int retval;
-	u8 buffer[2];
+	u8 *buffer;
+
+	buffer = kzalloc(1, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	buffer[0] = val;
 	/* Send the message to the vendor control endpoint
@@ -164,6 +168,7 @@ static int send_control_msg(struct usb_serial_port *port, u8 requesttype,
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 				0, 0, buffer, 1, 0);
+	kfree(buffer);
 
 	return retval;
 }



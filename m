Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268Ab2J2Vhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:47711 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761181Ab2J2Vhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 054/101] USB: opticon: fix DMA from stack
Date: Mon, 29 Oct 2012 14:35:07 -0700
Message-Id: <20121029213246.263267203@linuxfoundation.org>
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

commit ea0dbebffe118724cd4df7d9b071ea8ee48d48f0 upstream.

Make sure to allocate the control-message buffer dynamically as some
platforms cannot do DMA from stack.

Note that only the first byte of the old buffer was used.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/opticon.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -158,7 +158,11 @@ static int send_control_msg(struct usb_s
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
@@ -167,6 +171,7 @@ static int send_control_msg(struct usb_s
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 				0, 0, buffer, 1, 0);
+	kfree(buffer);
 
 	return retval;
 }



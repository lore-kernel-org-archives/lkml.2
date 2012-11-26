Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab2KZRYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:24:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079Ab2KZRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 243/270] USB: opticon: fix DMA from stack
Date: Mon, 26 Nov 2012 14:58:53 -0200
Message-Id: <1353949160-26803-244-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ea0dbebffe118724cd4df7d9b071ea8ee48d48f0 upstream.

Make sure to allocate the control-message buffer dynamically as some
platforms cannot do DMA from stack.

Note that only the first byte of the old buffer was used.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/opticon.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 02cb1b7..5ba2700 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -158,7 +158,11 @@ static int send_control_msg(struct usb_serial_port *port, u8 requesttype,
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
@@ -167,6 +171,7 @@ static int send_control_msg(struct usb_serial_port *port, u8 requesttype,
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
 				0, 0, buffer, 1, 0);
+	kfree(buffer);
 
 	return retval;
 }
-- 
1.7.9.5


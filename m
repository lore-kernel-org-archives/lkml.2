Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab0JJGry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 02:47:54 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:41947 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0JJGrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 02:47:52 -0400
Content-transfer-encoding: 7BIT
From: Alon Ziv <alon+git@nolaviz.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alon Ziv <alon+git@nolaviz.org>
Subject: [PATCH 1/3] Fix long-standing bugs in opticon driver
Date: Sun, 10 Oct 2010 08:32:18 +0200
Message-id: <1286692340-18639-2-git-send-email-alon-git@nolaviz.org>
X-Mailer: git-send-email 1.6.3.3
In-reply-to: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bulk-read callback had two bugs:
a) The bulk-in packet's leading two zeros were returned (and the two last
   bytes truncated)
b) The wrong URB was transmitted for the second (and later) read requests,
   causing further reads to return the entire packet (including leading
   zeros)

Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
---
 drivers/usb/serial/opticon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index ed01f3b..9ff19c8 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -96,8 +96,8 @@ static void opticon_bulk_callback(struct urb *urb)
 			/* real data, send it to the tty layer */
 			tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				tty_insert_flip_string(tty, data,
-							       data_length);
+				tty_insert_flip_string(tty, data + 2,
+						       data_length);
 				tty_flip_buffer_push(tty);
 				tty_kref_put(tty);
 			}
@@ -130,7 +130,7 @@ exit:
 						  priv->bulk_address),
 				  priv->bulk_in_buffer, priv->buffer_size,
 				  opticon_bulk_callback, priv);
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
 		if (result)
 			dev_err(&port->dev,
 			    "%s - failed resubmitting read urb, error %d\n",
-- 
1.6.3.3


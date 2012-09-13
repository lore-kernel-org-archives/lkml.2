Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2IMS5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:57:16 -0400
Received: from mail.ispras.ru ([83.149.199.43]:42049 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab2IMS5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:57:10 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] USB: omninet: fix potential tty NULL dereference
Date: Thu, 13 Sep 2012 22:56:55 +0400
Message-Id: <1347562615-1250-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add check for return value of tty_port_tty_get,
since it can return NULL after port hangup that may happen anytime.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/serial/omninet.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 6f3d705..493c892 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -185,10 +185,12 @@ static void omninet_read_bulk_callback(struct urb *urb)
 
 	if (urb->actual_length && header->oh_len) {
 		struct tty_struct *tty = tty_port_tty_get(&port->port);
-		tty_insert_flip_string(tty, data + OMNINET_DATAOFFSET,
+		if (tty) {
+			tty_insert_flip_string(tty, data + OMNINET_DATAOFFSET,
 							header->oh_len);
-		tty_flip_buffer_push(tty);
-		tty_kref_put(tty);
+			tty_flip_buffer_push(tty);
+			tty_kref_put(tty);
+		}
 	}
 
 	/* Continue trying to always read  */
-- 
1.7.9.5


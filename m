Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0EGRrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:48409 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab0EGRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FlFy6F7CUOjxVUxFcbNzgCpfV2Owv14iYIeBYvvZB10xu3xT7IAqiCbyPk9GMBc7Ee
         ODo6xlJqhJ+ZENG3lG/IFOawhFDZG0U186P0CfoXvTn5jM3sOkTaKdPpF4iHcUfp4crk
         DPp9yg81mXrNu65hfvUhL30cyIDeY92NWLFI0=
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: tty: fix incorrect use of tty_insert_flip_string_fixed_flag
Date: Fri,  7 May 2010 19:46:56 +0200
Message-Id: <1273254416-29802-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit
a108bfcb372d8c4452701039308fb95747911c59 (USB: tty: Prune uses of
tty_request_room in the USB layer) which broke three drivers
(cypress_m8, digi_acceleport and spcp8x5) through incorrect use of
tty_insert_flip_string_fixed_flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/cypress_m8.c      |    2 +-
 drivers/usb/serial/digi_acceleport.c |    4 ++--
 drivers/usb/serial/spcp8x5.c         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index e23c779..582e832 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1309,7 +1309,7 @@ static void cypress_read_int_callback(struct urb *urb)
 	/* process read if there is data other than line status */
 	if (tty && bytes > i) {
 		tty_insert_flip_string_fixed_flag(tty, data + i,
-				bytes - i, tty_flag);
+				tty_flag, bytes - i);
 		tty_flip_buffer_push(tty);
 	}
 
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 68b0aa5..3edda3e 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1703,8 +1703,8 @@ static int digi_read_inb_callback(struct urb *urb)
 		/* data length is len-1 (one byte of len is port_status) */
 		--len;
 		if (len > 0) {
-			tty_insert_flip_string_fixed_flag(tty, data, len,
-									flag);
+			tty_insert_flip_string_fixed_flag(tty, data, flag,
+									len);
 			tty_flip_buffer_push(tty);
 		}
 	}
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 5d39191..2ea32c5 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -726,8 +726,8 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
 		/* overrun is special, not associated with a char */
 		if (status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		tty_insert_flip_string_fixed_flag(tty, data,
-						urb->actual_length, tty_flag);
+		tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
+							urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
-- 
1.7.0.4


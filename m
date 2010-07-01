Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab0GAVO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:14:29 -0400
Received: from kroah.org ([198.145.64.141]:33852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab0GAVNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:15 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:49 2010
Message-Id: <20100701174249.715114106@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [039/200] USB: tty: fix incorrect use of tty_insert_flip_string_fixed_flag
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 70ced221cc9f041481f129e63cc5b1dedb0ff959 upstream.

Fix regression introduced by commit
a108bfcb372d8c4452701039308fb95747911c59 (USB: tty: Prune uses of
tty_request_room in the USB layer) which broke three drivers
(cypress_m8, digi_acceleport and spcp8x5) through incorrect use of
tty_insert_flip_string_fixed_flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cypress_m8.c      |    2 +-
 drivers/usb/serial/digi_acceleport.c |    4 ++--
 drivers/usb/serial/spcp8x5.c         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1309,7 +1309,7 @@ static void cypress_read_int_callback(st
 	/* process read if there is data other than line status */
 	if (tty && bytes > i) {
 		tty_insert_flip_string_fixed_flag(tty, data + i,
-				bytes - i, tty_flag);
+				tty_flag, bytes - i);
 		tty_flip_buffer_push(tty);
 	}
 
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1703,8 +1703,8 @@ static int digi_read_inb_callback(struct
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
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -726,8 +726,8 @@ static void spcp8x5_read_bulk_callback(s
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



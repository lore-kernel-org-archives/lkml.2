Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1B1JeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:34:13 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:36585 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1B1JeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:34:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] USB: serial/keyspan_pda, fix potential tty NULL dereferences
Date: Mon, 28 Feb 2011 10:34:05 +0100
Message-Id: <1298885646-9293-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we check the return value of tty_port_tty_get.
Sometimes it may return NULL and we later dereference that.

There are several places to check. For easier handling,
tty_port_tty_get is moved directly to the palce where needed in
keyspan_pda_rx_interrupt.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/keyspan_pda.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 554a869..7b690f3 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -173,7 +173,8 @@ static void keyspan_pda_wakeup_write(struct work_struct *work)
 		container_of(work, struct keyspan_pda_private, wakeup_work);
 	struct usb_serial_port *port = priv->port;
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	tty_wakeup(tty);
+	if (tty)
+		tty_wakeup(tty);
 	tty_kref_put(tty);
 }
 
@@ -206,7 +207,7 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 static void keyspan_pda_rx_interrupt(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int retval;
 	int status = urb->status;
@@ -223,7 +224,7 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
 		    __func__, status);
-		goto out;
+		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
 		    __func__, status);
@@ -233,12 +234,14 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 	/* see if the message is data or a status interrupt */
 	switch (data[0]) {
 	case 0:
-		/* rest of message is rx data */
-		if (urb->actual_length) {
+		tty = tty_port_tty_get(&port->port);
+		 /* rest of message is rx data */
+		if (tty && urb->actual_length) {
 			tty_insert_flip_string(tty, data + 1,
 						urb->actual_length - 1);
 			tty_flip_buffer_push(tty);
 		}
+		tty_kref_put(tty);
 		break;
 	case 1:
 		/* status interrupt */
@@ -265,8 +268,6 @@ exit:
 		dev_err(&port->dev,
 			"%s - usb_submit_urb failed with result %d",
 			__func__, retval);
-out:
-	tty_kref_put(tty);		     
 }
 
 
-- 
1.7.4.1



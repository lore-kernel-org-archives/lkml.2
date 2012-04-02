Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2DBMLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:11:00 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47935 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jan Dumon <j.dumon@option.com>
Subject: [PATCH 23/69] TTY: hso, use tty from tty_port
Date: Mon,  2 Apr 2012 13:54:07 +0200
Message-Id: <1333367693-3244-24-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We switched tty refcounting there to the one provided by tty_port
helpers. So tty_port->tty is now protected by tty_port->lock, not by
hso_serial->serial_lock.

Side note: tty->driver_data does not need the lock, so it is needed
neither in open, nor in close paths.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Dumon <j.dumon@option.com>
---
 drivers/net/usb/hso.c |   40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index ec782c7..813d709 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -250,7 +250,6 @@ struct hso_serial {
 
 	struct tty_port port;
 	/* from usb_serial_port */
-	struct tty_struct *tty;
 	spinlock_t serial_lock;
 
 	int (*write_data) (struct hso_serial *serial);
@@ -1297,11 +1296,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	kref_get(&serial->parent->ref);
 
 	/* setup */
-	spin_lock_irq(&serial->serial_lock);
 	tty->driver_data = serial;
-	tty_kref_put(serial->tty);
-	serial->tty = tty_kref_get(tty);
-	spin_unlock_irq(&serial->serial_lock);
+	tty_port_tty_set(&serial->port, tty);
 
 	/* check for port already opened, if not set the termios */
 	serial->port.count++;
@@ -1358,13 +1354,7 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 
 	if (serial->port.count <= 0) {
 		serial->port.count = 0;
-		spin_lock_irq(&serial->serial_lock);
-		if (serial->tty == tty) {
-			serial->tty->driver_data = NULL;
-			serial->tty = NULL;
-			tty_kref_put(tty);
-		}
-		spin_unlock_irq(&serial->serial_lock);
+		tty_port_tty_set(&serial->port, NULL);
 		if (!usb_gone)
 			hso_stop_serial_device(serial->parent);
 		tasklet_kill(&serial->unthrottle_tasklet);
@@ -1947,14 +1937,13 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 
 	spin_lock(&serial->serial_lock);
 	serial->tx_urb_used = 0;
-	tty = tty_kref_get(serial->tty);
 	spin_unlock(&serial->serial_lock);
 	if (status) {
 		handle_usb_error(status, __func__, serial->parent);
-		tty_kref_put(tty);
 		return;
 	}
 	hso_put_activity(serial->parent);
+	tty = tty_port_tty_get(&serial->port);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -1994,7 +1983,6 @@ static void ctrl_callback(struct urb *urb)
 	struct hso_serial *serial = urb->context;
 	struct usb_ctrlrequest *req;
 	int status = urb->status;
-	struct tty_struct *tty;
 
 	/* sanity check */
 	if (!serial)
@@ -2002,11 +1990,9 @@ static void ctrl_callback(struct urb *urb)
 
 	spin_lock(&serial->serial_lock);
 	serial->tx_urb_used = 0;
-	tty = tty_kref_get(serial->tty);
 	spin_unlock(&serial->serial_lock);
 	if (status) {
 		handle_usb_error(status, __func__, serial->parent);
-		tty_kref_put(tty);
 		return;
 	}
 
@@ -2024,13 +2010,15 @@ static void ctrl_callback(struct urb *urb)
 		put_rxbuf_data_and_resubmit_ctrl_urb(serial);
 		spin_unlock(&serial->serial_lock);
 	} else {
+		struct tty_struct *tty = tty_port_tty_get(&serial->port);
 		hso_put_activity(serial->parent);
-		if (tty)
+		if (tty) {
 			tty_wakeup(tty);
+			tty_kref_put(tty);
+		}
 		/* response to a write command */
 		hso_kick_transmit(serial);
 	}
-	tty_kref_put(tty);
 }
 
 /* handle RX data for serial port */
@@ -2046,8 +2034,7 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 		return -2;
 	}
 
-	/* All callers to put_rxbuf_data hold serial_lock */
-	tty = tty_kref_get(serial->tty);
+	tty = tty_port_tty_get(&serial->port);
 
 	/* Push data to tty */
 	if (tty) {
@@ -2067,12 +2054,12 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 			write_length_remaining -= curr_write_len;
 			tty_flip_buffer_push(tty);
 		}
+		tty_kref_put(tty);
 	}
 	if (write_length_remaining == 0) {
 		serial->curr_rx_urb_offset = 0;
 		serial->rx_urb_filled[hso_urb_to_index(serial, urb)] = 0;
 	}
-	tty_kref_put(tty);
 	return write_length_remaining;
 }
 
@@ -3166,13 +3153,12 @@ static void hso_free_interface(struct usb_interface *interface)
 		if (serial_table[i] &&
 		    (serial_table[i]->interface == interface)) {
 			hso_dev = dev2ser(serial_table[i]);
-			spin_lock_irq(&hso_dev->serial_lock);
-			tty = tty_kref_get(hso_dev->tty);
-			spin_unlock_irq(&hso_dev->serial_lock);
-			if (tty)
+			tty = tty_port_tty_get(&hso_dev->port);
+			if (tty) {
 				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
 			mutex_lock(&hso_dev->parent->mutex);
-			tty_kref_put(tty);
 			hso_dev->parent->usb_gone = 1;
 			mutex_unlock(&hso_dev->parent->mutex);
 			kref_put(&serial_table[i]->ref, hso_serial_ref_free);
-- 
1.7.9.2



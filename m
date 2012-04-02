Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2DBMJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:09:32 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47942 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2DBLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jan Dumon <j.dumon@option.com>
Subject: [PATCH 21/69] TTY: hso, add tty_port
Date: Mon,  2 Apr 2012 13:54:05 +0200
Message-Id: <1333367693-3244-22-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use open count from there. Other members will follow.

Remark: port.count is (and never was) properly protected. Only a mutex
is held, so ISR and all the functions it calls may see an invalid
state.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Dumon <j.dumon@option.com>
---
 drivers/net/usb/hso.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index cdc589e..0b26d75 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -255,9 +255,9 @@ struct hso_serial {
 	u8 dtr_state;
 	unsigned tx_urb_used:1;
 
+	struct tty_port port;
 	/* from usb_serial_port */
 	struct tty_struct *tty;
-	int open_count;
 	spinlock_t serial_lock;
 
 	int (*write_data) (struct hso_serial *serial);
@@ -1190,7 +1190,7 @@ static void put_rxbuf_data_and_resubmit_ctrl_urb(struct hso_serial *serial)
 	struct urb *urb;
 
 	urb = serial->rx_urb[0];
-	if (serial->open_count > 0) {
+	if (serial->port.count > 0) {
 		count = put_rxbuf_data(urb, serial);
 		if (count == -1)
 			return;
@@ -1226,7 +1226,7 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
 	DUMP1(urb->transfer_buffer, urb->actual_length);
 
 	/* Anyone listening? */
-	if (serial->open_count == 0)
+	if (serial->port.count == 0)
 		return;
 
 	if (status == 0) {
@@ -1311,8 +1311,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	spin_unlock_irq(&serial->serial_lock);
 
 	/* check for port already opened, if not set the termios */
-	serial->open_count++;
-	if (serial->open_count == 1) {
+	serial->port.count++;
+	if (serial->port.count == 1) {
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
@@ -1324,7 +1324,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
 			hso_stop_serial_device(serial->parent);
-			serial->open_count--;
+			serial->port.count--;
 			kref_put(&serial->parent->ref, hso_serial_ref_free);
 		}
 	} else {
@@ -1361,10 +1361,10 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 
 	/* reset the rts and dtr */
 	/* do the actual close */
-	serial->open_count--;
+	serial->port.count--;
 
-	if (serial->open_count <= 0) {
-		serial->open_count = 0;
+	if (serial->port.count <= 0) {
+		serial->port.count = 0;
 		spin_lock_irq(&serial->serial_lock);
 		if (serial->tty == tty) {
 			serial->tty->driver_data = NULL;
@@ -1446,7 +1446,7 @@ static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 	/* the actual setup */
 	spin_lock_irqsave(&serial->serial_lock, flags);
-	if (serial->open_count)
+	if (serial->port.count)
 		_hso_serial_set_termios(tty, old);
 	else
 		tty->termios = old;
@@ -1905,7 +1905,7 @@ static void intr_callback(struct urb *urb)
 				D1("Pending read interrupt on port %d\n", i);
 				spin_lock(&serial->serial_lock);
 				if (serial->rx_state == RX_IDLE &&
-					serial->open_count > 0) {
+					serial->port.count > 0) {
 					/* Setup and send a ctrl req read on
 					 * port i */
 					if (!serial->rx_urb_filled[0]) {
@@ -2320,6 +2320,7 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 	serial->minor = minor;
 	serial->magic = HSO_SERIAL_MAGIC;
 	spin_lock_init(&serial->serial_lock);
+	tty_port_init(&serial->port);
 	serial->num_rx_urbs = num_urbs;
 
 	/* RX, allocate urb and initialize */
@@ -3098,7 +3099,7 @@ static int hso_resume(struct usb_interface *iface)
 	/* Start all serial ports */
 	for (i = 0; i < HSO_SERIAL_TTY_MINORS; i++) {
 		if (serial_table[i] && (serial_table[i]->interface == iface)) {
-			if (dev2ser(serial_table[i])->open_count) {
+			if (dev2ser(serial_table[i])->port.count) {
 				result =
 				    hso_start_serial_device(serial_table[i], GFP_NOIO);
 				hso_kick_transmit(dev2ser(serial_table[i]));
-- 
1.7.9.2



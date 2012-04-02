Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2DBLzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:43 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48042 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jan Dumon <j.dumon@option.com>
Subject: [PATCH 22/69] TTY: hso, remove tty NULL checks fro tty->ops
Date: Mon,  2 Apr 2012 13:54:06 +0200
Message-Id: <1333367693-3244-23-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty is never NULL in tty->ops->* while the device is open. (And they
are not called otherwise.) So remove pointless checks and use
tty->driver_data directly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Dumon <j.dumon@option.com>
---
 drivers/net/usb/hso.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 0b26d75..ec782c7 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -106,13 +106,6 @@
 
 #define MAX_RX_URBS			2
 
-static inline struct hso_serial *get_serial_by_tty(struct tty_struct *tty)
-{
-	if (tty)
-		return tty->driver_data;
-	return NULL;
-}
-
 /*****************************************************************************/
 /* Debugging functions                                                       */
 /*****************************************************************************/
@@ -1114,7 +1107,7 @@ static void hso_init_termios(struct ktermios *termios)
 static void _hso_serial_set_termios(struct tty_struct *tty,
 				    struct ktermios *old)
 {
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	struct ktermios *termios;
 
 	if (!serial) {
@@ -1268,7 +1261,7 @@ static void hso_unthrottle_tasklet(struct hso_serial *serial)
 
 static	void hso_unthrottle(struct tty_struct *tty)
 {
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 
 	tasklet_hi_schedule(&serial->unthrottle_tasklet);
 }
@@ -1390,7 +1383,7 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 static int hso_serial_write(struct tty_struct *tty, const unsigned char *buf,
 			    int count)
 {
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	int space, tx_bytes;
 	unsigned long flags;
 
@@ -1422,7 +1415,7 @@ out:
 /* how much room is there for writing */
 static int hso_serial_write_room(struct tty_struct *tty)
 {
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	int room;
 	unsigned long flags;
 
@@ -1437,7 +1430,7 @@ static int hso_serial_write_room(struct tty_struct *tty)
 /* setup the term */
 static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	unsigned long flags;
 
 	if (old)
@@ -1458,7 +1451,7 @@ static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 /* how many characters in the buffer */
 static int hso_serial_chars_in_buffer(struct tty_struct *tty)
 {
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	int chars;
 	unsigned long flags;
 
@@ -1629,7 +1622,7 @@ static int hso_get_count(struct tty_struct *tty,
 		  struct serial_icounter_struct *icount)
 {
 	struct uart_icount cnow;
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	struct hso_tiocmget  *tiocmget = serial->tiocmget;
 
 	memset(icount, 0, sizeof(struct serial_icounter_struct));
@@ -1659,7 +1652,7 @@ static int hso_get_count(struct tty_struct *tty,
 static int hso_serial_tiocmget(struct tty_struct *tty)
 {
 	int retval;
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	struct hso_tiocmget  *tiocmget;
 	u16 UART_state_bitmap;
 
@@ -1693,7 +1686,7 @@ static int hso_serial_tiocmset(struct tty_struct *tty,
 	int val = 0;
 	unsigned long flags;
 	int if_num;
-	struct hso_serial *serial = get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 
 	/* sanity check */
 	if (!serial) {
@@ -1733,7 +1726,7 @@ static int hso_serial_tiocmset(struct tty_struct *tty,
 static int hso_serial_ioctl(struct tty_struct *tty,
 			    unsigned int cmd, unsigned long arg)
 {
-	struct hso_serial *serial =  get_serial_by_tty(tty);
+	struct hso_serial *serial = tty->driver_data;
 	int ret = 0;
 	D4("IOCTL cmd: %d, arg: %ld", cmd, arg);
 
-- 
1.7.9.2



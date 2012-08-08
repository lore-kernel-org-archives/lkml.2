Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2HHPKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:10:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37520 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2HHPKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:10:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND #2 1/3] serqt_usb2: drag screaming into the 21st century
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 16:27:55 +0100
Message-ID: <20120808152735.8280.54767.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fix the termios stuff but while we are at it do something about the rest of
it

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/serqt_usb2/serqt_usb2.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 8a362f7..c90de96 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -315,10 +315,8 @@ static void qt_read_bulk_callback(struct urb *urb)
 	}
 
 	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dbg("%s - bad tty pointer - exiting", __func__);
+	if (!tty)
 		return;
-	}
 
 	data = urb->transfer_buffer;
 
@@ -364,7 +362,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 		goto exit;
 	}
 
-	if (tty && RxCount) {
+	if (RxCount) {
 		flag_data = 0;
 		for (i = 0; i < RxCount; ++i) {
 			/* Look ahead code here */
@@ -428,7 +426,7 @@ static void qt_read_bulk_callback(struct urb *urb)
 		dbg("%s - failed resubmitting read urb, error %d",
 		    __func__, result);
 	else {
-		if (tty && RxCount) {
+		if (RxCount) {
 			tty_flip_buffer_push(tty);
 			tty_schedule_flip(tty);
 		}
@@ -897,8 +895,6 @@ static int qt_open(struct tty_struct *tty,
 	 * Put this here to make it responsive to stty and defaults set by
 	 * the tty layer
 	 */
-	/* FIXME: is this needed? */
-	/* qt_set_termios(tty, port, NULL); */
 
 	/*  Check to see if we've set up our endpoint info yet */
 	if (port0->open_ports == 1) {
@@ -1195,7 +1191,7 @@ static void qt_set_termios(struct tty_struct *tty,
 			   struct usb_serial_port *port,
 			   struct ktermios *old_termios)
 {
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	unsigned char new_LCR = 0;
 	unsigned int cflag = termios->c_cflag;
 	unsigned int index;
@@ -1204,7 +1200,7 @@ static void qt_set_termios(struct tty_struct *tty,
 
 	index = tty->index - port->serial->minor;
 
-	switch (cflag) {
+	switch (cflag & CSIZE) {
 	case CS5:
 		new_LCR |= SERIAL_5_DATA;
 		break;
@@ -1215,6 +1211,8 @@ static void qt_set_termios(struct tty_struct *tty,
 		new_LCR |= SERIAL_7_DATA;
 		break;
 	default:
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 	case CS8:
 		new_LCR |= SERIAL_8_DATA;
 		break;
@@ -1301,7 +1299,7 @@ static void qt_set_termios(struct tty_struct *tty,
 			dbg(__FILE__ "BoxSetSW_FlowCtrl (diabling) failed\n");
 
 	}
-	tty->termios->c_cflag &= ~CMSPAR;
+	termios->c_cflag &= ~CMSPAR;
 	/* FIXME: Error cases should be returning the actual bits changed only */
 }
 


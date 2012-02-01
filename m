Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2BAVdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:33:35 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54507 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284Ab2BAVS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:18:59 -0500
X-Sasl-enc: x+l+WQpXcwc9yo094kFCASeQFF1vH8GP9tx5Lkt65Wbt 1328131138
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.851215154@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Ramthun <mail@roland-ramthun.de>,
        Johan Hovold <jhovold@gmail.com>
Subject: [27/65] USB: ftdi_sio: fix initial baud rate
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 108e02b12921078a59dcacd048079ece48a4a983 upstream.

Fix regression introduced by commit b1ffb4c851f1 ("USB: Fix Corruption
issue in USB ftdi driver ftdi_sio.c") which caused the termios settings
to no longer be initialised at open. Consequently it was no longer
possible to set the port to the default speed of 9600 baud without first
changing to another baud rate and back again.

Reported-by: Roland Ramthun <mail@roland-ramthun.de>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Tested-by: Roland Ramthun <mail@roland-ramthun.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1815,6 +1815,7 @@ static int ftdi_sio_port_remove(struct u
 
 static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
+	struct ktermios dummy;
 	struct usb_device *dev = port->serial->dev;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	int result;
@@ -1833,8 +1834,10 @@ static int ftdi_open(struct tty_struct *
 	   This is same behaviour as serial.c/rs_open() - Kuba */
 
 	/* ftdi_set_termios  will send usb control messages */
-	if (tty)
-		ftdi_set_termios(tty, port, tty->termios);
+	if (tty) {
+		memset(&dummy, 0, sizeof(dummy));
+		ftdi_set_termios(tty, port, &dummy);
+	}
 
 	/* Start reading from the device */
 	result = usb_serial_generic_open(tty, port);



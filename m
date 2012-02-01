Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab2BAVWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:22:35 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35453 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757551Ab2BAVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:42 -0500
X-Sasl-enc: 3XIy3kSg9HrMLqE4cYyaartMK/3i5svkOHDB9AAAOzI1 1328131181
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:51 2012
Message-Id: <20120201210051.439470864@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: [86/89] USB: cp210x: clean up, refactor and document speed handling
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e5990874e511d5bbca23b3396419480cb2ca0ee7 upstream.

Clean up and refactor speed handling.
Document baud rate handling for CP210{1,2,4,5,10}.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Preston Fick <preston.fick@silabs.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |   69 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -39,6 +39,8 @@ static void cp210x_get_termios(struct tt
 	struct usb_serial_port *port);
 static void cp210x_get_termios_port(struct usb_serial_port *port,
 	unsigned int *cflagp, unsigned int *baudp);
+static void cp210x_change_speed(struct tty_struct *, struct usb_serial_port *,
+							struct ktermios *);
 static void cp210x_set_termios(struct tty_struct *, struct usb_serial_port *,
 							struct ktermios*);
 static int cp210x_tiocmget(struct tty_struct *);
@@ -572,11 +574,62 @@ static void cp210x_get_termios_port(stru
 	*cflagp = cflag;
 }
 
+/*
+ * CP2101 supports the following baud rates:
+ *
+ *	300, 600, 1200, 1800, 2400, 4800, 7200, 9600, 14400, 19200, 28800,
+ *	38400, 56000, 57600, 115200, 128000, 230400, 460800, 921600
+ *
+ * CP2102 and CP2103 support the following additional rates:
+ *
+ *	4000, 16000, 51200, 64000, 76800, 153600, 250000, 256000, 500000,
+ *	576000
+ *
+ * The device will map a requested rate to a supported one, but the result
+ * of requests for rates greater than 1053257 is undefined (see AN205).
+ *
+ * CP2104, CP2105 and CP2110 support most rates up to 2M, 921k and 1M baud,
+ * respectively, with an error less than 1%. The actual rates are determined
+ * by
+ *
+ *	div = round(freq / (2 x prescale x request))
+ *	actual = freq / (2 x prescale x div)
+ *
+ * For CP2104 and CP2105 freq is 48Mhz and prescale is 4 for request <= 365bps
+ * or 1 otherwise.
+ * For CP2110 freq is 24Mhz and prescale is 4 for request <= 300bps or 1
+ * otherwise.
+ */
+static void cp210x_change_speed(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios)
+{
+	u32 baud;
+
+	baud = tty->termios->c_ospeed;
+
+	/* This maps the requested rate to a rate valid on cp2102 or cp2103.
+	 *
+	 * NOTE: B0 is not implemented.
+	 */
+	baud = cp210x_quantise_baudrate(baud);
+
+	dbg("%s - setting baud rate to %u", __func__, baud);
+	if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud,
+							sizeof(baud))) {
+		dev_warn(&port->dev, "failed to set baud rate to %u\n", baud);
+		if (old_termios)
+			baud = old_termios->c_ospeed;
+		else
+			baud = 9600;
+	}
+
+	tty_encode_baud_rate(tty, baud, baud);
+}
+
 static void cp210x_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag;
-	u32 baud;
 	unsigned int bits;
 	unsigned int modem_ctl[4];
 
@@ -588,19 +641,9 @@ static void cp210x_set_termios(struct tt
 	tty->termios->c_cflag &= ~CMSPAR;
 	cflag = tty->termios->c_cflag;
 	old_cflag = old_termios->c_cflag;
-	baud = cp210x_quantise_baudrate(tty_get_baud_rate(tty));
 
-	/* If the baud rate is to be updated*/
-	if (baud != tty_termios_baud_rate(old_termios) && baud != 0) {
-		dbg("%s - Setting baud rate to %d baud", __func__,
-				baud);
-		if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, sizeof(baud))) {
-			dbg("Baud rate requested not supported by device");
-			baud = tty_termios_baud_rate(old_termios);
-		}
-	}
-	/* Report back the resulting baud rate */
-	tty_encode_baud_rate(tty, baud, baud);
+	if (tty->termios->c_ospeed != old_termios->c_ospeed)
+		cp210x_change_speed(tty, port, old_termios);
 
 	/* If the number of data bits is to be updated */
 	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {



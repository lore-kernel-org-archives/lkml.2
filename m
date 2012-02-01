Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab2BAVng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:43:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40426 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab2BAVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:14 -0500
X-Sasl-enc: e0BSZukpgxkcPby6w2BBA8gVdI9C75ObVvdiN556pY+A 1328130552
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:42 2012
Message-Id: <20120201205742.733279122@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Preston Fick <preston.fick@silabs.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [60/65] USB: cp210x: fix CP2104 baudrate usage
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Preston Fick <preston.fick@silabs.com>

commit 7f482fc88ac47662228d6b1f05759797c8936a30 upstream.

This fix changes the way baudrates are set on the CP210x devices from
Silicon Labs. The CP2101/2/3 will respond to both a GET/SET_BAUDDIV
command, and GET/SET_BAUDRATE command, while CP2104 and higher devices
only respond to GET/SET_BAUDRATE. The current cp210x.ko driver in
kernel version 3.2.0 only implements the GET/SET_BAUDDIV command.

This patch implements the two new codes for the GET/SET_BAUDRATE
commands. Then there is a change in the way that the baudrate is
assigned or retrieved. This is done according to the CP210x USB
specification in AN571. This document can be found here:
http://www.silabs.com/pages/DownloadDoc.aspx?FILEURL=Support%20Documents/TechnicalDocs/AN571.pdf&src=DocumentationWebPart

Sections 5.3/5.4 describe the USB packets for the old baudrate method.
Sections 5.5/5.6 describe the USB packets for the new method. This
patch also implements the new request scheme, and eliminates the
unnecessary baudrate calculations since it uses the "actual baudrate"
method.

This patch solves the problem reported for the CP2104 in bug 42586,
and also keeps support for all other devices (CP2101/2/3).

This patchfile is also attached to the bug report on
bugzilla.kernel.org. This patch has been developed and test on the
3.2.0 mainline kernel version under Ubuntu 10.11.

Signed-off-by: Preston Fick <preston.fick@silabs.com>
[duplicate patch also sent by Johan - gregkh]
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -202,6 +202,8 @@ static struct usb_serial_driver cp210x_d
 #define CP210X_EMBED_EVENTS	0x15
 #define CP210X_GET_EVENTSTATE	0x16
 #define CP210X_SET_CHARS	0x19
+#define CP210X_GET_BAUDRATE	0x1D
+#define CP210X_SET_BAUDRATE	0x1E
 
 /* CP210X_IFC_ENABLE */
 #define UART_ENABLE		0x0001
@@ -456,10 +458,7 @@ static void cp210x_get_termios_port(stru
 
 	dbg("%s - port %d", __func__, port->number);
 
-	cp210x_get_config(port, CP210X_GET_BAUDDIV, &baud, 2);
-	/* Convert to baudrate */
-	if (baud)
-		baud = cp210x_quantise_baudrate((BAUD_RATE_GEN_FREQ + baud/2)/ baud);
+	cp210x_get_config(port, CP210X_GET_BAUDRATE, &baud, 4);
 
 	dbg("%s - baud rate = %d", __func__, baud);
 	*baudp = baud;
@@ -594,8 +593,7 @@ static void cp210x_set_termios(struct tt
 	if (baud != tty_termios_baud_rate(old_termios) && baud != 0) {
 		dbg("%s - Setting baud rate to %d baud", __func__,
 				baud);
-		if (cp210x_set_config_single(port, CP210X_SET_BAUDDIV,
-					((BAUD_RATE_GEN_FREQ + baud/2) / baud))) {
+		if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, 4)) {
 			dbg("Baud rate requested not supported by device");
 			baud = tty_termios_baud_rate(old_termios);
 		}



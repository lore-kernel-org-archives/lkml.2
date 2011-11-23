Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1KWAg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:36:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab1KWAgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:36:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:56 2011
Message-Id: <20111123002556.755840884@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrew Worsley <amworsley@gmail.com>
Subject: [41/53] USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Worsley <amworsley@gmail.com>

commit b1ffb4c851f185e9051ba837c16d9b84ef688d26 upstream.

Fix for ftdi_set_termios() glitching output

ftdi_set_termios() is constantly setting the baud rate, data bits and parity
unnecessarily on every call, . When called while characters are being
transmitted can cause the FTDI chip to corrupt the serial port bit stream
output by stalling the output half a bit during the output of a character.
Simple fix by skipping this setting if the baud rate/data bits/parity are
unchanged.

Signed-off-by: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2083,13 +2083,19 @@ static void ftdi_set_termios(struct tty_
 
 	cflag = termios->c_cflag;
 
-	/* FIXME -For this cut I don't care if the line is really changing or
-	   not  - so just do the change regardless  - should be able to
-	   compare old_termios and tty->termios */
+	if (old_termios->c_cflag == termios->c_cflag
+	    && old_termios->c_ispeed == termios->c_ispeed
+	    && old_termios->c_ospeed == termios->c_ospeed)
+		goto no_c_cflag_changes;
+
 	/* NOTE These routines can get interrupted by
 	   ftdi_sio_read_bulk_callback  - need to examine what this means -
 	   don't see any problems yet */
 
+	if ((old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
+	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
+		goto no_data_parity_stop_changes;
+
 	/* Set number of data bits, parity, stop bits */
 
 	urb_value = 0;
@@ -2130,6 +2136,7 @@ static void ftdi_set_termios(struct tty_
 	}
 
 	/* Now do the baudrate */
+no_data_parity_stop_changes:
 	if ((cflag & CBAUD) == B0) {
 		/* Disable flow control */
 		if (usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
@@ -2157,6 +2164,7 @@ static void ftdi_set_termios(struct tty_
 
 	/* Set flow control */
 	/* Note device also supports DTR/CD (ugh) and Xon/Xoff in hardware */
+no_c_cflag_changes:
 	if (cflag & CRTSCTS) {
 		dbg("%s Setting to CRTSCTS flow control", __func__);
 		if (usb_control_msg(dev,



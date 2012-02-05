Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2BEWlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:41:09 -0500
Received: from 1wt.eu ([62.212.114.60]:61978 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab2BEW0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:36 -0500
Message-Id: <20120205220951.887731371@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Worsley <amworsley@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 57/91] USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 11 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/usb/serial/ftdi_sio.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/serial/ftdi_sio.c	2012-02-05 22:34:33.270914634 +0100
+++ longterm-2.6.27/drivers/usb/serial/ftdi_sio.c	2012-02-05 22:34:42.983916543 +0100
@@ -2109,13 +2109,19 @@
 
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
 
 	termios->c_cflag &= ~CMSPAR;
@@ -2151,6 +2157,7 @@
 	}
 
 	/* Now do the baudrate */
+no_data_parity_stop_changes:
 	if ((cflag & CBAUD) == B0) {
 		/* Disable flow control */
 		if (usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
@@ -2173,6 +2180,7 @@
 
 	/* Set flow control */
 	/* Note device also supports DTR/CD (ugh) and Xon/Xoff in hardware */
+no_c_cflag_changes:
 	if (cflag & CRTSCTS) {
 		dbg("%s Setting to CRTSCTS flow control", __func__);
 		if (usb_control_msg(dev,



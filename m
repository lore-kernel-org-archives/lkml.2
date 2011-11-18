Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1KRMNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:13:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32768 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1KRMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:13:40 -0500
Message-Id: <E1RRNK1-00024U-2n@compal>
To: Alan Cox <alan@linux.intel.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix Corruption issue in USB ftdi driver ftdi_sio.c
Date: Fri, 18 Nov 2011 23:13:33 +1100
From: Andrew Worsley <amworsley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for ftdi_set_termios() glitching output

ftdi_set_termios() is constantly setting the baud rate, data bits and parity
unnecessarily on every call, . When called while characters are being
transmitted can cause the FTDI chip to corrupt the serial port bit stream
output by stalling the output half a bit during the output of a character.
Simple fix by skipping this setting if the baud rate/data bits/parity are
unchanged.

Signed-off-by: Andrew Worsley <amworsley@gmail.com>
----

  I had a brief run with strace on the getty and it was doing ioctl()s on
  each call but it didn't look relavant to the problem. I think the issue is
  that XON/XOFF flow control was being implmented via hardware - for the ixoff
  to allow the user to use XON/XOFF to control output. Unfortunately it would
  send 3 Control URBs updating all of the settings after each piece of input

  I am trying to work around the issue of gmail messing with the tab/spacing
  by submitting via SMTP via gmail which I believe should fix the issue.

  The patch is against v3.2-rc2 and compiles - but no additional testing in
  this kernel has been done.

  Thanks

   Andrew

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8fe034d..bd4298b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2104,13 +2104,19 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
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
@@ -2151,6 +2157,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	}
 
 	/* Now do the baudrate */
+no_data_parity_stop_changes:
 	if ((cflag & CBAUD) == B0) {
 		/* Disable flow control */
 		if (usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
@@ -2178,6 +2185,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
 	/* Set flow control */
 	/* Note device also supports DTR/CD (ugh) and Xon/Xoff in hardware */
+no_c_cflag_changes:
 	if (cflag & CRTSCTS) {
 		dbg("%s Setting to CRTSCTS flow control", __func__);
 		if (usb_control_msg(dev,

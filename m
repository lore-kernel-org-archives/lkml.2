Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2HOTwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:34 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63099 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2HOTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Worsley <amworsley@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 137/165] USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c
Date: Wed, 15 Aug 2012 15:48:01 -0400
Message-ID: <1345060109-9187-138-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Worsley <amworsley@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b1ffb4c851f185e9051ba837c16d9b84ef688d26 upstream.

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

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 24dc63c..7367f4b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2332,13 +2332,19 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
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
@@ -2379,6 +2385,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	}
 
 	/* Now do the baudrate */
+no_data_parity_stop_changes:
 	if ((cflag & CBAUD) == B0) {
 		/* Disable flow control */
 		if (usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
@@ -2406,6 +2413,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
 	/* Set flow control */
 	/* Note device also supports DTR/CD (ugh) and Xon/Xoff in hardware */
+no_c_cflag_changes:
 	if (cflag & CRTSCTS) {
 		dbg("%s Setting to CRTSCTS flow control", __func__);
 		if (usb_control_msg(dev,
-- 
1.7.12.rc2


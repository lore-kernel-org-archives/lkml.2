Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LEHsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:48:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44512 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1LEHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:48:18 -0500
Date: Mon, 5 Dec 2011 15:47:30 +0800
From: wangyanqing <udknight@gmail.com>
To: gregkh@suse.de
Cc: amworsley@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers:usb:serial:ftdi_sio.c: ftdi_set_termios make no
 sense some in a situation
Message-ID: <20111205074730.GA10142@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>, gregkh@suse.de,
	amworsley@gmail.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b1ffb4c851f185e9051ba837c16d9b84ef688d26 make a improvement to drop no sense reset
termios. But it miss the situation, when call ftdi_set_termios with the value that
same with the default settings all the time, then termios will take no effect any way,
we need usb_control_msg to make effect. This patch try to resolve this question.

Signed-off-by: Wang YanQing <ukdnight@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 486769c..61f1be4 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2056,6 +2056,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	struct ktermios *termios = tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	__u16 urb_value; /* will hold the new flags */
+	static int init_once = 1;
 
 	/* Added for xon/xoff support */
 	unsigned int iflag = termios->c_iflag;
@@ -2082,7 +2083,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
 	if (old_termios->c_cflag == termios->c_cflag
 	    && old_termios->c_ispeed == termios->c_ispeed
-	    && old_termios->c_ospeed == termios->c_ospeed)
+	    && old_termios->c_ospeed == termios->c_ospeed
+	    && !init_once)
 		goto no_c_cflag_changes;
 
 	/* NOTE These routines can get interrupted by
@@ -2090,8 +2092,12 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	   don't see any problems yet */
 
 	if ((old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
-	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
+	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) &&
+	    !init_once) {
 		goto no_data_parity_stop_changes;
+	} else {
+		init_once = 0;
+	}
 
 	/* Set number of data bits, parity, stop bits */
 
-- 
1.7.3.4


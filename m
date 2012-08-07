Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2HGTyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:54:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49822 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab2HGTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:54:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 02/41] TTY: 68328serial, fix compilation
Date: Tue,  7 Aug 2012 21:47:27 +0200
Message-Id: <1344368886-24033-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_struct->termios is no longer a pointer. This was changed recently
by "tty: move the termios object into the tty". But 68328serial was
not changed, so we now have a compilation error:
68328serial.c: In function 'change_speed':
68328serial.c:518:22: error: invalid type argument of '->' (have 'struct ktermios')
68328serial.c: In function 'rs_set_ldisc':
68328serial.c:620:31: error: invalid type argument of '->' (have 'struct ktermios')
68328serial.c: In function 'rs_set_termios':
68328serial.c:988:20: error: invalid type argument of '->' (have 'struct ktermios')

Fix that now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/68328serial.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 3ed20e4..cc4c092 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -515,7 +515,7 @@ static void change_speed(struct m68k_serial *info, struct tty_struct *tty)
 	unsigned cflag;
 	int	i;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 	if (!(port = info->port))
 		return;
 
@@ -617,7 +617,7 @@ static void rs_set_ldisc(struct tty_struct *tty)
 	if (serial_paranoia_check(info, tty->name, "rs_set_ldisc"))
 		return;
 
-	info->is_cons = (tty->termios->c_line == N_TTY);
+	info->is_cons = (tty->termios.c_line == N_TTY);
 	
 	printk("ttyS%d console mode %s\n", info->line, info->is_cons ? "on" : "off");
 }
@@ -985,7 +985,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	change_speed(info, tty);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		rs_start(tty);
 	}
@@ -1070,7 +1070,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		if (tty->ldisc.close)
 			(tty->ldisc.close)(tty);
 		tty->ldisc = ldiscs[N_TTY];
-		tty->termios->c_line = N_TTY;
+		tty->termios.c_line = N_TTY;
 		if (tty->ldisc.open)
 			(tty->ldisc.open)(tty);
 	}
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab0JZP4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:56:04 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:36854 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753774Ab0JZP4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:56:01 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 11:56:01 EDT
From: Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - STI - LSRO1
Subject: [PATCH] tty_ldisc: Fix BUG() on hangup
Date: Tue, 26 Oct 2010 17:49:03 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.13-desktop-1mnb; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010261749.03875.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

A kernel BUG when bluetooth rfcomm connection drop while 
the associated serial port is open is sometime triggered.

It seems that the line discipline can disappear between the tty_ldisc_put  and 
tty_ldisc_get. This patch fall back to the N_TTY line discipline if the 
previous discipline is not available anymore.

This seem to fix the BUG(), but I don't know if it's correct.

Regards,

Philippe

---

--- linux-2.6.34.x86_64/drivers/char/tty_ldisc.c.orig	2010-05-16 
23:17:36.000000000 +0200
+++ linux-2.6.34.x86_64/drivers/char/tty_ldisc.c	2010-10-15 10:48:01.871721197 
+0200
@@ -712,9 +712,12 @@ static void tty_reset_termios(struct tty
  *	state closed
  */
 
-static void tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
+static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 {
-	struct tty_ldisc *ld;
+	struct tty_ldisc *ld = tty_ldisc_get(ldisc);
+
+	if (IS_ERR(ld))
+		return -1;
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
@@ -722,10 +725,10 @@ static void tty_ldisc_reinit(struct tty_
 	/*
 	 *	Switch the line discipline back
 	 */
-	ld = tty_ldisc_get(ldisc);
-	BUG_ON(IS_ERR(ld));
 	tty_ldisc_assign(tty, ld);
 	tty_set_termios_ldisc(tty, ldisc);
+
+	return 0;
 }
 
 /**
@@ -787,13 +790,16 @@ void tty_ldisc_hangup(struct tty_struct 
 	   a FIXME */
 	if (tty->ldisc) {	/* Not yet closed */
 		if (reset == 0) {
-			tty_ldisc_reinit(tty, tty->termios->c_line);
-			err = tty_ldisc_open(tty, tty->ldisc);
+			
+			if (!tty_ldisc_reinit(tty, tty->termios->c_line))
+				err = tty_ldisc_open(tty, tty->ldisc);
+			else
+				err = 1;
 		}
 		/* If the re-open fails or we reset then go to N_TTY. The
 		   N_TTY open cannot fail */
 		if (reset || err) {
-			tty_ldisc_reinit(tty, N_TTY);
+			BUG_ON(tty_ldisc_reinit(tty, N_TTY));
 			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
 		}
 		tty_ldisc_enable(tty);

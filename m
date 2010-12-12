Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0LLXqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0LLXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: philippe.retornaz@epfl.ch, philippe.retornaz@epfl.ch,
        philippe.retornaz@epfl.ch, alan@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [95/223] tty_ldisc: Fix BUG() on hangup
Message-Id: <20101212234635.36C7AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>

commit 1c95ba1e1de7edffc0c4e275e147f1a9eb1f81ae upstream.

A kernel BUG when bluetooth rfcomm connection drop while the associated
serial port is open is sometime triggered.

It seems that the line discipline can disappear between the
tty_ldisc_put and tty_ldisc_get. This patch fall back to the N_TTY line
discipline if the previous discipline is not available anymore.

Signed-off-by: Philippe Retornaz <philippe.retornaz@epfl.ch>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/tty_ldisc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux/drivers/char/tty_ldisc.c
===================================================================
--- linux.orig/drivers/char/tty_ldisc.c
+++ linux/drivers/char/tty_ldisc.c
@@ -741,9 +741,12 @@ static void tty_reset_termios(struct tty
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
@@ -751,10 +754,10 @@ static void tty_ldisc_reinit(struct tty_
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
@@ -816,13 +819,16 @@ void tty_ldisc_hangup(struct tty_struct
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

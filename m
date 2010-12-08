Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0LHBBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:32 -0500
Received: from kroah.org ([198.145.64.141]:49014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab0LHBB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:29 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.086957862@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philippe Retornaz <philippe.retornaz@epfl.ch>,
        Alan Cox <alan@linux.intel.com>
Subject: [137/289] tty_ldisc: Fix BUG() on hangup
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/char/tty_ldisc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -743,9 +743,12 @@ static void tty_reset_termios(struct tty
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
@@ -753,10 +756,10 @@ static void tty_ldisc_reinit(struct tty_
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
@@ -831,13 +834,16 @@ void tty_ldisc_hangup(struct tty_struct
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



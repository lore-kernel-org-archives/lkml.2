Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab2EYK4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:56:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60006 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2EYK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:56:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: remove recursive implementation of tty_ldisc_release
To: levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 25 May 2012 12:11:54 +0100
Message-ID: <20120525111152.7239.99793.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We need to do this in one pass with the locking requirements we now
have.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_ldisc.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)


diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 833e851..ecfaef5 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -894,6 +894,23 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_ldisc_enable(tty);
 	return 0;
 }
+
+static int tty_ldisc_kill(struct tty_struct *tty)
+{
+	mutex_lock(&tty->ldisc_mutex);
+	/*
+	 * Now kill off the ldisc
+	 */
+	tty_ldisc_close(tty, tty->ldisc);
+	tty_ldisc_put(tty->ldisc);
+	/* Force an oops if we mess this up */
+	tty->ldisc = NULL;
+
+	/* Ensure the next open requests the N_TTY ldisc */
+	tty_set_termios_ldisc(tty, N_TTY);
+	mutex_unlock(&tty->ldisc_mutex);
+}
+
 /**
  *	tty_ldisc_release		-	release line discipline
  *	@tty: tty being shut down
@@ -912,30 +929,19 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
-	/* We don't give a monkeys' about the o_tty lock here but we
-	   must do both to avoid lock inversions against another single
-	   locking case */
 	tty_unlock_pair(tty, o_tty);
 	tty_ldisc_halt(tty);
 	tty_ldisc_flush_works(tty);
+	if (o_tty) {
+		tty_ldisc_halt(o_tty);
+		tty_ldisc_flush_works(o_tty);
+	}
 	tty_lock_pair(tty, o_tty);
 
-	mutex_lock(&tty->ldisc_mutex);
-	/*
-	 * Now kill off the ldisc
-	 */
-	tty_ldisc_close(tty, tty->ldisc);
-	tty_ldisc_put(tty->ldisc);
-	/* Force an oops if we mess this up */
-	tty->ldisc = NULL;
-
-	/* Ensure the next open requests the N_TTY ldisc */
-	tty_set_termios_ldisc(tty, N_TTY);
-	mutex_unlock(&tty->ldisc_mutex);
 
-	/* This will need doing differently if we need to lock */
+	tty_ldisc_kill(tty);
 	if (o_tty)
-		tty_ldisc_release(o_tty, NULL);
+		tty_ldisc_kill(o_tty);
 
 	/* And the memory resources remaining (buffers, termios) will be
 	   disposed of when the kref hits zero */


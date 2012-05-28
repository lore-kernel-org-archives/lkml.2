Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2E1Jd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:33:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34538 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2E1Jd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:33:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] tty: fix ldisc lock inversion trace
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 28 May 2012 10:49:32 +0100
Message-ID: <20120528094921.3001.25918.stgit@bob.linux.org.uk>
In-Reply-To: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
References: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is caused by tty_release using tty_lock_pair to lock both
sides of the pty/tty pair, and then tty_ldisc_release dropping
and relocking one side only. We can drop both fine, so drop both
to avoid any lock ordering concerns.

Rework the release path to fix the new locking model.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_ldisc.c |   41 +++++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 16 deletions(-)


diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 173a900..ba8be39 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -894,6 +894,23 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_ldisc_enable(tty);
 	return 0;
 }
+
+static void tty_ldisc_kill(struct tty_struct *tty)
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
@@ -912,27 +929,19 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
-	tty_unlock(tty);
+	tty_unlock_pair(tty, o_tty);
 	tty_ldisc_halt(tty);
 	tty_ldisc_flush_works(tty);
-	tty_lock(tty);
-
-	mutex_lock(&tty->ldisc_mutex);
-	/*
-	 * Now kill off the ldisc
-	 */
-	tty_ldisc_close(tty, tty->ldisc);
-	tty_ldisc_put(tty->ldisc);
-	/* Force an oops if we mess this up */
-	tty->ldisc = NULL;
+	if (o_tty) {
+		tty_ldisc_halt(o_tty);
+		tty_ldisc_flush_works(o_tty);
+	}
+	tty_lock_pair(tty, o_tty);
 
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


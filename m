Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab1DNS1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:27:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:38134 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab1DNRq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 054/209] tty_ldisc: Fix BUG() on hangup
Date: Thu, 14 Apr 2011 13:41:24 -0400
Message-Id: <1302803039-9400-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Rétornaz <philippe.retornaz@epfl.ch>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 1c95ba1e1de7edffc0c4e275e147f1a9eb1f81ae upstream.

A kernel BUG when bluetooth rfcomm connection drop while the associated
serial port is open is sometime triggered.

It seems that the line discipline can disappear between the
tty_ldisc_put and tty_ldisc_get. This patch fall back to the N_TTY line
discipline if the previous discipline is not available anymore.

Signed-off-by: Philippe Retornaz <philippe.retornaz@epfl.ch>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tty_ldisc.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index df5e7db..7af1a15 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -741,9 +741,12 @@ static void tty_reset_termios(struct tty_struct *tty)
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
@@ -751,10 +754,10 @@ static void tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
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
@@ -816,13 +819,16 @@ void tty_ldisc_hangup(struct tty_struct *tty)
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
-- 
1.7.4.4


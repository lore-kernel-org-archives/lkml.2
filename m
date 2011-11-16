Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1KPP1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:27:17 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:52982 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1KPP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:27:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Subject: [PATCH 1/5] TTY: ldisc, allow waiting for ldisc arbitrarily long
Date: Wed, 16 Nov 2011 16:27:07 +0100
Message-Id: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix a nasty bug in ldisc hup vs. reinit we need to wait infinitely
long for ldisc to be gone. So here we add a parameter to
tty_ldisc_wait_idle to allow that.

This is only a preparation for the real fix which is done in the
following patches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitriy Matrosov <sgf.dma@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: stable <stable@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
1-3 in this series are about the bug I mentioned at the summit.
4-5 are not critical at all.

 drivers/tty/tty_ldisc.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 512c49f..534d176 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -547,15 +547,16 @@ static void tty_ldisc_flush_works(struct tty_struct *tty)
 /**
  *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
  *	@tty: tty to wait for
+ *	@timeout: for how long to wait at most
  *
  *	Wait for the line discipline to become idle. The discipline must
  *	have been halted for this to guarantee it remains idle.
  */
-static int tty_ldisc_wait_idle(struct tty_struct *tty)
+static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 {
-	int ret;
+	long ret;
 	ret = wait_event_timeout(tty_ldisc_idle,
-			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
+			atomic_read(&tty->ldisc->users) == 1, timeout);
 	if (ret < 0)
 		return ret;
 	return ret > 0 ? 0 : -EBUSY;
@@ -665,7 +666,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_ldisc_flush_works(tty);
 
-	retval = tty_ldisc_wait_idle(tty);
+	retval = tty_ldisc_wait_idle(tty, 5 * HZ);
 
 	tty_lock();
 	mutex_lock(&tty->ldisc_mutex);
@@ -762,7 +763,7 @@ static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(ld))
 		return -1;
 
-	WARN_ON_ONCE(tty_ldisc_wait_idle(tty));
+	WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
-- 
1.7.7.3



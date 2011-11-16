Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1KPP11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:27:27 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:52991 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KPP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:27:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Subject: [PATCH 2/5] TTY: ldisc, move wait idle to caller
Date: Wed, 16 Nov 2011 16:27:08 +0100
Message-Id: <1321457231-9154-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the only place where reinit is called from. And we really need
to wait for the old ldisc to go once. Actually this is the place where
the waiting originally was (before removed and re-added later).

This will make the fix in the following patch easier to implement.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitriy Matrosov <sgf.dma@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: stable <stable@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_ldisc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 534d176..a69a755 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -763,8 +763,6 @@ static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(ld))
 		return -1;
 
-	WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
-
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
 	tty->ldisc = NULL;
@@ -848,6 +846,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	   it means auditing a lot of other paths so this is
 	   a FIXME */
 	if (tty->ldisc) {	/* Not yet closed */
+		WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
+
 		if (reset == 0) {
 
 			if (!tty_ldisc_reinit(tty, tty->termios->c_line))
-- 
1.7.7.3



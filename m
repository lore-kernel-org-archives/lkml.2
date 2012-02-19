Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2BSVTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:19:14 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:56370 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab2BSVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:19:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        jirislaby@gmail.com
Subject: [PATCH 1/1] TTY: fix PTY hangup vs close race
Date: Sun, 19 Feb 2012 22:19:06 +0100
Message-Id: <1329686346-16752-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329683796.10124.21.camel@lappy>
References: <1329683796.10124.21.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d3bda5298 (TTY: get rid of BTM around devpts_*) moved
devpts_pty_kill out of BTM, but the BTM was not protecting only
devpts_pty_kill, but also tty->link. Hence move the function back at
this late stage until this gets resolved properly some time later.

I was confused by tty_vhangup(tty->link) outside BTM. But inside of
tty_vhangup, there is a check for tty == NULL. But we cannot add such
a check here. We have to have the tty and free the devpts node...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
---

Gee, I messed up Greg's address again...

 drivers/tty/pty.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index fa1bd2e..95037aa 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -54,8 +54,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	wake_up_interruptible(&tty->link->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
-		tty_unlock();
+		/* BTM protects tty->link here */
 		devpts_pty_kill(tty->link);
+		tty_unlock();
 		tty_vhangup(tty->link);
 		tty_lock();
 	}
-- 
1.7.9



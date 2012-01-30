Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2A3UUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:20:41 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:39603 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2A3UUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:20:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, jirislaby@gmail.com
Subject: [PATCH 4/5] TTY: pty, remove superfluous ptm test
Date: Mon, 30 Jan 2012 21:14:31 +0100
Message-Id: <1327954472-26594-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code looks like:
if (tty->driver->subtype == PTY_TYPE_MASTER) {
  ...
  if (tty->driver == ptm_driver)

But the second if is superfluous because only the ptm_driver is of
PTY_TYPE_MASTER subtype.

Also we can remove the #if now because devpts_pty_kill is defined as
an empty function for non-CONFIG_UNIX98_PTYS configs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d505837..ddec9f3 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -54,10 +54,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	wake_up_interruptible(&tty->link->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
-#ifdef CONFIG_UNIX98_PTYS
-		if (tty->driver == ptm_driver)
-			devpts_pty_kill(tty->link);
-#endif
+		devpts_pty_kill(tty->link);
 		tty_unlock();
 		tty_vhangup(tty->link);
 		tty_lock();
-- 
1.7.8.3



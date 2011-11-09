Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1KIUdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:33 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37361 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1KIUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/7] TTY: move pgrp killing
Date: Wed,  9 Nov 2011 21:33:18 +0100
Message-Id: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it to the only branch where tty_pgrp may be set. This is only a
cleanup which allows having tty_pgrp defined at that place.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/tty_io.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 05085be..391cec3 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -790,19 +790,24 @@ static void session_clear_tty(struct pid *session)
 void disassociate_ctty(int on_exit)
 {
 	struct tty_struct *tty;
-	struct pid *tty_pgrp = NULL;
 
 	if (!current->signal->leader)
 		return;
 
 	tty = get_current_tty();
 	if (tty) {
-		tty_pgrp = get_pid(tty->pgrp);
+		struct pid *tty_pgrp = get_pid(tty->pgrp);
 		if (on_exit) {
 			if (tty->driver->type != TTY_DRIVER_TYPE_PTY)
 				tty_vhangup(tty);
 		}
 		tty_kref_put(tty);
+		if (tty_pgrp) {
+			kill_pgrp(tty_pgrp, SIGHUP, on_exit);
+			if (!on_exit)
+				kill_pgrp(tty_pgrp, SIGCONT, on_exit);
+			put_pid(tty_pgrp);
+		}
 	} else if (on_exit) {
 		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
@@ -816,12 +821,6 @@ void disassociate_ctty(int on_exit)
 		}
 		return;
 	}
-	if (tty_pgrp) {
-		kill_pgrp(tty_pgrp, SIGHUP, on_exit);
-		if (!on_exit)
-			kill_pgrp(tty_pgrp, SIGCONT, on_exit);
-		put_pid(tty_pgrp);
-	}
 
 	spin_lock_irq(&current->sighand->siglock);
 	put_pid(current->signal->tty_old_pgrp);
-- 
1.7.7



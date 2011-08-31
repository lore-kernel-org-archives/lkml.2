Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1HaTZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:25:10 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:42892 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HaTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:25:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: [PATCH 1/4] TTY: serial, fix locking imbalance
Date: Wed, 31 Aug 2011 21:24:56 +0200
Message-Id: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "TTY: serial, move locking in uart_close" moved the lock, but
omitted to update branches which unlock the lock. Now they try to
unlock the lock without holding it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
If possible, please, merge this into the patch mentioned above (it's
not upstream yet).

 drivers/tty/serial/serial_core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 5c04cb9..c0fdbc5 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1262,7 +1262,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	if (tty_hung_up_p(filp)) {
 		spin_unlock_irqrestore(&port->lock, flags);
-		goto done;
+		return;
 	}
 
 	if ((tty->count == 1) && (port->count != 1)) {
@@ -1284,7 +1284,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	}
 	if (port->count) {
 		spin_unlock_irqrestore(&port->lock, flags);
-		goto done;
+		return;
 	}
 
 	/*
@@ -1347,7 +1347,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->close_wait);
 
-done:
 	mutex_unlock(&port->mutex);
 }
 
-- 
1.7.6.1



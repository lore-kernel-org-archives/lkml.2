Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2FDLka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:30 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44992 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 16/24] PTY: add tty_port
Date: Mon,  4 Jun 2012 13:35:30 +0200
Message-Id: <1338809738-18967-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has *no* function in the PTY driver yet. However as the tty
buffers will move to the tty_port structure, we will need tty_port for
all TTYs in the system, PTY inclusive.

For PTYs this is ensured by allocating 2 tty_port's in pty_install,
i.e. where the tty->link is allocated. Both tty_port's are properly
assigned to each end of the tty.

Freeing is done at the same place where tty is freed, i.e. in
tty->ops->cleanup.

This means BTW that tty_port does not outlive TTY in PTY. This might
be a subject to change in the future if we see some problems.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 881888f..b50fc1c 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -286,12 +286,15 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 		bool legacy)
 {
 	struct tty_struct *o_tty;
+	struct tty_port *ports[2];
 	int idx = tty->index;
 	int retval = -ENOMEM;
 
 	o_tty = alloc_tty_struct();
-	if (!o_tty)
-		goto err;
+	ports[0] = kmalloc(sizeof **ports, GFP_KERNEL);
+	ports[1] = kmalloc(sizeof **ports, GFP_KERNEL);
+	if (!o_tty || !ports[0] || !ports[1])
+		goto err_free_tty;
 	if (!try_module_get(driver->other->owner)) {
 		/* This cannot in fact currently happen */
 		goto err_free_tty;
@@ -335,6 +338,10 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	/* Establish the links in both directions */
 	tty->link   = o_tty;
 	o_tty->link = tty;
+	tty_port_init(ports[0]);
+	tty_port_init(ports[1]);
+	o_tty->port = ports[0];
+	tty->port = ports[1];
 
 	tty_driver_kref_get(driver);
 	tty->count++;
@@ -348,11 +355,17 @@ err_deinit_tty:
 	deinitialize_tty_struct(o_tty);
 	module_put(o_tty->driver->owner);
 err_free_tty:
+	kfree(ports[0]);
+	kfree(ports[1]);
 	free_tty_struct(o_tty);
-err:
 	return retval;
 }
 
+static void pty_cleanup(struct tty_struct *tty)
+{
+	kfree(tty->port);
+}
+
 /* Traditional BSD devices */
 #ifdef CONFIG_LEGACY_PTYS
 
@@ -391,6 +404,7 @@ static const struct tty_operations master_pty_ops_bsd = {
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
 	.ioctl = pty_bsd_ioctl,
+	.cleanup = pty_cleanup,
 	.resize = pty_resize
 };
 
@@ -404,6 +418,7 @@ static const struct tty_operations slave_pty_ops_bsd = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
+	.cleanup = pty_cleanup,
 	.resize = pty_resize
 };
 
@@ -555,6 +570,7 @@ static const struct tty_operations ptm_unix98_ops = {
 	.set_termios = pty_set_termios,
 	.ioctl = pty_unix98_ioctl,
 	.shutdown = pty_unix98_shutdown,
+	.cleanup = pty_cleanup,
 	.resize = pty_resize
 };
 
@@ -570,7 +586,8 @@ static const struct tty_operations pty_unix98_ops = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
-	.shutdown = pty_unix98_shutdown
+	.shutdown = pty_unix98_shutdown,
+	.cleanup = pty_cleanup,
 };
 
 /**
-- 
1.7.10.3



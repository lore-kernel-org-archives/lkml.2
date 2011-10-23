Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1JWVBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:01:14 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45134 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1JWVBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:01:13 -0400
Message-ID: <4EA48094.8020508@ilyx.ru>
Date: Mon, 24 Oct 2011 01:01:08 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, ilya@ilyx.ru
Subject: [PATCH] TTY: pty, fix pty counting
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version for commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24

diff -uprN a/drivers/tty/pty.c b/drivers/tty/pty.c
--- a/drivers/tty/pty.c	2011-05-19 08:06:34.000000000 +0400
+++ b/drivers/tty/pty.c	2011-10-23 18:01:20.000000000 +0400
@@ -36,13 +36,15 @@
 static struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
 #endif
+static int pty_count;
 
 static void pty_close(struct tty_struct *tty, struct file *filp)
 {
 	BUG_ON(!tty);
-	if (tty->driver->subtype == PTY_TYPE_MASTER)
+	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		WARN_ON(tty->count > 1);
-	else {
+		pty_count--;
+	} else {
 		if (tty->count > 2)
 			return;
 	}
@@ -446,7 +448,6 @@ static inline void legacy_pty_init(void)
 int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
-static int pty_count;
 
 static struct cdev ptmx_cdev;
 
@@ -599,15 +600,9 @@ free_mem_out:
 	return -ENOMEM;
 }
 
-static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
-{
-	pty_count--;
-}
-
 static const struct tty_operations ptm_unix98_ops = {
 	.lookup = ptm_unix98_lookup,
 	.install = pty_unix98_install,
-	.remove = pty_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -624,7 +619,6 @@ static const struct tty_operations ptm_u
 static const struct tty_operations pty_unix98_ops = {
 	.lookup = pts_unix98_lookup,
 	.install = pty_unix98_install,
-	.remove = pty_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,

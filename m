Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1J0Jsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:48:38 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:44461 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab1J0Jsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:48:37 -0400
Message-ID: <4EA928F3.7010204@ilyx.ru>
Date: Thu, 27 Oct 2011 13:48:35 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] TTY: pty, fix pty counting in "/proc/sys/kernel/pty/nr"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression for commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24
Commit: 24d406a6b accepted in Linux 3.1.
Disscussed on linux-kernel@vger.kernel.org "subject: [PATCH] TTY: pty, fix pty counting"
and not accepted.
Although, I think it's clear.

diff -uprN -X ../../dontdiff a/drivers/tty/pty.c b/drivers/tty/pty.c
--- a/drivers/tty/pty.c	2011-05-19 08:06:34.000000000 +0400
+++ b/drivers/tty/pty.c	2011-10-24 23:59:23.000000000 +0400
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
Signed-off-by: Ilya Zykov <ilya@ilyx.ru>

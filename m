Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab2EEDFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882Ab2EEDFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:05:16 -0400
Date: Fri, 4 May 2012 23:04:40 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jiri Slaby <jslaby@suse.cz>, Guy Martin <gmsof@tuxicoman.be>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25
In-Reply-To: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1205042259000.18896@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch reverts commit 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25.

The commit 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25 causes system lockup 
when pdc is used as a boot console.

The kernel boots, but it locks up when transferring control to userspace 
--- the message "INIT: version 2.86 booting" is not printed and the 
computer halts. With the patch reverted, the system starts normally on 
pdc.

Mikulas

---

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 4f00459..d14e20f 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -92,11 +92,10 @@ static int pdc_console_setup(struct console *co, char *options)
 
 static void pdc_console_poll(unsigned long unused);
 static DEFINE_TIMER(pdc_console_timer, pdc_console_poll, 0, 0);
-static struct tty_port tty_port;
 
 static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 {
-	tty_port_tty_set(&tty_port, tty);
+
 	mod_timer(&pdc_console_timer, jiffies + PDC_CONS_POLL_DELAY);
 
 	return 0;
@@ -104,10 +103,8 @@ static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 
 static void pdc_console_tty_close(struct tty_struct *tty, struct file *filp)
 {
-	if (!tty->count) {
+	if (!tty->count)
 		del_timer_sync(&pdc_console_timer);
-		tty_port_tty_set(&tty_port, NULL);
-	}
 }
 
 static int pdc_console_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
@@ -126,6 +123,8 @@ static int pdc_console_tty_chars_in_buffer(struct tty_struct *tty)
 	return 0; /* no buffer */
 }
 
+static struct tty_driver *pdc_console_tty_driver;
+
 static const struct tty_operations pdc_console_tty_ops = {
 	.open = pdc_console_tty_open,
 	.close = pdc_console_tty_close,
@@ -136,8 +135,10 @@ static const struct tty_operations pdc_console_tty_ops = {
 
 static void pdc_console_poll(unsigned long unused)
 {
+
 	int data, count = 0;
-	struct tty_struct *tty = tty_port_tty_get(&tty_port);
+
+	struct tty_struct *tty = pdc_console_tty_driver->ttys[0];
 
 	if (!tty)
 		return;
@@ -153,14 +154,10 @@ static void pdc_console_poll(unsigned long unused)
 	if (count)
 		tty_flip_buffer_push(tty);
 
-	tty_kref_put(tty);
-
 	if (pdc_cons.flags & CON_ENABLED)
 		mod_timer(&pdc_console_timer, jiffies + PDC_CONS_POLL_DELAY);
 }
 
-static struct tty_driver *pdc_console_tty_driver;
-
 static int __init pdc_console_tty_driver_init(void)
 {
 	int err;
@@ -185,8 +182,6 @@ static int __init pdc_console_tty_driver_init(void)
 	printk(KERN_INFO "The PDC console driver is still registered, removing CON_BOOT flag\n");
 	pdc_cons.flags &= ~CON_BOOT;
 
-	tty_port_init(&tty_port);
-
 	pdc_console_tty_driver = alloc_tty_driver(1);
 
 	if (!pdc_console_tty_driver)


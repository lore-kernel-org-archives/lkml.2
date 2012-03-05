Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976Ab2CEOCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:02:15 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34765 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2CENxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 66/68] TTY: pdc_cons, use tty_port
Date: Mon,  5 Mar 2012 14:52:53 +0100
Message-Id: <1330955575-26641-67-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of digging a tty out of the tty_driver struct, which is not
defined to work, use tty_port properly. This includes proper tty
refcounting even though there is no possible race currently. But we
will need tty_port for tty buffers in the future anyway.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/pdc_cons.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index d14e20f..4f00459 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -92,10 +92,11 @@ static int pdc_console_setup(struct console *co, char *options)
 
 static void pdc_console_poll(unsigned long unused);
 static DEFINE_TIMER(pdc_console_timer, pdc_console_poll, 0, 0);
+static struct tty_port tty_port;
 
 static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 {
-
+	tty_port_tty_set(&tty_port, tty);
 	mod_timer(&pdc_console_timer, jiffies + PDC_CONS_POLL_DELAY);
 
 	return 0;
@@ -103,8 +104,10 @@ static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 
 static void pdc_console_tty_close(struct tty_struct *tty, struct file *filp)
 {
-	if (!tty->count)
+	if (!tty->count) {
 		del_timer_sync(&pdc_console_timer);
+		tty_port_tty_set(&tty_port, NULL);
+	}
 }
 
 static int pdc_console_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
@@ -123,8 +126,6 @@ static int pdc_console_tty_chars_in_buffer(struct tty_struct *tty)
 	return 0; /* no buffer */
 }
 
-static struct tty_driver *pdc_console_tty_driver;
-
 static const struct tty_operations pdc_console_tty_ops = {
 	.open = pdc_console_tty_open,
 	.close = pdc_console_tty_close,
@@ -135,10 +136,8 @@ static const struct tty_operations pdc_console_tty_ops = {
 
 static void pdc_console_poll(unsigned long unused)
 {
-
 	int data, count = 0;
-
-	struct tty_struct *tty = pdc_console_tty_driver->ttys[0];
+	struct tty_struct *tty = tty_port_tty_get(&tty_port);
 
 	if (!tty)
 		return;
@@ -154,10 +153,14 @@ static void pdc_console_poll(unsigned long unused)
 	if (count)
 		tty_flip_buffer_push(tty);
 
+	tty_kref_put(tty);
+
 	if (pdc_cons.flags & CON_ENABLED)
 		mod_timer(&pdc_console_timer, jiffies + PDC_CONS_POLL_DELAY);
 }
 
+static struct tty_driver *pdc_console_tty_driver;
+
 static int __init pdc_console_tty_driver_init(void)
 {
 	int err;
@@ -182,6 +185,8 @@ static int __init pdc_console_tty_driver_init(void)
 	printk(KERN_INFO "The PDC console driver is still registered, removing CON_BOOT flag\n");
 	pdc_cons.flags &= ~CON_BOOT;
 
+	tty_port_init(&tty_port);
+
 	pdc_console_tty_driver = alloc_tty_driver(1);
 
 	if (!pdc_console_tty_driver)
-- 
1.7.9.2



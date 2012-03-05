Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175Ab2CEOIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:08:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34643 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2CENxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 12/68] TTY: srmcons, convert to use tty_port
Date: Mon,  5 Mar 2012 14:51:59 +0100
Message-Id: <1330955575-26641-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed because the tty buffer will become a tty_port member
later. That will help us to wipe out most of the races and checks for
the tty pointer in hot paths.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/kernel/srmcons.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 2c89ce5c..3ea8094 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -30,9 +30,8 @@ static int srm_is_registered_console = 0;
 #define MAX_SRM_CONSOLE_DEVICES 1	/* only support 1 console device */
 
 struct srmcons_private {
-	struct tty_struct *tty;
+	struct tty_port port;
 	struct timer_list timer;
-	spinlock_t lock;
 } srmcons_singleton;
 
 typedef union _srmcons_result {
@@ -68,20 +67,21 @@ static void
 srmcons_receive_chars(unsigned long data)
 {
 	struct srmcons_private *srmconsp = (struct srmcons_private *)data;
+	struct tty_port *port = &srmconsp->port;
 	unsigned long flags;
 	int incr = 10;
 
 	local_irq_save(flags);
 	if (spin_trylock(&srmcons_callback_lock)) {
-		if (!srmcons_do_receive_chars(srmconsp->tty))
+		if (!srmcons_do_receive_chars(port->tty))
 			incr = 100;
 		spin_unlock(&srmcons_callback_lock);
 	} 
 
-	spin_lock(&srmconsp->lock);
-	if (srmconsp->tty)
+	spin_lock(&port->lock);
+	if (port->tty)
 		mod_timer(&srmconsp->timer, jiffies + incr);
-	spin_unlock(&srmconsp->lock);
+	spin_unlock(&port->lock);
 
 	local_irq_restore(flags);
 }
@@ -157,18 +157,19 @@ static int
 srmcons_open(struct tty_struct *tty, struct file *filp)
 {
 	struct srmcons_private *srmconsp = &srmcons_singleton;
+	struct tty_port *port = &srmconsp->port;
 	unsigned long flags;
 
-	spin_lock_irqsave(&srmconsp->lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
 
-	if (!srmconsp->tty) {
+	if (!port->tty) {
 		tty->driver_data = srmconsp;
-
-		srmconsp->tty = tty;
+		tty->port = port;
+		port->tty = tty; /* XXX proper refcounting */
 		mod_timer(&srmconsp->timer, jiffies + 10);
 	}
 
-	spin_unlock_irqrestore(&srmconsp->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	return 0;
 }
@@ -177,16 +178,17 @@ static void
 srmcons_close(struct tty_struct *tty, struct file *filp)
 {
 	struct srmcons_private *srmconsp = tty->driver_data;
+	struct tty_port *port = &srmconsp->port;
 	unsigned long flags;
 
-	spin_lock_irqsave(&srmconsp->lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
 
 	if (tty->count == 1) {
-		srmconsp->tty = NULL;
+		port->tty = NULL;
 		del_timer(&srmconsp->timer);
 	}
 
-	spin_unlock_irqrestore(&srmconsp->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 
@@ -203,7 +205,7 @@ static const struct tty_operations srmcons_ops = {
 static int __init
 srmcons_init(void)
 {
-	spin_lock_init(&srmcons_singleton.lock);
+	tty_port_init(&srmcons_singleton.port);
 	setup_timer(&srmcons_singleton.timer, srmcons_receive_chars,
 			(unsigned long)&srmcons_singleton);
 	if (srm_is_registered_console) {
-- 
1.7.9.2



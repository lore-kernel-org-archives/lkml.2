Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1GNMg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:36:28 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51360 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1GNMfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:35:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2 6/6] TTY: mxser+cyclades remove wait_until_sent debug code
Date: Thu, 14 Jul 2011 14:35:15 +0200
Message-Id: <1310646915-3032-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes the code really ugly. And since it can be enabled only before
building and only in the source files, it can be barely used by users.
That said, I've not seen anybody to use it in the past few years.

This crap is copied to some more drivers over the tty tree. Since I'm
not their maintainer, I'm not sure if I should remove them too?

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/cyclades.c |   12 +-----------
 drivers/tty/mxser.c    |   13 +------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c0e8f2e..5beef49 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -45,7 +45,6 @@
 #undef	CY_DEBUG_IO
 #undef	CY_DEBUG_COUNT
 #undef	CY_DEBUG_DTR
-#undef	CY_DEBUG_WAIT_UNTIL_SENT
 #undef	CY_DEBUG_INTERRUPTS
 #undef	CY_16Y_HACK
 #undef	CY_ENABLE_MONITORING
@@ -1678,16 +1677,10 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 	 */
 	if (!timeout || timeout > 2 * info->timeout)
 		timeout = 2 * info->timeout;
-#ifdef CY_DEBUG_WAIT_UNTIL_SENT
-	printk(KERN_DEBUG "In cy_wait_until_sent(%d) check=%d, jiff=%lu...",
-		timeout, char_time, jiffies);
-#endif
+
 	card = info->card;
 	if (!cy_is_Z(card)) {
 		while (cyy_readb(info, CySRER) & CyTxRdy) {
-#ifdef CY_DEBUG_WAIT_UNTIL_SENT
-			printk(KERN_DEBUG "Not clean (jiff=%lu)...", jiffies);
-#endif
 			if (msleep_interruptible(jiffies_to_msecs(char_time)))
 				break;
 			if (timeout && time_after(jiffies, orig_jiffies +
@@ -1697,9 +1690,6 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
-#ifdef CY_DEBUG_WAIT_UNTIL_SENT
-	printk(KERN_DEBUG "Clean (jiff=%lu)...done\n", jiffies);
-#endif
 }
 
 static void cy_flush_buffer(struct tty_struct *tty)
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 7fc8c02..8998d52 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2005,16 +2005,9 @@ static void mxser_wait_until_sent(struct tty_struct *tty, int timeout)
 	 */
 	if (!timeout || timeout > 2 * info->timeout)
 		timeout = 2 * info->timeout;
-#ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
-	printk(KERN_DEBUG "In rs_wait_until_sent(%d) check=%lu...",
-		timeout, char_time);
-	printk("jiff=%lu...", jiffies);
-#endif
+
 	spin_lock_irqsave(&info->slock, flags);
 	while (!((lsr = inb(info->ioaddr + UART_LSR)) & UART_LSR_TEMT)) {
-#ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
-		printk("lsr = %d (jiff=%lu)...", lsr, jiffies);
-#endif
 		spin_unlock_irqrestore(&info->slock, flags);
 		schedule_timeout_interruptible(char_time);
 		spin_lock_irqsave(&info->slock, flags);
@@ -2025,10 +2018,6 @@ static void mxser_wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 	spin_unlock_irqrestore(&info->slock, flags);
 	set_current_state(TASK_RUNNING);
-
-#ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
-	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
-#endif
 }
 
 /*
-- 
1.7.6



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab2FDLhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:37:39 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44993 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org
Subject: [PATCH 03/24] TTY: ircomm, use close times from tty_port
Date: Mon,  4 Jun 2012 13:35:17 +0200
Message-Id: <1338809738-18967-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to tty_port->close_delay and closing_wait.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: netdev@vger.kernel.org
---
 include/net/irda/ircomm_tty.h      |    3 ---
 net/irda/ircomm/ircomm_tty.c       |   10 ++++------
 net/irda/ircomm/ircomm_tty_ioctl.c |    4 ++--
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/net/irda/ircomm_tty.h b/include/net/irda/ircomm_tty.h
index 365fa6e..b4184d0 100644
--- a/include/net/irda/ircomm_tty.h
+++ b/include/net/irda/ircomm_tty.h
@@ -101,9 +101,6 @@ struct ircomm_tty_cb {
 	struct timer_list watchdog_timer;
 	struct work_struct  tqueue;
 
-        unsigned short    close_delay;
-        unsigned short    closing_wait; /* time to wait before closing */
-
 	int  open_count;
 	int  blocked_open;	/* # of blocked opens */
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 8eeaa8b..61e0adc 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -389,8 +389,6 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 		INIT_WORK(&self->tqueue, ircomm_tty_do_softint);
 		self->max_header_size = IRCOMM_TTY_HDR_UNINITIALISED;
 		self->max_data_size = IRCOMM_TTY_DATA_UNINITIALISED;
-		self->close_delay = 5*HZ/10;
-		self->closing_wait = 30*HZ;
 
 		/* Init some important stuff */
 		init_timer(&self->watchdog_timer);
@@ -546,8 +544,8 @@ static void ircomm_tty_close(struct tty_struct *tty, struct file *filp)
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
-	if (self->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent_from_close(tty, self->closing_wait);
+	if (self->port.closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		tty_wait_until_sent_from_close(tty, self->port.closing_wait);
 
 	ircomm_tty_shutdown(self);
 
@@ -558,8 +556,8 @@ static void ircomm_tty_close(struct tty_struct *tty, struct file *filp)
 	self->tty = NULL;
 
 	if (self->blocked_open) {
-		if (self->close_delay)
-			schedule_timeout_interruptible(self->close_delay);
+		if (self->port.close_delay)
+			schedule_timeout_interruptible(self->port.close_delay);
 		wake_up_interruptible(&self->port.open_wait);
 	}
 
diff --git a/net/irda/ircomm/ircomm_tty_ioctl.c b/net/irda/ircomm/ircomm_tty_ioctl.c
index d0667d6..a6d25e3 100644
--- a/net/irda/ircomm/ircomm_tty_ioctl.c
+++ b/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -272,8 +272,8 @@ static int ircomm_tty_get_serial_info(struct ircomm_tty_cb *self,
 	info.line = self->line;
 	info.flags = self->flags;
 	info.baud_base = self->settings.data_rate;
-	info.close_delay = self->close_delay;
-	info.closing_wait = self->closing_wait;
+	info.close_delay = self->port.close_delay;
+	info.closing_wait = self->port.closing_wait;
 
 	/* For compatibility  */
 	info.type = PORT_16550A;
-- 
1.7.10.3



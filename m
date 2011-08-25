Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1HYNNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:13:16 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49568 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1HYNMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:12:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5/5] TTY: use tty_wait_until_sent_from_close in other drivers
Date: Thu, 25 Aug 2011 15:12:08 +0200
Message-Id: <1314277928-13388-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314277928-13388-1-git-send-email-jslaby@suse.cz>
References: <4E556CB7.2010102@suse.cz>
 <1314277928-13388-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the newly added helper to avoid stalls in drivers which are
not yet ported to tty_port helpers.

Those which are broken (call tty_wait_until_sent with irqs disabled)
are left untouched. They are in a deeper trouble than we are trying to
solve here. This includes amiserial, 68328serial, 68360serial and
crisv10.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/isdn/i4l/isdn_tty.c      |    2 +-
 drivers/tty/hvc/hvc_console.c    |    2 +-
 drivers/tty/hvc/hvcs.c           |    2 +-
 drivers/tty/serial/serial_core.c |    3 ++-
 net/irda/ircomm/ircomm_tty.c     |    2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index d850427..e5546cb 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1693,7 +1693,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	 * line status register.
 	 */
 	if (info->flags & ISDN_ASYNC_INITIALIZED) {
-		tty_wait_until_sent(tty, 3000);	/* 30 seconds timeout */
+		tty_wait_until_sent_from_close(tty, 3000);	/* 30 seconds timeout */
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index e1aaf4f..b6b2d18 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -388,7 +388,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 * there is no buffered data otherwise sleeps on a wait queue
 		 * waking periodically to check chars_in_buffer().
 		 */
-		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
+		tty_wait_until_sent_from_close(tty, HVC_CLOSE_WAIT);
 	} else {
 		if (hp->count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 4c8b665..e523773 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1237,7 +1237,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		irq = hvcsd->vdev->irq;
 		spin_unlock_irqrestore(&hvcsd->lock, flags);
 
-		tty_wait_until_sent(tty, HVCS_CLOSE_WAIT);
+		tty_wait_until_sent_from_close(tty, HVCS_CLOSE_WAIT);
 
 		/*
 		 * This line is important because it tells hvcs_open that this
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index e1bff1b..5c04cb9 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1297,7 +1297,8 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, msecs_to_jiffies(port->closing_wait));
+		tty_wait_until_sent_from_close(tty,
+				msecs_to_jiffies(port->closing_wait));
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index b3cc8b3..253695d 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -551,7 +551,7 @@ static void ircomm_tty_close(struct tty_struct *tty, struct file *filp)
 	 */
 	tty->closing = 1;
 	if (self->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, self->closing_wait);
+		tty_wait_until_sent_from_close(tty, self->closing_wait);
 
 	ircomm_tty_shutdown(self);
 
-- 
1.7.6



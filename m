Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999Ab2CEN5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:57:24 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34852 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851Ab2CENx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 51/68] TTY: simserial, use tty_port_hangup
Date: Mon,  5 Mar 2012 14:52:38 +0100
Message-Id: <1330955575-26641-52-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert shutdown to be tty_port_operations->shutdown. Then we can use
tty_port_hangup. (And we have to use tty_port_close.)

This means we no longer touch ASYNC_INITIALIZED, TTY_IO_ERROR. Also we
do not need to do any peculiar TTY logic in the file now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   64 +++++-------------------------------------
 1 file changed, 7 insertions(+), 57 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index e9c5fb7..323c932 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -388,17 +388,11 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct tty_struct *tty, struct serial_state *info)
+static void shutdown(struct tty_port *port)
 {
-	unsigned long	flags;
-
-	if (!(info->port.flags & ASYNC_INITIALIZED))
-		return;
-
-#ifdef SIMSERIAL_DEBUG
-	printk("Shutting down serial port %d (irq %d)...\n", info->line,
-	       info->irq);
-#endif
+	struct serial_state *info = container_of(port, struct serial_state,
+			port);
+	unsigned long flags;
 
 	local_irq_save(flags);
 	{
@@ -409,70 +403,25 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 			free_page((unsigned long) info->xmit.buf);
 			info->xmit.buf = NULL;
 		}
-
-		set_bit(TTY_IO_ERROR, &tty->flags);
-
-		info->port.flags &= ~ASYNC_INITIALIZED;
 	}
 	local_irq_restore(flags);
 }
 
-/*
- * ------------------------------------------------------------
- * rs_close()
- *
- * This routine is called when the serial port gets closed.  First, we
- * wait for the last remaining data to be sent.  Then, we unlink its
- * async structure from the interrupt chain if necessary, and we free
- * that IRQ if nothing is left in the chain.
- * ------------------------------------------------------------
- */
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = tty->driver_data;
-	struct tty_port *port = &info->port;
-
-	if (!info)
-		return;
-
-	if (tty_port_close_start(port, tty, filp) == 0)
-		return;
-
-	/*
-	 * Now we wait for the transmit buffer to clear; and we notify
-	 * the line discipline to only process XON/XOFF characters.
-	 */
-	shutdown(tty, info);
-	rs_flush_buffer(tty);
 
-	tty_port_close_end(port, tty);
-	tty_port_tty_set(port, NULL);
+	tty_port_close(&info->port, tty, filp);
 }
 
-/*
- * rs_hangup() --- called by tty_hangup() when a hangup is signaled.
- */
 static void rs_hangup(struct tty_struct *tty)
 {
 	struct serial_state *info = tty->driver_data;
-	struct tty_port *port = &info->port;
-
-#ifdef SIMSERIAL_DEBUG
-	printk("rs_hangup: called\n");
-#endif
 
 	rs_flush_buffer(tty);
-	if (port->flags & ASYNC_CLOSING)
-		return;
-	shutdown(tty, info);
-
-	port->count = 0;
-	port->flags &= ~ASYNC_NORMAL_ACTIVE;
-	tty_port_tty_set(port, NULL);
-	wake_up_interruptible(&port->open_wait);
+	tty_port_hangup(&info->port);
 }
 
-
 static int activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct serial_state *state = container_of(port, struct serial_state,
@@ -615,6 +564,7 @@ static const struct tty_operations hp_ops = {
 
 static const struct tty_port_operations hp_port_ops = {
 	.activate = activate,
+	.shutdown = shutdown,
 };
 
 /*
-- 
1.7.9.2



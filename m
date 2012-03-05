Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146Ab2CEOF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:05:57 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34676 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2CENxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 50/68] TTY: simserial, use tty_port_open
Date: Mon,  5 Mar 2012 14:52:37 +0100
Message-Id: <1330955575-26641-51-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So now we convert startup to be ->activate of tty_port. This means we
no longer care about INITIALIZED and TTY_IO_ERROR flags.

After we have ->activate much of the code may go as it duplicates what
tty_port_open does. In this case tty_port_open adds block_til_ready to
the path. But we do not define carrier hooks, so it is a noop.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   64 ++++--------------------------------------
 1 file changed, 5 insertions(+), 59 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index b3ec91c..e9c5fb7 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -473,9 +473,10 @@ static void rs_hangup(struct tty_struct *tty)
 }
 
 
-static int startup(struct tty_struct *tty, struct serial_state *state)
+static int activate(struct tty_port *port, struct tty_struct *tty)
 {
-	struct tty_port *port = &state->port;
+	struct serial_state *state = container_of(port, struct serial_state,
+			port);
 	unsigned long flags;
 	int	retval=0;
 	unsigned long page;
@@ -486,20 +487,11 @@ static int startup(struct tty_struct *tty, struct serial_state *state)
 
 	local_irq_save(flags);
 
-	if (port->flags & ASYNC_INITIALIZED) {
-		free_page(page);
-		goto errout;
-	}
-
 	if (state->xmit.buf)
 		free_page(page);
 	else
 		state->xmit.buf = (unsigned char *) page;
 
-#ifdef SIMSERIAL_DEBUG
-	printk("startup: ttys%d (irq %d)...", state->line, state->irq);
-#endif
-
 	/*
 	 * Allocate the IRQ if necessary
 	 */
@@ -510,18 +502,8 @@ static int startup(struct tty_struct *tty, struct serial_state *state)
 			goto errout;
 	}
 
-	clear_bit(TTY_IO_ERROR, &tty->flags);
-
 	state->xmit.head = state->xmit.tail = 0;
 
-#if 0
-	/*
-	 * Set up serial timers...
-	 */
-	timer_table[RS_TIMER].expires = jiffies + 2*HZ/100;
-	timer_active |= 1 << RS_TIMER;
-#endif
-
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
@@ -534,10 +516,6 @@ static int startup(struct tty_struct *tty, struct serial_state *state)
 	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 		tty->alt_speed = 460800;
 
-	port->flags |= ASYNC_INITIALIZED;
-	local_irq_restore(flags);
-	return 0;
-
 errout:
 	local_irq_restore(flags);
 	return retval;
@@ -554,41 +532,11 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = rs_table + tty->index;
 	struct tty_port *port = &info->port;
-	int retval;
 
-	port->count++;
-	tty_port_tty_set(port, tty);
 	tty->driver_data = info;
-	tty->port = port;
-
-#ifdef SIMSERIAL_DEBUG
-	printk("rs_open %s, count = %d\n", tty->name, port->count);
-#endif
 	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
-	 * If the port is the middle of closing, bail out now
-	 */
-	if (tty_hung_up_p(filp) || (port->flags & ASYNC_CLOSING)) {
-		if (port->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&port->close_wait);
-#ifdef SERIAL_DO_RESTART
-		return ((port->flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
-	 * Start up serial port
-	 */
-	retval = startup(tty, info);
-	if (retval) {
-		return retval;
-	}
-
-	/*
 	 * figure out which console to use (should be one already)
 	 */
 	console = console_drivers;
@@ -597,10 +545,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 		console = console->next;
 	}
 
-#ifdef SIMSERIAL_DEBUG
-	printk("rs_open ttys%d successful\n", info->line);
-#endif
-	return 0;
+	return tty_port_open(port, tty, filp);
 }
 
 /*
@@ -669,6 +614,7 @@ static const struct tty_operations hp_ops = {
 };
 
 static const struct tty_port_operations hp_port_ops = {
+	.activate = activate,
 };
 
 /*
-- 
1.7.9.2



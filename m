Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2CEOGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:06:00 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34673 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2CENxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 45/68] TTY: simserial, define local tty_port pointer
Date: Mon,  5 Mar 2012 14:52:32 +0100
Message-Id: <1330955575-26641-46-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use it to make the code more readable.

Since tport doesn't conflict with port anymore and there are not many
tport accessors left, do also s/\<tport\>/port/g.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   84 ++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 120aad4..909357e 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -47,7 +47,7 @@
 #define NR_PORTS	1	/* only one port for now */
 
 struct serial_state {
-	struct tty_port tport;
+	struct tty_port port;
 	struct circ_buf xmit;
 	int irq;
 	int x_char;
@@ -132,8 +132,9 @@ static  void receive_chars(struct tty_struct *tty)
 static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
 	struct serial_state *info = dev_id;
+	struct tty_struct *tty = info->port.tty;
 
-	if (!info->tport.tty) {
+	if (!tty) {
 		printk(KERN_INFO "simrs_interrupt_single: info|tty=0 info=%p problem\n", info);
 		return IRQ_NONE;
 	}
@@ -141,7 +142,7 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 	 * pretty simple in our case, because we only get interrupts
 	 * on inbound traffic
 	 */
-	receive_chars(info->tport.tty);
+	receive_chars(tty);
 	return IRQ_HANDLED;
 }
 
@@ -416,7 +417,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 {
 	unsigned long	flags;
 
-	if (!(info->tport.flags & ASYNC_INITIALIZED))
+	if (!(info->port.flags & ASYNC_INITIALIZED))
 		return;
 
 #ifdef SIMSERIAL_DEBUG
@@ -436,7 +437,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 
 		set_bit(TTY_IO_ERROR, &tty->flags);
 
-		info->tport.flags &= ~ASYNC_INITIALIZED;
+		info->port.flags &= ~ASYNC_INITIALIZED;
 	}
 	local_irq_restore(flags);
 }
@@ -454,6 +455,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = tty->driver_data;
+	struct tty_port *port = &info->port;
 	unsigned long flags;
 
 	if (!info)
@@ -468,30 +470,30 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		return;
 	}
 #ifdef SIMSERIAL_DEBUG
-	printk("rs_close ttys%d, count = %d\n", info->line, info->tport.count);
+	printk("rs_close ttys%d, count = %d\n", info->line, port->count);
 #endif
-	if ((tty->count == 1) && (info->tport.count != 1)) {
+	if ((tty->count == 1) && (port->count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  info->tport.count should always
+		 * structure will be freed.  port->count should always
 		 * be one in these conditions.  If it's greater than
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
 		printk(KERN_ERR "rs_close: bad serial port count; tty->count is 1, "
-		       "info->tport.count is %d\n", info->tport.count);
-		info->tport.count = 1;
+		       "port->count is %d\n", port->count);
+		port->count = 1;
 	}
-	if (--info->tport.count < 0) {
+	if (--port->count < 0) {
 		printk(KERN_ERR "rs_close: bad serial port count for ttys%d: %d\n",
-		       tty->index, info->tport.count);
-		info->tport.count = 0;
+		       tty->index, port->count);
+		port->count = 0;
 	}
-	if (info->tport.count) {
+	if (port->count) {
 		local_irq_restore(flags);
 		return;
 	}
-	info->tport.flags |= ASYNC_CLOSING;
+	port->flags |= ASYNC_CLOSING;
 	local_irq_restore(flags);
 
 	/*
@@ -501,14 +503,14 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	shutdown(tty, info);
 	rs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->tport.tty = NULL;
-	if (info->tport.blocked_open) {
-		if (info->tport.close_delay)
-			schedule_timeout_interruptible(info->tport.close_delay);
-		wake_up_interruptible(&info->tport.open_wait);
+	port->tty = NULL;
+	if (port->blocked_open) {
+		if (port->close_delay)
+			schedule_timeout_interruptible(port->close_delay);
+		wake_up_interruptible(&port->open_wait);
 	}
-	info->tport.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&info->tport.close_wait);
+	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	wake_up_interruptible(&port->close_wait);
 }
 
 /*
@@ -525,26 +527,27 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 static void rs_hangup(struct tty_struct *tty)
 {
 	struct serial_state *info = tty->driver_data;
+	struct tty_port *port = &info->port;
 
 #ifdef SIMSERIAL_DEBUG
 	printk("rs_hangup: called\n");
 #endif
 
 	rs_flush_buffer(tty);
-	if (info->tport.flags & ASYNC_CLOSING)
+	if (port->flags & ASYNC_CLOSING)
 		return;
 	shutdown(tty, info);
 
-	info->tport.count = 0;
-	info->tport.flags &= ~ASYNC_NORMAL_ACTIVE;
-	info->tport.tty = NULL;
-	wake_up_interruptible(&info->tport.open_wait);
+	port->count = 0;
+	port->flags &= ~ASYNC_NORMAL_ACTIVE;
+	port->tty = NULL;
+	wake_up_interruptible(&port->open_wait);
 }
 
 
 static int startup(struct tty_struct *tty, struct serial_state *state)
 {
-	struct tty_port *port = &state->tport;
+	struct tty_port *port = &state->port;
 	unsigned long flags;
 	int	retval=0;
 	unsigned long page;
@@ -622,26 +625,27 @@ errout:
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = rs_table + tty->index;
-	int			retval;
+	struct tty_port *port = &info->port;
+	int retval;
 
-	info->tport.count++;
-	info->tport.tty = tty;
+	port->count++;
+	port->tty = tty;
 	tty->driver_data = info;
-	tty->port = &info->tport;
+	tty->port = port;
 
 #ifdef SIMSERIAL_DEBUG
-	printk("rs_open %s, count = %d\n", tty->name, info->tport.count);
+	printk("rs_open %s, count = %d\n", tty->name, port->count);
 #endif
-	tty->low_latency = (info->tport.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
-	if (tty_hung_up_p(filp) || (info->tport.flags & ASYNC_CLOSING)) {
-		if (info->tport.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->tport.close_wait);
+	if (tty_hung_up_p(filp) || (port->flags & ASYNC_CLOSING)) {
+		if (port->flags & ASYNC_CLOSING)
+			interruptible_sleep_on(&port->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->tport.flags & ASYNC_HUP_NOTIFY) ?
+		return ((port->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -774,8 +778,8 @@ static int __init simrs_init(void)
 	 * Let's have a little bit of fun !
 	 */
 	state = rs_table;
-	tty_port_init(&state->tport);
-	state->tport.close_delay = 0; /* XXX really 0? */
+	tty_port_init(&state->port);
+	state->port.close_delay = 0; /* XXX really 0? */
 
 	retval = hpsim_get_irq(KEYBOARD_INTR);
 	if (retval < 0) {
-- 
1.7.9.2



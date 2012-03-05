Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2CEOIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:08:21 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34652 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab2CENxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 28/68] TTY: simserial, use only one copy of async flags
Date: Mon,  5 Mar 2012 14:52:15 +0100
Message-Id: <1330955575-26641-29-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same as for amiserial. Use only one instance of the flags.

Also remove them from async_struct now. Nobody else uses them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   48 ++++++++++++++++++++----------------------
 include/linux/serialP.h      |    1 -
 2 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 8f68972..a08a53f 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -46,7 +46,7 @@
 
 #define NR_PORTS	1	/* only one port for now */
 
-#define IRQ_T(info) ((info->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : IRQF_DISABLED)
+#define IRQ_T(state) ((state->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : IRQF_DISABLED)
 
 static char *serial_name = "SimSerial driver";
 static char *serial_version = "0.6";
@@ -455,12 +455,11 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 static void shutdown(struct async_struct * info)
 {
 	unsigned long	flags;
-	struct serial_state *state;
+	struct serial_state *state = info->state;
 	int		retval;
 
-	if (!(info->flags & ASYNC_INITIALIZED)) return;
-
-	state = info->state;
+	if (!(state->flags & ASYNC_INITIALIZED))
+		return;
 
 #ifdef SIMSERIAL_DEBUG
 	printk("Shutting down serial port %d (irq %d)....", info->line,
@@ -487,7 +486,8 @@ static void shutdown(struct async_struct * info)
 			if (IRQ_ports[state->irq]) {
 				free_irq(state->irq, NULL);
 				retval = request_irq(state->irq, rs_interrupt_single,
-						     IRQ_T(info), "serial", NULL);
+						     IRQ_T(state), "serial",
+						     NULL);
 
 				if (retval)
 					printk(KERN_ERR "serial shutdown: request_irq: error %d"
@@ -503,7 +503,7 @@ static void shutdown(struct async_struct * info)
 
 		if (info->tty) set_bit(TTY_IO_ERROR, &info->tty->flags);
 
-		info->flags &= ~ASYNC_INITIALIZED;
+		state->flags &= ~ASYNC_INITIALIZED;
 	}
 	local_irq_restore(flags);
 }
@@ -560,7 +560,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	info->flags |= ASYNC_CLOSING;
+	state->flags |= ASYNC_CLOSING;
 	local_irq_restore(flags);
 
 	/*
@@ -576,7 +576,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 			schedule_timeout_interruptible(info->close_delay);
 		wake_up_interruptible(&info->open_wait);
 	}
-	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	state->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
 }
 
@@ -600,15 +600,13 @@ static void rs_hangup(struct tty_struct *tty)
 	printk("rs_hangup: called\n");
 #endif
 
-	state = info->state;
-
 	rs_flush_buffer(tty);
-	if (info->flags & ASYNC_CLOSING)
+	if (state->flags & ASYNC_CLOSING)
 		return;
 	shutdown(info);
 
 	state->count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	state->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -633,7 +631,6 @@ static int get_async_struct(int line, struct async_struct **ret_info)
 	init_waitqueue_head(&info->open_wait);
 	init_waitqueue_head(&info->close_wait);
 	info->port = sstate->port;
-	info->flags = sstate->flags;
 	info->xmit_fifo_size = sstate->xmit_fifo_size;
 	info->line = line;
 	info->state = sstate;
@@ -661,7 +658,7 @@ startup(struct async_struct *info)
 
 	local_irq_save(flags);
 
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (state->flags & ASYNC_INITIALIZED) {
 		free_page(page);
 		goto errout;
 	}
@@ -691,7 +688,8 @@ startup(struct async_struct *info)
 		} else
 			handler = rs_interrupt_single;
 
-		retval = request_irq(state->irq, handler, IRQ_T(info), "simserial", NULL);
+		retval = request_irq(state->irq, handler, IRQ_T(state),
+				"simserial", NULL);
 		if (retval)
 			goto errout;
 	}
@@ -721,17 +719,17 @@ startup(struct async_struct *info)
 	 * Set up the tty->alt_speed kludge
 	 */
 	if (info->tty) {
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			info->tty->alt_speed = 57600;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			info->tty->alt_speed = 115200;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			info->tty->alt_speed = 230400;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			info->tty->alt_speed = 460800;
 	}
 
-	info->flags |= ASYNC_INITIALIZED;
+	state->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 	return 0;
 
@@ -762,7 +760,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 #ifdef SIMSERIAL_DEBUG
 	printk("rs_open %s, count = %d\n", tty->name, info->state->count);
 #endif
-	info->tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->tty->low_latency = (info->state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	if (!tmp_buf) {
 		page = get_zeroed_page(GFP_KERNEL);
@@ -778,11 +776,11 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
+	    (info->state->flags & ASYNC_CLOSING)) {
+		if (info->state->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->state->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index beaf39f..6741f57 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -43,7 +43,6 @@ struct serial_state {
 
 struct async_struct {
 	unsigned long		port;
-	int			flags;
 	int			xmit_fifo_size;
 	struct serial_state	*state;
 	struct tty_struct 	*tty;
-- 
1.7.9.2



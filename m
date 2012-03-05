Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab2CENxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:21 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34749 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2CENxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 37/68] TTY: amiserial/simserial, use tty_port
Date: Mon,  5 Mar 2012 14:52:24 +0100
Message-Id: <1330955575-26641-38-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tty_port to serial_state and start using common tty port members
from tty_port in amiserial and simserial. The rest will follow one by
one.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   24 ++++++++--------
 drivers/tty/amiserial.c      |   63 +++++++++++++++++++++---------------------
 include/linux/serialP.h      |    7 ++---
 3 files changed, 45 insertions(+), 49 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index a76a27e..614c091 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -165,7 +165,7 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
 	struct serial_state *info = dev_id;
 
-	if (!info->tty) {
+	if (!info->tport.tty) {
 		printk(KERN_INFO "simrs_interrupt_single: info|tty=0 info=%p problem\n", info);
 		return IRQ_NONE;
 	}
@@ -173,7 +173,7 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 	 * pretty simple in our case, because we only get interrupts
 	 * on inbound traffic
 	 */
-	receive_chars(info->tty);
+	receive_chars(info->tport.tty);
 	return IRQ_HANDLED;
 }
 
@@ -533,14 +533,14 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	shutdown(tty, info);
 	rs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->tty = NULL;
-	if (info->blocked_open) {
+	info->tport.tty = NULL;
+	if (info->tport.blocked_open) {
 		if (info->close_delay)
 			schedule_timeout_interruptible(info->close_delay);
-		wake_up_interruptible(&info->open_wait);
+		wake_up_interruptible(&info->tport.open_wait);
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&info->close_wait);
+	wake_up_interruptible(&info->tport.close_wait);
 }
 
 /*
@@ -569,8 +569,8 @@ static void rs_hangup(struct tty_struct *tty)
 
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
-	info->tty = NULL;
-	wake_up_interruptible(&info->open_wait);
+	info->tport.tty = NULL;
+	wake_up_interruptible(&info->tport.open_wait);
 }
 
 
@@ -662,8 +662,9 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	unsigned long		page;
 
 	info->count++;
-	info->tty = tty;
+	info->tport.tty = tty;
 	tty->driver_data = info;
+	tty->port = &info->tport;
 
 #ifdef SIMSERIAL_DEBUG
 	printk("rs_open %s, count = %d\n", tty->name, info->count);
@@ -685,7 +686,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
 		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+			interruptible_sleep_on(&info->tport.close_wait);
 #ifdef SERIAL_DO_RESTART
 		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
@@ -827,8 +828,7 @@ simrs_init (void)
 	 * Let's have a little bit of fun !
 	 */
 	for (i = 0, state = rs_table; i < NR_PORTS; i++,state++) {
-		init_waitqueue_head(&state->open_wait);
-		init_waitqueue_head(&state->close_wait);
+		tty_port_init(&state->tport);
 
 		if (state->type == PORT_UNKNOWN) continue;
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 5b87744..71d3331 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -234,7 +234,7 @@ static void receive_chars(struct serial_state *info)
 {
         int status;
 	int serdatr;
-	struct tty_struct *tty = info->tty;
+	struct tty_struct *tty = info->tport.tty;
 	unsigned char ch, flag;
 	struct	async_icount *icount;
 	int oe = 0;
@@ -331,8 +331,8 @@ static void transmit_chars(struct serial_state *info)
 		return;
 	}
 	if (info->xmit.head == info->xmit.tail
-	    || info->tty->stopped
-	    || info->tty->hw_stopped) {
+	    || info->tport.tty->stopped
+	    || info->tport.tty->hw_stopped) {
 		info->IER &= ~UART_IER_THRI;
 	        custom.intena = IF_TBE;
 		mb();
@@ -347,7 +347,7 @@ static void transmit_chars(struct serial_state *info)
 	if (CIRC_CNT(info->xmit.head,
 		     info->xmit.tail,
 		     SERIAL_XMIT_SIZE) < WAKEUP_CHARS)
-		tty_wakeup(info->tty);
+		tty_wakeup(info->tport.tty);
 
 #ifdef SERIAL_DEBUG_INTR
 	printk("THRE...");
@@ -384,7 +384,7 @@ static void check_modem_status(struct serial_state *info)
 		}
 		if (dstatus & SER_CTS)
 			icount->cts++;
-		wake_up_interruptible(&info->delta_msr_wait);
+		wake_up_interruptible(&info->tport.delta_msr_wait);
 	}
 
 	if ((info->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
@@ -393,29 +393,29 @@ static void check_modem_status(struct serial_state *info)
 		       (!(status & SER_DCD)) ? "on" : "off");
 #endif
 		if (!(status & SER_DCD))
-			wake_up_interruptible(&info->open_wait);
+			wake_up_interruptible(&info->tport.open_wait);
 		else {
 #ifdef SERIAL_DEBUG_OPEN
 			printk("doing serial hangup...");
 #endif
-			if (info->tty)
-				tty_hangup(info->tty);
+			if (info->tport.tty)
+				tty_hangup(info->tport.tty);
 		}
 	}
 	if (info->flags & ASYNC_CTS_FLOW) {
-		if (info->tty->hw_stopped) {
+		if (info->tport.tty->hw_stopped) {
 			if (!(status & SER_CTS)) {
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
 				printk("CTS tx start...");
 #endif
-				info->tty->hw_stopped = 0;
+				info->tport.tty->hw_stopped = 0;
 				info->IER |= UART_IER_THRI;
 				custom.intena = IF_SETCLR | IF_TBE;
 				mb();
 				/* set a pending Tx Interrupt, transmitter should restart now */
 				custom.intreq = IF_SETCLR | IF_TBE;
 				mb();
-				tty_wakeup(info->tty);
+				tty_wakeup(info->tport.tty);
 				return;
 			}
 		} else {
@@ -423,7 +423,7 @@ static void check_modem_status(struct serial_state *info)
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
 				printk("CTS tx stop...");
 #endif
-				info->tty->hw_stopped = 1;
+				info->tport.tty->hw_stopped = 1;
 				info->IER &= ~UART_IER_THRI;
 				/* disable Tx interrupt and remove any pending interrupts */
 				custom.intena = IF_TBE;
@@ -456,7 +456,7 @@ static irqreturn_t ser_rx_int(int irq, void *dev_id)
 	printk("ser_rx_int...");
 #endif
 
-	if (!info->tty)
+	if (!info->tport.tty)
 		return IRQ_NONE;
 
 	receive_chars(info);
@@ -475,7 +475,7 @@ static irqreturn_t ser_tx_int(int irq, void *dev_id)
 	  printk("ser_tx_int...");
 #endif
 
-	  if (!info->tty)
+	  if (!info->tport.tty)
 		return IRQ_NONE;
 
 	  transmit_chars(info);
@@ -607,7 +607,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 	 * clear delta_msr_wait queue to avoid mem leaks: we may free the irq
 	 * here so the queue might never be waken up
 	 */
-	wake_up_interruptible(&info->delta_msr_wait);
+	wake_up_interruptible(&info->tport.delta_msr_wait);
 
 	/*
 	 * Free the IRQ, if necessary
@@ -1274,7 +1274,7 @@ static int rs_ioctl(struct tty_struct *tty,
 			cprev = info->icount;
 			local_irq_restore(flags);
 			while (1) {
-				interruptible_sleep_on(&info->delta_msr_wait);
+				interruptible_sleep_on(&info->tport.delta_msr_wait);
 				/* see if a signal did it */
 				if (signal_pending(current))
 					return -ERESTARTSYS;
@@ -1442,15 +1442,15 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	state->tty = NULL;
-	if (state->blocked_open) {
+	state->tport.tty = NULL;
+	if (state->tport.blocked_open) {
 		if (state->close_delay) {
 			msleep_interruptible(jiffies_to_msecs(state->close_delay));
 		}
-		wake_up_interruptible(&state->open_wait);
+		wake_up_interruptible(&state->tport.open_wait);
 	}
 	state->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&state->close_wait);
+	wake_up_interruptible(&state->tport.close_wait);
 	local_irq_restore(flags);
 }
 
@@ -1531,8 +1531,8 @@ static void rs_hangup(struct tty_struct *tty)
 	shutdown(tty, info);
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
-	info->tty = NULL;
-	wake_up_interruptible(&info->open_wait);
+	info->tport.tty = NULL;
+	wake_up_interruptible(&info->tport.open_wait);
 }
 
 /*
@@ -1559,7 +1559,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
 		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+			interruptible_sleep_on(&info->tport.close_wait);
 #ifdef SERIAL_DO_RESTART
 		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
@@ -1589,7 +1589,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
-	add_wait_queue(&info->open_wait, &wait);
+	add_wait_queue(&info->tport.open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttys%d, count = %d\n",
 	       info->line, info->count);
@@ -1600,7 +1600,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		info->count--;
 	}
 	local_irq_restore(flags);
-	info->blocked_open++;
+	info->tport.blocked_open++;
 	while (1) {
 		local_irq_save(flags);
 		if (tty->termios->c_cflag & CBAUD)
@@ -1635,10 +1635,10 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		tty_lock();
 	}
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&info->open_wait, &wait);
+	remove_wait_queue(&info->tport.open_wait, &wait);
 	if (extra_count)
 		info->count++;
-	info->blocked_open--;
+	info->tport.blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready after blocking: ttys%d, count = %d\n",
 	       info->line, info->count);
@@ -1661,8 +1661,9 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	int retval;
 
 	info->count++;
-	info->tty = tty;
+	info->tport.tty = tty;
 	tty->driver_data = info;
+	tty->port = &info->tport;
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
 
@@ -1677,7 +1678,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
 		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+			interruptible_sleep_on(&info->tport.close_wait);
 #ifdef SERIAL_DO_RESTART
 		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
@@ -1869,9 +1870,7 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	state->icount.rx = state->icount.tx = 0;
 	state->icount.frame = state->icount.parity = 0;
 	state->icount.overrun = state->icount.brk = 0;
-	init_waitqueue_head(&state->open_wait);
-	init_waitqueue_head(&state->close_wait);
-	init_waitqueue_head(&state->delta_msr_wait);
+	tty_port_init(&state->tport);
 
 	printk(KERN_INFO "ttyS%d is the amiga builtin serial port\n",
 		       state->line);
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index 984f5ba..32d45b8 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -23,6 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/circ_buf.h>
+#include <linux/tty.h>
 #include <linux/wait.h>
 
 struct serial_state {
@@ -38,6 +39,7 @@ struct serial_state {
 	unsigned short	close_delay;
 	unsigned short	closing_wait; /* time to wait before closing */
 	struct async_icount	icount;	
+	struct tty_port tport;
 
 	/* amiserial */
 	int			read_status_mask;
@@ -46,14 +48,9 @@ struct serial_state {
 	int			quot;
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
-	wait_queue_head_t	delta_msr_wait;
 	/* simserial */
 	int			x_char;	/* xon/xoff character */
-	int			blocked_open; /* # of blocked opens */
  	struct circ_buf		xmit;
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
-	struct tty_struct 	*tty;
 	/* /simserial */
 	/* /amiserial */
 };
-- 
1.7.9.2



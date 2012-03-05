Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2CENyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:54:43 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34901 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2CENxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 33/68] TTY: serialP, merge serial_state and async_struct
Date: Mon,  5 Mar 2012 14:52:20 +0100
Message-Id: <1330955575-26641-34-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final step to get rid of the one of the structures.  A
further cleanup will follow. And I struct serial_state deserves cease
to exist after a switch to tty_port too.

While changing the lines, it removes also pointless tty->driver_data
casts.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |  160 +++++++++-------------
 drivers/tty/amiserial.c      |  301 +++++++++++++++++-------------------------
 include/linux/serialP.h      |   14 +-
 3 files changed, 191 insertions(+), 284 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 8b5a134..7b6e60e 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -163,7 +163,7 @@ static  void receive_chars(struct tty_struct *tty)
  */
 static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
-	struct async_struct *info = dev_id;
+	struct serial_state *info = dev_id;
 
 	if (!info->tty) {
 		printk(KERN_INFO "simrs_interrupt_single: info|tty=0 info=%p problem\n", info);
@@ -185,7 +185,7 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 
 static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (!tty || !info->xmit.buf)
@@ -202,12 +202,11 @@ static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 	return 1;
 }
 
-static void transmit_chars(struct async_struct *info, int *intr_done)
+static void transmit_chars(struct serial_state *info, int *intr_done)
 {
 	int count;
 	unsigned long flags;
 
-
 	local_irq_save(flags);
 
 	if (info->x_char) {
@@ -215,7 +214,7 @@ static void transmit_chars(struct async_struct *info, int *intr_done)
 
 		console->write(console, &c, 1);
 
-		info->state->icount.tx++;
+		info->icount.tx++;
 		info->x_char = 0;
 
 		goto out;
@@ -256,7 +255,7 @@ out:
 
 static void rs_flush_chars(struct tty_struct *tty)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	if (info->xmit.head == info->xmit.tail || tty->stopped || tty->hw_stopped ||
 	    !info->xmit.buf)
@@ -269,8 +268,8 @@ static void rs_flush_chars(struct tty_struct *tty)
 static int rs_write(struct tty_struct * tty,
 		    const unsigned char *buf, int count)
 {
+	struct serial_state *info = tty->driver_data;
 	int	c, ret = 0;
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
 	unsigned long flags;
 
 	if (!tty || !info->xmit.buf || !tmp_buf) return 0;
@@ -303,21 +302,21 @@ static int rs_write(struct tty_struct * tty,
 
 static int rs_write_room(struct tty_struct *tty)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	return CIRC_SPACE(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE);
 }
 
 static int rs_chars_in_buffer(struct tty_struct *tty)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	return CIRC_CNT(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE);
 }
 
 static void rs_flush_buffer(struct tty_struct *tty)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -333,7 +332,7 @@ static void rs_flush_buffer(struct tty_struct *tty)
  */
 static void rs_send_xchar(struct tty_struct *tty, char ch)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	info->x_char = ch;
 	if (ch) {
@@ -362,7 +361,7 @@ static void rs_throttle(struct tty_struct * tty)
 
 static void rs_unthrottle(struct tty_struct * tty)
 {
-	struct async_struct *info = (struct async_struct *)tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	if (I_IXOFF(tty)) {
 		if (info->x_char)
@@ -443,23 +442,22 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct async_struct * info)
+static void shutdown(struct serial_state *info)
 {
 	unsigned long	flags;
-	struct serial_state *state = info->state;
 
-	if (!(state->flags & ASYNC_INITIALIZED))
+	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 
 #ifdef SIMSERIAL_DEBUG
-	printk("Shutting down serial port %d (irq %d)....", info->line,
-	       state->irq);
+	printk("Shutting down serial port %d (irq %d)...\n", info->line,
+	       info->irq);
 #endif
 
 	local_irq_save(flags);
 	{
-		if (state->irq)
-			free_irq(state->irq, info);
+		if (info->irq)
+			free_irq(info->irq, info);
 
 		if (info->xmit.buf) {
 			free_page((unsigned long) info->xmit.buf);
@@ -468,7 +466,7 @@ static void shutdown(struct async_struct * info)
 
 		if (info->tty) set_bit(TTY_IO_ERROR, &info->tty->flags);
 
-		state->flags &= ~ASYNC_INITIALIZED;
+		info->flags &= ~ASYNC_INITIALIZED;
 	}
 	local_irq_restore(flags);
 }
@@ -485,13 +483,11 @@ static void shutdown(struct async_struct * info)
  */
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
-	struct async_struct * info = (struct async_struct *)tty->driver_data;
-	struct serial_state *state;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
-	if (!info ) return;
-
-	state = info->state;
+	if (!info)
+		return;
 
 	local_irq_save(flags);
 	if (tty_hung_up_p(filp)) {
@@ -502,30 +498,30 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		return;
 	}
 #ifdef SIMSERIAL_DEBUG
-	printk("rs_close ttys%d, count = %d\n", info->line, state->count);
+	printk("rs_close ttys%d, count = %d\n", info->line, info->count);
 #endif
-	if ((tty->count == 1) && (state->count != 1)) {
+	if ((tty->count == 1) && (info->count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  state->count should always
+		 * structure will be freed.  info->count should always
 		 * be one in these conditions.  If it's greater than
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
 		printk(KERN_ERR "rs_close: bad serial port count; tty->count is 1, "
-		       "state->count is %d\n", state->count);
-		state->count = 1;
+		       "info->count is %d\n", info->count);
+		info->count = 1;
 	}
-	if (--state->count < 0) {
+	if (--info->count < 0) {
 		printk(KERN_ERR "rs_close: bad serial port count for ttys%d: %d\n",
-		       state->line, state->count);
-		state->count = 0;
+		       info->line, info->count);
+		info->count = 0;
 	}
-	if (state->count) {
+	if (info->count) {
 		local_irq_restore(flags);
 		return;
 	}
-	state->flags |= ASYNC_CLOSING;
+	info->flags |= ASYNC_CLOSING;
 	local_irq_restore(flags);
 
 	/*
@@ -537,11 +533,11 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	tty_ldisc_flush(tty);
 	info->tty = NULL;
 	if (info->blocked_open) {
-		if (state->close_delay)
-			schedule_timeout_interruptible(state->close_delay);
+		if (info->close_delay)
+			schedule_timeout_interruptible(info->close_delay);
 		wake_up_interruptible(&info->open_wait);
 	}
-	state->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
 }
 
@@ -558,59 +554,28 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
  */
 static void rs_hangup(struct tty_struct *tty)
 {
-	struct async_struct * info = (struct async_struct *)tty->driver_data;
-	struct serial_state *state = info->state;
+	struct serial_state *info = tty->driver_data;
 
 #ifdef SIMSERIAL_DEBUG
 	printk("rs_hangup: called\n");
 #endif
 
 	rs_flush_buffer(tty);
-	if (state->flags & ASYNC_CLOSING)
+	if (info->flags & ASYNC_CLOSING)
 		return;
 	shutdown(info);
 
-	state->count = 0;
-	state->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->count = 0;
+	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
 
 
-static int get_async_struct(int line, struct async_struct **ret_info)
-{
-	struct async_struct *info;
-	struct serial_state *sstate;
-
-	sstate = rs_table + line;
-	sstate->count++;
-	if (sstate->info) {
-		*ret_info = sstate->info;
-		return 0;
-	}
-	info = kzalloc(sizeof(struct async_struct), GFP_KERNEL);
-	if (!info) {
-		sstate->count--;
-		return -ENOMEM;
-	}
-	init_waitqueue_head(&info->open_wait);
-	init_waitqueue_head(&info->close_wait);
-	info->state = sstate;
-	if (sstate->info) {
-		kfree(info);
-		*ret_info = sstate->info;
-		return 0;
-	}
-	*ret_info = sstate->info = info;
-	return 0;
-}
-
-static int
-startup(struct async_struct *info)
+static int startup(struct serial_state *state)
 {
 	unsigned long flags;
 	int	retval=0;
-	struct serial_state *state= info->state;
 	unsigned long page;
 
 	page = get_zeroed_page(GFP_KERNEL);
@@ -625,17 +590,18 @@ startup(struct async_struct *info)
 	}
 
 	if (!state->port || !state->type) {
-		if (info->tty) set_bit(TTY_IO_ERROR, &info->tty->flags);
+		if (state->tty)
+			set_bit(TTY_IO_ERROR, &state->tty->flags);
 		free_page(page);
 		goto errout;
 	}
-	if (info->xmit.buf)
+	if (state->xmit.buf)
 		free_page(page);
 	else
-		info->xmit.buf = (unsigned char *) page;
+		state->xmit.buf = (unsigned char *) page;
 
 #ifdef SIMSERIAL_DEBUG
-	printk("startup: ttys%d (irq %d)...", info->line, state->irq);
+	printk("startup: ttys%d (irq %d)...", state->line, state->irq);
 #endif
 
 	/*
@@ -643,14 +609,15 @@ startup(struct async_struct *info)
 	 */
 	if (state->irq) {
 		retval = request_irq(state->irq, rs_interrupt_single, 0,
-				"simserial", info);
+				"simserial", state);
 		if (retval)
 			goto errout;
 	}
 
-	if (info->tty) clear_bit(TTY_IO_ERROR, &info->tty->flags);
+	if (state->tty)
+		clear_bit(TTY_IO_ERROR, &state->tty->flags);
 
-	info->xmit.head = info->xmit.tail = 0;
+	state->xmit.head = state->xmit.tail = 0;
 
 #if 0
 	/*
@@ -663,15 +630,15 @@ startup(struct async_struct *info)
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
-	if (info->tty) {
+	if (state->tty) {
 		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			info->tty->alt_speed = 57600;
+			state->tty->alt_speed = 57600;
 		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			info->tty->alt_speed = 115200;
+			state->tty->alt_speed = 115200;
 		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-			info->tty->alt_speed = 230400;
+			state->tty->alt_speed = 230400;
 		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-			info->tty->alt_speed = 460800;
+			state->tty->alt_speed = 460800;
 	}
 
 	state->flags |= ASYNC_INITIALIZED;
@@ -692,20 +659,18 @@ errout:
  */
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
-	struct async_struct	*info;
+	struct serial_state *info = rs_table + tty->index;
 	int			retval;
 	unsigned long		page;
 
-	retval = get_async_struct(tty->index, &info);
-	if (retval)
-		return retval;
-	tty->driver_data = info;
+	info->count++;
 	info->tty = tty;
+	tty->driver_data = info;
 
 #ifdef SIMSERIAL_DEBUG
-	printk("rs_open %s, count = %d\n", tty->name, info->state->count);
+	printk("rs_open %s, count = %d\n", tty->name, info->count);
 #endif
-	info->tty->low_latency = (info->state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	if (!tmp_buf) {
 		page = get_zeroed_page(GFP_KERNEL);
@@ -720,12 +685,11 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
-	if (tty_hung_up_p(filp) ||
-	    (info->state->flags & ASYNC_CLOSING)) {
-		if (info->state->flags & ASYNC_CLOSING)
+	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
+		if (info->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->state->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -865,6 +829,8 @@ simrs_init (void)
 	 * Let's have a little bit of fun !
 	 */
 	for (i = 0, state = rs_table; i < NR_PORTS; i++,state++) {
+		init_waitqueue_head(&state->open_wait);
+		init_waitqueue_head(&state->close_wait);
 
 		if (state->type == PORT_UNKNOWN) continue;
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 7607c6e..410e8e7 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -45,7 +45,7 @@
 
 #if defined(MODULE) && defined(SERIAL_DEBUG_MCOUNT)
 #define DBG_CNT(s) printk("(%s): [%x] refc=%d, serc=%d, ttyc=%d -> %s\n", \
- tty->name, (info->state->flags), serial_driver->refcount,info->count,tty->count,s)
+ tty->name, (info->flags), serial_driver->refcount,info->count,tty->count,s)
 #else
 #define DBG_CNT(s)
 #endif
@@ -102,7 +102,7 @@ static struct tty_driver *serial_driver;
 
 static unsigned char current_ctl_bits;
 
-static void change_speed(struct async_struct *info, struct ktermios *old);
+static void change_speed(struct serial_state *info, struct ktermios *old);
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout);
 
 
@@ -115,7 +115,7 @@ static struct serial_state rs_table[1];
 #define serial_isroot()	(capable(CAP_SYS_ADMIN))
 
 
-static inline int serial_paranoia_check(struct async_struct *info,
+static inline int serial_paranoia_check(struct serial_state *info,
 					char *name, const char *routine)
 {
 #ifdef SERIAL_PARANOIA_CHECK
@@ -168,7 +168,7 @@ static __inline__ void rtsdtr_ctrl(int bits)
  */
 static void rs_stop(struct tty_struct *tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_stop"))
@@ -188,7 +188,7 @@ static void rs_stop(struct tty_struct *tty)
 
 static void rs_start(struct tty_struct *tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_start"))
@@ -229,7 +229,7 @@ static void rs_start(struct tty_struct *tty)
  * -----------------------------------------------------------------------
  */
 
-static void receive_chars(struct async_struct *info)
+static void receive_chars(struct serial_state *info)
 {
         int status;
 	int serdatr;
@@ -238,7 +238,7 @@ static void receive_chars(struct async_struct *info)
 	struct	async_icount *icount;
 	int oe = 0;
 
-	icount = &info->state->icount;
+	icount = &info->icount;
 
 	status = UART_LSR_DR; /* We obviously have a character! */
 	serdatr = custom.serdatr;
@@ -295,7 +295,7 @@ static void receive_chars(struct async_struct *info)
 	    printk("handling break....");
 #endif
 	    flag = TTY_BREAK;
-	    if (info->state->flags & ASYNC_SAK)
+	    if (info->flags & ASYNC_SAK)
 	      do_SAK(tty);
 	  } else if (status & UART_LSR_PE)
 	    flag = TTY_PARITY;
@@ -318,14 +318,14 @@ out:
 	return;
 }
 
-static void transmit_chars(struct async_struct *info)
+static void transmit_chars(struct serial_state *info)
 {
 	custom.intreq = IF_TBE;
 	mb();
 	if (info->x_char) {
 	        custom.serdat = info->x_char | 0x100;
 		mb();
-		info->state->icount.tx++;
+		info->icount.tx++;
 		info->x_char = 0;
 		return;
 	}
@@ -341,7 +341,7 @@ static void transmit_chars(struct async_struct *info)
 	custom.serdat = info->xmit.buf[info->xmit.tail++] | 0x100;
 	mb();
 	info->xmit.tail = info->xmit.tail & (SERIAL_XMIT_SIZE-1);
-	info->state->icount.tx++;
+	info->icount.tx++;
 
 	if (CIRC_CNT(info->xmit.head,
 		     info->xmit.tail,
@@ -358,7 +358,7 @@ static void transmit_chars(struct async_struct *info)
 	}
 }
 
-static void check_modem_status(struct async_struct *info)
+static void check_modem_status(struct serial_state *info)
 {
 	unsigned char status = ciab.pra & (SER_DCD | SER_CTS | SER_DSR);
 	unsigned char dstatus;
@@ -369,14 +369,14 @@ static void check_modem_status(struct async_struct *info)
 	current_ctl_bits = status;
 
 	if (dstatus) {
-		icount = &info->state->icount;
+		icount = &info->icount;
 		/* update input line counters */
 		if (dstatus & SER_DSR)
 			icount->dsr++;
 		if (dstatus & SER_DCD) {
 			icount->dcd++;
 #ifdef CONFIG_HARD_PPS
-			if ((info->state->flags & ASYNC_HARDPPS_CD) &&
+			if ((info->flags & ASYNC_HARDPPS_CD) &&
 			    !(status & SER_DCD))
 				hardpps();
 #endif
@@ -386,7 +386,7 @@ static void check_modem_status(struct async_struct *info)
 		wake_up_interruptible(&info->delta_msr_wait);
 	}
 
-	if ((info->state->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
+	if ((info->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
 #if (defined(SERIAL_DEBUG_OPEN) || defined(SERIAL_DEBUG_INTR))
 		printk("ttyS%d CD now %s...", info->line,
 		       (!(status & SER_DCD)) ? "on" : "off");
@@ -401,7 +401,7 @@ static void check_modem_status(struct async_struct *info)
 				tty_hangup(info->tty);
 		}
 	}
-	if (info->state->flags & ASYNC_CTS_FLOW) {
+	if (info->flags & ASYNC_CTS_FLOW) {
 		if (info->tty->hw_stopped) {
 			if (!(status & SER_CTS)) {
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
@@ -437,7 +437,7 @@ static void check_modem_status(struct async_struct *info)
 static irqreturn_t ser_vbl_int( int irq, void *data)
 {
         /* vbl is just a periodic interrupt we tie into to update modem status */
-	struct async_struct *info = data;
+	struct serial_state *info = data;
 	/*
 	 * TBD - is it better to unregister from this interrupt or to
 	 * ignore it if MSI is clear ?
@@ -449,14 +449,13 @@ static irqreturn_t ser_vbl_int( int irq, void *data)
 
 static irqreturn_t ser_rx_int(int irq, void *dev_id)
 {
-	struct serial_state *state = dev_id;
-	struct async_struct *info = state->info;
+	struct serial_state *info = dev_id;
 
 #ifdef SERIAL_DEBUG_INTR
 	printk("ser_rx_int...");
 #endif
 
-	if (!info || !info->tty)
+	if (!info->tty)
 		return IRQ_NONE;
 
 	receive_chars(info);
@@ -468,15 +467,14 @@ static irqreturn_t ser_rx_int(int irq, void *dev_id)
 
 static irqreturn_t ser_tx_int(int irq, void *dev_id)
 {
-	struct serial_state *state = dev_id;
-	struct async_struct *info = state->info;
+	struct serial_state *info = dev_id;
 
 	if (custom.serdatr & SDR_TBE) {
 #ifdef SERIAL_DEBUG_INTR
 	  printk("ser_tx_int...");
 #endif
 
-	  if (!info || !info->tty)
+	  if (!info->tty)
 		return IRQ_NONE;
 
 	  transmit_chars(info);
@@ -502,7 +500,7 @@ static irqreturn_t ser_tx_int(int irq, void *dev_id)
  * ---------------------------------------------------------------
  */
 
-static int startup(struct async_struct * info)
+static int startup(struct serial_state *info)
 {
 	unsigned long flags;
 	int	retval=0;
@@ -514,7 +512,7 @@ static int startup(struct async_struct * info)
 
 	local_irq_save(flags);
 
-	if (info->state->flags & ASYNC_INITIALIZED) {
+	if (info->flags & ASYNC_INITIALIZED) {
 		free_page(page);
 		goto errout;
 	}
@@ -565,13 +563,13 @@ static int startup(struct async_struct * info)
 	 * Set up the tty->alt_speed kludge
 	 */
 	if (info->tty) {
-		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			info->tty->alt_speed = 57600;
-		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			info->tty->alt_speed = 115200;
-		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			info->tty->alt_speed = 230400;
-		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			info->tty->alt_speed = 460800;
 	}
 
@@ -580,7 +578,7 @@ static int startup(struct async_struct * info)
 	 */
 	change_speed(info, NULL);
 
-	info->state->flags |= ASYNC_INITIALIZED;
+	info->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 	return 0;
 
@@ -593,15 +591,15 @@ errout:
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct async_struct * info)
+static void shutdown(struct serial_state *info)
 {
 	unsigned long	flags;
 	struct serial_state *state;
 
-	if (!(info->state->flags & ASYNC_INITIALIZED))
+	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 
-	state = info->state;
+	state = info;
 
 #ifdef SERIAL_DEBUG_OPEN
 	printk("Shutting down serial port %d ....\n", info->line);
@@ -640,7 +638,7 @@ static void shutdown(struct async_struct * info)
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
-	info->state->flags &= ~ASYNC_INITIALIZED;
+	info->flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 }
 
@@ -649,7 +647,7 @@ static void shutdown(struct async_struct * info)
  * This routine is called to set the UART divisor registers to match
  * the specified baud rate for a serial port.
  */
-static void change_speed(struct async_struct *info,
+static void change_speed(struct serial_state *info,
 			 struct ktermios *old_termios)
 {
 	int	quot = 0, baud_base, baud;
@@ -683,10 +681,10 @@ static void change_speed(struct async_struct *info,
 	baud = tty_get_baud_rate(info->tty);
 	if (!baud)
 		baud = 9600;	/* B0 transition handled in rs_set_termios */
-	baud_base = info->state->baud_base;
+	baud_base = info->baud_base;
 	if (baud == 38400 &&
-	    ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
-		quot = info->state->custom_divisor;
+	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+		quot = info->custom_divisor;
 	else {
 		if (baud == 134)
 			/* Special case since 134 is really 134.5 */
@@ -703,8 +701,8 @@ static void change_speed(struct async_struct *info,
 		if (!baud)
 			baud = 9600;
 		if (baud == 38400 &&
-		    ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
-			quot = info->state->custom_divisor;
+		    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+			quot = info->custom_divisor;
 		else {
 			if (baud == 134)
 				/* Special case since 134 is really 134.5 */
@@ -717,22 +715,22 @@ static void change_speed(struct async_struct *info,
 	if (!quot)
 		quot = baud_base / 9600;
 	info->quot = quot;
-	info->timeout = ((info->state->xmit_fifo_size*HZ*bits*quot) / baud_base);
+	info->timeout = ((info->xmit_fifo_size*HZ*bits*quot) / baud_base);
 	info->timeout += HZ/50;		/* Add .02 seconds of slop */
 
 	/* CTS flow control flag and modem status interrupts */
 	info->IER &= ~UART_IER_MSI;
-	if (info->state->flags & ASYNC_HARDPPS_CD)
+	if (info->flags & ASYNC_HARDPPS_CD)
 		info->IER |= UART_IER_MSI;
 	if (cflag & CRTSCTS) {
-		info->state->flags |= ASYNC_CTS_FLOW;
+		info->flags |= ASYNC_CTS_FLOW;
 		info->IER |= UART_IER_MSI;
 	} else
-		info->state->flags &= ~ASYNC_CTS_FLOW;
+		info->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
-		info->state->flags &= ~ASYNC_CHECK_CD;
+		info->flags &= ~ASYNC_CHECK_CD;
 	else {
-		info->state->flags |= ASYNC_CHECK_CD;
+		info->flags |= ASYNC_CHECK_CD;
 		info->IER |= UART_IER_MSI;
 	}
 	/* TBD:
@@ -791,7 +789,7 @@ static void change_speed(struct async_struct *info,
 
 static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct async_struct *info;
+	struct serial_state *info;
 	unsigned long flags;
 
 	info = tty->driver_data;
@@ -818,7 +816,7 @@ static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 
 static void rs_flush_chars(struct tty_struct *tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_flush_chars"))
@@ -843,11 +841,9 @@ static void rs_flush_chars(struct tty_struct *tty)
 static int rs_write(struct tty_struct * tty, const unsigned char *buf, int count)
 {
 	int	c, ret = 0;
-	struct async_struct *info;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
-	info = tty->driver_data;
-
 	if (serial_paranoia_check(info, tty->name, "rs_write"))
 		return 0;
 
@@ -891,7 +887,7 @@ static int rs_write(struct tty_struct * tty, const unsigned char *buf, int count
 
 static int rs_write_room(struct tty_struct *tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_write_room"))
 		return 0;
@@ -900,7 +896,7 @@ static int rs_write_room(struct tty_struct *tty)
 
 static int rs_chars_in_buffer(struct tty_struct *tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_chars_in_buffer"))
 		return 0;
@@ -909,7 +905,7 @@ static int rs_chars_in_buffer(struct tty_struct *tty)
 
 static void rs_flush_buffer(struct tty_struct *tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_flush_buffer"))
@@ -926,7 +922,7 @@ static void rs_flush_buffer(struct tty_struct *tty)
  */
 static void rs_send_xchar(struct tty_struct *tty, char ch)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
         unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_send_char"))
@@ -961,7 +957,7 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
  */
 static void rs_throttle(struct tty_struct * tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 #ifdef SERIAL_DEBUG_THROTTLE
 	char	buf[64];
@@ -986,7 +982,7 @@ static void rs_throttle(struct tty_struct * tty)
 
 static void rs_unthrottle(struct tty_struct * tty)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 #ifdef SERIAL_DEBUG_THROTTLE
 	char	buf[64];
@@ -1017,11 +1013,10 @@ static void rs_unthrottle(struct tty_struct * tty)
  * ------------------------------------------------------------
  */
 
-static int get_serial_info(struct async_struct * info,
+static int get_serial_info(struct serial_state *state,
 			   struct serial_struct __user * retinfo)
 {
 	struct serial_struct tmp;
-	struct serial_state *state = info->state;
    
 	if (!retinfo)
 		return -EFAULT;
@@ -1043,11 +1038,11 @@ static int get_serial_info(struct async_struct * info,
 	return 0;
 }
 
-static int set_serial_info(struct async_struct * info,
+static int set_serial_info(struct serial_state *state,
 			   struct serial_struct __user * new_info)
 {
 	struct serial_struct new_serial;
- 	struct serial_state old_state, *state;
+	struct serial_state old_state;
 	unsigned int		change_irq,change_port;
 	int 			retval = 0;
 
@@ -1055,7 +1050,6 @@ static int set_serial_info(struct async_struct * info,
 		return -EFAULT;
 
 	tty_lock();
-	state = info->state;
 	old_state = *state;
   
 	change_irq = new_serial.irq != state->irq;
@@ -1094,7 +1088,7 @@ static int set_serial_info(struct async_struct * info,
 	state->custom_divisor = new_serial.custom_divisor;
 	state->close_delay = new_serial.close_delay * HZ/100;
 	state->closing_wait = new_serial.closing_wait * HZ/100;
-	info->tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	state->tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
 	if (state->flags & ASYNC_INITIALIZED) {
@@ -1102,17 +1096,17 @@ check_and_exit:
 		     (state->flags & ASYNC_SPD_MASK)) ||
 		    (old_state.custom_divisor != state->custom_divisor)) {
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-				info->tty->alt_speed = 57600;
+				state->tty->alt_speed = 57600;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-				info->tty->alt_speed = 115200;
+				state->tty->alt_speed = 115200;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-				info->tty->alt_speed = 230400;
+				state->tty->alt_speed = 230400;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-				info->tty->alt_speed = 460800;
-			change_speed(info, NULL);
+				state->tty->alt_speed = 460800;
+			change_speed(state, NULL);
 		}
 	} else
-		retval = startup(info);
+		retval = startup(state);
 	tty_unlock();
 	return retval;
 }
@@ -1128,7 +1122,7 @@ check_and_exit:
  * 	    transmit holding register is empty.  This functionality
  * 	    allows an RS485 driver to be written in user space. 
  */
-static int get_lsr_info(struct async_struct * info, unsigned int __user *value)
+static int get_lsr_info(struct serial_state *info, unsigned int __user *value)
 {
 	unsigned char status;
 	unsigned int result;
@@ -1147,7 +1141,7 @@ static int get_lsr_info(struct async_struct * info, unsigned int __user *value)
 
 static int rs_tiocmget(struct tty_struct *tty)
 {
-	struct async_struct * info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned char control, status;
 	unsigned long flags;
 
@@ -1170,7 +1164,7 @@ static int rs_tiocmget(struct tty_struct *tty)
 static int rs_tiocmset(struct tty_struct *tty, unsigned int set,
 						unsigned int clear)
 {
-	struct async_struct * info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_ioctl"))
@@ -1197,7 +1191,7 @@ static int rs_tiocmset(struct tty_struct *tty, unsigned int set,
  */
 static int rs_break(struct tty_struct *tty, int break_state)
 {
-	struct async_struct * info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_break"))
@@ -1222,12 +1216,12 @@ static int rs_break(struct tty_struct *tty, int break_state)
 static int rs_get_icount(struct tty_struct *tty,
 				struct serial_icounter_struct *icount)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	struct async_icount cnow;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	cnow = info->state->icount;
+	cnow = info->icount;
 	local_irq_restore(flags);
 	icount->cts = cnow.cts;
 	icount->dsr = cnow.dsr;
@@ -1247,7 +1241,7 @@ static int rs_get_icount(struct tty_struct *tty,
 static int rs_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
-	struct async_struct * info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	struct async_icount cprev, cnow;	/* kernel counter temps */
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
@@ -1275,7 +1269,7 @@ static int rs_ioctl(struct tty_struct *tty,
 
 		case TIOCSERGSTRUCT:
 			if (copy_to_user(argp,
-					 info, sizeof(struct async_struct)))
+					 info, sizeof(struct serial_state)))
 				return -EFAULT;
 			return 0;
 
@@ -1288,7 +1282,7 @@ static int rs_ioctl(struct tty_struct *tty,
 		case TIOCMIWAIT:
 			local_irq_save(flags);
 			/* note the counters on entry */
-			cprev = info->state->icount;
+			cprev = info->icount;
 			local_irq_restore(flags);
 			while (1) {
 				interruptible_sleep_on(&info->delta_msr_wait);
@@ -1296,7 +1290,7 @@ static int rs_ioctl(struct tty_struct *tty,
 				if (signal_pending(current))
 					return -ERESTARTSYS;
 				local_irq_save(flags);
-				cnow = info->state->icount; /* atomic copy */
+				cnow = info->icount; /* atomic copy */
 				local_irq_restore(flags);
 				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr && 
 				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
@@ -1325,7 +1319,7 @@ static int rs_ioctl(struct tty_struct *tty,
 
 static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	struct async_struct *info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
 
@@ -1385,15 +1379,12 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
  */
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
-	struct async_struct * info = tty->driver_data;
-	struct serial_state *state;
+	struct serial_state *state = tty->driver_data;
 	unsigned long flags;
 
-	if (!info || serial_paranoia_check(info, tty->name, "rs_close"))
+	if (!state || serial_paranoia_check(state, tty->name, "rs_close"))
 		return;
 
-	state = info->state;
-
 	local_irq_save(flags);
 
 	if (tty_hung_up_p(filp)) {
@@ -1403,7 +1394,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	}
 
 #ifdef SERIAL_DEBUG_OPEN
-	printk("rs_close ttys%d, count = %d\n", info->line, state->count);
+	printk("rs_close ttys%d, count = %d\n", state->line, state->count);
 #endif
 	if ((tty->count == 1) && (state->count != 1)) {
 		/*
@@ -1441,7 +1432,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * interrupt driver to stop checking the data ready bit in the
 	 * line status register.
 	 */
-	info->read_status_mask &= ~UART_LSR_DR;
+	state->read_status_mask &= ~UART_LSR_DR;
 	if (state->flags & ASYNC_INITIALIZED) {
 	        /* disable receive interrupts */
 	        custom.intena = IF_RBF;
@@ -1455,22 +1446,22 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		 * has completely drained; this is especially
 		 * important if there is a transmit FIFO!
 		 */
-		rs_wait_until_sent(tty, info->timeout);
+		rs_wait_until_sent(tty, state->timeout);
 	}
-	shutdown(info);
+	shutdown(state);
 	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	info->tty = NULL;
-	if (info->blocked_open) {
+	state->tty = NULL;
+	if (state->blocked_open) {
 		if (state->close_delay) {
 			msleep_interruptible(jiffies_to_msecs(state->close_delay));
 		}
-		wake_up_interruptible(&info->open_wait);
+		wake_up_interruptible(&state->open_wait);
 	}
 	state->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&info->close_wait);
+	wake_up_interruptible(&state->close_wait);
 	local_irq_restore(flags);
 }
 
@@ -1479,14 +1470,14 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
  */
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 {
-	struct async_struct * info = tty->driver_data;
+	struct serial_state *info = tty->driver_data;
 	unsigned long orig_jiffies, char_time;
 	int lsr;
 
 	if (serial_paranoia_check(info, tty->name, "rs_wait_until_sent"))
 		return;
 
-	if (info->state->xmit_fifo_size == 0)
+	if (info->xmit_fifo_size == 0)
 		return; /* Just in case.... */
 
 	orig_jiffies = jiffies;
@@ -1499,7 +1490,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 	 * Note: we have to use pretty tight timings here to satisfy
 	 * the NIST-PCTS.
 	 */
-	char_time = (info->timeout - HZ/50) / info->state->xmit_fifo_size;
+	char_time = (info->timeout - HZ/50) / info->xmit_fifo_size;
 	char_time = char_time / 5;
 	if (char_time == 0)
 		char_time = 1;
@@ -1542,18 +1533,15 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
  */
 static void rs_hangup(struct tty_struct *tty)
 {
-	struct async_struct * info = tty->driver_data;
-	struct serial_state *state = info->state;
+	struct serial_state *info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_hangup"))
 		return;
 
-	state = info->state;
-
 	rs_flush_buffer(tty);
 	shutdown(info);
-	state->count = 0;
-	state->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->count = 0;
+	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -1564,14 +1552,13 @@ static void rs_hangup(struct tty_struct *tty)
  * ------------------------------------------------------------
  */
 static int block_til_ready(struct tty_struct *tty, struct file * filp,
-			   struct async_struct *info)
+			   struct serial_state *info)
 {
 #ifdef DECLARE_WAITQUEUE
 	DECLARE_WAITQUEUE(wait, current);
 #else
 	struct wait_queue wait = { current, NULL };
 #endif
-	struct serial_state *state = info->state;
 	int		retval;
 	int		do_clocal = 0, extra_count = 0;
 	unsigned long	flags;
@@ -1581,11 +1568,11 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (state->flags & ASYNC_CLOSING)) {
-		if (state->flags & ASYNC_CLOSING)
+	    (info->flags & ASYNC_CLOSING)) {
+		if (info->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((state->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -1598,7 +1585,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		state->flags |= ASYNC_NORMAL_ACTIVE;
+		info->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -1608,7 +1595,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, state->count is dropped by one, so that
+	 * this loop, info->count is dropped by one, so that
 	 * rs_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
@@ -1616,12 +1603,12 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	add_wait_queue(&info->open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttys%d, count = %d\n",
-	       state->line, state->count);
+	       info->line, info->count);
 #endif
 	local_irq_save(flags);
 	if (!tty_hung_up_p(filp)) {
 		extra_count = 1;
-		state->count--;
+		info->count--;
 	}
 	local_irq_restore(flags);
 	info->blocked_open++;
@@ -1632,9 +1619,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		local_irq_restore(flags);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(state->flags & ASYNC_INITIALIZED)) {
+		    !(info->flags & ASYNC_INITIALIZED)) {
 #ifdef SERIAL_DO_RESTART
-			if (state->flags & ASYNC_HUP_NOTIFY)
+			if (info->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -1643,7 +1630,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 			break;
 		}
-		if (!(state->flags & ASYNC_CLOSING) &&
+		if (!(info->flags & ASYNC_CLOSING) &&
 		    (do_clocal || (!(ciab.pra & SER_DCD)) ))
 			break;
 		if (signal_pending(current)) {
@@ -1652,7 +1639,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		}
 #ifdef SERIAL_DEBUG_OPEN
 		printk("block_til_ready blocking: ttys%d, count = %d\n",
-		       info->line, state->count);
+		       info->line, info->count);
 #endif
 		tty_unlock();
 		schedule();
@@ -1661,46 +1648,15 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (extra_count)
-		state->count++;
+		info->count++;
 	info->blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready after blocking: ttys%d, count = %d\n",
-	       info->line, state->count);
+	       info->line, info->count);
 #endif
 	if (retval)
 		return retval;
-	state->flags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}
-
-static int get_async_struct(int line, struct async_struct **ret_info)
-{
-	struct async_struct *info;
-	struct serial_state *sstate;
-
-	sstate = rs_table + line;
-	sstate->count++;
-	if (sstate->info) {
-		*ret_info = sstate->info;
-		return 0;
-	}
-	info = kzalloc(sizeof(struct async_struct), GFP_KERNEL);
-	if (!info) {
-		sstate->count--;
-		return -ENOMEM;
-	}
-#ifdef DECLARE_WAITQUEUE
-	init_waitqueue_head(&info->open_wait);
-	init_waitqueue_head(&info->close_wait);
-	init_waitqueue_head(&info->delta_msr_wait);
-#endif
-	info->state = sstate;
-	if (sstate->info) {
-		kfree(info);
-		*ret_info = sstate->info;
-		return 0;
-	}
-	*ret_info = sstate->info = info;
+	info->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -1712,32 +1668,29 @@ static int get_async_struct(int line, struct async_struct **ret_info)
  */
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
-	struct async_struct	*info;
+	struct serial_state *info = rs_table + tty->index;
 	int retval;
 
-	retval = get_async_struct(tty->index, &info);
-	if (retval) {
-		return retval;
-	}
-	tty->driver_data = info;
+	info->count++;
 	info->tty = tty;
+	tty->driver_data = info;
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
 
 #ifdef SERIAL_DEBUG_OPEN
-	printk("rs_open %s, count = %d\n", tty->name, info->state->count);
+	printk("rs_open %s, count = %d\n", tty->name, info->count);
 #endif
-	info->tty->low_latency = (info->state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->state->flags & ASYNC_CLOSING)) {
-		if (info->state->flags & ASYNC_CLOSING)
+	    (info->flags & ASYNC_CLOSING)) {
+		if (info->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->state->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -1773,24 +1726,14 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 
 static inline void line_info(struct seq_file *m, struct serial_state *state)
 {
-	struct async_struct *info = state->info, scr_info;
 	char	stat_buf[30], control, status;
 	unsigned long flags;
 
 	seq_printf(m, "%d: uart:amiga_builtin",state->line);
 
-	/*
-	 * Figure out the current RS-232 lines
-	 */
-	if (!info) {
-		info = &scr_info;	/* This is just for serial_{in,out} */
-
-		info->quot = 0;
-		info->tty = NULL;
-	}
 	local_irq_save(flags);
 	status = ciab.pra;
-	control = info ? info->MCR : status;
+	control = (state->flags & ASYNC_INITIALIZED) ? state->MCR : status;
 	local_irq_restore(flags);
 
 	stat_buf[0] = 0;
@@ -1806,9 +1749,8 @@ static inline void line_info(struct seq_file *m, struct serial_state *state)
 	if(!(status & SER_DCD))
 		strcat(stat_buf, "|CD");
 
-	if (info->quot) {
-		seq_printf(m, " baud:%d", state->baud_base / info->quot);
-	}
+	if (state->quot)
+		seq_printf(m, " baud:%d", state->baud_base / state->quot);
 
 	seq_printf(m, " tx:%d rx:%d", state->icount.tx, state->icount.rx);
 
@@ -1938,6 +1880,9 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	state->icount.rx = state->icount.tx = 0;
 	state->icount.frame = state->icount.parity = 0;
 	state->icount.overrun = state->icount.brk = 0;
+	init_waitqueue_head(&state->open_wait);
+	init_waitqueue_head(&state->close_wait);
+	init_waitqueue_head(&state->delta_msr_wait);
 
 	printk(KERN_INFO "ttyS%d is the amiga builtin serial port\n",
 		       state->line);
@@ -1993,7 +1938,6 @@ static int __exit amiga_serial_remove(struct platform_device *pdev)
 {
 	int error;
 	struct serial_state *state = platform_get_drvdata(pdev);
-	struct async_struct *info = state->info;
 
 	/* printk("Unloading %s: version %s\n", serial_name, serial_version); */
 	if ((error = tty_unregister_driver(serial_driver)))
@@ -2001,11 +1945,8 @@ static int __exit amiga_serial_remove(struct platform_device *pdev)
 		       error);
 	put_tty_driver(serial_driver);
 
-	rs_table[0].info = NULL;
-	kfree(info);
-
-	free_irq(IRQ_AMIGA_TBE, rs_table);
-	free_irq(IRQ_AMIGA_RBF, rs_table);
+	free_irq(IRQ_AMIGA_TBE, state);
+	free_irq(IRQ_AMIGA_RBF, state);
 
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index b8543f9..984f5ba 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -38,24 +38,24 @@ struct serial_state {
 	unsigned short	close_delay;
 	unsigned short	closing_wait; /* time to wait before closing */
 	struct async_icount	icount;	
-	struct async_struct *info;
-};
 
-struct async_struct {
-	struct serial_state	*state;
-	struct tty_struct 	*tty;
+	/* amiserial */
 	int			read_status_mask;
 	int			ignore_status_mask;
 	int			timeout;
 	int			quot;
-	int			x_char;	/* xon/xoff character */
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
+	wait_queue_head_t	delta_msr_wait;
+	/* simserial */
+	int			x_char;	/* xon/xoff character */
 	int			blocked_open; /* # of blocked opens */
  	struct circ_buf		xmit;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	wait_queue_head_t	delta_msr_wait;
+	struct tty_struct 	*tty;
+	/* /simserial */
+	/* /amiserial */
 };
 
 #endif /* _LINUX_SERIAL_H */
-- 
1.7.9.2



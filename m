Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab2CENzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:55:41 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34859 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964863Ab2CENx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 26/68] TTY: amiserial, remove tasklet for tty_wakeup
Date: Mon,  5 Mar 2012 14:52:13 +0100
Message-Id: <1330955575-26641-27-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_wakeup is safe to be called from all contexts. No need to schedule
a tasklet for that. Let's call it directly like in other drivers.

This allows us to kill another member of async_struct structure. (If
we remove the dummy uses in simserial.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    2 --
 drivers/tty/amiserial.c      |   42 ++----------------------------------------
 include/linux/serialP.h      |    8 --------
 3 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index c8e728bf..8f68972 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -570,7 +570,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	shutdown(info);
 	rs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
 		if (info->close_delay)
@@ -608,7 +607,6 @@ static void rs_hangup(struct tty_struct *tty)
 		return;
 	shutdown(info);
 
-	info->event = 0;
 	state->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index c6d8913..d5fac86 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -231,17 +231,6 @@ static void rs_start(struct tty_struct *tty)
  * -----------------------------------------------------------------------
  */
 
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver.
- */
-static void rs_sched_event(struct async_struct *info,
-			   int event)
-{
-	info->event |= 1 << event;
-	tasklet_schedule(&info->tlet);
-}
-
 static void receive_chars(struct async_struct *info)
 {
         int status;
@@ -359,7 +348,7 @@ static void transmit_chars(struct async_struct *info)
 	if (CIRC_CNT(info->xmit.head,
 		     info->xmit.tail,
 		     SERIAL_XMIT_SIZE) < WAKEUP_CHARS)
-		rs_sched_event(info, RS_EVENT_WRITE_WAKEUP);
+		tty_wakeup(info->tty);
 
 #ifdef SERIAL_DEBUG_INTR
 	printk("THRE...");
@@ -427,7 +416,7 @@ static void check_modem_status(struct async_struct *info)
 				/* set a pending Tx Interrupt, transmitter should restart now */
 				custom.intreq = IF_SETCLR | IF_TBE;
 				mb();
-				rs_sched_event(info, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(info->tty);
 				return;
 			}
 		} else {
@@ -507,29 +496,6 @@ static irqreturn_t ser_tx_int(int irq, void *dev_id)
  */
 
 /*
- * This routine is used to handle the "bottom half" processing for the
- * serial driver, known also the "software interrupt" processing.
- * This processing is done at the kernel interrupt level, after the
- * rs_interrupt() has returned, BUT WITH INTERRUPTS TURNED ON.  This
- * is where time-consuming activities which can not be done in the
- * interrupt driver proper are done; the interrupt driver schedules
- * them using rs_sched_event(), and they get done here.
- */
-
-static void do_softint(unsigned long private_)
-{
-	struct async_struct	*info = (struct async_struct *) private_;
-	struct tty_struct	*tty;
-
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(RS_EVENT_WRITE_WAKEUP, &info->event))
-		tty_wakeup(tty);
-}
-
-/*
  * ---------------------------------------------------------------
  * Low level utility subroutines for the serial driver:  routines to
  * figure out the appropriate timeout for an interrupt chain, routines
@@ -1506,7 +1472,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
 		if (info->close_delay) {
@@ -1597,7 +1562,6 @@ static void rs_hangup(struct tty_struct *tty)
 
 	rs_flush_buffer(tty);
 	shutdown(info);
-	info->event = 0;
 	state->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
@@ -1744,7 +1708,6 @@ static int get_async_struct(int line, struct async_struct **ret_info)
 	info->flags = sstate->flags;
 	info->xmit_fifo_size = sstate->xmit_fifo_size;
 	info->line = line;
-	tasklet_init(&info->tlet, do_softint, (unsigned long)info);
 	info->state = sstate;
 	if (sstate->info) {
 		kfree(info);
@@ -2050,7 +2013,6 @@ static int __exit amiga_serial_remove(struct platform_device *pdev)
 	struct async_struct *info = state->info;
 
 	/* printk("Unloading %s: version %s\n", serial_name, serial_version); */
-	tasklet_kill(&info->tlet);
 	if ((error = tty_unregister_driver(serial_driver)))
 		printk("SERIAL: failed to unregister serial driver (%d)\n",
 		       error);
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index c1acdb2..beaf39f 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -56,11 +56,9 @@ struct async_struct {
 	unsigned short		closing_wait;
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
-	unsigned long		event;
 	int			line;
 	int			blocked_open; /* # of blocked opens */
  	struct circ_buf		xmit;
-	struct tasklet_struct	tlet;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	delta_msr_wait;
@@ -68,10 +66,4 @@ struct async_struct {
 	struct async_struct	*prev_port;
 };
 
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at rs interrupt time.
- */
-#define RS_EVENT_WRITE_WAKEUP	0
-
 #endif /* _LINUX_SERIAL_H */
-- 
1.7.9.2



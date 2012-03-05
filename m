Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab2CEOAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:00:12 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34799 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2CENxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 38/68] TTY: amiserial/simserial, use close delays from tty_port
Date: Mon,  5 Mar 2012 14:52:25 +0100
Message-Id: <1330955575-26641-39-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that previously simserial set the delay to 0. So we preserve
that. BUT, is it correct?

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    5 +++--
 drivers/tty/amiserial.c      |   20 +++++++++-----------
 include/linux/serialP.h      |    2 --
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 614c091..fb324b3 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -535,8 +535,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	tty_ldisc_flush(tty);
 	info->tport.tty = NULL;
 	if (info->tport.blocked_open) {
-		if (info->close_delay)
-			schedule_timeout_interruptible(info->close_delay);
+		if (info->tport.close_delay)
+			schedule_timeout_interruptible(info->tport.close_delay);
 		wake_up_interruptible(&info->tport.open_wait);
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
@@ -829,6 +829,7 @@ simrs_init (void)
 	 */
 	for (i = 0, state = rs_table; i < NR_PORTS; i++,state++) {
 		tty_port_init(&state->tport);
+		state->tport.close_delay = 0; /* XXX really 0? */
 
 		if (state->type == PORT_UNKNOWN) continue;
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 71d3331..06e3a09 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1022,8 +1022,8 @@ static int get_serial_info(struct serial_state *state,
 	tmp.flags = state->flags;
 	tmp.xmit_fifo_size = state->xmit_fifo_size;
 	tmp.baud_base = state->baud_base;
-	tmp.close_delay = state->close_delay;
-	tmp.closing_wait = state->closing_wait;
+	tmp.close_delay = state->tport.close_delay;
+	tmp.closing_wait = state->tport.closing_wait;
 	tmp.custom_divisor = state->custom_divisor;
 	tty_unlock();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
@@ -1052,7 +1052,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
   
 	if (!serial_isroot()) {
 		if ((new_serial.baud_base != state->baud_base) ||
-		    (new_serial.close_delay != state->close_delay) ||
+		    (new_serial.close_delay != state->tport.close_delay) ||
 		    (new_serial.xmit_fifo_size != state->xmit_fifo_size) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (state->flags & ~ASYNC_USR_MASK)))
@@ -1077,8 +1077,8 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 	state->flags = ((state->flags & ~ASYNC_FLAGS) |
 			(new_serial.flags & ASYNC_FLAGS));
 	state->custom_divisor = new_serial.custom_divisor;
-	state->close_delay = new_serial.close_delay * HZ/100;
-	state->closing_wait = new_serial.closing_wait * HZ/100;
+	state->tport.close_delay = new_serial.close_delay * HZ/100;
+	state->tport.closing_wait = new_serial.closing_wait * HZ/100;
 	tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
@@ -1413,8 +1413,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
-	if (state->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, state->closing_wait);
+	if (state->tport.closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		tty_wait_until_sent(tty, state->tport.closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
@@ -1444,8 +1444,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	tty->closing = 0;
 	state->tport.tty = NULL;
 	if (state->tport.blocked_open) {
-		if (state->close_delay) {
-			msleep_interruptible(jiffies_to_msecs(state->close_delay));
+		if (state->tport.close_delay) {
+			msleep_interruptible(jiffies_to_msecs(state->tport.close_delay));
 		}
 		wake_up_interruptible(&state->tport.open_wait);
 	}
@@ -1863,8 +1863,6 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	state->port = (int)&custom.serdatr; /* Just to give it a value */
 	state->line = 0;
 	state->custom_divisor = 0;
-	state->close_delay = 5*HZ/10;
-	state->closing_wait = 30*HZ;
 	state->icount.cts = state->icount.dsr = 
 	  state->icount.rng = state->icount.dcd = 0;
 	state->icount.rx = state->icount.tx = 0;
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index 32d45b8..997edd0 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -36,8 +36,6 @@ struct serial_state {
 	int	xmit_fifo_size;
 	int	custom_divisor;
 	int	count;
-	unsigned short	close_delay;
-	unsigned short	closing_wait; /* time to wait before closing */
 	struct async_icount	icount;	
 	struct tty_port tport;
 
-- 
1.7.9.2



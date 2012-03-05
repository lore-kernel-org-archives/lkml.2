Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab2CENzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:55:44 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34853 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852Ab2CENx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 39/68] TTY: amiserial/simserial, use count from tty_port
Date: Mon,  5 Mar 2012 14:52:26 +0100
Message-Id: <1330955575-26641-40-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing special. Just remove count from serial_state and change all
users to use tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   24 ++++++++++++------------
 drivers/tty/amiserial.c      |   34 +++++++++++++++++-----------------
 include/linux/serialP.h      |    1 -
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index fb324b3..baa2b1e 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -500,26 +500,26 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		return;
 	}
 #ifdef SIMSERIAL_DEBUG
-	printk("rs_close ttys%d, count = %d\n", info->line, info->count);
+	printk("rs_close ttys%d, count = %d\n", info->line, info->tport.count);
 #endif
-	if ((tty->count == 1) && (info->count != 1)) {
+	if ((tty->count == 1) && (info->tport.count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  info->count should always
+		 * structure will be freed.  info->tport.count should always
 		 * be one in these conditions.  If it's greater than
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
 		printk(KERN_ERR "rs_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
-		info->count = 1;
+		       "info->tport.count is %d\n", info->tport.count);
+		info->tport.count = 1;
 	}
-	if (--info->count < 0) {
+	if (--info->tport.count < 0) {
 		printk(KERN_ERR "rs_close: bad serial port count for ttys%d: %d\n",
-		       info->line, info->count);
-		info->count = 0;
+		       info->line, info->tport.count);
+		info->tport.count = 0;
 	}
-	if (info->count) {
+	if (info->tport.count) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -567,7 +567,7 @@ static void rs_hangup(struct tty_struct *tty)
 		return;
 	shutdown(tty, info);
 
-	info->count = 0;
+	info->tport.count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tport.tty = NULL;
 	wake_up_interruptible(&info->tport.open_wait);
@@ -661,13 +661,13 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	int			retval;
 	unsigned long		page;
 
-	info->count++;
+	info->tport.count++;
 	info->tport.tty = tty;
 	tty->driver_data = info;
 	tty->port = &info->tport;
 
 #ifdef SIMSERIAL_DEBUG
-	printk("rs_open %s, count = %d\n", tty->name, info->count);
+	printk("rs_open %s, count = %d\n", tty->name, info->tport.count);
 #endif
 	tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 06e3a09..8ad64a0 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1383,26 +1383,26 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	}
 
 #ifdef SERIAL_DEBUG_OPEN
-	printk("rs_close ttys%d, count = %d\n", state->line, state->count);
+	printk("rs_close ttys%d, count = %d\n", state->line, state->tport.count);
 #endif
-	if ((tty->count == 1) && (state->count != 1)) {
+	if ((tty->count == 1) && (state->tport.count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  state->count should always
+		 * structure will be freed.  state->tport.count should always
 		 * be one in these conditions.  If it's greater than
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
 		printk("rs_close: bad serial port count; tty->count is 1, "
-		       "state->count is %d\n", state->count);
-		state->count = 1;
+		       "state->tport.count is %d\n", state->tport.count);
+		state->tport.count = 1;
 	}
-	if (--state->count < 0) {
+	if (--state->tport.count < 0) {
 		printk("rs_close: bad serial port count for ttys%d: %d\n",
-		       state->line, state->count);
-		state->count = 0;
+		       state->line, state->tport.count);
+		state->tport.count = 0;
 	}
-	if (state->count) {
+	if (state->tport.count) {
 		DBG_CNT("before DEC-2");
 		local_irq_restore(flags);
 		return;
@@ -1529,7 +1529,7 @@ static void rs_hangup(struct tty_struct *tty)
 
 	rs_flush_buffer(tty);
 	shutdown(tty, info);
-	info->count = 0;
+	info->tport.count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tport.tty = NULL;
 	wake_up_interruptible(&info->tport.open_wait);
@@ -1584,7 +1584,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->count is dropped by one, so that
+	 * this loop, info->tport.count is dropped by one, so that
 	 * rs_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
@@ -1592,12 +1592,12 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	add_wait_queue(&info->tport.open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttys%d, count = %d\n",
-	       info->line, info->count);
+	       info->line, info->tport.count);
 #endif
 	local_irq_save(flags);
 	if (!tty_hung_up_p(filp)) {
 		extra_count = 1;
-		info->count--;
+		info->tport.count--;
 	}
 	local_irq_restore(flags);
 	info->tport.blocked_open++;
@@ -1628,7 +1628,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		}
 #ifdef SERIAL_DEBUG_OPEN
 		printk("block_til_ready blocking: ttys%d, count = %d\n",
-		       info->line, info->count);
+		       info->line, info->tport.count);
 #endif
 		tty_unlock();
 		schedule();
@@ -1637,11 +1637,11 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->tport.open_wait, &wait);
 	if (extra_count)
-		info->count++;
+		info->tport.count++;
 	info->tport.blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready after blocking: ttys%d, count = %d\n",
-	       info->line, info->count);
+	       info->line, info->tport.count);
 #endif
 	if (retval)
 		return retval;
@@ -1660,7 +1660,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	struct serial_state *info = rs_table + tty->index;
 	int retval;
 
-	info->count++;
+	info->tport.count++;
 	info->tport.tty = tty;
 	tty->driver_data = info;
 	tty->port = &info->tport;
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index 997edd0..a6612b9 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -35,7 +35,6 @@ struct serial_state {
 	int	line;
 	int	xmit_fifo_size;
 	int	custom_divisor;
-	int	count;
 	struct async_icount	icount;	
 	struct tty_port tport;
 
-- 
1.7.9.2



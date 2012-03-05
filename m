Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100Ab2CEN71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:59:27 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34814 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab2CENxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:24 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 57/68] TTY: amiserial, stop using serial_state->{irq,type,line}
Date: Mon,  5 Mar 2012 14:52:44 +0100
Message-Id: <1330955575-26641-58-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* instead of line, use tty->index or iterator...
* irq and type are left unset. So get rid of them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   23 ++++++++++-------------
 include/linux/serialP.h |    3 ---
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index a9f5da6..b182bcc 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1008,7 +1008,7 @@ static void rs_unthrottle(struct tty_struct * tty)
  * ------------------------------------------------------------
  */
 
-static int get_serial_info(struct serial_state *state,
+static int get_serial_info(struct tty_struct *tty, struct serial_state *state,
 			   struct serial_struct __user * retinfo)
 {
 	struct serial_struct tmp;
@@ -1017,10 +1017,8 @@ static int get_serial_info(struct serial_state *state,
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
 	tty_lock();
-	tmp.type = state->type;
-	tmp.line = state->line;
+	tmp.line = tty->index;
 	tmp.port = state->port;
-	tmp.irq = state->irq;
 	tmp.flags = state->tport.flags;
 	tmp.xmit_fifo_size = state->xmit_fifo_size;
 	tmp.baud_base = state->baud_base;
@@ -1047,7 +1045,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 	tty_lock();
 	change_spd = ((new_serial.flags ^ port->flags) & ASYNC_SPD_MASK) ||
 		new_serial.custom_divisor != state->custom_divisor;
-	if (new_serial.irq != state->irq || new_serial.port != state->port ||
+	if (new_serial.irq || new_serial.port != state->port ||
 			new_serial.xmit_fifo_size != state->xmit_fifo_size) {
 		tty_unlock();
 		return -EINVAL;
@@ -1250,7 +1248,7 @@ static int rs_ioctl(struct tty_struct *tty,
 
 	switch (cmd) {
 		case TIOCGSERIAL:
-			return get_serial_info(info, argp);
+			return get_serial_info(tty, info, argp);
 		case TIOCSSERIAL:
 			return set_serial_info(tty, info, argp);
 		case TIOCSERCONFIG:
@@ -1403,7 +1401,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	}
 	if (--port->count < 0) {
 		printk("rs_close: bad serial port count for ttys%d: %d\n",
-		       state->line, port->count);
+		       tty->index, port->count);
 		port->count = 0;
 	}
 	if (port->count) {
@@ -1720,12 +1718,13 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
  * /proc fs routines....
  */
 
-static inline void line_info(struct seq_file *m, struct serial_state *state)
+static inline void line_info(struct seq_file *m, int line,
+		struct serial_state *state)
 {
 	char	stat_buf[30], control, status;
 	unsigned long flags;
 
-	seq_printf(m, "%d: uart:amiga_builtin",state->line);
+	seq_printf(m, "%d: uart:amiga_builtin", line);
 
 	local_irq_save(flags);
 	status = ciab.pra;
@@ -1771,7 +1770,7 @@ static inline void line_info(struct seq_file *m, struct serial_state *state)
 static int rs_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "serinfo:1.0 driver:%s\n", serial_version);
-	line_info(m, &rs_table[0]);
+	line_info(m, 0, &rs_table[0]);
 	return 0;
 }
 
@@ -1867,7 +1866,6 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 
 	state = rs_table;
 	state->port = (int)&custom.serdatr; /* Just to give it a value */
-	state->line = 0;
 	state->custom_divisor = 0;
 	state->icount.cts = state->icount.dsr = 
 	  state->icount.rng = state->icount.dcd = 0;
@@ -1876,8 +1874,7 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	state->icount.overrun = state->icount.brk = 0;
 	tty_port_init(&state->tport);
 
-	printk(KERN_INFO "ttyS%d is the amiga builtin serial port\n",
-		       state->line);
+	printk(KERN_INFO "ttyS0 is the amiga builtin serial port\n");
 
 	/* Hardware set up */
 
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index 9a04dec..77afbdb 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -29,9 +29,6 @@
 struct serial_state {
 	int	baud_base;
 	unsigned long	port;
-	int	irq;
-	int	type;
-	int	line;
 	int	xmit_fifo_size;
 	int	custom_divisor;
 	struct async_icount	icount;	
-- 
1.7.9.2



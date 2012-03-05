Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151Ab2CEOAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:00:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34787 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab2CENxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 59/68] TTY: amiserial, provide carrier helpers
Date: Mon,  5 Mar 2012 14:52:46 +0100
Message-Id: <1330955575-26641-60-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for a switch to tty_port_block_til_ready. We
need amiga_carrier_raised and amiga_dtr_rts. The implementation is
taken from startup, shutdown and current block_til_ready.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 613d6a3..61d7461 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1623,10 +1623,8 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	local_irq_restore(flags);
 	port->blocked_open++;
 	while (1) {
-		local_irq_save(flags);
 		if (tty->termios->c_cflag & CBAUD)
-		        rtsdtr_ctrl(SER_DTR|SER_RTS);
-		local_irq_restore(flags);
+			tty_port_raise_dtr_rts(port);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
 		    !(port->flags & ASYNC_INITIALIZED)) {
@@ -1641,7 +1639,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 			break;
 		}
 		if (!(port->flags & ASYNC_CLOSING) &&
-		    (do_clocal || (!(ciab.pra & SER_DCD)) ))
+		    (do_clocal || tty_port_carrier_raised(port)))
 			break;
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
@@ -1849,6 +1847,32 @@ static const struct tty_operations serial_ops = {
 	.proc_fops = &rs_proc_fops,
 };
 
+static int amiga_carrier_raised(struct tty_port *port)
+{
+	return !(ciab.pra & SER_DCD);
+}
+
+static void amiga_dtr_rts(struct tty_port *port, int raise)
+{
+	struct serial_state *info = container_of(port, struct serial_state,
+			tport);
+	unsigned long flags;
+
+	if (raise)
+		info->MCR |= SER_DTR|SER_RTS;
+	else
+		info->MCR &= ~(SER_DTR|SER_RTS);
+
+	local_irq_save(flags);
+	rtsdtr_ctrl(info->MCR);
+	local_irq_restore(flags);
+}
+
+static const struct tty_port_operations amiga_port_ops = {
+	.carrier_raised = amiga_carrier_raised,
+	.dtr_rts = amiga_dtr_rts,
+};
+
 /*
  * The serial driver boot-time initialization code!
  */
@@ -1891,6 +1915,7 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	state->icount.frame = state->icount.parity = 0;
 	state->icount.overrun = state->icount.brk = 0;
 	tty_port_init(&state->tport);
+	state->tport.ops = &amiga_port_ops;
 
 	printk(KERN_INFO "ttyS0 is the amiga builtin serial port\n");
 
-- 
1.7.9.2



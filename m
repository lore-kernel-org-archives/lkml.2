Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab2CEOIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:08:38 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34649 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab2CENxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 48/68] TTY: simserial, use tty_port_close_start
Date: Mon,  5 Mar 2012 14:52:35 +0100
Message-Id: <1330955575-26641-49-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I.e. remove more copied bloat.

The only change is that we wait_until_sent now. Which is what we
really should do.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   36 +-----------------------------------
 1 file changed, 1 insertion(+), 35 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 53db99a..2cd6d23 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -430,45 +430,12 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = tty->driver_data;
 	struct tty_port *port = &info->port;
-	unsigned long flags;
 
 	if (!info)
 		return;
 
-	local_irq_save(flags);
-	if (tty_hung_up_p(filp)) {
-#ifdef SIMSERIAL_DEBUG
-		printk("rs_close: hung_up\n");
-#endif
-		local_irq_restore(flags);
-		return;
-	}
-#ifdef SIMSERIAL_DEBUG
-	printk("rs_close ttys%d, count = %d\n", info->line, port->count);
-#endif
-	if ((tty->count == 1) && (port->count != 1)) {
-		/*
-		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  port->count should always
-		 * be one in these conditions.  If it's greater than
-		 * one, we've got real problems, since it means the
-		 * serial port won't be shutdown.
-		 */
-		printk(KERN_ERR "rs_close: bad serial port count; tty->count is 1, "
-		       "port->count is %d\n", port->count);
-		port->count = 1;
-	}
-	if (--port->count < 0) {
-		printk(KERN_ERR "rs_close: bad serial port count for ttys%d: %d\n",
-		       tty->index, port->count);
-		port->count = 0;
-	}
-	if (port->count) {
-		local_irq_restore(flags);
+	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	}
-	port->flags |= ASYNC_CLOSING;
-	local_irq_restore(flags);
 
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify
@@ -476,7 +443,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 */
 	shutdown(tty, info);
 	rs_flush_buffer(tty);
-	tty_ldisc_flush(tty);
 	port->tty = NULL;
 
 	tty_port_close_end(port, tty);
-- 
1.7.9.2



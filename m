Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209Ab2CEOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:09:59 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34623 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2CENxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 43/68] TTY: simserial, stop using serial_state->{line,icount}
Date: Mon,  5 Mar 2012 14:52:30 +0100
Message-Id: <1330955575-26641-44-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* instead of line, use tty->index or an iterator
* icount is not made public, only the tx path increments it

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 45df0f4..3698a2f 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -176,7 +176,6 @@ static void transmit_chars(struct tty_struct *tty, struct serial_state *info,
 
 		console->write(console, &c, 1);
 
-		info->icount.tx++;
 		info->x_char = 0;
 
 		goto out;
@@ -478,7 +477,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	}
 	if (--info->tport.count < 0) {
 		printk(KERN_ERR "rs_close: bad serial port count for ttys%d: %d\n",
-		       info->line, info->tport.count);
+		       tty->index, info->tport.count);
 		info->tport.count = 0;
 	}
 	if (info->tport.count) {
@@ -669,19 +668,14 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
  * /proc fs routines....
  */
 
-static inline void line_info(struct seq_file *m, struct serial_state *state)
-{
-	seq_printf(m, "%d: uart:16550 port:3F8 irq:%d\n",
-		       state->line, state->irq);
-}
-
 static int rs_proc_show(struct seq_file *m, void *v)
 {
 	int i;
 
 	seq_printf(m, "simserinfo:1.0 driver:%s\n", serial_version);
 	for (i = 0; i < NR_PORTS; i++)
-		line_info(m, &rs_table[i]);
+		seq_printf(m, "%d: uart:16550 port:3F8 irq:%d\n",
+		       i, rs_table[i].irq);
 	return 0;
 }
 
@@ -786,8 +780,7 @@ static int __init simrs_init(void)
 	state->irq = retval;
 
 	/* the port is imaginary */
-	printk(KERN_INFO "ttyS%d at 0x03f8 (irq = %d) is a 16550\n",
-			state->line, state->irq);
+	printk(KERN_INFO "ttyS0 at 0x03f8 (irq = %d) is a 16550\n", state->irq);
 
 	retval = tty_register_driver(hp_simserial_driver);
 	if (retval) {
-- 
1.7.9.2



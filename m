Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab2CENx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:29 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34805 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828Ab2CENxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 55/68] TTY: simserial, final cleanup
Date: Mon,  5 Mar 2012 14:52:42 +0100
Message-Id: <1330955575-26641-56-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove pointless checks (tty cannot be NULL at that points)
* fix some printks (use __func__, print text directly w/o using global
  strings)
* remove some empty lines

This is the last patch for simserial. Overall, the driver is 400 lines
shorter. Being now at 560 lines.

It was tested using ski with a busybox userspace.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 516ad09..c34785d 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -47,9 +47,6 @@ struct serial_state {
 	int x_char;
 };
 
-static char *serial_name = "SimSerial driver";
-static char *serial_version = "0.6";
-
 static struct serial_state rs_table[NR_PORTS];
 
 struct tty_driver *hp_simserial_driver;
@@ -99,7 +96,7 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 	struct tty_struct *tty = tty_port_tty_get(&info->port);
 
 	if (!tty) {
-		printk(KERN_INFO "simrs_interrupt_single: info|tty=0 info=%p problem\n", info);
+		printk(KERN_INFO "%s: tty=0 problem\n", __func__);
 		return IRQ_NONE;
 	}
 	/*
@@ -122,7 +119,7 @@ static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
 
-	if (!tty || !info->xmit.buf)
+	if (!info->xmit.buf)
 		return 0;
 
 	local_irq_save(flags);
@@ -199,7 +196,6 @@ static void rs_flush_chars(struct tty_struct *tty)
 	transmit_chars(tty, info, NULL);
 }
 
-
 static int rs_write(struct tty_struct * tty,
 		    const unsigned char *buf, int count)
 {
@@ -207,7 +203,7 @@ static int rs_write(struct tty_struct * tty,
 	int	c, ret = 0;
 	unsigned long flags;
 
-	if (!tty || !info->xmit.buf)
+	if (!info->xmit.buf)
 		return 0;
 
 	local_irq_save(flags);
@@ -309,7 +305,6 @@ static void rs_unthrottle(struct tty_struct * tty)
 	printk(KERN_INFO "simrs_unthrottle called\n");
 }
 
-
 static int rs_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
@@ -462,7 +457,7 @@ static int rs_proc_show(struct seq_file *m, void *v)
 {
 	int i;
 
-	seq_printf(m, "simserinfo:1.0 driver:%s\n", serial_version);
+	seq_printf(m, "simserinfo:1.0\n");
 	for (i = 0; i < NR_PORTS; i++)
 		seq_printf(m, "%d: uart:16550 port:3F8 irq:%d\n",
 		       i, rs_table[i].irq);
@@ -482,12 +477,6 @@ static const struct file_operations rs_proc_fops = {
 	.release	= single_release,
 };
 
-static inline void show_serial_version(void)
-{
-	printk(KERN_INFO "%s version %s with", serial_name, serial_version);
-	printk(KERN_INFO " no serial options enabled\n");
-}
-
 static const struct tty_operations hp_ops = {
 	.open = rs_open,
 	.close = rs_close,
@@ -523,7 +512,7 @@ static int __init simrs_init(void)
 	if (!hp_simserial_driver)
 		return -ENOMEM;
 
-	show_serial_version();
+	printk(KERN_INFO "SimSerial driver with no serial options enabled\n");
 
 	/* Initialize the tty_driver structure */
 
-- 
1.7.9.2



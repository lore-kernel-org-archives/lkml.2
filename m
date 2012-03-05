Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2CENxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:41 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34862 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964870Ab2CENx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 32/68] TTY: amiserial, remove IRQ_ports
Date: Mon,  5 Mar 2012 14:52:19 +0100
Message-Id: <1330955575-26641-33-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They used to work as a storage for 'info' pointer used in ISRs.  They
are not really needed. Just pass the pointer through request_irq to
the handlers.

It was set to NULL and tested in the ISRs, but we do not need the
tests as we disable all the interrupts at the same places where NULL
sets were.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 5540216..7607c6e 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -100,8 +100,6 @@ static struct tty_driver *serial_driver;
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS 256
 
-static struct async_struct *IRQ_ports;
-
 static unsigned char current_ctl_bits;
 
 static void change_speed(struct async_struct *info, struct ktermios *old);
@@ -439,7 +437,7 @@ static void check_modem_status(struct async_struct *info)
 static irqreturn_t ser_vbl_int( int irq, void *data)
 {
         /* vbl is just a periodic interrupt we tie into to update modem status */
-	struct async_struct * info = IRQ_ports;
+	struct async_struct *info = data;
 	/*
 	 * TBD - is it better to unregister from this interrupt or to
 	 * ignore it if MSI is clear ?
@@ -451,13 +449,13 @@ static irqreturn_t ser_vbl_int( int irq, void *data)
 
 static irqreturn_t ser_rx_int(int irq, void *dev_id)
 {
-	struct async_struct * info;
+	struct serial_state *state = dev_id;
+	struct async_struct *info = state->info;
 
 #ifdef SERIAL_DEBUG_INTR
 	printk("ser_rx_int...");
 #endif
 
-	info = IRQ_ports;
 	if (!info || !info->tty)
 		return IRQ_NONE;
 
@@ -470,14 +468,14 @@ static irqreturn_t ser_rx_int(int irq, void *dev_id)
 
 static irqreturn_t ser_tx_int(int irq, void *dev_id)
 {
-	struct async_struct * info;
+	struct serial_state *state = dev_id;
+	struct async_struct *info = state->info;
 
 	if (custom.serdatr & SDR_TBE) {
 #ifdef SERIAL_DEBUG_INTR
 	  printk("ser_tx_int...");
 #endif
 
-	  info = IRQ_ports;
 	  if (!info || !info->tty)
 		return IRQ_NONE;
 
@@ -554,8 +552,6 @@ static int startup(struct async_struct * info)
 	/* remember current state of the DCD and CTS bits */
 	current_ctl_bits = ciab.pra & (SER_DCD | SER_CTS | SER_DSR);
 
-	IRQ_ports = info;
-
 	info->MCR = 0;
 	if (info->tty->termios->c_cflag & CBAUD)
 	  info->MCR = SER_DTR | SER_RTS;
@@ -619,8 +615,6 @@ static void shutdown(struct async_struct * info)
 	 */
 	wake_up_interruptible(&info->delta_msr_wait);
 
-	IRQ_ports = NULL;
-
 	/*
 	 * Free the IRQ, if necessary
 	 */
@@ -1913,8 +1907,6 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 	if (!serial_driver)
 		return -ENOMEM;
 
-	IRQ_ports = NULL;
-
 	show_serial_version();
 
 	/* Initialize the tty_driver structure */
-- 
1.7.9.2



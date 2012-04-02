Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2DBL4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:00 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48050 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 13/69] TTY: isdn, use tty from tty_port
Date: Mon,  2 Apr 2012 13:53:57 +0200
Message-Id: <1333367693-3244-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No recounting this time, just a plain switch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   41 ++++++++++++++++++++---------------------
 include/linux/isdn.h        |    1 -
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index c81a725..8698856 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -68,7 +68,7 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 	if (!info->online)
 		return 0;
 
-	tty = info->tty;
+	tty = info->port.tty;
 	if (!tty)
 		return 0;
 
@@ -144,7 +144,7 @@ isdn_tty_readmodem(void)
 		if ((info->vonline & 1) && (info->emu.vpar[1]))
 			isdn_audio_eval_silence(info);
 #endif
-		tty = info->tty;
+		tty = info->port.tty;
 		if (tty) {
 			if (info->mcr & UART_MCR_RTS) {
 				/* CISCO AsyncPPP Hack */
@@ -300,7 +300,7 @@ isdn_tty_tint(modem_info *info)
 	len = skb->len;
 	if ((slen = isdn_writebuf_skb_stub(info->isdn_driver,
 					   info->isdn_channel, 1, skb)) == len) {
-		struct tty_struct *tty = info->tty;
+		struct tty_struct *tty = info->port.tty;
 		info->send_outstanding++;
 		info->msr &= ~UART_MSR_CTS;
 		info->lsr &= ~UART_LSR_TEMT;
@@ -705,7 +705,7 @@ isdn_tty_modem_hup(modem_info *info, int local)
 	printk(KERN_DEBUG "Mhup ttyI%d\n", info->line);
 #endif
 	info->rcvsched = 0;
-	isdn_tty_flush_buffer(info->tty);
+	isdn_tty_flush_buffer(info->port.tty);
 	if (info->online) {
 		info->last_lhup = local;
 		info->online = 0;
@@ -1008,15 +1008,15 @@ isdn_tty_change_speed(modem_info *info)
 		quot;
 	int i;
 
-	if (!info->tty || !info->tty->termios)
+	if (!info->port.tty || !info->port.tty->termios)
 		return;
-	cflag = info->tty->termios->c_cflag;
+	cflag = info->port.tty->termios->c_cflag;
 
 	quot = i = cflag & CBAUD;
 	if (i & CBAUDEX) {
 		i &= ~CBAUDEX;
 		if (i < 1 || i > 2)
-			info->tty->termios->c_cflag &= ~CBAUDEX;
+			info->port.tty->termios->c_cflag &= ~CBAUDEX;
 		else
 			i += 15;
 	}
@@ -1069,8 +1069,8 @@ isdn_tty_startup(modem_info *info)
 	 * Now, initialize the UART
 	 */
 	info->mcr = UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2;
-	if (info->tty)
-		clear_bit(TTY_IO_ERROR, &info->tty->flags);
+	if (info->port.tty)
+		clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
 	/*
 	 * and set the speed of the serial port
 	 */
@@ -1096,7 +1096,7 @@ isdn_tty_shutdown(modem_info *info)
 #endif
 	isdn_unlock_drivers();
 	info->msr &= ~UART_MSR_RI;
-	if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
+	if (!info->port.tty || (info->port.tty->termios->c_cflag & HUPCL)) {
 		info->mcr &= ~(UART_MCR_DTR | UART_MCR_RTS);
 		if (info->emu.mdmreg[REG_DTRHUP] & BIT_DTRHUP) {
 			isdn_tty_modem_reset_regs(info, 0);
@@ -1106,8 +1106,8 @@ isdn_tty_shutdown(modem_info *info)
 			isdn_tty_modem_hup(info, 1);
 		}
 	}
-	if (info->tty)
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
+	if (info->port.tty)
+		set_bit(TTY_IO_ERROR, &info->port.tty->flags);
 
 	info->port.flags &= ~ASYNC_INITIALIZED;
 }
@@ -1599,7 +1599,7 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 #endif
 	info->port.count++;
 	tty->driver_data = info;
-	info->tty = tty;
+	info->port.tty = tty;
 	tty->port = &info->port;
 	/*
 	 * Start up serial port
@@ -1692,7 +1692,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	isdn_tty_shutdown(info);
 	isdn_tty_flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->tty = NULL;
+	info->port.tty = NULL;
 	info->ncarrier = 0;
 	tty->closing = 0;
 	if (info->port.blocked_open) {
@@ -1719,7 +1719,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 	isdn_tty_shutdown(info);
 	info->port.count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	info->tty = NULL;
+	info->port.tty = NULL;
 	wake_up_interruptible(&info->port.open_wait);
 }
 
@@ -1894,7 +1894,6 @@ isdn_tty_modem_init(void)
 		isdn_tty_modem_reset_regs(info, 1);
 		info->magic = ISDN_ASYNC_MAGIC;
 		info->line = i;
-		info->tty = NULL;
 		info->x_char = 0;
 		info->isdn_driver = -1;
 		info->isdn_channel = -1;
@@ -2316,7 +2315,7 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 	l = strlen(msg);
 
 	spin_lock_irqsave(&info->readlock, flags);
-	tty = info->tty;
+	tty = info->port.tty;
 	if ((info->port.flags & ASYNC_CLOSING) || (!tty)) {
 		spin_unlock_irqrestore(&info->readlock, flags);
 		return;
@@ -2468,12 +2467,12 @@ isdn_tty_modem_result(int code, modem_info *info)
 #ifdef ISDN_DEBUG_MODEM_HUP
 		printk(KERN_DEBUG "modem_result: NO CARRIER %d %d\n",
 		       (info->port.flags & ASYNC_CLOSING),
-		       (!info->tty));
+		       (!info->port.tty));
 #endif
 		m->mdmreg[REG_RINGCNT] = 0;
 		del_timer(&info->nc_timer);
 		info->ncarrier = 0;
-		if ((info->port.flags & ASYNC_CLOSING) || (!info->tty))
+		if ((info->port.flags & ASYNC_CLOSING) || (!info->port.tty))
 			return;
 
 #ifdef CONFIG_ISDN_AUDIO
@@ -2606,11 +2605,11 @@ isdn_tty_modem_result(int code, modem_info *info)
 		}
 	}
 	if (code == RESULT_NO_CARRIER) {
-		if ((info->port.flags & ASYNC_CLOSING) || (!info->tty))
+		if ((info->port.flags & ASYNC_CLOSING) || (!info->port.tty))
 			return;
 
 		if (info->port.flags & ASYNC_CHECK_CD)
-			tty_hangup(info->tty);
+			tty_hangup(info->port.tty);
 	}
 }
 
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index a4b71fe..95883ac 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -479,7 +479,6 @@ typedef struct modem_info {
   struct T30_s		*fax;		 /* T30 Fax Group 3 data/interface */
   int			faxonline;	 /* Fax-channel status             */
 #endif
-  struct tty_struct 	*tty;            /* Pointer to corresponding tty   */
   atemu                 emu;             /* AT-emulator data               */
   spinlock_t	        readlock;
 } modem_info;
-- 
1.7.9.2



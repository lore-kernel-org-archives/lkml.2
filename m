Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab2DBL4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:43 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48201 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2DBLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 52/69] TTY: 68328serial, remove unused stuff from m68k_serial
Date: Mon,  2 Apr 2012 13:54:36 +0200
Message-Id: <1333367693-3244-53-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not everything from struct m68k_serial is really used. So remove
unused or only-set members of that structure. Next step is to move it
to 68328serial.c and remove 68328serial.h completely.

This change also takes status_handle and batten_down_hatches away
since they use break_abort but do nothing.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |   36 ++++--------------------------------
 drivers/tty/serial/68328serial.h |   16 ----------------
 2 files changed, 4 insertions(+), 48 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index bf5f811..c1cd214 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -213,25 +213,6 @@ static void rs_start(struct tty_struct *tty)
 	local_irq_restore(flags);
 }
 
-/* Drop into either the boot monitor or kadb upon receiving a break
- * from keyboard/console input.
- */
-static void batten_down_hatches(void)
-{
-	/* Drop into the debugger */
-}
-
-static void status_handle(struct m68k_serial *info, unsigned short status)
-{
-	/* If this is console input and this is a
-	 * 'break asserted' status change interrupt
-	 * see if we can drop into the debugger
-	 */
-	if((status & URX_BREAK) && info->break_abort)
-		batten_down_hatches();
-	return;
-}
-
 static void receive_chars(struct m68k_serial *info, unsigned short rx)
 {
 	struct tty_struct *tty = info->tty;
@@ -248,7 +229,6 @@ static void receive_chars(struct m68k_serial *info, unsigned short rx)
 	
 		if(info->is_cons) {
 			if(URX_BREAK & rx) { /* whee, break received */
-				status_handle(info, rx);
 				return;
 #ifdef CONFIG_MAGIC_SYSRQ
 			} else if (ch == 0x10) { /* ^P */
@@ -269,16 +249,13 @@ static void receive_chars(struct m68k_serial *info, unsigned short rx)
 		
 		flag = TTY_NORMAL;
 
-		if(rx & URX_PARITY_ERROR) {
+		if (rx & URX_PARITY_ERROR)
 			flag = TTY_PARITY;
-			status_handle(info, rx);
-		} else if(rx & URX_OVRUN) {
+		else if (rx & URX_OVRUN)
 			flag = TTY_OVERRUN;
-			status_handle(info, rx);
-		} else if(rx & URX_FRAME_ERROR) {
+		else if (rx & URX_FRAME_ERROR)
 			flag = TTY_FRAME;
-			status_handle(info, rx);
-		}
+
 		tty_insert_flip_char(tty, ch, flag);
 #ifndef CONFIG_XCOPILOT_BUGS
 	} while((rx = uart->urx.w) & URX_DATA_READY);
@@ -369,7 +346,6 @@ static int startup(struct m68k_serial * info)
 	 */
 
 	uart->ustcnt = USTCNT_UEN;
-	info->xmit_fifo_size = 1;
 	uart->ustcnt = USTCNT_UEN | USTCNT_RXEN | USTCNT_TXEN;
 	(void)uart->urx.w;
 
@@ -499,7 +475,6 @@ static void change_speed(struct m68k_serial *info)
                 i = (i & ~CBAUDEX) + B38400;
         }
 
-	info->baud = baud_table[i];
 	uart->ubaud = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) | 
 		PUT_FIELD(UBAUD_PRESCALER, hw_baud_table[i].prescale);
 
@@ -1034,7 +1009,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	info->event = 0;
 	info->tty = NULL;
 #warning "This is not and has never been valid so fix it"	
 #if 0
@@ -1070,7 +1044,6 @@ void rs_hangup(struct tty_struct *tty)
 	
 	rs_flush_buffer(tty);
 	shutdown(info);
-	info->event = 0;
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
@@ -1270,7 +1243,6 @@ rs68328_init(void)
 	    info->close_delay = 50;
 	    info->closing_wait = 3000;
 	    info->x_char = 0;
-	    info->event = 0;
 	    info->count = 0;
 	    info->blocked_open = 0;
 	    init_waitqueue_head(&info->open_wait);
diff --git a/drivers/tty/serial/68328serial.h b/drivers/tty/serial/68328serial.h
index a804ea5..971ead5 100644
--- a/drivers/tty/serial/68328serial.h
+++ b/drivers/tty/serial/68328serial.h
@@ -60,16 +60,7 @@
  */
 
 struct m68k_serial {
-	char soft_carrier;  /* Use soft carrier on this channel */
-	char break_abort;   /* Is serial console in, so process brk/abrt */
 	char is_cons;       /* Is this our console. */
-
-	/* We need to know the current clock divisor
-	 * to read the bps rate the chip has currently
-	 * loaded.
-	 */
-	unsigned char clk_divisor;  /* May be 1, 16, 32, or 64 */
-	int baud;
 	int			magic;
 	int			baud_base;
 	int			port;
@@ -77,17 +68,10 @@ struct m68k_serial {
 	int			flags; 		/* defined in tty.h */
 	int			type; 		/* UART type */
 	struct tty_struct 	*tty;
-	int			read_status_mask;
-	int			ignore_status_mask;
-	int			timeout;
-	int			xmit_fifo_size;
 	int			custom_divisor;
 	int			x_char;	/* xon/xoff character */
 	int			close_delay;
 	unsigned short		closing_wait;
-	unsigned short		closing_wait2;
-	unsigned long		event;
-	unsigned long		last_active;
 	int			line;
 	int			count;	    /* # of fd on device */
 	int			blocked_open; /* # of blocked opens */
-- 
1.7.9.2



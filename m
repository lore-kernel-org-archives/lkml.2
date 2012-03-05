Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab2CENyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:54:44 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34898 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab2CENxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 36/68] TTY: simserial, pass tty down to functions
Date: Mon,  5 Mar 2012 14:52:23 +0100
Message-Id: <1330955575-26641-37-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids pain with tty refcounting and touching tty_port in the
future. It allows us to remove some state->tty tests because the tty
passed down to them can never be NULL.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   50 ++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 7b6e60e..a76a27e 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -202,7 +202,8 @@ static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 	return 1;
 }
 
-static void transmit_chars(struct serial_state *info, int *intr_done)
+static void transmit_chars(struct tty_struct *tty, struct serial_state *info,
+		int *intr_done)
 {
 	int count;
 	unsigned long flags;
@@ -220,10 +221,11 @@ static void transmit_chars(struct serial_state *info, int *intr_done)
 		goto out;
 	}
 
-	if (info->xmit.head == info->xmit.tail || info->tty->stopped || info->tty->hw_stopped) {
+	if (info->xmit.head == info->xmit.tail || tty->stopped ||
+			tty->hw_stopped) {
 #ifdef SIMSERIAL_DEBUG
 		printk("transmit_chars: head=%d, tail=%d, stopped=%d\n",
-		       info->xmit.head, info->xmit.tail, info->tty->stopped);
+		       info->xmit.head, info->xmit.tail, tty->stopped);
 #endif
 		goto out;
 	}
@@ -261,7 +263,7 @@ static void rs_flush_chars(struct tty_struct *tty)
 	    !info->xmit.buf)
 		return;
 
-	transmit_chars(info, NULL);
+	transmit_chars(tty, info, NULL);
 }
 
 
@@ -295,7 +297,7 @@ static int rs_write(struct tty_struct * tty,
 	 */
 	if (CIRC_CNT(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE)
 	    && !tty->stopped && !tty->hw_stopped) {
-		transmit_chars(info, NULL);
+		transmit_chars(tty, info, NULL);
 	}
 	return ret;
 }
@@ -340,7 +342,7 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
 		 * I guess we could call console->write() directly but
 		 * let's do that for now.
 		 */
-		transmit_chars(info, NULL);
+		transmit_chars(tty, info, NULL);
 	}
 }
 
@@ -442,7 +444,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct serial_state *info)
+static void shutdown(struct tty_struct *tty, struct serial_state *info)
 {
 	unsigned long	flags;
 
@@ -464,7 +466,7 @@ static void shutdown(struct serial_state *info)
 			info->xmit.buf = NULL;
 		}
 
-		if (info->tty) set_bit(TTY_IO_ERROR, &info->tty->flags);
+		set_bit(TTY_IO_ERROR, &tty->flags);
 
 		info->flags &= ~ASYNC_INITIALIZED;
 	}
@@ -528,7 +530,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * Now we wait for the transmit buffer to clear; and we notify
 	 * the line discipline to only process XON/XOFF characters.
 	 */
-	shutdown(info);
+	shutdown(tty, info);
 	rs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	info->tty = NULL;
@@ -563,7 +565,7 @@ static void rs_hangup(struct tty_struct *tty)
 	rs_flush_buffer(tty);
 	if (info->flags & ASYNC_CLOSING)
 		return;
-	shutdown(info);
+	shutdown(tty, info);
 
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
@@ -572,7 +574,7 @@ static void rs_hangup(struct tty_struct *tty)
 }
 
 
-static int startup(struct serial_state *state)
+static int startup(struct tty_struct *tty, struct serial_state *state)
 {
 	unsigned long flags;
 	int	retval=0;
@@ -590,8 +592,7 @@ static int startup(struct serial_state *state)
 	}
 
 	if (!state->port || !state->type) {
-		if (state->tty)
-			set_bit(TTY_IO_ERROR, &state->tty->flags);
+		set_bit(TTY_IO_ERROR, &tty->flags);
 		free_page(page);
 		goto errout;
 	}
@@ -614,8 +615,7 @@ static int startup(struct serial_state *state)
 			goto errout;
 	}
 
-	if (state->tty)
-		clear_bit(TTY_IO_ERROR, &state->tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 
 	state->xmit.head = state->xmit.tail = 0;
 
@@ -630,16 +630,14 @@ static int startup(struct serial_state *state)
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
-	if (state->tty) {
-		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			state->tty->alt_speed = 57600;
-		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			state->tty->alt_speed = 115200;
-		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-			state->tty->alt_speed = 230400;
-		if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-			state->tty->alt_speed = 460800;
-	}
+	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		tty->alt_speed = 57600;
+	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		tty->alt_speed = 115200;
+	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		tty->alt_speed = 230400;
+	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		tty->alt_speed = 460800;
 
 	state->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
@@ -699,7 +697,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * Start up serial port
 	 */
-	retval = startup(info);
+	retval = startup(tty, info);
 	if (retval) {
 		return retval;
 	}
-- 
1.7.9.2



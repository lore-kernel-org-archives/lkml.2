Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3ACOxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:53:35 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60982 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] cyclades: push down tty_port_tty_get
Date: Thu,  3 Jan 2013 15:53:08 +0100
Message-Id: <1357224789-2853-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, the tty is not needed at all places in the ISR. So we can just
request in on demand when really needed.

This cleans TX and RX paths a bit as the indentation level can be
dropped by two now when we also invert the char_count if condition.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/cyclades.c | 237 ++++++++++++++++++++++++-------------------------
 1 file changed, 115 insertions(+), 122 deletions(-)

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 42a329b..345bd0e 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -917,7 +917,7 @@ cyz_issue_cmd(struct cyclades_card *cinfo,
 	return 0;
 }				/* cyz_issue_cmd */
 
-static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
+static void cyz_handle_rx(struct cyclades_port *info)
 {
 	struct BUF_CTRL __iomem *buf_ctrl = info->u.cyz.buf_ctrl;
 	struct cyclades_card *cinfo = info->card;
@@ -940,80 +940,77 @@ static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty)
 	else
 		char_count = rx_put - rx_get + rx_bufsize;
 
-	if (char_count) {
+	if (!char_count)
+		return;
+
 #ifdef CY_ENABLE_MONITORING
-		info->mon.int_count++;
-		info->mon.char_count += char_count;
-		if (char_count > info->mon.char_max)
-			info->mon.char_max = char_count;
-		info->mon.char_last = char_count;
+	info->mon.int_count++;
+	info->mon.char_count += char_count;
+	if (char_count > info->mon.char_max)
+		info->mon.char_max = char_count;
+	info->mon.char_last = char_count;
 #endif
-		if (tty == NULL) {
-			/* flush received characters */
-			new_rx_get = (new_rx_get + char_count) &
-					(rx_bufsize - 1);
-			info->rflush_count++;
-		} else {
+
 #ifdef BLOCKMOVE
-		/* we'd like to use memcpy(t, f, n) and memset(s, c, count)
-		   for performance, but because of buffer boundaries, there
-		   may be several steps to the operation */
-			while (1) {
-				len = tty_prepare_flip_string(port, &buf,
-						char_count);
-				if (!len)
-					break;
+	/* we'd like to use memcpy(t, f, n) and memset(s, c, count)
+	   for performance, but because of buffer boundaries, there
+	   may be several steps to the operation */
+	while (1) {
+		len = tty_prepare_flip_string(port, &buf,
+				char_count);
+		if (!len)
+			break;
 
-				len = min_t(unsigned int, min(len, char_count),
-						rx_bufsize - new_rx_get);
+		len = min_t(unsigned int, min(len, char_count),
+				rx_bufsize - new_rx_get);
 
-				memcpy_fromio(buf, cinfo->base_addr +
-						rx_bufaddr + new_rx_get, len);
+		memcpy_fromio(buf, cinfo->base_addr +
+				rx_bufaddr + new_rx_get, len);
 
-				new_rx_get = (new_rx_get + len) &
-						(rx_bufsize - 1);
-				char_count -= len;
-				info->icount.rx += len;
-				info->idle_stats.recv_bytes += len;
-			}
+		new_rx_get = (new_rx_get + len) &
+				(rx_bufsize - 1);
+		char_count -= len;
+		info->icount.rx += len;
+		info->idle_stats.recv_bytes += len;
+	}
 #else
-			len = tty_buffer_request_room(port, char_count);
-			while (len--) {
-				data = readb(cinfo->base_addr + rx_bufaddr +
-						new_rx_get);
-				new_rx_get = (new_rx_get + 1) &
-							(rx_bufsize - 1);
-				tty_insert_flip_char(port, data, TTY_NORMAL);
-				info->idle_stats.recv_bytes++;
-				info->icount.rx++;
-			}
+	len = tty_buffer_request_room(port, char_count);
+	while (len--) {
+		data = readb(cinfo->base_addr + rx_bufaddr +
+				new_rx_get);
+		new_rx_get = (new_rx_get + 1) &
+					(rx_bufsize - 1);
+		tty_insert_flip_char(port, data, TTY_NORMAL);
+		info->idle_stats.recv_bytes++;
+		info->icount.rx++;
+	}
 #endif
 #ifdef CONFIG_CYZ_INTR
-		/* Recalculate the number of chars in the RX buffer and issue
-		   a cmd in case it's higher than the RX high water mark */
-			rx_put = readl(&buf_ctrl->rx_put);
-			if (rx_put >= rx_get)
-				char_count = rx_put - rx_get;
-			else
-				char_count = rx_put - rx_get + rx_bufsize;
-			if (char_count >= readl(&buf_ctrl->rx_threshold) &&
-					!timer_pending(&cyz_rx_full_timer[
-							info->line]))
-				mod_timer(&cyz_rx_full_timer[info->line],
-						jiffies + 1);
+	/* Recalculate the number of chars in the RX buffer and issue
+	   a cmd in case it's higher than the RX high water mark */
+	rx_put = readl(&buf_ctrl->rx_put);
+	if (rx_put >= rx_get)
+		char_count = rx_put - rx_get;
+	else
+		char_count = rx_put - rx_get + rx_bufsize;
+	if (char_count >= readl(&buf_ctrl->rx_threshold) &&
+			!timer_pending(&cyz_rx_full_timer[
+					info->line]))
+		mod_timer(&cyz_rx_full_timer[info->line],
+				jiffies + 1);
 #endif
-			info->idle_stats.recv_idle = jiffies;
-			tty_schedule_flip(&info->port);
-		}
-		/* Update rx_get */
-		cy_writel(&buf_ctrl->rx_get, new_rx_get);
-	}
+	info->idle_stats.recv_idle = jiffies;
+	tty_schedule_flip(&info->port);
+
+	/* Update rx_get */
+	cy_writel(&buf_ctrl->rx_get, new_rx_get);
 }
 
-static void cyz_handle_tx(struct cyclades_port *info, struct tty_struct *tty)
+static void cyz_handle_tx(struct cyclades_port *info)
 {
 	struct BUF_CTRL __iomem *buf_ctrl = info->u.cyz.buf_ctrl;
 	struct cyclades_card *cinfo = info->card;
+	struct tty_struct *tty;
 	u8 data;
 	unsigned int char_count;
 #ifdef BLOCKMOVE
@@ -1033,63 +1030,63 @@ static void cyz_handle_tx(struct cyclades_port *info, struct tty_struct *tty)
 	else
 		char_count = tx_get - tx_put - 1;
 
-	if (char_count) {
-
-		if (tty == NULL)
-			goto ztxdone;
+	if (!char_count)
+		return;
+		
+	tty = tty_port_tty_get(&info->port);
+	if (tty == NULL)
+		goto ztxdone;
 
-		if (info->x_char) {	/* send special char */
-			data = info->x_char;
+	if (info->x_char) {	/* send special char */
+		data = info->x_char;
 
-			cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
-			tx_put = (tx_put + 1) & (tx_bufsize - 1);
-			info->x_char = 0;
-			char_count--;
-			info->icount.tx++;
-		}
+		cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
+		tx_put = (tx_put + 1) & (tx_bufsize - 1);
+		info->x_char = 0;
+		char_count--;
+		info->icount.tx++;
+	}
 #ifdef BLOCKMOVE
-		while (0 < (small_count = min_t(unsigned int,
-				tx_bufsize - tx_put, min_t(unsigned int,
-					(SERIAL_XMIT_SIZE - info->xmit_tail),
-					min_t(unsigned int, info->xmit_cnt,
-						char_count))))) {
-
-			memcpy_toio((char *)(cinfo->base_addr + tx_bufaddr +
-					tx_put),
-					&info->port.xmit_buf[info->xmit_tail],
-					small_count);
-
-			tx_put = (tx_put + small_count) & (tx_bufsize - 1);
-			char_count -= small_count;
-			info->icount.tx += small_count;
-			info->xmit_cnt -= small_count;
-			info->xmit_tail = (info->xmit_tail + small_count) &
-					(SERIAL_XMIT_SIZE - 1);
-		}
+	while (0 < (small_count = min_t(unsigned int,
+			tx_bufsize - tx_put, min_t(unsigned int,
+				(SERIAL_XMIT_SIZE - info->xmit_tail),
+				min_t(unsigned int, info->xmit_cnt,
+					char_count))))) {
+
+		memcpy_toio((char *)(cinfo->base_addr + tx_bufaddr + tx_put),
+				&info->port.xmit_buf[info->xmit_tail],
+				small_count);
+
+		tx_put = (tx_put + small_count) & (tx_bufsize - 1);
+		char_count -= small_count;
+		info->icount.tx += small_count;
+		info->xmit_cnt -= small_count;
+		info->xmit_tail = (info->xmit_tail + small_count) &
+				(SERIAL_XMIT_SIZE - 1);
+	}
 #else
-		while (info->xmit_cnt && char_count) {
-			data = info->port.xmit_buf[info->xmit_tail];
-			info->xmit_cnt--;
-			info->xmit_tail = (info->xmit_tail + 1) &
-					(SERIAL_XMIT_SIZE - 1);
-
-			cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
-			tx_put = (tx_put + 1) & (tx_bufsize - 1);
-			char_count--;
-			info->icount.tx++;
-		}
+	while (info->xmit_cnt && char_count) {
+		data = info->port.xmit_buf[info->xmit_tail];
+		info->xmit_cnt--;
+		info->xmit_tail = (info->xmit_tail + 1) &
+				(SERIAL_XMIT_SIZE - 1);
+
+		cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
+		tx_put = (tx_put + 1) & (tx_bufsize - 1);
+		char_count--;
+		info->icount.tx++;
+	}
 #endif
-		tty_wakeup(tty);
+	tty_wakeup(tty);
+	tty_kref_put(tty);
 ztxdone:
-		/* Update tx_put */
-		cy_writel(&buf_ctrl->tx_put, tx_put);
-	}
+	/* Update tx_put */
+	cy_writel(&buf_ctrl->tx_put, tx_put);
 }
 
 static void cyz_handle_cmd(struct cyclades_card *cinfo)
 {
 	struct BOARD_CTRL __iomem *board_ctrl = cinfo->board_ctrl;
-	struct tty_struct *tty;
 	struct cyclades_port *info;
 	__u32 channel, param, fw_ver;
 	__u8 cmd;
@@ -1102,9 +1099,6 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 		special_count = 0;
 		delta_count = 0;
 		info = &cinfo->ports[channel];
-		tty = tty_port_tty_get(&info->port);
-		if (tty == NULL)
-			continue;
 
 		switch (cmd) {
 		case C_CM_PR_ERROR:
@@ -1130,8 +1124,14 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 					readl(&info->u.cyz.ch_ctrl->rs_status);
 				if (dcd & C_RS_DCD)
 					wake_up_interruptible(&info->port.open_wait);
-				else
-					tty_hangup(tty);
+				else {
+					struct tty_struct *tty;
+					tty = tty_port_tty_get(&info->port);
+					if (tty) {
+						tty_hangup(tty);
+						tty_kref_put(tty);
+					}
+				}
 			}
 			break;
 		case C_CM_MCTS:
@@ -1160,7 +1160,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			printk(KERN_DEBUG "cyz_interrupt: rcvd intr, card %d, "
 					"port %ld\n", info->card, channel);
 #endif
-			cyz_handle_rx(info, tty);
+			cyz_handle_rx(info);
 			break;
 		case C_CM_TXBEMPTY:
 		case C_CM_TXLOWWM:
@@ -1170,7 +1170,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			printk(KERN_DEBUG "cyz_interrupt: xmit intr, card %d, "
 					"port %ld\n", info->card, channel);
 #endif
-			cyz_handle_tx(info, tty);
+			cyz_handle_tx(info);
 			break;
 #endif				/* CONFIG_CYZ_INTR */
 		case C_CM_FATAL:
@@ -1183,7 +1183,6 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			wake_up_interruptible(&info->port.delta_msr_wait);
 		if (special_count)
 			tty_schedule_flip(&info->port);
-		tty_kref_put(tty);
 	}
 }
 
@@ -1249,17 +1248,11 @@ static void cyz_poll(unsigned long arg)
 		cyz_handle_cmd(cinfo);
 
 		for (port = 0; port < cinfo->nports; port++) {
-			struct tty_struct *tty;
-
 			info = &cinfo->ports[port];
-			tty = tty_port_tty_get(&info->port);
-			/* OK to pass NULL to the handle functions below.
-			   They need to drop the data in that case. */
 
 			if (!info->throttle)
-				cyz_handle_rx(info, tty);
-			cyz_handle_tx(info, tty);
-			tty_kref_put(tty);
+				cyz_handle_rx(info);
+			cyz_handle_tx(info);
 		}
 		/* poll every 'cyz_polling_cycle' period */
 		expires = jiffies + cyz_polling_cycle;
-- 
1.8.1



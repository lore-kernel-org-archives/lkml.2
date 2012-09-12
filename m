Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab2ILNAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:00:55 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161Ab2ILMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqACACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIQEFJ1IQUVcGE4gRvGKRUgOVX5MH
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511803"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 21/24] Staging: ipack/devices/ipoctal: read more than one character from RX FIFO.
Date: Wed, 12 Sep 2012 14:55:43 +0200
Message-Id: <1347454546-23236-21-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RX FIFO has a size of 3 characters. Check if when we are picking the
oldest one, we have more to read.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   60 ++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 8b2be61..4f79fad 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -134,33 +134,45 @@ static int ipoctal_get_icount(struct tty_struct *tty,
 static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 			   struct tty_struct *tty, u8 sr)
 {
-	unsigned char value = ioread8(&channel->regs->r.rhr);
+	unsigned char value;
 	unsigned char flag = TTY_NORMAL;
-
-	/* Error: count statistics */
-	if (sr & SR_ERROR) {
-		iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-
-		if (sr & SR_OVERRUN_ERROR) {
-			channel->stats.overrun_err++;
-			/* Overrun doesn't affect the current character*/
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		}
-		if (sr & SR_PARITY_ERROR) {
-			channel->stats.parity_err++;
-			flag = TTY_PARITY;
-		}
-		if (sr & SR_FRAMING_ERROR) {
-			channel->stats.framing_err++;
-			flag = TTY_FRAME;
+	u8 isr;
+
+	do {
+		value = ioread8(&channel->regs->r.rhr);
+		/* Error: count statistics */
+		if (sr & SR_ERROR) {
+			iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+
+			if (sr & SR_OVERRUN_ERROR) {
+				channel->stats.overrun_err++;
+				/* Overrun doesn't affect the current character*/
+				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			}
+			if (sr & SR_PARITY_ERROR) {
+				channel->stats.parity_err++;
+				flag = TTY_PARITY;
+			}
+			if (sr & SR_FRAMING_ERROR) {
+				channel->stats.framing_err++;
+				flag = TTY_FRAME;
+			}
+			if (sr & SR_RECEIVED_BREAK) {
+				channel->stats.rcv_break++;
+				flag = TTY_BREAK;
+			}
 		}
-		if (sr & SR_RECEIVED_BREAK) {
-			channel->stats.rcv_break++;
-			flag = TTY_BREAK;
-		}
-	}
+		tty_insert_flip_char(tty, value, flag);
 
-	tty_insert_flip_char(tty, value, flag);
+		/* Check if there are more characters in RX FIFO
+		 * If there are more, the isr register for this channel
+		 * has enabled the RxRDY|FFULL bit.
+		 */
+		isr = ioread8(&channel->block_regs->r.isr);
+		sr = ioread8(&channel->regs->r.sr);
+	} while (isr & channel->isr_rx_rdy_mask);
+
+	tty_flip_buffer_push(tty);
 }
 
 static void ipoctal_irq_tx(struct ipoctal_channel *channel)
-- 
1.7.10.4


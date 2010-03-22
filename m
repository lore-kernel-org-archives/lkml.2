Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0CVHXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:23:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49628 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0CVHXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:23:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/5] i2c-bfin-twi: fix lost interrupts at high speeds
Date: Mon, 22 Mar 2010 03:23:18 -0400
Message-Id: <1269242600-30147-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
References: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

i2c event of next read/write byte may trigger before current int state
is cleared in the interrupt handler. So, this should be done at the
beginning of interrupt handler to avoid losing new i2c events.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   37 +++++++++++++------------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 758bb1f..3495019 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -80,14 +80,15 @@ static const u16 pin_req[2][3] = {
 	{P_TWI1_SCL, P_TWI1_SDA, 0},
 };
 
-static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
+static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
+					unsigned short twi_int_status)
 {
-	unsigned short twi_int_status = read_INT_STAT(iface);
 	unsigned short mast_stat = read_MASTER_STAT(iface);
 
 	if (twi_int_status & XMTSERV) {
 		/* Transmit next data */
 		if (iface->writeNum > 0) {
+			SSYNC();
 			write_XMT_DATA8(iface, *(iface->transPtr++));
 			iface->writeNum--;
 		}
@@ -109,10 +110,6 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 				write_MASTER_CTL(iface,
 					(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
 		}
-		SSYNC();
-		/* Clear status */
-		write_INT_STAT(iface, XMTSERV);
-		SSYNC();
 	}
 	if (twi_int_status & RCVSERV) {
 		if (iface->readNum > 0) {
@@ -134,7 +131,6 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 		} else if (iface->manual_stop) {
 			write_MASTER_CTL(iface,
 				read_MASTER_CTL(iface) | STOP);
-			SSYNC();
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 		           iface->cur_msg + 1 < iface->msg_num) {
 			if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
@@ -143,18 +139,12 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			else
 				write_MASTER_CTL(iface,
 					(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
-			SSYNC();
 		}
-		/* Clear interrupt source */
-		write_INT_STAT(iface, RCVSERV);
-		SSYNC();
 	}
 	if (twi_int_status & MERR) {
-		write_INT_STAT(iface, MERR);
 		write_INT_MASK(iface, 0);
 		write_MASTER_STAT(iface, 0x3e);
 		write_MASTER_CTL(iface, 0);
-		SSYNC();
 		iface->result = -EIO;
 
 		if (mast_stat & LOSTARB)
@@ -172,10 +162,6 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 		 * results.
 		 */
 		if (twi_int_status & MCOMP) {
-			write_INT_STAT(iface, MCOMP);
-			write_INT_MASK(iface, 0);
-			write_MASTER_CTL(iface, 0);
-			SSYNC();
 			/* If it is a quick transfer, only address without data,
 			 * not an err, return 1.
 			 * If address is acknowledged return 1.
@@ -188,8 +174,6 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 		return;
 	}
 	if (twi_int_status & MCOMP) {
-		write_INT_STAT(iface, MCOMP);
-		SSYNC();
 		if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
 			if (iface->readNum == 0) {
 				/* set the read number to 1 and ask for manual
@@ -211,7 +195,6 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			/* remove restart bit and enable master receive */
 			write_MASTER_CTL(iface,
 				read_MASTER_CTL(iface) & ~RSTART);
-			SSYNC();
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
 				iface->cur_msg+1 < iface->msg_num) {
 			iface->cur_msg++;
@@ -230,7 +213,6 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 					write_XMT_DATA8(iface,
 						*(iface->transPtr++));
 					iface->writeNum--;
-					SSYNC();
 				}
 			}
 
@@ -248,12 +230,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			/* remove restart bit and enable master receive */
 			write_MASTER_CTL(iface,
 				read_MASTER_CTL(iface) & ~RSTART);
-			SSYNC();
 		} else {
 			iface->result = 1;
 			write_INT_MASK(iface, 0);
 			write_MASTER_CTL(iface, 0);
-			SSYNC();
 		}
 	}
 	complete(&iface->complete);
@@ -264,9 +244,18 @@ static irqreturn_t bfin_twi_interrupt_entry(int irq, void *dev_id)
 {
 	struct bfin_twi_iface *iface = dev_id;
 	unsigned long flags;
+	unsigned short twi_int_status;
 
 	spin_lock_irqsave(&iface->lock, flags);
-	bfin_twi_handle_interrupt(iface);
+	while (1) {
+		twi_int_status = read_INT_STAT(iface);
+		if (!twi_int_status)
+			break;
+		/* Clear interrupt status */
+		write_INT_STAT(iface, twi_int_status);
+		bfin_twi_handle_interrupt(iface, twi_int_status);
+		SSYNC();
+	}
 	spin_unlock_irqrestore(&iface->lock, flags);
 	return IRQ_HANDLED;
 }
-- 
1.7.0.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2FMI2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:28:12 -0400
Received: from [65.55.88.11] ([65.55.88.11]:57978 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab2FMI2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:02 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/8 v2] i2c: i2c-bfin-twi: Improve the patch for bug "Illegal i2c bus lock upon certain transfer scenarios".
Date: Wed, 13 Jun 2012 16:22:41 +0800
Message-ID: <1339575767-22985-2-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
References: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

For transfer counts > 255 bytes i2c-bfin-twi sets the data
transfer counter DCNT to 0xFF indicating unlimited transfers.
It then uses a flag iface->manual_stop to manually issue the STOP
condition, once the required amount of bytes are received.

We found that on I2C receive operation issuing the STOP condition
together with a FULL RCV FIFO (2bytes) will cause SDA and SCL be
constantly driven low.

This patch stops receiving operation immediately in last rx interrupt.
This patch also wakes up waiting process when transfer completes.
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   43 ++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 33031f0..dbe8fa0 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -130,21 +130,25 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 			}
 			iface->transPtr++;
 			iface->readNum--;
-		} else if (iface->manual_stop) {
-			/* Temporary workaround to avoid possible bus stall -
-			 * Flush FIFO before issuing the STOP condition
-			 */
-			read_RCV_DATA16(iface);
-			write_MASTER_CTL(iface,
-				read_MASTER_CTL(iface) | STOP);
-		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
-		           iface->cur_msg + 1 < iface->msg_num) {
-			if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
-				write_MASTER_CTL(iface,
-					read_MASTER_CTL(iface) | RSTART | MDIR);
-			else
+		}
+
+		if (iface->readNum == 0) {
+			if (iface->manual_stop) {
+				/* Temporary workaround to avoid possible bus stall -
+				 * Flush FIFO before issuing the STOP condition
+				 */
+				read_RCV_DATA16(iface);
 				write_MASTER_CTL(iface,
-					(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
+					read_MASTER_CTL(iface) | STOP);
+			} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
+					iface->cur_msg + 1 < iface->msg_num) {
+				if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
+					write_MASTER_CTL(iface,
+						read_MASTER_CTL(iface) | RSTART | MDIR);
+				else
+					write_MASTER_CTL(iface,
+						(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
+			}
 		}
 	}
 	if (twi_int_status & MERR) {
@@ -245,12 +249,13 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 				}
 			}
 
-			if (iface->pmsg[iface->cur_msg].len <= 255)
-					write_MASTER_CTL(iface,
+			if (iface->pmsg[iface->cur_msg].len <= 255) {
+				write_MASTER_CTL(iface,
 					(read_MASTER_CTL(iface) &
 					(~(0xff << 6))) |
-				(iface->pmsg[iface->cur_msg].len << 6));
-			else {
+					(iface->pmsg[iface->cur_msg].len << 6));
+				iface->manual_stop = 0;
+			} else {
 				write_MASTER_CTL(iface,
 					(read_MASTER_CTL(iface) |
 					(0xff << 6)));
@@ -264,8 +269,8 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 			write_INT_MASK(iface, 0);
 			write_MASTER_CTL(iface, 0);
 		}
+		complete(&iface->complete);
 	}
-	complete(&iface->complete);
 }
 
 /* Interrupt handler */
-- 
1.7.0.4



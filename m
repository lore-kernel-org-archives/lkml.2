Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab2EPHb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:31:29 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:45588
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759538Ab2EPHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:31:27 -0400
X-SpamScore: 7
X-BigFish: VPS7(z5c5ozzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/8] i2c: i2c-bfin-twi: Stop receiving operation immediately in last rx interrupt.
Date: Wed, 16 May 2012 15:20:20 +0800
Message-ID: <1337152826-9850-2-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Also wake up waiting process when transfer completes.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

git-svn-id: svn://localhost/svn/linux-kernel/trunk@9105 526b6c2d-f592-4532-a319-5dd88ccb003d
---
 drivers/i2c/busses/i2c-bfin-twi.c |   43 ++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index e6dd3c9..376e331 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -130,21 +130,25 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 			}
 			iface->transPtr++;
 			iface->readNum--;
-		} else if (iface->manual_stop) {
-			/* Avoid possible bus stall -
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
+				/* Avoid possible bus stall -
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



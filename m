Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2EPHbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:31:38 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:8956
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759501Ab2EPHb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:31:28 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 5/8] i2c:i2c-bfin-twi: TWI fails to restart next transfer in high system load.
Date: Wed, 16 May 2012 15:20:23 +0800
Message-ID: <1337152826-9850-5-git-send-email-sonic.zhang@analog.com>
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

Current driver was developed based on BF537 0.2 HRM. In high system load, BUFRDERR error
interrupt may be raised if XMTSERV interrupt of last TX byte is not served in time
(set RSTART bit), which breaks restart tranfer as expected.

"Buffer Read Error (BUFRDERR)" description in Blackfin HRM only applys to BF537
rev. < 0.3. In later rev. and later announced Blackfin chips, such as BF527 and
BF548, a new TWI master feature "Clock Stretching" is added into the TWI controller,
BUFRDERR interrupt is not triggered after TX FIFO is empty.

This patch sets RSTART bit at the beginning of the first transfer. The SCL and SDA
is hold till XMTSERV interrupt of last TX byte is served. Restart transfer is not broken
in high system load.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 63fb84f..594bbb1 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -99,7 +99,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 		 */
 		else if (iface->cur_mode == TWI_I2C_MODE_COMBINED)
 			write_MASTER_CTL(iface,
-				read_MASTER_CTL(iface) | MDIR | RSTART);
+				read_MASTER_CTL(iface) | MDIR);
 		else if (iface->manual_stop)
 			write_MASTER_CTL(iface,
 				read_MASTER_CTL(iface) | STOP);
@@ -107,10 +107,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 		         iface->cur_msg + 1 < iface->msg_num) {
 			if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
 				write_MASTER_CTL(iface,
-					read_MASTER_CTL(iface) | RSTART | MDIR);
+					read_MASTER_CTL(iface) | MDIR);
 			else
 				write_MASTER_CTL(iface,
-					(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
+					read_MASTER_CTL(iface) & ~MDIR);
 		}
 	}
 	if (twi_int_status & RCVSERV) {
@@ -144,10 +144,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 					iface->cur_msg + 1 < iface->msg_num) {
 				if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
 					write_MASTER_CTL(iface,
-						read_MASTER_CTL(iface) | RSTART | MDIR);
+						read_MASTER_CTL(iface) | MDIR);
 				else
 					write_MASTER_CTL(iface,
-						(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
+						read_MASTER_CTL(iface) & ~MDIR);
 			}
 		}
 	}
@@ -262,9 +262,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 					(0xff << 6)));
 				iface->manual_stop = 1;
 			}
-			/* remove restart bit and enable master receive */
-			write_MASTER_CTL(iface,
-				read_MASTER_CTL(iface) & ~RSTART);
+			/* remove restart bit before last message */
+			if (iface->cur_msg+1 == iface->msg_num)
+				write_MASTER_CTL(iface,
+					read_MASTER_CTL(iface) & ~RSTART);
 		} else {
 			iface->result = 1;
 			write_INT_MASK(iface, 0);
@@ -327,7 +328,8 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 		return -EINVAL;
 	}
 
-	iface->cur_mode = TWI_I2C_MODE_REPEAT;
+	if (iface->msg_num > 1)
+		iface->cur_mode = TWI_I2C_MODE_REPEAT;
 	iface->manual_stop = 0;
 	iface->transPtr = pmsg->buf;
 	iface->writeNum = iface->readNum = pmsg->len;
@@ -372,6 +374,7 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 
 	/* Master enable */
 	write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
+		(iface->msg_num > 1 ? RSTART : 0) |
 		((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
 		((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 	SSYNC();
@@ -540,7 +543,7 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 		else
 			write_MASTER_CTL(iface, 0x1 << 6);
 		/* Master enable */
-		write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
+		write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN | RSTART |
 			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
 		break;
 	default:
-- 
1.7.0.4



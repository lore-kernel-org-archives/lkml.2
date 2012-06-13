Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2FMIaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:30:17 -0400
Received: from [216.32.180.12] ([216.32.180.12]:38177 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab2FMI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:05 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/8 v2] i2c: i2c-bfin-twi: Illegal i2c bus lock upon certain transfer scenarios.
Date: Wed, 13 Jun 2012 16:22:40 +0800
Message-ID: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

For transfer counts > 255 bytes i2c-bfin-twi sets the data
transfer counter DCNT to 0xFF indicating unlimited transfers.
It then uses a flag iface->manual_stop to manually issue the STOP
condition, once the required amount of bytes are received.

We found that on I2C receive operation issuing the STOP condition
together with a FULL RCV FIFO (2bytes) will cause SDA and SCL be
constantly driven low.

Temporary workaround until further investigation:
Discard the RCV FIFO before issuing the STOP condition.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index cdb59e5..33031f0 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -131,6 +131,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 			iface->transPtr++;
 			iface->readNum--;
 		} else if (iface->manual_stop) {
+			/* Temporary workaround to avoid possible bus stall -
+			 * Flush FIFO before issuing the STOP condition
+			 */
+			read_RCV_DATA16(iface);
 			write_MASTER_CTL(iface,
 				read_MASTER_CTL(iface) | STOP);
 		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
-- 
1.7.0.4



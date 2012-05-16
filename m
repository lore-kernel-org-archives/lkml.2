Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab2EPHb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:31:27 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:35640
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759223Ab2EPHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:31:25 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c device misbehaves.
Date: Wed, 16 May 2012 15:20:21 +0800
Message-ID: <1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
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

Some fault i2c device may hold the sda/scl line and cause i2c driver
wait in the BUS busy loop. This patch breaks this potential dead
loop.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

git-svn-id: svn://localhost/svn/linux-kernel/trunk@9291 526b6c2d-f592-4532-a319-5dd88ccb003d
---
 drivers/i2c/busses/i2c-bfin-twi.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 376e331..4abaf59 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -294,6 +294,8 @@ static irqreturn_t bfin_twi_interrupt_entry(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+#define BFIN_TWI_BUSY_TIMEOUT	1000
+
 /*
  * One i2c master transfer
  */
@@ -303,12 +305,16 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 	struct bfin_twi_iface *iface = adap->algo_data;
 	struct i2c_msg *pmsg;
 	int rc = 0;
+	unsigned int busy_timeout = BFIN_TWI_BUSY_TIMEOUT;
 
 	if (!(read_CONTROL(iface) & TWI_ENA))
 		return -ENXIO;
 
-	while (read_MASTER_STAT(iface) & BUSBUSY)
+	while (read_MASTER_STAT(iface) & BUSBUSY) {
+		if (--busy_timeout == 0)
+			return -EBUSY;
 		yield();
+	}
 
 	iface->pmsg = msgs;
 	iface->msg_num = num;
@@ -403,12 +409,16 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 {
 	struct bfin_twi_iface *iface = adap->algo_data;
 	int rc = 0;
+	unsigned int busy_timeout = BFIN_TWI_BUSY_TIMEOUT;
 
 	if (!(read_CONTROL(iface) & TWI_ENA))
 		return -ENXIO;
 
-	while (read_MASTER_STAT(iface) & BUSBUSY)
+	while (read_MASTER_STAT(iface) & BUSBUSY) {
+		if (--busy_timeout == 0)
+			return -EBUSY;
 		yield();
+	}
 
 	iface->writeNum = 0;
 	iface->readNum = 0;
-- 
1.7.0.4



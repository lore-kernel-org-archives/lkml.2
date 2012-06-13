Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2FMIaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:30:20 -0400
Received: from [216.32.180.12] ([216.32.180.12]:26429 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab2FMI2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:04 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/8 v2] i2c: i2c-bfin-twi: Break dead waiting loop if i2c device misbehaves.
Date: Wed, 13 Jun 2012 16:22:42 +0800
Message-ID: <1339575767-22985-3-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
References: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Some fault i2c device may hold the sda/scl line and cause i2c driver
wait in the BUS busy loop. The I2C framework already retry the
transfer loop before timeout. Return -EAGAIN instead of pull BUSBUSY
in the other loop.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index dbe8fa0..a5ab454 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -307,8 +307,8 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 	if (!(read_CONTROL(iface) & TWI_ENA))
 		return -ENXIO;
 
-	while (read_MASTER_STAT(iface) & BUSBUSY)
-		yield();
+	if (read_MASTER_STAT(iface) & BUSBUSY)
+		return -EAGAIN;
 
 	iface->pmsg = msgs;
 	iface->msg_num = num;
@@ -407,8 +407,8 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	if (!(read_CONTROL(iface) & TWI_ENA))
 		return -ENXIO;
 
-	while (read_MASTER_STAT(iface) & BUSBUSY)
-		yield();
+	if (read_MASTER_STAT(iface) & BUSBUSY)
+		return -EAGAIN;
 
 	iface->writeNum = 0;
 	iface->readNum = 0;
-- 
1.7.0.4



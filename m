Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2FMIaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:30:14 -0400
Received: from [65.55.88.12] ([65.55.88.12]:17868 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab2FMI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:28:05 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 4/8 v2] i2c: i2c-bfin-twi: Tighten condition when failing I2C transfer if MEN bit is reset unexpectedly.
Date: Wed, 13 Jun 2012 16:22:43 +0800
Message-ID: <1339575767-22985-4-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
References: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

In order to mark I2C transfer fail when MEN bit in I2C controller is reset unexpeced
in MCOMP interrupt, interrupt status bits XMTSERV or RCVSERV should be checked.

Master Transfer Complete (MCOMP).
[1] The initiated master transfer has completed. In the absence of a
repeat start, the bus has been released.
[0] The completion of a transfer has not been detected.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index a5ab454..2e59bbd 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -201,7 +201,8 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 		return;
 	}
 	if (twi_int_status & MCOMP) {
-		if ((read_MASTER_CTL(iface) & MEN) == 0 &&
+		if (twi_int_status & (XMTSERV|RCVSERV) &&
+			(read_MASTER_CTL(iface) & MEN) == 0 &&
 			(iface->cur_mode == TWI_I2C_MODE_REPEAT ||
 			iface->cur_mode == TWI_I2C_MODE_COMBINED)) {
 			iface->result = -1;
-- 
1.7.0.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab2EPHbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:31:31 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:56785
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759536Ab2EPHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:31:27 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing I2C transfer if MEN bit is reset unexpectedly.
Date: Wed, 16 May 2012 15:20:22 +0800
Message-ID: <1337152826-9850-4-git-send-email-sonic.zhang@analog.com>
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

Correct I2C transfer may fail because interrupt status bits XMTSERV and
RCVSERV are not checked when MCOMP interrupt is handled.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 4abaf59..63fb84f 100644
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



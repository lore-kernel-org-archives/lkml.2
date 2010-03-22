Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0CVHXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:23:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49636 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0CVHXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:23:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 5/5] i2c-bfin-twi: return completion in interrupt for smbus quick transfers
Date: Mon, 22 Mar 2010 03:23:20 -0400
Message-Id: <1269242600-30147-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
References: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

A smbus quick transfer has no data after the address byte.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index d157105..02a8c86 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -158,18 +158,14 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 		if (mast_stat & BUFWRERR)
 			dev_dbg(&iface->adap.dev, "Buffer Write Error\n");
 
-		/* if both err and complete int stats are set, return proper
-		 * results.
+		/* If it is a quick transfer, only address without data,
+		 * not an err, return 1.
 		 */
-		if (twi_int_status & MCOMP) {
-			/* If it is a quick transfer, only address without data,
-			 * not an err, return 1.
-			 * If address is acknowledged return 1.
-			 */
-			if ((iface->writeNum == 0 && (mast_stat & BUFRDERR))
-				|| !(mast_stat & ANAK))
-				iface->result = 1;
-		}
+		if (iface->cur_mode == TWI_I2C_MODE_STANDARD &&
+			iface->transPtr == NULL &&
+			(twi_int_status & MCOMP) && (mast_stat & DNAK))
+			iface->result = 1;
+
 		complete(&iface->complete);
 		return;
 	}
-- 
1.7.0.2


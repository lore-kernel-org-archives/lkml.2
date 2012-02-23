Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2BWCDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 21:03:42 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48699 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134Ab2BWCDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 21:03:41 -0500
MIME-Version: 1.0
From: Nishanth Menon <nm@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] MFD: TWL 6030: clear IRQ status register only once
Date: Wed, 22 Feb 2012 20:03:45 -0600
Message-Id: <1329962625-29767-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL6030 family of PMIC use a shadow interrupt status register
while kernel processes the current interrupt event.
However, any write(0 or 1) to register INT_STS_A, INT_STS_B or
INT_STS_C clears all 3 interrupt status registers.

Since clear of the interrupt is done on 32k clk, depending on I2C
bus speed, we could in-adverently clear the status of a interrupt
status pending on shadow register in the current implementation.
This is due to the fact that multi-byte i2c write operation into
three seperate status register could result in multiple load
and clear of status and result in lost interrupts.

Instead, doing a single byte write to INT_STS_A register with 0x0
will clear all three interrupt status registers without the related
risk.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/mfd/twl6030-irq.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index c6b456a..aa367a2 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -185,8 +185,17 @@ static int twl6030_irq_thread(void *data)
 			}
 		local_irq_enable();
 		}
-		ret = twl_i2c_write(TWL_MODULE_PIH, sts.bytes,
-				REG_INT_STS_A, 3); /* clear INT_STS_A */
+
+		/*
+		 * NOTE:
+		 * Simulation confirms that documentation is wrong w.r.t the
+		 * interrupt status clear operation. A single *byte* write to
+		 * any one of STS_A to STS_C register results in all three
+		 * STS registers being reset. Since it does not matter which
+		 * value is written, all three registers are cleared on a
+		 * single byte write, so we just use 0x0 to clear.
+		 */
+		ret = twl_i2c_write_u8(TWL_MODULE_PIH, 0x00, REG_INT_STS_A);
 		if (ret)
 			pr_warning("twl6030: I2C error in clearing PIH ISR\n");
 
-- 
1.7.5.4


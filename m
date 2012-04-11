Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785Ab2DKXce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:32:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965678Ab2DKX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:27 -0400
Message-Id: <20120411231313.718251989@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 36/42] mfd: Clear twl6030 IRQ status register only once
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 3f8349e6e98ba0455437724589072523865eae5e upstream.

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
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/twl6030-irq.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -145,8 +145,17 @@ static int twl6030_irq_thread(void *data
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
 



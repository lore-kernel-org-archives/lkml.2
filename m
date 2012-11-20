Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2KTCfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:35:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37350 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2KTCfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:35:06 -0500
Message-ID: <1353378896.6455.1.camel@phoenix>
Subject: [PATCH RFT] mfd: rc5t583: Fix array subscript is above array bounds
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Date: Tue, 20 Nov 2012 10:34:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below build warning while compiling this driver.
It's obviously RC5T583_MAX_INTERRUPT_MASK_REGS is 9 but irq_en_add array only
has 8 elements.

  CC      drivers/mfd/rc5t583-irq.o
drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_sync_unlock':
drivers/mfd/rc5t583-irq.c:227: warning: array subscript is above array bounds
drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_init':
drivers/mfd/rc5t583-irq.c:349: warning: array subscript is above array bounds

Since the number of interrupt enable registers is 8, this patch adds define for
RC5T583_MAX_INTERRUPT_EN_REGS to fix this bug.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Laxman,
  I don't have this hardware, I'd appreciate if you can review and test this patch.
Thank you,
Axel
 drivers/mfd/rc5t583-irq.c   |    2 +-
 include/linux/mfd/rc5t583.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rc5t583-irq.c b/drivers/mfd/rc5t583-irq.c
index fe00cdd..b41db59 100644
--- a/drivers/mfd/rc5t583-irq.c
+++ b/drivers/mfd/rc5t583-irq.c
@@ -345,7 +345,7 @@ int rc5t583_irq_init(struct rc5t583 *rc5t583, int irq, int irq_base)
 	mutex_init(&rc5t583->irq_lock);
 
 	/* Initailize all int register to 0 */
-	for (i = 0; i < RC5T583_MAX_INTERRUPT_MASK_REGS; i++)  {
+	for (i = 0; i < RC5T583_MAX_INTERRUPT_EN_REGS; i++)  {
 		ret = rc5t583_write(rc5t583->dev, irq_en_add[i],
 				rc5t583->irq_en_reg[i]);
 		if (ret < 0)
diff --git a/include/linux/mfd/rc5t583.h b/include/linux/mfd/rc5t583.h
index 36c242e..fd413cc 100644
--- a/include/linux/mfd/rc5t583.h
+++ b/include/linux/mfd/rc5t583.h
@@ -33,6 +33,7 @@
 /* Maximum number of main interrupts */
 #define MAX_MAIN_INTERRUPT		5
 #define RC5T583_MAX_GPEDGE_REG		2
+#define RC5T583_MAX_INTERRUPT_EN_REGS	8
 #define RC5T583_MAX_INTERRUPT_MASK_REGS	9
 
 /* Interrupt enable register */
@@ -304,7 +305,7 @@ struct rc5t583 {
 	uint8_t		intc_inten_reg;
 
 	/* For group interrupt bits and address */
-	uint8_t		irq_en_reg[RC5T583_MAX_INTERRUPT_MASK_REGS];
+	uint8_t		irq_en_reg[RC5T583_MAX_INTERRUPT_EN_REGS];
 
 	/* For gpio edge */
 	uint8_t		gpedge_reg[RC5T583_MAX_GPEDGE_REG];
-- 
1.7.9.5




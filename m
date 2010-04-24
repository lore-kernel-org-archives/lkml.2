Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0DXJbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 05:31:48 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:56517 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166Ab0DXJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 05:31:46 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix pca953x set_type 'scheduling while atomic' bug
Date: Sat, 24 Apr 2010 10:31:32 +0100
Message-Id: <1272101492-29103-1-git-send-email-maz@misterjones.org>
X-Mailer: git-send-email 1.7.0.6
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, eric.y.miao@gmail.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Gatliff reported the following bug when using the irq_chip
facility of the pca953x driver on a PPC platform:

BUG: scheduling while atomic: insmod/1530/0x00000002

He traced it back to an i2c transaction in pca953x_irq_set_type(),
which can be called with interrupt disabled (from __setup_irq()). As
the i2c controller can sleep while sending a message, this qualifies
as a bad idea.

This patch moves the i2c transaction to pca953x_irq_bus_sync_unlock(),
where it is actually safe to send an i2c message.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Reported-by: Bill Gatliff <bgat@billgatliff.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/gpio/pca953x.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 7d521e1..d407d84 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -252,6 +252,18 @@ static void pca953x_irq_bus_lock(unsigned int irq)
 static void pca953x_irq_bus_sync_unlock(unsigned int irq)
 {
 	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	uint16_t new_irqs;
+	uint16_t level;
+
+	/* Look for any newly setup interrupt */
+	new_irqs = chip->irq_trig_fall | chip->irq_trig_raise;
+	new_irqs &= ~chip->reg_direction;
+
+	while(new_irqs) {
+		level = __ffs(new_irqs);
+		pca953x_gpio_direction_input(&chip->gpio_chip, level);
+		new_irqs &= ~(1 << level);
+	}
 
 	mutex_unlock(&chip->irq_lock);
 }
@@ -278,7 +290,7 @@ static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
 	else
 		chip->irq_trig_raise &= ~mask;
 
-	return pca953x_gpio_direction_input(&chip->gpio_chip, level);
+	return 0;
 }
 
 static struct irq_chip pca953x_irq_chip = {
-- 
1.7.0.6


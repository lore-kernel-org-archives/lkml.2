Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1GTKMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:12:10 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:25856 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab1GTKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:12:07 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/6] pch_gpio: add spinlock in suspend/resume processing
Date: Wed, 20 Jul 2011 19:10:58 +0900
Message-Id: <1311156662-3044-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/pch_gpio.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index ca9c7b0..252bddb 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -55,6 +55,9 @@ struct pch_gpio_reg_data {
  * @gpio:			Data for GPIO infrastructure.
  * @pch_gpio_reg:		Memory mapped Register data is saved here
  *				when suspend.
+ * @spinlock:		Used for register access protection in
+ *				interrupt context pch_irq_mask,
+ *				pch_irq_unmask and pch_irq_type;
  */
 struct pch_gpio {
 	void __iomem *base;
@@ -63,6 +66,7 @@ struct pch_gpio {
 	struct gpio_chip gpio;
 	struct pch_gpio_reg_data pch_gpio_reg;
 	struct mutex lock;
+	spinlock_t spinlock;
 };
 
 static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
@@ -239,8 +243,11 @@ static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	s32 ret;
 	struct pch_gpio *chip = pci_get_drvdata(pdev);
+	unsigned long flags;
 
+	spin_lock_irqsave(&chip->spinlock, flags);
 	pch_gpio_save_reg_conf(chip);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	ret = pci_save_state(pdev);
 	if (ret) {
@@ -260,6 +267,7 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 {
 	s32 ret;
 	struct pch_gpio *chip = pci_get_drvdata(pdev);
+	unsigned long flags;
 
 	ret = pci_enable_wake(pdev, PCI_D0, 0);
 
@@ -271,9 +279,11 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 	}
 	pci_restore_state(pdev);
 
+	spin_lock_irqsave(&chip->spinlock, flags);
 	iowrite32(0x01, &chip->reg->reset);
 	iowrite32(0x00, &chip->reg->reset);
 	pch_gpio_restore_reg_conf(chip);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
 
 	return 0;
 }
-- 
1.7.4.4


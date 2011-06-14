Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1FNJBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:01:34 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:13704 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1FNJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:00:50 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v5 1/5] GPIO: pca953x.c: Fix IRQ support.
Date: Tue, 14 Jun 2011 11:00:54 +0200
Message-Id: <1308042058-20107-2-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308042058-20107-1-git-send-email-david@protonic.nl>
References: <1308042058-20107-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that in the normal case, IRQ_NOREQUEST needs to be explicitly
cleared, otherwise claiming the interrupt fails.
In the case of sparse interrupts, the descriptor needs to be allocated
first.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 0451d7a..5f6940a 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -474,12 +474,16 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		 * this purpose.
 		 */
 		chip->irq_stat &= chip->reg_direction;
-		chip->irq_base = pdata->irq_base;
 		mutex_init(&chip->irq_lock);
 
+		chip->irq_base = irq_alloc_descs(-1, pdata->irq_base, chip->gpio_chip.ngpio, -1);
+		if (chip->irq_base < 0)
+			goto out_failed;
+
 		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
 			int irq = lvl + chip->irq_base;
 
+			irq_clear_status_flags(irq, IRQ_NOREQUEST);
 			irq_set_chip_data(irq, chip);
 			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
 						 handle_simple_irq);
@@ -514,8 +518,10 @@ out_failed:
 
 static void pca953x_irq_teardown(struct pca953x_chip *chip)
 {
-	if (chip->irq_base != -1)
+	if (chip->irq_base != -1) {
+		irq_free_descs(chip->irq_base, chip->gpio_chip.ngpio);
 		free_irq(chip->client->irq, chip);
+	}
 }
 #else /* CONFIG_GPIO_PCA953X_IRQ */
 static int pca953x_irq_setup(struct pca953x_chip *chip,
-- 
1.7.4.1


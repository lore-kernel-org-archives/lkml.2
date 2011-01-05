Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1AEJCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:02:21 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9626 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab1AEJCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:02:19 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Marc Zyngier <maz@misterjones.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next-2.6] gpio/ml_ioh_gpio: fix resource leak issue
Date: Wed,  5 Jan 2011 18:02:06 +0900
Message-Id: <1294218126-5801-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1) add gpiochip_remove processing in case gpiochip_add fails.
(2) for easy to read, move variable initialization to out of for-condition.

Reported-by: Andrew Morton. <akpm@linux-foundation.org>
Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/ml_ioh_gpio.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/ml_ioh_gpio.c
index 4fa3224..cead8e6 100644
--- a/drivers/gpio/ml_ioh_gpio.c
+++ b/drivers/gpio/ml_ioh_gpio.c
@@ -208,7 +208,8 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 		goto err_kzalloc;
 	}
 
-	for (i = 0, chip = chip_save; i < 8; i++, chip++) {
+	chip = chip_save;
+	for (i = 0; i < 8; i++, chip++) {
 		chip->dev = &pdev->dev;
 		chip->base = base;
 		chip->reg = chip->base;
@@ -228,6 +229,12 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 	return 0;
 
 err_gpiochip_add:
+	for (; i != 0; i--) {
+		chip--;
+		ret = gpiochip_remove(&chip->gpio);
+		if (ret)
+			dev_err(&pdev->dev, "Failed gpiochip_remove(%d)\n", i);
+	}
 	kfree(chip_save);
 
 err_kzalloc:
-- 
1.6.2.5


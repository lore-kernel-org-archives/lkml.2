Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297Ab2CNBE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:04:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109Ab2CNBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:04:58 -0400
Date: Wed, 14 Mar 2012 05:04:54 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: [PATCH 1/6] ab8500_charger: Convert to the new USB OTG calls
Message-ID: <20120314010454.GA10798@oksana.dev.rtsoft.ru>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build errors:

ab8500_charger.c: In function 'ab8500_charger_remove':
ab8500_charger.c:2519:2: error: implicit declaration of function 'otg_unregister_notifier' [-Werror=implicit-function-declaration]
ab8500_charger.c:2520:2: error: implicit declaration of function 'otg_put_transceiver' [-Werror=implicit-function-declaration]
ab8500_charger.c: In function 'ab8500_charger_probe':
ab8500_charger.c:2688:2: error: implicit declaration of function 'otg_get_transceiver' [-Werror=implicit-function-declaration]
ab8500_charger.c:2688:10: warning: assignment makes pointer from integer without a cast [enabled by default]
ab8500_charger.c:2695:2: error: implicit declaration of function 'otg_register_notifier' [-Werror=implicit-function-declaration]

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/power/ab8500_charger.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index bbc541a..a7217d6 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -240,7 +240,7 @@ struct ab8500_charger {
 	struct work_struct usb_state_changed_work;
 	struct work_struct check_main_thermal_prot_work;
 	struct work_struct check_usb_thermal_prot_work;
-	struct otg_transceiver *otg;
+	struct usb_phy *usb_phy;
 	struct notifier_block nb;
 };
 
@@ -2516,8 +2516,8 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 	if (ret < 0)
 		dev_err(di->dev, "%s mask and set failed\n", __func__);
 
-	otg_unregister_notifier(di->otg, &di->nb);
-	otg_put_transceiver(di->otg);
+	usb_unregister_notifier(di->usb_phy, &di->nb);
+	usb_put_transceiver(di->usb_phy);
 
 	/* Delete the work queue */
 	destroy_workqueue(di->charger_wq);
@@ -2685,17 +2685,17 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		goto free_ac;
 	}
 
-	di->otg = otg_get_transceiver();
-	if (!di->otg) {
-		dev_err(di->dev, "failed to get otg transceiver\n");
+	di->usb_phy = usb_get_transceiver();
+	if (!di->usb_phy) {
+		dev_err(di->dev, "failed to get usb transceiver\n");
 		ret = -EINVAL;
 		goto free_usb;
 	}
 	di->nb.notifier_call = ab8500_charger_usb_notifier_call;
-	ret = otg_register_notifier(di->otg, &di->nb);
+	ret = usb_register_notifier(di->usb_phy, &di->nb);
 	if (ret) {
-		dev_err(di->dev, "failed to register otg notifier\n");
-		goto put_otg_transceiver;
+		dev_err(di->dev, "failed to register usb notifier\n");
+		goto put_usb_phy;
 	}
 
 	/* Identify the connected charger types during startup */
@@ -2736,15 +2736,15 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	return ret;
 
 free_irq:
-	otg_unregister_notifier(di->otg, &di->nb);
+	usb_unregister_notifier(di->usb_phy, &di->nb);
 
 	/* We also have to free all successfully registered irqs */
 	for (i = i - 1; i >= 0; i--) {
 		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
 		free_irq(irq, di);
 	}
-put_otg_transceiver:
-	otg_put_transceiver(di->otg);
+put_usb_phy:
+	usb_put_transceiver(di->usb_phy);
 free_usb:
 	power_supply_unregister(&di->usb_chg.psy);
 free_ac:
-- 
1.7.9


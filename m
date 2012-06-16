Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2FPQuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 12:50:17 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:58971 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753671Ab2FPQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 12:50:16 -0400
From: Roland Stigge <stigge@antcom.de>
To: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, sebastian.rasmussen@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2] mmc: mmci.c: Defer probe() in case of yet uninitialized GPIOs
Date: Sat, 16 Jun 2012 18:49:35 +0200
Message-Id: <1339865375-22314-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the GPIOs used by the MMCI driver are not registered yet when the driver is
probe()d, they can't be used. This happens if the mmci driver is probed before
the respective GPIO controller (e.g. on the LPC32xx EA3250 board, the PCA9532
GPIO controller would be initialized via DT after mmci). Therefore, we defer
mmci in this case.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/mmc/host/mmci.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- linux-2.6.orig/drivers/mmc/host/mmci.c
+++ linux-2.6/drivers/mmc/host/mmci.c
@@ -1215,13 +1215,21 @@ static void mmci_dt_populate_generic_pda
 {
 	int bus_width = 0;
 
-	pdata->gpio_wp = of_get_named_gpio(np, "wp-gpios", 0);
-	if (!pdata->gpio_wp)
-		pdata->gpio_wp = -1;
-
-	pdata->gpio_cd = of_get_named_gpio(np, "cd-gpios", 0);
-	if (!pdata->gpio_cd)
-		pdata->gpio_cd = -1;
+	if (of_get_property(np, "wp-gpios", NULL)) {
+		pdata->gpio_wp = of_get_named_gpio(np, "wp-gpios", 0);
+		if (pdata->gpio_wp == -ENODEV)
+			pdata->gpio_wp = -EPROBE_DEFER;
+	} else {
+		pdata->gpio_wp = -ENODEV;
+	}
+
+	if (of_get_property(np, "cd-gpios", NULL)) {
+		pdata->gpio_cd = of_get_named_gpio(np, "cd-gpios", 0);
+		if (pdata->gpio_cd == -ENODEV)
+			pdata->gpio_cd = -EPROBE_DEFER;
+	} else {
+		pdata->gpio_cd = -ENODEV;
+	}
 
 	if (of_get_property(np, "cd-inverted", NULL))
 		pdata->cd_invert = true;
@@ -1424,6 +1432,10 @@ static int __devinit mmci_probe(struct a
 	writel(0, host->base + MMCIMASK1);
 	writel(0xfff, host->base + MMCICLEAR);
 
+	if (plat->gpio_cd == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_gpio_cd;
+	}
 	if (gpio_is_valid(plat->gpio_cd)) {
 		ret = gpio_request(plat->gpio_cd, DRIVER_NAME " (cd)");
 		if (ret == 0)
@@ -1447,6 +1459,10 @@ static int __devinit mmci_probe(struct a
 		if (ret >= 0)
 			host->gpio_cd_irq = gpio_to_irq(plat->gpio_cd);
 	}
+	if (plat->gpio_wp == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_gpio_wp;
+	}
 	if (gpio_is_valid(plat->gpio_wp)) {
 		ret = gpio_request(plat->gpio_wp, DRIVER_NAME " (wp)");
 		if (ret == 0)

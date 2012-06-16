Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab2FPOPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 10:15:46 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:53587 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756668Ab2FPOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 10:15:45 -0400
From: Roland Stigge <stigge@antcom.de>
To: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, sebastian.rasmussen@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] mmc: mmci.c: Defer probe() in case of missing GPIOs
Date: Sat, 16 Jun 2012 16:14:59 +0200
Message-Id: <1339856099-9313-1-git-send-email-stigge@antcom.de>
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
 drivers/mmc/host/mmci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.orig/drivers/mmc/host/mmci.c
+++ linux-2.6/drivers/mmc/host/mmci.c
@@ -1424,6 +1424,10 @@ static int __devinit mmci_probe(struct a
 	writel(0, host->base + MMCIMASK1);
 	writel(0xfff, host->base + MMCICLEAR);
 
+	if (plat->gpio_cd < 0) {
+		ret = -EPROBE_DEFER;
+		goto err_gpio_cd;
+	}
 	if (gpio_is_valid(plat->gpio_cd)) {
 		ret = gpio_request(plat->gpio_cd, DRIVER_NAME " (cd)");
 		if (ret == 0)
@@ -1447,6 +1451,10 @@ static int __devinit mmci_probe(struct a
 		if (ret >= 0)
 			host->gpio_cd_irq = gpio_to_irq(plat->gpio_cd);
 	}
+	if (plat->gpio_wp < 0) {
+		ret = -EPROBE_DEFER;
+		goto err_gpio_wp;
+	}
 	if (gpio_is_valid(plat->gpio_wp)) {
 		ret = gpio_request(plat->gpio_wp, DRIVER_NAME " (wp)");
 		if (ret == 0)

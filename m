Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2CKMmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:42:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54759 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2CKMl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:41:58 -0400
X-AuditID: cbfee61b-b7c62ae000000989-84-4f5c9d9620cd
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 5/5] mmc: sdhci-s3c: setup pins using pinctrl interface
Date: Sun, 11 Mar 2012 18:16:05 +0530
Message-id: <1331469965-28846-6-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform specific callback to setup the sdhci pin mux and pin config
is removed and the pinctrl subsystem interface is used to setup the
mux and config.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/mmc/host/sdhci-s3c.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index ea0767e..76c1c36 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <linux/mmc/host.h>
 
@@ -50,6 +51,7 @@ struct sdhci_s3c {
 	struct platform_device	*pdev;
 	struct resource		*ioarea;
 	struct s3c_sdhci_platdata *pdata;
+	struct pinctrl 		*pinctrl;
 	unsigned int		cur_clk;
 	int			ext_cd_irq;
 	int			ext_cd_gpio;
@@ -529,6 +531,9 @@ static inline struct sdhci_s3c_drv_data *sdhci_s3c_get_driver_data(
 			platform_get_device_id(pdev)->driver_data;
 }
 
+#include <plat/map-s5p.h>
+#include <plat/map-base.h>
+
 static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 {
 	struct s3c_sdhci_platdata *pdata;
@@ -538,6 +543,7 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 	struct sdhci_s3c *sc;
 	struct resource *res;
 	int ret, irq, ptr, clks;
+	char *pstate;
 
 	if (!pdev->dev.platform_data && !pdev->dev.of_node) {
 		dev_err(dev, "no device data specified\n");
@@ -643,8 +649,13 @@ static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 	}
 
 	/* Ensure we have minimal gpio selected CMD/CLK/Detect */
-	if (pdata->cfg_gpio)
-		pdata->cfg_gpio(pdev, pdata->max_width);
+	pstate = pdata->max_width ? "sdhci-pcfg8" : "sdhci-pcfg4";
+	sc->pinctrl = pinctrl_get_select(&pdev->dev, pstate);
+	if (IS_ERR(sc->pinctrl)) {
+		dev_err(dev, "failed to setup pin configuration\n");
+		ret = -ENXIO;
+		goto err_req_regs;
+	}
 
 	host->hw_name = "samsung-hsmmc";
 	host->ops = &sdhci_s3c_ops;
-- 
1.6.6.rc2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab1LNPwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:52:35 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:49964
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405Ab1LNPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:52:30 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
Subject: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Date: Thu, 15 Dec 2011 00:03:42 +0800
Message-ID: <1323878622-26602-5-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323878622-26602-1-git-send-email-b29396@freescale.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 4b976f0..4504136 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/pinmux.h>
 #include <mach/esdhc.h>
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
@@ -68,6 +69,7 @@ struct pltfm_imx_data {
 	int flags;
 	u32 scratchpad;
 	enum imx_esdhc_type devtype;
+	struct pinmux *pmx;
 	struct esdhc_platform_data boarddata;
 };
 
@@ -439,6 +441,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	struct clk *clk;
 	int err;
 	struct pltfm_imx_data *imx_data;
+	struct pinmux *pmx;
 
 	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_imx_pdata);
 	if (IS_ERR(host))
@@ -466,6 +469,16 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	clk_enable(clk);
 	pltfm_host->clk = clk;
 
+	pmx = pinmux_get(&pdev->dev, NULL);
+	if (IS_ERR(pmx)) {
+		err = PTR_ERR(pmx);
+		goto err_pmx_get;
+	}
+	err = pinmux_enable(pmx);
+	if (err)
+		goto err_pmx_enable;
+	imx_data->pmx = pmx;
+
 	if (!is_imx25_esdhc(imx_data))
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
@@ -558,6 +571,10 @@ no_card_detect_irq:
 		gpio_free(boarddata->wp_gpio);
 no_card_detect_pin:
 no_board_data:
+	pinmux_disable(imx_data->pmx);
+err_pmx_enable:
+	pinmux_put(imx_data->pmx);
+err_pmx_get:
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 err_clk_get:
@@ -585,6 +602,9 @@ static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
 		gpio_free(boarddata->cd_gpio);
 	}
 
+	pinmux_disable(imx_data->pmx);
+	pinmux_put(imx_data->pmx);
+
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 	kfree(imx_data);
-- 
1.7.0.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2LURTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:19:35 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38979 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2LURT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:19:27 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 12:19:26 EST
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: host: dw_mmc-exynos: Add support for pinctrl
Date: Sat, 22 Dec 2012 02:11:27 +0900
Message-Id: <1356109906-1622-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for pin configuration using pinctrl subsystem to
dw_mmc-exynos driver. The property 'wp-gpios' can be specified for write
protect but 'samsung,cd-pinmux-gpio' and gpios used for clock, command and
data lines will be ignored.

-. 'pinctrl-0' should specify pin control groups (clock, comand and data
    lines) used for this controller.
-. 'pinctrl-names' should contain only one value, 'default'.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/mmc/host/dw_mmc-exynos.c |   44 ++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 4d50da6..d1c9963 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -16,6 +16,7 @@
 #include <linux/mmc/dw_mmc.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 
 #include "dw_mmc.h"
 #include "dw_mmc-pltfm.h"
@@ -49,6 +50,7 @@ struct dw_mci_exynos_priv_data {
 	u8				ciu_div;
 	u32				sdr_timing;
 	u32				ddr_timing;
+	struct pinctrl			*pctrl;
 };
 
 static struct dw_mci_exynos_compatible {
@@ -84,6 +86,10 @@ static int dw_mci_exynos_priv_init(struct dw_mci *host)
 			priv->ctrl_type = exynos_compat[idx].ctrl_type;
 	}
 
+	priv->pctrl = devm_pinctrl_get_select_default(host->dev);
+	if (IS_ERR(priv->pctrl))
+		dev_dbg(host->dev, "no pinctrl node\n");
+
 	host->priv = priv;
 	return 0;
 }
@@ -149,32 +155,19 @@ static int dw_mci_exynos_parse_dt(struct dw_mci *host)
 		return ret;
 
 	priv->ddr_timing = SDMMC_CLKSEL_TIMING(timing[0], timing[1], div);
+
 	return 0;
 }
 
 static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 				struct device_node *slot_np, u8 bus_width)
 {
+	struct dw_mci_exynos_priv_data *priv = host->priv;
 	int idx, gpio, ret;
 
 	if (!slot_np)
 		return -EINVAL;
 
-	/* cmd + clock + bus-width pins */
-	for (idx = 0; idx < NUM_PINS(bus_width); idx++) {
-		gpio = of_get_gpio(slot_np, idx);
-		if (!gpio_is_valid(gpio)) {
-			dev_err(host->dev, "invalid gpio: %d\n", gpio);
-			return -EINVAL;
-		}
-
-		ret = devm_gpio_request(host->dev, gpio, "dw-mci-bus");
-		if (ret) {
-			dev_err(host->dev, "gpio [%d] request failed\n", gpio);
-			return -EBUSY;
-		}
-	}
-
 	gpio = of_get_named_gpio(slot_np, "wp-gpios", 0);
 	if (gpio_is_valid(gpio)) {
 		if (devm_gpio_request(host->dev, gpio, "dw-mci-wp"))
@@ -185,9 +178,12 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 		host->pdata->quirks |= DW_MCI_QUIRK_NO_WRITE_PROTECT;
 	}
 
-	if (host->pdata->quirks & DW_MCI_QUIRK_BROKEN_CARD_DETECTION)
+	if (!IS_ERR(priv->pctrl))
 		return 0;
 
+	if (host->pdata->quirks & DW_MCI_QUIRK_BROKEN_CARD_DETECTION)
+		goto setup_bus;
+
 	gpio = of_get_named_gpio(slot_np, "samsung,cd-pinmux-gpio", 0);
 	if (gpio_is_valid(gpio)) {
 		if (devm_gpio_request(host->dev, gpio, "dw-mci-cd"))
@@ -196,6 +192,22 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 		dev_info(host->dev, "cd gpio not available");
 	}
 
+ setup_bus:
+	/* cmd + clock + bus-width pins */
+	for (idx = 0; idx < NUM_PINS(bus_width); idx++) {
+		gpio = of_get_gpio(slot_np, idx);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(host->dev, "invalid gpio: %d\n", gpio);
+			return -EINVAL;
+		}
+
+		ret = devm_gpio_request(host->dev, gpio, "dw-mci-bus");
+		if (ret) {
+			dev_err(host->dev, "gpio [%d] request failed\n", gpio);
+			return -EBUSY;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5


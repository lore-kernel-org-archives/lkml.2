Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab1H3TSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:18:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35524 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab1H3TR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:17:27 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>
Cc: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] mmc: sdhci-tegra: Add 8-bit support to device tree binding.
Date: Tue, 30 Aug 2011 13:17:16 -0600
Message-Id: <1314731837-6985-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314731837-6985-1-git-send-email-swarren@nvidia.com>
References: <1314731837-6985-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch which implemented a DT binding for sdhci-tegra did not
allow all platform data fields to be initialized from DT. The following
were missing:

is_8bit: Implemented by this patch.

pm_flags: Not implemented yet. There are no mainline users of this field.
  I'm not quite sure what it's for, and hence how to represent this
  in DT; the value ends up being assigned to host->mmc->pm_caps.

While we're at it, fix the binding documentation to refer to "SD/MMC"
instead of "eSDHC", since that's the correct name; "eSDHC" was cut/paste
from the Freescale binding docs.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This should be able to go straight into the MMC -next branch

 .../devicetree/bindings/mmc/nvidia-sdhci.txt       |    6 ++++--
 drivers/mmc/host/sdhci-tegra.c                     |    3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
index c87f667..7e51154 100644
--- a/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
@@ -5,13 +5,14 @@ and SDIO types of memory cards.
 
 Required properties:
 - compatible : Should be "nvidia,<chip>-sdhci"
-- reg : Should contain eSDHC registers location and length
-- interrupts : Should contain eSDHC interrupt
+- reg : Should contain SD/MMC registers location and length
+- interrupts : Should contain SD/MMC interrupt
 
 Optional properties:
 - cd-gpios : Specify GPIOs for card detection
 - wp-gpios : Specify GPIOs for write protection
 - power-gpios : Specify GPIOs for power control
+- support-8bit : Boolean, indicates if 8-bit mode should be used.
 
 Example:
 
@@ -22,4 +23,5 @@ sdhci@c8000200 {
 	cd-gpios = <&gpio 69 0>; /* gpio PI5 */
 	wp-gpios = <&gpio 57 0>; /* gpio PH1 */
 	power-gpios = <&gpio 155 0>; /* gpio PT3 */
+	support-8bit;
 };
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 9ab18d6..67176af 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/gpio.h>
 #include <linux/mmc/card.h>
@@ -153,6 +154,8 @@ static struct tegra_sdhci_platform_data * __devinit sdhci_tegra_dt_parse_pdata(
 	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
 	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
 	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
+	if (of_find_property(np, "support-8bit", NULL))
+		plat->is_8bit = 1;
 
 	return plat;
 }
-- 
1.7.0.4


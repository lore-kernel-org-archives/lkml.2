Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab0DGXNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:10 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65399 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756003Ab0DGXMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:12:47 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 01/11] ARM: MMCI: support 8bit mode on the ST Micro version
Date: Thu,  8 Apr 2010 01:12:14 +0200
Message-Id: <1270681934-4726-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for an 8bit wide bus to the card (data lines
MCIDAT0 through 7 exist) on the ST Micro version and alters the
U300 platform to support this. Also add some ST_ prefix to the
ST-specific registers.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/mmc.c |    2 +-
 drivers/mmc/host/mmci.c  |    6 ++++--
 drivers/mmc/host/mmci.h  |    6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-u300/mmc.c b/arch/arm/mach-u300/mmc.c
index 77fbb1e..c2549b8 100644
--- a/arch/arm/mach-u300/mmc.c
+++ b/arch/arm/mach-u300/mmc.c
@@ -106,7 +106,7 @@ int __devinit mmc_init(struct amba_device *adev)
 	mmci_card->mmc0_plat_data.gpio_wp = -1;
 	mmci_card->mmc0_plat_data.gpio_cd = -1;
 	mmci_card->mmc0_plat_data.capabilities = MMC_CAP_MMC_HIGHSPEED |
-		MMC_CAP_SD_HIGHSPEED | MMC_CAP_4_BIT_DATA;
+		MMC_CAP_SD_HIGHSPEED | MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
 
 	mmcsd_device->platform_data = (void *) &mmci_card->mmc0_plat_data;
 
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 84c103a..7e70c1a 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -55,14 +55,16 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 			host->cclk = host->mclk / (2 * (clk + 1));
 		}
 		if (host->hw_designer == AMBA_VENDOR_ST)
-			clk |= MCI_FCEN; /* Bug fix in ST IP block */
+			clk |= MCI_ST_FCEN; /* Bug fix in ST IP block */
 		clk |= MCI_CLK_ENABLE;
 		/* This hasn't proven to be worthwhile */
 		/* clk |= MCI_CLK_PWRSAVE; */
 	}
 
 	if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
-		clk |= MCI_WIDE_BUS;
+		clk |= MCI_4BIT_BUS;
+	if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
+		clk |= MCI_ST_8BIT_BUS;
 
 	writel(clk, host->base + MMCICLOCK);
 }
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 1ceb9a9..d77062e 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -25,9 +25,11 @@
 #define MCI_CLK_ENABLE		(1 << 8)
 #define MCI_CLK_PWRSAVE		(1 << 9)
 #define MCI_CLK_BYPASS		(1 << 10)
-#define MCI_WIDE_BUS		(1 << 11)
+#define MCI_4BIT_BUS		(1 << 11)
+/* 8bit wide buses supported in ST Micro versions */
+#define MCI_ST_8BIT_BUS		(1 << 12)
 /* HW flow control on the ST Micro version */
-#define MCI_FCEN		(1 << 13)
+#define MCI_ST_FCEN		(1 << 13)
 
 #define MMCIARGUMENT		0x008
 #define MMCICOMMAND		0x00c
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3AGLYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:24:33 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47249 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3AGLY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:24:29 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gerald Baeza <gerald.baeza@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 08/16] dmaengine: ste_dma40: physical channels number correction
Date: Mon,  7 Jan 2013 12:21:50 +0100
Message-Id: <1357557718-15676-9-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Baeza <gerald.baeza@stericsson.com>

DMAC_ICFG[0:2]=SCHNB only allows to count 'multiple of 4' physical
channels so it was ok with platforms having 8 channels but cannot be
used for next versions (with 10 or 14 channels).  This patch allows to
provide the number of physical channels for a DMA device via
platform_data, or still rely on SCHNB if platform_data announces 0
channel.

Signed-off-by: Gerald Baeza <gerald.baeza@stericsson.com>
Reviewed-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c                     | 15 ++++++++++-----
 include/linux/platform_data/dma-ste-dma40.h |  4 ++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5feab7db9..ca18117 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3004,14 +3004,21 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	 * ? has revision 1
 	 * DB8500v1 has revision 2
 	 * DB8500v2 has revision 3
+	 * AP9540v1 has revision 4
+	 * DB8540v1 has revision 4
 	 */
 	rev = AMBA_REV_BITS(pid);
 
+	plat_data = pdev->dev.platform_data;
+
 	/* The number of physical channels on this HW */
-	num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
+	if (plat_data->num_of_phy_chans)
+		num_phy_chans = plat_data->num_of_phy_chans;
+	else
+		num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
 
-	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x\n",
-		 rev, res->start);
+	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
+		 rev, res->start, num_phy_chans);
 
 	if (rev < 2) {
 		d40_err(&pdev->dev, "hardware revision: %d is not supported",
@@ -3019,8 +3026,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		goto failure;
 	}
 
-	plat_data = pdev->dev.platform_data;
-
 	/* Count the number of logical channels in use */
 	for (i = 0; i < plat_data->dev_len; i++)
 		if (plat_data->dev_rx[i] != 0)
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index 9ff93b0..833cb95 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -147,6 +147,9 @@ struct stedma40_chan_cfg {
  * @memcpy_conf_log: default configuration of logical channel memcpy
  * @disabled_channels: A vector, ending with -1, that marks physical channels
  * that are for different reasons not available for the driver.
+ * @num_of_phy_chans: The number of physical channels implemented in HW.
+ * 0 means reading the number of channels from DMA HW but this is only valid
+ * for 'multiple of 4' channels, like 8.
  */
 struct stedma40_platform_data {
 	u32				 dev_len;
@@ -158,6 +161,7 @@ struct stedma40_platform_data {
 	struct stedma40_chan_cfg	*memcpy_conf_log;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
 	bool				 use_esram_lcla;
+	int				 num_of_phy_chans;
 };
 
 #ifdef CONFIG_STE_DMA40
-- 
1.7.12.1


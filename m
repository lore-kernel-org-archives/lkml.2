Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2DCNDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:03:48 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:52472 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2DCNDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:03:47 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Juergen Beisert <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] spi/imx: prevent NULL pointer dereference in spi_imx_probe()
Date: Tue,  3 Apr 2012 15:03:44 +0200
Message-Id: <1333458224-7602-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When no platform_data is present and either 'spi-num-chipselects' is
not defined in the DT or 'cs-gpios' has less entries than
'spi-num-chipselects' specifies, the NULL platform_data pointer is
being dereferenced.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/spi/spi-imx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 373f4ff..570f220 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -766,8 +766,12 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
 	}
 
 	ret = of_property_read_u32(np, "fsl,spi-num-chipselects", &num_cs);
-	if (ret < 0)
-		num_cs = mxc_platform_info->num_chipselect;
+	if (ret < 0) {
+		if (mxc_platform_info)
+			num_cs = mxc_platform_info->num_chipselect;
+		else
+			return ret;
+	}
 
 	master = spi_alloc_master(&pdev->dev,
 			sizeof(struct spi_imx_data) + sizeof(int) * num_cs);
@@ -784,7 +788,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
 
 	for (i = 0; i < master->num_chipselect; i++) {
 		int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
-		if (cs_gpio < 0)
+		if (cs_gpio < 0 && mxc_platform_info)
 			cs_gpio = mxc_platform_info->chipselect[i];
 
 		spi_imx->chipselect[i] = cs_gpio;
-- 
1.7.2.5


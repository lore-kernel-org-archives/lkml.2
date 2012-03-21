Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2CUGDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:03:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35798 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2CUGDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:03:32 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] spi: omap2_mcspi: Make the runtime functions depend on CONFIG_PM_RUNTIME
Date: Wed, 21 Mar 2012 11:33:15 +0530
Message-ID: <1332309795-5075-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the function omap_mcspi_runtime_resume depend on CONFIG_PM_RUNTIME.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index cb2c0e3..f9d694d 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -248,23 +248,6 @@ static void omap2_mcspi_set_master_mode(struct spi_master *master)
 	omap2_mcspi_ctx[master->bus_num - 1].modulctrl = l;
 }
 
-static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
-{
-	struct spi_master *spi_cntrl;
-	struct omap2_mcspi_cs *cs;
-	spi_cntrl = mcspi->master;
-
-	/* McSPI: context restore */
-	mcspi_write_reg(spi_cntrl, OMAP2_MCSPI_MODULCTRL,
-			omap2_mcspi_ctx[spi_cntrl->bus_num - 1].modulctrl);
-
-	mcspi_write_reg(spi_cntrl, OMAP2_MCSPI_WAKEUPENABLE,
-			omap2_mcspi_ctx[spi_cntrl->bus_num - 1].wakeupenable);
-
-	list_for_each_entry(cs, &omap2_mcspi_ctx[spi_cntrl->bus_num - 1].cs,
-			node)
-		__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
-}
 static void omap2_mcspi_disable_clocks(struct omap2_mcspi *mcspi)
 {
 	pm_runtime_put_sync(mcspi->dev);
@@ -1066,6 +1049,26 @@ static int __init omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
+{
+	struct spi_master *spi_cntrl;
+	struct omap2_mcspi_cs *cs;
+
+	spi_cntrl = mcspi->master;
+
+	/* McSPI: context restore */
+	mcspi_write_reg(spi_cntrl, OMAP2_MCSPI_MODULCTRL,
+			omap2_mcspi_ctx[spi_cntrl->bus_num - 1].modulctrl);
+
+	mcspi_write_reg(spi_cntrl, OMAP2_MCSPI_WAKEUPENABLE,
+			omap2_mcspi_ctx[spi_cntrl->bus_num - 1].wakeupenable);
+
+	list_for_each_entry(cs, &omap2_mcspi_ctx[spi_cntrl->bus_num - 1].cs,
+			node)
+		__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
+}
+
 static int omap_mcspi_runtime_resume(struct device *dev)
 {
 	struct omap2_mcspi	*mcspi;
@@ -1077,7 +1080,9 @@ static int omap_mcspi_runtime_resume(struct device *dev)
 
 	return 0;
 }
-
+#else
+#define	omap_mcspi_runtime_resume	NULL
+#endif
 
 static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 {
-- 
1.7.1


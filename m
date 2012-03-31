Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab2CaLiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 07:38:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49184 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab2CaLhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 07:37:25 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 2/3] spi: omap2-mcspi: add support for pm_runtime autosuspend
Date: Sat, 31 Mar 2012 17:06:57 +0530
Message-ID: <1333193818-3984-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333193818-3984-1-git-send-email-shubhrajyoti@ti.com>
References: <1333193818-3984-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for configuring the omap2-mcspi driver use autosuspend for
runtime power management. This can reduce the latency in starting an
spi transfer by not suspending the device immediately following
completion of a transfer. If another transfer then takes place before
the autosuspend timeout (2 secs), the call to resume the device can
return immediately saving some save/ restore cycles.

Acked-by: Govindraj.R <govindraj.raja@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 1907ed2..0b0da2f 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -44,6 +44,7 @@
 #include <plat/mcspi.h>
 
 #define OMAP2_MCSPI_MAX_FREQ		48000000
+#define SPI_AUTOSUSPEND_TIMEOUT		2000
 
 #define OMAP2_MCSPI_REVISION		0x00
 #define OMAP2_MCSPI_SYSSTATUS		0x14
@@ -265,7 +266,8 @@ static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
 }
 static void omap2_mcspi_disable_clocks(struct omap2_mcspi *mcspi)
 {
-	pm_runtime_put_sync(mcspi->dev);
+	pm_runtime_mark_last_busy(mcspi->dev);
+	pm_runtime_put_autosuspend(mcspi->dev);
 }
 
 static int omap2_mcspi_enable_clocks(struct omap2_mcspi *mcspi)
@@ -1212,6 +1214,8 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
 	if (status < 0)
 		goto dma_chnl_free;
 
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_enable(&pdev->dev);
 
 	if (status || omap2_mcspi_master_setup(mcspi) < 0)
-- 
1.7.1


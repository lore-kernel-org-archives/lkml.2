Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0EKV5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:57:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61797 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0EKV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:57:20 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-mmc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>, Tony Lindgren <tony@atomide.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] MMC: OMAP HS-MMC: convert to dev_pm_ops
Date: Tue, 11 May 2010 14:57:16 -0700
Message-Id: <1273615036-4516-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert PM operations to use dev_pm_ops.  This will facilitate
the runtime PM coversion which will add to dev_pm_ops hooks.

Note that dev_pm_ops version of the suspend hook no longer takes a
'state' argument.  However, the MMC core function mmc_suspend_host()
still takes a 'state' argument, but it is unused, so a dummy
state variable was created to pass to the MMC core.

In the future, the MMC core should be converted to drop this
state argument and the rest of the MMC drivers could be easily
converted to dev_pm_ops as well.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
Applies on v2.6.34-rc6

 drivers/mmc/host/omap_hsmmc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e9caf69..8112d54 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2258,10 +2258,12 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int omap_hsmmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int omap_hsmmc_suspend(struct device *dev)
 {
 	int ret = 0;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
+	pm_message_t state = PMSG_SUSPEND; /* unused by MMC core */
 
 	if (host && host->suspended)
 		return 0;
@@ -2310,9 +2312,10 @@ static int omap_hsmmc_suspend(struct platform_device *pdev, pm_message_t state)
 }
 
 /* Routine to resume the MMC device */
-static int omap_hsmmc_resume(struct platform_device *pdev)
+static int omap_hsmmc_resume(struct device *dev)
 {
 	int ret = 0;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 
 	if (host && !host->suspended)
@@ -2363,13 +2366,17 @@ clk_en_err:
 #define omap_hsmmc_resume		NULL
 #endif
 
-static struct platform_driver omap_hsmmc_driver = {
-	.remove		= omap_hsmmc_remove,
+static struct dev_pm_ops omap_hsmmc_dev_pm_ops = {
 	.suspend	= omap_hsmmc_suspend,
 	.resume		= omap_hsmmc_resume,
+};
+
+static struct platform_driver omap_hsmmc_driver = {
+	.remove		= omap_hsmmc_remove,
 	.driver		= {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.pm = &omap_hsmmc_dev_pm_ops,
 	},
 };
 
-- 
1.7.0.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab0CPUcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:32:47 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:48959 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab0CPUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:32:44 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-mmc@vger.kernel.org
Cc: Chaithrika U S <chaithrika@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vipin Bhandari <vipin.bhandari@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] davinci: MMC: updates to suspend/resume implementation
Date: Tue, 16 Mar 2010 13:30:25 -0700
Message-Id: <1268771425-6277-2-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268771425-6277-1-git-send-email-khilman@deeprootsystems.com>
References: <1268771425-6277-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaithrika U S <chaithrika@ti.com>

Improve the suspend and resume callbacks in DaVinci MMC host controller driver.
Modify the reset status of the contorller and clock during suspend and resume.
Also migrate the power management callbacks from platform driver to dev_pm_ops
structure.

Tested on DA850/OMAP-L138 EVM.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
I thought this series had made it into -mm for 2.6.34, but I guess not.
Here it is again for 2.6.35.

 drivers/mmc/host/davinci_mmc.c |   51 +++++++++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 56afe0a..e4d1591 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -171,6 +171,7 @@ struct mmc_davinci_host {
 #define DAVINCI_MMC_DATADIR_READ	1
 #define DAVINCI_MMC_DATADIR_WRITE	2
 	unsigned char data_dir;
+	unsigned char suspended;
 
 	/* buffer is used during PIO of one scatterlist segment, and
 	 * is updated along with buffer_bytes_left.  bytes_left applies
@@ -1332,32 +1333,66 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
+static int davinci_mmcsd_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
+	struct pm_message msg = { PM_EVENT_SUSPEND };
+	int ret;
 
-	return mmc_suspend_host(host->mmc, msg);
+	mmc_host_enable(host->mmc);
+	ret = mmc_suspend_host(host->mmc, msg);
+	if (!ret) {
+		writel(0, host->base + DAVINCI_MMCIM);
+		mmc_davinci_reset_ctrl(host, 1);
+		mmc_host_disable(host->mmc);
+		clk_disable(host->clk);
+		host->suspended = 1;
+	} else {
+		host->suspended = 0;
+		mmc_host_disable(host->mmc);
+	}
+
+	return ret;
 }
 
-static int davinci_mmcsd_resume(struct platform_device *pdev)
+static int davinci_mmcsd_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
+	int ret;
 
-	return mmc_resume_host(host->mmc);
+	if (!host->suspended)
+		return 0;
+
+	clk_enable(host->clk);
+	mmc_host_enable(host->mmc);
+
+	mmc_davinci_reset_ctrl(host, 0);
+	ret = mmc_resume_host(host->mmc);
+	if (!ret)
+		host->suspended = 0;
+
+	return ret;
 }
+
+static struct dev_pm_ops davinci_mmcsd_pm = {
+	.suspend        = davinci_mmcsd_suspend,
+	.resume         = davinci_mmcsd_resume,
+};
+
+#define davinci_mmcsd_pm_ops (&davinci_mmcsd_pm)
 #else
-#define davinci_mmcsd_suspend	NULL
-#define davinci_mmcsd_resume	NULL
+#define davinci_mmcsd_pm_ops NULL
 #endif
 
 static struct platform_driver davinci_mmcsd_driver = {
 	.driver		= {
 		.name	= "davinci_mmc",
 		.owner	= THIS_MODULE,
+		.pm	= davinci_mmcsd_pm_ops,
 	},
 	.remove		= __exit_p(davinci_mmcsd_remove),
-	.suspend	= davinci_mmcsd_suspend,
-	.resume		= davinci_mmcsd_resume,
 };
 
 static int __init davinci_mmcsd_init(void)
-- 
1.7.0.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1CUIEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:04:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1CUIEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:04:38 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, sameo@linux.intel.com, grant.likely@secretlab.ca,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/5] mmc: sdhci: make sdhci-cns3xxx driver self registered
Date: Mon, 21 Mar 2011 16:07:00 +0800
Message-Id: <1300694823-8300-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds sdhci-cns3xxx its own .probe and .remove which in turn
call into the common functions provided by sdhci-pltfm.c, so that
sdhci-cns3xxx driver registers itself and keep all sdhci-cns3xxx
specific things like sdhci_cns3xxx_pdata away from sdhci-pltfm.c which
is common.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/sdhci-cns3xxx.c |   68 +++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/sdhci-pltfm.c   |    3 --
 drivers/mmc/host/sdhci-pltfm.h   |    1 -
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
index 9ebd1d7..97d19cd 100644
--- a/drivers/mmc/host/sdhci-cns3xxx.c
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -86,7 +86,7 @@ static struct sdhci_ops sdhci_cns3xxx_ops = {
 	.set_clock	= sdhci_cns3xxx_set_clock,
 };
 
-struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
+static struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
 	.ops = &sdhci_cns3xxx_ops,
 	.quirks = SDHCI_QUIRK_BROKEN_DMA |
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
@@ -95,3 +95,69 @@ struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
 		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK,
 };
+
+static int __devinit sdhci_cns3xxx_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	int ret;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_cns3xxx_pdata);
+	if (!host)
+		return -ENOMEM;
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto err_add_host;
+
+	return 0;
+
+err_add_host:
+	sdhci_pltfm_free(pdev);
+	return ret;
+}
+
+static int __devexit sdhci_cns3xxx_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	int dead = 0;
+	u32 scratch;
+
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+
+	sdhci_remove_host(pdev, dead);
+	sdhci_pltfm_free(pdev);
+
+	return 0;
+}
+
+static struct platform_driver sdhci_cns3xxx_driver = {
+	.driver		= {
+		.name	= "sdhci-cns3xxx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sdhci_cns3xxx_probe,
+	.remove		= __devexit_p(sdhci_cns3xxx_remove),
+#ifdef CONFIG_PM
+	.suspend	= sdhci_pltfm_suspend,
+	.resume		= sdhci_pltfm_resume,
+#endif
+};
+
+static int __init sdhci_cns3xxx_init(void)
+{
+	return platform_driver_register(&sdhci_cns3xxx_driver);
+}
+
+static void __exit sdhci_cns3xxx_exit(void)
+{
+	platform_driver_unregister(&sdhci_cns3xxx_driver);
+}
+
+module_init(sdhci_cns3xxx_init);
+module_exit(sdhci_cns3xxx_exit);
+
+MODULE_DESCRIPTION("SDHCI driver for CNS3xxx");
+MODULE_AUTHOR("Anton Vorontsov <avorontsov@mvista.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 38b8cb4..b9a904d 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -272,9 +272,6 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
 
 static const struct platform_device_id sdhci_pltfm_ids[] = {
 	{ "sdhci", },
-#ifdef CONFIG_MMC_SDHCI_CNS3XXX
-	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
-#endif
 #ifdef CONFIG_MMC_SDHCI_DOVE
 	{ "sdhci-dove", (kernel_ulong_t)&sdhci_dove_pdata },
 #endif
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 8357eba..493a8d0 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -21,7 +21,6 @@ struct sdhci_pltfm_host {
 	u32 scratchpad; /* to handle quirks across io-accessor calls */
 };
 
-extern struct sdhci_pltfm_data sdhci_cns3xxx_pdata;
 extern struct sdhci_pltfm_data sdhci_dove_pdata;
 extern struct sdhci_pltfm_data sdhci_tegra_pdata;
 extern struct sdhci_pltfm_data sdhci_tegra_dt_pdata;
-- 
1.7.1


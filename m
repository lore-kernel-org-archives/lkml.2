Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0EMTBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:01:51 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55100 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126Ab0EMTBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:01:47 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
       Manuel Lauss <manuel.lauss@gmail.com>, Cliff Cai <cliff.cai@analog.com>,
       =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
       Pavel Pisa <ppisa@pikron.com>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sascha Sommer <saschasommer@freenet.de>, Alex Dubov <oakad@yahoo.com>,
       Ian Molton <ian@mnementh.co.uk>, Joseph Chan <JosephChan@via.com.tw>,
       Harald Welte <HaraldWelte@viatech.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH] mmc: drop the "state" argument to mmc_suspend_host()
Date: Thu, 13 May 2010 20:01:45 +0100
Message-Id: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though many mmc host drivers pass a pm_message_t argument to
mmc_suspend_host() that argument isn't used the by MMC core. As host
drivers are converted to dev_pm_ops they'll have to construct
pm_message_t's (as they won't be passed by the PM subsystem any more)
just to appease the mmc suspend interface.

We might as well just delete the unused paramter.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 drivers/mmc/core/core.c          |    3 +--
 drivers/mmc/host/at91_mci.c      |    2 +-
 drivers/mmc/host/au1xmmc.c       |    2 +-
 drivers/mmc/host/bfin_sdh.c      |    2 +-
 drivers/mmc/host/cb710-mmc.c     |    2 +-
 drivers/mmc/host/davinci_mmc.c   |    2 +-
 drivers/mmc/host/imxmmc.c        |    2 +-
 drivers/mmc/host/mmci.c          |    2 +-
 drivers/mmc/host/msm_sdcc.c      |    2 +-
 drivers/mmc/host/mvsdio.c        |    2 +-
 drivers/mmc/host/mxcmmc.c        |    2 +-
 drivers/mmc/host/omap.c          |    2 +-
 drivers/mmc/host/omap_hsmmc.c    |    2 +-
 drivers/mmc/host/pxamci.c        |    2 +-
 drivers/mmc/host/s3cmci.c        |    3 +--
 drivers/mmc/host/sdhci-of-core.c |    2 +-
 drivers/mmc/host/sdhci.c         |    2 +-
 drivers/mmc/host/sdricoh_cs.c    |    2 +-
 drivers/mmc/host/tifm_sd.c       |    2 +-
 drivers/mmc/host/tmio_mmc.c      |    2 +-
 drivers/mmc/host/via-sdmmc.c     |    2 +-
 drivers/mmc/host/wbsd.c          |    2 +-
 include/linux/mmc/host.h         |    2 +-
 23 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 3168ebd..569e94d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1252,9 +1252,8 @@ EXPORT_SYMBOL(mmc_card_can_sleep);
 /**
  *	mmc_suspend_host - suspend a host
  *	@host: mmc host
- *	@state: suspend mode (PM_SUSPEND_xxx)
  */
-int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
+int mmc_suspend_host(struct mmc_host *host)
 {
 	int err = 0;
 
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index a6dd7da..c6497d0 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -1157,7 +1157,7 @@ static int at91_mci_suspend(struct platform_device *pdev, pm_message_t state)
 		enable_irq_wake(host->board->det_pin);
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index f583444..c8da5d3 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1142,7 +1142,7 @@ static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
 	struct au1xmmc_host *host = platform_get_drvdata(pdev);
 	int ret;
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc);
 	if (ret)
 		return ret;
 
diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 6919e84..4b0e677 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -576,7 +576,7 @@ static int sdh_suspend(struct platform_device *dev, pm_message_t state)
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() & ~PWR_ON);
 	peripheral_free_list(drv_data->pin_req);
diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index 92a324f..ca3bdc8 100644
--- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -675,7 +675,7 @@ static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
 	int err;
 
-	err = mmc_suspend_host(mmc, state);
+	err = mmc_suspend_host(mmc);
 	if (err)
 		return err;
 
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 3bd0ba2..40e4ee7 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1331,7 +1331,7 @@ static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
-	return mmc_suspend_host(host->mmc, msg);
+	return mmc_suspend_host(host->mmc);
 }
 
 static int davinci_mmcsd_resume(struct platform_device *pdev)
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index bf98d7c..9a68ff4 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -1115,7 +1115,7 @@ static int imxmci_suspend(struct platform_device *dev, pm_message_t state)
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 84c103a..b8d1c21 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -811,7 +811,7 @@ static int mmci_suspend(struct amba_device *dev, pm_message_t state)
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
 
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 		if (ret == 0)
 			writel(0, host->base + MMCIMASK0);
 	}
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 04ae884..1b01d91 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1214,7 +1214,7 @@ msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 			disable_irq(host->stat_irq);
 
 		if (mmc->card && mmc->card->type != MMC_TYPE_SDIO)
-			rc = mmc_suspend_host(mmc, state);
+			rc = mmc_suspend_host(mmc);
 		if (!rc) {
 			writel(0, host->base + MMCIMASK0);
 
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 34e2348..366eefa 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -865,7 +865,7 @@ static int mvsd_suspend(struct platform_device *dev, pm_message_t state)
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 2df9041..8ee9051 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -848,7 +848,7 @@ static int mxcmci_suspend(struct platform_device *dev, pm_message_t state)
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, state);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 84d2804..25c6f7f 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1557,7 +1557,7 @@ static int mmc_omap_suspend(struct platform_device *pdev, pm_message_t mesg)
 		struct mmc_omap_slot *slot;
 
 		slot = host->slots[i];
-		ret = mmc_suspend_host(slot->mmc, mesg);
+		ret = mmc_suspend_host(slot->mmc);
 		if (ret < 0) {
 			while (--i >= 0) {
 				slot = host->slots[i];
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e9caf69..4fe919f 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2281,7 +2281,7 @@ static int omap_hsmmc_suspend(struct platform_device *pdev, pm_message_t state)
 		}
 		cancel_work_sync(&host->mmc_carddetect_work);
 		mmc_host_enable(host->mmc);
-		ret = mmc_suspend_host(host->mmc, state);
+		ret = mmc_suspend_host(host->mmc);
 		if (ret == 0) {
 			OMAP_HSMMC_WRITE(host->base, ISE, 0);
 			OMAP_HSMMC_WRITE(host->base, IE, 0);
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 0ed4895..52770fa 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -813,7 +813,7 @@ static int pxamci_suspend(struct device *dev)
 	int ret = 0;
 
 	if (mmc)
-		ret = mmc_suspend_host(mmc, PMSG_SUSPEND);
+		ret = mmc_suspend_host(mmc);
 
 	return ret;
 }
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 2fdf768..2e16e0a 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1881,9 +1881,8 @@ MODULE_DEVICE_TABLE(platform, s3cmci_driver_ids);
 static int s3cmci_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
-	struct pm_message event = { PM_EVENT_SUSPEND };
 
-	return mmc_suspend_host(mmc, event);
+	return mmc_suspend_host(mmc);
 }
 
 static int s3cmci_resume(struct device *dev)
diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
index 55e3313..034826d 100644
--- a/drivers/mmc/host/sdhci-of-core.c
+++ b/drivers/mmc/host/sdhci-of-core.c
@@ -89,7 +89,7 @@ static int sdhci_of_suspend(struct of_device *ofdev, pm_message_t state)
 {
 	struct sdhci_host *host = dev_get_drvdata(&ofdev->dev);
 
-	return mmc_suspend_host(host->mmc, state);
+	return mmc_suspend_host(host->mmc);
 }
 
 static int sdhci_of_resume(struct of_device *ofdev)
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9d4fdfa..d297863 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1587,7 +1587,7 @@ int sdhci_suspend_host(struct sdhci_host *host, pm_message_t state)
 
 	sdhci_disable_card_detection(host);
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc);
 	if (ret)
 		return ret;
 
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index cb41e9c..e7507af 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -519,7 +519,7 @@ static int sdricoh_pcmcia_suspend(struct pcmcia_device *link)
 {
 	struct mmc_host *mmc = link->priv;
 	dev_dbg(&link->dev, "suspend\n");
-	mmc_suspend_host(mmc, PMSG_SUSPEND);
+	mmc_suspend_host(mmc);
 	return 0;
 }
 
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 82554dd..cec9995 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -1032,7 +1032,7 @@ static void tifm_sd_remove(struct tifm_dev *sock)
 
 static int tifm_sd_suspend(struct tifm_dev *sock, pm_message_t state)
 {
-	return mmc_suspend_host(tifm_get_drvdata(sock), state);
+	return mmc_suspend_host(tifm_get_drvdata(sock));
 }
 
 static int tifm_sd_resume(struct tifm_dev *sock)
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index b2b577f..940e373 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -475,7 +475,7 @@ static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret;
 
-	ret = mmc_suspend_host(mmc, state);
+	ret = mmc_suspend_host(mmc);
 
 	/* Tell MFD core it can disable us now.*/
 	if (!ret && cell->disable)
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 632858a..19f2d72 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1280,7 +1280,7 @@ static int via_sd_suspend(struct pci_dev *pcidev, pm_message_t state)
 	via_save_pcictrlreg(host);
 	via_save_sdcreg(host);
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc);
 
 	pci_save_state(pcidev);
 	pci_enable_wake(pcidev, pci_choose_state(pcidev, state), 0);
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 69efe01..0012f5d 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1819,7 +1819,7 @@ static int wbsd_suspend(struct wbsd_host *host, pm_message_t state)
 {
 	BUG_ON(host == NULL);
 
-	return mmc_suspend_host(host->mmc, state);
+	return mmc_suspend_host(host->mmc);
 }
 
 static int wbsd_resume(struct wbsd_host *host)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 43eaf5c..1b4e214 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -227,7 +227,7 @@ static inline void *mmc_priv(struct mmc_host *host)
 #define mmc_classdev(x)	(&(x)->class_dev)
 #define mmc_hostname(x)	(dev_name(&(x)->class_dev))
 
-extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
+extern int mmc_suspend_host(struct mmc_host *);
 extern int mmc_resume_host(struct mmc_host *);
 
 extern void mmc_power_save_host(struct mmc_host *host);
-- 
1.6.4.rc0


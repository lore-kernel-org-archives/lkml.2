Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1KDIQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:16:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:62538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1KDIQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:16:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="70971316"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 3/4] mmc: sdhci-pci: add platform data
Date: Fri,  4 Nov 2011 10:16:02 +0200
Message-Id: <1320394563-29682-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320394563-29682-1-git-send-email-adrian.hunter@intel.com>
References: <1320394563-29682-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a means of getting platform data for the SDHCI PCI
devices.  The data is stored against the slot not the
device in order to support multi-slot devices.

The data allows platform-specific setup (such as getting
GPIO numbers from firmware or setting up wl12xx for SDIO)
to be done in platform support files instead of the
sdhci-pci driver.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/Makefile                   |    2 +-
 drivers/mmc/Makefile               |    3 +--
 drivers/mmc/host/Makefile          |    1 +
 drivers/mmc/host/sdhci-pci-data.c  |    5 +++++
 drivers/mmc/host/sdhci-pci.c       |   32 ++++++++++++++++++++++++++++----
 include/linux/mmc/sdhci-pci-data.h |   18 ++++++++++++++++++
 6 files changed, 54 insertions(+), 7 deletions(-)
 create mode 100644 drivers/mmc/host/sdhci-pci-data.c
 create mode 100644 include/linux/mmc/sdhci-pci-data.h

diff --git a/drivers/Makefile b/drivers/Makefile
index 7fa433a..fe621d9 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -95,7 +95,7 @@ obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
-obj-$(CONFIG_MMC)		+= mmc/
+obj-y				+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-y				+= leds/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
diff --git a/drivers/mmc/Makefile b/drivers/mmc/Makefile
index 12eef39..400756e 100644
--- a/drivers/mmc/Makefile
+++ b/drivers/mmc/Makefile
@@ -6,5 +6,4 @@ subdir-ccflags-$(CONFIG_MMC_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_MMC)		+= core/
 obj-$(CONFIG_MMC)		+= card/
-obj-$(CONFIG_MMC)		+= host/
-
+obj-$(subst m,y,$(CONFIG_MMC))	+= host/
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index b4b83f3..745f8fc 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_MXS)		+= mxs-mmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
+obj-$(subst m,y,$(CONFIG_MMC_SDHCI_PCI))	+= sdhci-pci-data.o
 obj-$(CONFIG_MMC_SDHCI_PXAV3)	+= sdhci-pxav3.o
 obj-$(CONFIG_MMC_SDHCI_PXAV2)	+= sdhci-pxav2.o
 obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
diff --git a/drivers/mmc/host/sdhci-pci-data.c b/drivers/mmc/host/sdhci-pci-data.c
new file mode 100644
index 0000000..a611217
--- /dev/null
+++ b/drivers/mmc/host/sdhci-pci-data.c
@@ -0,0 +1,5 @@
+#include <linux/module.h>
+#include <linux/mmc/sdhci-pci-data.h>
+
+struct sdhci_pci_data *(*sdhci_pci_get_data)(struct pci_dev *pdev, int slotno);
+EXPORT_SYMBOL_GPL(sdhci_pci_get_data);
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d833d9c..9d1874a 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -25,6 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/sfi.h>
 #include <linux/pm_runtime.h>
+#include <linux/mmc/sdhci-pci-data.h>
 
 #include "sdhci.h"
 
@@ -62,6 +63,7 @@ struct sdhci_pci_fixes {
 struct sdhci_pci_slot {
 	struct sdhci_pci_chip	*chip;
 	struct sdhci_host	*host;
+	struct sdhci_pci_data	*data;
 
 	int			pci_bar;
 	int			rst_n_gpio;
@@ -1188,11 +1190,12 @@ static const struct dev_pm_ops sdhci_pci_pm_ops = {
 \*****************************************************************************/
 
 static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
-	struct pci_dev *pdev, struct sdhci_pci_chip *chip, int bar)
+	struct pci_dev *pdev, struct sdhci_pci_chip *chip, int first_bar,
+	int slotno)
 {
 	struct sdhci_pci_slot *slot;
 	struct sdhci_host *host;
-	int ret;
+	int ret, bar = first_bar + slotno;
 
 	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "BAR %d is not iomem. Aborting.\n", bar);
@@ -1227,6 +1230,20 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	slot->pci_bar = bar;
 	slot->rst_n_gpio = -EINVAL;
 
+	/* Retrieve platform data if there is any */
+	if (*sdhci_pci_get_data)
+		slot->data = sdhci_pci_get_data(pdev, slotno);
+
+	if (slot->data) {
+		if (slot->data->setup) {
+			ret = slot->data->setup(slot->data);
+			if (ret) {
+				dev_err(&pdev->dev, "platform setup failed\n");
+				goto free;
+			}
+		}
+	}
+
 	host->hw_name = "PCI";
 	host->ops = &sdhci_pci_ops;
 	host->quirks = chip->quirks;
@@ -1236,7 +1253,7 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	ret = pci_request_region(pdev, bar, mmc_hostname(host->mmc));
 	if (ret) {
 		dev_err(&pdev->dev, "cannot request region\n");
-		goto free;
+		goto cleanup;
 	}
 
 	host->ioaddr = pci_ioremap_bar(pdev, bar);
@@ -1270,6 +1287,10 @@ unmap:
 release:
 	pci_release_region(pdev, bar);
 
+cleanup:
+	if (slot->data && slot->data->cleanup)
+		slot->data->cleanup(slot->data);
+
 free:
 	sdhci_free_host(host);
 
@@ -1291,6 +1312,9 @@ static void sdhci_pci_remove_slot(struct sdhci_pci_slot *slot)
 	if (slot->chip->fixes && slot->chip->fixes->remove_slot)
 		slot->chip->fixes->remove_slot(slot, dead);
 
+	if (slot->data && slot->data->cleanup)
+		slot->data->cleanup(slot->data);
+
 	pci_release_region(slot->chip->pdev, slot->pci_bar);
 
 	sdhci_free_host(slot->host);
@@ -1377,7 +1401,7 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 	slots = chip->num_slots;	/* Quirk may have changed this */
 
 	for (i = 0; i < slots; i++) {
-		slot = sdhci_pci_probe_slot(pdev, chip, first_bar + i);
+		slot = sdhci_pci_probe_slot(pdev, chip, first_bar, i);
 		if (IS_ERR(slot)) {
 			for (i--; i >= 0; i--)
 				sdhci_pci_remove_slot(chip->slots[i]);
diff --git a/include/linux/mmc/sdhci-pci-data.h b/include/linux/mmc/sdhci-pci-data.h
new file mode 100644
index 0000000..8959604
--- /dev/null
+++ b/include/linux/mmc/sdhci-pci-data.h
@@ -0,0 +1,18 @@
+#ifndef LINUX_MMC_SDHCI_PCI_DATA_H
+#define LINUX_MMC_SDHCI_PCI_DATA_H
+
+struct pci_dev;
+
+struct sdhci_pci_data {
+	struct pci_dev	*pdev;
+	int		slotno;
+	int		rst_n_gpio; /* Set to -EINVAL if unused */
+	int		cd_gpio;    /* Set to -EINVAL if unused */
+	int		(*setup)(struct sdhci_pci_data *data);
+	void		(*cleanup)(struct sdhci_pci_data *data);
+};
+
+extern struct sdhci_pci_data *(*sdhci_pci_get_data)(struct pci_dev *pdev,
+				int slotno);
+
+#endif
-- 
1.7.6.4


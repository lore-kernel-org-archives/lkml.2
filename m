Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2KHNEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:04:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:24988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2KHNEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:04:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102381"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 16/26] mmc: sdhci: panic write: no sleeping
Date: Thu,  8 Nov 2012 15:06:14 +0200
Message-Id: <1352379984-18381-17-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/host/sdhci.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 1ed78f0..827e34f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1536,6 +1536,14 @@ static int sdhci_check_ro(struct sdhci_host *host)
 
 #define SAMPLE_COUNT	5
 
+static void sdhci_msleep(struct sdhci_host *host, unsigned int ms)
+{
+	if (mmc_am_panic_task(host->mmc))
+		mdelay(ms);
+	else
+		msleep(ms);
+}
+
 static int sdhci_do_get_ro(struct sdhci_host *host)
 {
 	int i, ro_count;
@@ -1549,7 +1557,7 @@ static int sdhci_do_get_ro(struct sdhci_host *host)
 			if (++ro_count > SAMPLE_COUNT / 2)
 				return 1;
 		}
-		msleep(30);
+		sdhci_msleep(host, 30);
 	}
 	return 0;
 }
@@ -1605,6 +1613,14 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 	sdhci_unlock_irqrestore(host, flags);
 }
 
+#define sdhci_usleep_range(host, min, max)		\
+do {							\
+	if (mmc_am_panic_task((host)->mmc))		\
+		mdelay(DIV_ROUND_UP(min, 1000));	\
+	else						\
+		usleep_range(min, max);			\
+} while (0)
+
 static int sdhci_do_3_3v_signal_voltage_switch(struct sdhci_host *host,
 						u16 ctrl)
 {
@@ -1623,7 +1639,7 @@ static int sdhci_do_3_3v_signal_voltage_switch(struct sdhci_host *host,
 		}
 	}
 	/* Wait for 5ms */
-	usleep_range(5000, 5500);
+	sdhci_usleep_range(host, 5000, 5500);
 
 	/* 3.3V regulator output should be stable within 5 ms */
 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
@@ -1668,7 +1684,7 @@ static int sdhci_do_1_8v_signal_voltage_switch(struct sdhci_host *host,
 			sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 
 			/* Wait for 5ms */
-			usleep_range(5000, 5500);
+			sdhci_usleep_range(host, 5000, 5500);
 
 			ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 			if (ctrl & SDHCI_CTRL_VDD_180) {
@@ -1676,7 +1692,7 @@ static int sdhci_do_1_8v_signal_voltage_switch(struct sdhci_host *host,
 				clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
 				clk |= SDHCI_CLOCK_CARD_EN;
 				sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
-				usleep_range(1000, 1500);
+				sdhci_usleep_range(host, 1000, 1500);
 
 				/*
 				 * If DAT[3:0] level is 1111b, then the card
@@ -1703,7 +1719,7 @@ static int sdhci_do_1_8v_signal_voltage_switch(struct sdhci_host *host,
 		regulator_disable(host->vmmc);
 
 	/* Wait for 1ms as per the spec */
-	usleep_range(1000, 1500);
+	sdhci_usleep_range(host, 1000, 1500);
 	pwr |= SDHCI_POWER_ON;
 	sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);
 	if (host->vmmc)
-- 
1.7.9.5


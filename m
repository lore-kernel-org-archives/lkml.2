Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2GQKYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:24:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53749 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GQKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:24:38 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-2e-50053d65c48e
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 3/9] mmc: dw_mmc: lookup for optional biu and ciu clocks
Date: Tue, 17 Jul 2012 16:08:58 +0530
Message-id: <1342521538-12790-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <CAGxe1ZGMvrec-nEYdZJ84Hub0fByYvnkCY_dRq2k489gCRSxQg@mail.gmail.com>
References: <CAGxe1ZGMvrec-nEYdZJ84Hub0fByYvnkCY_dRq2k489gCRSxQg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t9jAd1UW9YAg1e7JCwu75rDZnHkfz+j
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgyvi9Yi1jwSeJij3XJ7A1MJ4Q6WLk5JAQMJFY
	vqWPEcIWk7hwbz1bFyMXh5DAIkaJZbMPMIMkhATamCRmb6wAsdkEDCQeLXzHDmKLCDhJLJk7
	gRmkgVngDqPEo1knwSYJC3hI7F03G6yZRUBV4vGLG2ANvAKeEv8PrGWG2KYksaH3KBOIzSkQ
	LHG6+T47xLIAiW/L2pkmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcBs+kdjCu
	bLA4xCjAwajEw7vAnDVAiDWxrLgy9xCjBAezkgjvahOgEG9KYmVValF+fFFpTmrxIUZpDhYl
	cV5j76/+QgLpiSWp2ampBalFMFkmDk6pBkZnQV0um9jeVs606YnmNUFWa1T2dj2WVdg8x1wj
	TliyTv3lPM1c5c8PoxZycj+UWP7A5eqzlL08D/ZNXP/30j3rMvPUZB/L/7oCsuUfZO3WJR14
	F+B89u1TD9WfvPut8oVOSSdqypdVruGTuOZjVDNjSYXiJOn1pYavP0nHXlP6LnzuxIHPz5RY
	ijMSDbWYi4oTAZl0VG//AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms allow for clock gating and control of bus interface unit clock
and card interface unit clock. Add support for clock lookup of optional biu
and ciu clocks for clock gating and clock speed determination.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/mmc/host/dw_mmc.c  |   39 ++++++++++++++++++++++++++++++++++++---
 include/linux/mmc/dw_mmc.h |    4 ++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index cd58063..ebd22d8 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1953,13 +1953,30 @@ int dw_mci_probe(struct dw_mci *host)
 		return -ENODEV;
 	}
 
-	if (!host->pdata->bus_hz) {
+	host->biu_clk = clk_get(host->dev, "biu");
+	if (IS_ERR(host->biu_clk))
+		dev_dbg(host->dev, "biu clock not available\n");
+	else
+		clk_prepare_enable(host->biu_clk);
+
+	host->ciu_clk = clk_get(host->dev, "ciu");
+	if (IS_ERR(host->ciu_clk))
+		dev_dbg(host->dev, "ciu clock not available\n");
+	else
+		clk_prepare_enable(host->ciu_clk);
+
+	if (IS_ERR(host->ciu_clk))
+		host->bus_hz = host->pdata->bus_hz;
+	else
+		host->bus_hz = clk_get_rate(host->ciu_clk);
+
+	if (!host->bus_hz) {
 		dev_err(host->dev,
 			"Platform data must supply bus speed\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_clk;
 	}
 
-	host->bus_hz = host->pdata->bus_hz;
 	host->quirks = host->pdata->quirks;
 
 	spin_lock_init(&host->lock);
@@ -2109,6 +2126,16 @@ err_dmaunmap:
 		regulator_disable(host->vmmc);
 		regulator_put(host->vmmc);
 	}
+
+err_clk:
+	if (!IS_ERR(host->ciu_clk)) {
+		clk_disable_unprepare(host->ciu_clk);
+		clk_put(host->ciu_clk);
+	}
+	if (!IS_ERR(host->biu_clk)) {
+		clk_disable_unprepare(host->biu_clk);
+		clk_put(host->biu_clk);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(dw_mci_probe);
@@ -2142,6 +2169,12 @@ void dw_mci_remove(struct dw_mci *host)
 		regulator_put(host->vmmc);
 	}
 
+	if (!IS_ERR(host->ciu_clk))
+		clk_disable_unprepare(host->ciu_clk);
+	if (!IS_ERR(host->biu_clk))
+		clk_disable_unprepare(host->biu_clk);
+	clk_put(host->ciu_clk);
+	clk_put(host->biu_clk);
 }
 EXPORT_SYMBOL(dw_mci_remove);
 
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index a37a573..787ad56 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -78,6 +78,8 @@ struct mmc_data;
  * @data_offset: Set the offset of DATA register according to VERID.
  * @dev: Device associated with the MMC controller.
  * @pdata: Platform data associated with the MMC controller.
+ * @biu_clk: Pointer to bus interface unit clock instance.
+ * @ciu_clk: Pointer to card interface unit clock instance.
  * @slot: Slots sharing this MMC controller.
  * @fifo_depth: depth of FIFO.
  * @data_shift: log2 of FIFO item size.
@@ -158,6 +160,8 @@ struct dw_mci {
 	u16			data_offset;
 	struct device		*dev;
 	struct dw_mci_board	*pdata;
+	struct clk		*biu_clk;
+	struct clk		*ciu_clk;
 	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
 
 	/* FIFO push and pull */
-- 
1.6.6.rc2


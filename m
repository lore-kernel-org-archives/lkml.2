Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab2GLMlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:41:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34034 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2GLMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:40:48 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-1b-4ffec5cf251b
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v3 3/6] mmc: dw_mmc: lookup for optional biu and ciu clocks
Date: Thu, 12 Jul 2012 18:24:25 +0530
Message-id: <1342097668-25243-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t9jAd3zR//5G1y4J2JxedccNosj//sZ
	LWac38fkwOzxeZNcAGMUl01Kak5mWWqRvl0CV8aH9h7mghNSFdc7WhgbGN+JdjFycEgImEgc
	62LpYuQEMsUkLtxbz9bFyMUhJLCIUWJD50dGCKeNSeJdazsbSBWbgIHEo4Xv2EFsEQEniSVz
	JzCDFDEL3GGUeDTrJCNIQljAW2Lb6wdgY1kEVCVezrjEDLKNV8BT4twMDohtShIbeo8ygdic
	Al4S11e2sIKUCAGVvPrjMIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4BB4JrWD
	cWWDxSFGAQ5GJR7eDwf++QuxJpYVV+YeYpTgYFYS4e3PBQrxpiRWVqUW5ccXleakFh9ilOZg
	URLnNfb+6i8kkJ5YkpqdmlqQWgSTZeLglGpgnFuQWyayL36ahtPUY8o1Ng+jVv3lmr3v/M4f
	br9EsuxNS5Zw8e7bd+f9TSX/1GVM6wUdvZNjZ37/aFg6W79FnkHl6kTRA1cPFu9meSS4RWip
	oPynkF1+WztX+ikJ1y573HnhlLLyHKu4q4tP1kZv70lRM9pz06x304kUoV2q+q8Uln9Zfjvh
	gxJLcUaioRZzUXEiAEr5nSD9AQAA
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
 drivers/mmc/host/dw_mmc.c  |   42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/mmc/dw_mmc.h |    4 ++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index cd58063..679473c 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1953,18 +1953,38 @@ int dw_mci_probe(struct dw_mci *host)
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
 	INIT_LIST_HEAD(&host->queue);
 
+	host->dma_ops = host->pdata->dma_ops;
+	dw_mci_init_dma(host);
+
 	/*
 	 * Get the host data width - this assumes that HCON has been set with
 	 * the correct values.
@@ -2109,6 +2129,16 @@ err_dmaunmap:
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
@@ -2142,6 +2172,12 @@ void dw_mci_remove(struct dw_mci *host)
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


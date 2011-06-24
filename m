Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1FXNMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:12:17 -0400
Received: from multi.imgtec.com ([194.200.65.239]:3460 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1FXNMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:12:07 -0400
Message-ID: <4E04895B.1070408@imgtec.com>
Date: Fri, 24 Jun 2011 13:55:55 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Subject: [PATCH 3/6] mmc: dw_mmc: convert card tasklet to workqueue
References: <4E0488A9.6050109@imgtec.com>
In-Reply-To: <4E0488A9.6050109@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:55:55.0601 (UTC) FILETIME=[0E623410:01CC326E]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_55_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the card insert/remove tasklet to a workqueue, and call the
setpower platform specific callback without the spinlock held. This
means neither of the setpower or get_cd callbacks are called from atomic
context which allows them to sleep.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c  |   50 +++++++++++++++++++++++++++----------------
 include/linux/mmc/dw_mmc.h |    2 +-
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index c4bddf6..3f610d5 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -33,6 +33,7 @@
 #include <linux/mmc/dw_mmc.h>
 #include <linux/bitops.h>
 #include <linux/regulator/consumer.h>
+#include <linux/workqueue.h>
 
 #include "dw_mmc.h"
 
@@ -100,6 +101,8 @@ struct dw_mci_slot {
 	int			last_detect_state;
 };
 
+static struct workqueue_struct *dw_mci_card_workqueue;
+
 #if defined(CONFIG_DEBUG_FS)
 static int dw_mci_req_show(struct seq_file *s, void *v)
 {
@@ -1255,7 +1258,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 
 		if (pending & SDMMC_INT_CD) {
 			mci_writel(host, RINTSTS, SDMMC_INT_CD);
-			tasklet_schedule(&host->card_tasklet);
+			queue_work(dw_mci_card_workqueue, &host->card_work);
 		}
 
 	} while (pass_count++ < 5);
@@ -1274,9 +1277,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void dw_mci_tasklet_card(unsigned long data)
+static void dw_mci_work_routine_card(struct work_struct *work)
 {
-	struct dw_mci *host = (struct dw_mci *)data;
+	struct dw_mci *host = container_of(work, struct dw_mci, card_work);
 	int i;
 
 	for (i = 0; i < host->num_slots; i++) {
@@ -1288,22 +1291,21 @@ static void dw_mci_tasklet_card(unsigned long data)
 
 		present = dw_mci_get_cd(mmc);
 		while (present != slot->last_detect_state) {
-			spin_lock(&host->lock);
-
 			dev_dbg(&slot->mmc->class_dev, "card %s\n",
 				present ? "inserted" : "removed");
 
+			/* Power up slot (before spin_lock, may sleep) */
+			if (present != 0 && host->pdata->setpower)
+				host->pdata->setpower(slot->id, mmc->ocr_avail);
+
+			spin_lock_bh(&host->lock);
+
 			/* Card change detected */
 			slot->last_detect_state = present;
 
-			/* Power up slot */
-			if (present != 0) {
-				if (host->pdata->setpower)
-					host->pdata->setpower(slot->id,
-							      mmc->ocr_avail);
-
+			/* Mark card as present if applicable */
+			if (present != 0)
 				set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
-			}
 
 			/* Clean up queue if present */
 			mrq = slot->mrq;
@@ -1353,8 +1355,6 @@ static void dw_mci_tasklet_card(unsigned long data)
 
 			/* Power down slot */
 			if (present == 0) {
-				if (host->pdata->setpower)
-					host->pdata->setpower(slot->id, 0);
 				clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
 
 				/*
@@ -1376,7 +1376,12 @@ static void dw_mci_tasklet_card(unsigned long data)
 
 			}
 
-			spin_unlock(&host->lock);
+			spin_unlock_bh(&host->lock);
+
+			/* Power down slot (after spin_unlock, may sleep) */
+			if (present == 0 && host->pdata->setpower)
+				host->pdata->setpower(slot->id, 0);
+
 			present = dw_mci_get_cd(mmc);
 		}
 
@@ -1476,7 +1481,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	 * Card may have been plugged in prior to boot so we
 	 * need to run the detect tasklet
 	 */
-	tasklet_schedule(&host->card_tasklet);
+	queue_work(dw_mci_card_workqueue, &host->card_work);
 
 	return 0;
 }
@@ -1665,12 +1670,15 @@ static int dw_mci_probe(struct platform_device *pdev)
 	mci_writel(host, CLKSRC, 0);
 
 	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
-	tasklet_init(&host->card_tasklet,
-		     dw_mci_tasklet_card, (unsigned long)host);
+	dw_mci_card_workqueue = alloc_workqueue("dw-mci-card",
+			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
+	if (!dw_mci_card_workqueue)
+		goto err_dmaunmap;
+	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
 
 	ret = request_irq(irq, dw_mci_interrupt, 0, "dw-mci", host);
 	if (ret)
-		goto err_dmaunmap;
+		goto err_workqueue;
 
 	platform_set_drvdata(pdev, host);
 
@@ -1714,6 +1722,9 @@ err_init_slot:
 	}
 	free_irq(irq, host);
 
+err_workqueue:
+	destroy_workqueue(dw_mci_card_workqueue);
+
 err_dmaunmap:
 	if (host->use_dma && host->dma_ops->exit)
 		host->dma_ops->exit(host);
@@ -1753,6 +1764,7 @@ static int __exit dw_mci_remove(struct platform_device *pdev)
 	mci_writel(host, CLKSRC, 0);
 
 	free_irq(platform_get_irq(pdev, 0), host);
+	destroy_workqueue(dw_mci_card_workqueue);
 	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
 
 	if (host->use_dma && host->dma_ops->exit)
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 55d9909..dea4847 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -131,7 +131,7 @@ struct dw_mci {
 	u32			stop_cmdr;
 	u32			dir_status;
 	struct tasklet_struct	tasklet;
-	struct tasklet_struct	card_tasklet;
+	struct work_struct	card_work;
 	unsigned long		pending_events;
 	unsigned long		completed_events;
 	enum dw_mci_state	state;
-- 
1.7.2.3



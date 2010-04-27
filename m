Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0D0NWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:22:35 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55179 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab0D0NWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:22:31 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Anders Grahn <anders.grahn@hd-wireless.se>
Subject: [PATCH 4/4] MMC: atmel-mci: Add support for SDIO interrupts
Date: Tue, 27 Apr 2010 16:36:29 +0200
Message-Id: <12c815b6060bc044238d63a686de517e43e90184.1272378853.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1271671952-29204-1-git-send-email-nicolas.ferre@atmel.com>
References: <1271671952-29204-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <bfa27c51250b39deeccbf6f3a656db4e0b73ce92.1272378853.git.nicolas.ferre@atmel.com>
References: <bfa27c51250b39deeccbf6f3a656db4e0b73ce92.1272378853.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Grahn <anders.grahn@hd-wireless.se>

Atmel-mci support for SDIO interrupts. This adds the enable_sdio_irq() function
and the configuration of sdio irq mask per slot. With this irq mask
information, we keep the idea of multiple slot per sd/mmc host (not only
A and B).
MMC_CAP_SDIO_IRQ is added according to slot configuration.

A new little function is added to run mmc_signal_sdio_irq() during interrupt
handling routine.

Signed-off-by: Anders Grahn <anders.grahn@hd-wireless.se>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 68b47cc..fd96ab9 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -173,6 +173,7 @@ struct atmel_mci {
  * @mmc: The mmc_host representing this slot.
  * @host: The MMC controller this slot is using.
  * @sdc_reg: Value of SDCR to be written before using this slot.
+ * @sdio_irq: SDIO irq mask for this slot.
  * @mrq: mmc_request currently being processed or waiting to be
  *	processed, or NULL when the slot is idle.
  * @queue_node: List node for placing this node in the @queue list of
@@ -191,6 +192,7 @@ struct atmel_mci_slot {
 	struct atmel_mci	*host;
 
 	u32			sdc_reg;
+	u32			sdio_irq;
 
 	struct mmc_request	*mrq;
 	struct list_head	queue_node;
@@ -792,7 +794,7 @@ static void atmci_start_request(struct atmel_mci *host,
 	mci_writel(host, SDCR, slot->sdc_reg);
 
 	iflags = mci_readl(host, IMR);
-	if (iflags)
+	if (iflags & ~(MCI_SDIOIRQA | MCI_SDIOIRQB))
 		dev_warn(&slot->mmc->class_dev, "WARNING: IMR=0x%08x\n",
 				iflags);
 
@@ -1041,11 +1043,23 @@ static int atmci_get_cd(struct mmc_host *mmc)
 	return present;
 }
 
+static void atmci_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct atmel_mci_slot	*slot = mmc_priv(mmc);
+	struct atmel_mci	*host = slot->host;
+
+	if (enable)
+		mci_writel(host, IER, slot->sdio_irq);
+	else
+		mci_writel(host, IDR, slot->sdio_irq);
+}
+
 static const struct mmc_host_ops atmci_ops = {
 	.request	= atmci_request,
 	.set_ios	= atmci_set_ios,
 	.get_ro		= atmci_get_ro,
 	.get_cd		= atmci_get_cd,
+	.enable_sdio_irq = atmci_enable_sdio_irq,
 };
 
 /* Called with host->lock held */
@@ -1497,6 +1511,19 @@ static void atmci_cmd_interrupt(struct atmel_mci *host, u32 status)
 	tasklet_schedule(&host->tasklet);
 }
 
+static void atmci_sdio_interrupt(struct atmel_mci *host, u32 status)
+{
+	int	i;
+
+	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+		struct atmel_mci_slot *slot = host->slot[i];
+		if (slot && (status & slot->sdio_irq)) {
+			mmc_signal_sdio_irq(slot->mmc);
+		}
+	}
+}
+
+
 static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 {
 	struct atmel_mci	*host = dev_id;
@@ -1536,6 +1563,10 @@ static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 
 		if (pending & MCI_CMDRDY)
 			atmci_cmd_interrupt(host, status);
+
+		if (pending & (MCI_SDIOIRQA | MCI_SDIOIRQB))
+			atmci_sdio_interrupt(host, status);
+
 	} while (pass_count++ < 5);
 
 	return pass_count ? IRQ_HANDLED : IRQ_NONE;
@@ -1558,7 +1589,7 @@ static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
 
 static int __init atmci_init_slot(struct atmel_mci *host,
 		struct mci_slot_pdata *slot_data, unsigned int id,
-		u32 sdc_reg)
+		u32 sdc_reg, u32 sdio_irq)
 {
 	struct mmc_host			*mmc;
 	struct atmel_mci_slot		*slot;
@@ -1574,11 +1605,14 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	slot->wp_pin = slot_data->wp_pin;
 	slot->detect_is_active_high = slot_data->detect_is_active_high;
 	slot->sdc_reg = sdc_reg;
+	slot->sdio_irq = sdio_irq;
 
 	mmc->ops = &atmci_ops;
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (sdio_irq)
+		mmc->caps |= MMC_CAP_SDIO_IRQ;
 	if (atmci_is_mci2())
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 	if (slot_data->bus_width >= 4)
@@ -1769,13 +1803,13 @@ static int __init atmci_probe(struct platform_device *pdev)
 	ret = -ENODEV;
 	if (pdata->slot[0].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[0],
-				0, MCI_SDCSEL_SLOT_A);
+				0, MCI_SDCSEL_SLOT_A, MCI_SDIOIRQA);
 		if (!ret)
 			nr_slots++;
 	}
 	if (pdata->slot[1].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[1],
-				1, MCI_SDCSEL_SLOT_B);
+				1, MCI_SDCSEL_SLOT_B, MCI_SDIOIRQB);
 		if (!ret)
 			nr_slots++;
 	}
-- 
1.5.6.5


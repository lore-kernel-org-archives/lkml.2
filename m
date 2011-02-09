Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1BIKh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:37:59 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab1BIKh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:37:58 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/8] intel_mid_ssp_spi: Add the QoS quirk for slave mode
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:09:08 +0000
Message-ID: <20110209100857.555.54454.stgit@bob.linux.org.uk>
In-Reply-To: <20110209100231.555.90520.stgit@bob.linux.org.uk>
References: <20110209100231.555.90520.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is needed for Moorestown. Again we add this so that the default is off
and the code changed is all within if (quirks & ).

Baed on previous generic driver work by Mathieu SOULARD
<mathieux.soulard@intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/spi/intel_mid_ssp_spi.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)


diff --git a/drivers/spi/intel_mid_ssp_spi.c b/drivers/spi/intel_mid_ssp_spi.c
index c8cd3bb..26e41c2 100644
--- a/drivers/spi/intel_mid_ssp_spi.c
+++ b/drivers/spi/intel_mid_ssp_spi.c
@@ -186,6 +186,8 @@ struct driver_data {
 	int rxdma_done;
 	struct callback_param tx_param;
 	struct callback_param rx_param;
+	/* PM_QOS request (for Moorestown) */
+	struct pm_qos_request_list pm_qos_req;
 };
 
 struct chip_data {
@@ -443,6 +445,10 @@ static void dma_transfer_complete(void *arg)
 	/* Stop getting Time Outs */
 	iowrite32(0, reg + SSTO);
 
+	if (drv_data->quirks & QUIRKS_USE_PM_QOS)
+		pm_qos_update_request(&drv_data->pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
+
 	/* release DMA mappings */
 	unmap_dma_buffers(drv_data, drv_data->cur_msg);
 
@@ -556,6 +562,8 @@ static void dma_transfer(struct driver_data *drv_data)
 	struct dma_slave_config *txconf, *rxconf;
 	struct device *dev = &drv_data->pdev->dev;
 
+	if (drv_data->quirks & QUIRKS_USE_PM_QOS)
+		pm_qos_update_request(&drv_data->pm_qos_req, MIN_EXIT_LATENCY);
 	/* get Data Read/Write address */
 	ssdr_addr = (dma_addr_t)(drv_data->paddr + 0x10);
 	flag = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
@@ -1186,6 +1194,9 @@ static void cleanup(struct spi_device *spi)
 
 	if (drv_data->dma_inited)
 		intel_mid_ssp_spi_dma_exit(drv_data);
+	/* Remove the PM_QOS request */
+	if (drv_data->quirks & QUIRKS_USE_PM_QOS)
+		pm_qos_remove_request(&drv_data->pm_qos_req);
 	kfree(chip);
 	spi_set_ctldata(spi, NULL);
 }
@@ -1332,6 +1343,11 @@ static int intel_mid_ssp_spi_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, drv_data);
 
+	/* Create the PM_QOS request */
+	if (drv_data->quirks & QUIRKS_USE_PM_QOS)
+		pm_qos_add_request(&drv_data->pm_qos_req,
+			PM_QOS_CPU_DMA_LATENCY, PM_QOS_DEFAULT_VALUE);
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0KWLGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:06:49 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37688 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0KWLG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:06:26 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jamie Iles <jamie.iles@picochip.com>
Subject: [PATCH 3/4] dmaengine/dw_dmac: provide a mechanism to indicate private devices
Date: Tue, 23 Nov 2010 11:06:10 +0000
Message-Id: <1290510371-23077-4-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms (e.g. Picochip PC3XX) have multiple DMA controllers
where some may be used for slave transfers and others for general
purpose memcpy type transfers. Add a .is_private boolean to the
platform data structure so that controllers can be marked as private
so that the DMA_PRIVATE capability will be set for that controller.

Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
---
 drivers/dma/dw_dmac.c   |    2 ++
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 64024f1..bea304b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1341,6 +1341,8 @@ static int __init dw_probe(struct platform_device *pdev)
 
 	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
 	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
+	if (pdata->is_private)
+		dma_cap_set(DMA_PRIVATE, dw->dma.cap_mask);
 	dw->dma.dev = &pdev->dev;
 	dw->dma.device_alloc_chan_resources = dwc_alloc_chan_resources;
 	dw->dma.device_free_chan_resources = dwc_free_chan_resources;
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 8014eb8..deec66b 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -16,9 +16,12 @@
 /**
  * struct dw_dma_platform_data - Controller configuration parameters
  * @nr_channels: Number of channels supported by hardware (max 8)
+ * @is_private: The device channels should be marked as private and not for
+ *	by the general purpose DMA channel allocator.
  */
 struct dw_dma_platform_data {
 	unsigned int	nr_channels;
+	bool		is_private;
 };
 
 /**
-- 
1.7.2.3


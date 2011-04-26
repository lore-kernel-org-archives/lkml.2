Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1DZKE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:04:59 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33652 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116Ab1DZKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:04:56 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/4] pch_dma: fix dma direction issue for ML7213 IOH video-in
Date: Tue, 26 Apr 2011 19:05:51 +0900
Message-Id: <1303812353-6712-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303812353-6712-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1303812353-6712-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, even-channel number is set as tx direction and odd is set as rx.
However, though video-in uses ch6, the direction is not tx but rx.
This patch sets video-in's DMA direction correctly.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 9421ed5..cd7bf83 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -59,6 +59,14 @@
 #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
 #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
 
+/* PCI Device ID of DMA device */
+#define PCI_VENDOR_ID_ROHM             0x10DB
+#define PCI_DEVICE_ID_EG20T_PCH_DMA_8CH        0x8810
+#define PCI_DEVICE_ID_EG20T_PCH_DMA_4CH        0x8815
+#define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
+#define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
+#define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
+
 #define MAX_CHAN_NR			8
 
 static unsigned int init_nr_desc_per_channel = 64;
@@ -853,7 +861,12 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
 
 		pd_chan->membase = &regs->desc[i];
 
-		pd_chan->dir = (i % 2) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+		/* D10:F0 DMA ch6 "video input" is rx direction */
+		if ((id->device == PCI_DEVICE_ID_ML7213_DMA1_8CH) && (i == 6))
+			pd_chan->dir = DMA_FROM_DEVICE;
+		else
+			pd_chan->dir = (i % 2) ? DMA_FROM_DEVICE : \
+								DMA_TO_DEVICE;
 
 		spin_lock_init(&pd_chan->lock);
 
@@ -925,14 +938,6 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
 	}
 }
 
-/* PCI Device ID of DMA device */
-#define PCI_VENDOR_ID_ROHM             0x10DB
-#define PCI_DEVICE_ID_EG20T_PCH_DMA_8CH        0x8810
-#define PCI_DEVICE_ID_EG20T_PCH_DMA_4CH        0x8815
-#define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
-#define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
-#define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
-
 static const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
-- 
1.7.4


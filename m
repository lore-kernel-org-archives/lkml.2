Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2LCXIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:08:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:3622 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2LCXIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:08:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,209,1355126400"; 
   d="scan'208";a="256789392"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] ioat: Add alignment workaround for IVB platforms
To: djbw@fb.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 16:08:37 -0700
Message-ID: <20121203230837.29219.20710.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI IDs for IvyBridge IOAT DMA needs to go into a header file since
dma_v3.c looks them up for certain hardware workarounds. Need to add to the
alignment workaround for IOAT 3.2 since it wasn't fixed in IVB.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 drivers/dma/ioat/dma_v3.c |   22 +++++++++++++++++++++-
 drivers/dma/ioat/hw.h     |   11 +++++++++++
 drivers/dma/ioat/pci.c    |   11 -----------
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index f7f1dc6..c665e0a 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1187,6 +1187,26 @@ static bool is_snb_ioat(struct pci_dev *pdev)
 	}
 }
 
+static bool is_ivb_ioat(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB0:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB1:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB2:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB3:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB4:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB5:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB6:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB7:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB8:
+	case PCI_DEVICE_ID_INTEL_IOAT_IVB9:
+		return true;
+	default:
+		return false;
+	}
+
+}
+
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -1207,7 +1227,7 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 
-	if (is_jf_ioat(pdev) || is_snb_ioat(pdev))
+	if (is_jf_ioat(pdev) || is_snb_ioat(pdev) || is_ivb_ioat(pdev))
 		dma->copy_align = 6;
 
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 60e6754..e2db4c7 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -31,6 +31,17 @@
 #define IOAT_PCI_DID_SCNB       0x65FF
 #define IOAT_PCI_DID_SNB        0x402F
 
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB0	0x0e20
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB1	0x0e21
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB2	0x0e22
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB3	0x0e23
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB4	0x0e24
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB5	0x0e25
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB6	0x0e26
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB7	0x0e27
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB8	0x0e2e
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB9	0x0e2f
+
 #define IOAT_PCI_RID            0x00
 #define IOAT_PCI_SVID           0x8086
 #define IOAT_PCI_SID            0x8086
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index c057306..01be1c9 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -40,17 +40,6 @@ MODULE_VERSION(IOAT_DMA_VERSION);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel Corporation");
 
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB0	0x0e20
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB1	0x0e21
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB2	0x0e22
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB3	0x0e23
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB4	0x0e24
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB5	0x0e25
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB6	0x0e26
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB7	0x0e27
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB8	0x0e2e
-#define PCI_DEVICE_ID_INTEL_IOAT_IVB9	0x0e2f
-
 static struct pci_device_id ioat_pci_tbl[] = {
 	/* I/OAT v1 platforms */
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT) },


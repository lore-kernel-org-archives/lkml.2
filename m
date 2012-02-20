Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2BTC2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:28:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:20869 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab2BTC2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:28:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119206382"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: [PATCH] Quirk for IVB graphics FLR errata
Thread-Topic: [PATCH] Quirk for IVB graphics FLR errata
Thread-Index: AcztVfc7u0UuN5eGRhGshMYuo098fw==
Date: Mon, 20 Feb 2012 02:27:25 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FCD089A@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For IvyBridge Mobile platform, a system hang may occur if a FLR(Function Level Reset) is asserted to internal graphics.

This quirk patch is workaround for the IVB FLR errata issue.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Kay, Allen M <allen.m.kay@intel.com>
---
 drivers/pci/quirks.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6476547..8bf5b88 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -29,6 +29,10 @@
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
+#include <asm/tsc.h>
+/* 10 seconds */
+#define IGD_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
+
 /*
  * This quirk function disables memory decoding and releases memory resources
  * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
@@ -3069,11 +3073,53 @@ static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
 	return 0;
 }
 
+static int reset_ivb_igd(struct pci_dev *dev, int probe)
+{
+	u8 *mmio_base;
+	u32 val;
+
+	if (probe)
+		return 0;
+
+	mmio_base = ioremap_nocache(pci_resource_start(dev, 0),
+				 pci_resource_len(dev, 0));
+	if (!mmio_base)
+		return -ENOMEM;
+
+	/* work around */
+	*((u32 *)(mmio_base + 0x45010)) = 0x00000002;
+	*((u32 *)(mmio_base + 0xc2004)) = 0x00000005;
+	val = *((u32 *)(mmio_base + 0xc7204)) & 0xfffffffe;
+	*((u32 *)(mmio_base + 0xc7204)) = val;
+	do {
+		cycles_t start_time = get_cycles();
+		while (1) {
+			val = *((u32 *)(mmio_base + 0xc7200));
+			if (((val & 0x80000000) == 0)
+				&& ((val & 0x30000000) == 0))
+				break;
+			if (IGD_OPERATION_TIMEOUT < (get_cycles() - start_time))
+				break;
+			cpu_relax();
+		}
+	} while (0);
+	*((u32 *)(mmio_base + 0xd0100)) = 0x00000002;
+
+	iounmap(pci_resource_start(dev, 0));
+	return 0;
+}
+
 #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
+#define PCI_DEVICE_ID_INTEL_IVB_M_VGA      0x0156
+#define PCI_DEVICE_ID_INTEL_IVB_M2_VGA     0x0166
 
 static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
 		 reset_intel_82599_sfp_virtfn },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_M_VGA,
+		reset_ivb_igd },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_M2_VGA,
+		reset_ivb_igd },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 		reset_intel_generic_dev },
 	{ 0 }
-- 
1.6.0.rc1


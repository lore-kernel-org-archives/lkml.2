Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2CURCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:02:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:35980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab2CURCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:02:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="123477722"
From: Seth Heasley <seth.heasley@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 1/1] lpc_sch: Add Intel Centerton Multifunction Device support
Date: Wed, 21 Mar 2012 09:59:51 -0700
Message-Id: <1332349191-8068-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DeviceIDs for the Intel Centerton Legacy Block.  The Legacy Block includes SMBus, GPIO, and Watchdog functionality.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/mfd/lpc_sch.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index abc4213..778af13 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -36,10 +36,13 @@
 
 #define GPIOBASE	0x44
 #define GPIO_IO_SIZE	64
+#define GPIO_IO_SIZE_128	128
 
 #define WDTBASE		0x84
 #define WDT_IO_SIZE	64
 
+#define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
+
 static struct resource smbus_sch_resource = {
 		.flags = IORESOURCE_IO,
 };
@@ -68,7 +71,7 @@ static struct resource wdt_sch_resource = {
 
 static struct mfd_cell tunnelcreek_cells[] = {
 	{
-		.name = "tunnelcreek_wdt",
+		.name = "ie6xx_wdt",
 		.num_resources = 1,
 		.resources = &wdt_sch_resource,
 	},
@@ -77,6 +80,7 @@ static struct mfd_cell tunnelcreek_cells[] = {
 static DEFINE_PCI_DEVICE_TABLE(lpc_sch_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CENTERTON_ILB) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, lpc_sch_ids);
@@ -115,7 +119,12 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 	}
 
 	gpio_sch_resource.start = base_addr;
-	gpio_sch_resource.end = base_addr + GPIO_IO_SIZE - 1;
+
+	/* Intel Centerton has 128 bytes of I/O space */
+	if (id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB)
+		gpio_sch_resource.end = base_addr + GPIO_IO_SIZE_128 - 1;
+	else
+		gpio_sch_resource.end = base_addr + GPIO_IO_SIZE - 1;
 
 	for (i=0; i < ARRAY_SIZE(lpc_sch_cells); i++)
 		lpc_sch_cells[i].id = id->device;
@@ -125,7 +134,8 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 	if (ret)
 		goto out_dev;
 
-	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC) {
+	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC
+	 || id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB) {
 		pci_read_config_dword(dev, WDTBASE, &base_addr_cfg);
 		if (!(base_addr_cfg & (1 << 31))) {
 			dev_err(&dev->dev, "Decode of the WDT I/O range disabled\n");
-- 
1.7.4.4


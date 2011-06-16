Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1FPLF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:05:58 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:48362 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1FPLFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:05:55 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH 1/2] Add tunnelcreek watchdog to lpc_sch devices
Date: Thu, 16 Jun 2011 13:05:49 +0200
Message-Id: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/mfd/lpc_sch.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index ea3f52c..ea1169b 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -37,6 +37,9 @@
 #define GPIOBASE	0x44
 #define GPIO_IO_SIZE	64
 
+#define WDTBASE		0x84
+#define WDT_IO_SIZE	64
+
 static struct resource smbus_sch_resource = {
 		.flags = IORESOURCE_IO,
 };
@@ -59,6 +62,18 @@ static struct mfd_cell lpc_sch_cells[] = {
 	},
 };
 
+static struct resource wdt_sch_resource = {
+		.flags = IORESOURCE_IO,
+};
+
+static struct mfd_cell tunnelcreek_cells[] = {
+	{
+		.name = "tunnelcreek_wdt",
+		.num_resources = 1,
+		.resources = &wdt_sch_resource,
+	},
+};
+
 static struct pci_device_id lpc_sch_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC) },
@@ -72,6 +87,7 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 	unsigned int base_addr_cfg;
 	unsigned short base_addr;
 	int i;
+	int ret;
 
 	pci_read_config_dword(dev, SMBASE, &base_addr_cfg);
 	if (!(base_addr_cfg & (1 << 31))) {
@@ -104,8 +120,39 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 	for (i=0; i < ARRAY_SIZE(lpc_sch_cells); i++)
 		lpc_sch_cells[i].id = id->device;
 
-	return mfd_add_devices(&dev->dev, 0,
+	ret = mfd_add_devices(&dev->dev, 0,
 			lpc_sch_cells, ARRAY_SIZE(lpc_sch_cells), NULL, 0);
+	if (ret)
+		goto out_dev;
+
+	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC) {
+		pci_read_config_dword(dev, WDTBASE, &base_addr_cfg);
+		if (!(base_addr_cfg & (1 << 31))) {
+			dev_err(&dev->dev, "Decode of the WDT I/O range disabled\n");
+			ret = -ENODEV;
+			goto out_dev;
+		}
+		base_addr = (unsigned short)base_addr_cfg;
+		if (base_addr == 0) {
+			dev_err(&dev->dev, "I/O space for WDT uninitialized\n");
+			ret = -ENODEV;
+			goto out_dev;
+		}
+
+		wdt_sch_resource.start = base_addr;
+		wdt_sch_resource.end = base_addr + WDT_IO_SIZE - 1;
+
+		for (i = 0; i < ARRAY_SIZE(tunnelcreek_cells); i++)
+			tunnelcreek_cells[i].id = id->device;
+
+		ret = mfd_add_devices(&dev->dev, 0, tunnelcreek_cells,
+			ARRAY_SIZE(tunnelcreek_cells), NULL, 0);
+	}
+
+	return ret;
+out_dev:
+	mfd_remove_devices(&dev->dev);
+	return ret;
 }
 
 static void __devexit lpc_sch_remove(struct pci_dev *dev)
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1GDN3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:29:17 -0400
Received: from 61-96-236-77.server-home.net ([77.236.96.61]:41216 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab1GDN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:29:14 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH 1/2 v2] Add Intel E6XX watchdog to lpc_sch devices
Date: Mon,  4 Jul 2011 15:29:07 +0200
Message-Id: <1309786148-5138-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110701110002.GA9326@infomag.iguana.be>
References: <20110701110002.GA9326@infomag.iguana.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changes in v2:
* Changed subject to use E6XX instead of tunnelcreek
* Changed watchdog driver to ie6xx_wdt

 drivers/mfd/lpc_sch.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index ea3f52c..6c9a256 100644
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
+		.name = "ie6xx_wdt",
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


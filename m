Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2EGUay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:30:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18665 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2EGUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 18/21] parisc/PCI: register busn_res for root buses
Date: Mon,  7 May 2012 13:30:03 -0700
Message-Id: <1336422606-4244-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host bridge bus number aperture to the resource list.
Like the MMIO and I/O port apertures, this is used when assigning
resources to hot-added devices or in the case of conflicts.

[bhelgaas: set flags directly, at LBA bus_num init, write changelog]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Helge Deller <deller@gmx.de>
CC: linux-parisc@vger.kernel.org
---
 drivers/parisc/dino.c    |   10 ++++++++--
 drivers/parisc/lba_pci.c |    8 ++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 70517b0..ffddc4f 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -898,6 +898,7 @@ static int __init dino_probe(struct parisc_device *dev)
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	unsigned long hpa = dev->hpa.start;
+	int max;
 
 	name = "Dino";
 	if (is_card_dino(&dev->id)) {
@@ -983,6 +984,10 @@ static int __init dino_probe(struct parisc_device *dev)
 	if (dino_dev->hba.gmmio_space.flags)
 		pci_add_resource(&resources, &dino_dev->hba.gmmio_space);
 
+	dino_dev->hba.bus_num.start = dino_current_bus;
+	dino_dev->hba.bus_num.end = 255;
+	dino_dev->hba.bus_num.flags = IORESOURCE_BUS;
+	pci_add_resource(&resources, &dino_dev->hba.bus_num);
 	/*
 	** It's not used to avoid chicken/egg problems
 	** with configuration accessor functions.
@@ -998,12 +1003,13 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
-	bus->busn_res.end = pci_scan_child_bus(bus);
+	max = pci_scan_child_bus(bus);
+	pci_bus_update_busn_res_end(bus, max);
 
 	/* This code *depends* on scanning being single threaded
 	 * if it isn't, this global bus number count will fail
 	 */
-	dino_current_bus = bus->busn_res.end + 1;
+	dino_current_bus = max + 1;
 	pci_bus_assign_resources(bus);
 	pci_bus_add_devices(bus);
 	return 0;
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index cd8f9ce..4f9cf24 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -989,6 +989,7 @@ lba_pat_resources(struct parisc_device *pa_dev, struct lba_device *lba_dev)
 		case PAT_PBNUM:
 			lba_dev->hba.bus_num.start = p->start;
 			lba_dev->hba.bus_num.end   = p->end;
+			lba_dev->hba.bus_num.flags = IORESOURCE_BUS;
 			break;
 
 		case PAT_LMMIO:
@@ -1366,6 +1367,7 @@ lba_driver_probe(struct parisc_device *dev)
 	void *tmp_obj;
 	char *version;
 	void __iomem *addr = ioremap_nocache(dev->hpa.start, 4096);
+	int max;
 
 	/* Read HW Rev First */
 	func_class = READ_REG32(addr + LBA_FCLASS);
@@ -1502,6 +1504,8 @@ lba_driver_probe(struct parisc_device *dev)
 	if (lba_dev->hba.gmmio_space.flags)
 		pci_add_resource(&resources, &lba_dev->hba.gmmio_space);
 
+	pci_add_resource(&resources, &lba_dev->hba.bus_num);
+
 	dev->dev.platform_data = lba_dev;
 	lba_bus = lba_dev->hba.hba_bus =
 		pci_create_root_bus(&dev->dev, lba_dev->hba.bus_num.start,
@@ -1511,7 +1515,7 @@ lba_driver_probe(struct parisc_device *dev)
 		return 0;
 	}
 
-	lba_bus->busn_res.end = pci_scan_child_bus(lba_bus);
+	max = pci_scan_child_bus(lba_bus);
 
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
 	if (is_pdc_pat()) {
@@ -1541,7 +1545,7 @@ lba_driver_probe(struct parisc_device *dev)
 		lba_dev->flags |= LBA_FLAG_SKIP_PROBE;
 	}
 
-	lba_next_bus = lba_res->busn_res.end + 1;
+	lba_next_bus = max + 1;
 	pci_bus_add_devices(lba_bus);
 
 	/* Whew! Finally done! Tell services we got this one covered. */
-- 
1.7.7


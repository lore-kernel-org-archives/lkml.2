Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161356Ab2CSFrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:47:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30668 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030960Ab2CSFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 19/47] PCI: Claim hw/fw allocated resources in hot add path.
Date: Sun, 18 Mar 2012 22:46:08 -0700
Message-Id: <1332135996-13860-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F66C884.0009,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During testing remove/rescan root bus 00, found
[  338.142574] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:01.1
[  338.146788] ata_piix 0000:00:01.1: device not available (can't reserve [io  0x01f0-0x01f7])
[  338.150565] ata_piix: probe of 0000:00:01.1 failed with error -22

because that fixed resource is not claimed from
        arch/x86/pci/i386.c::pcibios_allocate_resources()
that is init path.

Try to claim those resources, so on the remove/rescan will still use old
resources.

It is some kind honoring HW/FW setting in the registers during hot add.
esp root-bus hot add is through acpi, BIOS have chance to set some register
for us.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   20 ++++++++++++++++----
 drivers/pci/bus.c   |    2 ++
 include/linux/pci.h |    1 +
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index cecb842..e1ff375 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -193,13 +193,15 @@ EXPORT_SYMBOL(pcibios_align_resource);
  *	    as well.
  */
 
-static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
+static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 {
 	int idx;
 	struct resource *r;
 
 	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
 		r = &dev->resource[idx];
+		if (r->parent)	/* Already allocated */
+			continue;
 		if (!r->flags)
 			continue;
 		if (!r->start || pci_claim_resource(dev, idx) < 0) {
@@ -215,7 +217,7 @@ static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
 	}
 }
 
-static void __init pcibios_allocate_bus_resources(struct pci_bus *bus)
+static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 {
 	struct pci_bus *child;
 
@@ -231,7 +233,7 @@ struct pci_check_idx_range {
 	int end;
 };
 
-static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
+static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 {
 	int idx, disabled, i;
 	u16 command;
@@ -284,7 +286,7 @@ static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 	}
 }
 
-static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
+static void pcibios_allocate_resources(struct pci_bus *bus, int pass)
 {
 	struct pci_dev *dev;
 	struct pci_bus *child;
@@ -326,6 +328,16 @@ static int __init pcibios_assign_resources(void)
 	return 0;
 }
 
+void pcibios_resource_survey_bus(struct pci_bus *bus)
+{
+	dev_printk(KERN_DEBUG, &bus->dev, "Allocating resources\n");
+
+	pcibios_allocate_bus_resources(bus);
+
+	pcibios_allocate_resources(bus, 0);
+	pcibios_allocate_resources(bus, 1);
+}
+
 void __init pcibios_resource_survey(void)
 {
 	struct pci_bus *bus;
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 1eb7944..672ffc8 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -94,6 +94,8 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 	pci_free_resource_list(&bus->resources);
 }
 
+void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
+
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
  * @bus: PCI bus
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 860091f..b434401 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -643,6 +643,7 @@ extern struct list_head pci_root_buses;	/* list of all known PCI buses */
 /* Some device drivers need know if pci is initiated */
 extern int no_pci_devices(void);
 
+void pcibios_resource_survey_bus(struct pci_bus *bus);
 void pcibios_fixup_bus(struct pci_bus *);
 int __must_check pcibios_enable_device(struct pci_dev *, int mask);
 char *pcibios_setup(char *str);
-- 
1.7.7


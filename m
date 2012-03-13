Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2CMH1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:27:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49216 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2CMH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:27:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/12] PCI: Claim hw/fw allocated resources in hot add path.
Date: Tue, 13 Mar 2012 00:26:25 -0700
Message-Id: <1331623594-30543-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F5EF6E0.0005,ss=1,re=0.000,fgs=0
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
 arch/x86/pci/i386.c     |   10 ++++++++++
 drivers/pci/bus.c       |    2 ++
 drivers/pci/setup-bus.c |    4 ++++
 include/linux/pci.h     |    1 +
 4 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 111bcef..3e1dd0e 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -325,6 +325,16 @@ static int __init pcibios_assign_resources(void)
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
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index d9a5500..33f0fcd 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1444,6 +1444,8 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
+	pcibios_resource_survey_bus(parent);
+
 again:
 	__pci_bus_size_bridges(parent, &add_list, true);
 	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
@@ -1499,6 +1501,8 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
 
+	pcibios_resource_survey_bus(bus);
+
 	down_read(&pci_bus_sem);
 	__pci_bus_size_bridges(bus, &add_list, false);
 	up_read(&pci_bus_sem);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ec8c4cf..161f6c0 100644
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


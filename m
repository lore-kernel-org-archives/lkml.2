Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2L1TNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:13:36 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:40503 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2L1TNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:13:33 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, shangw@linux.vnet.ibm.com, paulus@samba.org,
        bhelgaas@google.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ppc/EEH: fix crash when adding a device in a slot with DDW
Date: Fri, 28 Dec 2012 17:13:19 -0200
Message-Id: <1356721999-25159-2-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20121228120616.GB21831@oc0268524204.ibm.com>
References: <20121228120616.GB21831@oc0268524204.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122819-9254-0000-0000-00000B38F307
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DDW code uses a eeh_dev struct from the pci_dev. However, this is
not set until eeh_add_device_late is called.

Since pci_bus_add_devices is called before eeh_add_device_late, the PCI
devices are added to the bus, making drivers' probe hooks to be called.
These will call set_dma_mask, which will call the DDW code, which will
require the eeh_dev struct from pci_dev. This would result in a crash,
due to a NULL dereference.

Calling eeh_add_device_late after pci_bus_add_devices would make the
system BUG, because device files shouldn't be added to devices there
were not added to the system. So, a new function is needed to add such
files only after pci_bus_add_devices have been called.

Cc: stable@vger.kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/eeh.h       |    3 +++
 arch/powerpc/kernel/of_platform.c    |    3 +++
 arch/powerpc/kernel/pci-common.c     |    7 +++++--
 arch/powerpc/platforms/pseries/eeh.c |   24 +++++++++++++++++++++++-
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.h
index b0ef738..0f816da 100644
--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -201,6 +201,7 @@ int eeh_dev_check_failure(struct eeh_dev *edev);
 void __init eeh_addr_cache_build(void);
 void eeh_add_device_tree_early(struct device_node *);
 void eeh_add_device_tree_late(struct pci_bus *);
+void eeh_add_sysfs_files(struct pci_bus *);
 void eeh_remove_bus_device(struct pci_dev *, int);
 
 /**
@@ -240,6 +241,8 @@ static inline void eeh_add_device_tree_early(struct device_node *dn) { }
 
 static inline void eeh_add_device_tree_late(struct pci_bus *bus) { }
 
+static inline void eeh_add_sysfs_files(struct pci_bus *bus) { }
+
 static inline void eeh_remove_bus_device(struct pci_dev *dev, int purge_pe) { }
 
 static inline void eeh_lock(void) { }
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index c5fc6b2..500dd32 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -91,6 +91,9 @@ static int __devinit of_pci_phb_probe(struct platform_device *dev)
 	/* Add probed PCI devices to the device model */
 	pci_bus_add_devices(phb->bus);
 
+	/* sysfs files should only be added after devices are added */
+	eeh_add_sysfs_files(phb->bus);
+
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 7f94f76..4d3de7e 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1480,11 +1480,14 @@ void pcibios_finish_adding_to_bus(struct pci_bus *bus)
 	pcibios_allocate_bus_resources(bus);
 	pcibios_claim_one_bus(bus);
 
+	/* Fixup EEH */
+	eeh_add_device_tree_late(bus);
+
 	/* Add new devices to global lists.  Register in proc, sysfs. */
 	pci_bus_add_devices(bus);
 
-	/* Fixup EEH */
-	eeh_add_device_tree_late(bus);
+	/* sysfs files should only be added after devices are added */
+	eeh_add_sysfs_files(bus);
 }
 EXPORT_SYMBOL_GPL(pcibios_finish_adding_to_bus);
 
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 9a04322..6b73d6c 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -788,7 +788,6 @@ static void eeh_add_device_late(struct pci_dev *dev)
 	dev->dev.archdata.edev = edev;
 
 	eeh_addr_cache_insert_dev(dev);
-	eeh_sysfs_add_device(dev);
 }
 
 /**
@@ -815,6 +814,29 @@ void eeh_add_device_tree_late(struct pci_bus *bus)
 EXPORT_SYMBOL_GPL(eeh_add_device_tree_late);
 
 /**
+ * eeh_add_sysfs_files - Add EEH sysfs files for the indicated PCI bus
+ * @bus: PCI bus
+ *
+ * This routine must be used to add EEH sysfs files for PCI
+ * devices which are attached to the indicated PCI bus. The PCI bus
+ * is added after system boot through hotplug or dlpar.
+ */
+void eeh_add_sysfs_files(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		eeh_sysfs_add_device(dev);
+		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+			struct pci_bus *subbus = dev->subordinate;
+			if (subbus)
+				eeh_add_sysfs_files(subbus);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(eeh_add_sysfs_files);
+
+/**
  * eeh_remove_device - Undo EEH setup for the indicated pci device
  * @dev: pci device to be removed
  * @purge_pe: remove the PE or not
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2HGQVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:21:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2HGQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:21:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v1 20/22] PCI/IA64: enable PCI bus lock mechanism for IA64 platforms
Date: Wed,  8 Aug 2012 00:11:00 +0800
Message-Id: <1344355862-2726-21-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

This patch turns on PCI bus lock mechanism for IA64 platforms.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/ia64/pci/pci.c               |    2 ++
 arch/ia64/sn/kernel/io_init.c     |    1 +
 arch/ia64/sn/pci/tioca_provider.c |    4 +++-
 drivers/pci/Kconfig               |    2 +-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index d173a88..259a2e1 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -387,6 +387,8 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 	}
 
 	pci_scan_child_bus(pbus);
+	pci_bus_unlock(pbus);
+
 	return pbus;
 
 out3:
diff --git a/arch/ia64/sn/kernel/io_init.c b/arch/ia64/sn/kernel/io_init.c
index 238e2c5..67e8ce9 100644
--- a/arch/ia64/sn/kernel/io_init.c
+++ b/arch/ia64/sn/kernel/io_init.c
@@ -329,6 +329,7 @@ sn_pci_controller_fixup(int segment, int busnum, struct pci_bus *bus)
  		goto error_return; /* error, or bus already scanned */
 
 	bus->sysdata = controller;
+	pci_bus_unlock(bus);
 
 	return;
 
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index a70b11f..79f8226 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -624,7 +624,7 @@ tioca_bus_fixup(struct pcibus_bussoft *prom_bussoft, struct pci_controller *cont
 	    nasid_to_cnodeid(tioca_common->ca_closest_nasid);
 	tioca_common->ca_kernel_private = (u64) tioca_kern;
 
-	bus = pci_find_bus(tioca_common->ca_common.bs_persist_segment,
+	bus = pci_get_bus(tioca_common->ca_common.bs_persist_segment,
 		tioca_common->ca_common.bs_persist_busnum);
 	BUG_ON(!bus);
 	tioca_kern->ca_devices = &bus->devices;
@@ -634,6 +634,7 @@ tioca_bus_fixup(struct pcibus_bussoft *prom_bussoft, struct pci_controller *cont
 	if (tioca_gart_init(tioca_kern) < 0) {
 		kfree(tioca_kern);
 		kfree(tioca_common);
+		pci_bus_put(bus);
 		return NULL;
 	}
 
@@ -654,6 +655,7 @@ tioca_bus_fixup(struct pcibus_bussoft *prom_bussoft, struct pci_controller *cont
 
 	/* Setup locality information */
 	controller->node = tioca_kern->ca_closest_node;
+	pci_bus_put(bus);
 	return tioca_common;
 }
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 1bbe924..5a796c0 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -122,4 +122,4 @@ config PCI_LABEL
 	select NLS
 
 config PCI_BUS_LOCK
-	def_bool y if X86
+	def_bool y if (X86 || IA64)
-- 
1.7.9.5


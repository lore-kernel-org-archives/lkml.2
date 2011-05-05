Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1EEJM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:12:29 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:50318 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:12:28 -0400
X-Greylist: delayed 6467 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 May 2011 05:12:27 EDT
Message-ID: <4DC250A6.9040802@kernel.org>
Date: Thu, 05 May 2011 00:24:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH] pci: Check bridge resources after resource allocation.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DC250B7.0029,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During pci remove/rescan testing found:

[  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
[  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
[  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
[  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
[  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
[  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
[  541.199202] pci 0000:c0:03.0: enabling bus mastering
[  541.199209] pci 0000:c0:03.0: setting latency timer to 64
[  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
[  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22

This bug was uncovered by commit
| commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
| Author: Ram Pai <linuxram@us.ibm.com>
| Date:   Mon Feb 14 17:43:20 2011 -0800
|
|    PCI: pre-allocate additional resources to devices only after successful allo
cation of essential resources.

After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size. So it will not get into failed list, and will not be reset there.

The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
bridge, and later if children does not need to IO resource. those bridge
resources will not need to be allocated. but flags still there.

Add pci_bridge_check_resources() to close the loop.

after patch, will get right result:
[  621.206655] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
[  621.206912] pci 0000:c0:03.0:   bridge window [io  disabled]
[  621.226594] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
[  621.226904] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
[  621.247012] pci 0000:c0:03.0: enabling bus mastering
[  621.247275] pci 0000:c0:03.0: setting latency timer to 64
[  621.267656] pcieport 0000:c0:03.0: setting latency timer to 64
[  621.268134] pcieport 0000:c0:03.0: irq 160 for MSI/MSI-X
[  621.286832] pcieport 0000:c0:03.0: Signaling PME through PCIe PME interrupt
[  621.306360] pci 0000:c4:00.0: Signaling PME through PCIe PME interrupt
[  621.306684] pcie_pme 0000:c0:03.0:pcie01: service driver pcie_pme loaded
[  621.326512] aer 0000:c0:03.0:pcie02: service driver aer loaded
[  621.326911] pciehp 0000:c0:03.0:pcie04: Hotplug Controller:

Signed-off-by: Yinghai Lu <yinghai@kernel.org>


---
 drivers/pci/setup-bus.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -811,6 +811,27 @@ void __ref pci_bus_size_bridges(struct p
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
+static void __ref pci_bridge_check_resources(struct pci_dev *bridge)
+{
+	struct resource *b_res;
+	int i;
+
+	b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
+
+	/*
+	 * We set resource flag in pci_bridge_check_ranges() for further
+	 *  allocation for children devices.
+	 * Then if children do not need some kind of resource (like IO), and
+	 *  bridge resource will not be allocated.
+	 * At last, those flags could be left set, that will confuse
+	 *  pci_setup_bridge() and pci_enable_bridge()
+	 * So use reset_resource to clear them.
+	 */
+	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
+		if (!resource_size(&b_res[i]))
+			reset_resource(&b_res[i]);
+}
+
 static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 					 struct resource_list_x *add_head,
 					 struct resource_list_x *fail_head)
@@ -820,6 +841,9 @@ static void __ref __pci_bus_assign_resou
 
 	pbus_assign_resources_sorted(bus, add_head, fail_head);
 
+	if (bus->self)
+		pci_bridge_check_resources(bus->self);
+
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		b = dev->subordinate;
 		if (!b)
@@ -862,6 +886,8 @@ static void __ref __pci_bridge_assign_re
 	if (!b)
 		return;
 
+	pci_bridge_check_resources((struct pci_dev *)bridge);
+
 	__pci_bus_assign_resources(b, NULL, fail_head);
 
 	switch (bridge->class >> 8) {

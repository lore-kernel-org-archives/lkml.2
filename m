Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2IBVwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:52:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19817 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2IBVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:52:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part3 08/11] PCI: Make pci_rescan_bus_bridge_resize() use pci_scan_bridge
Date: Sun,  2 Sep 2012 14:52:18 -0700
Message-Id: <1346622741-30799-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
References: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after remove all children and then using setpci change bus register and
rescan bridge could use new set bus number.

Otherwise need to rescan parent bus, it would have too much overhead.

also need to use pci_bus_add_single_device to make sure new change bus have
directory /sys/../.../pci_bus.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d1796fe..59345ac 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1879,14 +1879,16 @@ EXPORT_SYMBOL(pci_scan_bus);
  */
 unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
 {
-	unsigned int max;
-	struct pci_bus *bus = bridge->subordinate;
+	unsigned int max = 0;
+	int pass;
+	struct pci_bus *bus = bridge->bus;
 
-	max = pci_scan_child_bus(bus);
+	for (pass = 0; pass < 2; pass++)
+		max = pci_scan_bridge(bus, bridge, max, pass);
 
 	pci_assign_unassigned_bridge_resources(bridge);
 
-	pci_bus_add_devices(bus);
+	pci_bus_add_single_device(bridge);
 
 	return max;
 }
-- 
1.7.7


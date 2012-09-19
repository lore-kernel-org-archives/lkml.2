Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab2ISTCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:02:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19639 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2ISSz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:26 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/40] PCI: pci_bus_size_bridges() should not size own bridge
Date: Wed, 19 Sep 2012 11:54:30 -0700
Message-Id: <1348080894-23412-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During checking acpiphp code, found following sequence:
        pci_bus_size_bridges(bus);
        pci_bus_assign_resources(bus);
	pci_enable_bridges(bus);

The problem is that when bus is not root bus, pci_bus_size_bridges would also size
own pci bridge bus->self if that bridge resource is not inserted before.
but later pci_bus_assign_resources will not allocate those size bridge res.

So try make it less confusing, let it does not include self sizing.
and add with_self parameter info __pci_bus_size_bridge()

Fixes caller in pci hotplug componets.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/acpiphp_glue.c |    3 ++-
 drivers/pci/setup-bus.c            |   24 +++++++++++++++---------
 include/linux/pci.h                |    1 +
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 085eec7..6cb1923 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -842,7 +842,8 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 				max = pci_scan_bridge(bus, dev, max, pass);
 				if (pass && dev->subordinate) {
 					check_hotplug_bridge(slot, dev);
-					pci_bus_size_bridges(dev->subordinate);
+					pci_bus_size_bridges_with_self(
+							dev->subordinate);
 				}
 			}
 		}
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 31821d4..85f7ec73 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1044,8 +1044,8 @@ handle_done:
 	;
 }
 
-void __ref __pci_bus_size_bridges(struct pci_bus *bus,
-			struct list_head *realloc_head)
+static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+			struct list_head *realloc_head, bool with_self)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -1063,13 +1063,13 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 
 		case PCI_CLASS_BRIDGE_PCI:
 		default:
-			__pci_bus_size_bridges(b, realloc_head);
+			__pci_bus_size_bridges(b, realloc_head, true);
 			break;
 		}
 	}
 
-	/* The root bus? */
-	if (!bus->self)
+	/* Is root bus or not wanted? */
+	if (!bus->self || !with_self)
 		return;
 
 	switch (bus->self->class >> 8) {
@@ -1109,9 +1109,15 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 	}
 }
 
+void __ref pci_bus_size_bridges_with_self(struct pci_bus *bus)
+{
+	__pci_bus_size_bridges(bus, NULL, true);
+}
+EXPORT_SYMBOL(pci_bus_size_bridges_with_self);
+
 void __ref pci_bus_size_bridges(struct pci_bus *bus)
 {
-	__pci_bus_size_bridges(bus, NULL);
+	__pci_bus_size_bridges(bus, NULL, false);
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
@@ -1424,7 +1430,7 @@ again:
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_size_bridges(bus, add_list);
+		__pci_bus_size_bridges(bus, add_list, false);
 
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node)
@@ -1501,7 +1507,7 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 				  IORESOURCE_PREFETCH;
 
 again:
-	__pci_bus_size_bridges(parent, &add_list);
+	__pci_bus_size_bridges(parent, &add_list, true);
 	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
 	BUG_ON(!list_empty(&add_list));
 	tried_times++;
@@ -1562,7 +1568,7 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 			if (dev->subordinate)
 				__pci_bus_size_bridges(dev->subordinate,
-							 &add_list);
+						 &add_list, true);
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 02b8e10..7404077 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -978,6 +978,7 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
+void pci_bus_size_bridges_with_self(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
-- 
1.7.7


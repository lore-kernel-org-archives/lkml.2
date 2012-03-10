Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2CJHCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:02:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25582 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2CJHCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:02:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 07/37] PCI: pci_bus_size_bridges() should not size own bridge
Date: Fri,  9 Mar 2012 23:00:07 -0800
Message-Id: <1331362837-10740-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020204.4F5AFC67.0042,ss=1,re=0.000,fgs=0
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
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/setup-bus.c                |   24 +++++++++++++++---------
 include/linux/pci.h                    |    1 +
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 806c44f..10b2122 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -816,7 +816,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 				max = pci_scan_bridge(bus, dev, max, pass);
 				if (pass && dev->subordinate)
-					pci_bus_size_bridges(dev->subordinate);
+					pci_bus_size_bridges_with_self(dev->subordinate);
 			}
 		}
 	}
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index ae853cc..4ef80ad 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -313,7 +313,7 @@ int __ref cpci_configure_slot(struct slot *slot)
 				continue;
 			}
 			child->subordinate = pci_do_scan_bus(child);
-			pci_bus_size_bridges(child);
+			pci_bus_size_bridges_with_self(child);
 		}
 		pci_dev_put(dev);
 	}
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index df7e4bf..d92807b 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -85,7 +85,7 @@ int __ref shpchp_configure_device(struct slot *p_slot)
 				continue;
 			}
 			child->subordinate = pci_do_scan_bus(child);
-			pci_bus_size_bridges(child);
+			pci_bus_size_bridges_with_self(child);
 		}
 		pci_configure_slot(dev);
 		pci_dev_put(dev);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f35a679..ec2026c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -982,8 +982,8 @@ handle_done:
 	;
 }
 
-void __ref __pci_bus_size_bridges(struct pci_bus *bus,
-			struct list_head *realloc_head)
+static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+			struct list_head *realloc_head, bool with_self)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -1001,13 +1001,13 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 
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
@@ -1047,9 +1047,15 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
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
 
@@ -1362,7 +1368,7 @@ again:
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_size_bridges(bus, add_list);
+		__pci_bus_size_bridges(bus, add_list, false);
 
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node)
@@ -1439,7 +1445,7 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 				  IORESOURCE_PREFETCH;
 
 again:
-	__pci_bus_size_bridges(parent, &add_list);
+	__pci_bus_size_bridges(parent, &add_list, true);
 	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
 	BUG_ON(!list_empty(&add_list));
 	tried_times++;
@@ -1500,7 +1506,7 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 			if (dev->subordinate)
 				__pci_bus_size_bridges(dev->subordinate,
-							 &add_list);
+						 &add_list, true);
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 634bbf5..87dceca 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -906,6 +906,7 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
+void pci_bus_size_bridges_with_self(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
-- 
1.7.7


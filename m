Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2IBVtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:49:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32880 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2IBVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:47:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part1 2/4] PCI, acpiphp: Add is_hotplug_bridge detection
Date: Sun,  2 Sep 2012 14:47:36 -0700
Message-Id: <1346622458-30595-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
References: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system support hotplug bridge with children hotplug slots, we need to make sure
that parent bridge get preallocated resource so later when device is plugged into
children slot, those children devices will get resource allocated.

We do not meet this problem, because for pcie hotplug card, when acpiphp is used,
pci_scan_bridge will set that for us when detect hotplug bit in slot cap.

Reported-and-tested-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jason Baron <jbaron@redhat.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 7be4ca5..085eec7 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -783,6 +783,29 @@ static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
 	}
 }
 
+static void check_hotplug_bridge(struct acpiphp_slot *slot, struct pci_dev *dev)
+{
+	struct acpiphp_func *func;
+
+	if (!dev->subordinate)
+		return;
+
+	/* quirk, or pcie could set it already */
+	if (dev->is_hotplug_bridge)
+		return;
+
+	if (PCI_SLOT(dev->devfn) != slot->device)
+		return;
+
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		if (PCI_FUNC(dev->devfn) == func->function) {
+			/* check if this bridge has ejectable slots */
+			if ((detect_ejectable_slots(func->handle) > 0))
+				dev->is_hotplug_bridge = 1;
+			break;
+		}
+	}
+}
 /**
  * enable_device - enable, configure a slot
  * @slot: slot to be enabled
@@ -817,8 +840,10 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 				max = pci_scan_bridge(bus, dev, max, pass);
-				if (pass && dev->subordinate)
+				if (pass && dev->subordinate) {
+					check_hotplug_bridge(slot, dev);
 					pci_bus_size_bridges(dev->subordinate);
+				}
 			}
 		}
 	}
-- 
1.7.7


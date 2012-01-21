Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2AUKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:09:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22222 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2AUKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/21] PCI: Fixing multiple retrying with pci resource optional resources allocation under multi bridges
Date: Sat, 21 Jan 2012 02:08:24 -0800
Message-Id: <1327140517-14811-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EBA.0009,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One system has devices that support sriov and those devices
are connected to pcie switch to pcie root port.

 +-[0000:80]-+-00.0-[81-8f]--
 |           +-01.0-[90-9f]--
 |           +-02.0-[a0-af]----00.0-[a1-a3]--+-02.0-[a2]--+-00.0 Oracle Corporation Device 207a
 |           |                               \-03.0-[a3]--+-00.0 Oracle Corporation Device 207a
 |           +-02.2-[b0-bf]----00.0-[b1-b3]--+-02.0-[b2]--+-00.0 Oracle Corporation Device 207a
 |           |                               \-03.0-[b3]--+-00.0 Oracle Corporation Device 207a

When BIOS does not assign resource for sriov bar, kernel pci reallocation
ony go up to one bridge and then failed to get resource to all sriov bar.
even We have big enough range in peer root bus for allocation.
Specifically, only bridge a1:02.0 level get cleared, and reallocated. kernel does not
go up to clear bridge 80:02.0 level.

To make it go upper levels, during retring, We need to treat good to have
as must have.

Only last try will treat good to have as optional, at that time, parent
bridges resource already released so it will have chance to get assigned
with must_have plus good_to_have for all children devices.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   46 ++++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c09c67a..c79ce4e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -943,7 +943,8 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 		 * Follow thru
 		 */
 	default:
-		pbus_size_io(bus, 0, additional_io_size, realloc_head);
+		pbus_size_io(bus, realloc_head ? 0 : additional_io_size,
+			     additional_io_size, realloc_head);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -951,11 +952,15 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 		   resources. */
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if (pbus_size_mem(bus, prefmask, prefmask, 0, additional_mem_size, realloc_head))
+		if (pbus_size_mem(bus, prefmask, prefmask,
+				  realloc_head ? 0 : additional_mem_size,
+				  additional_mem_size, realloc_head))
 			mask = prefmask; /* Success, size non-prefetch only. */
 		else
 			additional_mem_size += additional_mem_size;
-		pbus_size_mem(bus, mask, IORESOURCE_MEM, 0, additional_mem_size, realloc_head);
+		pbus_size_mem(bus, mask, IORESOURCE_MEM,
+				realloc_head ? 0 : additional_mem_size,
+				additional_mem_size, realloc_head);
 		break;
 	}
 }
@@ -1194,45 +1199,50 @@ pci_assign_unassigned_resources(void)
 	struct pci_bus *bus;
 	struct resource_list_x realloc_list; /* list of resources that
 					want additional resources */
+	struct resource_list_x *add_list = NULL;
 	int tried_times = 0;
 	enum release_type rel_type = leaf_only;
 	struct resource_list_x head, *list;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
-	int max_depth = pci_get_max_depth();
-	int pci_try_num;
-
+	int pci_try_num = 1;
 
 	head.next = NULL;
 	realloc_list.next = NULL;
 
-	pci_try_num = max_depth + 1;
-	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-		 max_depth, pci_try_num);
+	/* don't realloc if asked to do so */
+	if (pci_realloc_enabled()) {
+		int max_depth = pci_get_max_depth();
+
+		pci_try_num = max_depth + 1;
+		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
+			 max_depth, pci_try_num);
+	}
 
 again:
+	/*
+	 * last try will use add_list, otherwise will try good to have as
+	 * must have, so can realloc parent bridge resource
+	 */
+	if (tried_times + 1 == pci_try_num)
+		add_list = &realloc_list;
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_size_bridges(bus, &realloc_list);
+		__pci_bus_size_bridges(bus, add_list);
 
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_assign_resources(bus, &realloc_list, &head);
-	BUG_ON(realloc_list.next);
+		__pci_bus_assign_resources(bus, add_list, &head);
+	if (add_list)
+		BUG_ON(add_list->next);
 	tried_times++;
 
 	/* any device complain? */
 	if (!head.next)
 		goto enable_and_dump;
 
-	/* don't realloc if asked to do so */
-	if (!pci_realloc_enabled()) {
-		free_list(resource_list_x, &head);
-		goto enable_and_dump;
-	}
-
 	failed_type = 0;
 	for (list = head.next; list;) {
 		failed_type |= list->flags;
-- 
1.7.7


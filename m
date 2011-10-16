Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1JPBc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:32:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17203 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1JPBcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:32:24 -0400
Message-ID: <4E9A341D.3000400@oracle.com>
Date: Sat, 15 Oct 2011 18:32:13 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] PCI: Using add_list in pcie hotplug path
References: <4E9A3092.4080309@oracle.com>
In-Reply-To: <4E9A3092.4080309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4E9A3428.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need add size for hot plug path when pluging in hotplug chassis without cards.
-v2: change descriptions. make it can be applied after
	pci: Check bridge resources after resource allocation.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -327,13 +327,14 @@ requested_and_reassign:
 }
 
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
+				 struct resource_list_x *add_head,
 				 struct resource_list_x *fail_head)
 {
 	struct resource_list head;
 
 	head.next = NULL;
 	__dev_sort_resources(dev, &head);
-	__assign_resources_sorted(&head, NULL, fail_head);
+	__assign_resources_sorted(&head, add_head, fail_head);
 
 }
 
@@ -1003,17 +1004,19 @@ void __ref pci_bus_assign_resources(cons
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
+					 struct resource_list_x *add_head,
 					 struct resource_list_x *fail_head)
 {
 	struct pci_bus *b;
 
-	pdev_assign_resources_sorted((struct pci_dev *)bridge, fail_head);
+	pdev_assign_resources_sorted((struct pci_dev *)bridge,
+					 add_head, fail_head);
 
 	b = bridge->subordinate;
 	if (!b)
 		return;
 
-	__pci_bus_assign_resources(b, NULL, fail_head);
+	__pci_bus_assign_resources(b, add_head, fail_head);
 
 	switch (bridge->class >> 8) {
 	case PCI_CLASS_BRIDGE_PCI:
@@ -1288,6 +1291,8 @@ enable_and_dump:
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *parent = bridge->subordinate;
+	struct resource_list_x add_list; /* list of resources that
+					want additional resources */
 	int tried_times = 0;
 	struct resource_list_x head, *list;
 	int retval;
@@ -1295,11 +1300,12 @@ void pci_assign_unassigned_bridge_resour
 				  IORESOURCE_PREFETCH;
 
 	head.next = NULL;
+	add_list.next = NULL;
 
 again:
-	pci_bus_size_bridges(parent);
-	__pci_bridge_assign_resources(bridge, &head);
-
+	__pci_bus_size_bridges(parent, &add_list);
+	__pci_bridge_assign_resources(bridge, &add_list, &head);
+	BUG_ON(add_list.next);
 	tried_times++;
 
 	if (!head.next)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2AUKJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:09:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16518 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2AUKI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:08:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/21] PCI: Using add_list in pcie hotplug path.
Date: Sat, 21 Jan 2012 02:08:21 -0800
Message-Id: <1327140517-14811-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F1A8EB6.00E5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need add size for hot plug path when pluging in hotplug chassis without cards.
-v2: change descriptions. make it can be applied after
	pci: Check bridge resources after resource allocation.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 7757c00..97c1eda 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -330,13 +330,14 @@ requested_and_reassign:
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
 
@@ -1006,17 +1007,19 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
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
@@ -1291,6 +1294,8 @@ enable_and_dump:
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *parent = bridge->subordinate;
+	struct resource_list_x add_list; /* list of resources that
+					want additional resources */
 	int tried_times = 0;
 	struct resource_list_x head, *list;
 	int retval;
@@ -1298,11 +1303,12 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
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
-- 
1.7.7


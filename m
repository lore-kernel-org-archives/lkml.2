Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1FTWrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:47:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59670 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1FTWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:47:41 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, svenkatr@ti.com,
        yinghai@kernel.org, cjb@laptop.org, linux-pci@vger.kernel.org,
        linux-net-drivers@solarflare.com, bhutchings@solarflare.com
Subject: [PATCH 1/4] PCI: honor child buses add_size in hot plug configuration
Date: Mon, 20 Jun 2011 15:47:14 -0700
Message-Id: <1308610037-6261-2-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Recent pci_bus_size change will use add_size for minimum resource size for pcie
hotplug bridge.  But it does not pass children back to parent bridge.

that will have problem on some setup like:
hot add one chassis with more hot plug slots.
for example: if the chassis have 8 slots, we should allocate 8x2M instead
of one 1x2M for parent bus.

So try to get child add_size and compare the sum with parent bus bridge...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 1e9e5a5..e42b89a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -536,6 +536,20 @@ static resource_size_t calculate_memsize(resource_size_t size,
 	return size;
 }
 
+static resource_size_t get_res_add_size(struct resource_list_x *add_head,
+					struct resource *res)
+{
+	struct resource_list_x *list;
+
+	/* check if it is in add_head list */
+	for (list = add_head->next; list && list->res != res;
+			list = list->next);
+	if (list)
+		return list->add_size;
+
+	return 0;
+}
+
 /**
  * pbus_size_io() - size the io window of a given bus
  *
@@ -555,6 +569,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
 	unsigned long size = 0, size0 = 0, size1 = 0;
+	resource_size_t children_add_size = 0;
 
 	if (!b_res)
  		return;
@@ -575,10 +590,15 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 				size += r_size;
 			else
 				size1 += r_size;
+
+			if (add_head)
+				children_add_size += get_res_add_size(add_head, r);
 		}
 	}
 	size0 = calculate_iosize(size, min_size, size1,
 			resource_size(b_res), 4096);
+	if (children_add_size > add_size)
+		add_size = children_add_size;
 	size1 = (!add_head || (add_head && !add_size)) ? size0 :
 		calculate_iosize(size, min_size+add_size, size1,
 			resource_size(b_res), 4096);
@@ -620,6 +640,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 	unsigned int mem64_mask = 0;
+	resource_size_t children_add_size = 0;
 
 	if (!b_res)
 		return 0;
@@ -661,6 +682,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			if (order > max_order)
 				max_order = order;
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
+
+			if (add_head)
+				children_add_size += get_res_add_size(add_head, r);
 		}
 	}
 	align = 0;
@@ -677,6 +701,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 		align += aligns[order];
 	}
 	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
+	if (children_add_size > add_size)
+		add_size = children_add_size;
 	size1 = (!add_head || (add_head && !add_size)) ? size0 :
 		calculate_memsize(size, min_size+add_size, 0,
 				resource_size(b_res), min_align);
-- 
1.7.0.4


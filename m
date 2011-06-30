Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1F3XsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:48:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52388 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1F3XsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:48:09 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, socketcan@hartkopp.net,
        bhelgaas@google.com, linux@dominikbrodowski.net,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 1/5 v2] PCI: honor child buses optional size in hot plug configuration
Date: Thu, 30 Jun 2011 16:47:38 -0700
Message-Id: <1309477662-18680-2-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

git commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
    "PCI: pre-allocate additional resources to devices only after
	successful allocation of essential resources."

fails to take into consideration the optional-resources needed by children
devices while calculating the optional-resource needed by the bridge.

This can be a problem on some setup. For example, if a hotplug bridge has 8
children hotplug bridges, the bridge should have enough resources to accomodate
the hotplug requirements for each of its children hotplug bridges.  Currently
this is not the case.

This patch fixes the problem.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab1EFUpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:45:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50382 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab1EFUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:45:06 -0400
Message-ID: <4DC45DBA.6030805@kernel.org>
Date: Fri, 06 May 2011 13:44:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 2/2] pci: honor child buses add_size in hot plug configuration
References: <4DC250A6.9040802@kernel.org> <20110506081243.GF16782@ram-laptop> <4DC4586C.6020308@kernel.org>
In-Reply-To: <4DC4586C.6020308@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DC45DC2.000A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recent pci_bus_size change will use add_size for minimum resource size for pcie
hotplug bridge.  But it does not pass children back to parent bridge.

that will have problem on some setup like:
hot add one chassis with more hot plug slots.
for example: if the chassis have 8 slots, we should allocate 8x2M instead
of one 1x2M for parent bus.

So try to get child add_size and compare the sum with parent bus bridge...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -537,6 +537,20 @@ static resource_size_t calculate_memsize
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
@@ -556,6 +570,7 @@ static void pbus_size_io(struct pci_bus
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
 	unsigned long size = 0, size0 = 0, size1 = 0;
+	resource_size_t children_add_size = 0;
 
 	if (!b_res)
  		return;
@@ -576,10 +591,15 @@ static void pbus_size_io(struct pci_bus
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
 	size1 = !add_size? size0:
 		calculate_iosize(size, min_size+add_size, size1,
 			resource_size(b_res), 4096);
@@ -621,6 +641,7 @@ static int pbus_size_mem(struct pci_bus
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 	unsigned int mem64_mask = 0;
+	resource_size_t children_add_size = 0;
 
 	if (!b_res)
 		return 0;
@@ -662,6 +683,9 @@ static int pbus_size_mem(struct pci_bus
 			if (order > max_order)
 				max_order = order;
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
+
+			if (add_head)
+				children_add_size += get_res_add_size(add_head, r);
 		}
 	}
 	align = 0;
@@ -678,6 +702,8 @@ static int pbus_size_mem(struct pci_bus
 		align += aligns[order];
 	}
 	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
+	if (children_add_size > add_size)
+		add_size = children_add_size;
 	size1 = !add_size ? size :
 		calculate_memsize(size, min_size+add_size, 0,
 				resource_size(b_res), min_align);

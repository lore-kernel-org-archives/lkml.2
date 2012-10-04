Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946547Ab2JDV3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:29:20 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39431 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946507Ab2JDV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:28:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Ram Pai <linuxram@us.ibm.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Worsley <amworsley@gmail.com>
Subject: [ 31/33] PCI: honor child buses add_size in hot plug configuration
Date: Thu,  4 Oct 2012 14:26:53 -0700
Message-Id: <20121004210602.349918561@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210558.383865383@linuxfoundation.org>
References: <20121004210558.383865383@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit be768912a49b10b68e96fbd8fa3cab0adfbd3091 upstream.

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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -543,6 +543,20 @@ static resource_size_t calculate_memsize
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
@@ -562,6 +576,7 @@ static void pbus_size_io(struct pci_bus
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
 	unsigned long size = 0, size0 = 0, size1 = 0;
+	resource_size_t children_add_size = 0;
 
 	if (!b_res)
  		return;
@@ -582,10 +597,15 @@ static void pbus_size_io(struct pci_bus
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
@@ -627,6 +647,7 @@ static int pbus_size_mem(struct pci_bus
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 	unsigned int mem64_mask = 0;
+	resource_size_t children_add_size = 0;
 
 	if (!b_res)
 		return 0;
@@ -668,6 +689,9 @@ static int pbus_size_mem(struct pci_bus
 			if (order > max_order)
 				max_order = order;
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
+
+			if (add_head)
+				children_add_size += get_res_add_size(add_head, r);
 		}
 	}
 	align = 0;
@@ -684,6 +708,8 @@ static int pbus_size_mem(struct pci_bus
 		align += aligns[order];
 	}
 	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
+	if (children_add_size > add_size)
+		add_size = children_add_size;
 	size1 = (!add_head || (add_head && !add_size)) ? size0 :
 		calculate_memsize(size, min_size+add_size, 0,
 				resource_size(b_res), min_align);



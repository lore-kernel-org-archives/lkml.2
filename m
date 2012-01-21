Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2AUKKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:23 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22282 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2AUKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:15 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/21] PCI: add debug print out for add_size
Date: Sat, 21 Jan 2012 02:08:31 -0800
Message-Id: <1327140517-14811-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F1A8EC4.000C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for some corner cases later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c845d18..ae0b1f2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -118,10 +118,13 @@ static resource_size_t get_res_add_size(struct list_head *head,
 
 	list_for_each_entry(dev_res, head, list) {
 		if (dev_res->res == res) {
+			int idx = res - &dev_res->dev->resource[0];
+
 			dev_printk(KERN_DEBUG, &dev_res->dev->dev,
-				 "%pR get_res_add_size  add_size %llx\n",
-				 dev_res->res,
+				 "res[%d]=%pR get_res_add_size add_size %llx\n",
+				 idx, dev_res->res,
 				 (unsigned long long)dev_res->add_size);
+
 			return dev_res->add_size;
 		}
 	}
@@ -260,8 +263,9 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 			if (pci_reassign_resource(add_res->dev, idx,
 						  add_size, align))
 				dev_printk(KERN_DEBUG, &add_res->dev->dev,
-				   "failed to add optional resources res=%pR\n",
-							res);
+					   "failed to add %llx res[%d]=%pR\n",
+					   (unsigned long long)add_size,
+					   idx, res);
 		}
 out:
 		list_del(&add_res->list);
@@ -760,8 +764,12 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	b_res->start = 4096;
 	b_res->end = b_res->start + size0 - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
-	if (size1 > size0 && realloc_head)
+	if (size1 > size0 && realloc_head) {
 		add_to_list(realloc_head, bus->self, b_res, size1-size0, 4096);
+		dev_printk(KERN_DEBUG, &bus->self->dev, "bridge window "
+				 "%pR to [bus %02x-%02x] add_size %lx\n", b_res,
+				 bus->secondary, bus->subordinate, size1-size0);
+	}
 }
 
 /**
@@ -873,8 +881,12 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	b_res->start = min_align;
 	b_res->end = size0 + min_align - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
-	if (size1 > size0 && realloc_head)
+	if (size1 > size0 && realloc_head) {
 		add_to_list(realloc_head, bus->self, b_res, size1-size0, min_align);
+		dev_printk(KERN_DEBUG, &bus->self->dev, "bridge window "
+				 "%pR to [bus %02x-%02x] add_size %llx\n", b_res,
+				 bus->secondary, bus->subordinate, (unsigned long long)size1-size0);
+	}
 	return 1;
 }
 
-- 
1.7.7


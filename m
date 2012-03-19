Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161831Ab2CSFxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:53:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25485 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161996Ab2CSFtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:47 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 12/26] PCI: Use for_each_res with pci bar reassign funcs
Date: Sun, 18 Mar 2012 22:48:35 -0700
Message-Id: <1332136129-14010-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F66C8F8.00D1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index d9a5500..13548a7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -106,7 +106,7 @@ static resource_size_t get_res_add_size(struct list_head *head,
 
 	list_for_each_entry(dev_res, head, list) {
 		if (dev_res->res == res) {
-			int idx = res - &dev_res->dev->resource[0];
+			int idx = pci_dev_resource_idx(dev_res->dev, res);
 
 			dev_printk(KERN_DEBUG, &dev_res->dev->dev,
 				 "res[%d]=%pR get_res_add_size add_size %llx\n",
@@ -124,15 +124,13 @@ static resource_size_t get_res_add_size(struct list_head *head,
 static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 {
 	int i;
+	struct resource *r;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *r;
+	for_each_pci_dev_all_resource(dev, r, i) {
 		struct pci_dev_resource *dev_res, *tmp;
 		resource_size_t r_align;
 		struct list_head *n;
 
-		r = &dev->resource[i];
-
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
@@ -237,7 +235,7 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		if (!found_match)/* just skip */
 			continue;
 
-		idx = res - &add_res->dev->resource[0];
+		idx = pci_dev_resource_idx(add_res->dev, res);
 		add_size = add_res->add_size;
 		if (!resource_size(res)) {
 			res->start = add_res->start;
@@ -280,7 +278,7 @@ static void assign_requested_resources_sorted(struct list_head *head,
 
 	list_for_each_entry(dev_res, head, list) {
 		res = dev_res->res;
-		idx = res - &dev_res->dev->resource[0];
+		idx = pci_dev_resource_idx(dev_res->dev, res);
 		if (resource_size(res) &&
 		    pci_assign_resource(dev_res->dev, idx)) {
 			if (fail_head && !pci_is_root_bus(dev_res->dev->bus)) {
@@ -716,9 +714,9 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
+		struct resource *r;
 
-		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-			struct resource *r = &dev->resource[i];
+		for_each_pci_dev_all_resource(dev, r, i) {
 			unsigned long r_size;
 
 			if (r->parent || !(r->flags & IORESOURCE_IO))
@@ -798,9 +796,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
+		struct resource *r;
 
-		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-			struct resource *r = &dev->resource[i];
+		for_each_pci_dev_all_resource(dev, r, i) {
 			resource_size_t r_size;
 
 			if (r->parent || (r->flags & mask) != type)
@@ -1140,9 +1138,7 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
 				  IORESOURCE_PREFETCH;
 
 	dev = bus->self;
-	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
-	     idx++) {
-		r = &dev->resource[idx];
+	for_each_pci_dev_bridge_resource(dev, r, idx) {
 		if ((r->flags & type_mask) != type)
 			continue;
 		if (!r->parent)
@@ -1313,9 +1309,9 @@ static void __init pci_realloc_detect(void)
 
 	for_each_pci_dev(dev) {
 		int i;
+		struct resource *r;
 
-		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
-			struct resource *r = &dev->resource[i];
+		for_each_pci_dev_iov_resource(dev, r, i) {
 
 			/* Not assigned, or rejected by kernel ? */
 			if (r->flags && !r->start) {
-- 
1.7.7


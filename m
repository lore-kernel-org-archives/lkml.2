Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2EWGfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:35:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32564 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176Ab2EWGfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:35:02 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/11] PCI: Treat ROM resource as optional during assigning.
Date: Tue, 22 May 2012 23:34:37 -0700
Message-Id: <1337754877-19759-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So will try to allocate them together with requested ones, if can not assign
them, could go with requested one only, and just skip ROM resource.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   21 +++++++--------------
 include/linux/pci.h     |    5 +++++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index ed32864..41c08d6 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -305,18 +305,10 @@ static void assign_requested_resources_sorted(struct list_head *head,
 		idx = res - &dev_res->dev->resource[0];
 		if (resource_size(res) &&
 		    pci_assign_resource_fit(dev_res->dev, idx, fit)) {
-			if (fail_head) {
-				/*
-				 * if the failed res is for ROM BAR, and it will
-				 * be enabled later, don't add it to the list
-				 */
-				if (!((idx == PCI_ROM_RESOURCE) &&
-				      (!(res->flags & IORESOURCE_ROM_ENABLE))))
-					add_to_list(fail_head,
-						    dev_res->dev, res,
-						    0 /* dont care */,
-						    0 /* dont care */);
-			}
+			if (fail_head)
+				add_to_list(fail_head, dev_res->dev, res,
+					    0 /* dont care */,
+					    0 /* dont care */);
 			reset_resource(res);
 		}
 	}
@@ -833,8 +825,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 				continue;
 			r_size = resource_size(r);
 
-			/* put SRIOV requested res to the optional list */
-			if (realloc_head && is_pci_iov_resource_idx(i)) {
+			/* put SRIOV/ROM requested res to the optional list */
+			if (realloc_head && (is_pci_iov_resource_idx(i) ||
+					     is_pci_rom_resource_idx(i))) {
 				r->end = r->start - 1;
 				add_to_list(realloc_head, dev, r, r_size, 0/* dont' care */);
 				children_add_size += r_size;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0d254d9..08c081c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -122,6 +122,11 @@ static inline bool is_pci_iov_resource_idx(int i)
 	return false;
 }
 
+static inline bool is_pci_rom_resource_idx(int i)
+{
+	return i == PCI_ROM_RESOURCE;
+}
+
 typedef int __bitwise pci_power_t;
 
 #define PCI_D0		((pci_power_t __force) 0)
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab1CaMJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab1CaMJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:09:08 -0400
Date: Thu, 31 Mar 2011 14:08:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] dma-debug: print information about leaked entry
Message-ID: <20110331120759.GA5230@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When driver leak dma mapping, print additional information about one of
leaked entries, to to help investigate problem. Patch should be useful
for debugging drivers, which maps many different class of buffers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 lib/dma-debug.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 4bfb047..db07bfd 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -649,7 +649,7 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
+static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
 	struct dma_debug_entry *entry;
 	unsigned long flags;
@@ -660,8 +660,10 @@ static int device_dma_allocations(struct device *dev)
 	for (i = 0; i < HASH_SIZE; ++i) {
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
-			if (entry->dev == dev)
+			if (entry->dev == dev) {
 				count += 1;
+				*out_entry = entry;
+			}
 		}
 		spin_unlock(&dma_entry_hash[i].lock);
 	}
@@ -674,6 +676,7 @@ static int device_dma_allocations(struct device *dev)
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
+	struct dma_debug_entry *uninitialized_var(entry);
 	int count;
 
 	if (global_disable)
@@ -681,12 +684,17 @@ static int dma_debug_device_change(struct notifier_block *nb, unsigned long acti
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
-		count = device_dma_allocations(dev);
+		count = device_dma_allocations(dev, &entry);
 		if (count == 0)
 			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
+		err_printk(dev, entry, "DMA-API: device driver has pending "
 				"DMA allocations while released from device "
-				"[count=%d]\n", count);
+				"[count=%d]\n"
+				"One of leaked entries details: "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [mapped as %s]\n",
+			count, entry->dev_addr, entry->size,
+			dir2name[entry->direction], type2name[entry->type]);
 		break;
 	default:
 		break;
-- 
1.7.1


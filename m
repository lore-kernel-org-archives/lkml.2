Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1EJSma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:42:30 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1EJSm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:42:29 -0400
Subject: [PATCH] dma-debug: print some unfreed allocations
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 20:42:24 +0200
Message-ID: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When a driver unbinds and still has allocations,
we print them out but there's no indication where
they came from. If stacktrace support is built
into the kernel, we can print out their traces.

Unfortunately, if you're unloading the module the
traces will be useless, but once you find such an
error you can manually unbind the device instead
to see where the allocations came from.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/dma-debug.c |   47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

--- a/lib/dma-debug.c	2011-05-10 20:25:11.000000000 +0200
+++ b/lib/dma-debug.c	2011-05-10 20:36:55.000000000 +0200
@@ -649,7 +649,9 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
+#define DMA_DEBUG_NUM_PRINT_UNFREED		10
+
+static void check_device_dma_allocations(struct device *dev)
 {
 	struct dma_debug_entry *entry;
 	unsigned long flags;
@@ -666,27 +668,52 @@ static int device_dma_allocations(struct
 		spin_unlock(&dma_entry_hash[i].lock);
 	}
 
-	local_irq_restore(flags);
+	if (count > 1) {
+		err_printk(dev, NULL, "DMA-API: device driver has pending "
+			   "DMA allocations while released from device "
+			   "[count=%d]\n", count);
+#ifdef CONFIG_STACKTRACE
+		count = 0;
+		/*
+		 * If we have, print out some stack traces for the allocations.
+		 * In case of module unload, the stack traces will be useless,
+		 * but instead of unloading the module you can manually unbind
+		 * the driver instead and get useful traces.
+		 */
+		printk(KERN_WARNING "Showing traces for %d allocations:\n",
+		       DMA_DEBUG_NUM_PRINT_UNFREED);
+
+		for (i = 0; i < HASH_SIZE; ++i) {
+			spin_lock(&dma_entry_hash[i].lock);
+			list_for_each_entry(entry, &dma_entry_hash[i].list,
+					    list) {
+				if (entry->dev == dev)
+					count += 1;
+				if (count > DMA_DEBUG_NUM_PRINT_UNFREED)
+					break;
+				dump_entry_trace(entry);
+			}
+			spin_unlock(&dma_entry_hash[i].lock);
+
+			if (count > DMA_DEBUG_NUM_PRINT_UNFREED)
+				break;
+		}
+#endif
+	}
 
-	return count;
+	local_irq_restore(flags);
 }
 
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
-	int count;
 
 	if (global_disable)
 		return 0;
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
-		count = device_dma_allocations(dev);
-		if (count == 0)
-			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
-				"DMA allocations while released from device "
-				"[count=%d]\n", count);
+		check_device_dma_allocations(dev);
 		break;
 	default:
 		break;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935181Ab1ETQeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:34:20 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:49736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab1ETQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:34:19 -0400
Subject: [PATCH v3] dma-debug: print some unfreed allocations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20110519081931.GM31309@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
	 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
	 <20110516110029.GC31309@amd.com>
	 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
	 <20110519081931.GM31309@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 09:36:58 -0700
Message-ID: <1305909418.4640.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When a driver unbinds and still has allocations,
we print out that they exist but there's nothing
to indicate where they came from. If stacktrace
support is built into the kernel, we can print
out their traces. The number of traces that will
be printed is configurable in debugfs, with the
default being zero.

Unfortunately, if you're unloading the module the
traces will be useless, but once you find such an
error you can manually unbind the device instead
to see where the allocations came from.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DMA-API.txt |   10 +++++++
 lib/dma-debug.c           |   62 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 62 insertions(+), 10 deletions(-)

--- a/lib/dma-debug.c	2011-05-20 08:59:55.000000000 -0700
+++ b/lib/dma-debug.c	2011-05-20 09:36:29.000000000 -0700
@@ -102,6 +102,12 @@ static struct dentry *num_free_entries_d
 static struct dentry *min_free_entries_dent __read_mostly;
 static struct dentry *filter_dent           __read_mostly;
 
+#ifdef CONFIG_STACKTRACE
+/* Show stack traces for this many pending allocations */
+static u32 num_show_pending __read_mostly;
+static struct dentry *num_show_pending_dent __read_mostly;
+#endif
+
 /* per-driver filter related state */
 
 #define NAME_MAX_LEN	64
@@ -641,6 +647,14 @@ static int dma_debug_fs_init(void)
 	if (!filter_dent)
 		goto out_err;
 
+#ifdef CONFIG_STACKTRACE
+	num_show_pending_dent = debugfs_create_u32("num_show_pending", 0644,
+						   dma_debug_dent,
+						   &num_show_pending);
+	if (!num_show_pending_dent)
+		goto out_err;
+#endif
+
 	return 0;
 
 out_err:
@@ -649,7 +663,7 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
+static void check_device_dma_allocations(struct device *dev)
 {
 	struct dma_debug_entry *entry;
 	unsigned long flags;
@@ -666,27 +680,55 @@ static int device_dma_allocations(struct
 		spin_unlock(&dma_entry_hash[i].lock);
 	}
 
-	local_irq_restore(flags);
+	if (count > 1)
+		err_printk(dev, NULL, "DMA-API: device driver has pending "
+			   "DMA allocations while released from device "
+			   "[count=%d]\n", count);
 
-	return count;
+#ifdef CONFIG_STACKTRACE
+	if (count > 1 && num_show_pending > 0) {
+		count = 0;
+		/*
+		 * If we have, print out some stack traces for the allocations.
+		 * In case of module unload, the stack traces will be useless,
+		 * but instead of unloading the module you can manually unbind
+		 * the driver instead and get useful traces.
+		 */
+		printk(KERN_WARNING "Showing traces for %d allocations:\n",
+		       num_show_pending);
+
+		for (i = 0; i < HASH_SIZE; ++i) {
+			spin_lock(&dma_entry_hash[i].lock);
+			list_for_each_entry(entry, &dma_entry_hash[i].list,
+					    list) {
+				if (entry->dev != dev)
+					continue;
+				count += 1;
+				if (count > num_show_pending)
+					break;
+				dump_entry_trace(entry);
+			}
+			spin_unlock(&dma_entry_hash[i].lock);
+
+			if (count > num_show_pending)
+				break;
+		}
+	}
+#endif
+
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
--- a/Documentation/DMA-API.txt	2011-05-20 09:33:24.000000000 -0700
+++ b/Documentation/DMA-API.txt	2011-05-20 09:35:34.000000000 -0700
@@ -655,6 +655,16 @@ this directory the following files can c
 				that file to disable the filter and see
 				all errors again.
 
+	dma-api/num_show_pending
+				This file is only present if CONFIG_STACKTRACE
+				is enabled in the kernel, and allows debugging
+				unfreed allocations in that it prints out the
+				stack traces for this many (default 0) unfreed
+				allocations if there are any. Note that these
+				traces may be useless if you're unregistering
+				by unloading the module; work around that by
+				unbinding the driver in sysfs instead.
+
 If you have this code compiled into your kernel it will be enabled by default.
 If you want to boot without the bookkeeping anyway you can provide
 'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.



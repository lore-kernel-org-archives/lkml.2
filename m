Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0JGFR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 01:17:28 -0400
Received: from home.keithp.com ([63.227.221.253]:50628 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0JGFR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 01:17:27 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 01:17:27 EDT
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/2] lib/dma_debug: print out the actual pending DMA allocations on release
Date: Wed,  6 Oct 2010 22:07:53 -0700
Message-Id: <1286428073-29799-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device leaves DMA allocations pending, instead of just printing
the count of allocations, go back and print out information about each
one so that the user can find the call site causing the bug.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 lib/dma-debug.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 01e6427..46cdc55 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -670,6 +670,27 @@ static int device_dma_allocations(struct device *dev)
 	return count;
 }
 
+static void device_dma_print_allocations(struct device *dev)
+{
+	struct dma_debug_entry *entry;
+	unsigned long flags;
+	int i;
+
+	local_irq_save(flags);
+
+	for (i = 0; i < HASH_SIZE; ++i) {
+		spin_lock(&dma_entry_hash[i].lock);
+		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
+			if (entry->dev == dev)
+				err_printk(dev, entry, "DMA-API: device driver has pending "
+					   "DMA allocations while released from device");
+		}
+		spin_unlock(&dma_entry_hash[i].lock);
+	}
+
+	local_irq_restore(flags);
+}
+
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
@@ -683,9 +704,7 @@ static int dma_debug_device_change(struct notifier_block *nb, unsigned long acti
 		count = device_dma_allocations(dev);
 		if (count == 0)
 			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
-				"DMA allocations while released from device "
-				"[count=%d]\n", count);
+		device_dma_print_allocations(dev);
 		break;
 	default:
 		break;
-- 
1.7.1


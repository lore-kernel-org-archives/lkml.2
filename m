Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2BJNjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:39:39 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42063 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2BJNjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:39:37 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/6] sep: NULL out pointers,
 mark debug code DEBUG to fix warnings
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:53:21 +0000
Message-ID: <20120210135319.12442.82066.stgit@bob.linux.org.uk>
In-Reply-To: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Allyn <mark.a.allyn@intel.com>

[This is picked out of the differences between the upstream driver and
 the staging driver. I'm resolving the differences as a series of updates -AC]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_main.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index db51895..cf420f6 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -40,6 +40,7 @@
 /* #define SEP_PERF_DEBUG */
 
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
@@ -197,9 +198,9 @@ static int sep_allocate_dmatables_region(struct sep_device *sep,
 					 struct sep_dma_context *dma_ctx,
 					 const u32 table_count)
 {
-	const size_t new_len =  table_count *
-				sizeof(struct sep_lli_entry) *
-				SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+	const size_t new_len =
+		SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES - 1;
+
 	void *tmp_region = NULL;
 
 	dev_dbg(&sep->pdev->dev, "[PID%d] dma_ctx = 0x%p\n",
@@ -230,6 +231,7 @@ static int sep_allocate_dmatables_region(struct sep_device *sep,
 	if (*dmatables_region) {
 		memcpy(tmp_region, *dmatables_region, dma_ctx->dmatables_len);
 		kfree(*dmatables_region);
+		*dmatables_region = NULL;
 	}
 
 	*dmatables_region = tmp_region;
@@ -342,11 +344,12 @@ static void _sep_dump_message(struct sep_device *sep)
 
 	u32 *p = sep->shared_addr;
 
-	for (count = 0; count < 40 * 4; count += 4)
+	for (count = 0; count < 10 * 4; count += 4)
 		dev_dbg(&sep->pdev->dev,
 			"[PID%d] Word %d of the message is %x\n",
 				current->pid, count/4, *p++);
 }
+
 #endif
 
 /**
@@ -384,6 +387,8 @@ static void sep_unmap_and_free_shared_area(struct sep_device *sep)
 				sep->shared_addr, sep->shared_bus);
 }
 
+#ifdef DEBUG
+
 /**
  * sep_shared_bus_to_virt - convert bus/virt addresses
  * @sep: pointer to struct sep_device
@@ -398,6 +403,8 @@ static void *sep_shared_bus_to_virt(struct sep_device *sep,
 	return sep->shared_addr + (bus_address - sep->shared_bus);
 }
 
+#endif
+
 /**
  * sep_open - device open method
  * @inode: inode of SEP device


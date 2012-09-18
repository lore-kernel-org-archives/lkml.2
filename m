Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2IRNib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:38:31 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47216 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab2IRNi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:38:26 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 1/2] rapidio: add inbound memory mapping interface
Date: Tue, 18 Sep 2012 09:37:20 -0400
Message-Id: <1347975441-6723-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1347975441-6723-1-git-send-email-alexandre.bounine@idt.com>
References: <1347975441-6723-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common inbound memory mapping/unmapping interface. This allows to make
local memory space accessible from the RapidIO side using hardware mapping
capabilities of RapidIO bridging devices. The new interface is intended to
enable data transfers between RapidIO devices in combination with DMA engine
support. 

This patch is based on patch submitted by Li Yang <leoli@freescale.com>
(https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-April/071210.html)

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/rapidio/rio.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rio.h     |    5 +++++
 include/linux/rio_drv.h |    5 +++++
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index c40665a..d7b68cc 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -33,6 +33,7 @@
 
 static LIST_HEAD(rio_mports);
 static unsigned char next_portid;
+static DEFINE_SPINLOCK(rio_mmap_lock);
 
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
@@ -398,6 +399,49 @@ int rio_release_inb_pwrite(struct rio_dev *rdev)
 EXPORT_SYMBOL_GPL(rio_release_inb_pwrite);
 
 /**
+ * rio_map_inb_region -- Map inbound memory region.
+ * @mport: Master port.
+ * @lstart: physical address of memory region to be mapped
+ * @rbase: RIO base address assigned to this window
+ * @size: Size of the memory region
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from RIO space to local memory.
+ */
+int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
+			u64 rbase, u32 size, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->ops->map_inb)
+		return -1;
+	spin_lock_irqsave(&rio_mmap_lock, flags);
+	rc = mport->ops->map_inb(mport, local, rbase, size, rflags);
+	spin_unlock_irqrestore(&rio_mmap_lock, flags);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_map_inb_region);
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @lstart: physical address of memory region to be unmapped
+ */
+void rio_unmap_inb_region(struct rio_mport *mport, dma_addr_t lstart)
+{
+	unsigned long flags;
+	if (!mport->ops->unmap_inb)
+		return;
+	spin_lock_irqsave(&rio_mmap_lock, flags);
+	mport->ops->unmap_inb(mport, lstart);
+	spin_unlock_irqrestore(&rio_mmap_lock, flags);
+}
+EXPORT_SYMBOL_GPL(rio_unmap_inb_region);
+
+/**
  * rio_mport_get_physefb - Helper function that returns register offset
  *                      for Physical Layer Extended Features Block.
  * @port: Master port to issue transaction
diff --git a/include/linux/rio.h b/include/linux/rio.h
index ba382f2..4d1a104 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -301,6 +301,8 @@ struct rio_net {
  * @add_outb_message: Callback to add a message to an outbound mailbox queue.
  * @add_inb_buffer: Callback to	add a buffer to an inbound mailbox queue.
  * @get_inb_message: Callback to get a message from an inbound mailbox queue.
+ * @map_inb: Callback to map RapidIO address region into local memory space.
+ * @unmap_inb: Callback to unmap RapidIO address region mapped with map_inb().
  */
 struct rio_ops {
 	int (*lcread) (struct rio_mport *mport, int index, u32 offset, int len,
@@ -323,6 +325,9 @@ struct rio_ops {
 				 int mbox, void *buffer, size_t len);
 	int (*add_inb_buffer)(struct rio_mport *mport, int mbox, void *buf);
 	void *(*get_inb_message)(struct rio_mport *mport, int mbox);
+	int (*map_inb)(struct rio_mport *mport, dma_addr_t lstart,
+			u64 rstart, u32 size, u32 flags);
+	void (*unmap_inb)(struct rio_mport *mport, dma_addr_t lstart);
 };
 
 #define RIO_RESOURCE_MEM	0x00000100
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index 31ad146..b75c059 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -365,6 +365,11 @@ void rio_release_regions(struct rio_dev *);
 int rio_request_region(struct rio_dev *, int, char *);
 void rio_release_region(struct rio_dev *, int);
 
+/* Memory mapping functions */
+extern int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
+			u64 rbase, u32 size, u32 rflags);
+extern void rio_unmap_inb_region(struct rio_mport *mport, dma_addr_t lstart);
+
 /* Port-Write management */
 extern int rio_request_inb_pwrite(struct rio_dev *,
 			int (*)(struct rio_dev *, union rio_pw_msg*, int));
-- 
1.7.8.4


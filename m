Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1HaVam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:30:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab1HaVad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:30:33 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 1/3] add dma_coherent_write_sync to DMA API
Date: Wed, 31 Aug 2011 17:30:12 -0400
Message-Id: <1314826214-22428-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826214-22428-1-git-send-email-msalter@redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARMv6/7 DMA-coherent memory is bufferable which means that CPU writes to
coherent memory may still be held in a write buffer for a significant amount
of time. This is largely mitigated by having the MMIO write functions force
a write buffer flush before doing the actual write to the MMIO register. This
forces out previous CPU writes to coherent memory for drivers which write to
a register to inform the device that something was written to memory. However,
this does not mitigate the problem for devices which poll the DMA memory for
changes written by the CPU. One such case was found by ming.lei@canonical.com
in the USB EHCI driver. The EHCI host controller relies at least partly on
polling DMA coherent memory for information from the driver.

This patch adds a dma_coherent_write_sync() function to the DMA API which
drivers can use to explicitly force out data which may otherwise be held up
in a write buffer. It is a no-op unless and architecture provides its own
version or the function and sets ARCH_HAS_DMA_COHERENT_WRITE_SYNC.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 Documentation/DMA-API-HOWTO.txt |   15 +++++++++++++++
 Documentation/DMA-API.txt       |   12 ++++++++++++
 include/linux/dma-mapping.h     |    6 ++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index a0b6250..8c22b8b 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -400,6 +400,21 @@ Make sure you've called dma_pool_free for all memory allocated
 from a pool before you destroy the pool. This function may not
 be called in interrupt context.
 
+Some architectures which supporting DMA coherent memory may still have write
+buffering between the CPU and DMA memory. This buffering may delay CPU writes
+from reaching coherent memory in a timely manner. These delays in turn can
+lead lead to dramatic performance issues in certain cases. An architecture
+may mitigate this problem to a large degree by having a write buffer flush
+implicit in the MMIO functions used to write to device registers. This works
+for the most common cases where a driver needs to write to a register to tell
+a device that something was written to the shared coherent memory. There are
+other cases where the device polls the dma-coherent memory for data written
+by the driver. In such cases, the driver needs to explicity force write buffer
+data to memory by calling:
+
+	dma_coherent_write_sync();
+
+
 			DMA Direction
 
 The interfaces described in subsequent portions of this document
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index fe23269..44d6923 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -418,6 +418,18 @@ void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
 	....
 
 
+Part Ie - Write buffering to dma-coherent memory
+------------------------------------------------
+
+Some architectures supporting DMA coherent memory may have write
+buffering between the CPU and DMA memory. This buffering may delay
+CPU writes from reaching coherent memory in a timely manner.
+
+    void
+    dma_coherent_write_sync()
+
+Force any outstanding coherent writes to memory.
+
 Part II - Advanced dma_ usage
 -----------------------------
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 347fdc3..b29d65c 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -154,6 +154,12 @@ dma_mark_declared_memory_occupied(struct device *dev,
 }
 #endif
 
+#ifndef ARCH_HAS_DMA_COHERENT_WRITE_SYNC
+static inline void dma_coherent_write_sync(void)
+{
+}
+#endif
+
 /*
  * Managed DMA API
  */
-- 
1.7.6


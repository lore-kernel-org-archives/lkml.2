Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2DFVCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:02:07 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53688 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab2DFVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:02:04 -0400
Message-Id: <201204062101.q36L1u5k011404@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 4 Apr 2012 16:58:27 -0400
Subject: [PATCH 4/6] arch/tile: common DMA code for the GXIO IORPC subsystem
To: linux-kernel@vger.kernel.org
In-Reply-To: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
X-OriginalArrivalTime: 06 Apr 2012 21:01:56.0229 (UTC) FILETIME=[80072B50:01CD1438]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_queue support is used by both the mPipe (networking)
and Trio (PCI) hardware shims on tilegx.  This common code is
selected when either of those drivers is built.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/gxio/Kconfig             |    9 ++
 arch/tile/gxio/Makefile            |    1 +
 arch/tile/gxio/dma_queue.c         |  236 ++++++++++++++++++++++++++++++++++++
 arch/tile/include/gxio/dma_queue.h |   59 +++++++++
 4 files changed, 305 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/gxio/dma_queue.c
 create mode 100644 arch/tile/include/gxio/dma_queue.h

diff --git a/arch/tile/gxio/Kconfig b/arch/tile/gxio/Kconfig
index c2bae7d..b5cd898 100644
--- a/arch/tile/gxio/Kconfig
+++ b/arch/tile/gxio/Kconfig
@@ -5,3 +5,12 @@ config TILE_GXIO
 	  This option supports direct access to TILE-Gx hardware from
 	  user space, via the gxio library, or from kernel space, via
 	  kernel IORPC support.
+
+config TILE_GXIO_DMA
+	bool "Tilera Gx I/O DMA support"
+	depends on TILE_GXIO
+	---help---
+	  This option supports direct access to the common I/O DMA facility
+	  within the TILE-Gx mPIPE and Trio hardware.  It is not required
+	  in order to use the gxio library to access mPIPE or Trio from
+	  user space.
diff --git a/arch/tile/gxio/Makefile b/arch/tile/gxio/Makefile
index db1ee28..97ab468 100644
--- a/arch/tile/gxio/Makefile
+++ b/arch/tile/gxio/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_TILE_GXIO) += iorpc_globals.o kiorpc.o
+obj-$(CONFIG_TILE_GXIO_DMA) += dma_queue.o
diff --git a/arch/tile/gxio/dma_queue.c b/arch/tile/gxio/dma_queue.c
new file mode 100644
index 0000000..12cb5df
--- /dev/null
+++ b/arch/tile/gxio/dma_queue.c
@@ -0,0 +1,236 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/io.h>
+#include <linux/atomic.h>
+#include <gxio/dma_queue.h>
+#include <hv/iorpc.h>
+
+/* Wait for a memory read to complete. */
+#define wait_for_value(val) \
+	__asm__ __volatile__("move %0, %0" :: "r"(val))
+
+/* The credit counter lives in the high 32 bits. */
+#define DMA_QUEUE_CREDIT_SHIFT 32
+
+/* The index is in the low 16. */
+#define DMA_QUEUE_INDEX_MASK ((1 << 16) - 1)
+
+/*
+ * The hardware descriptor-ring type.
+ * This matches the types used by mpipe (MPIPE_EDMA_POST_REGION_VAL_t)
+ * and trio (TRIO_PUSH_DMA_REGION_VAL_t or TRIO_PULL_DMA_REGION_VAL_t).
+ * See those types for more documentation on the individual fields.
+ */
+typedef union {
+	struct {
+#ifndef __BIG_ENDIAN__
+		uint64_t ring_idx   : 16;
+		uint64_t count      : 16;
+		uint64_t gen        : 1;
+		uint64_t __reserved : 31;
+#else
+		uint64_t __reserved : 31;
+		uint64_t gen        : 1;
+		uint64_t count      : 16;
+		uint64_t ring_idx   : 16;
+#endif
+	};
+	uint64_t word;
+} __gxio_ring_t;
+
+
+void __gxio_dma_queue_init(__gxio_dma_queue_t *dma_queue,
+			   void *post_region_addr,
+			   unsigned int num_entries)
+{
+	/*
+	 * Limit 65536 entry rings to 65535 credits because we only have a
+	 * 16 bit completion counter.
+	 */
+	int64_t credits = (num_entries < 65536) ? num_entries : 65535;
+
+	memset(dma_queue, 0, sizeof(*dma_queue));
+
+	dma_queue->post_region_addr = post_region_addr;
+	dma_queue->hw_complete_count = 0;
+	dma_queue->credits_and_next_index = credits << DMA_QUEUE_CREDIT_SHIFT;
+}
+
+
+static void __gxio_dma_queue_update_credits(__gxio_dma_queue_t *dma_queue)
+{
+	__gxio_ring_t val;
+	uint64_t count;
+	uint64_t delta;
+	uint64_t new_count;
+
+	/*
+	 * Read the 64-bit completion count without touching the cache, so
+	 * we later avoid having to evict any sharers of this cache line
+	 * when we update it below.
+	 */
+	uint64_t orig_hw_complete_count =
+		cmpxchg(&dma_queue->hw_complete_count, -1, -1);
+
+	/* Make sure the load completes before we access the hardware. */
+	wait_for_value(orig_hw_complete_count);
+
+	/* Read the 16-bit count of how many packets it has completed. */
+	val.word = __gxio_mmio_read(dma_queue->post_region_addr);
+	count = val.count;
+
+	/*
+	 * Calculate the number of completions since we last updated the
+	 * 64-bit counter.  It's safe to ignore the high bits because the
+	 * maximum credit value is 65535.
+	 */
+	delta = (count - orig_hw_complete_count) & 0xffff;
+	if (delta == 0)
+		return;
+
+	/*
+	 * Try to write back the count, advanced by delta.  If we race with
+	 * another thread, this might fail, in which case we return
+	 * immediately on the assumption that some credits are (or at least
+	 * were) available.
+	 */
+	new_count = orig_hw_complete_count + delta;
+	if (cmpxchg(&dma_queue->hw_complete_count,
+		    orig_hw_complete_count, new_count) !=
+	    orig_hw_complete_count)
+		return;
+
+	/*
+	 * We succeeded in advancing the completion count; add back the
+	 * corresponding number of egress credits.
+	 */
+	__insn_fetchadd(&dma_queue->credits_and_next_index,
+			(delta << DMA_QUEUE_CREDIT_SHIFT));
+}
+
+
+/*
+ * A separate 'blocked' method for put() so that backtraces and
+ * profiles will clearly indicate that we're wasting time spinning on
+ * egress availability rather than actually posting commands.
+ */
+int64_t __gxio_dma_queue_wait_for_credits(__gxio_dma_queue_t *dma_queue,
+					  int64_t modifier)
+{
+	int backoff = 16;
+	int64_t old;
+
+	do {
+		int i;
+		/* Back off to avoid spamming memory networks. */
+		for (i = backoff; i > 0; i--)
+			__insn_mfspr(SPR_PASS);
+
+		/* Check credits again. */
+		__gxio_dma_queue_update_credits(dma_queue);
+		old = __insn_fetchaddgez(&dma_queue->credits_and_next_index,
+					 modifier);
+
+		/* Calculate bounded exponential backoff for next iteration. */
+		if (backoff < 256)
+			backoff *= 2;
+	} while (old + modifier < 0);
+
+	return old;
+}
+
+
+int64_t __gxio_dma_queue_reserve_aux(__gxio_dma_queue_t *dma_queue,
+				     unsigned int num, int wait)
+{
+	uint64_t slot;
+	uint64_t complete;
+
+	/*
+	 * Try to reserve 'num' egress command slots.  We do this by
+	 * constructing a constant that subtracts N credits and adds N to
+	 * the index, and using fetchaddgez to only apply it if the credits
+	 * count doesn't go negative.
+	 */
+	int64_t modifier = (((int64_t)(-num)) << DMA_QUEUE_CREDIT_SHIFT) | num;
+	int64_t old = __insn_fetchaddgez(&dma_queue->credits_and_next_index,
+					 modifier);
+
+	if (unlikely(old + modifier < 0)) {
+		/*
+		 * We're out of credits.  Try once to get more by checking for
+		 * completed egress commands.  If that fails, wait or fail.
+		 */
+		__gxio_dma_queue_update_credits(dma_queue);
+		old = __insn_fetchaddgez(&dma_queue->credits_and_next_index,
+					 modifier);
+		if (old + modifier < 0) {
+			if (wait)
+				old = __gxio_dma_queue_wait_for_credits(
+					dma_queue, modifier);
+			else
+				return GXIO_ERR_DMA_CREDITS;
+		}
+	}
+
+	/*
+	 * Compute the value for "slot" which will correspond to the
+	 * eventual value of "hw_complete_count".  We combine the low 24
+	 * bits of "old" with the high 40 bits of "hw_complete_count", and
+	 * if the result is LESS than "hw_complete_count", then we handle
+	 * wrapping by adding "1 << 24".  TODO: As a future optimization,
+	 * whenever "hw_complete_count" is modified, we could store the high
+	 * 41 bits of "hw_complete_count" in a separate field, but only when
+	 * they change, and use it instead of "hw_complete_count" above.
+	 * This will reduce the chance of "inval storms".  TODO: As a future
+	 * optimization, we could make a version of this function that simply
+	 * returns "old & 0xffffff", which is "good enough" for many uses.
+	 */
+	complete = ACCESS_ONCE(dma_queue->hw_complete_count);
+	slot = (complete & 0xffffffffff000000) | (old & 0xffffff);
+	if (slot < complete)
+		slot += 0x1000000;
+
+	/*
+	 * If any of our indexes mod 256 were equivalent to 0, go ahead and
+	 * collect some egress credits, and update "hw_complete_count".
+	 */
+	if (unlikely(((slot + num) & 0xff) < num)) {
+		__gxio_dma_queue_update_credits(dma_queue);
+
+		/* Make sure the index doesn't overflow into the credits. */
+#ifdef __BIG_ENDIAN__
+		*(((uint8_t *)&dma_queue->credits_and_next_index) + 4) = 0;
+#else
+		*(((uint8_t *)&dma_queue->credits_and_next_index) + 3) = 0;
+#endif
+	}
+
+	return slot;
+}
+
+
+int __gxio_dma_queue_is_complete(__gxio_dma_queue_t *dma_queue, int64_t slot,
+				 int update)
+{
+	if (update) {
+		if (ACCESS_ONCE(dma_queue->hw_complete_count) > slot)
+			return 1;
+
+		__gxio_dma_queue_update_credits(dma_queue);
+	}
+
+	return ACCESS_ONCE(dma_queue->hw_complete_count) > slot;
+}
diff --git a/arch/tile/include/gxio/dma_queue.h b/arch/tile/include/gxio/dma_queue.h
new file mode 100644
index 0000000..6e18b88
--- /dev/null
+++ b/arch/tile/include/gxio/dma_queue.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _GXIO_DMA_QUEUE_H_
+#define _GXIO_DMA_QUEUE_H_
+
+/*
+ * DMA queue management APIs shared between TRIO and mPIPE.
+ */
+
+#include "common.h"
+
+/* State object that tracks a DMA queue's head and tail indices, as
+    well as the number of commands posted and completed.  The
+    structure is accessed via a thread-safe, lock-free algorithm. */
+typedef struct {
+  /* Address of a MPIPE_EDMA_POST_REGION_VAL_t,
+      TRIO_PUSH_DMA_REGION_VAL_t, or TRIO_PULL_DMA_REGION_VAL_t
+      register.  These register have identical encodings and provide
+      information about how many commands have been processed. */
+	void *post_region_addr;
+
+  /* A lazily-updated count of how many commands the hardware has
+      completed. */
+	uint64_t hw_complete_count __attribute__ ((aligned(64)));
+
+  /* High 32 bits are a count of available egress command credits,
+      low 32 bits are the next command index. */
+	int64_t credits_and_next_index;
+} __gxio_dma_queue_t;
+
+/* Initialize a dma queue. */
+void __gxio_dma_queue_init(__gxio_dma_queue_t *dma_queue,
+			   void *post_region_addr, unsigned int num_entries);
+
+/* Try to reserve credits, potentially blocking. */
+int64_t __gxio_dma_queue_reserve_aux(__gxio_dma_queue_t *dma_queue,
+				     unsigned int num, int wait);
+
+/* Wait for credits to become available. */
+int64_t __gxio_dma_queue_wait_for_credits(__gxio_dma_queue_t *dma_queue,
+					  int64_t modifier);
+
+/* Check whether a particular slot has completed. */
+int __gxio_dma_queue_is_complete(__gxio_dma_queue_t *dma_queue, int64_t slot,
+				 int update);
+
+#endif /* !_GXIO_DMA_QUEUE_H_ */
-- 
1.6.5.2


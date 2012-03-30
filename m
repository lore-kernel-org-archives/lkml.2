Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068Ab2C3WvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:51:09 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934877Ab2C3VGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:13 -0400
Message-Id: <201203302105.q2UL58uK006307@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 15:47:38 -0400
Subject: [PATCH] arch/tile: fix finv_buffer_remote() for tilegx
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:08.0913 (UTC) FILETIME=[C9FC2A10:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some correctness issues with this code that are now fixed
with this change.  The change is likely less performant than it could
be, but it should no longer be vulnerable to any races with memory
operations on the memory network while invalidating a range of memory.
This code is run infrequently so performance isn't critical, but
correctness definitely is.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/cacheflush.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index 6af2b97..db4fb89 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -39,7 +39,21 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 {
 	char *p, *base;
 	size_t step_size, load_count;
+
+	/*
+	 * On TILEPro the striping granularity is a fixed 8KB; on
+	 * TILE-Gx it is configurable, and we rely on the fact that
+	 * the hypervisor always configures maximum striping, so that
+	 * bits 9 and 10 of the PA are part of the stripe function, so
+	 * every 512 bytes we hit a striping boundary.
+	 *
+	 */
+#ifdef __tilegx__
+	const unsigned long STRIPE_WIDTH = 512;
+#else
 	const unsigned long STRIPE_WIDTH = 8192;
+#endif
+
 #ifdef __tilegx__
 	/*
 	 * On TILE-Gx, we must disable the dstream prefetcher before doing
@@ -74,7 +88,7 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 	 * memory, that one load would be sufficient, but since we may
 	 * be, we also need to back up to the last load issued to
 	 * another memory controller, which would be the point where
-	 * we crossed an 8KB boundary (the granularity of striping
+	 * we crossed a "striping" boundary (the granularity of striping
 	 * across memory controllers).  Keep backing up and doing this
 	 * until we are before the beginning of the buffer, or have
 	 * hit all the controllers.
@@ -88,12 +102,22 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 	 * every cache line on a full memory stripe on each
 	 * controller" that we simply do that, to simplify the logic.
 	 *
-	 * FIXME: See bug 9535 for some issues with this code.
+	 * On TILE-Gx the hash-for-home function is much more complex,
+	 * with the upshot being we can't readily guarantee we have
+	 * hit both entries in the 128-entry AMT that were hit by any
+	 * load in the entire range, so we just re-load them all.
+	 * With larger buffers, we may want to consider using a hypervisor
+	 * trap to issue loads directly to each hash-for-home tile for
+	 * each controller (doing it from Linux would trash the TLB).
 	 */
 	if (hfh) {
 		step_size = L2_CACHE_BYTES;
+#ifdef __tilegx__
+		load_count = (size + L2_CACHE_BYTES - 1) / L2_CACHE_BYTES;
+#else
 		load_count = (STRIPE_WIDTH / L2_CACHE_BYTES) *
 			      (1 << CHIP_LOG_NUM_MSHIMS());
+#endif
 	} else {
 		step_size = STRIPE_WIDTH;
 		load_count = (1 << CHIP_LOG_NUM_MSHIMS());
-- 
1.6.5.2


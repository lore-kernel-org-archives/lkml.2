Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1ATRle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:41:34 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:57864
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750762Ab1ATRld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:41:33 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/ringbuffer: Fix use of stale HEAD position whilst polling for space
Date: Thu, 20 Jan 2011 17:41:19 +0000
Message-Id: <1295545279-21335-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTi=AEhztUp30A0o5YxHCqqLg38+f5s+mXfbZTX8Y@mail.gmail.com>
References: <AANLkTi=AEhztUp30A0o5YxHCqqLg38+f5s+mXfbZTX8Y@mail.gmail.com>
X-To-Not-Matched: true
X-Originating-IP: 78.156.66.37
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend, Linus found that his machine would hang for 3 seconds,
and identified that intel_ring_buffer_wait() was the culprit:

"Because from looking at the code, I get the notion that
"intel_read_status_page()" may not be exact. But what happens if that
inexact value matches our cached ring->actual_head, so we never even
try to read the exact case? Does it _stay_ inexact for arbitrarily
long times? If so, we might wait for the ring to empty forever (well,
until the timeout - the behavior I see), even though the ring really
_is_ empty."

As the reported HEAD position is only updated every time it crosses a
64k boundary, whilst draining the ring it is indeed likely to remain one
value. If that value matches the last known HEAD position, we never read
the true value from the register and so trigger a timeout.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |   40 ++++++++++++++++++------------
 drivers/gpu/drm/i915/intel_ringbuffer.h |    1 -
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 51fbc5e..6218fa9 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -34,6 +34,14 @@
 #include "i915_trace.h"
 #include "intel_drv.h"
 
+static inline int ring_space(struct intel_ring_buffer *ring)
+{
+	int space = (ring->head & HEAD_ADDR) - (ring->tail + 8);
+	if (space < 0)
+		space += ring->size;
+	return space;
+}
+
 static u32 i915_gem_get_seqno(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -204,11 +212,9 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 	if (!drm_core_check_feature(ring->dev, DRIVER_MODESET))
 		i915_kernel_lost_context(ring->dev);
 	else {
-		ring->head = I915_READ_HEAD(ring) & HEAD_ADDR;
+		ring->head = I915_READ_HEAD(ring);
 		ring->tail = I915_READ_TAIL(ring) & TAIL_ADDR;
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		ring->space = ring_space(ring);
 	}
 
 	return 0;
@@ -921,7 +927,7 @@ static int intel_wrap_ring_buffer(struct intel_ring_buffer *ring)
 	}
 
 	ring->tail = 0;
-	ring->space = ring->head - 8;
+	ring->space = ring_space(ring);
 
 	return 0;
 }
@@ -933,20 +939,22 @@ int intel_wait_ring_buffer(struct intel_ring_buffer *ring, int n)
 	unsigned long end;
 	u32 head;
 
+	/* If the reported head position has wrapped or hasn't advanced,
+	 * fallback to the slow and accurate path.
+	 */
+	head = intel_read_status_page(ring, 4);
+	if (head > ring->head) {
+		ring->head = head;
+		ring->space = ring_space(ring);
+		if (ring->space >= n)
+			return 0;
+	}
+
 	trace_i915_ring_wait_begin (dev);
 	end = jiffies + 3 * HZ;
 	do {
-		/* If the reported head position has wrapped or hasn't advanced,
-		 * fallback to the slow and accurate path.
-		 */
-		head = intel_read_status_page(ring, 4);
-		if (head < ring->actual_head)
-			head = I915_READ_HEAD(ring);
-		ring->actual_head = head;
-		ring->head = head & HEAD_ADDR;
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		ring->head = I915_READ_HEAD(ring);
+		ring->space = ring_space(ring);
 		if (ring->space >= n) {
 			trace_i915_ring_wait_end(dev);
 			return 0;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 61d5220..6d6fde8 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -47,7 +47,6 @@ struct  intel_ring_buffer {
 	struct		drm_device *dev;
 	struct		drm_i915_gem_object *obj;
 
-	u32		actual_head;
 	u32		head;
 	u32		tail;
 	int		space;
-- 
1.7.2.3


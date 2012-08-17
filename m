Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030796Ab2HQDcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:32:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46798 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030663Ab2HQD1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:01 -0400
Message-Id: <20120817030248.892667316@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Subject: [ 32/37] drm/i915: correctly order the ring init sequence
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.

We may only start to set up the new register values after having
confirmed that the ring is truely off. Otherwise the hw might lose the
newly written register values. This is caught later on in the init
sequence, when we check whether the register writes have stuck.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
Tested-by: Yang Guang <guang.a.yang@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index bf0195a..414af1e 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -289,8 +289,6 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 	I915_WRITE_HEAD(ring, 0);
 	ring->write_tail(ring, 0);
 
-	/* Initialize the ring. */
-	I915_WRITE_START(ring, obj->gtt_offset);
 	head = I915_READ_HEAD(ring) & HEAD_ADDR;
 
 	/* G45 ring initialization fails to reset head to zero */
@@ -316,6 +314,11 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 		}
 	}
 
+	/* Initialize the ring. This must happen _after_ we've cleared the ring
+	 * registers with the above sequence (the readback of the HEAD registers
+	 * also enforces ordering), otherwise the hw might lose the new ring
+	 * register values. */
+	I915_WRITE_START(ring, obj->gtt_offset);
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
 			| RING_VALID);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab2JKAUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:20:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36250 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932999Ab2JKAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:16:24 -0400
X-Sasl-enc: cTQ7xj3SUTwmOaM4q1431JmdK3S9rK4H7uReEBXs9c1t 1349914582
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 121/133] Revert "drm/i915: correctly order the ring init sequence"
Date: Thu, 11 Oct 2012 07:52:27 +0900
Message-Id: <20121010224916.321548770@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts 622ecb9ace2ec006b58f6779732961945ea303ca which is
commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.

We may only start to set up the new register values after having
confirmed that the ring is truely off. Otherwise the hw might lose the
newly written register values. This is caught later on in the init
sequence, when we check whether the register writes have stuck.

Reported-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Yang Guang <guang.a.yang@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -280,6 +280,8 @@ static int init_ring_common(struct intel
 	I915_WRITE_HEAD(ring, 0);
 	ring->write_tail(ring, 0);
 
+	/* Initialize the ring. */
+	I915_WRITE_START(ring, obj->gtt_offset);
 	head = I915_READ_HEAD(ring) & HEAD_ADDR;
 
 	/* G45 ring initialization fails to reset head to zero */
@@ -305,11 +307,6 @@ static int init_ring_common(struct intel
 		}
 	}
 
-	/* Initialize the ring. This must happen _after_ we've cleared the ring
-	 * registers with the above sequence (the readback of the HEAD registers
-	 * also enforces ordering), otherwise the hw might lose the new ring
-	 * register values. */
-	I915_WRITE_START(ring, obj->gtt_offset);
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
 			| RING_VALID);



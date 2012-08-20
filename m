Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2HTD4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:56:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2HTD4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:56:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 04/16] drm/i915: correctly order the ring init sequence
Date: Sun, 19 Aug 2012 20:56:03 -0700
Message-Id: <20120820035458.292084336@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035457.653002510@linuxfoundation.org>
References: <20120820035457.653002510@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -150,8 +150,6 @@ static int init_ring_common(struct intel
 	I915_WRITE_HEAD(ring, 0);
 	ring->write_tail(ring, 0);
 
-	/* Initialize the ring. */
-	I915_WRITE_START(ring, obj->gtt_offset);
 	head = I915_READ_HEAD(ring) & HEAD_ADDR;
 
 	/* G45 ring initialization fails to reset head to zero */
@@ -177,6 +175,11 @@ static int init_ring_common(struct intel
 		}
 	}
 
+	/* Initialize the ring. This must happen _after_ we've cleared the ring
+	 * registers with the above sequence (the readback of the HEAD registers
+	 * also enforces ordering), otherwise the hw might lose the new ring
+	 * register values. */
+	I915_WRITE_START(ring, obj->gtt_offset);
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
 			| RING_REPORT_64K | RING_VALID);



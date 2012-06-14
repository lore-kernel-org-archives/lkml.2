Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2FNX66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2FNX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:54 -0400
Message-Id: <20120614235624.085907695@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 02/42] drm/i915: Reset last_retired_head when resetting ring
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit c3b20037926e607b6cdaecbf9d3103e2ca63bc31 upstream.

When we reset the ring control registers, including the HEAD and TAIL of
the ring, we also need to reset associated state. In this instance, we
were failing to reset the cached value of ring->last_retired_head and so
upon the first request for more space following a resume would
potentially (depending on a narrow race window) believe that the HEAD had
advanced much further than reality.

This is a regression from:

commit a71d8d94525e8fd855c0466fb586ae1cb008f3a2
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 15 11:25:36 2012 +0000

    drm/i915: Record the tail at each request and use it to estimate the head

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -309,6 +309,7 @@ static int init_ring_common(struct intel
 		ring->head = I915_READ_HEAD(ring);
 		ring->tail = I915_READ_TAIL(ring) & TAIL_ADDR;
 		ring->space = ring_space(ring);
+		ring->last_retired_head = -1;
 	}
 
 	return 0;



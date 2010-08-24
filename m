Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab0HXXRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:17:09 -0400
Received: from kroah.org ([198.145.64.141]:41072 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933444Ab0HXXCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:18 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:05 2010
Message-Id: <20100824224505.278927481@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>
Subject: [046/114] drm/i915: i8xx also doesnt like multiple oustanding pageflips
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 6146b3d61925116e3fecce36c2fd873665bd6614 upstream.

My i855GM suffers from a 80k/s interrupt storm without this.
So add 2nd gen to the list of things that don't like more than
one outstanding pageflip request.

Furthermore I've changed the busy loop into a ringbuffer wait.
Busy-loops that don't check whether the chip died are simply evil.
And performance should actually improve, because there's usually
a decent amount of rendering queued on the gpu, hopefully rendering
that MI_WAIT into a noop by the time it's executed.

The current code holds dev->struct_mutex while executing this loop,
hence stalling all other gem activity anyway.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
[anholt: resolved against conflict]
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4816,14 +4816,16 @@ static int intel_crtc_page_flip(struct d
 	work->pending_flip_obj = obj;
 
 	if (intel_crtc->plane)
-		flip_mask = I915_DISPLAY_PLANE_B_FLIP_PENDING_INTERRUPT;
+		flip_mask = MI_WAIT_FOR_PLANE_B_FLIP;
 	else
-		flip_mask = I915_DISPLAY_PLANE_A_FLIP_PENDING_INTERRUPT;
+		flip_mask = MI_WAIT_FOR_PLANE_A_FLIP;
 
-	/* Wait for any previous flip to finish */
-	if (IS_GEN3(dev))
-		while (I915_READ(ISR) & flip_mask)
-			;
+	if (IS_GEN3(dev) || IS_GEN2(dev)) {
+		BEGIN_LP_RING(2);
+		OUT_RING(MI_WAIT_FOR_EVENT | flip_mask);
+		OUT_RING(0);
+		ADVANCE_LP_RING();
+	}
 
 	/* Offset into the new buffer for cases of shared fbs between CRTCs */
 	offset = obj_priv->gtt_offset;



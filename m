Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2JKAOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:14:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54900 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932775Ab2JKAOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:14:32 -0400
X-Sasl-enc: RbU9EwWoZjG/PMwtX0hXbdHPcR6KConipG5UtRLpDuy2 1349914471
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 099/133] drm/i915: Fix GT_MODE default value
Date: Thu, 11 Oct 2012 07:52:05 +0900
Message-Id: <20121010224912.333302920@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit f8f2ac9a76b0f80a6763ca316116a7bab8486997 upstream.

I can't even find how I figured this might be needed anymore. But sure
enough, the value I'm reading back on platforms doesn't match what the
docs recommends.

It seemed to fix Chris' GT1 in limited testing as well.

Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    3 +++
 drivers/gpu/drm/i915/intel_pm.c |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -514,6 +514,9 @@
 # define VS_TIMER_DISPATCH				(1 << 6)
 # define MI_FLUSH_ENABLE				(1 << 12)
 
+#define GEN6_GT_MODE	0x20d0
+#define   GEN6_GT_MODE_HI	(1 << 9)
+
 #define GFX_MODE	0x02520
 #define GFX_MODE_GEN7	0x0229c
 #define RING_MODE_GEN7(ring)	((ring)->mmio_base+0x29c)
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3363,6 +3363,11 @@ static void gen6_init_clock_gating(struc
 			   DISPPLANE_TRICKLE_FEED_DISABLE);
 		intel_flush_display_plane(dev_priv, pipe);
 	}
+
+	/* The default value should be 0x200 according to docs, but the two
+	 * platforms I checked have a 0 for this. (Maybe BIOS overrides?) */
+	I915_WRITE(GEN6_GT_MODE, _MASKED_BIT_DISABLE(0xffff));
+	I915_WRITE(GEN6_GT_MODE, _MASKED_BIT_ENABLE(GEN6_GT_MODE_HI));
 }
 
 static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)



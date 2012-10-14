Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2JNOmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46373 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab2JNOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:47 -0400
Message-Id: <20121014143547.291345441@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 100/147] drm/i915: Fix GT_MODE default value
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: open-code _MASKED_BIT_{ENABLE,DISABLE}]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -401,6 +401,9 @@
 # define VS_TIMER_DISPATCH				(1 << 6)
 # define MI_FLUSH_ENABLE				(1 << 11)
 
+#define GEN6_GT_MODE	0x20d0
+#define   GEN6_GT_MODE_HI	(1 << 9)
+
 #define GFX_MODE	0x02520
 #define GFX_MODE_GEN7	0x0229c
 #define   GFX_RUN_LIST_ENABLE		(1<<15)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8298,6 +8298,11 @@ static void gen6_init_clock_gating(struc
 			   DISPPLANE_TRICKLE_FEED_DISABLE);
 		intel_flush_display_plane(dev_priv, pipe);
 	}
+
+	/* The default value should be 0x200 according to docs, but the two
+	 * platforms I checked have a 0 for this. (Maybe BIOS overrides?) */
+	I915_WRITE(GEN6_GT_MODE, 0xffff << 16);
+	I915_WRITE(GEN6_GT_MODE, GEN6_GT_MODE_HI << 16 | GEN6_GT_MODE_HI);
 }
 
 static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)



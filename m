Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2FQSkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:40:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880Ab2FQSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:00 -0400
Message-Id: <20120617175941.644246078@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [ 02/69] drm/i915: hold forcewake around ring hw init
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 upstream.

Empirical evidence suggests that we need to: On at least one ivb
machine when running the hangman i-g-t test, the rings don't properly
initialize properly - the RING_START registers seems to be stuck at
all zeros.

Holding forcewake around this register init sequences makes chip reset
reliable again. Note that this is not the first such issue:

commit f01db988ef6f6c70a6cc36ee71e4a98a68901229
Author: Sean Paul <seanpaul@chromium.org>
Date:   Fri Mar 16 12:43:22 2012 -0400

    drm/i915: Add wait_for in init_ring_common

added delay loops to make RING_START and RING_CTL initialization
reliable on the blt ring at boot-up. So I guess it won't hurt if we do
this unconditionally for all force_wake needing gpus.

To avoid copy&pasting of the HAS_FORCE_WAKE check I've added a new
intel_info bit for that.

v2: Fixup missing commas in static struct and properly handling the
error case in init_ring_common, both noticed by Jani Nikula.

Reported-and-tested-by: Yang Guang <guang.a.yang@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2:
 - drop changes to Haswell device information
 - NEEDS_FORCE_WAKE didn't refer to Valley View anyway]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -214,6 +214,7 @@
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_sandybridge_m_info = {
@@ -222,6 +223,7 @@
 	.has_fbc = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_ivybridge_d_info = {
@@ -229,6 +231,7 @@
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_ivybridge_m_info = {
@@ -237,6 +240,7 @@
 	.has_fbc = 0,	/* FBC is not enabled on Ivybridge mobile yet */
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct pci_device_id pciidlist[] = {		/* aka */
@@ -939,7 +943,7 @@
 
 /* We give fast paths for the really cool registers */
 #define NEEDS_FORCE_WAKE(dev_priv, reg) \
-	(((dev_priv)->info->gen >= 6) && \
+	((HAS_FORCE_WAKE((dev_priv)->dev)) && \
 	 ((reg) < 0x40000) &&		 \
 	 ((reg) != FORCEWAKE) &&	 \
 	 ((reg) != ECOBUS))
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -244,6 +244,7 @@
 	u8 is_broadwater:1;
 	u8 is_crestline:1;
 	u8 is_ivybridge:1;
+	u8 has_force_wake:1;
 	u8 has_fbc:1;
 	u8 has_pipe_cxsr:1;
 	u8 has_hotplug:1;
@@ -1001,6 +1002,8 @@
 #define HAS_PCH_CPT(dev) (INTEL_PCH_TYPE(dev) == PCH_CPT)
 #define HAS_PCH_IBX(dev) (INTEL_PCH_TYPE(dev) == PCH_IBX)
 
+#define HAS_FORCE_WAKE(dev) (INTEL_INFO(dev)->has_force_wake)
+
 #include "i915_trace.h"
 
 extern struct drm_ioctl_desc i915_ioctls[];
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -263,10 +263,15 @@
 
 static int init_ring_common(struct intel_ring_buffer *ring)
 {
-	drm_i915_private_t *dev_priv = ring->dev->dev_private;
+	struct drm_device *dev = ring->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_gem_object *obj = ring->obj;
+	int ret = 0;
 	u32 head;
 
+	if (HAS_FORCE_WAKE(dev))
+		gen6_gt_force_wake_get(dev_priv);
+
 	/* Stop the ring if it's running. */
 	I915_WRITE_CTL(ring, 0);
 	I915_WRITE_HEAD(ring, 0);
@@ -314,7 +319,8 @@
 				I915_READ_HEAD(ring),
 				I915_READ_TAIL(ring),
 				I915_READ_START(ring));
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (!drm_core_check_feature(ring->dev, DRIVER_MODESET))
@@ -325,7 +331,11 @@
 		ring->space = ring_space(ring);
 	}
 
-	return 0;
+out:
+	if (HAS_FORCE_WAKE(dev))
+		gen6_gt_force_wake_put(dev_priv);
+
+	return ret;
 }
 
 static int



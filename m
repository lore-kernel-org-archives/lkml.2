Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2HXXDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 19:03:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2HXXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 19:03:21 -0400
Date: Fri, 24 Aug 2012 20:03:14 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 08/32] drm/i915: correctly order the ring init sequence
Message-ID: <20120824230313.GD3072@herton-Z68MA-D2H-B3>
References: <20120820035647.862247088@linuxfoundation.org>
 <20120820035649.020303468@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820035649.020303468@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 08:57:04PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.
> 
> We may only start to set up the new register values after having
> confirmed that the ring is truely off. Otherwise the hw might lose the
> newly written register values. This is caught later on in the init
> sequence, when we check whether the register writes have stuck.
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
> Tested-by: Yang Guang <guang.a.yang@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I think with this commit also the following commits should be picked for
3.4 right? (as suggested for 3.0):

f01db988ef6f6c70a6cc36ee71e4a98a68901229
b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6

Just reporting that I tested this 3.4.10 proposed update with the two
commits above cherry-picked/backported applied, and worked ok.

The first cherry-picked cleanly, while
b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 needed backporting for 3.4,
like happened with 3.0, this is a proposed backport which I
applied/tested, is similar to 3.0 and 3.2 versions:

>From a2712ae26afde5be2bc62080755d1324164f53d3 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Mon, 4 Jun 2012 11:18:15 +0200
Subject: [PATCH] drm/i915: hold forcewake around ring hw init

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

Cc: stable@vger.kernel.org
Reported-and-tested-by: Yang Guang <guang.a.yang@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[herton: backport to 3.4:
 - adjust for different struct intel_device_info layouts
 - drop changes to Haswell/Valleyview, not present in 3.4
 - NEEDS_FORCE_WAKE is on i915_drv.h, and doesn't have IS_VALLEYVIEW ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c         |    4 ++++
 drivers/gpu/drm/i915/i915_drv.h         |    7 +++++--
 drivers/gpu/drm/i915/intel_ringbuffer.c |   16 +++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index ae8a64f..c654557 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -224,6 +224,7 @@ static const struct intel_device_info intel_sandybridge_d_info = {
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
 	.has_llc = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_sandybridge_m_info = {
@@ -233,6 +234,7 @@ static const struct intel_device_info intel_sandybridge_m_info = {
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
 	.has_llc = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_ivybridge_d_info = {
@@ -241,6 +243,7 @@ static const struct intel_device_info intel_ivybridge_d_info = {
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
 	.has_llc = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_ivybridge_m_info = {
@@ -250,6 +253,7 @@ static const struct intel_device_info intel_ivybridge_m_info = {
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
 	.has_llc = 1,
+	.has_force_wake = 1,
 };
 
 static const struct pci_device_id pciidlist[] = {		/* aka */
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 5fabc6c..a2117b2 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -255,6 +255,7 @@ struct intel_device_info {
 	u8 is_broadwater:1;
 	u8 is_crestline:1;
 	u8 is_ivybridge:1;
+	u8 has_force_wake:1;
 	u8 has_fbc:1;
 	u8 has_pipe_cxsr:1;
 	u8 has_hotplug:1;
@@ -1051,6 +1052,8 @@ struct drm_i915_file_private {
 #define HAS_PCH_CPT(dev) (INTEL_PCH_TYPE(dev) == PCH_CPT)
 #define HAS_PCH_IBX(dev) (INTEL_PCH_TYPE(dev) == PCH_IBX)
 
+#define HAS_FORCE_WAKE(dev) (INTEL_INFO(dev)->has_force_wake)
+
 #include "i915_trace.h"
 
 /**
@@ -1452,8 +1455,8 @@ int __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv);
 
 /* We give fast paths for the really cool registers */
 #define NEEDS_FORCE_WAKE(dev_priv, reg) \
-	(((dev_priv)->info->gen >= 6) && \
-	 ((reg) < 0x40000) &&		 \
+	((HAS_FORCE_WAKE((dev_priv)->dev)) && \
+	 ((reg) < 0x40000) &&            \
 	 ((reg) != FORCEWAKE))
 
 #define __i915_read(x, y) \
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 9ef731d..88e89a2 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -249,10 +249,15 @@ u32 intel_ring_get_active_head(struct intel_ring_buffer *ring)
 
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
@@ -303,7 +308,8 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 				I915_READ_HEAD(ring),
 				I915_READ_TAIL(ring),
 				I915_READ_START(ring));
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (!drm_core_check_feature(ring->dev, DRIVER_MODESET))
@@ -315,7 +321,11 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 		ring->last_retired_head = -1;
 	}
 
-	return 0;
+out:
+	if (HAS_FORCE_WAKE(dev))
+		gen6_gt_force_wake_put(dev_priv);
+
+	return ret;
 }
 
 static int
-- 
1.7.9.5

-- 
[]'s
Herton

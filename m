Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab2HWQSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:18:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2HWQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:18:52 -0400
Date: Thu, 23 Aug 2012 13:18:43 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Subject: Re: [ 04/16] drm/i915: correctly order the ring init sequence
Message-ID: <20120823161842.GA3004@herton-Z68MA-D2H-B3>
References: <20120820035457.653002510@linuxfoundation.org>
 <20120820035458.292084336@linuxfoundation.org>
 <20120821051318.GB3625@herton-Z68MA-D2H-B3>
 <CAKMK7uFpj+qctqKOk6PJqRn_7XAiDbE7Bv2r2VseGyUHUTD2mA@mail.gmail.com>
 <20120821131115.GA3132@herton-Z68MA-D2H-B3>
 <CAKMK7uFjxQZYXLrs14RydnSKp6_ghwUL-1xGQm5C5dXao60Fhg@mail.gmail.com>
 <20120822045015.GB3132@herton-Z68MA-D2H-B3>
 <20120822224451.GC3076@herton-Z68MA-D2H-B3>
 <CAKMK7uFUX-U1Y-GAyR+ma=k8pcfUpvZESomgog2C6KrfkRbcaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFUX-U1Y-GAyR+ma=k8pcfUpvZESomgog2C6KrfkRbcaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:10:18AM +0200, Daniel Vetter wrote:
> On Thu, Aug 23, 2012 at 12:44 AM, Herton Ronaldo Krzesinski
> <herton.krzesinski@canonical.com> wrote:
> > Really sorry about this, but it was a hardware+bios setting problem
> > here. I finished investigating what was happening here, and is related to
> > the DRAM installed on this machine. The memory installed is DDR3-1333,
> > and on bios it was configured as that, but turns out the chipset (G41)
> > only supports up to DDR3-1066 (as on specs, although the motherboard
> > lists the 1333 as supported, but as "OC", and allows configuring this
> > way automatically or manually).
> >
> > After setting manually back to 1066, I stopped seeing all the weird
> > behaviour, like the writes to the start address don't trigger anymore
> > setting on the head offset. I'm sorry about that, and really it's a
> > brown paper bag time for me :(. The machine worked fine and passed
> > through memtest and never gave any problems, this was the first
> > time (seems only the video device didn't like the memory setting, and
> > the code change probably changed timing in the right way to pop up this
> > now, also never had graphics corruption or other noticeable problems).
> > I retested kernels that gave problems and they run fine now.
> 
> Well, at least we could clear this up.
> 
> Greg, please pick up the following patches for 3.0 (if you haven't already):
> 
> f01db988ef6f6c70a6cc36ee71e4a98a68901229 and
> 0d8957c8a90bbb5d34fab9a304459448a5131e06
> 
> Note that all kernels that need f01db backported also need
> b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 (to fix a regression
> introduce by the former).

b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 needs some backporting for 3.0,
I did it in advance, build tested and installed here on a sandybridge
based laptop on x86_64:

>From 3adf724d83de569510f2df0b91a097de92372970 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Mon, 4 Jun 2012 11:18:15 +0200
Subject: [PATCH 2/2] drm/i915: hold forcewake around ring hw init

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

Cc: stable@vger.kernel.org
Reported-and-tested-by: Yang Guang <guang.a.yang@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[herton: backport to 3.0:
 - adjust for different struct intel_device_info layouts
 - drop changes to Haswell, not present in 3.0
 - NEEDS_FORCE_WAKE is on i915_drv.h, and doesn't have IS_VALLEYVIEW ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c         |    4 ++++
 drivers/gpu/drm/i915/i915_drv.h         |    9 ++++++---
 drivers/gpu/drm/i915/intel_ringbuffer.c |   16 +++++++++++++---
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 111686a..9111d4c 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -181,6 +181,7 @@ static const struct intel_device_info intel_sandybridge_d_info = {
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_sandybridge_m_info = {
@@ -189,6 +190,7 @@ static const struct intel_device_info intel_sandybridge_m_info = {
 	.has_fbc = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_ivybridge_d_info = {
@@ -196,6 +198,7 @@ static const struct intel_device_info intel_ivybridge_d_info = {
 	.need_gfx_hws = 1, .has_hotplug = 1,
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct intel_device_info intel_ivybridge_m_info = {
@@ -204,6 +207,7 @@ static const struct intel_device_info intel_ivybridge_m_info = {
 	.has_fbc = 0,	/* FBC is not enabled on Ivybridge mobile yet */
 	.has_bsd_ring = 1,
 	.has_blt_ring = 1,
+	.has_force_wake = 1,
 };
 
 static const struct pci_device_id pciidlist[] = {		/* aka */
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b570415..e80acf9 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -234,6 +234,7 @@ struct intel_device_info {
 	u8 is_broadwater : 1;
 	u8 is_crestline : 1;
 	u8 is_ivybridge : 1;
+	u8 has_force_wake:1;
 	u8 has_fbc : 1;
 	u8 has_pipe_cxsr : 1;
 	u8 has_hotplug : 1;
@@ -986,6 +987,8 @@ struct drm_i915_file_private {
 #define HAS_PCH_CPT(dev) (INTEL_PCH_TYPE(dev) == PCH_CPT)
 #define HAS_PCH_IBX(dev) (INTEL_PCH_TYPE(dev) == PCH_IBX)
 
+#define HAS_FORCE_WAKE(dev) (INTEL_INFO(dev)->has_force_wake)
+
 #include "i915_trace.h"
 
 extern struct drm_ioctl_desc i915_ioctls[];
@@ -1342,9 +1345,9 @@ void __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv);
 
 /* We give fast paths for the really cool registers */
 #define NEEDS_FORCE_WAKE(dev_priv, reg) \
-	(((dev_priv)->info->gen >= 6) && \
-	((reg) < 0x40000) && \
-	((reg) != FORCEWAKE))
+	((HAS_FORCE_WAKE((dev_priv)->dev)) && \
+	 ((reg) < 0x40000) &&            \
+	 ((reg) != FORCEWAKE))
 
 #define __i915_read(x, y) \
 static inline u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 38ae0ec..1e225d9 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -141,10 +141,15 @@ u32 intel_ring_get_active_head(struct intel_ring_buffer *ring)
 
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
@@ -195,7 +200,8 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 				I915_READ_HEAD(ring),
 				I915_READ_TAIL(ring),
 				I915_READ_START(ring));
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (!drm_core_check_feature(ring->dev, DRIVER_MODESET))
@@ -206,7 +212,11 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 		ring->space = ring_space(ring);
 	}
 
-	return 0;
+out:
+	if (HAS_FORCE_WAKE(dev))
+		gen6_gt_force_wake_put(dev_priv);
+
+	return ret;
 }
 
 /*
-- 
1.7.5.4

> 
> Thanks, Daniel
> -- 
> Daniel Vetter
> daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton

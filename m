Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965745Ab2E0BZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:25:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35469 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945945Ab2E0BTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:19:14 -0400
Message-Id: <20120527002521.485934241@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:13 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Bernard Kilarski <bernard.r.kilarski@intel.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 67/91] drm/i915: [GEN7] Use HW scheduler for fixed function shaders
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit a1e969e0332de7a430e62822cee8f2ec8d83cd7c upstream.

This originally started as a patch from Bernard as a way of simply
setting the VS scheduler. After submitting the RFC patch, we decided to
also modify the DS scheduler. To be most explicit, I've made the patch
explicitly set all scheduler modes, and included the defines for other
modes (in case someone feels frisky later).

The rest of the story gets a bit weird. The first version of the patch
showed an almost unbelievable performance improvement. Since rebasing my
branch it appears the performance improvement has gone, unfortunately.
But setting these bits seem to be the right thing to do given that the
docs describe corruption that can occur with the default settings.

In summary, I am seeing no more perf improvements (or regressions) in my
limited testing, but we believe this should be set to prevent rendering
corruption, therefore cc stable.

v1: Clear bit 4 also (Ken + Eugeni)
Do a full clear + set of the bits we want (Me).

Cc: Bernard Kilarski <bernard.r.kilarski@intel.com>
Reviewed-by (RFC): Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Ben Widawsky <benjamin.widawsky@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |   15 +++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |   14 ++++++++++++++
 2 files changed, 29 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -615,6 +615,21 @@
 
 #define GEN6_BSD_RNCID			0x12198
 
+#define GEN7_FF_THREAD_MODE		0x20a0
+#define   GEN7_FF_SCHED_MASK		0x0077070
+#define   GEN7_FF_TS_SCHED_HS1		(0x5<<16)
+#define   GEN7_FF_TS_SCHED_HS0		(0x3<<16)
+#define   GEN7_FF_TS_SCHED_LOAD_BALANCE	(0x1<<16)
+#define   GEN7_FF_TS_SCHED_HW		(0x0<<16) /* Default */
+#define   GEN7_FF_VS_SCHED_HS1		(0x5<<12)
+#define   GEN7_FF_VS_SCHED_HS0		(0x3<<12)
+#define   GEN7_FF_VS_SCHED_LOAD_BALANCE	(0x1<<12) /* Default */
+#define   GEN7_FF_VS_SCHED_HW		(0x0<<12)
+#define   GEN7_FF_DS_SCHED_HS1		(0x5<<4)
+#define   GEN7_FF_DS_SCHED_HS0		(0x3<<4)
+#define   GEN7_FF_DS_SCHED_LOAD_BALANCE	(0x1<<4)  /* Default */
+#define   GEN7_FF_DS_SCHED_HW		(0x0<<4)
+
 /*
  * Framebuffer compression (915+ only)
  */
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8612,6 +8612,18 @@ static void gen6_init_clock_gating(struc
 	}
 }
 
+static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)
+{
+	uint32_t reg = I915_READ(GEN7_FF_THREAD_MODE);
+
+	reg &= ~GEN7_FF_SCHED_MASK;
+	reg |= GEN7_FF_TS_SCHED_HW;
+	reg |= GEN7_FF_VS_SCHED_HW;
+	reg |= GEN7_FF_DS_SCHED_HW;
+
+	I915_WRITE(GEN7_FF_THREAD_MODE, reg);
+}
+
 static void ivybridge_init_clock_gating(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -8656,6 +8668,8 @@ static void ivybridge_init_clock_gating(
 			   DISPPLANE_TRICKLE_FEED_DISABLE);
 		intel_flush_display_plane(dev_priv, pipe);
 	}
+
+	gen7_setup_fixed_func_scheduler(dev_priv);
 }
 
 static void g4x_init_clock_gating(struct drm_device *dev)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2E1Dg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab2E1D3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:45 -0400
Message-Id: <20120528031215.017823881@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Bernard Kilarski <bernard.r.kilarski@intel.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 088/117] drm/i915: [GEN7] Use HW scheduler for fixed function shaders
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h      |   15 +++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |   14 ++++++++++++++
 2 files changed, 29 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -570,6 +570,21 @@
 
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
@@ -8245,6 +8245,18 @@
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
@@ -8285,6 +8297,8 @@
 			   DISPPLANE_TRICKLE_FEED_DISABLE);
 		intel_flush_display_plane(dev_priv, pipe);
 	}
+
+	gen7_setup_fixed_func_scheduler(dev_priv);
 }
 
 static void g4x_init_clock_gating(struct drm_device *dev)



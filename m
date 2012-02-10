Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2BJWr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:47:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65316 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087Ab2BJWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:35 -0500
MIME-Version: 1.0
Message-Id: <20120210223442.735734708@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [patch 28/55] drm/i915: check ACTHD of all rings
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 097354eb14fa94d31a09c64d640643f58e4a5a9a upstream.

Otherwise hangcheck spuriously fires when running blitter/bsd-only
workloads.

Contrary to a similar patch by Ben Widawsky this does not check
INSTDONE of the other rings. Chris Wilson implied that in a failure to
detect a hang, most likely because INSTDONE was fluctuating. Thus only
check ACTHD, which as far as I know is rather reliable. Also, blitter
and bsd rings can't launch complex tasks from a single instruction
(like 3D_PRIM on the render with complex or even infinite shaders).

This fixes spurious gpu hang detection when running
tests/gem_hangcheck_forcewake on snb/ivb.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/i915_drv.h |    2 ++
 drivers/gpu/drm/i915/i915_irq.c |   13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -325,6 +325,8 @@ typedef struct drm_i915_private {
 	struct timer_list hangcheck_timer;
 	int hangcheck_count;
 	uint32_t last_acthd;
+	uint32_t last_acthd_bsd;
+	uint32_t last_acthd_blt;
 	uint32_t last_instdone;
 	uint32_t last_instdone1;
 
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1665,7 +1665,7 @@ void i915_hangcheck_elapsed(unsigned lon
 {
 	struct drm_device *dev = (struct drm_device *)data;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	uint32_t acthd, instdone, instdone1;
+	uint32_t acthd, instdone, instdone1, acthd_bsd, acthd_blt;
 	bool err = false;
 
 	/* If all work is done then ACTHD clearly hasn't advanced. */
@@ -1679,16 +1679,21 @@ void i915_hangcheck_elapsed(unsigned lon
 	}
 
 	if (INTEL_INFO(dev)->gen < 4) {
-		acthd = I915_READ(ACTHD);
 		instdone = I915_READ(INSTDONE);
 		instdone1 = 0;
 	} else {
-		acthd = I915_READ(ACTHD_I965);
 		instdone = I915_READ(INSTDONE_I965);
 		instdone1 = I915_READ(INSTDONE1);
 	}
+	acthd = intel_ring_get_active_head(&dev_priv->ring[RCS]);
+	acthd_bsd = HAS_BSD(dev) ?
+		intel_ring_get_active_head(&dev_priv->ring[VCS]) : 0;
+	acthd_blt = HAS_BLT(dev) ?
+		intel_ring_get_active_head(&dev_priv->ring[BCS]) : 0;
 
 	if (dev_priv->last_acthd == acthd &&
+	    dev_priv->last_acthd_bsd == acthd_bsd &&
+	    dev_priv->last_acthd_blt == acthd_blt &&
 	    dev_priv->last_instdone == instdone &&
 	    dev_priv->last_instdone1 == instdone1) {
 		if (dev_priv->hangcheck_count++ > 1) {
@@ -1720,6 +1725,8 @@ void i915_hangcheck_elapsed(unsigned lon
 		dev_priv->hangcheck_count = 0;
 
 		dev_priv->last_acthd = acthd;
+		dev_priv->last_acthd_bsd = acthd_bsd;
+		dev_priv->last_acthd_blt = acthd_blt;
 		dev_priv->last_instdone = instdone;
 		dev_priv->last_instdone1 = instdone1;
 	}



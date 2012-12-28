Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2L1Tod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:44:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55216 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab2L1TSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:11 -0500
Message-Id: <20121228190355.404986151@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Runyan, Arthur J" <arthur.j.runyan@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 120/173] drm/i915: disable cpt phase pointer fdi rx workaround
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 539526b4137bc0e7a8806c38c8522f226814a0e6 upstream.

We've originally added this in

commit 291427f5fdadec6e4be2924172e83588880e1539
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Jul 29 12:42:37 2011 -0700

    drm/i915: apply phase pointer override on SNB+ too

and then copy-pasted it over to ivb/ppt. The w/a was originally added
for ilk/ibx in

commit 5b2adf897146edeac6a1e438fb67b5a53dbbdf34
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Oct 7 16:01:15 2010 -0700

    drm/i915: add Ironlake clock gating workaround for FDI link training

and fixed up a bit in

commit 6f06ce184c765fd8d50669a8d12fdd566c920859
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jan 4 15:09:38 2011 -0800

    drm/i915: set phase sync pointer override enable before setting phase sync pointer

It turns out that this w/a isn't actually required on cpt/ppt and
positively harmful on ivb/ppt when using fdi B/C links - it results in
a black screen occasionally, with seemingfully everything working as
it should. The only failure indication I've found in the hw is that
eventually (but not right after the modeset completes) a pipe underrun
is signalled.

Big thanks to Arthur Runyan for all the ideas for registers to check
and changes to test, otherwise I couldn't ever have tracked this down!

Cc: "Runyan, Arthur J" <arthur.j.runyan@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2384,18 +2384,6 @@ static void intel_fdi_normal_train(struc
 			   FDI_FE_ERRC_ENABLE);
 }
 
-static void cpt_phase_pointer_enable(struct drm_device *dev, int pipe)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 flags = I915_READ(SOUTH_CHICKEN1);
-
-	flags |= FDI_PHASE_SYNC_OVR(pipe);
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* once to unlock... */
-	flags |= FDI_PHASE_SYNC_EN(pipe);
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* then again to enable */
-	POSTING_READ(SOUTH_CHICKEN1);
-}
-
 /* The FDI link training functions for ILK/Ibexpeak. */
 static void ironlake_fdi_link_train(struct drm_crtc *crtc)
 {
@@ -2544,8 +2532,6 @@ static void gen6_fdi_link_train(struct d
 	POSTING_READ(reg);
 	udelay(150);
 
-	cpt_phase_pointer_enable(dev, pipe);
-
 	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
@@ -2664,8 +2650,6 @@ static void ivb_manual_fdi_link_train(st
 	POSTING_READ(reg);
 	udelay(150);
 
-	cpt_phase_pointer_enable(dev, pipe);
-
 	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
@@ -2775,17 +2759,6 @@ static void ironlake_fdi_pll_enable(stru
 	}
 }
 
-static void cpt_phase_pointer_disable(struct drm_device *dev, int pipe)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 flags = I915_READ(SOUTH_CHICKEN1);
-
-	flags &= ~(FDI_PHASE_SYNC_EN(pipe));
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* once to disable... */
-	flags &= ~(FDI_PHASE_SYNC_OVR(pipe));
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* then again to lock */
-	POSTING_READ(SOUTH_CHICKEN1);
-}
 static void ironlake_fdi_disable(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
@@ -2815,8 +2788,6 @@ static void ironlake_fdi_disable(struct
 		I915_WRITE(FDI_RX_CHICKEN(pipe),
 			   I915_READ(FDI_RX_CHICKEN(pipe) &
 				     ~FDI_RX_PHASE_SYNC_POINTER_EN));
-	} else if (HAS_PCH_CPT(dev)) {
-		cpt_phase_pointer_disable(dev, pipe);
 	}
 
 	/* still set train pattern 1 */



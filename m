Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2JNPEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:04:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46390 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab2JNOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:01 -0400
Message-Id: <20121014143547.157688566@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>
Subject: [ 099/147] drm/i915: call drm_handle_vblank before finish_page_flip
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 74d44445afb9f50126eba052adeb89827cee88f3 upstream.

... since finish_page_flip needs the vblank timestamp generated
in drm_handle_vblank. Somehow all the gmch platforms get it right,
but all the pch platform irq handlers get is wrong. Hooray for copy&
pasting!

Currently this gets papered over by a gross hack in finish_page_flip.
A second patch will remove that.

Note that without this, the new timestamp sanity checks in flip_test
occasionally get tripped up, hence the cc: stable tag.

Reviewed-by: mario.kleiner@tuebingen.mpg.de
Tested-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: no loop over pipes in ivybridge_irq_handler(),
 so make a similar change to that in ironlake_irq_handler()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -530,6 +530,12 @@ static irqreturn_t ivybridge_irq_handler
 	if (de_iir & DE_GSE_IVB)
 		intel_opregion_gse_intr(dev);
 
+	if (de_iir & DE_PIPEA_VBLANK_IVB)
+		drm_handle_vblank(dev, 0);
+
+	if (de_iir & DE_PIPEB_VBLANK_IVB)
+		drm_handle_vblank(dev, 1);
+
 	if (de_iir & DE_PLANEA_FLIP_DONE_IVB) {
 		intel_prepare_page_flip(dev, 0);
 		intel_finish_page_flip_plane(dev, 0);
@@ -540,12 +546,6 @@ static irqreturn_t ivybridge_irq_handler
 		intel_finish_page_flip_plane(dev, 1);
 	}
 
-	if (de_iir & DE_PIPEA_VBLANK_IVB)
-		drm_handle_vblank(dev, 0);
-
-	if (de_iir & DE_PIPEB_VBLANK_IVB)
-		drm_handle_vblank(dev, 1);
-
 	/* check event from PCH */
 	if (de_iir & DE_PCH_EVENT_IVB) {
 		if (pch_iir & SDE_HOTPLUG_MASK_CPT)
@@ -622,6 +622,12 @@ static irqreturn_t ironlake_irq_handler(
 	if (de_iir & DE_GSE)
 		intel_opregion_gse_intr(dev);
 
+	if (de_iir & DE_PIPEA_VBLANK)
+		drm_handle_vblank(dev, 0);
+
+	if (de_iir & DE_PIPEB_VBLANK)
+		drm_handle_vblank(dev, 1);
+
 	if (de_iir & DE_PLANEA_FLIP_DONE) {
 		intel_prepare_page_flip(dev, 0);
 		intel_finish_page_flip_plane(dev, 0);
@@ -632,12 +638,6 @@ static irqreturn_t ironlake_irq_handler(
 		intel_finish_page_flip_plane(dev, 1);
 	}
 
-	if (de_iir & DE_PIPEA_VBLANK)
-		drm_handle_vblank(dev, 0);
-
-	if (de_iir & DE_PIPEB_VBLANK)
-		drm_handle_vblank(dev, 1);
-
 	/* check event from PCH */
 	if (de_iir & DE_PCH_EVENT) {
 		if (pch_iir & hotplug_mask)



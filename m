Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab2JKAYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:24:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32790 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932917Ab2JKAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:20 -0400
X-Sasl-enc: RJs6QB7kDA8w8PF7UcYTCyHm4sblKZGl83IjrBcoUEFV 1349915058
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 085/122] drm/i915: call drm_handle_vblank before finish_page_flip
Date: Thu, 11 Oct 2012 07:54:11 +0900
Message-Id: <20121010225353.369675672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -680,12 +680,12 @@ static irqreturn_t ivybridge_irq_handler
 			intel_opregion_gse_intr(dev);
 
 		for (i = 0; i < 3; i++) {
+			if (de_iir & (DE_PIPEA_VBLANK_IVB << (5 * i)))
+				drm_handle_vblank(dev, i);
 			if (de_iir & (DE_PLANEA_FLIP_DONE_IVB << (5 * i))) {
 				intel_prepare_page_flip(dev, i);
 				intel_finish_page_flip_plane(dev, i);
 			}
-			if (de_iir & (DE_PIPEA_VBLANK_IVB << (5 * i)))
-				drm_handle_vblank(dev, i);
 		}
 
 		/* check event from PCH */
@@ -767,6 +767,12 @@ static irqreturn_t ironlake_irq_handler(
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
@@ -777,12 +783,6 @@ static irqreturn_t ironlake_irq_handler(
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



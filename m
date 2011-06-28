Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1F1WFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:05:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35050 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1F1WFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:05:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/29] gma500: Do sane FB cleanup
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:04:43 +0100
Message-ID: <20110628220441.898.94170.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

If we get a user frame buffer destroyed which is being displayed then clean
up the mess nicely. We can now run a slightly modified modetest including setting
modes, and handling crashes.

Modetest still blows up but this is because libdrm 2.4.25 is busted.


Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c            |   24 +++++++++++++++++++++++-
 drivers/staging/gma500/psb_intel_display.c |   22 +++++++++++++---------
 2 files changed, 36 insertions(+), 10 deletions(-)


diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 5977add..d005025 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -719,16 +719,38 @@ static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 {
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 	struct gtt_range *r = psbfb->gtt;
+	struct drm_device *dev = fb->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_fbdev *fbdev = dev_priv->fbdev;
+	struct drm_crtc *crtc;
+	int reset = 0;
 
 	/* Should never get stolen memory for a user fb */
 	WARN_ON(r->stolen);
 	pr_err("user framebuffer destroy %p, fbdev %p\n",
 						psbfb, psbfb->fbdev);
+	/* Check if we are erroneously live */
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
+		if (crtc->fb == fb)
+			reset = 1;
+
+	if (reset)
+		pr_err("DRM: gma500, forcing reset\n");
+
+	if (reset)
+		/* 
+		 * Now force a sane response before we permit the DRM crc layer to
+		 * do stupid things like blank the display. Instead we reset this
+		 * framebuffer as if the user had forced a reset. We must do this
+		 * before the cleanup so that the DRM layer doesn't get a chance
+		 * to stick its oar in where it isn't wanted.
+		 */
+		drm_fb_helper_restore_fbdev_mode(&fbdev->psb_fb_helper);
+
         /* Let DRM do its clean up */
 	drm_framebuffer_cleanup(fb);
 	/*  We are no longer using the resource in GEM */
 	drm_gem_object_unreference_unlocked(&r->gem);
-
 	kfree(fb);
 }
 
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index a99271d..c7c55b1 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -352,15 +352,15 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 
 	PSB_DEBUG_ENTRY("\n");
 
+	if (!gma_power_begin(dev, true))
+		return 0;
+
 	/* no fb bound */
 	if (!crtc->fb) {
 		DRM_DEBUG("No FB bound\n");
-		return 0;
+		goto psb_intel_pipe_cleaner;
 	}
 
-	if (!gma_power_begin(dev, true))
-		return 0;
-
 	/* We are displaying this buffer, make sure it is actually loaded
 	   into the GTT */
 	ret = psb_gtt_pin(psbfb->gtt);
@@ -409,6 +409,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 		REG_READ(dspbase);
 	}
 
+psb_intel_pipe_cleaner:
 	/* If there was a previous display we can now unpin it */
 	if (old_fb)
 		psb_gtt_unpin(to_psb_fb(old_fb)->gtt);
@@ -588,6 +589,7 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
 	int pipe = psb_intel_crtc->pipe;
 	int fp_reg = (pipe == 0) ? FPA0 : FPB0;
 	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
@@ -610,6 +612,12 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct drm_connector *connector;
 
+	/* No scan out no play */
+	if (crtc->fb == NULL) {
+	        crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+                return 0;
+        }
+
 	list_for_each_entry(connector, &mode_config->connector_list, head) {
 		struct psb_intel_output *psb_intel_output =
 		    to_psb_intel_output(connector);
@@ -786,11 +794,7 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 	REG_WRITE(dspcntr_reg, dspcntr);
 
 	/* Flush the plane changes */
-	{
-		struct drm_crtc_helper_funcs *crtc_funcs =
-		    crtc->helper_private;
-		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
-	}
+	crtc_funcs->mode_set_base(crtc, x, y, old_fb);
 
 	psb_intel_wait_for_vblank(dev);
 


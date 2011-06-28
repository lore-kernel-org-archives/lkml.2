Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1F1WJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:09:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41023 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1F1WJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:09:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/29] gma500: enable Medfield CRTC support
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:09:22 +0100
Message-ID: <20110628220920.898.39482.stgit@bob.linux.org.uk>
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

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_intel_display.c |   33 ++++++++++++++++++++++++--
 drivers/staging/gma500/mdfld_output.h        |    3 ++
 drivers/staging/gma500/mrst_bios.c           |    2 +-
 drivers/staging/gma500/psb_intel_display.c   |    9 +++----
 4 files changed, 38 insertions(+), 9 deletions(-)


diff --git a/drivers/staging/gma500/mdfld_intel_display.c b/drivers/staging/gma500/mdfld_intel_display.c
index 26d7f80..0b619b6 100644
--- a/drivers/staging/gma500/mdfld_intel_display.c
+++ b/drivers/staging/gma500/mdfld_intel_display.c
@@ -44,7 +44,6 @@
 /* Hardcoded currently */
 static int ksel = KSEL_CRYSTAL_19;
 
-extern struct drm_device *gpDrmDevice;
 extern void mdfld_save_display(struct drm_device *dev);
 extern bool gbgfxsuspended;
 
@@ -561,10 +560,10 @@ static void mdfld_crtc_dpms(struct drm_crtc *crtc, int mode)
 		return;
 
 	 /* Ignore if system is already in DSR and in suspended state. */
-	if(gbgfxsuspended && dev_priv->dispstatus == false && mode == 3){
+	if(/*gbgfxsuspended */0 && dev_priv->dispstatus == false && mode == 3){
 	    if(dev_priv->rpm_enabled && pipe == 1){
 	//          dev_priv->is_mipi_on = false;
-	            pm_request_idle(&gpDrmDevice->pdev->dev);
+	          pm_request_idle(&dev->pdev->dev);
 	    }
 	    return;
 	}else if(mode == 0) {
@@ -1386,3 +1385,31 @@ mrst_crtc_mode_set_exit:
 
 	return 0;
 }
+
+static void mdfld_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+}
+
+static void mdfld_crtc_commit(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_ON);
+}
+
+static bool mdfld_crtc_mode_fixup(struct drm_crtc *crtc,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+const struct drm_crtc_helper_funcs mdfld_helper_funcs = {
+	.dpms = mdfld_crtc_dpms,
+	.mode_fixup = mdfld_crtc_mode_fixup,
+	.mode_set = mdfld_crtc_mode_set,
+	.mode_set_base = mdfld__intel_pipe_set_base,
+	.prepare = mdfld_crtc_prepare,
+	.commit = mdfld_crtc_commit,
+};
diff --git a/drivers/staging/gma500/mdfld_output.h b/drivers/staging/gma500/mdfld_output.h
index 53b57db..70f2302a 100644
--- a/drivers/staging/gma500/mdfld_output.h
+++ b/drivers/staging/gma500/mdfld_output.h
@@ -74,4 +74,7 @@ int mdfld_panel_dpi(struct drm_device *dev);
 int mdfld_get_panel_type(struct drm_device *dev, int pipe);
 void mdfld_disable_crtc (struct drm_device *dev, int pipe);
 
+extern const struct drm_crtc_helper_funcs mdfld_helper_funcs;
+extern const struct drm_crtc_funcs mdfld_intel_crtc_funcs;
+
 #endif
diff --git a/drivers/staging/gma500/mrst_bios.c b/drivers/staging/gma500/mrst_bios.c
index a90fe92..c3707f4 100644
--- a/drivers/staging/gma500/mrst_bios.c
+++ b/drivers/staging/gma500/mrst_bios.c
@@ -237,7 +237,7 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 		dev_err(dev->dev, "Unknown revision of GCT!\n");
 		vbt->size = 0;
 	}
-	if (IS_MDFLD(dev_priv->dev)){
+	if (IS_MFLD(dev_priv->dev)){
 		if (panel_id == GCT_DETECT) {
 			if (dev_priv->gct_data.bpi == 2) {
 				dev_info(dev->dev, "[GFX] PYR Panel Detected\n");
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index ac0d9da..907c68e 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -29,6 +29,7 @@
 #include "psb_intel_display.h"
 #include "psb_powermgmt.h"
 
+#include "mdfld_output.h"
 
 struct psb_intel_clock_t {
 	/* given values */
@@ -1303,12 +1304,10 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 		return;
 	}
 
-#if 0	/* FIXME */
 	if (IS_MFLD(dev))
 		drm_crtc_init(dev, &psb_intel_crtc->base,
-						&mfld_intel_crtc_funcs);
+						&mdfld_intel_crtc_funcs);
 	else
-#endif
         	drm_crtc_init(dev, &psb_intel_crtc->base,
 						&psb_intel_crtc_funcs);
 
@@ -1336,9 +1335,9 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	if (IS_MRST(dev))
 		drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &mrst_helper_funcs);
-/*	else if (IS_MDFLD(dev))
+	else if (IS_MFLD(dev))
 		drm_crtc_helper_add(&psb_intel_crtc->base,
-				    &mfld_helper_funcs); */
+				    &mdfld_helper_funcs);
 	else
 		drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &psb_intel_helper_funcs);


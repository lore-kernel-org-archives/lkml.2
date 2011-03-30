Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1C3JRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:17:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51153 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932124Ab1C3JRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:17:51 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 01/18] gma500: begin adding Moorestown support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 09:59:08 +0100
Message-ID: <20110330085903.5897.78910.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Moorestown systems have some graphics differences we care about and some
we don't need to.

To start with it has a single pipe and that pipe can be used for LVDS



Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c           |    6 ++++--
 drivers/staging/gma500/psb_drv.h           |    6 ++----
 drivers/staging/gma500/psb_fb.c            |    6 +++++-
 drivers/staging/gma500/psb_intel_display.c |    4 +++-
 drivers/staging/gma500/psb_intel_lvds.c    |    8 ++++++--
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 44cd095..a7391c5 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -586,8 +586,10 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&dev_priv->video_ctx);
 
-	dev_priv->num_pipe = 2;
-
+	if (IS_MRST(dev))
+		dev_priv->num_pipe = 1;
+	else
+		dev_priv->num_pipe = 2;
 
 	dev_priv->dev = dev;
 	bdev = &dev_priv->bdev;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 29a3605..e7507b1 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -45,6 +45,8 @@ enum {
 	CHIP_PSB_8109 = 1,
 };
 
+#define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
+
 /*
  *Hardware bugfixes
  */
@@ -52,10 +54,6 @@ enum {
 #define DRIVER_NAME "pvrsrvkm"
 #define DRIVER_DESC "drm driver for the Intel GMA500"
 #define DRIVER_AUTHOR "Intel Corporation"
-#define OSPM_PROC_ENTRY "ospm"
-#define RTPM_PROC_ENTRY "rtpm"
-#define BLC_PROC_ENTRY "mrst_blc"
-#define DISPLAY_PROC_ENTRY "display_status"
 
 #define PSB_DRM_DRIVER_DATE "2009-03-10"
 #define PSB_DRM_DRIVER_MAJOR 8
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index f67f53b..4e5d8a6 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -716,7 +716,11 @@ static void psb_setup_outputs(struct drm_device *dev)
 			break;
 		case INTEL_OUTPUT_LVDS:
 			PSB_DEBUG_ENTRY("LVDS.\n");
-			crtc_mask = (1 << 1);
+			if (IS_MRST(dev))
+			        crtc_mask = (1 << 0);
+                        else
+        			crtc_mask = (1 << 1);
+
 			clone_mask = (1 << INTEL_OUTPUT_LVDS);
 			break;
 		case INTEL_OUTPUT_MIPI:
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 80b37f4..917d37e 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -569,7 +569,9 @@ static int psb_intel_panel_fitter_pipe(struct drm_device *dev)
 	if ((pfit_control & PFIT_ENABLE) == 0)
 		return -1;
 	/* Must be on PIPE 1 for PSB */
-	return 1;
+	if (!IS_MRST(dev))
+		return 1;
+	return (pfit_control >> 29) & 3;
 }
 
 static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index d3d210a..2de0524 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -400,11 +400,15 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
 		panel_fixed_mode = mode_dev->panel_fixed_mode2;
 
-	/* PSB doesn't appear to be GEN4 */
-	if (psb_intel_crtc->pipe == 0) {
+	/* PSB requires the LVDS is on pipe B, MRST has only one pipe anyway */
+	if (!IS_MRST(dev) && psb_intel_crtc->pipe == 0) {
 		printk(KERN_ERR "Can't support LVDS on pipe A\n");
 		return false;
 	}
+	if (IS_MRST(dev) && psb_intel_crtc->pipe != 0) {
+		printk(KERN_ERR "Must use PIPE A\n");
+		return false;
+	}
 	/* Should never happen!! */
 	list_for_each_entry(tmp_encoder, &dev->mode_config.encoder_list,
 			    head) {


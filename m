Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1EKUqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:46:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44299 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab1EKUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BVgRy/qmSkzFdqbu/dY0f4co/1n/O3JcLoGFYpdoFjqfZLl31aCuybKKPzWR8kfMiU
         yxOrvMUeL/0vIIAR4mmXuOVsQBRaJvy/NVgdNjJyZkYp0BtS/FTm7/oTjDsHbu1Z57ZG
         AjSjda6U9rSQWaGRrktU2H7Z6VCPDTETzJnLg=
Date: Wed, 11 May 2011 22:46:09 +0200
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@linux.intel.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS before
 adding backlight (try 2)
Message-ID: <20110511204609.GA6059@patrik-macbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Fit-PC2 the VBT reports an invalid fixed panel mode for LVDS, this gets
in the way for SDVO. This patch makes VBT parsing skip the invalid mode. When
there is no LVDS output the backlight support crashes so the patch also checks
for this before enabling it.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 46ab028..dbc6e4f 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -542,6 +542,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	unsigned long irqflags;
 	int ret = -ENOMEM;
 	uint32_t tt_pages;
+	struct drm_connector *connector;
+	struct psb_intel_output *psb_intel_output;
 
 	dev_priv = kzalloc(sizeof(*dev_priv), GFP_KERNEL);
 	if (dev_priv == NULL)
@@ -663,7 +665,21 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		drm_kms_helper_poll_init(dev);
 	}
 
-	ret = psb_backlight_init(dev);
+	/* Only add backlight support if we have LVDS output
+	 *
+	 * FIXME: Handle turning on LVDS at runtime
+	 */
+	list_for_each_entry(connector, &dev->mode_config.connector_list,
+			    head) {
+		psb_intel_output = to_psb_intel_output(connector);
+
+		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_LVDS:
+			ret = psb_backlight_init(dev);
+			break;
+		}
+	}
+
 	if (ret)
 		return ret;
 #if 0
diff --git a/drivers/staging/gma500/psb_intel_bios.c b/drivers/staging/gma500/psb_intel_bios.c
index 48ac8ba..417965d 100644
--- a/drivers/staging/gma500/psb_intel_bios.c
+++ b/drivers/staging/gma500/psb_intel_bios.c
@@ -154,10 +154,15 @@ static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
 
 	fill_detail_timing_data(panel_fixed_mode, dvo_timing);
 
-	dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
-
-	DRM_DEBUG("Found panel mode in BIOS VBT tables:\n");
-	drm_mode_debug_printmodeline(panel_fixed_mode);
+	if (panel_fixed_mode->htotal > 0 && panel_fixed_mode->vtotal > 0) {
+		dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
+		DRM_DEBUG("Found panel mode in BIOS VBT tables:\n");
+		drm_mode_debug_printmodeline(panel_fixed_mode);
+	} else {
+		DRM_DEBUG("Ignoring bogus LVDS VBT mode.\n");
+		dev_priv->lvds_vbt = 0;
+		kfree(panel_fixed_mode);
+	}
 
 	return;
 }

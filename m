Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1FHKXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:23:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60865 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1FHKXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:23:47 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/15] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight
To: greg@kroah.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 08 Jun 2011 11:11:28 +0100
Message-ID: <20110608101121.9478.64934.stgit@localhost.localdomain>
In-Reply-To: <20110608100411.9478.86672.stgit@localhost.localdomain>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

On the Fit-PC2 the VBT reports an invalid fixed panel mode for LVDS, this gets
in the way for SDVO. This patch makes VBT parsing skip the invalid mode. When
there is no LVDS output the backlight support crashes so the patch also checks
for this before enabling it.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c        |   15 ++++++++++++++-
 drivers/staging/gma500/psb_intel_bios.c |   13 +++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 1c45c11..aa87b1b 100644
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
@@ -663,7 +665,18 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		drm_kms_helper_poll_init(dev);
 	}
 
-	ret = psb_backlight_init(dev);
+	/* Only add backlight support if we have LVDS output */
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


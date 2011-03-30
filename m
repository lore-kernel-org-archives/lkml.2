Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1C3JS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:18:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51181 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932274Ab1C3JS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:18:56 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 08/18] gma500: add framebuffer setup
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:00:13 +0100
Message-ID: <20110330090011.5897.68941.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Moorestown we want to use the mrst LVDS setup not the Poulsbo setup

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 4e5d8a6..53a270e 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -698,8 +698,16 @@ static void psb_setup_outputs(struct drm_device *dev)
 
 	psb_create_backlight_property(dev);
 
-	psb_intel_lvds_init(dev, &dev_priv->mode_dev);
-	/* psb_intel_sdvo_init(dev, SDVOB); */
+	if (IS_MRST(dev)) {
+		if (dev_priv->iLVDS_enable)
+			mrst_lvds_init(dev, &dev_priv->mode_dev);
+		else
+			DRM_ERROR("DSI is not supported\n");
+	} else {
+		/* FIXME: check if SDVO init should be re-enabled */
+		psb_intel_lvds_init(dev, &dev_priv->mode_dev);
+		/* psb_intel_sdvo_init(dev, SDVOB); */
+	}
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list,
 			    head) {
@@ -717,10 +725,9 @@ static void psb_setup_outputs(struct drm_device *dev)
 		case INTEL_OUTPUT_LVDS:
 			PSB_DEBUG_ENTRY("LVDS.\n");
 			if (IS_MRST(dev))
-			        crtc_mask = (1 << 0);
-                        else
-        			crtc_mask = (1 << 1);
-
+				crtc_mask = (1 << 0);
+			else
+				crtc_mask = (1 << 1);
 			clone_mask = (1 << INTEL_OUTPUT_LVDS);
 			break;
 		case INTEL_OUTPUT_MIPI:


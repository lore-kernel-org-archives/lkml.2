Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab1GKSuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:50:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58563 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1GKSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:50:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/4] gma500: Sort out dither
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 11 Jul 2011 19:41:09 +0100
Message-ID: <20110711184044.8996.80880.stgit@localhost.localdomain>
In-Reply-To: <20110711183933.8996.37507.stgit@localhost.localdomain>
References: <20110711183933.8996.37507.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Ubuntu users reported that dithering was not being set on Poulsbo, and they
have a point as we set one variable and check another which is never set.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Tested-by: Luca Forina <luca.forina@gmail.com>
---

 drivers/staging/gma500/cdv_intel_lvds.c |    3 ++-
 drivers/staging/gma500/mrst_lvds.c      |    5 ++++-
 drivers/staging/gma500/psb_intel_lvds.c |    3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gma500/cdv_intel_lvds.c b/drivers/staging/gma500/cdv_intel_lvds.c
index 19ad9bb..d9478d5 100644
--- a/drivers/staging/gma500/cdv_intel_lvds.c
+++ b/drivers/staging/gma500/cdv_intel_lvds.c
@@ -356,6 +356,7 @@ static void cdv_intel_lvds_mode_set(struct drm_encoder *encoder,
 	struct psb_intel_mode_device *mode_dev =
 	    enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 pfit_control;
 
 	/*
@@ -377,7 +378,7 @@ static void cdv_intel_lvds_mode_set(struct drm_encoder *encoder,
 	else
 		pfit_control = 0;
 
-	if (mode_dev->panel_wants_dither)
+	if (dev_priv->lvds_dither)
 		pfit_control |= PANEL_8TO6_DITHER_ENABLE;
 
 	REG_WRITE(PFIT_CONTROL, pfit_control);
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 127b200..3e15ecd 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -91,6 +91,7 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 	struct psb_intel_mode_device *mode_dev =
 				enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 lvds_port;
 	uint64_t v = DRM_MODE_SCALE_FULLSCREEN;
 
@@ -107,7 +108,9 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 		    LVDS_PORT_EN |
 		    LVDS_BORDER_EN;
 
-	if (mode_dev->panel_wants_dither)
+	/* If the firmware says dither on Moorestown, or the BIOS does
+	   on Oaktrail then enable dithering */
+	if (mode_dev->panel_wants_dither || dev_priv->lvds_dither)
 		lvds_port |= MRST_PANEL_8TO6_DITHER_ENABLE;
 
 	REG_WRITE(LVDS, lvds_port);
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index c4111b5..03132a4 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -470,6 +470,7 @@ static void psb_intel_lvds_mode_set(struct drm_encoder *encoder,
 	struct psb_intel_mode_device *mode_dev =
 	    enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 pfit_control;
 
 	/*
@@ -491,7 +492,7 @@ static void psb_intel_lvds_mode_set(struct drm_encoder *encoder,
 	else
 		pfit_control = 0;
 
-	if (mode_dev->panel_wants_dither)
+	if (dev_priv->lvds_dither)
 		pfit_control |= PANEL_8TO6_DITHER_ENABLE;
 
 	REG_WRITE(PFIT_CONTROL, pfit_control);


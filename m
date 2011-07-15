Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1GOQoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:44:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35837 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1GOQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:44:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/15] gma500: Use the mrst helpers and power control for mode
 commit
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:35:24 +0100
Message-ID: <20110715163522.28759.75067.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We want to hit the MM panel backlight when appropriate

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_lvds.c      |   29 +++++++++++++++++++++++++++--
 drivers/staging/gma500/psb_drv.h        |    2 --
 drivers/staging/gma500/psb_intel_lvds.c |    4 ++--
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 108f245..25fde4c 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -147,13 +147,38 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 	gma_power_end(dev);
 }
 
+static void mrst_lvds_prepare(struct drm_encoder *encoder)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+
+	if (!gma_power_begin(dev, true))
+		return;
+
+	mode_dev->saveBLC_PWM_CTL = REG_READ(BLC_PWM_CTL);
+	mode_dev->backlight_duty_cycle = (mode_dev->saveBLC_PWM_CTL &
+					  BACKLIGHT_DUTY_CYCLE_MASK);
+	mrst_lvds_set_power(dev, output, false);
+	gma_power_end(dev);
+}
+
+static void mrst_lvds_commit(struct drm_encoder *encoder)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+
+	if (mode_dev->backlight_duty_cycle == 0)
+		mode_dev->backlight_duty_cycle =
+		    psb_intel_lvds_get_max_backlight(dev);
+	mrst_lvds_set_power(dev, output, true);
+}
 
 static const struct drm_encoder_helper_funcs mrst_lvds_helper_funcs = {
 	.dpms = mrst_lvds_dpms,
 	.mode_fixup = psb_intel_lvds_mode_fixup,
-	.prepare = psb_intel_lvds_prepare,
+	.prepare = mrst_intel_lvds_prepare,
 	.mode_set = mrst_lvds_mode_set,
-	.commit = psb_intel_lvds_commit,
+	.commit = mrst_intel_lvds_commit,
 };
 
 static struct drm_display_mode lvds_configuration_modes[] = {
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 829657b..194c64f 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -792,8 +792,6 @@ extern const struct drm_crtc_helper_funcs psb_intel_helper_funcs;
 extern const struct drm_crtc_funcs psb_intel_crtc_funcs;
 
 /* psb_intel_lvds.c */
-extern void psb_intel_lvds_prepare(struct drm_encoder *encoder);
-extern void psb_intel_lvds_commit(struct drm_encoder *encoder);
 extern const struct drm_connector_helper_funcs
 					psb_intel_lvds_connector_helper_funcs;
 extern const struct drm_connector_funcs psb_intel_lvds_connector_funcs;
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 53803b2..c6436da 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -432,7 +432,7 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	return true;
 }
 
-void psb_intel_lvds_prepare(struct drm_encoder *encoder)
+static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
@@ -450,7 +450,7 @@ void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 	gma_power_end(dev);
 }
 
-void psb_intel_lvds_commit(struct drm_encoder *encoder)
+static void psb_intel_lvds_commit(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);


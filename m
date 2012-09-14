Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2INM5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:57:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50961 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2INM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:57:14 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] i915: Quirk out disconnected backlight
Date: Fri, 14 Sep 2012 13:57:06 +0100
Message-Id: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms (for instance MacbookPros) have custom backlight drivers
and don't use the integrated i915 backlight control. This patch adds a
quirk to disable registering the intel backlight when unused on a
platform.

Tested on MacbookPro8,3. Without this patch both the intel_backlight and
gmux_backlight devices get registered and userspace doesn't know which
it should use.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   10 ++++++++++
 drivers/gpu/drm/i915/intel_panel.c   |    3 +++
 3 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 627fe35..48860a0 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -349,6 +349,7 @@ enum intel_pch {
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
 #define QUIRK_INVERT_BRIGHTNESS (1<<2)
+#define QUIRK_NO_BACKLIGHT (2<<2)
 
 struct intel_fbdev;
 struct intel_fbc_work;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2dfa6cf..c8153cd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7088,6 +7088,13 @@ static void quirk_invert_brightness(struct drm_device *dev)
 	DRM_INFO("applying inverted panel brightness quirk\n");
 }
 
+static void quirk_no_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	dev_priv->quirks |= QUIRK_NO_BACKLIGHT;
+	DRM_INFO("applying no backlight quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -7123,6 +7130,9 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer Aspire 5734Z must invert backlight brightness */
 	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
+
+	/* Apple MacbookPro8,3 doesn't have a backlight */
+	{ 0x0126, 0x106b, 0x00de, quirk_no_backlight },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 3df4f5f..f116e2a 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -413,6 +413,9 @@ int intel_panel_setup_backlight(struct drm_device *dev)
 	struct backlight_properties props;
 	struct drm_connector *connector;
 
+	if (dev_priv->quirks & QUIRK_NO_BACKLIGHT)
+		return 0;
+
 	intel_panel_init_backlight(dev);
 
 	if (dev_priv->int_lvds_connector)
-- 
1.7.9.5


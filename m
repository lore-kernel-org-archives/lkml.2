Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2HCQCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:02:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2HCQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:02:38 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 5/5] drm/i915: check LVDS for EDID on GPU switches
Date: Fri,  3 Aug 2012 11:02:21 -0500
Message-Id: <1344009741-14248-6-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the LVDS panel wasn't connected at boot then we won't have an EDID
for it. To fix this, call intel_lvds_get_edid() from the vga_switcheroo
reprobe callback.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c   |    1 +
 drivers/gpu/drm/i915/intel_drv.h  |    1 +
 drivers/gpu/drm/i915/intel_lvds.c |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 5b5176d..c9c942e 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1266,6 +1266,7 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 static void i915_switcheroo_reprobe(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
+	intel_lvds_get_edid(dev);
 	intel_fb_output_poll_changed(dev);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 8435355..bcc14f9 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -356,6 +356,7 @@ extern void intel_dvo_init(struct drm_device *dev);
 extern void intel_tv_init(struct drm_device *dev);
 extern void intel_mark_busy(struct drm_device *dev,
 			    struct drm_i915_gem_object *obj);
+extern bool intel_lvds_get_edid(struct drm_device *dev);
 extern bool intel_lvds_init(struct drm_device *dev);
 extern void intel_dp_init(struct drm_device *dev, int dp_reg);
 void
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 9d05a90..39dbefc 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -902,7 +902,7 @@ static bool intel_lvds_supported(struct drm_device *dev)
 	return IS_MOBILE(dev) && !IS_I830(dev);
 }
 
-static bool intel_lvds_get_edid(struct drm_device *dev)
+bool intel_lvds_get_edid(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_connector *connector = dev_priv->int_lvds_connector;
-- 
1.7.9.5


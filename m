Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1BJKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:16:27 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:53919
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755787Ab1BJKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:16:25 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@kernel.org
Subject: [PATCH] drm/i915/tv: Use polling rather than interrupt-based hotplug
Date: Thu, 10 Feb 2011 10:16:06 +0000
Message-Id: <1297332966-17647-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <alpine.LSU.2.00.1102081132160.1591@sister.anvils>
References: <alpine.LSU.2.00.1102081132160.1591@sister.anvils>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation recommends that we should use a polling method for TV
detection as this is more power efficient than the interrupt based
mechanism (as the encoder can be completely switched off). A secondary
effect is that leaving the hotplug enabled seems to be causing pipe
underruns as reported by Hugh Dickins on his Crestline.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@kernel.org
---

Hugh, does this prevent the persistent PIPE UNDERRUN issue?

---
 drivers/gpu/drm/i915/intel_tv.c |   43 +++++++++++++++++++++++++++-----------
 1 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 93206e4..fe4a53a 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1234,7 +1234,8 @@ static const struct drm_display_mode reported_modes[] = {
  * \return false if TV is disconnected.
  */
 static int
-intel_tv_detect_type (struct intel_tv *intel_tv)
+intel_tv_detect_type (struct intel_tv *intel_tv,
+		      struct drm_connector *connector)
 {
 	struct drm_encoder *encoder = &intel_tv->base.base;
 	struct drm_device *dev = encoder->dev;
@@ -1245,11 +1246,13 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 	int type;
 
 	/* Disable TV interrupts around load detect or we'll recurse */
-	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
-	i915_disable_pipestat(dev_priv, 0,
-			      PIPE_HOTPLUG_INTERRUPT_ENABLE |
-			      PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
-	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
+	if (connector->polled & DRM_CONNECTOR_POLL_HPD) {
+		spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
+		i915_disable_pipestat(dev_priv, 0,
+				      PIPE_HOTPLUG_INTERRUPT_ENABLE |
+				      PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
+		spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
+	}
 
 	save_tv_dac = tv_dac = I915_READ(TV_DAC);
 	save_tv_ctl = tv_ctl = I915_READ(TV_CTL);
@@ -1302,11 +1305,13 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 	I915_WRITE(TV_CTL, save_tv_ctl);
 
 	/* Restore interrupt config */
-	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
-	i915_enable_pipestat(dev_priv, 0,
-			     PIPE_HOTPLUG_INTERRUPT_ENABLE |
-			     PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
-	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
+	if (connector->polled & DRM_CONNECTOR_POLL_HPD) {
+		spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
+		i915_enable_pipestat(dev_priv, 0,
+				     PIPE_HOTPLUG_INTERRUPT_ENABLE |
+				     PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
+		spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
+	}
 
 	return type;
 }
@@ -1356,7 +1361,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 	drm_mode_set_crtcinfo(&mode, CRTC_INTERLACE_HALVE_V);
 
 	if (intel_tv->base.base.crtc && intel_tv->base.base.crtc->enabled) {
-		type = intel_tv_detect_type(intel_tv);
+		type = intel_tv_detect_type(intel_tv, connector);
 	} else if (force) {
 		struct drm_crtc *crtc;
 		int dpms_mode;
@@ -1364,7 +1369,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 		crtc = intel_get_load_detect_pipe(&intel_tv->base, connector,
 						  &mode, &dpms_mode);
 		if (crtc) {
-			type = intel_tv_detect_type(intel_tv);
+			type = intel_tv_detect_type(intel_tv, connector);
 			intel_release_load_detect_pipe(&intel_tv->base, connector,
 						       dpms_mode);
 		} else
@@ -1658,6 +1663,18 @@ intel_tv_init(struct drm_device *dev)
 	intel_encoder = &intel_tv->base;
 	connector = &intel_connector->base;
 
+	/* The documentation, for the older chipsets at least, recommend
+	 * using a polling method rather than hotplug detection for TVs.
+	 * This is because in order to perform the hotplug detection, the PLLs
+	 * for the TV must be kept alive increasing power drain and starving
+	 * bandwidth from other encoders. Notably for instance, it causes
+	 * pipe underruns on Crestline when this encoder is supposedly idle.
+	 *
+	 * More recent chipsets favour HDMI rather than integrated S-Video.
+	 */
+	connector->polled =
+		DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;
+
 	drm_connector_init(dev, connector, &intel_tv_connector_funcs,
 			   DRM_MODE_CONNECTOR_SVIDEO);
 
-- 
1.7.2.3


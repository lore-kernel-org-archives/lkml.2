Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab0G3SDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:03:38 -0400
Received: from kroah.org ([198.145.64.141]:59333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771Ab0G3R6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175152.416558813@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [204/205] drm/i915: make sure eDP panel is turned on
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 9934c132989d5c488d2e15188220ce240960ce96 upstream.

When enabling the eDP port, we need to make sure the panel is turned on
after training the link.  If we don't, it likely won't come back after
suspend or may not come up at all.

For unknown reasons, unlocking the panel regs before initiating a power
on sequence is necessary.  There are known bugs in the PCH panel
sequencing logic, apparently this is one possible workaround.

Fixes https://bugs.freedesktop.org/show_bug.cgi?id=28739.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: "Paulo J. S. Silva" <pjssilva@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |   53 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -677,6 +677,51 @@ intel_dp_mode_set(struct drm_encoder *en
 	}
 }
 
+static void ironlake_edp_panel_on (struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long timeout = jiffies + msecs_to_jiffies(5000);
+	u32 pp, pp_status;
+
+	pp_status = I915_READ(PCH_PP_STATUS);
+	if (pp_status & PP_ON)
+		return;
+
+	pp = I915_READ(PCH_PP_CONTROL);
+	pp |= PANEL_UNLOCK_REGS | POWER_TARGET_ON;
+	I915_WRITE(PCH_PP_CONTROL, pp);
+	do {
+		pp_status = I915_READ(PCH_PP_STATUS);
+	} while (((pp_status & PP_ON) == 0) && !time_after(jiffies, timeout));
+
+	if (time_after(jiffies, timeout))
+		DRM_DEBUG_KMS("panel on wait timed out: 0x%08x\n", pp_status);
+
+	pp &= ~(PANEL_UNLOCK_REGS | EDP_FORCE_VDD);
+	I915_WRITE(PCH_PP_CONTROL, pp);
+}
+
+static void ironlake_edp_panel_off (struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long timeout = jiffies + msecs_to_jiffies(5000);
+	u32 pp, pp_status;
+
+	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~POWER_TARGET_ON;
+	I915_WRITE(PCH_PP_CONTROL, pp);
+	do {
+		pp_status = I915_READ(PCH_PP_STATUS);
+	} while ((pp_status & PP_ON) && !time_after(jiffies, timeout));
+
+	if (time_after(jiffies, timeout))
+		DRM_DEBUG_KMS("panel off wait timed out\n");
+
+	/* Make sure VDD is enabled so DP AUX will work */
+	pp |= EDP_FORCE_VDD;
+	I915_WRITE(PCH_PP_CONTROL, pp);
+}
+
 static void ironlake_edp_backlight_on (struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -711,14 +756,18 @@ intel_dp_dpms(struct drm_encoder *encode
 	if (mode != DRM_MODE_DPMS_ON) {
 		if (dp_reg & DP_PORT_EN) {
 			intel_dp_link_down(intel_encoder, dp_priv->DP);
-			if (IS_eDP(intel_encoder))
+			if (IS_eDP(intel_encoder)) {
+				ironlake_edp_backlight_off(dev);
 				ironlake_edp_backlight_off(dev);
+			}
 		}
 	} else {
 		if (!(dp_reg & DP_PORT_EN)) {
 			intel_dp_link_train(intel_encoder, dp_priv->DP, dp_priv->link_configuration);
-			if (IS_eDP(intel_encoder))
+			if (IS_eDP(intel_encoder)) {
+				ironlake_edp_panel_on(dev);
 				ironlake_edp_backlight_on(dev);
+			}
 		}
 	}
 	dp_priv->dpms_mode = mode;



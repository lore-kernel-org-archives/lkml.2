Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1LINAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:00:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:34808 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1LIM76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:59:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83996296"
Message-Id: <20111209124555.970818539@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Dec 2011 20:42:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        "Zhenyu Wang" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] drm/i915: dont trigger hotplug events on unchanged ELD
References: <20111209124216.701131933@intel.com>
Content-Disposition: inline; filename=no-extra-eld-passing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ELD may or may not change when switching the video mode.
If unchanged, don't trigger hot plug events to HDMI audio driver.

This avoids disturbing the user with repeated printks.

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |   51 ++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 5 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2011-11-24 08:25:26.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2011-11-24 08:25:27.000000000 +0800
@@ -5811,6 +5811,35 @@ static int intel_crtc_mode_set(struct dr
 	return ret;
 }
 
+static bool intel_eld_uptodate(struct drm_connector *connector,
+			       int reg_eldv, uint32_t bits_eldv,
+			       int reg_elda, uint32_t bits_elda,
+			       int reg_edid)
+{
+	struct drm_i915_private *dev_priv = connector->dev->dev_private;
+	uint8_t *eld = connector->eld;
+	uint32_t i;
+
+	i = I915_READ(reg_eldv);
+	i &= bits_eldv;
+
+	if (!eld[0])
+		return !i;
+
+	if (!i)
+		return false;
+
+	i = I915_READ(reg_elda);
+	i &= ~bits_elda;
+	I915_WRITE(reg_elda, i);
+
+	for (i = 0; i < eld[2]; i++)
+		if (I915_READ(reg_edid) != *((uint32_t *)eld + i))
+			return false;
+
+	return true;
+}
+
 static void g4x_write_eld(struct drm_connector *connector,
 			  struct drm_crtc *crtc)
 {
@@ -5827,6 +5856,12 @@ static void g4x_write_eld(struct drm_con
 	else
 		eldv = G4X_ELDV_DEVCTG;
 
+	if (intel_eld_uptodate(connector,
+			       G4X_AUD_CNTL_ST, eldv,
+			       G4X_AUD_CNTL_ST, G4X_ELD_ADDR,
+			       G4X_HDMIW_HDMIEDID))
+		return;
+
 	i = I915_READ(G4X_AUD_CNTL_ST);
 	i &= ~(eldv | G4X_ELD_ADDR);
 	len = (i >> 9) & 0x1f;		/* ELD buffer size */
@@ -5886,6 +5921,17 @@ static void ironlake_write_eld(struct dr
 		eldv = IBX_ELD_VALIDB << ((i - 1) * 4);
 	}
 
+	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
+		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
+		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
+	}
+
+	if (intel_eld_uptodate(connector,
+			       aud_cntrl_st2, eldv,
+			       aud_cntl_st, IBX_ELD_ADDRESS,
+			       hdmiw_hdmiedid))
+		return;
+
 	i = I915_READ(aud_cntrl_st2);
 	i &= ~eldv;
 	I915_WRITE(aud_cntrl_st2, i);
@@ -5893,11 +5939,6 @@ static void ironlake_write_eld(struct dr
 	if (!eld[0])
 		return;
 
-	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
-		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
-		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
-	}
-
 	i = I915_READ(aud_cntl_st);
 	i &= ~IBX_ELD_ADDRESS;
 	I915_WRITE(aud_cntl_st, i);



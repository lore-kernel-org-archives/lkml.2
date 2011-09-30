Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1I3BOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:14:42 -0400
Received: from home.keithp.com ([63.227.221.253]:49813 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab1I3BKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:12 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 05/21] drm/i915: Check eDP power when doing aux channel communications
Date: Thu, 29 Sep 2011 18:09:37 -0700
Message-Id: <1317344993-24945-6-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify that the eDP VDD is on, either with the panel being on or with
the VDD force-on bit being set.

This demonstrates that in many instances, VDD is not on when needed,
which leads to failed EDID communications.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 8ab2a88..3b29a6f 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -279,6 +279,24 @@ intel_hrawclk(struct drm_device *dev)
 	}
 }
 
+static void
+intel_dp_check_edp(struct intel_dp *intel_dp)
+{
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 pp_status, pp_control;
+	if (!is_edp(intel_dp))
+		return;
+	pp_status = I915_READ(PCH_PP_STATUS);
+	pp_control = I915_READ(PCH_PP_CONTROL);
+	if ((pp_status & PP_ON) == 0 && (pp_control & EDP_FORCE_VDD) == 0) {
+		WARN(1, "eDP powered off while attempting aux channel communication.\n");
+		DRM_DEBUG_KMS("Status 0x%08x Control 0x%08x\n",
+			      pp_status,
+			      I915_READ(PCH_PP_CONTROL));
+	}
+}
+
 static int
 intel_dp_aux_ch(struct intel_dp *intel_dp,
 		uint8_t *send, int send_bytes,
@@ -295,6 +313,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 	uint32_t aux_clock_divider;
 	int try, precharge;
 
+	intel_dp_check_edp(intel_dp);
 	/* The clock divider is based off the hrawclk,
 	 * and would like to run at 2MHz. So, take the
 	 * hrawclk value and divide by 2 and use that
@@ -408,6 +427,7 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
 	int msg_bytes;
 	uint8_t	ack;
 
+	intel_dp_check_edp(intel_dp);
 	if (send_bytes > 16)
 		return -1;
 	msg[0] = AUX_NATIVE_WRITE << 4;
@@ -450,6 +470,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	uint8_t ack;
 	int ret;
 
+	intel_dp_check_edp(intel_dp);
 	msg[0] = AUX_NATIVE_READ << 4;
 	msg[1] = address >> 8;
 	msg[2] = address & 0xff;
@@ -493,6 +514,7 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
 	int reply_bytes;
 	int ret;
 
+	intel_dp_check_edp(intel_dp);
 	/* Set up the command byte */
 	if (mode & MODE_I2C_READ)
 		msg[0] = AUX_I2C_READ << 4;
-- 
1.7.6.3


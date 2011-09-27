Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1I0GNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:13:44 -0400
Received: from home.keithp.com ([63.227.221.253]:55040 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1I0GMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:02 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 3/9] drv/i915: Pull display_clock_mode out of VBT table
Date: Mon, 26 Sep 2011 23:11:40 -0700
Message-Id: <1317103906-4649-4-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tells the driver whether a CK505 clock source is available on
pre-PCH hardware. If so, it should be used as the non-SSC source,
leaving the internal clock for use as the SSC source.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.h   |    1 +
 drivers/gpu/drm/i915/intel_bios.c |    6 ++++--
 drivers/gpu/drm/i915/intel_bios.h |    4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 7916bd9..18df595 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -357,6 +357,7 @@ typedef struct drm_i915_private {
 	unsigned int lvds_vbt:1;
 	unsigned int int_crt_support:1;
 	unsigned int lvds_use_ssc:1;
+	unsigned int display_clock_mode:1;
 	int lvds_ssc_freq;
 	struct {
 		int rate;
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index dcbc839..eb58784 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -309,11 +309,13 @@ parse_general_features(struct drm_i915_private *dev_priv,
 		dev_priv->lvds_use_ssc = general->enable_ssc;
 		dev_priv->lvds_ssc_freq =
 			intel_bios_ssc_frequency(dev, general->ssc_freq);
-		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d\n",
+		dev_priv->display_clock_mode = general->display_clock_mode;
+		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d display_clock_mode %d\n",
 			      dev_priv->int_tv_support,
 			      dev_priv->int_crt_support,
 			      dev_priv->lvds_use_ssc,
-			      dev_priv->lvds_ssc_freq);
+			      dev_priv->lvds_ssc_freq,
+			      dev_priv->display_clock_mode);
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index 5f8e4ed..02b1b624 100644
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -120,7 +120,9 @@ struct bdb_general_features {
 	u8 ssc_freq:1;
 	u8 enable_lfp_on_override:1;
 	u8 disable_ssc_ddt:1;
-	u8 rsvd8:3; /* finish byte */
+	u8 rsvd7:1;
+	u8 display_clock_mode:1;
+	u8 rsvd8:1; /* finish byte */
 
         /* bits 3 */
 	u8 disable_smooth_vision:1;
-- 
1.7.6.3


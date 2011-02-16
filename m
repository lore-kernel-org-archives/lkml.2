Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1BPA3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:29:06 -0500
Received: from kroah.org ([198.145.64.141]:49905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab1BPAZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:50 2011
Message-Id: <20110216001450.867490143@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [258/272] drm/i915: fix calculation of eDP signal levels on Sandybridge
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yuanhan Liu <yuanhan.liu@linux.intel.com>

commit 3c5a62b5226ca5db993660281e9c2a7275d9fb02 upstream.

Some voltage swing/pre-emphasis level use the same value on eDP
Sandybridge, like 400mv_0db and 600mv_0db are with the same value
of (0x0 << 22). So, fix them, and point out the value if it isn't
a supported voltage swing/pre-emphasis level.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h |    9 +++++----
 drivers/gpu/drm/i915/intel_dp.c |   23 ++++++++++++++++-------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3057,10 +3057,11 @@
 #define  EDP_LINK_TRAIN_600MV_3_5DB_SNB_A	(0x01<<22)
 #define  EDP_LINK_TRAIN_800MV_0DB_SNB_A		(0x0<<22)
 /* SNB B-stepping */
-#define  EDP_LINK_TRAIN_400MV_0DB_SNB_B		(0x0<<22)
-#define  EDP_LINK_TRAIN_400MV_6DB_SNB_B		(0x3a<<22)
-#define  EDP_LINK_TRAIN_600MV_3_5DB_SNB_B	(0x39<<22)
-#define  EDP_LINK_TRAIN_800MV_0DB_SNB_B		(0x38<<22)
+#define  EDP_LINK_TRAIN_400_600MV_0DB_SNB_B	(0x0<<22)
+#define  EDP_LINK_TRAIN_400MV_3_5DB_SNB_B	(0x1<<22)
+#define  EDP_LINK_TRAIN_400_600MV_6DB_SNB_B	(0x3a<<22)
+#define  EDP_LINK_TRAIN_600_800MV_3_5DB_SNB_B	(0x39<<22)
+#define  EDP_LINK_TRAIN_800_1200MV_0DB_SNB_B	(0x38<<22)
 #define  EDP_LINK_TRAIN_VOL_EMP_MASK_SNB	(0x3f<<22)
 
 #endif /* _I915_REG_H_ */
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1153,18 +1153,27 @@ intel_dp_signal_levels(uint8_t train_set
 static uint32_t
 intel_gen6_edp_signal_levels(uint8_t train_set)
 {
-	switch (train_set & (DP_TRAIN_VOLTAGE_SWING_MASK|DP_TRAIN_PRE_EMPHASIS_MASK)) {
+	int signal_levels = train_set & (DP_TRAIN_VOLTAGE_SWING_MASK |
+					 DP_TRAIN_PRE_EMPHASIS_MASK);
+	switch (signal_levels) {
 	case DP_TRAIN_VOLTAGE_SWING_400 | DP_TRAIN_PRE_EMPHASIS_0:
-		return EDP_LINK_TRAIN_400MV_0DB_SNB_B;
+	case DP_TRAIN_VOLTAGE_SWING_600 | DP_TRAIN_PRE_EMPHASIS_0:
+		return EDP_LINK_TRAIN_400_600MV_0DB_SNB_B;
+	case DP_TRAIN_VOLTAGE_SWING_400 | DP_TRAIN_PRE_EMPHASIS_3_5:
+		return EDP_LINK_TRAIN_400MV_3_5DB_SNB_B;
 	case DP_TRAIN_VOLTAGE_SWING_400 | DP_TRAIN_PRE_EMPHASIS_6:
-		return EDP_LINK_TRAIN_400MV_6DB_SNB_B;
+	case DP_TRAIN_VOLTAGE_SWING_600 | DP_TRAIN_PRE_EMPHASIS_6:
+		return EDP_LINK_TRAIN_400_600MV_6DB_SNB_B;
 	case DP_TRAIN_VOLTAGE_SWING_600 | DP_TRAIN_PRE_EMPHASIS_3_5:
-		return EDP_LINK_TRAIN_600MV_3_5DB_SNB_B;
+	case DP_TRAIN_VOLTAGE_SWING_800 | DP_TRAIN_PRE_EMPHASIS_3_5:
+		return EDP_LINK_TRAIN_600_800MV_3_5DB_SNB_B;
 	case DP_TRAIN_VOLTAGE_SWING_800 | DP_TRAIN_PRE_EMPHASIS_0:
-		return EDP_LINK_TRAIN_800MV_0DB_SNB_B;
+	case DP_TRAIN_VOLTAGE_SWING_1200 | DP_TRAIN_PRE_EMPHASIS_0:
+		return EDP_LINK_TRAIN_800_1200MV_0DB_SNB_B;
 	default:
-		DRM_DEBUG_KMS("Unsupported voltage swing/pre-emphasis level\n");
-		return EDP_LINK_TRAIN_400MV_0DB_SNB_B;
+		DRM_DEBUG_KMS("Unsupported voltage swing/pre-emphasis level:"
+			      "0x%x\n", signal_levels);
+		return EDP_LINK_TRAIN_400_600MV_0DB_SNB_B;
 	}
 }
 



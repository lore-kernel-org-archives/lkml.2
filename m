Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1GZGg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:36:58 -0400
Received: from home.keithp.com ([63.227.221.253]:48629 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1GZGgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:36:43 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/5] drm/i915: Use dp_detect_common in hotplug helper function
Date: Mon, 25 Jul 2011 23:36:30 -0700
Message-Id: <1311662194-4050-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311662194-4050-1-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the common dpcd reading routine, i915_dp_detect_common,
instead of open-coding a call to intel_dp_aux_native_read. Besides
reducing duplicated code, this also gains the read retries which
may be necessary when a cable is first plugged back in and the link
needs to be retrained.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index dcc7ae6..45db810 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1567,6 +1567,20 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 	POSTING_READ(intel_dp->output_reg);
 }
 
+static enum drm_connector_status
+i915_dp_detect_common(struct intel_dp *intel_dp)
+{
+	enum drm_connector_status status = connector_status_disconnected;
+
+	if (intel_dp_aux_native_read_retry(intel_dp, 0x000, intel_dp->dpcd,
+					   sizeof (intel_dp->dpcd)) &&
+	    (intel_dp->dpcd[DP_DPCD_REV] != 0)) {
+		status = connector_status_connected;
+	}
+
+	return status;
+}
+
 /*
  * According to DP spec
  * 5.1.2:
@@ -1579,45 +1593,30 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 static void
 intel_dp_check_link_status(struct intel_dp *intel_dp)
 {
-	int ret;
-
 	if (!intel_dp->base.base.crtc)
 		return;
 
+	/* Try to read receiver status if the link appears to be up */
 	if (!intel_dp_get_link_status(intel_dp)) {
 		intel_dp_link_down(intel_dp);
 		return;
 	}
 
-	/* Try to read receiver status if the link appears to be up */
-	ret = intel_dp_aux_native_read(intel_dp,
-				       0x000, intel_dp->dpcd,
-				       sizeof (intel_dp->dpcd));
-	if (ret != sizeof(intel_dp->dpcd)) {
+	/* Now read the DPCD to see if it's actually running */
+	if (i915_dp_detect_common(intel_dp) != connector_status_connected) {
 		intel_dp_link_down(intel_dp);
 		return;
 	}
 
 	if (!intel_channel_eq_ok(intel_dp)) {
+		DRM_DEBUG_KMS("%s: channel EQ not ok, retraining\n",
+			      drm_get_encoder_name(&intel_dp->base.base));
 		intel_dp_start_link_train(intel_dp);
 		intel_dp_complete_link_train(intel_dp);
 	}
 }
 
 static enum drm_connector_status
-i915_dp_detect_common(struct intel_dp *intel_dp)
-{
-	enum drm_connector_status status = connector_status_disconnected;
-
-	if (intel_dp_aux_native_read_retry(intel_dp, 0x000, intel_dp->dpcd,
-					   sizeof (intel_dp->dpcd)) &&
-	    (intel_dp->dpcd[DP_DPCD_REV] != 0))
-		status = connector_status_connected;
-
-	return status;
-}
-
-static enum drm_connector_status
 ironlake_dp_detect(struct intel_dp *intel_dp)
 {
 	enum drm_connector_status status;
-- 
1.7.5.4


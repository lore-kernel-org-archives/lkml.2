Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1GZGhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:37:42 -0400
Received: from home.keithp.com ([63.227.221.253]:48641 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1GZGgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:36:46 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/5] drm/i915: Rename i915_dp_detect_common to intel_dp_get_dpcd
Date: Mon, 25 Jul 2011 23:36:31 -0700
Message-Id: <1311662194-4050-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311662194-4050-1-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This describes the function better, allowing it to be used where the
DPCD value is relevant.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 45db810..41674e1 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1567,18 +1567,16 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 	POSTING_READ(intel_dp->output_reg);
 }
 
-static enum drm_connector_status
-i915_dp_detect_common(struct intel_dp *intel_dp)
+static bool
+intel_dp_get_dpcd(struct intel_dp *intel_dp)
 {
-	enum drm_connector_status status = connector_status_disconnected;
-
 	if (intel_dp_aux_native_read_retry(intel_dp, 0x000, intel_dp->dpcd,
 					   sizeof (intel_dp->dpcd)) &&
 	    (intel_dp->dpcd[DP_DPCD_REV] != 0)) {
-		status = connector_status_connected;
+		return true;
 	}
 
-	return status;
+	return false;
 }
 
 /*
@@ -1603,7 +1601,7 @@ intel_dp_check_link_status(struct intel_dp *intel_dp)
 	}
 
 	/* Now read the DPCD to see if it's actually running */
-	if (i915_dp_detect_common(intel_dp) != connector_status_connected) {
+	if (!intel_dp_get_dpcd(intel_dp)) {
 		intel_dp_link_down(intel_dp);
 		return;
 	}
@@ -1617,6 +1615,14 @@ intel_dp_check_link_status(struct intel_dp *intel_dp)
 }
 
 static enum drm_connector_status
+intel_dp_detect_dpcd(struct intel_dp *intel_dp)
+{
+	if (intel_dp_get_dpcd(intel_dp))
+		return connector_status_connected;
+	return connector_status_disconnected;
+}
+
+static enum drm_connector_status
 ironlake_dp_detect(struct intel_dp *intel_dp)
 {
 	enum drm_connector_status status;
@@ -1629,7 +1635,7 @@ ironlake_dp_detect(struct intel_dp *intel_dp)
 		return status;
 	}
 
-	return i915_dp_detect_common(intel_dp);
+	return intel_dp_detect_dpcd(intel_dp);
 }
 
 static enum drm_connector_status
@@ -1658,7 +1664,7 @@ g4x_dp_detect(struct intel_dp *intel_dp)
 	if ((temp & bit) == 0)
 		return connector_status_disconnected;
 
-	return i915_dp_detect_common(intel_dp);
+	return intel_dp_detect_dpcd(intel_dp);
 }
 
 /**
-- 
1.7.5.4


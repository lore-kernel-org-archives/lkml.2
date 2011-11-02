Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab1KBGVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:21:20 -0400
Received: from home.keithp.com ([63.227.221.253]:33675 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1KBGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:21:02 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 6/7] drm/i915: Try harder during dp pattern 1 link training
Date: Tue,  1 Nov 2011 23:20:29 -0700
Message-Id: <1320214830-12696-7-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of going through the sequence just once, run through the whole
set up to 5 times to see if something can work. This isn't part of the
DP spec, but the BIOS seems to do it, and given that link training
failure is so bad, it seems reasonable to follow suit.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   41 +++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 6be6a04..bf20a35 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1576,8 +1576,9 @@ intel_dp_set_link_train(struct intel_dp *intel_dp,
 
 	ret = intel_dp_aux_native_write(intel_dp,
 					DP_TRAINING_LANE0_SET,
-					intel_dp->train_set, 4);
-	if (ret != 4)
+					intel_dp->train_set,
+					intel_dp->lane_count);
+	if (ret != intel_dp->lane_count)
 		return false;
 
 	return true;
@@ -1593,7 +1594,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 	int i;
 	uint8_t voltage;
 	bool clock_recovery = false;
-	int tries;
+	int voltage_tries, loop_tries;
 	u32 reg;
 	uint32_t DP = intel_dp->DP;
 
@@ -1620,7 +1621,8 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		DP &= ~DP_LINK_TRAIN_MASK;
 	memset(intel_dp->train_set, 0, 4);
 	voltage = 0xff;
-	tries = 0;
+	voltage_tries = 0;
+	loop_tries = 0;
 	clock_recovery = false;
 	for (;;) {
 		/* Use intel_dp->train_set[0] to set the voltage and pre emphasis values */
@@ -1663,17 +1665,28 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		for (i = 0; i < intel_dp->lane_count; i++)
 			if ((intel_dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED) == 0)
 				break;
-		if (i == intel_dp->lane_count)
-			break;
-
-		/* Check to see if we've tried the same voltage 5 times */
-		if ((intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK) == voltage) {
-			++tries;
-			if (tries == 5)
+		if (i == intel_dp->lane_count) {
+			++loop_tries;
+			if (loop_tries == 5) {
+				DRM_DEBUG_KMS("too many full retries, give up\n");
 				break;
-		} else
-			tries = 0;
-		voltage = intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK;
+			}
+			memset(intel_dp->train_set, 0, 4);
+			voltage_tries = 0;
+			continue;
+		} else {
+
+			/* Check to see if we've tried the same voltage 5 times */
+			if ((intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK) == voltage) {
+				++voltage_tries;
+				if (voltage_tries == 5) {
+					DRM_DEBUG_KMS("too many voltage retries, give up\n");
+					break;
+				}
+			} else
+				voltage_tries = 0;
+			voltage = intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK;
+		}
 
 		/* Compute new intel_dp->train_set as requested by target */
 		intel_get_adjust_train(intel_dp, link_status);
-- 
1.7.7


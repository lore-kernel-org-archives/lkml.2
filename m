Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1BVWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:28 -0500
Received: from kroah.org ([198.145.64.141]:46638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab1BVWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.757859280@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [17/70] drm/i915: make DP training try a little harder
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 37f809755845cc3e18e8216c04525bdb885fa13b upstream.

When trying to do channel equalization, we need to make sure we still
have clock recovery on all lanes while training.  We also need to try
clock recovery again if we lose the clock or if channel eq fails 5
times.  We'll try clock recovery up to 5 more times before giving up
entirely.

Gets suspend/resume working on my Vaio again and brings us back into
compliance with the DP training sequence spec.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1343,17 +1343,24 @@ intel_dp_complete_link_train(struct inte
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	bool channel_eq = false;
-	int tries;
+	int tries, cr_tries;
 	u32 reg;
 	uint32_t DP = intel_dp->DP;
 
 	/* channel equalization */
 	tries = 0;
+	cr_tries = 0;
 	channel_eq = false;
 	for (;;) {
 		/* Use intel_dp->train_set[0] to set the voltage and pre emphasis values */
 		uint32_t    signal_levels;
 
+		if (cr_tries > 5) {
+			DRM_ERROR("failed to train DP, aborting\n");
+			intel_dp_link_down(intel_dp);
+			break;
+		}
+
 		if (IS_GEN6(dev) && is_edp(intel_dp)) {
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
@@ -1376,14 +1383,26 @@ intel_dp_complete_link_train(struct inte
 		if (!intel_dp_get_link_status(intel_dp))
 			break;
 
+		/* Make sure clock is still ok */
+		if (!intel_clock_recovery_ok(intel_dp->link_status, intel_dp->lane_count)) {
+			intel_dp_start_link_train(intel_dp);
+			cr_tries++;
+			continue;
+		}
+
 		if (intel_channel_eq_ok(intel_dp)) {
 			channel_eq = true;
 			break;
 		}
 
-		/* Try 5 times */
-		if (tries > 5)
-			break;
+		/* Try 5 times, then try clock recovery if that fails */
+		if (tries > 5) {
+			intel_dp_link_down(intel_dp);
+			intel_dp_start_link_train(intel_dp);
+			tries = 0;
+			cr_tries++;
+			continue;
+		}
 
 		/* Compute new intel_dp->train_set as requested by target */
 		intel_get_adjust_train(intel_dp);



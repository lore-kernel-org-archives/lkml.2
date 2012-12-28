Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2L1Tqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:46:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55194 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676Ab2L1TSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:09 -0500
Message-Id: <20121228190355.014489357@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 118/173] ath9k_hw: Fix signal strength / channel noise reporting
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit b7c0c238898d200e80487516e2b67aba2a522cc0 upstream.

While AR_PHY_CCA_NOM_VAL_* does contain the expected internal noise floor
for a chip measured in clean air, it refers to the lowest expected reading.

Depending on the frequency, this measurement can vary by about 6db, thus
causing a higher reported channel noise and signal strength.

Factor in the 6db offset when converting internal noisefloor to channel noise.

This patch makes the reported values more accurate for all chips without
affecting NF calibration behavior.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 drivers/net/wireless/ath/ath9k/calib.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -69,6 +69,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw
 
 	if (chan && chan->noisefloor) {
 		s8 delta = chan->noisefloor -
+			   ATH9K_NF_CAL_NOISE_THRESH -
 			   ath9k_hw_get_default_nf(ah, chan);
 		if (delta > 0)
 			noise += delta;
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -22,6 +22,9 @@
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
+/* Internal noise floor can vary by about 6db depending on the frequency */
+#define ATH9K_NF_CAL_NOISE_THRESH		6
+
 #define NUM_NF_READINGS       6
 #define ATH9K_NF_CAL_HIST_MAX 5
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2LMOAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:00:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab2LMOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:00:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 002/241] cfg80211: fix antenna gain handling
Date: Thu, 13 Dec 2012 11:56:07 -0200
Message-Id: <1355407206-17100-3-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit c4a9fafc77a5318f5ed26c509bbcddf03e18c201 upstream.

No driver initializes chan->max_antenna_gain to something sensible, and
the only place where it is being used right now is inside ath9k. This
leads to ath9k potentially using less tx power than it can use, which can
decrease performance/range in some rare cases.

Rather than going through every single driver, this patch initializes
chan->orig_mag in wiphy_register(), ignoring whatever value the driver
left in there. If a driver for some reason wishes to limit it independent
from regulatory rulesets, it can do so internally.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/wireless/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e98ab2f..3f514b6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -548,8 +548,7 @@ int wiphy_register(struct wiphy *wiphy)
 		for (i = 0; i < sband->n_channels; i++) {
 			sband->channels[i].orig_flags =
 				sband->channels[i].flags;
-			sband->channels[i].orig_mag =
-				sband->channels[i].max_antenna_gain;
+			sband->channels[i].orig_mag = INT_MAX;
 			sband->channels[i].orig_mpwr =
 				sband->channels[i].max_power;
 			sband->channels[i].band = band;
-- 
1.7.9.5


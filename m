Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2KNGHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:07:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54950 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab2KNFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:01 -0500
Message-Id: <20121114053936.389927320@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 18/82] cfg80211: fix antenna gain handling
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 443d4d7..3f72530 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
 		for (i = 0; i < sband->n_channels; i++) {
 			sband->channels[i].orig_flags =
 				sband->channels[i].flags;
-			sband->channels[i].orig_mag =
-				sband->channels[i].max_antenna_gain;
+			sband->channels[i].orig_mag = INT_MAX;
 			sband->channels[i].orig_mpwr =
 				sband->channels[i].max_power;
 			sband->channels[i].band = band;



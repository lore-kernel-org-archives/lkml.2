Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993215Ab2KOEkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:40:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:48827 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992876Ab2KOELF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 13/66] cfg80211: fix antenna gain handling
Date: Wed, 14 Nov 2012 20:10:18 -0800
Message-Id: <20121115040939.964604698@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -506,8 +506,7 @@ int wiphy_register(struct wiphy *wiphy)
 		for (i = 0; i < sband->n_channels; i++) {
 			sband->channels[i].orig_flags =
 				sband->channels[i].flags;
-			sband->channels[i].orig_mag =
-				sband->channels[i].max_antenna_gain;
+			sband->channels[i].orig_mag = INT_MAX;
 			sband->channels[i].orig_mpwr =
 				sband->channels[i].max_power;
 			sband->channels[i].band = band;



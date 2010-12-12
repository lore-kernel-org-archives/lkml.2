Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0LLXpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab0LLXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:09 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [13/223] mac80211: fix channel assumption for association done work
Message-Id: <20101212234508.7945CB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit e7480bbb926c5816e4fbfca70748096bbe0e4978 upstream.

Be consistent and use the wk->chan instead of the
local->hw.conf.channel for the association done work.
This prevents any possible races against channel changes
while we run this work.

In the case that the race did happen we would be initializing
the bit rates for the new AP under the assumption of a wrong
channel and in the worst case, wrong band. This could lead
to trying to assuming we could use CCK frames on 5 GHz, for
example.

This patch has a fix for kernels >= v2.6.34

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/mlme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/net/mac80211/mlme.c
===================================================================
--- linux.orig/net/mac80211/mlme.c
+++ linux/net/mac80211/mlme.c
@@ -1210,7 +1210,7 @@ static bool ieee80211_assoc_success(stru
 
 	rates = 0;
 	basic_rates = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[wk->chan->band];
 
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
@@ -1246,11 +1246,11 @@ static bool ieee80211_assoc_success(stru
 		}
 	}
 
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[wk->chan->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
 	/* cf. IEEE 802.11 9.2.12 */
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	if (wk->chan->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else

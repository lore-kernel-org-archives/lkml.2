Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0LMAbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:31:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44663 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0LLXpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:18 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: johannes.berg@intel.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [21/223] mac80211: use correct station flags lock
Message-Id: <20101212234516.E54D1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johannes Berg <johannes.berg@intel.com>

commit f5521b13880f4f4f612e1d20dd4f565122d16e04 upstream.

This code is modifying the station flags, and
as such should hold the flags lock so it can
do so atomically vs. other flags modifications
and readers. This issue was introduced when
this code was added in eccb8e8f, as it used
the wrong lock (thus not fixing the race that
was previously documented in a comment.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/cfg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/net/mac80211/cfg.c
===================================================================
--- linux.orig/net/mac80211/cfg.c
+++ linux/net/mac80211/cfg.c
@@ -639,6 +639,7 @@ static void sta_apply_parameters(struct
 				 struct sta_info *sta,
 				 struct station_parameters *params)
 {
+	unsigned long flags;
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
@@ -647,7 +648,7 @@ static void sta_apply_parameters(struct
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, flags);
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
 
@@ -674,7 +675,7 @@ static void sta_apply_parameters(struct
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			sta->flags |= WLAN_STA_MFP;
 	}
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID

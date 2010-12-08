Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0LHA7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:52 -0500
Received: from kroah.org ([198.145.64.141]:48613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab0LHA7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:49 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.828219893@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [055/289] mac80211: use correct station flags lock
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/mac80211/cfg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -634,6 +634,7 @@ static void sta_apply_parameters(struct
 				 struct sta_info *sta,
 				 struct station_parameters *params)
 {
+	unsigned long flags;
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
@@ -642,7 +643,7 @@ static void sta_apply_parameters(struct
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, flags);
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
 
@@ -669,7 +670,7 @@ static void sta_apply_parameters(struct
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			sta->flags |= WLAN_STA_MFP;
 	}
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1DLOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:23 -0400
Received: from kroah.org ([198.145.64.141]:57644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab1DLOiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:53 2011
Message-Id: <20110412143553.859882668@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [055/105] mac80211: fix a crash in minstrel_ht in HT mode with no supported MCS rates
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4dc217df68a17a57f8464c74c1b4785e40bddf77 upstream.

When a client connects in HT mode but does not provide any valid MCS
rates, the function that finds the next sample rate gets stuck in an
infinite loop.
Fix this by falling back to legacy rates if no usable MCS rates are found.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rc80211_minstrel_ht.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -639,18 +639,14 @@ minstrel_ht_update_caps(void *priv, stru
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	struct ieee80211_local *local = hw_to_local(mp->hw);
 	u16 sta_cap = sta->ht_cap.cap;
+	int n_supported = 0;
 	int ack_dur;
 	int stbc;
 	int i;
 
 	/* fall back to the old minstrel for legacy stations */
-	if (!sta->ht_cap.ht_supported) {
-		msp->is_ht = false;
-		memset(&msp->legacy, 0, sizeof(msp->legacy));
-		msp->legacy.r = msp->ratelist;
-		msp->legacy.sample_table = msp->sample_table;
-		return mac80211_minstrel.rate_init(priv, sband, sta, &msp->legacy);
-	}
+	if (!sta->ht_cap.ht_supported)
+		goto use_legacy;
 
 	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) !=
 		MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS);
@@ -705,7 +701,22 @@ minstrel_ht_update_caps(void *priv, stru
 
 		mi->groups[i].supported =
 			mcs->rx_mask[minstrel_mcs_groups[i].streams - 1];
+
+		if (mi->groups[i].supported)
+			n_supported++;
 	}
+
+	if (!n_supported)
+		goto use_legacy;
+
+	return;
+
+use_legacy:
+	msp->is_ht = false;
+	memset(&msp->legacy, 0, sizeof(msp->legacy));
+	msp->legacy.r = msp->ratelist;
+	msp->legacy.sample_table = msp->sample_table;
+	return mac80211_minstrel.rate_init(priv, sband, sta, &msp->legacy);
 }
 
 static void



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2J2WBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:01:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:47896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761349Ab2J2Vhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Florian Reitmeir <florian@reitmeir.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 078/101] mac80211: connect with HT20 if HT40 is not permitted
Date: Mon, 29 Oct 2012 14:35:31 -0700
Message-Id: <20121029213248.972848350@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 3a40414f826a8f1096d9b94c4a53ef91b25ba28d upstream.

Some changes to fix issues with HT40 APs in Korea
and follow-up changes to allow using HT40 even if
the local regulatory database disallows it caused
issues with iwlwifi (and could cause issues with
other devices); iwlwifi firmware would assert if
you tried to connect to an AP that has an invalid
configuration (e.g. using HT40- on channel 140.)

Fix this, while avoiding the "Korean AP" issue by
disabling HT40 and advertising HT20 to the AP
when connecting.

Reported-by: Florian Reitmeir <florian@reitmeir.org>
Tested-by: Florian Reitmeir <florian@reitmeir.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3065,22 +3065,32 @@ static int ieee80211_prep_connection(str
 				   ht_cfreq, ht_oper->primary_chan,
 				   cbss->channel->band);
 			ht_oper = NULL;
+		} else {
+			channel_type = NL80211_CHAN_HT20;
 		}
 	}
 
-	if (ht_oper) {
-		channel_type = NL80211_CHAN_HT20;
+	if (ht_oper && sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		/*
+		 * cfg80211 already verified that the channel itself can
+		 * be used, but it didn't check that we can do the right
+		 * HT type, so do that here as well. If HT40 isn't allowed
+		 * on this channel, disable 40 MHz operation.
+		 */
 
-		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-			switch (ht_oper->ht_param &
-					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
+				ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
+			else
 				channel_type = NL80211_CHAN_HT40PLUS;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
+				ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
+			else
 				channel_type = NL80211_CHAN_HT40MINUS;
-				break;
-			}
+			break;
 		}
 	}
 



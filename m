Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1FCCMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:12:37 -0400
Received: from mta21.charter.net ([216.33.127.81]:57310 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1FCCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:12:13 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=TAXlbi3eXkAA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=PDDj8hj82B6I2HmP7HIA:9 a=71Rc07XmVEEFpGmdt_EA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 5/5] iwlegacy: add missing null check
Date: Thu,  2 Jun 2011 21:06:10 -0500
Message-Id: <1307066770-27309-5-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lq_sta has other null checks in this funcion.
assuming they are correct, this additional null check
should be added too.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c |   66 ++++++++++++++-------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 24d1499..a475aac 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -2275,40 +2275,42 @@ iwl4965_rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
-	rate_idx  = lq_sta->last_txrate_idx;
-
-	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
-		rate_idx -= IWL_FIRST_OFDM_RATE;
-		/* 6M and 9M shared same MCS index */
-		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
-		if (iwl4965_rs_extract_rate(lq_sta->last_rate_n_flags) >=
-			 IWL_RATE_MIMO2_6M_PLCP)
-			rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
-		info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
-		if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
-			info->control.rates[0].flags |=
-					IEEE80211_TX_RC_SHORT_GI;
-		if (lq_sta->last_rate_n_flags & RATE_MCS_DUP_MSK)
-			info->control.rates[0].flags |=
-					IEEE80211_TX_RC_DUP_DATA;
-		if (lq_sta->last_rate_n_flags & RATE_MCS_HT40_MSK)
-			info->control.rates[0].flags |=
-					IEEE80211_TX_RC_40_MHZ_WIDTH;
-		if (lq_sta->last_rate_n_flags & RATE_MCS_GF_MSK)
-			info->control.rates[0].flags |=
-					IEEE80211_TX_RC_GREEN_FIELD;
-	} else {
-		/* Check for invalid rates */
-		if ((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT_LEGACY) ||
-				((sband->band == IEEE80211_BAND_5GHZ) &&
-				 (rate_idx < IWL_FIRST_OFDM_RATE)))
-			rate_idx = rate_lowest_index(sband, sta);
-		/* On valid 5 GHz rate, adjust index */
-		else if (sband->band == IEEE80211_BAND_5GHZ)
+	if (lq_sta) {
+		rate_idx  = lq_sta->last_txrate_idx;
+
+		if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
 			rate_idx -= IWL_FIRST_OFDM_RATE;
-		info->control.rates[0].flags = 0;
+			/* 6M and 9M shared same MCS index */
+			rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
+			if (iwl4965_rs_extract_rate(lq_sta->last_rate_n_flags) >=
+				 IWL_RATE_MIMO2_6M_PLCP)
+				rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
+			info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
+			if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
+				info->control.rates[0].flags |=
+						IEEE80211_TX_RC_SHORT_GI;
+			if (lq_sta->last_rate_n_flags & RATE_MCS_DUP_MSK)
+				info->control.rates[0].flags |=
+						IEEE80211_TX_RC_DUP_DATA;
+			if (lq_sta->last_rate_n_flags & RATE_MCS_HT40_MSK)
+				info->control.rates[0].flags |=
+						IEEE80211_TX_RC_40_MHZ_WIDTH;
+			if (lq_sta->last_rate_n_flags & RATE_MCS_GF_MSK)
+				info->control.rates[0].flags |=
+						IEEE80211_TX_RC_GREEN_FIELD;
+		} else {
+			/* Check for invalid rates */
+			if ((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT_LEGACY) ||
+					((sband->band == IEEE80211_BAND_5GHZ) &&
+					 (rate_idx < IWL_FIRST_OFDM_RATE)))
+				rate_idx = rate_lowest_index(sband, sta);
+			/* On valid 5 GHz rate, adjust index */
+			else if (sband->band == IEEE80211_BAND_5GHZ)
+				rate_idx -= IWL_FIRST_OFDM_RATE;
+			info->control.rates[0].flags = 0;
+		}
+		info->control.rates[0].idx = rate_idx;
 	}
-	info->control.rates[0].idx = rate_idx;
 
 }
 
-- 
1.7.2.5


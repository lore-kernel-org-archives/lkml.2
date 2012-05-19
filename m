Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2ESNv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:51:26 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:35069 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab2ESNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:51:24 -0400
From: Soumik DAS <soumik.das@stericsson.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Soumik Das <soumik.das@stericsson.com>
Subject: [PATCH] mac80211: Fix race in sending null to check AP
Date: Sat, 19 May 2012 19:20:53 +0530
Message-ID: <1337435453-1661-1-git-send-email-soumik.das@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soumik Das <soumik.das@stericsson.com>

mac80211 tries to verify the existence of the current AP by
probing or sending a NULL frame in function
ieee80211_mgd_probe_ap_send. It 1st sends a null frame to the AP,
increments probe_send_count and waits for the ACK to the NULL
frame for a finite duration of time. At times, it happens that by
the time mac80211 gets to increment probe_send_count, the ACK for
the NULL frame transmitted has already been processed. This leads
to a race condition where mac80211 times out waiting for the ACK
for the NULL frame causing unnecessary disconnection with the AP.

Signed-off-by: Soumik Das <soumik.das@stericsson.com>
---
 net/mac80211/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dbd4bd9..40c933c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1522,6 +1522,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	 * anymore. The timeout will be reset if the frame is ACKed by
 	 * the AP.
 	 */
+	ifmgd->probe_send_count++;
+
 	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, 0);
@@ -1538,7 +1540,6 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 					 0, (u32) -1, true, false);
 	}
 
-	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(ifmgd, ifmgd->probe_timeout);
 	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-- 
1.7.0.4


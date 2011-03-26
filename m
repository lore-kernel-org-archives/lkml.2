Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1CZS1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:27:09 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:58869 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab1CZS1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:27:07 -0400
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] cfg80211:: fix possible NULL pointer dereference
Date: Sat, 26 Mar 2011 19:26:55 +0100
Message-Id: <1301164015-7978-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cfg80211_inform_bss_frame() wiphy is first dereferenced on privsz
initialisation and then it is checked for NULL. This patch fixes that.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 net/wireless/scan.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ea427f4..300c11d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -585,16 +585,23 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	struct cfg80211_internal_bss *res;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
-	size_t privsz = wiphy->bss_priv_size;
+	size_t privsz;
+
+	if (WARN_ON(!mgmt))
+		return NULL;
+
+	if (WARN_ON(!wiphy))
+		return NULL;
 
 	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
 	            (signal < 0 || signal > 100)))
 		return NULL;
 
-	if (WARN_ON(!mgmt || !wiphy ||
-		    len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
+	if (WARN_ON(len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
 		return NULL;
 
+	privsz = wiphy->bss_priv_size;
+
 	res = kzalloc(sizeof(*res) + privsz + ielen, gfp);
 	if (!res)
 		return NULL;
-- 
1.7.0.4


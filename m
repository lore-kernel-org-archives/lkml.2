Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab0IXQWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:22:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53776 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0IXQWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:22:16 -0400
From: Florian Mickler <florian@mickler.org>
To: linux-wireless@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes.berg@intel.com>, Zhu Yi <yi.zhu@intel.com>,
        Ben Cahill <ben.m.cahill@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwl3945: queue the right work if the scan needs to be aborted
Date: Fri, 24 Sep 2010 18:22:01 +0200
Message-Id: <1285345323-4250-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iwl3945's scan_completed calls into the mac80211 stack which triggers a
warn on if there is no scan outstanding.

This can be avoided by not calling scan_completed but abort_scan in
iwl3945_request_scan  in the done: branch of the function which is used
as an error out.

The done: branch seems to be an error-out branch, as, for example, if
iwl_is_ready(priv) returns false  the done: branch is executed.

NOTE:
I'm not familiar with the driver at all.
I just quickly scanned as a reaction to

https://bugzilla.kernel.org/show_bug.cgi?id=17722

the users of scan_completed in the  iwl3945 driver and noted the odd
discrepancy between the comment above this instance and the comment in
mac80211 scan_completed function.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9dd9e64..8fd00a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1411,7 +1411,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 	clear_bit(STATUS_SCANNING, &priv->status);
 	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->scan_completed);
+	queue_work(priv->workqueue, &priv->abort_scan);
 }
 
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 59a308b..d31661c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3018,7 +3018,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	clear_bit(STATUS_SCANNING, &priv->status);
 
 	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->scan_completed);
+	queue_work(priv->workqueue, &priv->abort_scan);
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
-- 
1.7.3


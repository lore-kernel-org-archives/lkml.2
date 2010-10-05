Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0JEWWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:22:51 -0400
Received: from ist.d-labs.de ([213.239.218.44]:52891 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab0JEWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:22:50 -0400
From: Florian Mickler <florian@mickler.org>
To: linville@tuxdriver.com
Cc: stable@kernel.org, linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
        reinette.chatre@intel.com, ilw@linux.intel.com,
        johannes.berg@intel.com, ben.m.cahill@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgruszka@redhat.com, Florian Mickler <florian@mickler.org>
Subject: [PATCH] iwlwifi: fix iwlwifi scanning corner cases
Date: Wed,  6 Oct 2010 00:21:32 +0200
Message-Id: <1286317292-10679-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <20101005085717.GA18012@redhat.com>
References: <20101005085717.GA18012@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka pointed out, that commit
"iwl3945: queue the right work if the scan needs to be aborted"
has an awkward definition of "right". Specifically the abort_scan work
doesn't notify the generic wireless stack that the scan was aborted.

In order to get rid of the warning in bug
https://bugzilla.kernel.org/show_bug.cgi?id=17722
we inform ieee80211_scan_completed that we are aborting
the scan by setting the apropriate status bit in request_scan and 
pass it into ieee80211_scan_completed. 

Signed-off-by: Florian Mickler <florian@mickler.org>
---

Hi John!

Here is the fix that Stanislaw described. 
(Yes, it is in a brown paper bag.)  Please wait for him to review this. 

Another option would be to just revert my previous patch and live with the 
warning until the scanning rework hit's mainline.

Regards,
Flo




 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8fd00a6..2d26767 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1410,8 +1410,10 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	*/
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 	clear_bit(STATUS_SCANNING, &priv->status);
+
 	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->abort_scan);
+	set_bit(STATUS_SCAN_ABORTING, &priv->status);
+	queue_work(priv->workqueue, &priv->scan_completed);
 }
 
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a4b3663..fedf384 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -552,8 +552,10 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	 * into driver again into functions that will attempt to take
 	 * mutex.
 	 */
-	if (!internal)
-		ieee80211_scan_completed(priv->hw, false);
+	if (!internal) {
+		bool aborted = test_bit(STATUS_SCAN_ABORTING, &priv->status);
+		ieee80211_scan_completed(priv->hw, aborted);
+	}
 }
 EXPORT_SYMBOL(iwl_bg_scan_completed);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d31661c..da10588 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3018,7 +3018,8 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	clear_bit(STATUS_SCANNING, &priv->status);
 
 	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->abort_scan);
+	set_bit(STATUS_SCAN_ABORTING, &priv->status);
+	queue_work(priv->workqueue, &priv->scan_completed);
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
-- 
1.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424711Ab2LFUYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:24:32 -0500
Received: from mail.tpi.com ([70.99.223.143]:1654 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422940Ab2LFUYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:24:31 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Don Fry <donald.h.fry@intel.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH wireless-next] iwlwifi: iwlagn_request_scan: Fix check for NULL priv->scan_request
Date: Thu,  6 Dec 2012 13:24:05 -0700
Message-Id: <1354825445-79551-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WARN_ON_ONCE() check for scan_request will not correctly detect
a NULL pointer for scan_type == IWL_SCAN_NORMAL. Make it explicit
that the check only applies to normal scans.

Convert WARN_ON_ONCE to WARN_ON since priv->scan_request really _can't_
be NULL for normal scans. If it is then we should emit frequent warnings.

This smatch warning led to scrutiny of iwlagn_request_scan():

drivers/net/wireless/iwlwifi/dvm/scan.c:894 iwlagn_request_scan() error: we previously assumed 'priv->scan_request' could be null (see line 792)

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Don Fry <donald.h.fry@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This patch does apply to 3.6.y, but it doesn't fix an existing
bug so I don't think it qualifies. This patch simply makes
the driver more robust for future development.

 drivers/net/wireless/iwlwifi/dvm/scan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index bb9f625..e5cbcca 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -673,8 +673,9 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	const u8 *ssid = NULL;
 	u8 ssid_len = 0;
 
-	if (WARN_ON_ONCE(priv->scan_request &&
-			 priv->scan_request->n_channels > MAX_SCAN_CHANNEL))
+	if (WARN_ON(priv->scan_type == IWL_SCAN_NORMAL &&
+		(!priv->scan_request ||
+		priv->scan_request->n_channels > MAX_SCAN_CHANNEL)))
 		return -EINVAL;
 
 	lockdep_assert_held(&priv->mutex);
-- 
1.7.9.5


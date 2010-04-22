Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0DVTi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:38:58 -0400
Received: from kroah.org ([198.145.64.141]:41420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab0DVT3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.706793688@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       maximilian attems <max@stro.at>
Subject: [160/197] iwlwifi: fix scan race
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit bbcbb9ef9735c67da303d30bd6beb9e699f0f508 upstream.

There is a problem if an "internal short scan" is in progress when a
mac80211 requested scan arrives. If this new scan request arrives within
the "next_scan_jiffies" period then driver will immediately return success
and complete the scan. The problem here is that the scan has not been
fully initialized at this time (is_internal_short_scan is still set to true
because of the currently running scan), which results in the scan
completion never to be sent to mac80211. At this time also, evan though the
internal short scan is still running the state (is_internal_short_scan)
will be set to false, so when the internal scan does complete then mac80211
will receive a scan completion.

Fix this by checking right away if a scan is in progress when a scan
request arrives from mac80211.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -405,21 +405,6 @@ void iwl_init_scan_params(struct iwl_pri
 
 static int iwl_scan_initiate(struct iwl_priv *priv)
 {
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN(priv, "Aborting scan due to not ready.\n");
-		return -EIO;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		return -EAGAIN;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
-		return -EAGAIN;
-	}
-
 	IWL_DEBUG_INFO(priv, "Starting scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->scan_start = jiffies;
@@ -450,6 +435,18 @@ int iwl_mac_hw_scan(struct ieee80211_hw
 		goto out_unlock;
 	}
 
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
 	/* We don't schedule scan within next_scan_jiffies period.
 	 * Avoid scanning during possible EAPOL exchange, return
 	 * success immediately.



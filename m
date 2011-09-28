Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab1I1Wuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab1I1Wui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.782872795@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [241/244] iwlagn: fix dangling scan request
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 6c80c39d9a6986a566c30d797aae37bfb697eea3 upstream.

If iwl_scan_initiate() fails for any reason,
priv->scan_request and priv->scan_vif are left
dangling. This can lead to a crash later when
iwl_bg_scan_completed() tries to run a pending
scan request.

In practice, this seems to be very rare due to
the STATUS_SCANNING check earlier. That check,
however, is wrong -- it should allow a scan to
be queued when a reset/roc scan is going on.
When a normal scan is already going on, a new
one can't be issued by mac80211, so that code
can be removed completely. I introduced this
bug when adding off-channel support in commit
266af4c745952e9bebf687dd68af58df553cb59d.

Reported-by: Peng Yan <peng.yan@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -406,31 +406,33 @@ int iwl_mac_hw_scan(struct ieee80211_hw
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    priv->scan_type != IWL_SCAN_NORMAL) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	/* mac80211 will only ask for one band at a time */
-	priv->scan_request = req;
-	priv->scan_vif = vif;
-
 	/*
 	 * If an internal scan is in progress, just set
 	 * up the scan_request as per above.
 	 */
 	if (priv->scan_type != IWL_SCAN_NORMAL) {
-		IWL_DEBUG_SCAN(priv, "SCAN request during internal scan\n");
+		IWL_DEBUG_SCAN(priv,
+			       "SCAN request during internal scan - defer\n");
+		priv->scan_request = req;
+		priv->scan_vif = vif;
 		ret = 0;
-	} else
+	} else {
+		priv->scan_request = req;
+		priv->scan_vif = vif;
+		/*
+		 * mac80211 will only ask for one band at a time
+		 * so using channels[0] here is ok
+		 */
 		ret = iwl_scan_initiate(priv, vif, IWL_SCAN_NORMAL,
 					req->channels[0]->band);
+		if (ret) {
+			priv->scan_request = NULL;
+			priv->scan_vif = NULL;
+		}
+	}
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-out_unlock:
 	mutex_unlock(&priv->mutex);
 
 	return ret;



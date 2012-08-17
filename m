Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030738Ab2HQD2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:28:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46861 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030685Ab2HQD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:08 -0400
Message-Id: <20120817030247.543764780@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 24/37] iwlwifi: disable greenfield transmissions as a workaround
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 50e2a30cf6fcaeb2d27360ba614dd169a10041c5 upstream.

There's a bug that causes the rate scaling to get stuck
when it has to use single-stream rates with a peer that
can do GF and SGI; the two are incompatible so we can't
use them together, but that causes the algorithm to not
work at all, it always rejects updates.

Disable greenfield for now to prevent that problem.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -708,11 +708,14 @@ static int rs_toggle_antenna(u32 valid_a
  */
 static bool rs_use_green(struct ieee80211_sta *sta)
 {
-	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->ctx;
-
-	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
-		!(ctx->ht.non_gf_sta_present);
+	/*
+	 * There's a bug somewhere in this code that causes the
+	 * scaling to get stuck because GF+SGI can't be combined
+	 * in SISO rates. Until we find that bug, disable GF, it
+	 * has only limited benefit and we still interoperate with
+	 * GF APs since we can always receive GF transmissions.
+	 */
+	return false;
 }
 
 /**



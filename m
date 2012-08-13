Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2HMUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab2HMUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 78/82] iwlwifi: disable greenfield transmissions as a workaround
Date: Mon, 13 Aug 2012 13:19:54 -0700
Message-Id: <20120813201753.279520441@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -709,11 +709,14 @@ static int rs_toggle_antenna(u32 valid_a
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



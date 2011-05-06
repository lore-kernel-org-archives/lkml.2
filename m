Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1EFANV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:13:21 -0400
Received: from kroah.org ([198.145.64.141]:32825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab1EFANT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001208.355963197@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 11/38] iwlagn: fix "Received BA when not expected"
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit bfd36103ec26599557c2bd3225a1f1c9267f8fcb upstream.

Need to use broadcast sta_id for management frames, otherwise we broke
BA session in the firmware and get messages like that:

"Received BA when not expected"

or (on older kernels):

"BA scd_flow 0 does not match txq_id 10"

This fix regression introduced in 2.6.35 during station management
code rewrite by:

commit 2a87c26bbe9587baeb9e56d3ce0b4971bd777643
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Apr 30 11:30:45 2010 -0700

    iwlwifi: use iwl_find_station less

Patch partially resolve:
https://bugzilla.kernel.org/show_bug.cgi?id=16691
However, there are still 11n performance problems on 4965 and 5xxx
devices that need to be investigated.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -561,12 +561,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
-	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
+	/* For management frames use broadcast id to do not break aggregation */
+	if (!ieee80211_is_data(fc))
+		sta_id = ctx->bcast_sta_id;
+	else {
+		/* Find index into station table for destination station */
+		sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
+				       hdr->addr1);
+			goto drop_unlock;
+		}
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);



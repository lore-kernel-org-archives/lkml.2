Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1EKBwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 21:52:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48943 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1EKBwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 21:52:23 -0400
Date: Wed, 11 May 2011 11:52:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110511115216.d68e78e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-agn-tx.c between commit bfd36103ec26
("iwlagn: fix "Received BA when not expected"") from Linus' tree and
commit 2c46f72e069e ("iwlagn: check DMA mapping errors") from the
wireless tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 4afae14,7c1becf..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@@ -582,17 -580,12 +580,17 @@@ int iwlagn_tx_skb(struct iwl_priv *priv
  
  	hdr_len = ieee80211_hdrlen(fc);
  
 -	/* Find index into station table for destination station */
 -	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
 -	if (sta_id == IWL_INVALID_STATION) {
 -		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 -			       hdr->addr1);
 -		goto drop_unlock_priv;
 +	/* For management frames use broadcast id to do not break aggregation */
 +	if (!ieee80211_is_data(fc))
 +		sta_id = ctx->bcast_sta_id;
 +	else {
 +		/* Find index into station table for destination station */
 +		sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
 +		if (sta_id == IWL_INVALID_STATION) {
 +			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 +				       hdr->addr1);
- 			goto drop_unlock;
++			goto drop_unlock_priv;
 +		}
  	}
  
  	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);

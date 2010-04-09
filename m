Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0DIBFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:05:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60937 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0DIBFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:05:22 -0400
Date: Fri, 9 Apr 2010 11:05:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20100409110520.9d4be988.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-4965.c between commit
ece6444c2fe80dab679beb5f0d58b091f1933b00 ("iwlwifi: need check for valid
qos packet before free") from the wireless-current tree and commit
74bcdb33e99f49ef5202dd2f8109945b4570edc2 ("iwlwifi: move agn only tx
functions from iwlcore to iwlagn") from the wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-4965.c
index 89aba76,6edae9b..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@@ -2020,10 -2013,8 +2013,10 @@@ static void iwl4965_rx_reply_tx(struct 
  			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
  			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
  					   "%d index %d\n", scd_ssn , index);
- 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+ 			freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 -			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 +			if (qc)
 +				iwl_free_tfds_in_queue(priv, sta_id,
 +						       tid, freed);
  
  			if (priv->mac80211_registered &&
  			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@@ -2048,18 -2039,15 +2041,18 @@@
  				   le32_to_cpu(tx_resp->rate_n_flags),
  				   tx_resp->failure_frame);
  
- 		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+ 		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 -		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 +		if (qc && likely(sta_id != IWL_INVALID_STATION))
 +			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 +		else if (sta_id == IWL_INVALID_STATION)
 +			IWL_DEBUG_TX_REPLY(priv, "Station not known\n");
  
  		if (priv->mac80211_registered &&
  		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
  			iwl_wake_queue(priv, txq_id);
  	}
 -
 -	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 +	if (qc && likely(sta_id != IWL_INVALID_STATION))
- 		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
++		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
  
  	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
  		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");

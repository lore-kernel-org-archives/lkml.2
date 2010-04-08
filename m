Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab0DHUa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:30:28 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33412 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab0DHUaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:30:18 -0400
Date: Thu, 8 Apr 2010 16:19:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-wireless@vger.kernel.org
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
	v2.6.34-rc3-406 oops with 4965AGN wireless
Message-ID: <20100408201952.GD2999@tuxdriver.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:27:53AM +0800, Jeff Chua wrote:

> Wey, the patch doesn't apply cleanly. I believe you meant "iwl_" instead  
> of "iwlagn_".

He based his patch on wireless-testing (or something similar), where
iwlagn_ is the proper prefix for the functions in question.

John

P.S. Cc'ing linux-wireless...

P.P.S.  You might try this version of his later patch...

>From ece6444c2fe80dab679beb5f0d58b091f1933b00 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Thu, 8 Apr 2010 13:17:37 -0700
Subject: [PATCH] iwlwifi: need check for valid qos packet before free

For 4965, need to check it is valid qos frame before free, only valid
QoS frame has the tid used to free the packets.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 83c52a6..8972166 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2015,7 +2015,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+			if (qc)
+				iwl_free_tfds_in_queue(priv, sta_id,
+						       tid, freed);
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@ -2041,14 +2043,17 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				   tx_resp->failure_frame);
 
 		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
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
-	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	if (qc && likely(sta_id != IWL_INVALID_STATION))
+		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
-- 
1.6.2.5

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

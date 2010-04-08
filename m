Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0DHRxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:53:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:35764 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238Ab0DHRxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,171,1270450800"; 
   d="scan'208,223";a="263538100"
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhao, Shanyu" <shanyu.zhao@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
Content-Type: multipart/mixed; boundary="=-nUvKoqY6KtHDgcmFght6"
Date: Thu, 08 Apr 2010 11:50:19 -0700
Message-Id: <1270752619.11853.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nUvKoqY6KtHDgcmFght6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Jeff,

On Thu, 2010-04-08 at 10:16 -0700, Jeff Chua wrote:
> Linus,
> 
> I'm having problem with the latest git pull 2 days ago with the 4965AGN 
> wireless.
> 
> Starting the wireless with WPA2 resulted in system hard freeze. Reverting 
> the commit below solves the problem.
> 
> 
> Thanks,
> Jeff
> 
> 
Sorry for the problem caused by this patch, it is my mistake using the
similar approach for 4965 like the newer devices. could you try the
attach patch to see if this fix your system freeze problem.

Regards
Wey

--=-nUvKoqY6KtHDgcmFght6
Content-Disposition: attachment; filename*0=0001-iwlwifi-need-check-for-valid-qos-packet-before-free.patc; filename*1=h
Content-Type: text/x-patch; name="0001-iwlwifi-need-check-for-valid-qos-packet-before-free.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 0c441b5c684709152cd322e91ce59914159ea513 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Thu, 8 Apr 2010 11:41:24 -0700
Subject: [PATCH 1/1] iwlwifi: need check for valid qos packet before free

For 4965, need to check it is valid qos frame before free, only valid
QoS frame has the tid used to free the packets.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c710b26..4113909 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2014,7 +2014,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+			if (qc && likely(sta_id != IWL_INVALID_STATION))
+				iwl_free_tfds_in_queue(priv, sta_id,
+						       tid, freed);
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@ -2046,8 +2048,8 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
 			iwl_wake_queue(priv, txq_id);
 	}
-
-	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
+	if (qc && likely(sta_id != IWL_INVALID_STATION))
+		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 }
-- 
1.5.6.3


--=-nUvKoqY6KtHDgcmFght6--


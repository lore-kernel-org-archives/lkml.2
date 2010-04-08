Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab0DHT2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:28:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:37102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311Ab0DHT21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,172,1270450800"; 
   d="scan'208,223";a="556241971"
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhao, Shanyu" <shanyu.zhao@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100408181340.GN30031@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
	 <20100408181340.GN30031@ZenIV.linux.org.uk>
Content-Type: multipart/mixed; boundary="=-v7/y33nWzMArKS48gcnM"
Date: Thu, 08 Apr 2010 13:24:56 -0700
Message-Id: <1270758296.11853.16.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v7/y33nWzMArKS48gcnM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Viro and Jeff,

On Thu, 2010-04-08 at 11:13 -0700, Al Viro wrote:
> On Fri, Apr 09, 2010 at 01:16:43AM +0800, Jeff Chua wrote:
> > 
> > index 1bd2cd8..83c52a6 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> > @@ -2041,16 +2041,14 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
> >  				   tx_resp->failure_frame);
> > 
> >  		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
> > -		if (qc && likely(sta_id != IWL_INVALID_STATION))
> > -			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
> > +		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
> 
> So what happens if we hit sta_id == IWL_INVALID_STATION and !txq->sched_retry?
> 
> AFAICS, IWL_INVALID_STATION is 255 and priv->stations[] has only 32 elements.
> And code around that place is
>         if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
>                 IWL_ERR(priv, "Station not known\n");
>                 return;
>         }
>         if (txq->sched_retry) {
> 		....
> 	} else {
> 		....
> 		the code modified in that chunk
> 		....
> 	}
> so this removal of check for sta_id doesn't look apriori safe...
> 
> I'm not familiar with that code and I don't have the hardware, so this is
> just from RTFS, but... might make sense to replace that call of
> iwl_free_tfds_in_queue with
> 
> 		if (sta_id == IWL_INVALID_STATION)
> 			printk(KERN_ERR "buggered");
> 		else
> 			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
> 
> and see if that helps and if printk gets triggered.

Maybe this patch looks better, if sched_rety and sta_id ==
IWL_INVALID_ID_STATION, this function already return before reach
iwl_free_tfds_in_queue, so do not have to check for sta_id ==
IWL_INVALID_ID_STATION. the other case, print log if sta_id ==
IWL_INVALID_ID_STATION.

Wey

--=-v7/y33nWzMArKS48gcnM
Content-Disposition: attachment; filename*0=0001-iwlwifi-need-check-for-valid-qos-packet-before-free.patc; filename*1=h
Content-Type: text/x-patch; name="0001-iwlwifi-need-check-for-valid-qos-packet-before-free.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From f3a5f691e32c0edfbc42a1e8687392dc3efe396e Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Thu, 8 Apr 2010 13:17:37 -0700
Subject: [PATCH 1/1] iwlwifi: need check for valid qos packet before free

For 4965, need to check it is valid qos frame before free, only valid
QoS frame has the tid used to free the packets.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c710b26..2e3cda7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2014,7 +2014,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+			if (qc)
+				iwl_free_tfds_in_queue(priv, sta_id,
+						       tid, freed);
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@ -2040,14 +2042,17 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				   tx_resp->failure_frame);
 
 		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
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
+		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 }
-- 
1.5.6.3


--=-v7/y33nWzMArKS48gcnM--


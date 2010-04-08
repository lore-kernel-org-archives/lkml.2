Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab0DHTxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:53:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:7599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059Ab0DHTxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:53:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,172,1270450800"; 
   d="scan'208,223";a="507541309"
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Zhao, Shanyu" <shanyu.zhao@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.1004090336410.22139@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
	 <Pine.LNX.4.64.1004090336410.22139@boston.corp.fedex.com>
Content-Type: multipart/mixed; boundary="=-qGsVv7IT84VMBWAtQBAQ"
Date: Thu, 08 Apr 2010 13:50:00 -0700
Message-Id: <1270759800.19330.19.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qGsVv7IT84VMBWAtQBAQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Jeff,


On Thu, 2010-04-08 at 12:42 -0700, Jeff Chua wrote:
> 
> On Fri, Apr 9, 2010 at 4:24 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> 
> wrote:
> 
> > Maybe this patch looks better, if sched_rety and sta_id ==
> 
> Wey,
> 
> I've updated your patch and tested it. Wireless seems ok now.
> 
> Please verify it and inform Linus once you sign-off on it.
> 
> 
> Thanks,
> Jeff
> 
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c.org	2010-04-09 02:11:45.000000000 +0800
> +++ a/drivers/net/wireless/iwlwifi/iwl-4965.c	2010-04-09 03:33:43.000000000 +0800
> @@ -2012,10 +2012,15 @@
> 
>   		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
>   			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
> -			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
> -					   "%d index %d\n", scd_ssn , index);
> +			IWL_DEBUG_TX_REPLY(priv,
> +					"Retry scheduler reclaim scd_ssn "
> +					"%d index %d\n", scd_ssn , index);
>   			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
> -			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
> +			if(qc)
> +				iwl_free_tfds_in_queue(priv, sta_id, tid,
> +					freed);
> +			else if (sta_id == IWL_INVALID_STATION)
> +				       IWL_ERR(priv, "invalid station");
> 
do not need to check sta_id == IWL_INVALID_STATION here since already
check before.
could you try my revised version of patch I send after my first attempt.
to make sure it works. 

I attach here again in case you did not get it.

Thanks
Wey



--=-qGsVv7IT84VMBWAtQBAQ
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


--=-qGsVv7IT84VMBWAtQBAQ--


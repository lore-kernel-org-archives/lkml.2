Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab0DHRTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:19:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10666 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab0DHRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=KyvhuMOGGd7oXhApSGS0eaYLKyX7e77+yCRfWQl2qU4knIm8FJ54gXfKv8rhXYR686
         m2gB67pyTI3cVxqz+Yq/QGxC21tbVxKX68NvtBVnMUrcji6e64SVkpzyM3yujGJ7vVGF
         BixzgdCcxdltsXnYfSVgLyDudODfrenkazL4k=
Date: Fri, 9 Apr 2010 01:16:43 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
cc: stable@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6. v2.6.34-rc3-406
 oops with 4965AGN wireless
Message-ID: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

I'm having problem with the latest git pull 2 days ago with the 4965AGN 
wireless.

Starting the wireless with WPA2 resulted in system hard freeze. Reverting 
the commit below solves the problem.


Thanks,
Jeff


commit be6b38bcb175613f239e0b302607db346472c6b6
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Thu Mar 18 09:05:00 2010 -0700

     iwlwifi: counting number of tfds can be free for 4965

     Forget one hunk in 4965 during "iwlwifi: error checking for number of tfds
     in queue" patch.

     Reported-by: Shanyu Zhao <shanyu.zhao@intel.com>
     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
     Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
     CC: stable@kernel.org

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1bd2cd8..83c52a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2041,16 +2041,14 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
  				   tx_resp->failure_frame);

  		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		if (qc && likely(sta_id != IWL_INVALID_STATION))
-			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);

  		if (priv->mac80211_registered &&
  		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
  			iwl_wake_queue(priv, txq_id);
  	}

-	if (qc && likely(sta_id != IWL_INVALID_STATION))
-		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	iwl_txq_check_empty(priv, sta_id, tid, txq_id);

  	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
  		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");

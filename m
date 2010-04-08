Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab0DHTnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:43:15 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:56717 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab0DHTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:mime-version:content-type;
        b=N5jrAFUFbOeKZDjpcmQwvZCpnFJ8lnVUkKAKDxT9DY9Q1zLvJEo+6cotfczzQvcPDD
         CfERZDT6M9I8mPWKIobtGU++unG7AHqakkqZS0ipxZe18Rp87DfZF2HPO5xGuLZWFFk6
         cHyisj9YzZ+ZqrF6gB/C1KkLMz3bCd/l5lSw8=
Date: Fri, 9 Apr 2010 03:42:52 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
cc: Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6. v2.6.34-rc3-406
 oops with 4965AGN wireless
In-Reply-To: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.1004090336410.22139@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Apr 9, 2010 at 4:24 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> 
wrote:

> Maybe this patch looks better, if sched_rety and sta_id ==

Wey,

I've updated your patch and tested it. Wireless seems ok now.

Please verify it and inform Linus once you sign-off on it.


Thanks,
Jeff

--- a/drivers/net/wireless/iwlwifi/iwl-4965.c.org	2010-04-09 02:11:45.000000000 +0800
+++ a/drivers/net/wireless/iwlwifi/iwl-4965.c	2010-04-09 03:33:43.000000000 +0800
@@ -2012,10 +2012,15 @@

  		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
  			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
-					   "%d index %d\n", scd_ssn , index);
+			IWL_DEBUG_TX_REPLY(priv,
+					"Retry scheduler reclaim scd_ssn "
+					"%d index %d\n", scd_ssn , index);
  			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+			if(qc)
+				iwl_free_tfds_in_queue(priv, sta_id, tid,
+					freed);
+			else if (sta_id == IWL_INVALID_STATION)
+				       IWL_ERR(priv, "invalid station");

  			if (priv->mac80211_registered &&
  			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@ -2041,14 +2046,18 @@
  				   tx_resp->failure_frame);

  		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+		if (qc && likely(sta_id != IWL_INVALID_STATION))
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+		else if (sta_id == IWL_INVALID_STATION)
+		       IWL_ERR(priv, "invalid station");

  		if (priv->mac80211_registered &&
  		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
  			iwl_wake_queue(priv, txq_id);
  	}

-	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	if (qc && likely(sta_id != IWL_INVALID_STATION))
+		iwl_txq_check_empty(priv, sta_id, tid, txq_id);

  	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
  		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");

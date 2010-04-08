Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab0DHT2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:28:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39681 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab0DHT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=B3RCOLdUEVRX/wkRObEHHd+P3fKJjBT+s/sJy4dGWQYYII1/qx2vMYEYdTVthZL7P7
         Honkk6//kd0lPAyMfnzazGi2BeuH401s1nepG5MN55B88XJj81YNoKkE4sbuP0hvACOX
         SgCyPwsIiecSVr527RvCWUxRe7BYo6/zxC3Ss=
Date: Fri, 9 Apr 2010 03:27:53 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>, Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6. v2.6.34-rc3-406
 oops with 4965AGN wireless
Message-ID: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Apr 9, 2010 at 1:19 AM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:

> I don't mind reverting patches, but I hate doing it blind and without 
> _any_ chance for the guilty party to try to fix it first.

> Can you post the oops that your subject implies happened? Maybe the 
> driver authors can find the proper fix without a revert?

The screen is so fast and never stops so I don't know how to capture that. 
I just tried the patch from Wey and had to modify it slightly to make it 
work.



On Fri, Apr 9, 2010 at 2:50 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> 
wrote:

> Sorry for the problem caused by this patch, it is my mistake using the
similar approach for 4965 like the newer devices. could you try the
attach patch to see if this fix your system freeze problem.

Wey, the patch doesn't apply cleanly. I believe you meant "iwl_" instead 
of "iwlagn_".

Also, the checking for IWL_INVALID_STATION should be done after the "} 
else {" as in the original code prior to your patch. I just verified this 
with the patch below and it no longer oops.



On Fri, Apr 9, 2010 at 2:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:

> So what happens if we hit sta_id == IWL_INVALID_STATION and
> !txq->sched_retry?

> I'm not familiar with that code and I don't have the hardware, so this 
> is just from RTFS, but... might make sense to replace that call of 
> iwl_free_tfds_in_queue with
>       if (sta_id == IWL_INVALID_STATION)
>              printk(KERN_ERR "buggered");
>       else
>              iwl_free_tfds_in_queue(priv, sta_id, tid, freed);


I just tried that, but not seeing any invalid station messages. The 
KERN_ERR has been added below.




On Fri, Apr 9, 2010 at 4:09 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> 
wrote:

> We can check for IWL_INVALID_STATION and print log, but need to check
> for qc to make sure it is valid; maybe something like


Ok, added below.



Thanks,
Jeff

--- drivers/net/wireless/iwlwifi/iwl-4965.c.org	2010-04-09 02:11:45.000000000 +0800
+++ drivers/net/wireless/iwlwifi/iwl-4965.c	2010-04-09 03:21:57.000000000 +0800
@@ -2012,10 +2012,18 @@

  		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
  			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
-					   "%d index %d\n", scd_ssn , index);
+			IWL_DEBUG_TX_REPLY(priv,
+					"Retry scheduler reclaim scd_ssn "
+					"%d index %d\n", scd_ssn , index);
  			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
  			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+			if (qc && likely(sta_id != IWL_INVALID_STATION))
+				iwl_free_tfds_in_queue(priv, sta_id, tid,
+					freed);
+			else {
+				if (sta_id == IWL_INVALID_STATION)
+				       IWL_ERR(priv, "invalid station");
+			}

  			if (priv->mac80211_registered &&
  			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@ -2041,14 +2049,20 @@
  				   tx_resp->failure_frame);

  		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+		if (qc && likely(sta_id != IWL_INVALID_STATION))
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+		else {
+			if (sta_id == IWL_INVALID_STATION)
+			       IWL_ERR(priv, "invalid station");
+		}

  		if (priv->mac80211_registered &&
  		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
  			iwl_wake_queue(priv, txq_id);
  	}

-	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	if (qc && likely(sta_id != IWL_INVALID_STATION))
+		iwl_txq_check_empty(priv, sta_id, tid, txq_id);

  	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
  		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");

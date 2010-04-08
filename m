Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab0DHSNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:13:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38963 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab0DHSNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:13:48 -0400
Date: Thu, 8 Apr 2010 19:13:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
Message-ID: <20100408181340.GN30031@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 01:16:43AM +0800, Jeff Chua wrote:
> 
> index 1bd2cd8..83c52a6 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -2041,16 +2041,14 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
>  				   tx_resp->failure_frame);
> 
>  		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
> -		if (qc && likely(sta_id != IWL_INVALID_STATION))
> -			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
> +		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);

So what happens if we hit sta_id == IWL_INVALID_STATION and !txq->sched_retry?

AFAICS, IWL_INVALID_STATION is 255 and priv->stations[] has only 32 elements.
And code around that place is
        if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
                IWL_ERR(priv, "Station not known\n");
                return;
        }
        if (txq->sched_retry) {
		....
	} else {
		....
		the code modified in that chunk
		....
	}
so this removal of check for sta_id doesn't look apriori safe...

I'm not familiar with that code and I don't have the hardware, so this is
just from RTFS, but... might make sense to replace that call of
iwl_free_tfds_in_queue with

		if (sta_id == IWL_INVALID_STATION)
			printk(KERN_ERR "buggered");
		else
			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);

and see if that helps and if printk gets triggered.

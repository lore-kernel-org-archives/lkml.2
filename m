Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab0DHTNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:13:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:40680 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960Ab0DHTNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:13:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,172,1270450800"; 
   d="scan'208";a="263569886"
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
Content-Type: text/plain
Date: Thu, 08 Apr 2010 13:09:33 -0700
Message-Id: <1270757373.11853.11.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

We can check for IWL_INVALID_STATION and print log, but need to check
for qc to make sure it is valid; maybe something like
			if (qc && likely(sta_id != IWL_INVALID_STATION))
				iwl_free_tfds_in_queue(priv, sta_id,
						       tid, freed);
			else {
				if (sta_id == IWL_INVALID_STATION)
					IWL_ERR(priv, "invalid station"");
			} 
	
Wey




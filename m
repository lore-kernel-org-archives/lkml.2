Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2AGSyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:54:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6806 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2AGSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:54:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6582"; a="150793031"
Date: Sat, 7 Jan 2012 10:54:43 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>, vinod.koul@intel.com,
        dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        bryanh@codeaurora.org, linux@arm.linux.org.uk, tsoni@qualcomm.com,
        johlstei@qualcomm.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on old
 MSM DMA APIs
Message-ID: <20120107185443.GA19216@codeaurora.org>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
 <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org>
 <1325901569.10425.14.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325901569.10425.14.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 05:59:29PM -0800, Daniel Walker wrote:

> > diff --git a/drivers/dma/msm-dma.c b/drivers/dma/msm-dma.c
> > new file mode 100644
> > index 0000000..51d9a2b
> > --- /dev/null
> > +++ b/drivers/dma/msm-dma.c
> > ...
> > +static void msm_chan_desc_cleanup(struct msm_dma_chan *chan)
> > +{
> > +	struct msm_dma_desc_sw *desc, *_desc;
> > +	unsigned long flags;
> > +
> > +	dev_dbg(chan->dev, "Cleaning completed descriptor of channel %d\n",
> > +							chan->chan_id);
> > +	spin_lock_irqsave(&chan->lock, flags);
> > +
> > +	list_for_each_entry_safe(desc, _desc, &chan->active_list, node) {
> > +		dma_async_tx_callback callback;
> > +		void *callback_param;
> > +
> > +		if (msm_dma_desc_status(chan, desc) == DMA_IN_PROGRESS)
> > +			break;
> > +
> > +		/* Remove from the list of running transactions */
> > +		list_del(&desc->node);
> > +
> > +		/* Run the link descriptor callback function */
> > +		callback = desc->async_tx.callback;
> > +		callback_param = desc->async_tx.callback_param;
> > +		if (callback) {
> > +			spin_unlock_irqrestore(&chan->lock, flags);
> > +			callback(callback_param);
> 
> Are you sure unlocking here is safe? at_hdmac.c holds the lock the
> entire time, and fsldma.c deletes the entire list, then runs the
> operations.

Good catch.

According to a comment in at_hdmac.c, it is safe to hold the lock
while calling the callbacks, so that's probably the easiest solution.
I suspect that you've got something in another driver expecting the
lock to be released, and that might have to be changed.

I do think the way fsldma.c does it is cleaner, though, since it
allows the lock to be released for longer periods of times.

In either case, it can't be releasing a lock in the middle of a loop
like this.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2AHAOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 19:14:09 -0500
Received: from fifo99.com ([67.223.236.141]:51270 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab2AHAOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 19:14:06 -0500
Message-ID: <1325981636.16037.6.camel@m0nster>
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on
 old MSM DMA APIs
From: Daniel Walker <dwalker@fifo99.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Brown <davidb@codeaurora.org>,
        Ravi Kumar V <kumarrav@codeaurora.org>, vinod.koul@intel.com,
        dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        bryanh@codeaurora.org, tsoni@qualcomm.com, johlstei@qualcomm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Sat, 07 Jan 2012 16:13:56 -0800
In-Reply-To: <20120107192112.GB13181@n2100.arm.linux.org.uk>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
	 <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org>
	 <1325901569.10425.14.camel@m0nster> <20120107185443.GA19216@codeaurora.org>
	 <20120107192112.GB13181@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-07 at 19:21 +0000, Russell King - ARM Linux wrote:
> On Sat, Jan 07, 2012 at 10:54:43AM -0800, David Brown wrote:
> > On Fri, Jan 06, 2012 at 05:59:29PM -0800, Daniel Walker wrote:
> > 
> > > > diff --git a/drivers/dma/msm-dma.c b/drivers/dma/msm-dma.c
> > > > new file mode 100644
> > > > index 0000000..51d9a2b
> > > > --- /dev/null
> > > > +++ b/drivers/dma/msm-dma.c
> > > > ...
> > > > +static void msm_chan_desc_cleanup(struct msm_dma_chan *chan)
> > > > +{
> > > > +	struct msm_dma_desc_sw *desc, *_desc;
> > > > +	unsigned long flags;
> > > > +
> > > > +	dev_dbg(chan->dev, "Cleaning completed descriptor of channel %d\n",
> > > > +							chan->chan_id);
> > > > +	spin_lock_irqsave(&chan->lock, flags);
> > > > +
> > > > +	list_for_each_entry_safe(desc, _desc, &chan->active_list, node) {
> > > > +		dma_async_tx_callback callback;
> > > > +		void *callback_param;
> > > > +
> > > > +		if (msm_dma_desc_status(chan, desc) == DMA_IN_PROGRESS)
> > > > +			break;
> > > > +
> > > > +		/* Remove from the list of running transactions */
> > > > +		list_del(&desc->node);
> > > > +
> > > > +		/* Run the link descriptor callback function */
> > > > +		callback = desc->async_tx.callback;
> > > > +		callback_param = desc->async_tx.callback_param;
> > > > +		if (callback) {
> > > > +			spin_unlock_irqrestore(&chan->lock, flags);
> > > > +			callback(callback_param);
> > > 
> > > Are you sure unlocking here is safe? at_hdmac.c holds the lock the
> > > entire time, and fsldma.c deletes the entire list, then runs the
> > > operations.
> > 
> > Good catch.
> > 
> > According to a comment in at_hdmac.c, it is safe to hold the lock
> > while calling the callbacks, so that's probably the easiest solution.
> > I suspect that you've got something in another driver expecting the
> > lock to be released, and that might have to be changed.
> 
> It is _not_ safe to hold the lock while calling callbacks.
> 
> Please refer to the DMA engine documentation, found here:
> 
> Documentation/dmaengine.txt
> 
> section 3:
> 
>    Note:
>         Although the async_tx API specifies that completion callback
>         routines cannot submit any new operations, this is not the
>         case for slave/cyclic DMA.
> 
>         For slave DMA, the subsequent transaction may not be available
>         for submission prior to callback function being invoked, so
>         slave DMA callbacks are permitted to prepare and submit a new
>         transaction.
> 
>         For cyclic DMA, a callback function may wish to terminate the
>         DMA via dmaengine_terminate_all().
> 
> *       Therefore, it is important that DMA engine drivers drop any
> *       locks before calling the callback function which may cause a
> *       deadlock.

Here's the comment from at_hdmac.c .

                /*
                 * The API requires that no submissions are done from a
                 * callback, so we don't need to drop the lock here
                 */
                if (callback)
                        callback(param);

I don't know much about the DMA engine, but maybe there is some special
case here that makes this ok.. (CC'ed Nicolas Ferre)

Daniel


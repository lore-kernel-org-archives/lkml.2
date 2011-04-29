Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1D2JQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 05:16:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43144 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1D2JQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 05:16:13 -0400
Date: Fri, 29 Apr 2011 10:15:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: shiraz.hashim@st.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, viresh.linux@gmail.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/7] dmaengine/dw_dmac: Replace spin_lock* with
	irqsave variants
Message-ID: <20110429091557.GZ17290@n2100.arm.linux.org.uk>
References: <cover.1303896566.git.viresh.kumar@st.com> <50dc2f47f2c9f94fce78583568830a66af49307d.1303896567.git.viresh.kumar@st.com> <20110428171020.GB17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428171020.GB17290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 06:10:20PM +0100, Russell King - ARM Linux wrote:
> On Wed, Apr 27, 2011 at 03:06:44PM +0530, Viresh Kumar wrote:
> > @@ -407,6 +410,8 @@ EXPORT_SYMBOL(dw_dma_get_dst_addr);
> >  static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
> >  		u32 status_block, u32 status_err, u32 status_xfer)
> >  {
> > +	unsigned long flags;
> > +
> >  	if (status_block & dwc->mask) {
> >  		void (*callback)(void *param);
> >  		void *callback_param;
> > @@ -418,9 +423,9 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
> >  		callback = dwc->cdesc->period_callback;
> >  		callback_param = dwc->cdesc->period_callback_param;
> >  		if (callback) {
> > -			spin_unlock(&dwc->lock);
> > +			spin_unlock_irqrestore(&dwc->lock, flags);
> >  			callback(callback_param);
> > -			spin_lock(&dwc->lock);
> > +			spin_lock_irqsave(&dwc->lock, flags);
> 
> I'm really not convinced that this is anywhere near correct.  I'm
> surprised this doesn't spit out a compiler warning.
> 
> spin_unlock_irqrestore() reads the flags argument and puts it into
> the PSR.  spin_lock_irqsave() reads the PSR, puts it into the flags
> argument, sets the interrupt mask bit and writes back to the PSR.
> 
> So, if you do:
> 
> 	unsigned long flags;
> 
> 	spin_unlock_irqrestore(&dwc->lock, flags);
> 	...
> 	spin_lock_irqsave(&dwc->lock, flags);
> 
> you're going to end up corrupting the PSR.
> 
> In any case, releasing a spinlock temporarily within a called function
> is _really_ not a nice thing to do.  It makes code review rather
> difficult as called functions become non-atomic when called within
> an atomic region.

BTW, how this gets handled in other drivers is basically as follows in
the tasklet:

tasklet()
{
	LIST_HEAD(completed);

	spin_lock_irqsave(lock, flags);
	for each txd(txd) {
		if (completed(txd))
			list_move_tail(&txd->node, &completed);
	}
	try to start new txd();
	spin_unlock_irqrestore(lock, flags);

	for each list entry safe(txd, &completed) {
		void (*callback)(void *) = txd->callback;
		void *param = txd->callback_param;

		free_txd(txd);

		if (callback)
			callback(param);
	}
}

I'm not sure how easy it is to move dw_dmac to that kind of structure,
but I think this is what is required rather than dropping locks within
functions which they haven't themselves taken.

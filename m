Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1CAKA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:00:28 -0500
Received: from www.tglx.de ([62.245.132.106]:36317 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab1CAKA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:00:26 -0500
Date: Tue, 1 Mar 2011 11:00:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
In-Reply-To: <20110301093956.GL29521@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1103011054440.2701@localhost6.localdomain6>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de> <1298887229-7987-4-git-send-email-s.hauer@pengutronix.de> <alpine.LFD.2.00.1102281858240.2701@localhost6.localdomain6> <20110301093956.GL29521@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Sascha Hauer wrote:
> On Mon, Feb 28, 2011 at 07:33:05PM +0100, Thomas Gleixner wrote:
> > > +void ipu_idmac_put(struct ipu_channel *channel)
> > > +{
> > > +	dev_dbg(ipu_dev, "%s %d\n", __func__, channel->num);
> > 
> > Do we really need this debug stuff in all these functions ?
> 
> Reading this comment I expected tons of dev_dbg in the driver. The one
> you mentioned above (plus the corresponding one in ipu_idmac_get) are
> indeed not particularly useful, but do you think there is still too much
> debug code left?

Well, I don't see a point in having useless debug stuff around.
> > > +	DECLARE_IPU_IRQ_BITMAP(irqs);
> > 
> > Why the hell do we need this? It's a bog standard bitmap, right ?
> 
> It's defined as:
> 
> #define DECLARE_IPU_IRQ_BITMAP(name)     DECLARE_BITMAP(name, IPU_IRQ_COUNT)
> 
> So yes, it's a standard bitmask. It can be used in client drivers
> aswell. Where's the problem of adding a define for this so that client
> drivers do not have to care about the size of the bitmap?

That's nonsense. You have to know about the size of the bitmap for any
operation on it. Or are you going to provide wrappers around
bitmap_zero() and all other possible bitmap_* functions as well?

> > 
> > > +	bitmap_zero(irqs, IPU_IRQ_COUNT);
> > > +	ret = ipu_submodules_init(pdev, ipu_base, ipu_clk);
> > > +	if (ret)
> > > +		goto failed_submodules_init;
> > > +
> > > +	/* Set sync refresh channels as high priority */
> > > +	ipu_idmac_write(0x18800000, IDMAC_CHA_PRI(0));
> > 
> > Hmm, this random prio setting here is odd.
> 
> This is 1:1 from the Freescale Kernel and I never thought about it. We
> can remove it and see what happens. Maybe then some day we'll learn
> *why* this is done.

Well, the point is to move that to the init function which deals with
IDMAC and not have it at some random place in the code.
 
> > > +	/* Wait for DC triple buffer to empty */
> > > +	if (dc_channels[dc_chan].di == 0)
> > > +		while ((__raw_readl(DC_STAT) & 0x00000002)
> > > +			!= 0x00000002) {
> > > +			msleep(2);
> > > +			timeout -= 2;
> > > +			if (timeout <= 0)
> > > +				break;
> > 
> > So we poll stuff which is updated from some other function ?
> 
> We poll the DC_STAT register here which is updated from the hardware.

And there is no interrupt for this ?

Thanks,

	tglx

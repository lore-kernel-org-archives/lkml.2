Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0LWMbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:31:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34913 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0LWMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:31:04 -0500
Date: Thu, 23 Dec 2010 12:30:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20101223123028.GI3636@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com> <AANLkTinOMOkY6AUW8Z6FWMMWU9u0_sNjA2r_31u9-A8v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinOMOkY6AUW8Z6FWMMWU9u0_sNjA2r_31u9-A8v@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 09:17:07AM +0100, Linus Walleij wrote:
> 2010/12/23 Dan Williams <dan.j.williams@intel.com>:
> > It looks like this driver needs a full scrub
> > which seems unreasonable to complete and test over the holidays before
> > .37 lands.  Linus we either need to mark this "depends on BROKEN" or
> > revert it.
> 
> Isn't it really as simple as to release the spinlock during callbacks?
> That lock is only intended to protect the plchan variables, not to block
> anyone from queueing new stuff during the callback (as happens now).
> 
> It can release that lock, make a callback where a new descriptor
> gets queued, and then take it again and start looking at the queue,
> at which point it discovers the new desc and process it.

Is it actually safe to do this?  The answer seems to be no - if we happen
to terminate all transfers (as your PL011 uart code does) when we fail to
setup a new DMA transaction, then bad stuff happens due to this:

                /*
                 * Device callbacks should NOT clear
                 * the current transaction on the channel
                 * Linus: sometimes they should?
                 */
                if (!plchan->at)
                        BUG();

We really need a saner approach here - maybe the list approach described
by Jassie.

> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index b605cc9..7879a22 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1651,8 +1651,11 @@ static void pl08x_tasklet(unsigned long data)
>  		/*
>  		 * Callback to signal completion
>  		 */
> -		if (callback)
> -			callback(callback_param);
> +		if (callback) {
> +                        spin_unlock(&plchan->lock);
> +                        callback(callback_param);
> +                        spin_lock(&plchan->lock);

Plus, of course, that tasklets run with IRQs enabled.  This means we're
taking this spinlock in an interruptible context.  If we have some other
path which also takes this lock from an IRQ context, then we're asking
for deadlock.  See my previous mails on this subject.

I'm currently splitting my dirty patch, and attacking this driver to
clean up some of it into a more reasonable shape, so this is one area
which I'm going to be sorting out.

Patches later.

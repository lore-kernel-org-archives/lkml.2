Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0LRBNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:13:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381Ab0LRBNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:13:43 -0500
Date: Fri, 17 Dec 2010 17:13:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 15/16] pps: add parallel port PPS client
Message-Id: <20101217171309.54b695a1.akpm@linux-foundation.org>
In-Reply-To: <20101218035054.2aaac64b@apollo.gnet>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<5aad62a4e5290f8baa5994b227e7fe6edaa7841a.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161756.664b8d8b.akpm@linux-foundation.org>
	<20101218035054.2aaac64b@apollo.gnet>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 03:50:54 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> __ Fri, 17 Dec 2010 16:17:56 -0800
> Andrew Morton <akpm@linux-foundation.org> __________:
> 
> > On Fri, 17 Dec 2010 22:54:39 +0300
> > Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
> > 
> > > Add parallel port PPS client. It uses a standard method for capturing
> > > timestamps for assert edge transitions: getting a timestamp soon after
> > > an interrupt has happened. This is not a very precise source of time
> > > information due to interrupt handling delays. However, timestamps for
> > > clear edge transitions are much more precise because the interrupt
> > > handler continuously polls hardware port until the transition is done.
> > > Hardware port operations require only about 1us so the maximum error
> > > should not exceed this value. This was my primary goal when developing
> > > this client.
> > > Clear edge capture could be disabled using clear_wait parameter.
> > > 
> > > ...
> > >
> > > +/* parport interrupt handler */
> > > +static void parport_irq(void *handle)
> > > +{
> > > +	struct pps_event_time ts_assert, ts_clear;
> > > +	struct pps_client_pp *dev = handle;
> > > +	struct parport *port = dev->pardev->port;
> > > +	unsigned int i;
> > > +	unsigned long flags;
> > > +
> > > +	/* first of all we get the time stamp... */
> > > +	pps_get_ts(&ts_assert);
> > > +
> > > +	if (dev->cw == 0)
> > > +		/* clear edge capture disabled */
> > > +		goto out_assert;
> > > +
> > > +	/* try capture the clear edge */
> > > +	local_irq_save(flags);
> > > +	/* check the signal (no signal means the pulse is lost this time) */
> > > +	if (!signal_is_set(port)) {
> > > +		local_irq_restore(flags);
> > > +		dev_err(dev->pps->dev, "lost the signal\n");
> > > +		goto out_assert;
> > > +	}
> > > +
> > > +	/* poll the port until the signal is unset */
> > > +	for (i = dev->cw; i; i--)
> > > +		if (!signal_is_set(port)) {
> > > +			pps_get_ts(&ts_clear);
> > > +			local_irq_restore(flags);
> > > +			dev->cw_err = 0;
> > > +			goto out_both;
> > > +		}
> > > +	local_irq_restore(flags);
> > 
> > Why is this function paying around with local_irq_save()?  It's unusual
> > and looks buggy because local_irq_save() doesn't stop other CPUs from
> > taking an interrupt and coming in and playing with the "protected" data.
> 
> The idea is to prevent other interrupts on the same processor to
> introduce uncontrolled time lags here. Reading from IO port is known to
> take approximately 1us while other interrupt handlers can probably take
> much more. So I poll the port with locally disabled interrupts to
> ensure that the maximum lag here is 1us. All my experiments show that
> it is in fact very precise this way given that input signal is precise.

Please send along a patch which explains all this to future readers?

> Hmm. Do you want me to rewrite the parport subsystem?

yep!  And page reclaim, writeback and readahead, please.


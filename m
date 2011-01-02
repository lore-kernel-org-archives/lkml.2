Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1ABLXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 06:23:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41584 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1ABLXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 06:23:11 -0500
Date: Sun, 2 Jan 2011 11:22:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20110102112227.GA10355@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com> <20101223001012.GF29368@n2100.arm.linux.org.uk> <AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com> <AANLkTikP+JZkN7AjqaNfHY8jZ7bVsV-af=YR=MTdfnNU@mail.gmail.com> <20101231215018.GB5012@n2100.arm.linux.org.uk> <AANLkTim08yVM2NceT-8tukJNNNG3WUdjPs-7MD9QBV-u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim08yVM2NceT-8tukJNNNG3WUdjPs-7MD9QBV-u@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 01:42:31AM -0800, Dan Williams wrote:
> On Fri, Dec 31, 2010 at 1:50 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Reason for asking is that there's no way at the moment to tell what the
> > expectations are from a lot of the DMA engine support code - and that is
> > _very_ bad news if you want DMA engine drivers to behave the same.
> 
> For the generic offload usage case dma drivers need to present
> consistent behaviour because they are reused generically.
> 
> The slave usages are not generic.  They grew up around wanting to
> reuse dmaengine's channel allocation boilerplate, while maintaining
> architecture-specific (dma driver / slave driver pairing) behaviour.
> Certainly the ->device_prep* methods can be made to present a
> consistent/documented interface.

The device_prep/submit/terminate/pause/resume interface is really what
I was referring to - the behaviour of these needs to be really well
defined otherwise there will be problems.

> >        cookie = dmaengine_submit(desc);
> >        if (dma_submit_error(cookie))
> >                /* what DMA engine cleanup of desc is expected here? */
> 
> dma_submit_error() is something I should have removed after commit
> a0587bcf "ioat1: move descriptor allocation from submit to prep" all
> errors should be notified by prep failing to return a descriptor
> handle.  Negative dma_cookie_t values are only returned by the
> dma_async_memcpy* calls which translate a prep failure into -ENOMEM.

Ok, that means error checking on the dmaengine_submit() result in slave
DMA drivers should be removed - which makes things simpler.

> > Note: I don't trust what's written in 3.3 of async-tx-api.txt, because
> > that seems to be talking about the the async_* APIs rather than the
> > DMA engine API. (see below.)
> >
> > 1. Is it valid to call dmaengine_terminate_all(chan) in those paths?
> >
> > 2. What is the expectations wrt the callback of a previously submitted
> >   job at the point that dmaengine_terminate_all() returns?
> >
> > 3. What if the callback is running on a different CPU, waiting for a
> >   spinlock you're holding at the time you call dmaengine_terminate_all()
> >   within that very same spinlock?
> >
> > 4. What if dmaengine_terminate_all() is running, but parallel with it
> >   the tasklet runs on a different CPU, and queues another DMA job?
> >
> > These can all be solved by requiring that the termination implementations
> > call tasklet_disable(), then clean up the DMA state, followed by
> > tasklet_enable().  tasklet_disable() will prevent the tasklet being
> > scheduled, and wait for the tasklet to finish running before proceeding.
> > This means that (2) becomes "the tasklet will not be running", (3)
> > becomes illegal (due to deadlock), and (4) becomes predictable as we
> > know that after tasklet_disable() we have consistent DMA engine state
> > and we can terminate everything that's been queued.
> >
> 
> This assumes that all submission and completion occurs in tasklet
> context?  I think something is wrong if the terminate_all
> implementation is not taking the channel spinlock or otherwise
> guaranteeing that it is not racing against new submissions and the
> completion tasklet.

I was initially thinking more of the case where we have:

	tasklet->callback->attempted submission of next tx buffer,
		submission failure->terminate_all->tasklet_disable

As tasklet_disable() will wait for the tasklet to finish running, this
results in deadlock.  This is exactly what could happen with the PL011
UART driver's usage of the DMA engine API.  However, as a result of your
comments, I've removed the terminate_all calls in those failure paths as
they're entirely unnecessary.  So that problem is solved.

However, that is not the only place where this can happen:

CPU0		CPU1
		takes slave driver spinlock
tasklet
callback
spins on slave driver spinlock
		terminate_all
		tasklet_disable

That also leads to deadlock - and again is something still to be solved
between the PL011 UART driver and PL08x DMA driver.

This scenario also applies if you do similar things in the DMA engine
driver.  Most DMA engine drivers take a spinlock within their tasklet.

CPU0		CPU1
		terminate_all
tasklet
		takes DMA engine driver spinlock
spins on DMA engine driver spinlock
		tasklet_disable

So... beware of DMA engine drivers which use tasklet_disable() in their
terminate_all path!  (Maybe this should be a no-no.)

> > Almost no one checks the result of dmaengine_submit() (or its open-coded
> > equivalent).  Are all such drivers potentially leaking descriptors?  If
> > not, how are the failed descriptors re-used?
> 
> As per above, submit must fail if prep succeeds.

I think you mean "submit must succeed if prep succeeds".

> > What should be the initial value of tx->cookie after a successful
> > prep_slave_sg() call?
> 
> Drivers are using -EBUSY to indicate descriptor is in the process of
> being submitted.

Ok, so that's something else which needs fixing in PL08x.

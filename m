Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2BPTJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:09:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:58971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2BPTJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:09:26 -0500
Date: Thu, 16 Feb 2012 20:09:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
In-Reply-To: <20120216150139.GA16634@srcf.ucam.org>
Message-ID: <alpine.LFD.2.02.1202161946530.2794@ionos>
References: <20120215145225.GA21448@srcf.ucam.org> <alpine.LFD.2.02.1202152059230.2794@ionos> <20120215202221.GA29552@srcf.ucam.org> <alpine.LFD.2.02.1202152125500.2794@ionos> <20120215203814.GA29795@srcf.ucam.org> <alpine.LFD.2.02.1202152140110.2794@ionos>
 <20120215204757.GA30275@srcf.ucam.org> <20120216142733.GA15632@srcf.ucam.org> <20120216143132.293c8f50@pyramind.ukuu.org.uk> <1329403876.2293.232.camel@twins> <20120216150139.GA16634@srcf.ucam.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Matthew Garrett wrote:

> On Thu, Feb 16, 2012 at 03:51:16PM +0100, Peter Zijlstra wrote:
> > On Thu, 2012-02-16 at 14:31 +0000, Alan Cox wrote:
> > > In historical Unix sleep(0) ends up the nearest equivalent it had to
> > > triggering a reschedule and giving up the rest of the timeslice.
> > > 
> > > I suspect special casing it as yield() isn't far from the right result ?
> > 
> > But why go that way? Using sleep(0) or yield() is pretty much always the
> > wrong thing to do anyway, this is a great opportunity for all folks to
> > find these sites and fix them.
> > 
> > Wasn't that what open-source is all about, doing the right thing?
> 
> Doing the right thing if practical. How about we special-case for now 
> with a once-per-process printk and kill it further down the line?

We've done this for stuff which was once kinda guaranteed
(intentionally or not), but sleep(0) has never had any guarantee
whatsoever. Quite the contrary it changed its behaviour several times
over the last decades and there is no reason to manifest some weird
ass semantics now.

> > Why should we care about obviously broken crap?
> > 
> > Furthermore, pushing slack to several seconds will also break stuff that
> > needed those timers to expire sooner, who is going to fix that?
> 
> The reason to change timer slack is because we're willing to break 
> polling applications in order to gain power savings. The problem is that 
> there are event-driven applications that are also going to be broken 
> because some ridiculous proportion of userspace believes that sleep(0) 
> is a thing that they can do in an event-driven application. The question 

If we are willing to break polling crap, then there is no fricking
reason not to break lousy programmed "event driven" crap while we are
at it.

> is whether the cost of special-casing that in the kernel is more than 
> fixing all of them.

The cost of special casing stuff is maintainence, inconsistance of
interfaces and extended confusion. And each of that is worse than
breaking some (i.e. 1% of the total app stack out there) weirdo apps.

> > What's next, we're actually going to give people their O_PONIES?
> 
> If we could give people O_PONIES then why wouldn't we? The only reason 
> not to is because it costs too much elsewhere.

Wrong. The reason is that O_PONIES is impossible to define and that's
equally true for any exception to the (nano)sleep interface.

Thanks,

	tglx

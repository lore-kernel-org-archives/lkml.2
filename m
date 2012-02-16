Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2BPPBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:01:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59766 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2BPPBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:01:53 -0500
Date: Thu, 16 Feb 2012 15:01:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120216150139.GA16634@srcf.ucam.org>
References: <20120215145225.GA21448@srcf.ucam.org>
 <alpine.LFD.2.02.1202152059230.2794@ionos>
 <20120215202221.GA29552@srcf.ucam.org>
 <alpine.LFD.2.02.1202152125500.2794@ionos>
 <20120215203814.GA29795@srcf.ucam.org>
 <alpine.LFD.2.02.1202152140110.2794@ionos>
 <20120215204757.GA30275@srcf.ucam.org>
 <20120216142733.GA15632@srcf.ucam.org>
 <20120216143132.293c8f50@pyramind.ukuu.org.uk>
 <1329403876.2293.232.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329403876.2293.232.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 03:51:16PM +0100, Peter Zijlstra wrote:
> On Thu, 2012-02-16 at 14:31 +0000, Alan Cox wrote:
> > In historical Unix sleep(0) ends up the nearest equivalent it had to
> > triggering a reschedule and giving up the rest of the timeslice.
> > 
> > I suspect special casing it as yield() isn't far from the right result ?
> 
> But why go that way? Using sleep(0) or yield() is pretty much always the
> wrong thing to do anyway, this is a great opportunity for all folks to
> find these sites and fix them.
> 
> Wasn't that what open-source is all about, doing the right thing?

Doing the right thing if practical. How about we special-case for now 
with a once-per-process printk and kill it further down the line?

> Why should we care about obviously broken crap?
> 
> Furthermore, pushing slack to several seconds will also break stuff that
> needed those timers to expire sooner, who is going to fix that?

The reason to change timer slack is because we're willing to break 
polling applications in order to gain power savings. The problem is that 
there are event-driven applications that are also going to be broken 
because some ridiculous proportion of userspace believes that sleep(0) 
is a thing that they can do in an event-driven application. The question 
is whether the cost of special-casing that in the kernel is more than 
fixing all of them.

> So we've got a stacking of two ill-considered things:
>  - applications using yield()/sleep(0)
>  - weirdos pushing timer slack to the seconds range
> 
> Individually both cause/are borkage, and now you want to add code to the
> kernel to mitigate some, but nowhere near all, of it?
> 
> What's next, we're actually going to give people their O_PONIES?

If we could give people O_PONIES then why wouldn't we? The only reason 
not to is because it costs too much elsewhere.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

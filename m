Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab2CTP2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:28:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33060 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077Ab2CTP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:28:28 -0400
Date: Tue, 20 Mar 2012 11:23:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120320152354.GB29135@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
 <1328894901.25989.20.camel@laptop>
 <20120210190412.GB12975@phenom.dumpdata.com>
 <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
 <20120212205016.GA2794@asmodeus>
 <20120215085737.GA13722@asmodeus>
 <1329297944.2293.36.camel@twins>
 <20120215161741.GC4093@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215161741.GC4093@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F68A210.00BF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 11:17:41AM -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Feb 15, 2012 at 10:25:44AM +0100, Peter Zijlstra wrote:
> > On Wed, 2012-02-15 at 00:57 -0800, Steven Noonan wrote:
> > > It seems to me that there are two options for fixing this, but I'm
> > > probably lacking the necessary context (or experience with Xen). Either:
> > > 
> > > - The patch provided by Ben needs to have additional work to specially
> > >   handle IRQ_WORK_VECTOR, since it seems to be a special case where
> > >   there's no event channel attached for it. Perhaps adding an event
> > >   channel for this is the fix? Seems high-overhead, but I lack a good
> > >   understanding of how interrupts are handled in Xen.
> > 
> > So that's a self-IPI, is Xen failing to implement this?
> 
> It does have self-IPIs.
> > 
> > > or
> > > 
> > > - Perf needs to be "enlightened" about Xen and avoid sending an IPI in
> > >   the first place.
> > 
> > Uhm, no. If anything Xen should simply not implement
> > arch_irq_work_raise(). The callbacks are then ran from the timer
> > interrupt.
> 
> Looks like that wouldn't be too difficult - meaning implement a similar
> form of IRQ_WORKER that would call
> 
>  inc_irq_stat(apic_irq_work_irqs);
>  irq_work_run();
> 
> .. along with the rest of the stuff from Ben's patch. Let me see if I can
> prep a patch.

Peter,

I am going to start cracking at this to see why the self-IPI don't seem to
work, while the patch that was removed (so the NMI, would just check on its
own CPU whether it was called without doing the NMI).

But in the meantime, are there any good docs to look over to get a good idea
of how the perf code works?

Thanks.

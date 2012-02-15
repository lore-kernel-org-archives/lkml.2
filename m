Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2BORS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:18:27 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:22239 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2BORS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:18:26 -0500
Date: Wed, 15 Feb 2012 12:14:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Noonan <steven@uplinklabs.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ben Guthro <ben@guthro.net>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120215171459.GA8337@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
 <1328894901.25989.20.camel@laptop>
 <20120210190412.GB12975@phenom.dumpdata.com>
 <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
 <20120212205016.GA2794@asmodeus>
 <20120215085737.GA13722@asmodeus>
 <1329297944.2293.36.camel@twins>
 <20120215093204.GA17286@asmodeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215093204.GA17286@asmodeus>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F3BE8D2.0135,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 01:32:04AM -0800, Steven Noonan wrote:
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
> Yes.
> 
> Ben's patch implements it, but it explodes (NULL pointer dereference)
> when it can't find an event channel for IRQ_WORK_VECTOR.

Actually there is an existing self-IPI framework so that any of the smp_call_*
end up IPI-ing other CPUs and that seems to work OK.

 274:        700          0          0          0          0          0  xen-percpu-ipi       callfunc0
 276:      15184          0          0          0          0          0  xen-percpu-ipi       callfuncsingle0
 279:          0        275          0          0          0          0  xen-percpu-ipi       callfunc1
 281:          0       8686          0          0          0          0  xen-percpu-ipi       callfuncsingle1
 284:          0          0        754          0          0          0  xen-percpu-ipi       callfunc2
 286:          0          0       4968          0          0          0  xen-percpu-ipi       callfuncsingle2
 289:          0          0          0        751          0          0  xen-percpu-ipi       callfunc3
 291:          0          0          0      19224          0          0  xen-percpu-ipi       callfuncsingle3
 294:          0          0          0          0        761          0  xen-percpu-ipi       callfunc4
 296:          0          0          0          0      21893          0  xen-percpu-ipi       callfuncsingle4
 299:          0          0          0          0          0        750  xen-percpu-ipi       callfunc5
 301:          0          0          0          0          0      10362  xen-percpu-ipi       callfuncsingle5
 CAL:      15886       8981       5724      19977      22657      11114   Function call interrupts

So even without Ben's patch it should have worked. I am not actually sure
why it decided to just sit there. Looking at it, the IPI on both native
and xen would end up calling: generic_smp_call_function_single_interrupt()
from their respective single-IPI interrupt handlers.

Jeremy, was there any difficulities when IPI oneself?

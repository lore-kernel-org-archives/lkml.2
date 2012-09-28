Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2I1P5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:57:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51521 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2I1P5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:57:49 -0400
Date: Fri, 28 Sep 2012 16:57:46 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>, Rob Landley <rob@landley.net>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 RESEND 2/2] ARM: local timers: add timer support using
 IO mapped register
Message-ID: <20120928155746.GB2253@linaro.org>
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
 <1347694914-1457-2-git-send-email-rvaswani@codeaurora.org>
 <5062013F.8050507@codeaurora.org>
 <20120928122858.GD9472@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928122858.GD9472@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Note: please aim to CC devicetree-discuss@lists.ozlabs.org with any
patches or bindings relevant to device tree. ]

[ Lorenzo, there's a question for you further down this mail. ]

On Fri, Sep 28, 2012 at 01:28:58PM +0100, Mark Rutland wrote:
> On Tue, Sep 25, 2012 at 08:08:47PM +0100, Rohit Vaswani wrote:
> > Any comments ?
> 
> I have a few questions about the irq side of things.
> 
> > > diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> > > index 52478c8..8e01328 100644
> > > --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> > > +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> > > @@ -7,10 +7,13 @@ The timer is attached to a GIC to deliver its per-processor interrupts.
> > >
> > >   ** Timer node properties:
> > >
> > > -- compatible : Should at least contain "arm,armv7-timer".
> > > +- compatible : Should at least contain "arm,armv7-timer" or
> > > +  "arm,armv7-timer-mem" if using the memory mapped arch timer interface.
> > >
> > > -- interrupts : Interrupt list for secure, non-secure, virtual and
> > > -  hypervisor timers, in that order.
> > > +- interrupts : If using the cp15 interface, the interrupt list for secure,
> > > +  non-secure, virtual and hypervisor timers, in that order.

We should use the correct architectural terms for documenting these.
For example, "non-secure" requires qualification.

If I understand the ARM ARM correctly, the architectural names are

 * Secure PL1 physical
 * Non-secure PL2 physical
 * Non-secure PL1 physical
 * Virtual

[...]

> What privilege level are the interrupts for the memory-mapped interface?
> 
> Could each core have multiple interrupts at different privilege levels?
> 
> I also notice we don't seem to handle the case of systems without security
> extensions, which only have physical and virtual interrupts. If we're adding
> support for different interrupt setups, how do we handle them?

Agreed, some of the timers will be absent depending on the architectural
options implemented by the processor.

Also, timers not visible to / usable by the kernel being booted should
probably left out of the DT, even though the hardware may physically have
them:

For example, a guest should not see the Secure PL1 physical timer or the
Non-secure PL2 physical timer.  A hypervisor or host OS which does not
provide the guest with access to the Non-secure PL1 physical timer (such
as KVM) should leave that out too: there is no exception-free way for
the OS to probe that directly: i.e., from the guest's point of view the
device doesn't exist at all, so it seems wrong for the DT to include them
in this case.


[...]

> > > +  If using the memory mapped interface, list the interrupts for each core,
> > > +  starting with core 0.
> 
> I take it that core 0 means physical cpu 0 (i.e. MPIDR.Aff{2,1,0} == 0)?

Lorenzo, should we have a standard way of referring to CPUs and topology
nodes documented as part of the topology bindings?  We certainly need
rules of some kind, since when the topology is non-trivial there is no
well-defined "first" CPU, nor any single correct order in which to list
CPUs.

The topology may also be sparsely populated (e.g.,
Aff[2,1,0] in { (0,0,0), (0,0,1), (0,1,0), (0,1,1), (0,1,2), (0,1,3) })

It would be bad if different driver bindings end up solving this in
different ways (even non-broken ways)

Cheers
---Dave

[...]

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1EFOFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:05:00 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:1936 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1EFOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:04:59 -0400
X-IronPort-AV: E=Sophos;i="4.64,326,1301875200"; 
   d="scan'208";a="5638685"
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <alpine.LFD.2.02.1105061505010.3005@ionos>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1105061149330.3005@ionos>
	 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1105061505010.3005@ionos>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 6 May 2011 15:04:57 +0100
Message-ID: <1304690697.26692.176.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 14:24 +0100, Thomas Gleixner wrote:
> On Fri, 6 May 2011, Tian, Kevin wrote:
> > > From: Thomas Gleixner
> > > Sent: Friday, May 06, 2011 6:00 PM
> > > 
> > > On Fri, 6 May 2011, Tian, Kevin wrote:
> > > > x86: don't unmask disabled irqs when migrating them
> > > >
> > > > it doesn't make sense to mask/unmask a disabled irq when migrating it
> > > > from offlined cpu to another, because it's not expected to handle any
> > > > instance of it. Current mask/set_affinity/unmask steps may trigger
> > > > unexpected instance on disabled irq which then simply bug on when
> > > > there is no handler for it. One failing example is observed in Xen.
> > > > Xen pvops
> > > 
> > > So there is no handler, why the heck is there an irq action?
> > > 
> > > 	  if (!irq_has_action(irq) ....
> > > 	     	continue;
> > > 
> > > Should have caught an uninitialized interrupt. If Xen abuses interrupts that way,
> > > then it rightfully explodes. And we do not fix it by magic somewhere else.
> > 
> > sorry that my bad description here. there does be a dummy handler registered
> > on such irqs which simply throws out a BUG_ON when hit. I should just say such 
> > injection is not expected instead of no handler. :-)
> 
> So can please someone point me to that particular incarnation of
> nonsense and provide a reasonable explanation for this abuse?
> 
> What is the point of an interrupt, which is permanently disabled, has
> a handler with a BUG() inside and an irqaction assigned ?
> 
> What's the purpose of this? Why is the irqaction there in the first
> place? To be called by some other weird means than by the irq
> handling code?

The Xen PV spinlock code (arch/x86/xen/spinlock.c) allocates an IRQ
(per-cpu lock_kicker_irq). I think it is there purely in order to have
the associated underlying evtchn to use as the thing to poll (Xen has an
evtchn poll hypercall, see xen_poll_irq()) on the slow path and kick on
release. There is never any need to call a handler for that evtchn --
just notifying the evtchn is enough to wake the poller.

The irq is setup using request_irq(). Is there a different API to
register an IRQ without attaching a handler/action to it? (I can't think
why such a thing would exist).

I'm not really sure why these can't just be an evtchn without an
associated IRQ since it doesn't really have any interrupt-like
semantics. Perhaps just a general desire to keep event channels
abstracted into the core Xen event subsystem with IRQs as the public
facing API? Jeremy?

Ian.

> > > The only conditional which is interesting is the unmask path and that's a simple
> > > optimization and not a correctness problem.
> > > 
> > 
> > So what's your suggestion based on my updated information? Is there any
> > interface I may take to differentiate above exception with normal case? Basically
> > in Xen usage we want such irqs permanently disabled at the chip level. Or
> > could we only do mask/unmask for irqs which are unmasked atm if as you said
> > it's just an optimization step? :-)
> 
> No we can make the unmask conditional on !irqd_irq_disabled() because
> that's not violating any of the semantics. The interrupt would be
> masked anyway when it arrives and the handler code sees that it is
> lazy disabled. I mean real handler code, not the Xen abomination.
> 
> The only valid reason why I'd apply that patch is that it avoids a
> potential extra interrupt, but not to prevent screwed up handlers from
> exploding.
> 
> Thanks,
> 
> 	tglx



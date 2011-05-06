Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1EFMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:54:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:2538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab1EFMyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:54:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,326,1301900400"; 
   d="scan'208";a="431696542"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Fri, 6 May 2011 20:54:39 +0800
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwL1GyqnvmzZBFoTHyj0RqABKyCfgAE23UA
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105061149330.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1105061149330.3005@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner
> Sent: Friday, May 06, 2011 6:00 PM
> 
> On Fri, 6 May 2011, Tian, Kevin wrote:
> > x86: don't unmask disabled irqs when migrating them
> >
> > it doesn't make sense to mask/unmask a disabled irq when migrating it
> > from offlined cpu to another, because it's not expected to handle any
> > instance of it. Current mask/set_affinity/unmask steps may trigger
> > unexpected instance on disabled irq which then simply bug on when
> > there is no handler for it. One failing example is observed in Xen.
> > Xen pvops
> 
> So there is no handler, why the heck is there an irq action?
> 
> 	  if (!irq_has_action(irq) ....
> 	     	continue;
> 
> Should have caught an uninitialized interrupt. If Xen abuses interrupts that way,
> then it rightfully explodes. And we do not fix it by magic somewhere else.

sorry that my bad description here. there does be a dummy handler registered
on such irqs which simply throws out a BUG_ON when hit. I should just say such 
injection is not expected instead of no handler. :-)

> 
> > guest marks a special type of irqs as disabled, which are simply used
> 
> As I explained before several times, IRQF_DISABLED has absolutely nothing to
> do with it and pvops _CANNOT_ mark an interrupt disabled.

I have to admit that I need more study about whole interrupt sub-system, to better
understand your explanation here. Also here again my description is not accurate
enough. I meant that Xen pvops request the special irq with below flags:
	IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING
and then later explicitly disable it with disable_irq(). As you said that IRQF_DISABLED
itself has nothing to do with it, and it's the later disable_irq() which takes real 
effect because Xen event chip hooks this callback to mask the irq from the chip level.

> 
> >
> >  		chip = irq_data_get_irq_chip(data);
> > -		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
> > +		do_mask = !irqd_irq_disabled(data) &&
> > +			!irqd_can_move_in_process_context(data) && chip->irq_mask;
> > +		if (do_mask)
> >  			chip->irq_mask(data);
> 
> This is completely wrong. irqd_irq_disabled() is a status information which does
> not tell you whether the interrupt is actually masked at the hardware level
> because we do lazy interrupt hardware masking. So your change would keep
> the line unmasked at the hardware level for all interrupts which are in the lazy
> disabled state.

Got it.

> 
> The only conditional which is interesting is the unmask path and that's a simple
> optimization and not a correctness problem.
> 

So what's your suggestion based on my updated information? Is there any
interface I may take to differentiate above exception with normal case? Basically
in Xen usage we want such irqs permanently disabled at the chip level. Or
could we only do mask/unmask for irqs which are unmasked atm if as you said
it's just an optimization step? :-)
 

Thanks
Kevin


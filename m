Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1EFBMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:12:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:63766 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1EFBMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:12:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,323,1301900400"; 
   d="scan'208";a="431442548"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>
Date: Fri, 6 May 2011 09:12:37 +0800
Subject: RE: [PATCH] x86: skip migrating percpu irq in fixup_irqs
Thread-Topic: [PATCH] x86: skip migrating percpu irq in fixup_irqs
Thread-Index: AcwLB5MndYVUnZuiQCuR8J2thl8z1AAgl2ew
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F574@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F327@shsmsx502.ccr.corp.intel.com>
 <1304585343.26692.71.camel@zakaz.uk.xensource.com>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F3A9@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105051108320.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1105051108320.3005@ionos>
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

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Thursday, May 05, 2011 5:34 PM
> 
> On Thu, 5 May 2011, Tian, Kevin wrote:
> > > From: Ian Campbell [mailto:Ian.Campbell@eu.citrix.com]
> > > Sent: Thursday, May 05, 2011 4:49 PM
> > >
> > > On Thu, 2011-05-05 at 09:15 +0100, Tian, Kevin wrote:
> > > > x86: skip migrating percpu irq in fixup_irqs
> > > >
> > > > IRQF_PER_CPU is used by Xen for a set of virtual interrupts
> > > > binding to a specific vcpu, but it's not recognized in fixup_irqs
> > > > which simply atempts to migrate it to other vcpus. In most cases
> > > > this just works, because Xen event channel chip silently fails the
> > > > set_affinity ops for irqs marked as IRQF_PER_CPU. But there's a
> > > > special category (like used for pv spinlock) also adds a
> > > > IRQ_DISABLED flag, used as polled only
> 
> I guess you mean IRQF_DISABLED, right?

yes. :-)

> 
> > > > event channels which don't expect any instance injected. However
> > > > fixup_irqs absolutely masks/unmasks irqs which makes such special
> > > > type irq injected unexpectely while there's no handler for it.
> 
> IRQF_DISABLED has absolutely nothing to do with polling and mask/unmask.
> IRQF_DISABLED is actually a NOOP and totally irrelevant.

this is just due to the way how Xen pvops implements the event polling, with
corresponding irq marked as both IRQF_PER_CPU and IRQ_DISABLED. This
way when the event polled by the pvops guest comes, Xen simply resumes
the guest at next instruction after the poll hypercall but no need to make this
instance aware into the guest.

> 
> > > > This error is triggered on some box when doing reboot. The fix is
> > > > to recognize IRQF_PER_CPU flag early before the affinity change,
> > > > which actually matches the rationale of IRQF_PER_CPU.
> > >
> > > Skipping affinity fixup for PER_CPU IRQs seems logical enough (so I
> > > suspect this patch is good in its own right) but if the real issue
> > > you are fixing is that IRQ_DISABLED IQRs are getting unmasked should
> > > that issue be addressed directly rather than relying on it being a side-effect
> of PER_CPU-ness?
> >
> > actually this is one thing I'm not sure and would like to hear more
> suggestions.
> > imo affinity and percpu are same type of attributes, which describe
> > the constraints to host a given irq, while disabled/masked are another
> > type of
> 
> They are similar, but percpu says explicitely: This interrupt can never be moved
> away from the cpu it is bound to. Affinity ist just the current binding which is
> allowed to be changed.

yes.

> 
> > attributes which describe whether to accept an irq instance (mask is
> > for short period). even without the IRQ_DISABLED issue, this patch is
> > also required though it doesn't expose observable failure. I didn't
> > bake the 2nd patch to avoid unmask for IRQ_DISABLED, because I want to
> > know whether this is desired, e.g. IRQ_DISABLED is set in the fly when
> > there can be still one instance pending?
> 
> What you probably mean is the core internal disabled state of the interrupt line.
> Yes, we should not unmask such interrupts in the fixup move.
> 

OK, I'll send an updated patch to cover both IRQF_PER_CPU and IRQF_DISABLED
case.

Thanks
Kevin

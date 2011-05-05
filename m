Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1EEJeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:34:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:52833 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1EEJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:34:04 -0400
Date: Thu, 5 May 2011 11:33:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Tian, Kevin" <kevin.tian@intel.com>
cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>
Subject: RE: [PATCH] x86: skip migrating percpu irq in fixup_irqs
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F3A9@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1105051108320.3005@ionos>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F327@shsmsx502.ccr.corp.intel.com> <1304585343.26692.71.camel@zakaz.uk.xensource.com> <625BA99ED14B2D499DC4E29D8138F1505C8ED7F3A9@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Tian, Kevin wrote:
> > From: Ian Campbell [mailto:Ian.Campbell@eu.citrix.com]
> > Sent: Thursday, May 05, 2011 4:49 PM
> > 
> > On Thu, 2011-05-05 at 09:15 +0100, Tian, Kevin wrote:
> > > x86: skip migrating percpu irq in fixup_irqs
> > >
> > > IRQF_PER_CPU is used by Xen for a set of virtual interrupts binding to
> > > a specific vcpu, but it's not recognized in fixup_irqs which simply
> > > atempts to migrate it to other vcpus. In most cases this just works,
> > > because Xen event channel chip silently fails the set_affinity ops for
> > > irqs marked as IRQF_PER_CPU. But there's a special category (like used
> > > for pv spinlock) also adds a IRQ_DISABLED flag, used as polled only

I guess you mean IRQF_DISABLED, right?

> > > event channels which don't expect any instance injected. However
> > > fixup_irqs absolutely masks/unmasks irqs which makes such special type
> > > irq injected unexpectely while there's no handler for it.

IRQF_DISABLED has absolutely nothing to do with polling and
mask/unmask. IRQF_DISABLED is actually a NOOP and totally irrelevant.

> > > This error is triggered on some box when doing reboot. The fix is to
> > > recognize IRQF_PER_CPU flag early before the affinity change, which
> > > actually matches the rationale of IRQF_PER_CPU.
> > 
> > Skipping affinity fixup for PER_CPU IRQs seems logical enough (so I suspect this
> > patch is good in its own right) but if the real issue you are fixing is that
> > IRQ_DISABLED IQRs are getting unmasked should that issue be addressed
> > directly rather than relying on it being a side-effect of PER_CPU-ness?
> 
> actually this is one thing I'm not sure and would like to hear more suggestions.
> imo affinity and percpu are same type of attributes, which describe the 
> constraints to host a given irq, while disabled/masked are another type of

They are similar, but percpu says explicitely: This interrupt can
never be moved away from the cpu it is bound to. Affinity ist just the
current binding which is allowed to be changed.

> attributes which describe whether to accept an irq instance (mask is for
> short period). even without the IRQ_DISABLED issue, this patch is also 
> required though it doesn't expose observable failure. I didn't bake the 2nd
> patch to avoid unmask for IRQ_DISABLED, because I want to know whether
> this is desired, e.g. IRQ_DISABLED is set in the fly when there can be still
> one instance pending?

What you probably mean is the core internal disabled state of the
interrupt line. Yes, we should not unmask such interrupts in the fixup
move.

Thanks,

	tglx

 

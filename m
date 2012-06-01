Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab2FASFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:05:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab2FASFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:05:35 -0400
Message-ID: <1338573558.23475.41.camel@bling.home>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Fri, 01 Jun 2012 11:59:18 -0600
In-Reply-To: <4FC8F867.7080103@siemens.com>
References: <20120601161521.26935.25606.stgit@bling.home>
	  <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>
	 <4FC8F867.7080103@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 19:14 +0200, Jan Kiszka wrote:
> On 2012-06-01 19:03, Alex Williamson wrote:
> > On Fri, 2012-06-01 at 18:39 +0200, Jan Kiszka wrote:
> >> On 2012-06-01 18:16, Alex Williamson wrote:
> >>> The kernel no longer allows us to pass NULL for a hard interrupt
> >>> handler without IRQF_ONESHOT.  Should have been using this flag
> >>> anyway.
> >>
> >> This make the IRQ handling tail a bit slower (due to
> >> irq_finalize_oneshot). MSIs are edge-triggered, so there was no need for
> >> masking in theory.
> > 
> > Aren't these asynchronous since we can theoretically do
> > irq_finalize_oneshot while the guest is servicing the device?
> 
> If it runs on a different CPU. But usually it's more efficient to have
> handler and user on the same CPU. And this work has to be processed
> somewhere.

Yes we need more CPUs and it's better to not do work if we don't have
to.  I don't want to go off on too much of a tangent, but I'm not
entirely convinced that host to guest handler locality is all that
important.  There's just not enough touched by the host handler to make
much difference.  Guest handler and guest user locality is obviously
important, just as it is on bare metal.

> >>  Hmm, can't we trust the information that an IRQ
> >> grabbed here is really a MSI type?
> > 
> > 
> > Apparently not, comment added with this check (1c6c6952):
> > 
> >        * The interrupt was requested with handler = NULL, so
> >        * we use the default primary handler for it. But it
> >        * does not have the oneshot flag set. In combination
> >        * with level interrupts this is deadly, because the
> >        * default primary handler just wakes the thread, then
> >        * the irq lines is reenabled, but the device still
> >        * has the level irq asserted. Rinse and repeat....
> >        *
> >        * While this works for edge type interrupts, we play
> >        * it safe and reject unconditionally because we can't
> >        * say for sure which type this interrupt really
> >        * has. The type flags are unreliable as the
> >        * underlying chip implementation can override them.
> 
> I was talking about KVM here: Can't the KVM device assignment code
> ensure that only MSIs are registered as such so that the above concerns
> no longer apply?

Is that making assumptions about how the chipset handles an MSI?  Are
you suggesting we need a request_edge_threaded_only_irq() API?  Thanks,

Alex




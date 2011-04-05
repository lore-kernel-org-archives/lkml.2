Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1DELwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 07:52:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:19721 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1DELwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 07:52:11 -0400
X-IronPort-AV: E=Sophos;i="4.63,303,1299456000"; 
   d="scan'208";a="5144273"
Date: Tue, 5 Apr 2011 12:53:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: do not clear and mask evtchns in
 __xen_evtchn_do_upcall
In-Reply-To: <1301993495.23887.128.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1104051228280.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103291505090.16492@kaball-desktop>  <20110330154630.GA17427@dumpdata.com>  <alpine.DEB.2.00.1104041521370.16492@kaball-desktop> <1301993495.23887.128.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, Ian Campbell wrote:
> Since this patch revolves around the interaction with the irq core I
> think it would be worth running it by tglx as well as xen-devel for the
> next iteration.
> 

Yes, I'll do that.


> Does something about the switch of handler type fix the issue with
> drivers which call disable_irq() in their interrupt handler and leave it
> disabled until a later time? (e.g. the userspace evtchn driver). I think
> I know why this is the case but it would be useful to mention in the
> commit message.

Yep, I added a note in the commit message:

"it fixes a problem occurring when a driver calls disable_irq() in its
handler: the old code was unconditionally unmasking the evtchn even if
the irq is disabled when irq_eoi was called"


> On Mon, 2011-04-04 at 17:46 +0100, Stefano Stabellini wrote:
> > 
> >     - it uses these handlers in the same way Linux would use them: it let
> >     Linux mask\unmask and ack the irq when Linux want to mask\unmask and ack
> >     the irq;
> 
> This code is in Linux, perhaps you mean "the same way native code would
> use them" or "with the semantics which the generic code defines" or
> something along those lines.

good point


> > +       pirq_query_unmask(irq);
> > +       /* we try to follow the same convention as Linux on native:
> 
> That's basically a coincidence, isn't it?
> 
> What we are actually trying to do is use the handler with the
> appropriate semantics for the type of interrupt, e.g. event channels are
> naturally edge triggered but some event channels can be bound to pirqs
> with configurations that require an EOI and therefore have a level of
> levelness about them.

I completely rewrote the paragraph, adding many more details, including
the Xen side of the interface.

> 
> > +        * handle_edge_irq for edge irqs and handle_fasteoi_irq for level
> > +        * irqs
> 
> should probably mention the relationship between pirq_needs_eoi=>level
> triggering.

done.


> Is there any relationship between pirq_needs_eoi and the trigger value
> passed to PHYSDEVOP_setup_gsi at setup time?

PHYSDEVOP_setup_gsi tells Xen the trigger value of the physical
interrupt, depending on this value Xen will handle the interrupt
differently. Besides Xen used to set the need_eoi flag of the
corresponding irq depending on the real trigger value of the underlying
physical interrupt, but it doesn't anymore.

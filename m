Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1DELSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 07:18:16 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:15068 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1DELSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 07:18:15 -0400
X-IronPort-AV: E=Sophos;i="4.63,303,1299456000"; 
   d="scan'208";a="5143510"
Date: Tue, 5 Apr 2011 12:19:27 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: do not clear and mask evtchns in
 __xen_evtchn_do_upcall
In-Reply-To: <20110404171739.GA15070@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1104051211420.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103291505090.16492@kaball-desktop> <20110330154630.GA17427@dumpdata.com> <alpine.DEB.2.00.1104041521370.16492@kaball-desktop> <20110404171739.GA15070@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011, Konrad Rzeszutek Wilk wrote:
> > I reworded this part of the commit message, see below updated patch.
> > 
> [looking]
> .. snip..
> > > Can you expand? As in for the GSI? Or for the MSI/MSI-X?
> > 
> > Linux on native would use handle_edge_irq for edge irqs and msis, and
> > handle_fasteoi_irq for everything else.
> 
> What about per_cpu one?
> 

That is the simplest case, we are already using the same semantic as in
the native code.


> > > OK. You need a big comment about this in the code. Explain
> > > why this is happening. B/c if you look at this from code
> > > it seems like wrong thing to do for gsi's (as in you would
> > > think handle_level_irq would the right choice).
> > 
> > Except handle_level_irq is not used anymore anywhere in the kernel, give
> > a look at arch/x86/kernel/apic/io_apic.c:ioapic_register_intr.
> 
> 'make_8259A_irq' ? But yeah, I don't think we will hit machines with
> that architecture anymore.

Actually I was looking at:

setup_IO_APIC_irqs -> __io_apic_setup_irqs -> io_apic_setup_irq_pin



> > Updated patch, rebased on 2.6.39-rc1 follows:
> > 
> > ---
> > 
> > 
> > commit 6978531913b45abf3aff048475a2174a2cdaf288
> > Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Date:   Tue Mar 29 14:15:06 2011 +0000
> > 
> >     xen: do not clear and mask evtchns in __xen_evtchn_do_upcall
> >     
> >     Change the irq handler of virqs and pirqs that don't need EOI (pirqs
> >     that correspond to physical edge interrupts) to handle_edge_irq.
> >     
> >     Use handle_fasteoi_irq for pirqs that need eoi (they generally
> >     correspond to level triggered irqs), no risk in loosing interrupts
> >     because we have to EOI the irq anyway.
> >     
> >     This change has the following benefits:
> >     
> >     - it uses the very same handlers that Linux would use on native for the
> >     same irqs (handle_edge_irq for edge irqs and msis, and
>                                                    ^^^-'MSIs/MSI-Xs'
> >     handle_fasteoi_irq for everything else);
> >     
> >     - it uses these handlers in the same way Linux would use them: it let
>                                                                            ^- 's'
> 
> >     Linux mask\unmask and ack the irq when Linux want to mask\unmask and ack
>                                                        ^- 's'
> >     the irq;
> >     
> >     See genericirq in the kernel docbook docs for more informations.
> 
> Say 'Documentation/DocBook/genericirq.tmpl'
> 
> [edit: The patch looks OK to me, but let me think about this some more over this
> week and sketch out the flow].

done


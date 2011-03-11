Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1CKOaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:30:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56144 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1CKOaV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 11 Mar 2011 09:30:21 -0500
Date: Fri, 11 Mar 2011 09:29:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [GIT PATCH v2 0/14] xen: events: cleanups +
 ween off nr_irqs
Message-ID: <20110311142954.GC4880@dumpdata.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
 <20110310225726.GA2983@dumpdata.com>
 <1299834774.17339.1799.camel@zakaz.uk.xensource.com>
 <1299842689.17339.1986.camel@zakaz.uk.xensource.com>
 <1299850128.17339.2007.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299850128.17339.2007.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D7A31F5.0104,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I am having difficulties with passthrough of an USB device. Somehow the
> > > > irq count is not going up at all (both in dom0 and domU) and it looks to
> > > > be doing just simple polling. I've rebased the xen-pciback to be on top
> > > > of your changes and apply cleanly. The whole lot is now in #master
> > > > 
> > > > MSI and MSI-X devices work just fine in both Dom0 and DomU case so
> > > > it is something special with the legacy IRQs. Probably forgot something
> > > > simple...
> > > 
> > > Thanks, I'll take a look. Did you mean "legacy IRQ" as in <16 or as in
> > > not-MSI(-X)?

not-MSI(-X) ones. I've this fancy LSI 1030 controller that sits at GSI 46 on this
SuperMicro board and it is quite confused.
> > 
> > Works for me in a PV guest, at least under the second interpretation (I
> > don't have any useful devices IRQ < 16). This is with your pciback 0.5.

OK. Let me boot up that machine and see what /proc/interrupts look like. Maybe
the xen-pciback.hide=() throws a lot of things out of whack.
> > 
> > I see something like what you describe under HVM, although pciback is
> > not used in that case. xc_physdev_map_pirq is used but not with
> > the /sys/.../bdf node AFAICT.
> > 
> > More digging required I guess...
> 
> If I just pass through the EHCI device it doesn't work. However if I
> also pass-through the associated UHCI controller then I do see the
> usb-storage device, interrupts and all. The EHCI controller still
> doesn't work though. Note that with a PV guest passing-through the EHCI
> controller by itself does work.
> 
> The issue I'm seeing seems to have more to do with accessing the memory
> mapped BAR than IRQs though:

> 
>         ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>         PHYSDEVOP_map_pirq mapped gsi 46 to pirq 18
>         xen_allocate_pirq_gsi for gsi 46, pirq 18 "ioapic-level"
>         xen: --> irq=46, pirq=18
>         ehci_hcd 0000:00:07.0: PCI INT C -> GSI 46 (level, low) -> IRQ 46
>         ehci: remapped rsrc 0xf3021000 to c8064000

<scratch> If you hit the 'i' in the debug console is this 
BAR visible there? That is f3021?
>         ehci_hcd 0000:00:07.0: setting latency timer to 64
>         ehci_hcd 0000:00:07.0: EHCI Host Controller
>         ehci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 1
>         ehci_reset: handshake failed with -19. regs c80640ff
>         ehci_hcd 0000:00:07.0: Enabling legacy PCI PM
>         __startup_pirq: irq46 bound to evtchn 19
>         ehci_hcd 0000:00:07.0: irq 46, io mem 0xf3021000
>         ehci_reset: handshake failed with -19. regs c80640ff
>         ehci_run: ehci_reset failed with -19
>         ehci_hcd 0000:00:07.0: startup error -19
>         ehci_hcd 0000:00:07.0: USB bus 1 deregistered
>         ehci_hcd 0000:00:07.0: PCI INT C disabled
>         ehci_hcd 0000:00:07.0: init 0000:00:07.0 fail, -19
> 
> The -19 is -ENODEV from driver/usb/host/ehci-hcd.c:handshake() which is
> a readl with nothing to do with IRQs.

<nods>
> 
> Ian.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

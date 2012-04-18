Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2DRVIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:08:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26169 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2DRVIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:08:31 -0400
Date: Wed, 18 Apr 2012 17:03:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Zhang, Xiantao" <xiantao.zhang@intel.com>
Cc: Lin Ming <mlin@ss.pku.edu.cn>, "mingo@elte.hu" <mingo@elte.hu>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen/x86: Implement x86_apic_ops
Message-ID: <20120418210309.GD21970@phenom.dumpdata.com>
References: <20120328092358.GD22885@gmail.com>
 <1332956242-5352-1-git-send-email-konrad.wilk@oracle.com>
 <1332956242-5352-3-git-send-email-konrad.wilk@oracle.com>
 <CAF1ivSagwO9PLQwwbLmTZik8xpfDncY=aXdhugT5Rivuu14K9g@mail.gmail.com>
 <20120416154746.GC4654@phenom.dumpdata.com>
 <B6C2EB9186482D47BD0C5A9A483456440E05E7@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <B6C2EB9186482D47BD0C5A9A483456440E05E7@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F8F2D42.000C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +unsigned int xen_io_apic_read(unsigned apic, unsigned reg) {
> > > > +       if (reg == 0x1)
> > > > +               return 0x00170020;
> > > > +       else if (reg == 0x0)
> > > > +               return apic << 24;
> > >
> > > Why is fixed value returned?
> > >
> > > Can't we implement it with hypercall(PHYSDEVOP_apic_read)?
> > 
> > We sure can. But this was meant to fix the regression - so I figured we would
> > do that later on. But the more important question is - do we actually need to
> > do the hypercall? We aren't using the IOAPIC for anything - we don't program
> > the pins from dom0.
> 
>  Actually, dom0 doesn't programe ioapic pins directly as you said,  but the work is done by dom0 in the indirect way.  For dom0,  I added a hypercall PHYSDEVOP_setup_gsi before, and with this hypercall, we can get rid of programing IOAPIC pins from dom0 and hypervisor helps to do the ioapic programming, but we still need to get correct GSI information from hypervisor, otherwise, the hypercall may meet issues.  

The GSI information (I think of the polarity and trigger, and as well
which PCI devices pins correspond to what interrupt) is retrieved via the ACPI _PRT.

The IO-APIC isn't used at all - instead the code in arch/x86/pci/xen.c is utilized
which does the appropiate lookup and invokes the proper hypercall to bind an
PIRQ (GSI) to an event channel (and the event channel is then binded to the Linux
IRQ subsystem).

The hypercall - PHYSDEVOP_apic_read can be implemented here - and I am
more than open for folks to submit a patch for it - but it does not affect
how GSI/IO-APIC programming is done. This will just report proper IO-APIC
information instead of the fabricated one.

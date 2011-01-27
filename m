Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1A0Qb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:31:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53541 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1A0Qb5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 Jan 2011 11:31:57 -0500
Date: Thu, 27 Jan 2011 11:30:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: matthieu castet <castet.matthieu@free.fr>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kees Cook <kees.cook@canonical.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "sliakh.lkml@gmail.com" <sliakh.lkml@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiang@cs.ncsu.edu" <jiang@cs.ncsu.edu>,
        Stefan Bader <stefan.bader@canonical.com>, konrad@kernel.org
Subject: Was: [tip:x86/security] x86: Add NX protection for kernel data.
 Is: don't set RW on RO regions in .bss
Message-ID: <20110127163046.GA8339@dumpdata.com>
References: <1295537856.14780.54.camel@zakaz.uk.xensource.com>
 <20110120190531.GA9687@dumpdata.com>
 <4D3899AB.60207@free.fr>
 <20110120210436.GA1810@dumpdata.com>
 <20110120211939.GA32262@dumpdata.com>
 <20110120215556.GA29700@dumpdata.com>
 <4D39FDA2.2000305@free.fr>
 <20110122051134.GA6905@dumpdata.com>
 <4D3C3ADB.1020609@free.fr>
 <20110124153109.GA970@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124153109.GA970@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, what give you the attached patch.
> > 
> > I don't know if I should give the printk or not. 
> 
> I would say get rid of the printk. It does not really help the users. Here is an excerpt of
> 2.6.38-rc2 with this patch:
> 
>    7.247448] NX-protecting the kernel data: 2412k
> [    7.252489] RO page for 0xc15a0000 in bss/data.
> [    7.253052] RO page for 0xc15a1000 in bss/data.
> [    7.253052] RO page for 0xc15a3000 in bss/data.
> [    7.365104] mv used greatest stack depth: 6616 bytes left
> 
> So Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> (I tested on baremetal x86,x86_64 and Xen x86 and x86_64)

Matthieu,

I can send a patch for rc3 that would get rid of the "if within(.._sdata"
(since if we get rid of the printk it does not do anything) - but I
would much prefer if you did it since you are much familiar with
this patch and know the ramifications.

This being in the x86 generic code it should go through the tip
probably, I think?

P.S.
[I trimmed down the CC and moved some folks to the To field]
> > 
> > 
> > Matthieu
> 
> 
> > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > index 8b830ca..eec93c5 100644
> > --- a/arch/x86/mm/pageattr.c
> > +++ b/arch/x86/mm/pageattr.c
> > @@ -256,7 +256,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
> >  				   unsigned long pfn)
> >  {
> >  	pgprot_t forbidden = __pgprot(0);
> > -	pgprot_t required = __pgprot(0);
> >  
> >  	/*
> >  	 * The BIOS area between 640k and 1Mb needs to be executable for
> > @@ -283,11 +282,13 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
> >  		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
> >  		pgprot_val(forbidden) |= _PAGE_RW;
> >  	/*
> > -	 * .data and .bss should always be writable.
> > +	 * .data and .bss should always be writable, but xen won't like
> > +	 * if we make page table rw (that live in .data or .bss)
> >  	 */
> >  	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
> >  	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
> > -		pgprot_val(required) |= _PAGE_RW;
> > +		if ((pgprot_val(prot) & _PAGE_RW) == 0)
> > +			printk(KERN_INFO "RO page for 0x%lx in bss/data.\n", address);
> >  
> >  #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
> >  	/*
> > @@ -327,7 +328,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
> >  #endif
> >  
> >  	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
> > -	prot = __pgprot(pgprot_val(prot) | pgprot_val(required));
> >  
> >  	return prot;
> >  }

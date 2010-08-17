Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0HQQsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:48:33 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:25755 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab0HQQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:48:30 -0400
Subject: Re: [Patch] Skip cpu_calibrate for kernel running
	under	hypervisors.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C6A2C98.4060605@zytor.com>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
	 <4C69D02F.6090601@zytor.com>
	 <1282024311.20786.2.camel@ank32.eng.vmware.com>
	 <4C6A2C98.4060605@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 17 Aug 2010 09:48:30 -0700
Message-Id: <1282063710.4388.11.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi HPA,

On Mon, 2010-08-16 at 23:30 -0700, H. Peter Anvin wrote:
> On 08/16/2010 10:51 PM, Alok Kataria wrote:
> >>
> >> I'm somewhat reluctant to take this one, since it assumes all the
> >> hypervisors act the same.  This seems rather inherently wrong.  In fact,
> >> the whole statement is fishy as heck... instead of being dependent on
> >> AMD and so on, 
> > 
> > The check about being on AMD is something that was already there. 
> > 
> 
> I know it was... and calibrate_cpu() seems to be an AMD-specific
> function, but that's rather crappy.  I'm thinking that perhaps we should
> make it an x86_init function, then the AMD CPU detection can install it
> and the vmware hypervisor detection can uninstall it.

I am planning to add a calibrate_apic function ptr in x86_platform_ops,
for getting the APIC frequency too directly from the hypervisor. If you
want I can add this calibrate_cpu function ptr too or is the patch below
okay for now ? 

Thanks,
Alok

> 
> >> this should either be a function pointer or a CPU
> >> (mis)feature bit.
> > 
> > In any case, I agree that my previous patch did assume all hypervisors
> > to be same, which might be wrong. How about using the
> > X86_FEATURE_TSC_RELIABLE bit for this too ? i.e. Skip cpu_calibrate call
> > if TSC_RELIABLE bit is set. As of now that bit is set for vmware only. 
> > 
> > Something like the below.
> > 
> > Signed-off-by: Alok N Kataria <akataria@vmware.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > 
> > Index: linux-x86-tree.git/arch/x86/kernel/tsc.c
> > ===================================================================
> > --- linux-x86-tree.git.orig/arch/x86/kernel/tsc.c	2010-08-03 12:21:20.000000000 -0700
> > +++ linux-x86-tree.git/arch/x86/kernel/tsc.c	2010-08-16 21:59:32.000000000 -0700
> > @@ -927,7 +927,8 @@ void __init tsc_init(void)
> >  	}
> >  
> >  	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> > -			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> > +	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
> > +	    !(cpu_has(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE)))
> >  		cpu_khz = calibrate_cpu();
> >  
> >  	printk("Detected %lu.%03lu MHz processor.\n",
> > 
> 
> That seems like a much better approach.
> 
> 	-hpa
> 


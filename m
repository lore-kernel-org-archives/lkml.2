Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2CTUaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:30:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42889 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab2CTUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:30:12 -0400
Date: Tue, 20 Mar 2012 16:25:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120320202546.GA29554@phenom.dumpdata.com>
References: <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
 <20120319193842.GA8123@phenom.dumpdata.com>
 <20120320094048.GC20079@phenom.dumpdata.com>
 <1332267178.16101.66.camel@sbsiddha-desk.sc.intel.com>
 <20120320185841.GF29554@phenom.dumpdata.com>
 <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F68E8CB.009F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 01:05:19PM -0700, Suresh Siddha wrote:
> On Tue, 2012-03-20 at 14:58 -0400, Konrad Rzeszutek Wilk wrote:
> > Then this fixes the issue - thought if there are more checks in the future
> > it will have to be redone..:
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 988828b..b8e2794 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1859,6 +1859,7 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
> >  #endif	/* CONFIG_X86_64 */
> >  
> >  static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
> > +static unsigned char fake_ioapic_mapping[PAGE_SIZE] __page_aligned_bss;
> >  
> >  static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
> >  {
> > @@ -1899,7 +1900,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
> >  		 * We just don't map the IO APIC - all access is via
> >  		 * hypercalls.  Keep the address in the pte for reference.
> >  		 */
> > -		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
> > +		pte = pfn_pte(PFN_DOWN(__pa(fake_ioapic_mapping)), PAGE_KERNEL);
> >  		break;
> >  #endif
> >  
> > @@ -2064,6 +2065,7 @@ void __init xen_init_mmu_ops(void)
> >  	pv_mmu_ops = xen_mmu_ops;
> >  
> >  	memset(dummy_mapping, 0xff, PAGE_SIZE);
> > +	memset(fake_ioapic_mapping, 0xfd, PAGE_SIZE);
> 
> heh ;)
> 
> I was referring to setting up something little more valid. Like
> IO_APIC_reg_01 showing value of 0x00170020 etc. As the gsi computation
> actually refers to the number of redirection table entries supported by
> the IO-APIC.
> 
> Also does the dom0 see all the GSI's/io-apic's that the host sees or is
> it going to be just one io-apic? I was just wondering if the reg 01 need
> to be same as what the host sees?

It does not use the APIC mechanism at all. It only needs the GSI value
from the IOAPIC and LAPIC so that the ACPI can work. Then the ACPI _PRT values
are used to setup the GSI's (via hypercalls).

> 
> Anyways, instead of 0xfd, having sane fake register values will be a
> better start.

It could also at startup copy the original values and stick them in these copies.
That does mean using the memory allocator to allocate X copies for X IOAPICS. I
don't think the memory allocator is active at that stage since we using fixmaps.
Thoughts?

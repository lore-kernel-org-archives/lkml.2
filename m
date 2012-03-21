Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265Ab2CUARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:17:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49700 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2CUARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:17:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: suresh.b.siddha@intel.com, jwboyer@redhat.com, mingo@elte.hu,
        hpa@zytor.com, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Date: Tue, 20 Mar 2012 20:12:41 -0400
Message-Id: <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F691DFF.0019,ss=1,re=0.000,fgs=0
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

I was talking with Suresh on IRC and I realized that some of these patches
that did this were posted some time ago, so I dusted them off and redid them
just a tiny bit.

Ingo, please take a look - and if you are OK with them please put in them
the v3.4 queue - if you are not comfortable, then the above patch will have to
suffice as a work-around for the regression.

 arch/x86/include/asm/io_apic.h  |   31 +++++++++++++++++++++++++++++--
 arch/x86/include/asm/x86_init.h |    8 ++++++++
 arch/x86/kernel/apic/io_apic.c  |   10 ++++++----
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/x86_init.c      |    8 ++++++++
 arch/x86/xen/Makefile           |    2 +-
 arch/x86/xen/apic.c             |   17 +++++++++++++++++
 arch/x86/xen/enlighten.c        |    2 ++
 arch/x86/xen/xen-ops.h          |    4 ++++
 9 files changed, 76 insertions(+), 8 deletions(-)
Jeremy Fitzhardinge (1):
      x86: add io_apic_ops to allow interception

Konrad Rzeszutek Wilk (2):
      x86/apic_ops: Replace apic_ops with x86_apic_ops.
      xen/x86: Implement x86_apic_ops


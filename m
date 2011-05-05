Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1EEOB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:01:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35717 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1EEOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:01:54 -0400
Date: Thu, 5 May 2011 10:01:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Daniel Kiper <dkiper@net-space.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page
 table high"
Message-ID: <20110505140124.GD4386@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com>
 <20110503005527.GA6735@router-fw-old.local.net-space.pl>
 <20110503151206.GA8868@dumpdata.com>
 <20110503195141.GA15775@router-fw-old.local.net-space.pl>
 <20110504185903.GA29903@router-fw-old.local.net-space.pl>
 <alpine.DEB.2.00.1105051133570.10886@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105051133570.10886@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DC2ADC4.0019:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 01:55:22PM +0100, Stefano Stabellini wrote:
> On Wed, 4 May 2011, Daniel Kiper wrote:
> > On Tue, May 03, 2011 at 09:51:41PM +0200, Daniel Kiper wrote:
> > > On Tue, May 03, 2011 at 11:12:06AM -0400, Konrad Rzeszutek Wilk wrote:
> > > > On Tue, May 03, 2011 at 02:55:27AM +0200, Daniel Kiper wrote:
> > > > > On Mon, May 02, 2011 at 01:22:21PM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > [...]
> > 
> > > > > I think that (Stefano please confirm or not) this patch was prepared
> > > > > as workaround for similar issues. However, I do not like this patch
> > > > > because on systems with small amount of memory it leaves huge (to some
> > > > > extent) hole between max_low_pfn and 4G. Additionally, it affects
> > > > > memory hotplug a bit because it allocates memory starting from current
> > > > > max_mfn. It also breaks memory hotplug on i386 (maybe also others
> > > > > thinks, however, I could not confirm that). If it stay for some
> > > > > reason it should be amended in follwing way:
> > > > >
> > > > > #ifdef CONFIG_X86_32
> > > > >         xen_extra_mem_start = mem_end;
> > > > > #else
> > > > >         xen_extra_mem_start = max((1ULL << 32), mem_end);
> > > > > #endif
> > > > >
> > > > > Regarding comment for this patch it should be mentioned that without this
> > > > > patch e820_end_of_low_ram_pfn() is not broken. It is not called simply.
> > > > >
> > > > > Last but least. I found that memory sizes below and including exactly 1 GiB and
> > > > > exactly 2 GiB, 3 GiB (maybe higher, i.e. 4 GiB, 5 GiB, ...; I was not able to test
> > > > > them because I do not have sufficient memory) are magic. It means that if memory
> > > > > is set with those sizes everything is working good (without 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> > > > > and 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 applied). It means that domU
> > > > > should be tested with sizes which are not power of two nor multiple of that.
> > > >
> > > > Hmm, I thought I did test 1500M.
> > >
> > > It does not work on my machine (24bdb0b62cc82120924762ae6bc85afc8c3f2b26
> > > removed and 4b239f458c229de044d6905c2b0f9fe16ed9e01e applied).
> > 
> > It does not work on my machine (x86_64) with Linux Kernel Ver. 2.6.39-rc6 without
> > git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
> > e820 region at an addr lower than 4G). As I said ealier bug introduced by git
> > commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table
> > high) is probably hidden (repaird/workarounded ???) by git commit
> > 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
> > e820 region at an addr lower than 4G).
> > 
> > Konrad, Stefano could you confirm that ??? If it is true
> > how could I help you in removing this bug ???
> 
> The reason why "xen: do not create the extra e820 region at an addr
> lower than 4G" is needed is the following:
> 
> starting the extra memory region at an address lower than 4G is
> dangerous because if the extra memory region spans the 4G boundary then
> e820_end_of_ram_pfn will get confused and return 0x100000000, therefore
> init_memory_mapping will setup 1:1 mapping for 0-0x100000000, including
> the whole 3G-4G range.
> Of course this is wrong because among other things will cause the kernel
> to remap the IOAPIC MMIO registers that should go through the fixmap
> instead.
> I don't think "x86-64, mm: Put early page table high" is related to the
> bug that this commit is trying to solve.
> 
> Could you please explain in details what problems do this patch create?
> 
> In any case you are right about the fact that the change is not needed
> on X86_32 so if it has any bad side effects on X86_32 we can always do

Why not? Can't you boot a 32-bit Dom0 on those machines?

> the following, like you suggested:
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 90bac0a..721f576 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -227,7 +227,11 @@ char * __init xen_memory_setup(void)
>  
>  	memcpy(map_raw, map, sizeof(map));
>  	e820.nr_map = 0;
> +#ifdef CONFIG_X86_32
> +	xen_extra_mem_start = mem_end;
> +#else
>  	xen_extra_mem_start = max((1ULL << 32), mem_end);
> +#endif
>  	for (i = 0; i < memmap.nr_entries; i++) {
>  		unsigned long long end;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

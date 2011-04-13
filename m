Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab1DMKfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:35:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29447 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab1DMKfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:35:04 -0400
X-IronPort-AV: E=Sophos;i="4.64,203,1301875200"; 
   d="scan'208";a="5280878"
Date: Wed, 13 Apr 2011 11:35:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
In-Reply-To: <4DA48EA9.70109@kernel.org>
Message-ID: <alpine.DEB.2.00.1104131125080.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA48EA9.70109@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Yinghai Lu wrote:
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 6b833db..fec8680 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1275,6 +1275,20 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
> >   {
> >   }
> >
> > +static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
> > +{
> > +	/* reserve the range used */
> > +	memblock_x86_reserve_range(start, end, "PGTABLE");
> > +
> > +	/* set as RW the rest */
> > +	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
> > +			PFN_PHYS(pgt_buf_top));
> > +	while (end<  PFN_PHYS(pgt_buf_top)) {
> > +		make_lowmem_page_readwrite(__va(end));
> > +		end += PAGE_SIZE;
> > +	}
> > +}
> > +
> 
> it would be more cleaner to xen code if you make mark start/end to RO, and not make them all before as RO.

Yes, that would be ideal, but we cannot do that because we don't know
exactly where is pgt_buf_end before allocating the pagetable pages and
the pagetable pages need to be marked RO before being hooked into the
pagetable. This is why we mark the whole range RO and after the
pagetable allocation when we know for sure where is pgt_buf_end we
modify the range pgt_buf_end-pgt_buf_top to RW.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1ATPLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:11:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35464 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab1ATPLD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 20 Jan 2011 10:11:03 -0500
Date: Thu, 20 Jan 2011 10:10:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        xen-devel@lists.xensource.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: p2m: correctly initialize partial p2m leave
Message-ID: <20110120151032.GD5092@dumpdata.com>
References: <4D3848DF.9000906@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3848DF.9000906@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 03:38:23PM +0100, Stefan Bader wrote:
> There have been changes and code been moved around, so this is just a quick
> rebase of the change I tested on a 2.6.37 based kernel. The basic problem seem
> still valid, though.

Nice catch..
> 
> Initially I thought of adding a cc to stable into the s-o-b, but the patch needs
> to be adapted anyway (I can supply that version if the way I fixed the issue
> looks ok).
> 
> Regards,
> Stefan

> >From 1e9c9514caf0399c88ae9288e6db8e3d1c4b4be5 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Thu, 20 Jan 2011 11:37:43 +0100
> Subject: [PATCH] xen: p2m: correctly initialize partial p2m leave
> 
> After changing the p2m mapping to a tree by
> 
>   commit 58e05027b530ff081ecea68e38de8d59db8f87e0
>     xen: convert p2m to a 3 level tree
> 
> and trying to boot a DomU with 615MB of memory, the following crash was
> observed in the dump:
> 
> kernel direct mapping tables up to 26f00000 @ 1ec4000-1fff000
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c0107397>] xen_set_pte+0x27/0x60
> *pdpt = 0000000000000000 *pde = 0000000000000000
> 
> Adding further debug statements showed that when trying to set up
> pfn=0x26700 the returned mapping was invalid.
> 
> pfn=0x266ff calling set_pte(0xc1fe77f8, 0x6b3003)
> pfn=0x26700 calling set_pte(0xc1fe7800, 0x3)
> 
> Although the last_pfn obtained from the startup info is 0x26700, which
> should in turn not be hit, the additional 8MB which are added as extra
> memory normally seem to be ok. This lead to looking into the initial
> p2m tree construction, which uses the smaller value and assuming that
> there is other code handling the extra memory.
> 
> When the p2m tree is set up, the leaves are directly pointed to the
> array which the domain builder set up. But if the mapping is not on a
> boundary that fits into one p2m page, this will result in the last leaf
> being only partially valid. And as the invalid entries are not
> initialized in that case, things go badly wrong.
> 
> I am trying to fix that by checking whether the current leaf is a
> complete map and if not, allocate a completely new page and copy only
> the valid pointers there. This may not be the most efficient or elegant
> solution, but at least it seems to allow me booting DomUs with memory
> assignments all over the range.
> 
> BugLink: http://bugs.launchpad.net/bugs/686692
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  arch/x86/xen/p2m.c |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 8f2251d..c9307ec 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -237,7 +237,25 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  			p2m_top[topidx] = mid;
>  		}
>  
> -		p2m_top[topidx][mididx] = &mfn_list[pfn];
> +		/*
> +		 * As long as the mfn_list has enough entries to completely
> +		 * fill a p2m page, pointing into the array is ok. But if
> +		 * not the entries beyond the last pfn will be undefined.
> +		 * And guessing that the 'what-ever-there-is' does not take it
> +		 * too kindly when changing it to invalid markers, a new page
> +		 * is allocated, initialized and filled with the valid part.
> +		 */
> +		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
> +			unsigned long p2midx;
> +			unsigned long **p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +			p2m_init(p2m);
> +
> +			for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
> +				p2m[p2midx] = mfn_list[pfn + p2midx];
> +			}
> +			p2m_top[topidx][mididx] = p2m;
> +		} else
> +			p2m_top[topidx][mididx] = &mfn_list[pfn];
>  	}
>  
>  	m2p_override_init();
> -- 
> 1.7.0.4
> 


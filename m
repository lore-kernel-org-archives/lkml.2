Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab0FQSXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:23:33 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44619 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757002Ab0FQSXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:23:32 -0400
Date: Thu, 17 Jun 2010 13:24:53 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per_cpu_ptr_to_phys() failure on UV x86_64
Message-ID: <20100617182453.GA31478@sgi.com>
References: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com> <4C1A5679.8010907@kernel.org> <4C1A5CD4.3020802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1A5CD4.3020802@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jun 17, 2010 at 07:35:16PM +0200, Tejun Heo wrote:
> On 06/17/2010 07:08 PM, Tejun Heo wrote:
> > (scratching head...) So, that means it's given an address for which
> > !pcpu_addr_in_first_chunk() but outside of vmalloc area.  Strange.
> > I'll find out what's going on.
> 
> Does the following patch work?  The original patch assumed that @addr
> would be the address of the base cpu which isn't true.  I only compile
> tested the patch so it might be broken (sorry, I gotta go somewhere
> now) but this should be the right direction.

Yes, your patch works.  I tested it on a 32p UV system.

-Cliff
 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 46485e1..8956155 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -978,14 +978,23 @@ bool is_kernel_percpu_address(unsigned long addr)
>   */
>  phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  {
> -	if (pcpu_addr_in_first_chunk(addr)) {
> -		if ((unsigned long)addr < VMALLOC_START ||
> -		    (unsigned long)addr >= VMALLOC_END)
> -			return __pa(addr);
> -		else
> -			return page_to_phys(vmalloc_to_page(addr));
> -	} else
> -		return page_to_phys(pcpu_addr_to_page(addr));
> +	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		void *start = per_cpu_ptr(base, cpu);
> +
> +		if (addr >= start && addr < start + pcpu_unit_size) {
> +			/* in the first chunk */
> +			if ((unsigned long)addr < VMALLOC_START ||
> +			    (unsigned long)addr >= VMALLOC_END)
> +				return __pa(addr);
> +			else
> +				return page_to_phys(vmalloc_to_page(addr));
> +		}
> +	}
> +	/* in one of the other chunks */
> +	return page_to_phys(pcpu_addr_to_page(addr));
>  }
> 
>  static inline size_t pcpu_calc_fc_sizes(size_t static_size,
> 
> 
> -- 
> tejun

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824

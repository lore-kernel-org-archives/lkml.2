Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167Ab0FRM2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:28:42 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44693 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761148Ab0FRM2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:28:41 -0400
Date: Fri, 18 Jun 2010 07:30:02 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix first chunk match in per_cpu_ptr_to_phys()
Message-ID: <20100618123002.GA15931@sgi.com>
References: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com> <4C1A5679.8010907@kernel.org> <4C1A5CD4.3020802@kernel.org> <20100617182453.GA31478@sgi.com> <4C1B42C0.3090906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1B42C0.3090906@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Jun 18, 2010 at 11:56:16AM +0200, Tejun Heo wrote:
> per_cpu_ptr_to_phys() determines whether the passed in @addr belongs
> to the first_chunk or not by just matching the address against the
> address range of the base unit (unit0, used by cpu0).  When an adress
> from another cpu was passed in, it will always determine that the
> address doesn't belong to the first chunk even when it does.  This
> makes the function return a bogus physical address which may lead to
> crash.
> 
> This problem was discovered by Cliff Wickman while investigating a
> crash during kdump on a SGI UV system.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Cliff Wickman <cpw@sgi.com>
> ---
> Can you please verify this one?  I added a small optimization so that
> it doesn't suck too bad on large machines and it works fine here but
> it would be great to have your Tested-by:.

Yep.  Works fine on 32p UV.

Tested-by: Cliff Wickman <cpw@sgi.com>

> 
> Thanks.
> 
>  mm/percpu.c |   31 ++++++++++++++++++++++++++++---
>  1 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 46485e1..6470e77 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -229,8 +229,8 @@ static int __maybe_unused pcpu_page_idx(unsigned int cpu, int page_idx)
>  	return pcpu_unit_map[cpu] * pcpu_unit_pages + page_idx;
>  }
> 
> -static unsigned long __maybe_unused pcpu_chunk_addr(struct pcpu_chunk *chunk,
> -						unsigned int cpu, int page_idx)
> +static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
> +				     unsigned int cpu, int page_idx)
>  {
>  	return (unsigned long)chunk->base_addr + pcpu_unit_offsets[cpu] +
>  		(page_idx << PAGE_SHIFT);
> @@ -978,7 +978,32 @@ bool is_kernel_percpu_address(unsigned long addr)
>   */
>  phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  {
> -	if (pcpu_addr_in_first_chunk(addr)) {
> +	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
> +	bool in_first_chunk = false;
> +	unsigned long first_start, first_end;
> +	unsigned int cpu;
> +
> +	/*
> +	 * The following test on first_start/end isn't strictly
> +	 * necessary but will speed up lookups of addresses which
> +	 * aren't in the first chunk.
> +	 */
> +	first_start = pcpu_chunk_addr(pcpu_first_chunk, pcpu_first_unit_cpu, 0);
> +	first_end = pcpu_chunk_addr(pcpu_first_chunk, pcpu_last_unit_cpu,
> +				    pcpu_unit_pages);
> +	if ((unsigned long)addr >= first_start &&
> +	    (unsigned long)addr < first_end) {
> +		for_each_possible_cpu(cpu) {
> +			void *start = per_cpu_ptr(base, cpu);
> +
> +			if (addr >= start && addr < start + pcpu_unit_size) {
> +				in_first_chunk = true;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (in_first_chunk) {
>  		if ((unsigned long)addr < VMALLOC_START ||
>  		    (unsigned long)addr >= VMALLOC_END)
>  			return __pa(addr);
> -- 
> 1.6.4.2

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824

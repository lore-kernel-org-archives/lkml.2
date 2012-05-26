Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2EZAjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:39:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:36579 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2EZAjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:39:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157411055"
Subject: Re: [PATCH V2] mm, x86, pat: Improve scaling of
 pat_pagerange_is_ram()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: John Dykstra <jdykstra@cray.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 25 May 2012 17:37:39 -0700
In-Reply-To: <1337980366.1979.6.camel@redwood>
References: <1337027192.1604.9.camel@redwood>
	 <1337208407.1997.49.camel@sbsiddha-desk.sc.intel.com>
	 <1337980366.1979.6.camel@redwood>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337992659.7938.39.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 16:12 -0500, John Dykstra wrote:
> On Wed, 2012-05-16 at 15:46 -0700, Suresh Siddha wrote:
> > Instead of duplicating what kernel/resource.c:walk_system_ram_range() is
> > already doing, can we just provide a callback that can be used with
> > walk_system_ram_range() and see if the expected RAM pages is what the
> > callback also sees.
> 
> The resulting patch is a bit longer than V1.  
> ---
> 
> Function pat_pagerange_is_ram() scales poorly to large address ranges,
> because it probes the resource tree for each page.  On a 2.6 GHz
> Opteron, this function consumes 34 ms. for a 1 GB range.  It is called
> twice during untrack_pfn_vma(), slowing process cleanup and handicapping
> the OOM killer.
> 
> This replacement consumes less than 1ms. under the same conditions.
> 
> Signed-off-by: John Dykstra <jdykstra@cray.com> on behalf of Cray Inc. 
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>

Looks good to me.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
>  arch/x86/mm/pat.c |   58
> ++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index f6ff57b..246cce8 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -158,31 +158,45 @@ static unsigned long pat_x_mtrr_type(u64 start,
> u64 end, unsigned long req_type)
>  	return req_type;
>  }
>  
> +struct pagerange_is_ram_state {
> +	unsigned long		cur_pfn;
> +	int			ram;
> +	int			not_ram;
> +};
> +
> +static int pagerange_is_ram_callback(unsigned long initial_pfn,
> +				unsigned long total_nr_pages, void *arg)
> +{
> +	struct pagerange_is_ram_state *state = arg;
> +
> +	state->not_ram |= initial_pfn > state->cur_pfn;
> +	state->ram |= total_nr_pages > 0;
> +	state->cur_pfn = initial_pfn + total_nr_pages;
> +
> +	return state->ram && state->not_ram;
> +}
> +
>  static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
>  {
> -	int ram_page = 0, not_rampage = 0;
> -	unsigned long page_nr;
> +	int ret = 0;
> +	unsigned long start_pfn = start >> PAGE_SHIFT;
> +	unsigned long end_pfn = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	struct pagerange_is_ram_state state = {start_pfn, 0, 0};
>  
> -	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
> -	     ++page_nr) {
> -		/*
> -		 * For legacy reasons, physical address range in the legacy ISA
> -		 * region is tracked as non-RAM. This will allow users of
> -		 * /dev/mem to map portions of legacy ISA region, even when
> -		 * some of those portions are listed(or not even listed) with
> -		 * different e820 types(RAM/reserved/..)
> -		 */
> -		if (page_nr >= (ISA_END_ADDRESS >> PAGE_SHIFT) &&
> -		    page_is_ram(page_nr))
> -			ram_page = 1;
> -		else
> -			not_rampage = 1;
> -
> -		if (ram_page == not_rampage)
> -			return -1;
> -	}
> +	/*
> +	 * For legacy reasons, physical address range in the legacy ISA
> +	 * region is tracked as non-RAM. This will allow users of
> +	 * /dev/mem to map portions of legacy ISA region, even when
> +	 * some of those portions are listed(or not even listed) with
> +	 * different e820 types(RAM/reserved/..)
> +	 */
> +	if (start_pfn < ISA_END_ADDRESS >> PAGE_SHIFT)
> +		start_pfn = ISA_END_ADDRESS >> PAGE_SHIFT;
>  
> -	return ram_page;
> +	if (start_pfn < end_pfn)
> +		ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
> +				&state, pagerange_is_ram_callback);
> +	return (ret > 0) ? -1 : (state.ram ? 1 : 0);
>  }
>  
>  /*



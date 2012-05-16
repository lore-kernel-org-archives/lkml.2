Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734Ab2EPWsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:48:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:35785 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2EPWso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100961108"
Subject: Re: [PATCH] mm, x86, pat: Improve scaling of pat_pagerange_is_ram()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: John Dykstra <jdykstra@cray.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 15:46:47 -0700
In-Reply-To: <1337027192.1604.9.camel@redwood>
References: <1337027192.1604.9.camel@redwood>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337208407.1997.49.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 15:26 -0500, John Dykstra wrote:
> Function pat_pagerange_is_ram() scales poorly to large address ranges,
> because it probes the resource tree for each page.  On a 2.6 GHz
> Opteron, this function consumes 34 ms. for a 1 GB range.  It is called
> twice during untrack_pfn_vma(), slowing process cleanup and handicapping
> the OOM killer.
> 
> This replacement based on walk_system_ram_range() consumes less than 1
> ms. under the same conditions.
> 
> Signed-off-by: John Dykstra <jdykstra@cray.com> on behalf of Cray Inc. 
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/mm/pat.c      |   55 ++++++++++++++++++++++++++++++-----------------
>  include/linux/ioport.h |    2 +
>  kernel/resource.c      |    2 +-
>  3 files changed, 38 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index f6ff57b..c119afb 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -160,29 +160,44 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
>  
>  static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
>  {
> -	int ram_page = 0, not_rampage = 0;
> -	unsigned long page_nr;
> +	struct resource res;
> +	resource_size_t pg_end, after_ram;
> +	int ram = 0, not_ram = 0;
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
> +	res.start = start & PHYSICAL_PAGE_MASK;
>  
> -		if (ram_page == not_rampage)
> +	/*
> +	 * For legacy reasons, physical address range in the legacy ISA
> +	 * region is tracked as non-RAM. This will allow users of
> +	 * /dev/mem to map portions of legacy ISA region, even when
> +	 * some of those portions are listed(or not even listed) with
> +	 * different e820 types(RAM/reserved/..)
> +	 */
> +	if (res.start < ISA_END_ADDRESS) {
> +		not_ram = 1;
> +		res.start = ISA_END_ADDRESS;
> +	}
> +
> +	pg_end = (end + PAGE_SIZE - 1) & PHYSICAL_PAGE_MASK;
> +	res.end = pg_end;
> +	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> +	after_ram = res.start;
> +	while ((res.start < res.end) &&
> +		(find_next_system_ram(&res, "System RAM") >= 0)) {
> +		if (res.start > after_ram)
> +			not_ram = 1;
> +		if (res.end > res.start)
> +			ram = 1;
> +
> +		if (ram && not_ram)
>  			return -1;
> +
> +		after_ram = res.end + 1;
> +		res.start = res.end + 1;
> +		res.end = pg_end;
>  	}

Instead of duplicating what kernel/resource.c:walk_system_ram_range() is
already doing, can we just provide a callback that can be used with
walk_system_ram_range() and see if the expected RAM pages is what the
callback also sees.

That will greatly simplify the patch and avoid code duplication.

thanks,
suresh


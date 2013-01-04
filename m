Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3ADPBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:01:45 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62167 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab3ADPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:01:42 -0500
Date: Fri, 4 Jan 2013 10:01:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, yinghai@kernel.org,
        liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: memblock: optimize memblock_find_in_range_node()
 to minimize the search work
Message-ID: <20130104150139.GB15633@mtj.dyndns.org>
References: <1357291493-25773-1-git-send-email-linfeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357291493-25773-1-git-send-email-linfeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 05:24:53PM +0800, Lin Feng wrote:
> The memblock array is in ascending order and we traverse the memblock array in
> reverse order so we can add some simple check to reduce the search work.
> 
> Tejun fix a underflow bug in 5d53cb27d8, but I think we could break there for
> the same reason.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>  mm/memblock.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 6259055..a710557 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -111,11 +111,18 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>  	end = max(start, end);
>  
>  	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
> +		/*
> +		 * exclude the regions out of the candidate range, since it's
> +		 * likely to find a suitable range, we ignore the worst case.
> +		 */
> +		if (this_start >= end)
> +			continue;
> +
>  		this_start = clamp(this_start, start, end);
>  		this_end = clamp(this_end, start, end);
>  
>  		if (this_end < size)
> -			continue;
> +			break;

I don't know.  This only saves looping when memblocks are below the
requested size, right?  I don't think it would matter in any way and
would prefer to keep the logic as simple as possible.

Thanks.

-- 
tejun

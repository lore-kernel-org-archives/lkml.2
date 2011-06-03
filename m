Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1FCMH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:07:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58675 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1FCMHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:07:55 -0400
Date: Fri, 3 Jun 2011 07:07:52 -0500
From: Russ Anderson <rja@sgi.com>
To: Rafael Aquini <aquini@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, rja@americas.sgi.com
Subject: Re: [PATCH] mm: fix negative commitlimit when gigantic hugepages are allocated
Message-ID: <20110603120751.GA24840@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20110518153445.GA18127@sgi.com> <BANLkTinbHnrf2isuLzUFZN8ypaT476G1zw@mail.gmail.com> <20110519045630.GA22533@sgi.com> <BANLkTinyYP-je9Nf8X-xWEdpgvn8a631Mw@mail.gmail.com> <20110519221101.GC19648@sgi.com> <20110520130411.d1e0baef.akpm@linux-foundation.org> <20110520223032.GA15192@x61.tchesoft.com> <20110526210751.GA14819@optiplex.tchesoft.com> <20110602040821.GA7934@sgi.com> <20110603025555.GA10530@optiplex.tchesoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603025555.GA10530@optiplex.tchesoft.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Russ Anderson <rja@sgi.com>

On Thu, Jun 02, 2011 at 11:55:57PM -0300, Rafael Aquini wrote:
> When 1GB hugepages are allocated on a system, free(1) reports
> less available memory than what really is installed in the box.
> Also, if the total size of hugepages allocated on a system is
> over half of the total memory size, CommitLimit becomes
> a negative number.
> 
> The problem is that gigantic hugepages (order > MAX_ORDER)
> can only be allocated at boot with bootmem, thus its frames
> are not accounted to 'totalram_pages'. However,  they are
> accounted to hugetlb_total_pages()
> 
> What happens to turn CommitLimit into a negative number
> is this calculation, in fs/proc/meminfo.c:
> 
>         allowed = ((totalram_pages - hugetlb_total_pages())
>                 * sysctl_overcommit_ratio / 100) + total_swap_pages;
> 
> A similar calculation occurs in __vm_enough_memory() in mm/mmap.c.
> 
> Also, every vm statistic which depends on 'totalram_pages' will render
> confusing values, as if system were 'missing' some part of its memory.
> 
> Reported-by: Russ Anderson <rja@sgi.com>
> Signed-off-by: Rafael Aquini <aquini@linux.com>
> ---
>  mm/hugetlb.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f33bb31..c67dd0f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1111,6 +1111,14 @@ static void __init gather_bootmem_prealloc(void)
>  		WARN_ON(page_count(page) != 1);
>  		prep_compound_huge_page(page, h->order);
>  		prep_new_huge_page(h, page, page_to_nid(page));
> +
> +		/* if we had gigantic hugepages allocated at boot time,
> +		 * we need to reinstate the 'stolen' pages to totalram_pages,
> +		 * in order to fix confusing memory reports from free(1)
> +		 * and another side-effects, like CommitLimit going negative.
> +		 */
> +		if (h->order > (MAX_ORDER - 1))
> +			totalram_pages += 1 << h->order;
>  	}
>  }
>  
> -- 
> 1.7.4.4

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

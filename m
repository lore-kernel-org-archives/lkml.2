Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1BJLU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:20:59 -0500
Received: from gir.skynet.ie ([193.1.99.77]:32837 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1BJLU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:20:58 -0500
Date: Thu, 10 Feb 2011 11:20:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/5] have smaps show transparent huge pages
Message-ID: <20110210112032.GG17873@csn.ul.ie>
References: <20110209195406.B9F23C9F@kernel> <20110209195413.6D3CB37F@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110209195413.6D3CB37F@kernel>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:54:13AM -0800, Dave Hansen wrote:
> 
> Now that the mere act of _looking_ at /proc/$pid/smaps will not
> destroy transparent huge pages, tell how much of the VMA is
> actually mapped with them.
> 
> This way, we can make sure that we're getting THPs where we
> expect to see them.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Acked-by: David Rientjes <rientjes@google.com>
> ---
> 
>  linux-2.6.git-dave/fs/proc/task_mmu.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff -puN fs/proc/task_mmu.c~teach-smaps-thp fs/proc/task_mmu.c
> --- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps-thp	2011-02-09 11:41:44.423556779 -0800
> +++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-02-09 11:41:52.611550670 -0800
> @@ -331,6 +331,7 @@ struct mem_size_stats {
>  	unsigned long private_dirty;
>  	unsigned long referenced;
>  	unsigned long anonymous;
> +	unsigned long anonymous_thp;
>  	unsigned long swap;
>  	u64 pss;
>  };
> @@ -394,6 +395,7 @@ static int smaps_pte_range(pmd_t *pmd, u
>  			spin_lock(&walk->mm->page_table_lock);
>  		} else {
>  			smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> +			mss->anonymous_thp += HPAGE_SIZE;

I should have thought of this for the previous patch but should this be
HPAGE_PMD_SIZE instead of HPAGE_SIZE? Right now, they are the same value
but they are not the same thing.

>  			return 0;
>  		}
>  	}
> @@ -435,6 +437,7 @@ static int show_smap(struct seq_file *m,
>  		   "Private_Dirty:  %8lu kB\n"
>  		   "Referenced:     %8lu kB\n"
>  		   "Anonymous:      %8lu kB\n"
> +		   "AnonHugePages:  %8lu kB\n"
>  		   "Swap:           %8lu kB\n"
>  		   "KernelPageSize: %8lu kB\n"
>  		   "MMUPageSize:    %8lu kB\n"
> @@ -448,6 +451,7 @@ static int show_smap(struct seq_file *m,
>  		   mss.private_dirty >> 10,
>  		   mss.referenced >> 10,
>  		   mss.anonymous >> 10,
> +		   mss.anonymous_thp >> 10,
>  		   mss.swap >> 10,
>  		   vma_kernel_pagesize(vma) >> 10,
>  		   vma_mmu_pagesize(vma) >> 10,
> _
> 

-- 
Mel Gorman
SUSE Labs

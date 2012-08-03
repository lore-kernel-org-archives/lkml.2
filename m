Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2HCNcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:32:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2HCNci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:32:38 -0400
Date: Fri, 3 Aug 2012 15:32:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] hugetlb: correct page offset index for sharing pmd
Message-ID: <20120803133235.GA8434@dhcp22.suse.cz>
References: <CAJd=RBB=jKD+9JcuBmBGC8R8pAQ-QoWHexMNMsXpb9zV548h5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBB=jKD+9JcuBmBGC8R8pAQ-QoWHexMNMsXpb9zV548h5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 03-08-12 20:56:45, Hillf Danton wrote:
> The computation of page offset index is open coded, and incorrect, to
> be used in scanning prio tree, as huge page offset is required, and is
> fixed with the well defined routine.

I guess that nobody reported this because if someone really wants to
share he will use aligned address for mmap/shmat and so the index is 0.
Anyway it is worth fixing. Thanks for pointing out!

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/arch/x86/mm/hugetlbpage.c	Fri Aug  3 20:34:58 2012
> +++ b/arch/x86/mm/hugetlbpage.c	Fri Aug  3 20:40:16 2012
> @@ -72,12 +72,15 @@ static void huge_pmd_share(struct mm_str
>  	if (!vma_shareable(vma, addr))
>  		return;
> 
> +	idx = linear_page_index(vma, addr);
> +

You can use linear_hugepage_index directly and remove the idx
initialization as well.

>  	mutex_lock(&mapping->i_mmap_mutex);
>  	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
>  		if (svma == vma)
>  			continue;
> 
> -		saddr = page_table_shareable(svma, vma, addr, idx);
> +		saddr = page_table_shareable(svma, vma, addr,
> +						idx * (PMD_SIZE/PAGE_SIZE));

Why not just fixing page_table_shareable as well rather than playing
tricks like this?

>  		if (saddr) {
>  			spte = huge_pte_offset(svma->vm_mm, saddr);
>  			if (spte) {
> --

-- 
Michal Hocko
SUSE Labs

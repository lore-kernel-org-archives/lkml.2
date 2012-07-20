Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2GTNxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:53:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2GTNxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:53:34 -0400
Date: Fri, 20 Jul 2012 15:53:29 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andi.kleen" <andi.kleen@intel.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cgroup: Fix memory accounting scalability in
 shrink_page_list
Message-ID: <20120720135329.GA12440@tiehlicka.suse.cz>
References: <1342740866.13492.50.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342740866.13492.50.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-07-12 16:34:26, Tim Chen wrote:
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33dc256..aac5672 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -779,6 +779,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  
>  	cond_resched();
>  
> +	mem_cgroup_uncharge_start();
>  	while (!list_empty(page_list)) {
>  		enum page_references references;
>  		struct address_space *mapping;

Is this safe? We have a scheduling point few lines below. What prevents
from task move while we are in the middle of the batch?

> @@ -1026,6 +1027,7 @@ keep_lumpy:
>  
>  	list_splice(&ret_pages, page_list);
>  	count_vm_events(PGACTIVATE, pgactivate);
> +	mem_cgroup_uncharge_end();
>  	*ret_nr_dirty += nr_dirty;
>  	*ret_nr_writeback += nr_writeback;
>  	return nr_reclaimed;
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

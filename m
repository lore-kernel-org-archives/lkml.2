Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1KRQfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:35:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab1KRQfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:35:24 -0500
Date: Fri, 18 Nov 2011 17:35:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Message-ID: <20111118163521.GD23223@tiehlicka.suse.cz>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-11-11 10:33:08, KAMEZAWA Hiroyuki wrote:
> 
> I'll send this again when mm is shipped.
> I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> it's very slow. This fixes it. Any comments are welcome.
> 
> ==
> Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
> 
> at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> and modify page_cgroup and LRU accounting jobs and called
> HPAGE_PMD_SIZE - 1 times.
> 
> But thinking again,
>   - compound_lock() is held at move_accout...then, it's not necessary
>     to take move_lock_page_cgroup().
>   - LRU is locked and all tail pages will go into the same LRU as
>     head is now on.
>   - page_cgroup is contiguous in huge page range.
> 
> This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
> hugepage and reduce costs for spliting.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Yes, looks good. Andrew already took the patch, but just in case
Reviewed-by: Michal Hocko <mhocko@suse.cz>

Just one really minor comment bellow
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6aff93c..99101f1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2523,38 +2523,38 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>  /*
>   * Because tail pages are not marked as "used", set it. We're under
>   * zone->lru_lock, 'splitting on pmd' and compund_lock.

typo that could be fixed to make grep happier

> + * charge/uncharge will be never happen and move_account() is done under
> + * compound_lock(), so we don't have to take care of races.
>   */
> -void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
> +void mem_cgroup_split_huge_fixup(struct page *head)

Thanks!
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2CZPXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:23:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2CZPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:23:16 -0400
Date: Mon, 26 Mar 2012 17:23:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v6 6/7] mm/memcg: kill mem_cgroup_lru_del()
Message-ID: <20120326152315.GC22754@tiehlicka.suse.cz>
References: <20120322214944.27814.42039.stgit@zurg>
 <20120322215639.27814.4996.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322215639.27814.4996.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-03-12 01:56:39, Konstantin Khlebnikov wrote:
> This patch kills mem_cgroup_lru_del(), we can use mem_cgroup_lru_del_list()
> instead. On 0-order isolation we already have right lru list id.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Hugh Dickins <hughd@google.com>

Yes, looks good
Acked-by: Michal Hocko <mhocko@suse.cz>

Just a small nit..
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5f6ed98..9de66be 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[...]
> @@ -1205,8 +1205,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  
>  			if (__isolate_lru_page(cursor_page, mode) == 0) {
>  				unsigned int isolated_pages;
> +				enum lru_list cursor_lru;
>  
> -				mem_cgroup_lru_del(cursor_page);
> +				cursor_lru = page_lru(cursor_page);
> +				mem_cgroup_lru_del_list(cursor_page,
> +							cursor_lru);

Why not mem_cgroup_lru_del_list(cursor_page,
				page_lru(cursor_page));
The patch would be smaller and it doesn't make checkpatch unhappy as well.

>  				list_move(&cursor_page->lru, dst);
>  				isolated_pages = hpage_nr_pages(cursor_page);
>  				nr_taken += isolated_pages;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

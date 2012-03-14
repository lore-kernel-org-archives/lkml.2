Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493Ab2CNKCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:02:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760435Ab2CNKCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:02:43 -0400
Date: Wed, 14 Mar 2012 11:02:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] page_cgroup: fix horrid swap accounting regression
Message-ID: <20120314100240.GB4434@tiehlicka.suse.cz>
References: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-03-12 20:52:55, Hugh Dickins wrote:
> Why is memcg's swap accounting so broken?  Insane counts, wrong ownership,
> unfreeable structures, which later get freed and then accessed after free.
> 
> Turns out to be a tiny a little 3.3-rc1 regression in 9fb4b7cc0724
> "page_cgroup: add helper function to get swap_cgroup": the helper
> function (actually named lookup_swap_cgroup()) returns an address
> using void* arithmetic, but the structure in question is a short.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Thanks, this one looks really nasty.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
> 
>  mm/page_cgroup.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- 3.3-rc6/mm/page_cgroup.c	2012-01-20 08:42:35.320020840 -0800
> +++ linux/mm/page_cgroup.c	2012-03-05 19:51:13.535372098 -0800
> @@ -379,13 +379,15 @@ static struct swap_cgroup *lookup_swap_c
>  	pgoff_t offset = swp_offset(ent);
>  	struct swap_cgroup_ctrl *ctrl;
>  	struct page *mappage;
> +	struct swap_cgroup *sc;
>  
>  	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
>  	if (ctrlp)
>  		*ctrlp = ctrl;
>  
>  	mappage = ctrl->map[offset / SC_PER_PAGE];
> -	return page_address(mappage) + offset % SC_PER_PAGE;
> +	sc = page_address(mappage);
> +	return sc + offset % SC_PER_PAGE;
>  }
>  
>  /**

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

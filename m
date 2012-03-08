Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2CHGBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:01:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53083 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2CHGBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:01:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Mar 2012 15:00:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] page_cgroup: fix horrid swap accounting regression
Message-Id: <20120308150002.c900b38c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
References: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012 20:52:55 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Why is memcg's swap accounting so broken?  Insane counts, wrong ownership,
> unfreeable structures, which later get freed and then accessed after free.
> 
> Turns out to be a tiny a little 3.3-rc1 regression in 9fb4b7cc0724
> "page_cgroup: add helper function to get swap_cgroup": the helper
> function (actually named lookup_swap_cgroup()) returns an address
> using void* arithmetic, but the structure in question is a short.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Thank you for testing/fixes.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


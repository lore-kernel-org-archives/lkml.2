Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1HAOhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:37:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HAOhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:37:47 -0400
Date: Mon, 1 Aug 2011 16:37:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v4 3/5] memcg : stop scanning if enough
Message-ID: <20110801143745.GF25251@tiehlicka.suse.cz>
References: <20110727144438.a9fdfd5b.kamezawa.hiroyu@jp.fujitsu.com>
 <20110727144900.503a0afe.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727144900.503a0afe.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-07-11 14:49:00, KAMEZAWA Hiroyuki wrote:
> memcg :avoid node fallback scan if possible.
> 
> Now, try_to_free_pages() scans all zonelist because the page allocator
> should visit all zonelists...but that behavior is harmful for memcg.
> Memcg just scans memory because it hits limit...no memory shortage
> in pased zonelist.
> 
> For example, with following unbalanced nodes
> 
>      Node 0    Node 1
> File 1G        0
> Anon 200M      200M
> 
> memcg will cause swap-out from Node1 at every vmscan.
> 
> Another example, assume 1024 nodes system.
> With 1024 node system, memcg will visit 1024 nodes
> pages per vmscan... This is overkilling. 
> 
> This is why memcg's victim node selection logic doesn't work
> as expected.

Previous patch adds nodemask filled by
mem_cgroup_select_victim_node. Shouldn't we rather limit that nodemask
to a victim node?

Or am I missing something?

The patch as is doesn't look nice it makes shrink_zones even more
memcg-hacky:
	for_each_zone_zonelist_nodemask
		if (scanning_global_lru(sc))
			/.../

		shrink_zone(priority, zone, sc);

		if (!scanning_global_lru(sc))
			/.../

> 
> This patch is a help for stopping vmscan when we scanned enough.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/vmscan.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: mmotm-0710/mm/vmscan.c
> ===================================================================
> --- mmotm-0710.orig/mm/vmscan.c
> +++ mmotm-0710/mm/vmscan.c
> @@ -2058,6 +2058,16 @@ static void shrink_zones(int priority, s
>  		}
>  
>  		shrink_zone(priority, zone, sc);
> +		if (!scanning_global_lru(sc)) {
> +			/*
> +			 * When we do scan for memcg's limit, it's bad to do
> +			 * fallback into more node/zones because there is no
> +			 * memory shortage. We quit as much as possible when
> +			 * we reache target.
> +			 */
> +			if (sc->nr_to_reclaim <= sc->nr_reclaimed)
> +				break;
> +		}
>  	}
>  }
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

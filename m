Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1HJOOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:14:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1HJOO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:14:29 -0400
Date: Wed, 10 Aug 2011 16:14:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v5 2/6]  memcg: stop vmscan when enough done.
Message-ID: <20110810141425.GC15007@tiehlicka.suse.cz>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
 <20110809190933.d965888b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809190933.d965888b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-08-11 19:09:33, KAMEZAWA Hiroyuki wrote:
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
> 
> This patch is a help for stopping vmscan when we scanned enough.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

OK, I see the point. At first I was afraid that we would make a bigger
pressure on the node which triggered the reclaim but as we are selecting
t dynamically (mem_cgroup_select_victim_node) - round robin at the
moment - it should be fair in the end. More targeted node selection
should be even more efficient.

I still have a concern about resize_limit code path, though. It uses
memcg direct reclaim to get under the new limit (assuming it is lower
than the current one). 
Currently we might reclaim nr_nodes * SWAP_CLUSTER_MAX while
after your change we have it at SWAP_CLUSTER_MAX. This means that
mem_cgroup_resize_mem_limit might fail sooner on large NUMA machines
(currently it is doing 5 rounds of reclaim before it gives up). I do not
consider this to be blocker but maybe we should enhance
mem_cgroup_hierarchical_reclaim with a nr_pages argument to tell it how
much we want to reclaim (min(SWAP_CLUSTER_MAX, nr_pages)).
What do you think?

> ---
>  mm/vmscan.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: mmotm-Aug3/mm/vmscan.c
> ===================================================================
> --- mmotm-Aug3.orig/mm/vmscan.c
> +++ mmotm-Aug3/mm/vmscan.c
> @@ -2124,6 +2124,16 @@ static void shrink_zones(int priority, s
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

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

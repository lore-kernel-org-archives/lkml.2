Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1GGXxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:53:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53440 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1GGXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:53:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 8 Jul 2011 08:46:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH][Cleanup] memcg: consolidates memory cgroup lru stat
 functions
Message-Id: <20110708084629.73c7e543.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110707142922.c9657ec4.akpm@linux-foundation.org>
References: <20110707155217.909c429a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110707142922.c9657ec4.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 14:29:22 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 7 Jul 2011 15:52:17 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > In mm/memcontrol.c, there are many lru stat functions as..
> > 
> > mem_cgroup_zone_nr_lru_pages
> > mem_cgroup_node_nr_file_lru_pages
> > mem_cgroup_nr_file_lru_pages
> > mem_cgroup_node_nr_anon_lru_pages
> > mem_cgroup_nr_anon_lru_pages
> > mem_cgroup_node_nr_unevictable_lru_pages
> > mem_cgroup_nr_unevictable_lru_pages
> > mem_cgroup_node_nr_lru_pages
> > mem_cgroup_nr_lru_pages
> > mem_cgroup_get_local_zonestat
> > 
> > Some of them are under #ifdef MAX_NUMNODES >1 and others are not.
> > This seems bad. This patch consolidates all functions into
> > 
> > mem_cgroup_zone_nr_lru_pages()
> > mem_cgroup_node_nr_lru_pages()
> > mem_cgroup_nr_lru_pages()
> > 
> > For these functions, "which LRU?" information is passed by a mask.
> > 
> > example)
> > mem_cgroup_nr_lru_pages(mem, BIT(LRU_ACTIVE_ANON))
> > 
> > And I added some macro as ALL_LRU, ALL_LRU_FILE, ALL_LRU_ANON.
> > example)
> > mem_cgroup_nr_lru_pages(mem, ALL_LRU)
> > 
> > BTW, considering layout of NUMA memory placement of counters, this patch seems
> > to be better. 
> > 
> > Now, when we gather all LRU information, we scan in following orer
> >     for_each_lru -> for_each_node -> for_each_zone.
> > 
> > This means we'll touch cache lines in different node in turn.
> > 
> > After patch, we'll scan 
> >     for_each_node -> for_each_zone -> for_each_lru(mask)
> > 
> > Then, we'll gather information in the same cacheline at once.
> 
> mm/vmscan.c: In function 'zone_nr_lru_pages':
> mm/vmscan.c:175: warning: passing argument 2 of 'mem_cgroup_zone_nr_lru_pages' makes pointer from integer without a cast
> include/linux/memcontrol.h:307: note: expected 'struct zone *' but argument is of type 'int'
> mm/vmscan.c:175: error: too many arguments to function 'mem_cgroup_zone_nr_lru_pages'
> 

Hmm...quilt reflesh miss, sorry.

> --- a/include/linux/memcontrol.h~memcg-consolidates-memory-cgroup-lru-stat-functions-fix
> +++ a/include/linux/memcontrol.h
> @@ -304,8 +304,8 @@ mem_cgroup_inactive_file_is_low(struct m
>  }
>  
>  static inline unsigned long
> -mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, struct zone *zone,
> -			     enum lru_list lru)
> +mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
> +				unsigned int lru_mask)
>  {
>  	return 0;
>  }
> 
> > +unsigned long
> > +mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *mem, int nid, int zid,
> > +			unsigned int lru_mask)
> 
> The memcg code sometimes uses "struct mem_cgroup *mem" and sometimes
> uses "struct mem_cgroup *memcg".  That's irritating.  I think "memcg"
> is better.
> 

Sure. I always use "mem" but otheres not ;(
Ok, I'll use memcg.

Thanks,
-Kame 

